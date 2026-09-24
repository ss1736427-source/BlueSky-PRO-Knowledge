#include "constrained_open_space.hpp"
#include <cassert>
using namespace bluesky::planning;
int main(){
 ConstrainedEnvironmentSnapshot e; e.snapshot_id="ENV-1";e.snapshot_version="42";e.calculation_input_version="calc-42";
 SpatialRestriction z;z.restriction_id="NOTAM-1";z.source_id="NOTAM";z.snapshot_version="N-7";z.polygon={{59,30},{59,30.01},{59.01,30.01},{59.01,30}};e.restrictions.push_back(z);
 auto blocked=ConstrainedOpenSpace::evaluateSegment(e,{{58.995,29.995},{59.005,30.005},100});assert(!blocked.allowed&&blocked.blocking_restriction_ids.size()==1);
 auto open=ConstrainedOpenSpace::evaluateSegment(e,{{58.99,29.99},{58.995,29.995},100});assert(open.allowed);
 z.minimum_altitude_m=150;e.restrictions[0]=z;assert(ConstrainedOpenSpace::evaluateSegment(e,{{58.995,29.995},{59.005,30.005},100}).allowed);
 z.minimum_altitude_m=0;z.maximum_altitude_m=120;e.restrictions[0]=z;assert(!ConstrainedOpenSpace::evaluateSegment(e,{{58.995,29.995},{59.005,30.005},100}).allowed);
 e.complete=false;auto incomplete=ConstrainedOpenSpace::evaluateSegment(e,{{58.995,29.995},{59.005,30.005},100});assert(!incomplete.allowed&&incomplete.blocking_restriction_ids.front()=="ENVIRONMENT_INCOMPLETE");
 e.complete=true;auto a=ConstrainedOpenSpace::evaluateSegment(e,{{58.99,29.99},{58.995,29.995},100});auto b=ConstrainedOpenSpace::evaluateSegment(e,{{58.99,29.99},{58.995,29.995},100});assert(a.dependency_identity==b.dependency_identity);return 0;
}