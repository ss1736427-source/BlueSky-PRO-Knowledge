#include "mission_compiler.hpp"

namespace bluesky::planning {

bool MissionCompiler::compile(const Mission& mission,
                              ExecutableMissionPackage& package,
                              std::string& rejection_reason) {
    rejection_reason.clear();

    if (mission.identity.mission_id.empty()) {
        rejection_reason = "MISSION_ID_REQUIRED";
        return false;
    }
    if (mission.identity.mission_version.empty()) {
        rejection_reason = "MISSION_VERSION_REQUIRED";
        return false;
    }
    if (mission.vehicle_assignments.empty()) {
        rejection_reason = "VEHICLE_ASSIGNMENT_REQUIRED";
        return false;
    }
    if (mission.selected_solution.candidate_id.empty()) {
        rejection_reason = "SELECTED_SOLUTION_REQUIRED";
        return false;
    }
    if (mission.executable_packages.size() != 0) {
        rejection_reason = "PACKAGE_ALREADY_DECLARED";
        return false;
    }

    const auto& vehicle = mission.vehicle_assignments.front();
    package.package_id = mission.identity.mission_id + "-PKG-" + mission.identity.mission_version;
    package.vehicle_id = vehicle.vehicle_id;
    package.package_version = mission.identity.mission_version;
    package.mission_id = mission.identity.mission_id;
    package.mission_version = mission.identity.mission_version;
    package.execution_steps = {"LOAD", "ARM_GATE", "EXECUTE", "COMPLETE"};
    return true;
}

} // namespace bluesky::planning
