#pragma once

#include <string>
#include <vector>

namespace bluesky::planning {

struct PlanningGraphEdge {
    std::string from;
    std::string to;
    double cost{0.0};
};

struct PlanningGraph {
    std::vector<std::string> nodes;
    std::vector<PlanningGraphEdge> edges;
    std::string start_node;
    std::string goal_node;
};

} // namespace bluesky::planning
