#pragma once

#include <cstdint>
#include <string>
#include <vector>
#include <optional>

namespace bluesky::autopilot {

enum class ConnectionState {
    Disconnected,
    Connecting,
    Connected,
    Degraded,
    Recovering,
    Failed
};

enum class ExecutionState {
    Requested,
    Sent,
    Acknowledged,
    Executed,
    Rejected,
    Timeout,
    Unknown
};

enum class ErrorCode {
    None,
    NotConnected,
    AuthenticationFailed,
    Unsupported,
    IncompatibleVersion,
    CapabilityMissing,
    InvalidState,
    SafetyRejected,
    CommandRejected,
    Timeout,
    LinkLost,
    ProtocolError,
    MissionMismatch,
    ConfigurationMismatch,
    InternalAdapterError
};

struct Identity {
    std::string vehicleId;
    std::string vehicleType;
    std::string autopilot;
    std::string firmwareVersion;
    std::string protocol;
    std::string protocolVersion;
};

struct Capabilities {
    std::vector<std::string> commands;
    std::vector<std::string> missionFeatures;
    std::vector<std::string> payloadFeatures;
};

struct LinkMetrics {
    double latencyMs{0.0};
    double packetLoss{0.0};
    bool healthy{false};
};

struct CommandResult {
    std::string commandId;
    std::string vehicleId;
    ExecutionState executionState{ExecutionState::Unknown};
    bool acknowledged{false};
    ErrorCode error{ErrorCode::None};
    std::string reason;
    std::int64_t sourceTimestampMs{0};
    std::int64_t adapterTimestampMs{0};
};

struct MissionComparison {
    bool equal{false};
    std::vector<std::string> mismatches;
};

class UniversalAutopilotAdapter {
public:
    virtual ~UniversalAutopilotAdapter() = default;

    virtual Identity getVehicleIdentity() const = 0;
    virtual Capabilities getCapabilities() const = 0;

    virtual bool connect() = 0;
    virtual void disconnect() = 0;
    virtual ConnectionState getConnectionState() const = 0;
    virtual LinkMetrics getLinkMetrics() const = 0;

    virtual CommandResult arm() = 0;
    virtual CommandResult disarm() = 0;
    virtual CommandResult takeoff(double altitudeM) = 0;
    virtual CommandResult land() = 0;
    virtual CommandResult hold() = 0;
    virtual CommandResult resume() = 0;
    virtual CommandResult rtl() = 0;
    virtual CommandResult gotoPosition(double latDeg, double lonDeg, double altitudeM) = 0;
    virtual CommandResult startMission() = 0;
    virtual CommandResult pauseMission() = 0;
    virtual CommandResult abortMission() = 0;

    virtual bool uploadMission(const std::string& canonicalMission) = 0;
    virtual std::optional<std::string> readBackMission() = 0;
    virtual MissionComparison compareMission(
        const std::string& approvedMission,
        const std::string& actualMission) const = 0;
};

} // namespace bluesky::autopilot
