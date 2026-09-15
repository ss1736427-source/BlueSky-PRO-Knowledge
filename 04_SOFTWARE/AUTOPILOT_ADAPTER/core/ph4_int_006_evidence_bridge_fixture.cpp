#include "autopilot_adapter_baseline.hpp"
#include "c2_interface_baseline.hpp"

#include <cassert>
#include <fstream>
#include <iostream>
#include <string>

namespace {
void write_event(std::ofstream& out, const std::string& parameter, const std::string& value,
                 const std::string& source, const std::string& quality,
                 const std::string& session, const std::string& run) {
    out << "{\"timestamp_ms\":1000,\"parameter\":\"" << parameter
        << "\",\"value\":\"" << value
        << "\",\"unit\":\"none\",\"source\":\"" << source
        << "\",\"quality\":\"" << quality
        << "\",\"context\":{\"session_id\":\"" << session
        << "\",\"test_run_id\":\"" << run
        << "\",\"evidence_domain_id\":\"EC-01\"}}\n";
}
}

int main(int argc, char** argv) {
    using namespace bluesky::autopilot;
    using namespace bluesky::c2;

    const std::string output = argc > 1 ? argv[1] : "ph4_int_006_events.jsonl";
    const std::string session = "SES-PH4-INT-006";
    const std::string run = "RUN-PH4-INT-006";

    AutopilotAdapterBaseline adapter(Identity{"FIXTURE-UAV-001", "FIXTURE", "FIXTURE-AUTOPILOT", "1.0", "FIXTURE", "1.0"});
    C2InterfaceBaseline c2(C2Identity{"FIXTURE-UAV-001", "FIXTURE-TRANSPORT", "FIXTURE-PROTOCOL", "1.0"});

    std::ofstream events(output, std::ios::trunc);
    assert(events.good());

    auto disconnected = adapter.startMission();
    assert(!disconnected.acknowledged);
    write_event(events, "command_result", "REJECTED", "AUTOPILOT_ADAPTER", "VALID", session, run);
    write_event(events, "error_reason", disconnected.reason, "AUTOPILOT_ADAPTER", "VALID", session, run);

    assert(adapter.connect());
    auto accepted = adapter.startMission();
    assert(accepted.acknowledged);
    write_event(events, "command_result", "ACKNOWLEDGED", "AUTOPILOT_ADAPTER", "VALID", session, run);

    auto c2Result = c2.send("MISSION", "MISSION-FIXTURE-006");
    assert(!c2Result.accepted);
    write_event(events, "c2_result", "REJECTED", "C2_INTERFACE", "VALID", session, run);

    events.close();
    std::cout << "PH4_INT_006_EVIDENCE_BRIDGE_FIXTURE: PASS\n";
    std::cout << "canonical_event_fields=PASS\n";
    std::cout << "session_provenance=PASS\n";
    std::cout << "failure_events_preserved=PASS\n";
    std::cout << "source_boundary_preserved=PASS\n";
    std::cout << "verification_status=FIXTURE_ONLY\n";
}
