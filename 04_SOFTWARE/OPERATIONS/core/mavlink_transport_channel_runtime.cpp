#include "mavlink_transport_channel_runtime.hpp"

namespace bluesky::operations {

MavlinkTransportChannelRuntime::MavlinkTransportChannelRuntime(
    std::int64_t heartbeat_timeout_ms)
    : heartbeat_timeout_ms_(heartbeat_timeout_ms),
      session_runtime_(heartbeat_timeout_ms) {}

bool MavlinkTransportChannelRuntime::registerChannel(
    const MavlinkTransportChannelConfig& config) {
    if (config.channel_id.empty() || config.session_id.empty() ||
        config.vehicle_id.empty() || config.source_id.empty() ||
        config.system_id == 0 || config.component_id == 0 ||
        channels_.find(config.channel_id) != channels_.end()) {
        return false;
    }

    ChannelState state;
    state.snapshot.config = config;
    state.snapshot.state = MavlinkTransportChannelState::Offline;
    channels_.emplace(config.channel_id, std::move(state));
    return true;
}

bool MavlinkTransportChannelRuntime::connect(const std::string& channel_id) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return false;

    auto& channel = it->second;
    if (channel.snapshot.state == MavlinkTransportChannelState::Connected) {
        return true;
    }

    channel.snapshot.state = MavlinkTransportChannelState::Connecting;
    channel.snapshot.state = MavlinkTransportChannelState::Connected;
    return true;
}

bool MavlinkTransportChannelRuntime::disconnect(
    const std::string& channel_id) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return false;

    it->second.snapshot.state = MavlinkTransportChannelState::Offline;
    it->second.rx_queue.clear();
    it->second.tx_queue.clear();
    return true;
}

bool MavlinkTransportChannelRuntime::fail(const std::string& channel_id) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return false;

    auto& channel = it->second;
    channel.snapshot.state = MavlinkTransportChannelState::Lost;
    ++channel.snapshot.stats.link_failures;
    return true;
}

bool MavlinkTransportChannelRuntime::reconnect(
    const std::string& channel_id) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return false;

    auto& channel = it->second;
    channel.snapshot.state = MavlinkTransportChannelState::Recovering;
    session_runtime_.reconnect(
        channel.snapshot.config.session_id,
        channel.snapshot.config.vehicle_id,
        channel.snapshot.config.source_id,
        channel.snapshot.config.system_id,
        channel.snapshot.config.component_id);
    ++channel.snapshot.stats.reconnects;
    channel.snapshot.state = MavlinkTransportChannelState::Connected;
    return true;
}

bool MavlinkTransportChannelRuntime::send(
    const std::string& channel_id,
    std::int64_t timestamp_ms,
    const std::vector<std::uint8_t>& frame) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return false;

    auto& channel = it->second;
    if (channel.snapshot.state != MavlinkTransportChannelState::Connected &&
        channel.snapshot.state != MavlinkTransportChannelState::Degraded) {
        ++channel.snapshot.stats.transmit_failures;
        return false;
    }

    channel.tx_queue.push_back(frame);
    ++channel.snapshot.stats.transmitted_frames;
    channel.snapshot.stats.last_transmit_timestamp_ms = timestamp_ms;
    return true;
}

bool MavlinkTransportChannelRuntime::injectReceive(
    const std::string& channel_id,
    std::int64_t timestamp_ms,
    const std::vector<std::uint8_t>& frame) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return false;

    auto& channel = it->second;
    if (channel.snapshot.state != MavlinkTransportChannelState::Connected &&
        channel.snapshot.state != MavlinkTransportChannelState::Degraded) {
        ++channel.snapshot.stats.rejected_frames;
        return false;
    }

    ++channel.snapshot.stats.received_frames;
    channel.snapshot.stats.last_receive_timestamp_ms = timestamp_ms;
    channel.rx_queue.push_back(frame);
    return true;
}

std::optional<std::vector<std::uint8_t>>
MavlinkTransportChannelRuntime::receive(const std::string& channel_id) {
    auto it = channels_.find(channel_id);
    if (it == channels_.end()) return std::nullopt;

    auto& channel = it->second;
    if (channel.rx_queue.empty()) return std::nullopt;

    const auto frame = channel.rx_queue.front();
    channel.rx_queue.erase(channel.rx_queue.begin());

    const auto result = session_runtime_.ingestRawFrame(
        channel.snapshot.config.session_id,
        channel.snapshot.config.dialect,
        channel.snapshot.config.vehicle_id,
        channel.snapshot.config.source_id,
        channel.snapshot.stats.last_receive_timestamp_ms,
        frame);

    if (result.accepted) {
        ++channel.snapshot.stats.accepted_frames;
        if (result.snapshot.link_state == MavlinkLinkState::Degraded) {
            channel.snapshot.state = MavlinkTransportChannelState::Degraded;
        } else if (result.snapshot.link_state == MavlinkLinkState::Healthy) {
            channel.snapshot.state = MavlinkTransportChannelState::Connected;
        }
    } else {
        ++channel.snapshot.stats.rejected_frames;
    }

    return frame;
}

MavlinkSessionSnapshot MavlinkTransportChannelRuntime::tickSession(
    const std::string& session_id, std::int64_t now_ms) {
    const auto snapshot = session_runtime_.tick(session_id, now_ms);

    for (auto& [_, channel] : channels_) {
        if (channel.snapshot.config.session_id != session_id) continue;
        if (snapshot.link_state == MavlinkLinkState::Lost) {
            channel.snapshot.state = MavlinkTransportChannelState::Lost;
        } else if (snapshot.link_state == MavlinkLinkState::Degraded) {
            channel.snapshot.state = MavlinkTransportChannelState::Degraded;
        } else if (snapshot.link_state == MavlinkLinkState::Healthy) {
            channel.snapshot.state = MavlinkTransportChannelState::Connected;
        }
    }

    return snapshot;
}

std::optional<MavlinkTransportChannelSnapshot>
MavlinkTransportChannelRuntime::snapshot(
    const std::string& channel_id) const {
    const auto it = channels_.find(channel_id);
    if (it == channels_.end()) return std::nullopt;

    auto result = it->second.snapshot;
    result.session = session_runtime_.snapshot(
        result.config.session_id);
    return result;
}

} // namespace bluesky::operations
