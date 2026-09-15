#include "ph4_int_014_sil_execution_source.hpp"
#include "ph4_int_015_mavlink2_adapter.hpp"

#include <cassert>
#include <exception>
#include <iostream>

int main() {
    try {
        using namespace bluesky::autopilot;

        const std::string flightRecordId = "FLIGHT-RECORD-PH4-INT-017";
        const std::string approvedMission = "MISSION-017:UAV-MAV-017";

        std::cerr << "PH4_INT_017_STAGE|construct\n";
        Mavlink2Adapter adapter({"UAV-MAV-017", "MULTIROTOR", "MAVLINK2-BASELINE", "SIL", "MAVLink2", "2"});
        SilExecutionSource source(flightRecordId);

        std::cerr << "PH4_INT_017_STAGE|connect_upload\n";
        assert(adapter.connect());
        assert(adapter.uploadMission(approvedMission));

        std::cerr << "PH4_INT_017_STAGE|command_ack\n";
        const auto started = adapter.startMission();
        assert(started.acknowledged);
        const auto startFrame = adapter.encodeCommand(started);
        const auto startAck = adapter.decodeCommandAck(startFrame);
        assert(startAck.has_value());
        assert(startAck->commandId == started.commandId);

        std::cerr << "PH4_INT_017_STAGE|executing\n";
        const auto executionEvent = source.emit(startAck->vehicleId, startAck->commandId, "EXECUTING");
        assert(executionEvent.flightRecordId == flightRecordId);

        std::cerr << "PH4_INT_017_STAGE|readback\n";
        const auto readback = adapter.readBackMission();
        assert(readback.has_value());
        const auto readbackFrame = adapter.encodeMissionReadback(*readback);
        const auto decodedReadback = adapter.decodeMissionReadback(readbackFrame);
        assert(decodedReadback.has_value());

        std::cerr << "PH4_INT_017_STAGE|compare\n";
        const auto comparison = adapter.compareMission(approvedMission, *decodedReadback);
        assert(comparison.equal);

        std::cerr << "PH4_INT_017_STAGE|completed\n";
        const auto completedEvent = source.emit(startAck->vehicleId, startAck->commandId, "COMPLETED");
        assert(completedEvent.flightRecordId == flightRecordId);

        std::cout << "PH4_INT_017|" << flightRecordId << "|"
                  << startAck->vehicleId << "|" << startAck->commandId << "|"
                  << "EXECUTING" << "|" << "COMPLETED" << "|"
                  << Mavlink2Adapter::kProtocol << "|"
                  << Mavlink2Adapter::kProtocolVersion << "|"
                  << startFrame << "|" << readbackFrame << "|"
                  << approvedMission << "|" << *decodedReadback << "|"
                  << (comparison.equal ? "MATCH" : "MISMATCH") << "\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "PH4_INT_017_EXCEPTION|" << error.what() << "\n";
        return 1;
    } catch (...) {
        std::cerr << "PH4_INT_017_EXCEPTION|UNKNOWN\n";
        return 1;
    }
}
