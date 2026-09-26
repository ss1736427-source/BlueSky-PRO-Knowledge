#include "notam_prohibited_zone_validator.hpp"
#include <algorithm>
#include <cmath>

namespace bluesky::planning {
namespace {
constexpr double kEarthRadiusM = 6371000.0;
constexpr double kPi = 3.14159265358979323846;

double deg_to_rad(double v) { return v * kPi / 180.0; }

bool valid_point(const GeoPoint& p) {
    return std::isfinite(p.latitude_deg) && std::isfinite(p.longitude_deg) &&
           p.latitude_deg >= -90.0 && p.latitude_deg <= 90.0 &&
           p.longitude_deg >= -180.0 && p.longitude_deg <= 180.0;
}

double distance_m(const GeoPoint& a, const GeoPoint& b) {
    const double lat1 = deg_to_rad(a.latitude_deg);
    const double lat2 = deg_to_rad(b.latitude_deg);
    const double dlat = lat2 - lat1;
    const double dlon = deg_to_rad(b.longitude_deg - a.longitude_deg);
    const double h = std::clamp(
        std::sin(dlat / 2.0) * std::sin(dlat / 2.0) +
        std::cos(lat1) * std::cos(lat2) *
        std::sin(dlon / 2.0) * std::sin(dlon / 2.0), 0.0, 1.0);
    return 2.0 * kEarthRadiusM * std::atan2(std::sqrt(h), std::sqrt(1.0 - h));
}

bool point_in_polygon(const GeoPoint& p, const std::vector<GeoPoint>& poly) {
    if (poly.size() < 3) return false;
    bool inside = false;
    for (std::size_t i = 0, j = poly.size() - 1; i < poly.size(); j = i++) {
        const auto& a = poly[i];
        const auto& b = poly[j];
        const bool crosses = ((a.longitude_deg > p.longitude_deg) != (b.longitude_deg > p.longitude_deg));
        if (crosses) {
            const double lat_at_lon = a.latitude_deg +
                (b.latitude_deg - a.latitude_deg) *
                (p.longitude_deg - a.longitude_deg) /
                (b.longitude_deg - a.longitude_deg);
            if (p.latitude_deg < lat_at_lon) inside = !inside;
        }
    }
    return inside;
}

bool valid_zone(const NotamZone& z) {
    if (z.notam_id.empty() || !std::isfinite(z.lower_altitude_m) ||
        !std::isfinite(z.upper_altitude_m) || z.lower_altitude_m > z.upper_altitude_m ||
        z.valid_from_epoch_s <= 0 || z.valid_to_epoch_s < z.valid_from_epoch_s)
        return false;
    if (z.geometry_type == NotamGeometryType::Circle)
        return valid_point(z.center) && std::isfinite(z.radius_m) && z.radius_m > 0.0;
    if (z.geometry_type == NotamGeometryType::Polygon)
        return z.polygon.size() >= 3 &&
               std::all_of(z.polygon.begin(), z.polygon.end(), valid_point);
    return false;
}

bool contains(const NotamZone& z, const GeoPoint& p) {
    if (z.geometry_type == NotamGeometryType::Circle) return distance_m(z.center, p) <= z.radius_m;
    return point_in_polygon(p, z.polygon);
}
}

NotamValidationResult NotamProhibitedZoneValidator::validate(const Route& route,
                                                              const NotamSnapshot& snapshot) {
    NotamValidationResult result;
    result.snapshot_id = snapshot.snapshot_id;

    const auto reject_snapshot = [&result](const char* detail) {
        result.status = RouteValidationStatus::Rejected;
        result.findings.push_back({NotamValidationCode::SnapshotNotValid, "", "", detail});
    };

    if (route.constraints.avoid_restricted_areas &&
        route.environment.airspace_snapshot_id.empty()) {
        result.status = RouteValidationStatus::Rejected;
        result.findings.push_back({NotamValidationCode::MissingSnapshotReference, "", "",
                                   "Missing airspace/NOTAM snapshot reference"});
        return result;
    }

    if (snapshot.snapshot_id.empty() || snapshot.evaluation_epoch_s <= 0) {
        reject_snapshot("NOTAM snapshot is missing identity or evaluation time");
        return result;
    }
    if (route.constraints.avoid_restricted_areas &&
        route.environment.airspace_snapshot_id != snapshot.snapshot_id) {
        reject_snapshot("Route airspace snapshot reference does not match supplied NOTAM snapshot");
        return result;
    }

    for (const auto& zone : snapshot.zones) {
        if (!valid_zone(zone)) {
            reject_snapshot("NOTAM snapshot contains an invalid prohibited-zone record");
            return result;
        }
    }

    for (const auto& wp : route.waypoints) {
        if (!valid_point(wp.position) || !std::isfinite(wp.altitude_m)) {
            reject_snapshot("Route contains an invalid waypoint coordinate or altitude");
            return result;
        }
    }

    for (const auto& zone : snapshot.zones) {
        if (zone.restriction_type != NotamRestrictionType::Prohibited) continue;
        if (snapshot.evaluation_epoch_s < zone.valid_from_epoch_s ||
            snapshot.evaluation_epoch_s > zone.valid_to_epoch_s) continue;
        for (const auto& wp : route.waypoints) {
            if (wp.altitude_m < zone.lower_altitude_m ||
                wp.altitude_m > zone.upper_altitude_m) continue;
            if (contains(zone, wp.position)) {
                result.status = RouteValidationStatus::Rejected;
                result.findings.push_back({NotamValidationCode::WaypointInsideProhibitedZone,
                                           wp.waypoint_id, zone.notam_id,
                                           "Route waypoint lies inside an active NOTAM prohibited zone"});
            }
        }
    }
    return result;
}

} // namespace bluesky::planning
