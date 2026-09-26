#include "notam_prohibited_zone_validator.hpp"
#include <cassert>

using namespace bluesky::planning;

static Route route() {
    Route r;
    r.lineage.route_id = "R-NOTAM-1";
    r.lineage.route_version = "1";
    r.environment.airspace_snapshot_id = "NOTAM-SNAP-1";
    r.constraints.avoid_restricted_areas = true;
    r.waypoints = {{"WP-1", {60.0, 25.0}, 100.0, true}, {"WP-2", {60.01, 25.01}, 100.0, false}};
    return r;
}

static NotamSnapshot snapshot() {
    NotamSnapshot s;
    s.snapshot_id = "NOTAM-SNAP-1";
    s.source_id = "AUTH-NOTAM";
    s.source_version = "2026-09-24T12:00Z";
    s.evaluation_epoch_s = 1000;
    s.zones.push_back({"N-001", NotamRestrictionType::Prohibited, NotamGeometryType::Circle,
                       {60.0, 25.0}, 1000.0, {}, 0.0, 500.0, 900, 1100});
    return s;
}

int main() {
    auto r = route();
    auto s = snapshot();
    auto blocked = NotamProhibitedZoneValidator::validate(r, s);
    assert(blocked.status == RouteValidationStatus::Rejected);
    assert(blocked.findings.size() == 1);
    assert(blocked.findings.front().waypoint_id == "WP-1");
    assert(blocked.findings.front().notam_id == "N-001");

    r.waypoints.front().position = {60.1, 25.1};
    auto allowed = NotamProhibitedZoneValidator::validate(r, s);
    assert(allowed.status == RouteValidationStatus::Allowed);

    r.environment.airspace_snapshot_id.clear();
    auto missing = NotamProhibitedZoneValidator::validate(r, s);
    assert(missing.status == RouteValidationStatus::Rejected);
    assert(missing.findings.front().code == NotamValidationCode::MissingSnapshotReference);
}
