#include "mission_compiler.hpp"
#include <iostream>

using namespace bluesky::planning;

int main() {
    Mission mission;
    mission.identity.mission_id = "MIS-001";
    mission.identity.mission_version = "1";
    mission.vehicle_assignments.push_back({"UAV-001", "CFG-1"});
    mission.selected_solution.candidate_id = "ROUTE-001";

    ExecutableMissionPackage package;
    std::string reason;

    if (!MissionCompiler::compile(mission, package, reason)) return 1;
    if (package.package_id != "MIS-001-PKG-1") return 2;
    if (package.vehicle_id != "UAV-001") return 3;
    if (package.execution_steps.size() != 4) return 4;

    Mission invalid = mission;
    invalid.identity.mission_id.clear();
    if (MissionCompiler::compile(invalid, package, reason)) return 5;
    if (reason != "MISSION_ID_REQUIRED") return 6;

    std::cout << "PASS: mission compiler contract\n";
    return 0;
}
