#pragma once

#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace bluesky::planning {
struct Mission;
struct VehicleEquipmentCapabilityProfile;
}

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
    Validating,
    Rejected,
    Dispatched,
    Acknowledged,
    Executing,
    Completed,
    Failed,
    Cancelled,
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
    std::vector<std::string> equipmentFeatures;
};

struct LinkMetrics {
    double latencyMs{0.0};
    double packetLoss{0.0};
    bool healthy{false};
};

struct NormalizedState {
    std::string value;
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
    virtual std::string getAutopilotIdentity() const = 0;
    virtual std::string getFirmwareVersion() const = 0;
    virtual std::string getProtocolVersion() const = 0;

    virtual Capabilities getCapabilities() const = 0;
    virtual std::vector<std::string> getSupportedCommands() const = 0;
    virtual std::vector<std::string> getSupportedMissionFeatures() const = 0;
    virtual std::vector<std::string> getSupportedEquipmentFeatures() const = 0;

    virtual bool connect() = 0;
    virtual void disconnect() = 0;
    virtual ConnectionState getConnectionState() const = 0;
    virtual LinkMetrics getLinkMetrics() const = 0;

    virtual NormalizedState getNavigationState() const = 0;
    virtual NormalizedState getFlightMode() const = 0;
    virtual NormalizedState getHealthState() const = 0;
    virtual NormalizedState getFailsafeState() const = 0;
    virtual NormalizedState getEnergyState() const = 0;
    virtual NormalizedState getMissionState() const = 0;
    virtual NormalizedState getEquipmentState() const = 0;

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
    virtual CommandResult resumeMission() = 0;
    virtual CommandResult abortMission() = 0;

    virtual std::optional<std::string> compileMission(
        const bluesky::planning::Mission& mission,
        const bluesky::planning::VehicleEquipmentCapabilityProfile& capabilities) = 0;
    virtual bool uploadMission(const std::string& compiledMission) = 0;
    virtual std::optional<std::string> downloadMission() = 0;
    virtual std::optional<std::string> readBackMission() = 0;
    virtual MissionComparison compareMission(
        const std::string& approvedMission,
        const std::string& actualMission) const = 0;

    virtual std::optional<std::string> readBaseline() = 0;
    virtual MissionComparison compare(
        const std::string& baseline,
        const std::string& actual) const = 0;
    virtual CommandResult validate(const std::string& configuration) const = 0;
    virtual CommandResult write(const std::string& configuration) = 0;
    virtual std::optional<std::string> readBack() = 0;
    virtual CommandResult verify(const std::string& baseline) = 0;
};

} // namespace bluesky::autopilot
