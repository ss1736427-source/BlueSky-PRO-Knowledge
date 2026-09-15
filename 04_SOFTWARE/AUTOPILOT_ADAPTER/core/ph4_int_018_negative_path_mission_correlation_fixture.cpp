#include "ph4_int_014_sil_execution_source.hpp"
#include "ph4_int_015_mavlink2_adapter.hpp"

#include <cassert>
#include <iostream>

int main() {
    using namespace bluesky::autopilot;

    const std::string flightRecordId = "FLIGHT-RECORD-PH4-INT-018";
    const std::string approvedMission = "MISSION-018:UAV-MAV-018";
    const std::string mismatchedMission = "MISSION-018:UAV-MAV-018-MISMATCH";

    Mavlink2Adapter adapter({"UAV-MAV-018", "MULTIROTOR", "MAVLINK2-BASELINE", "SIL", "MAVLink2", "2"});
    SilExecutionSource source(flightRecordId);

    assert(adapter.connect());
    assert(adapter.uploadMission(mismatchedMission));

    const auto started = adapter.startMission();
    assert(started.acknowledged);
    const auto startFrame = adapter.encodeCommand(started);
    const auto startAck = adapter.decodeCommandAck(startFrame);
    assert(startAck.has_value());

    const auto executing = source.emit(startAck->vehicleId, startAck->commandId, "EXECUTING");
    assert(executing.flightRecordId == flightRecordId);

    const auto readback = adapter.readBackMission();
    assert(readback.has_value());
    const auto readbackFrame = adapter.encodeMissionReadback(*readback);
    const auto decodedReadback = adapter.decodeMissionReadback(readbackFrame);
    assert(decodedReadback.has_value());

    const auto comparison = adapter.compareMission(approvedMission, *decodedReadback);
    assert(!comparison.equal);
    assert(!comparison.mismatches.empty());

    const auto failed = source.emit(startAck->vehicleId, startAck->commandId, "FAILED");
    assert(failed.flightRecordId == flightRecordId);
    assert(failed.vehicleId == executing.vehicleId);
    assert(failed.commandId == executing.commandId);

    std::cout << "PH4_INT_018|" << flightRecordId << "|"
              << startAck->vehicleId << "|" << startAck->commandId << "|"
              << executing.executionState << "|" << failed.executionState << "|"
              << Mavlink2Adapter::kProtocol << "|"
              << Mavlink2Adapter::kProtocolVersion << "|"
              << startFrame << "|" << readbackFrame << "|"
              << approvedMission << "|" << *decodedReadback << "|"
              << "MISMATCH" << "|" << "EXECUTION_FAILURE" << "\n";
    return 0;
}
