#include "constrained_open_space.hpp"
#include <algorithm>
#include <cmath>
#include <functional>
namespace bluesky::planning {
namespace {
constexpr double kM=111320.0;
struct XY{double x;double y;};
XY project(const GeoPoint&p,double lat){return {p.longitude_deg*kM*std::cos(lat*3.141592653589793/180.0),p.latitude_deg*kM};}
double cross(XY a,XY b,XY c){return (b.x-a.x)*(c.y-a.y)-(b.y-a.y)*(c.x-a.x);}
bool on(XY a,XY b,XY p){constexpr double e=1e-7;return std::abs(cross(a,b,p))<e&&p.x>=std::min(a.x,b.x)-e&&p.x<=std::max(a.x,b.x)+e&&p.y>=std::min(a.y,b.y)-e&&p.y<=std::max(a.y,b.y)+e;}
bool inter(XY a,XY b,XY c,XY d){double x=cross(a,b,c),y=cross(a,b,d),z=cross(c,d,a),w=cross(c,d,b);if(((x>0&&y<0)||(x<0&&y>0))&&((z>0&&w<0)||(z<0&&w>0)))return true;return on(a,b,c)||on(a,b,d)||on(c,d,a)||on(c,d,b);}
bool inside(XY p,const std::vector<XY>&v){bool in=false;if(v.size()<3)return false;for(size_t i=0,j=v.size()-1;i<v.size();j=i){if((v[i].y>p.y)!=(v[j].y>p.y)){double x=v[j].x+(p.y-v[j].y)*(v[i].x-v[j].x)/(v[i].y-v[j].y);if(p.x<x)in=!in;}}return in;}
double dist(XY p,XY a,XY b){double dx=b.x-a.x,dy=b.y-a.y,d=dx*dx+dy*dy;if(d==0)return std::hypot(p.x-a.x,p.y-a.y);double t=std::max(0.0,std::min(1.0,((p.x-a.x)*dx+(p.y-a.y)*dy)/d));return std::hypot(p.x-(a.x+t*dx),p.y-(a.y+t*dy));}
bool hit(const SpatialRestriction&r,const SpatialEdge&e){
 if(!r.active)return false;
 if(e.altitude_m<r.minimum_altitude_m||(r.maximum_altitude_m>0&&e.altitude_m>r.maximum_altitude_m))return false;
 double lat=(e.from.latitude_deg+e.to.latitude_deg)*0.5;XY a=project(e.from,lat),b=project(e.to,lat);
 if(r.geometry_type==RestrictionGeometryType::Circle)return dist(project(r.center,lat),a,b)<=r.radius_m;
 if(r.polygon.size()<3)return false;std::vector<XY>p;for(auto&g:r.polygon)p.push_back(project(g,lat));
 if(inside(a,p)||inside(b,p))return true;for(size_t i=0;i<p.size();++i)if(inter(a,b,p[i],p[(i+1)%p.size()]))return true;return false;
}
std::string dep(const ConstrainedEnvironmentSnapshot&e){std::hash<std::string>h;std::string s=e.snapshot_id+"|"+e.snapshot_version+"|"+e.calculation_input_version;for(auto&r:e.restrictions)s+="|"+r.restriction_id+"|"+r.source_id+"|"+r.snapshot_version+"|"+std::to_string(r.minimum_altitude_m)+"|"+std::to_string(r.maximum_altitude_m);return std::to_string(h(s));}
OpenSpaceResult init(const ConstrainedEnvironmentSnapshot&e){return {true,e.snapshot_id,e.snapshot_version,e.calculation_input_version,dep(e),{}};}
}
OpenSpaceResult ConstrainedOpenSpace::evaluateSegment(const ConstrainedEnvironmentSnapshot&e,const SpatialEdge&edge){
 auto r=init(e);if(!e.complete){r.allowed=false;r.blocking_restriction_ids.push_back("ENVIRONMENT_INCOMPLETE");return r;}
 for(const auto&x:e.restrictions)if(hit(x,edge))r.blocking_restriction_ids.push_back(x.restriction_id);
 r.allowed=r.blocking_restriction_ids.empty();return r;
}
OpenSpaceResult ConstrainedOpenSpace::evaluateRoute(const ConstrainedEnvironmentSnapshot&e,const Route&route){
 auto r=init(e);if(!e.complete){r.allowed=false;r.blocking_restriction_ids.push_back("ENVIRONMENT_INCOMPLETE");return r;}
 for(const auto&s:route.segments){auto a=std::find_if(route.waypoints.begin(),route.waypoints.end(),[&](const auto&w){return w.waypoint_id==s.from_waypoint_id;});auto b=std::find_if(route.waypoints.begin(),route.waypoints.end(),[&](const auto&w){return w.waypoint_id==s.to_waypoint_id;});if(a==route.waypoints.end()||b==route.waypoints.end())continue;auto x=evaluateSegment(e,{a->position,b->position,(a->altitude_m+b->altitude_m)*0.5});r.blocking_restriction_ids.insert(r.blocking_restriction_ids.end(),x.blocking_restriction_ids.begin(),x.blocking_restriction_ids.end());}
 std::sort(r.blocking_restriction_ids.begin(),r.blocking_restriction_ids.end());r.blocking_restriction_ids.erase(std::unique(r.blocking_restriction_ids.begin(),r.blocking_restriction_ids.end()),r.blocking_restriction_ids.end());r.allowed=r.blocking_restriction_ids.empty();return r;
}
}
