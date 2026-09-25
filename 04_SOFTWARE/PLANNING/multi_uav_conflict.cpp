#include "multi_uav_conflict.hpp"
#include <algorithm>
#include <cmath>
#include <iomanip>
#include <sstream>

namespace bluesky::planning {
namespace {
constexpr double kEarthRadiusM=6371000.0;
constexpr double kPi=3.14159265358979323846;
double rad(double x){return x*kPi/180.0;}
double horizontal(const GeoPoint&a,const GeoPoint&b){
    const double lat=(rad(a.latitude_deg)+rad(b.latitude_deg))*0.5;
    const double n=rad(b.latitude_deg-a.latitude_deg)*kEarthRadiusM;
    const double e=rad(b.longitude_deg-a.longitude_deg)*kEarthRadiusM*std::cos(lat);
    return std::hypot(n,e);
}
const TrajectoryPoint4D* interpolate(const TrajectoryResult&t,double time){
    if(t.points.empty() || time < t.points.front().elapsed_time_s ||
       time > t.points.back().elapsed_time_s) return nullptr;
    for(size_t i=1;i<t.points.size();++i){
        const auto&a=t.points[i-1]; const auto&b=t.points[i];
        if(time<=b.elapsed_time_s){
            const double dt=b.elapsed_time_s-a.elapsed_time_s;
            const double f=dt>0.0?(time-a.elapsed_time_s)/dt:0.0;
            auto* out=new TrajectoryPoint4D;
            out->waypoint_id=a.waypoint_id+"@"+b.waypoint_id;
            out->position.latitude_deg=a.position.latitude_deg+
                (b.position.latitude_deg-a.position.latitude_deg)*f;
            out->position.longitude_deg=a.position.longitude_deg+
                (b.position.longitude_deg-a.position.longitude_deg)*f;
            out->altitude_m=a.altitude_m+(b.altitude_m-a.altitude_m)*f;
            out->elapsed_time_s=time;
            out->cumulative_energy_wh=a.cumulative_energy_wh+
                (b.cumulative_energy_wh-a.cumulative_energy_wh)*f;
            return out;
        }
    }
    return nullptr;
}
}
MultiUavConflictResult MultiUavConflictDetector::evaluate(
    const std::vector<TrajectoryResult>& ts,
    const std::vector<MultiUavSeparationInput>& sep,
    const std::string& version){
    MultiUavConflictResult r; r.calculation_version=version;
    std::ostringstream dep; dep<<version;
    for(const auto&t:ts) dep<<"|"<<t.uav_id<<":"<<t.dependency_identity;
    for(const auto&s:sep) dep<<"|S:"<<s.uav_id<<":"<<std::setprecision(17)
        <<s.minimum_horizontal_separation_m<<","<<s.minimum_vertical_separation_m
        <<","<<s.temporal_tolerance_s;
    r.dependency_identity=dep.str();

    if(ts.size()<2) return r;
    for(size_t i=0;i<ts.size();++i){
        if(ts[i].status!=TrajectoryStatus::Feasible || ts[i].points.size()<2){
            r.status=MultiUavConflictStatus::Conflict;
            r.findings.push_back({MultiUavConflictFindingCode::InvalidTrajectory,
                ts[i].uav_id, "", 0.0, "all trajectories must be feasible and contain 4D points"});
        }
    }
    if(r.status==MultiUavConflictStatus::Conflict) return r;

    auto sep_for=[&](const std::string&id)->MultiUavSeparationInput{
        for(const auto&s:sep) if(s.uav_id==id) return s;
        return {};
    };
    for(size_t i=0;i<ts.size();++i) for(size_t j=i+1;j<ts.size();++j){
        const auto si=sep_for(ts[i].uav_id), sj=sep_for(ts[j].uav_id);
        const double hsep=std::max(si.minimum_horizontal_separation_m,sj.minimum_horizontal_separation_m);
        const double vsep=std::max(si.minimum_vertical_separation_m,sj.minimum_vertical_separation_m);
        const double tol=std::max(si.temporal_tolerance_s,sj.temporal_tolerance_s);
        const double start=std::max(ts[i].points.front().elapsed_time_s,ts[j].points.front().elapsed_time_s);
        const double end=std::min(ts[i].points.back().elapsed_time_s,ts[j].points.back().elapsed_time_s);
        if(end+tol<start) continue;

        std::vector<double> times={start,end};
        for(const auto&p:ts[i].points) if(p.elapsed_time_s>=start-tol && p.elapsed_time_s<=end+tol) times.push_back(p.elapsed_time_s);
        for(const auto&p:ts[j].points) if(p.elapsed_time_s>=start-tol && p.elapsed_time_s<=end+tol) times.push_back(p.elapsed_time_s);
        std::sort(times.begin(),times.end());
        times.erase(std::unique(times.begin(),times.end(),[](double a,double b){return std::abs(a-b)<1e-9;}),times.end());

        for(double t:times){
            auto* a=interpolate(ts[i],t); auto* b=interpolate(ts[j],t);
            if(!a||!b) continue;
            const bool conflict=horizontal(a->position,b->position)<hsep &&
                std::abs(a->altitude_m-b->altitude_m)<vsep;
            delete a; delete b;
            if(conflict){
                r.status=MultiUavConflictStatus::Conflict;
                r.findings.push_back({MultiUavConflictFindingCode::SpatialTemporalConflict,
                    ts[i].uav_id,ts[j].uav_id,t,"minimum spatial/altitude separation is violated"});
                return r;
            }
        }
    }
    return r;
}
} // namespace bluesky::planning
