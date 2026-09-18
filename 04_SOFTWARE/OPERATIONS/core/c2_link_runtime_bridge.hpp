#pragma once

#include "mavlink_transport_channel_runtime.hpp"
#include "../../AUTOPILOT_ADAPTER/core/c2_channel_manager.hpp"
#include <cstdint>
#include <optional>
#include <string>

namespace bluesky::operations {

struct C2LinkMeasurement {
    double latency_ms{0.0};
    double packet_loss{0.0};
    double capacity_kbps{0.0};
    bool integrity_ok{false};
    bool authenticated{false};
    std::int64_t measured_timestamp_ms{0};
};

class C2LinkRuntimeBridge final {
public:
    // Builds the C2 measurement input from executable per-channel runtime metrics.
    // Capacity is represented as observed throughput, not physical link capacity.
    static C2LinkMeasurement measureFromTransport(
        const MavlinkTransportChannelSnapshot& transport,
        bool integrity_ok,
        bool authenticated,
        std::int64_t measured_timestamp_ms);

    static std::optional<bluesky::c2::ChannelSnapshot> toChannelSnapshot(
        const MavlinkTransportChannelSnapshot& transport,
        const C2LinkMeasurement& measurement);

private:
    static bluesky::c2::ChannelState mapState(
        MavlinkTransportChannelState state);
};

} // namespace bluesky::operations
