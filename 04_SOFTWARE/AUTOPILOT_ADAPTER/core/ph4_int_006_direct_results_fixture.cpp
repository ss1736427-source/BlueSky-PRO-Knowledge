#include "autopilot_adapter_baseline.hpp"
#include "c2_interface_baseline.hpp"
#include <cassert>
#include <iostream>
int main() {
    using namespace bluesky::autopilot;
    using namespace bluesky::c2;
    AutopilotAdapterBaseline adapter(Identity{"FIXTURE-UAV-001", "FIXTURE", "FIXTURE-AUTOPILOT", "1.0", "FIXTURE", "1.0"});
    C2InterfaceBaseline c2(C2Identity{"FIXTURE-UAV-001", "FIXTURE-TRANSPORT", "FIXTURE-PROTOCOL", "1.0"});
    auto rejected = adapter.startMission();
    assert(!rejected.acknowledged && rejected.error == ErrorCode::NotConnected && rejected.reason == "AUTOPILOT_NOT_CONNECTED");
    assert(adapter.connect());
    auto accepted = adapter.startMission();
    assert(accepted.acknowledged && accepted.error == ErrorCode::None);
    auto mismatch = adapter.compare("APPROVED", "ACTUAL");
    assert(!mismatch.equal && mismatch.mismatches.size() == 1);
    auto c2Rejected = c2.send("MISSION", "PAYLOAD");
    assert(!c2Rejected.accepted && c2Rejected.error == C2ErrorCode::NotConnected);
    assert(c2.connect());
    auto authFailure = c2.authenticate("");
    assert(!authFailure.accepted && authFailure.error == C2ErrorCode::AuthenticationFailed);
    std::cout << "PH4_INT_006_DIRECT_RESULTS: PASS\n";
    std::cout << "adapter_result_binding=PASS\n";
    std::cout << "c2_result_binding=PASS\n";
    std::cout << "mismatch_is_non_success=PASS\n";
    std::cout << "verification_status=FIXTURE_ONLY\n";
}
