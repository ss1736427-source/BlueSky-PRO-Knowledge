#include "ph4_int_014_sil_execution_source.hpp"
#include "ph4_int_015_mavlink2_adapter.hpp"

#include <cassert>
#include <iostream>

int main() {
    using namespace bluesky::autopilot;

    const std::string flightRecordId = "FLIGHT-RECORD-PH4-INT-017";
    const std::string approvedMission = "MISSION-017:UAV-MAV-017";

    Mavlink2Adapter adapter({"UAV-MAV-017", "MULTIROTOR", "MAVLINK2-BASELINE", "SIL", "MAVLink2", "2"});
    SilExecutionSource source(flightRecordId);

    assert(adapter.connect());
    assert(adapter.uploadMission(approvedMission));

    const auto started = adapter.startMission();
    assert(started.acknowledged);
    const auto startFrame = adapter.encodeCommand(started);
    const auto startAck = adapter.decodeCommandAck(startFrame);
    assert(startAck.has_value());
    assert(startAck->commandId == started.commandId);

    const auto executionEvent = source.emit(startAck->vehicleId, startAck->commandId, "EXECUTING");
    assert(executionEvent.flightRecordId == flightRecordId);

    const auto readback = adapter.readBackMission();
    assert(readback.has_value());
    const auto readbackFrame = adapter.encodeMissionReadback(*readback);
    const auto decodedReadback = adapter.decodeMissionReadback(readbackFrame);
    assert(decodedReadback.has_value());

    const auto comparison = adapter.compareMission(approvedMission, *decodedReadback);
    assert(comparison.match);

    const auto completedEvent = source.emit(startAck->vehicleId, startAck->commandId, "COMPLETED");
    assert(completedEvent.flightRecordId == flightRecordId);

    std::cout << "PH4_INT_017|" << flightRecordId << "|"
              << startAck->vehicleId << "|" << startAck->commandId << "|"
              << "EXECUTING" << "|" << "COMPLETED" << "|"
              << Mavlink2Adapter::kProtocol << "|"
              << Mavlink2Adapter::kProtocolVersion << "|"
              << startFrame << "|" << readbackFrame << "|"
              << approvedMission << "|" << *decodedReadback << "|"
              << (comparison.match ? "MATCH" : "MISMATCH") << "\n";
    return 0;
}
