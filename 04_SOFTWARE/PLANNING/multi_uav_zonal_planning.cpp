#include "multi_uav_zonal_planning.hpp"

#include <algorithm>
#include <cmath>
#include <iomanip>
#include <sstream>

namespace bluesky::planning {
namespace {

std::string identity(const MissionOperatingArea& area,
                     const std::vector<std::string>& uavs,
                     std::size_t count,
                     const std::string& version) {
    std::ostringstream out;
    out << std::setprecision(15) << area.area_id << "|" << area.area_version
        << "|" << version << "|" << count;
    for (const auto& id : uavs) out << "|" << id;
    for (const auto& p : area.boundary)
        out << "|" << p.latitude_deg << "," << p.longitude_deg;
    return out.str();
}

bool finitePoint(const GeoPoint& p) {
    return std::isfinite(p.latitude_deg) && std::isfinite(p.longitude_deg);
}

} // namespace

ZonalPlanningResult MultiUavZonalPlanner::partition(
    const MissionOperatingArea& area,
    const std::vector<std::string>& uav_ids,
    const std::string& calculation_version) {
    ZonalPlanningResult result;
    result.calculation_version = calculation_version;

    if (area.area_id.empty() || area.area_version.empty() ||
        area.boundary.size() < 3 || uav_ids.empty()) {
        result.findings.push_back("INVALID_ZONAL_INPUT");
        return result;
    }
    if (!std::all_of(area.boundary.begin(), area.boundary.end(), finitePoint)) {
        result.findings.push_back("INVALID_AREA_GEOMETRY");
        return result;
    }
    auto unique_uavs = uav_ids;
    std::sort(unique_uavs.begin(), unique_uavs.end());
    if (std::adjacent_find(unique_uavs.begin(), unique_uavs.end()) != unique_uavs.end() ||
        std::any_of(unique_uavs.begin(), unique_uavs.end(),
                    [](const std::string& id) { return id.empty(); })) {
        result.findings.push_back("INVALID_UAV_SET");
        return result;
    }

    double min_lat = area.boundary.front().latitude_deg;
    double max_lat = min_lat;
    double min_lon = area.boundary.front().longitude_deg;
    double max_lon = min_lon;
    for (const auto& p : area.boundary) {
        min_lat = std::min(min_lat, p.latitude_deg);
        max_lat = std::max(max_lat, p.latitude_deg);
        min_lon = std::min(min_lon, p.longitude_deg);
        max_lon = std::max(max_lon, p.longitude_deg);
    }
    if (!(max_lon > min_lon) || !(max_lat > min_lat)) {
        result.findings.push_back("DEGENERATE_AREA");
        return result;
    }

    const auto n = unique_uavs.size();
    const double width = (max_lon - min_lon) / static_cast<double>(n);
    result.zones.reserve(n);
    result.assignments.reserve(n);

    for (std::size_t i = 0; i < n; ++i) {
        const double left = min_lon + width * static_cast<double>(i);
        const double right = (i + 1 == n) ? max_lon
                                          : min_lon + width * static_cast<double>(i + 1);
        OperationalZone zone;
        zone.zone_id = area.area_id + "-ZONE-" + std::to_string(i + 1);
        zone.zone_version = area.area_version + ".Z" + std::to_string(i + 1);
        zone.area_id = area.area_id;
        zone.ordinal = i;
        zone.boundary = {
            {min_lat, left}, {max_lat, left},
            {max_lat, right}, {min_lat, right}
        };
        result.zones.push_back(zone);
        result.assignments.push_back(
            {unique_uavs[i], zone.zone_id, zone.zone_version});
    }

    result.dependency_identity = identity(area, unique_uavs, n, calculation_version);
    result.feasible = true;
    return result;
}

} // namespace bluesky::planning
