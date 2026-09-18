#pragma once
#include <cstdint>
#include <optional>
#include <string>

namespace bluesky::autopilot {

enum class MavlinkSessionState {
    Disconnected,
    Connecting,
    Connected,
    Degraded,
    Lost,
    Recovering
};

struct MavlinkSessionIdentity {
    std::string sessionId;
    std::string protocol{"MAVLINK2"};
    std::string dialect;
    std::string systemId;
    std::string componentId;
    std::string autopilot;
    std::string firmwareVersion;
};

struct MavlinkMessageEnvelope {
    std::string messageType;
    std::string sourceSystemId;
    std::string sourceComponentId;
    std::uint8_t sequence{0};
    std::int64_t receivedTimestampMs{0};
    bool supported{true};
    bool malformed{false};
};

class MavlinkSessionBoundary {
public:
    explicit MavlinkSessionBoundary(std::string dialect = "COMMON");

    bool connect(const MavlinkSessionIdentity& identity);
    void disconnect();

    MavlinkSessionState state() const;
    const MavlinkSessionIdentity& identity() const;

    bool acceptHeartbeat(const MavlinkMessageEnvelope& heartbeat);
    bool route(const MavlinkMessageEnvelope& message);

    bool heartbeatFresh(std::int64_t nowMs, std::int64_t timeoutMs) const;
    std::uint64_t acceptedMessageCount() const;
    std::uint64_t rejectedMessageCount() const;

    void markLost();
    bool beginRecovery();
    bool restore(const MavlinkSessionIdentity& identity);

private:
    std::string dialect_;
    MavlinkSessionIdentity identity_{};
    MavlinkSessionState state_{MavlinkSessionState::Disconnected};
    std::optional<std::int64_t> lastHeartbeatMs_;
    std::uint64_t acceptedMessages_{0};
    std::uint64_t rejectedMessages_{0};
};

} // namespace bluesky::autopilot
