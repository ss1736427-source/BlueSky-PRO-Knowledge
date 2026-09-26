#include "constrained_open_space.hpp"

#include <cassert>
#include <string>
using namespace bluesky::planning;

int main() {
    ConstrainedEnvironmentSnapshot environment;
    environment.snapshot_id = "ENV-1";
    environment.snapshot_version = "42";
    environment.calculation_input_version = "calc-42";

    SpatialRestriction restriction;
    restriction.restriction_id = "NOTAM-1";
    restriction.source_id = "NOTAM";
    restriction.snapshot_version = "N-7";
    restriction.polygon = {{59, 30}, {59, 30.01}, {59.01, 30.01}, {59.01, 30}};
    environment.restrictions.push_back(restriction);

    const SpatialEdge crossing{{58.995, 29.995}, {59.005, 30.005}, 100};
    const auto blocked = ConstrainedOpenSpace::evaluateSegment(environment, crossing);
    assert(!blocked.allowed && blocked.blocking_restriction_ids.size() == 1);

    const auto open = ConstrainedOpenSpace::evaluateSegment(
        environment, {{58.99, 29.99}, {58.995, 29.995}, 100});
    assert(open.allowed);

    restriction.minimum_altitude_m = 150;
    environment.restrictions[0] = restriction;
    assert(ConstrainedOpenSpace::evaluateSegment(environment, crossing).allowed);

    restriction.minimum_altitude_m = 0;
    restriction.maximum_altitude_m = 120;
    environment.restrictions[0] = restriction;
    assert(!ConstrainedOpenSpace::evaluateSegment(environment, crossing).allowed);

    const auto envelope = ConstrainedOpenSpace::evaluateSegment(
        environment, {{58.995, 29.995}, {59.005, 30.005}, 150, 80, 160});
    assert(!envelope.allowed);

    environment.complete = false;
    const auto incomplete = ConstrainedOpenSpace::evaluateSegment(environment, crossing);
    assert(!incomplete.allowed &&
           incomplete.blocking_restriction_ids.front() == "ENVIRONMENT_INCOMPLETE");
    environment.complete = true;

    const auto first = ConstrainedOpenSpace::evaluateSegment(environment, open.allowed
        ? SpatialEdge{{58.99, 29.99}, {58.995, 29.995}, 100} : crossing);
    const auto second = ConstrainedOpenSpace::evaluateSegment(environment,
        {{58.99, 29.99}, {58.995, 29.995}, 100});
    assert(first.dependency_identity == second.dependency_identity);

    auto changed = environment;
    changed.restrictions[0].polygon[0].latitude_deg += 0.001;
    const auto changed_result = ConstrainedOpenSpace::evaluateSegment(
        changed, {{58.99, 29.99}, {58.995, 29.995}, 100});
    assert(changed_result.dependency_identity != second.dependency_identity);

    Route empty_route;
    const auto empty = ConstrainedOpenSpace::evaluateRoute(environment, empty_route);
    assert(!empty.allowed &&
           empty.blocking_restriction_ids.front() == "ROUTE_HAS_NO_SEGMENTS");

    Route malformed_route;
    malformed_route.segments.push_back({"SEG-1", "MISSING-A", "MISSING-B", 10, 5});
    const auto malformed = ConstrainedOpenSpace::evaluateRoute(environment, malformed_route);
    assert(!malformed.allowed);
    assert(malformed.blocking_restriction_ids.size() == 1);
    assert(malformed.blocking_restriction_ids.front() ==
           "ROUTE_SEGMENT_MISSING_WAYPOINT:SEG-1");

    Route valid_route;
    valid_route.waypoints = {
        {"A", {58.99, 29.99}, 100, false},
        {"B", {58.995, 29.995}, 100, false}
    };
    valid_route.segments.push_back({"SEG-2", "A", "B", 10, 5});
    assert(ConstrainedOpenSpace::evaluateRoute(environment, valid_route).allowed);

    return 0;
}
