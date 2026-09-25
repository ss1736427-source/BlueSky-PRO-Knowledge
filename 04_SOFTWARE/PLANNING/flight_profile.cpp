#include "flight_profile.hpp"
#include <cmath>
namespace bluesky::planning {
FlightProfile FlightProfileBuilder::build(const SelectedRouteSet& selected,
                                          const Route& route,
                                          const std::string& profile_id,
                                          const std::string& profile_version) {
    FlightProfile result;
    result.mission_id = selected.mission_id;
    result.mission_version = selected.mission_version;
    result.profile_id = profile_id;
    result.source_candidate_id = selected.candidate_id;
    result.route_version = route.route_version;
    result.calculation_input_version = route.lineage.calculation_input_version;
    result.dependency_identity = selected.source_dependency_identity + "|" + route.lineage.dependency_identity;
    result.points.reserve(route.waypoints.size());
    double time = 0.0;
    for (const auto& wp : route.waypoints) {
        FlightProfilePoint p;
        p.position = wp.position;
        p.altitude_m = wp.altitude_m;
        p.cumulative_time_s = time;
        p.mandatory = wp.mandatory;
        result.points.push_back(p);
    }
    (void)profile_version;
    return result;
}
}
