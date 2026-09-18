#include "mavlink_session_boundary.hpp"

namespace bluesky::autopilot {

MavlinkSessionBoundary::MavlinkSessionBoundary(std::string dialect)
    : dialect_(std::move(dialect)) {}

bool MavlinkSessionBoundary::connect(const MavlinkSessionIdentity& identity) {
    if (identity.sessionId.empty() || identity.systemId.empty() ||
        identity.componentId.empty() || identity.protocol != "MAVLINK2" ||
        identity.dialect.empty()) {
        state_ = MavlinkSessionState::Disconnected;
        return false;
    }
    identity_ = identity;
    state_ = MavlinkSessionState::Connected;
    lastHeartbeatMs_.reset();
    return true;
}

void MavlinkSessionBoundary::disconnect() {
    state_ = MavlinkSessionState::Disconnected;
    lastHeartbeatMs_.reset();
}

MavlinkSessionState MavlinkSessionBoundary::state() const {
    return state_;
}

const MavlinkSessionIdentity& MavlinkSessionBoundary::identity() const {
    return identity_;
}

bool MavlinkSessionBoundary::acceptHeartbeat(const MavlinkMessageEnvelope& heartbeat) {
    if (state_ != MavlinkSessionState::Connected &&
        state_ != MavlinkSessionState::Recovering) {
        ++rejectedMessages_;
        return false;
    }
    if (heartbeat.messageType != "HEARTBEAT" || heartbeat.malformed ||
        !heartbeat.supported || heartbeat.sourceSystemId != identity_.systemId ||
        heartbeat.sourceComponentId != identity_.componentId) {
        ++rejectedMessages_;
        return false;
    }
    lastHeartbeatMs_ = heartbeat.receivedTimestampMs;
    ++acceptedMessages_;
    state_ = MavlinkSessionState::Connected;
    return true;
}

bool MavlinkSessionBoundary::route(const MavlinkMessageEnvelope& message) {
    if (state_ != MavlinkSessionState::Connected &&
        state_ != MavlinkSessionState::Recovering) {
        ++rejectedMessages_;
        return false;
    }
    if (message.malformed || !message.supported ||
        message.sourceSystemId != identity_.systemId ||
        message.sourceComponentId != identity_.componentId) {
        ++rejectedMessages_;
        return false;
    }
    ++acceptedMessages_;
    return true;
}

bool MavlinkSessionBoundary::heartbeatFresh(std::int64_t nowMs, std::int64_t timeoutMs) const {
    return lastHeartbeatMs_.has_value() &&
           nowMs >= *lastHeartbeatMs_ &&
           (nowMs - *lastHeartbeatMs_) <= timeoutMs;
}

std::uint64_t MavlinkSessionBoundary::acceptedMessageCount() const {
    return acceptedMessages_;
}

std::uint64_t MavlinkSessionBoundary::rejectedMessageCount() const {
    return rejectedMessages_;
}

void MavlinkSessionBoundary::markLost() {
    if (state_ == MavlinkSessionState::Connected ||
        state_ == MavlinkSessionState::Degraded) {
        state_ = MavlinkSessionState::Lost;
    }
}

bool MavlinkSessionBoundary::beginRecovery() {
    if (state_ != MavlinkSessionState::Lost) return false;
    state_ = MavlinkSessionState::Recovering;
    lastHeartbeatMs_.reset();
    return true;
}

bool MavlinkSessionBoundary::restore(const MavlinkSessionIdentity& identity) {
    if (state_ != MavlinkSessionState::Recovering ||
        identity.systemId != identity_.systemId ||
        identity.componentId != identity_.componentId ||
        identity.protocol != "MAVLINK2" ||
        identity.dialect.empty()) {
        return false;
    }
    identity_ = identity;
    state_ = MavlinkSessionState::Connected;
    return true;
}

} // namespace bluesky::autopilot
