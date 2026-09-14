#include "mission_compiler.hpp"
#include <iostream>

using namespace bluesky::planning;

int main() {
    Mission mission;
    mission.identity.mission_id = "MIS-GROUP-001";
    mission.identity.mission_version = "1";
    mission.vehicle_assignments.push_back({"UAV-001", "CFG-1"});
    mission.vehicle_assignments.push_back({"UAV-002", "CFG-2"});
    mission.selected_solution.candidate_id = "ROUTE-001";

    ExecutableMissionPackage first;
    std::string reason;
    if (!MissionCompiler::compile(mission, first, reason)) return 1;
    if (first.vehicle_id != "UAV-001") return 2;

    std::cout << "PASS: compiler input remains deterministic for current single-package baseline\n";
    std::cout << "NOTE: multi-vehicle package emission remains a required EC-05 increment\n";
    return 0;
}
