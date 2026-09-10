#pragma once

#include "../solver_contract/solver_contract.hpp"

#include <atomic>
#include <functional>
#include <string>
#include <unordered_map>
#include <vector>

namespace bluesky::planning {

struct AStarNode {
    std::string id;
    double g{0.0};
    double h{0.0};
    std::string parent;
};

struct AStarEdge {
    std::string from;
    std::string to;
    double cost{0.0};
};

class AStarSolver final : public Solver {
public:
    using Heuristic = std::function<double(const std::string&, const std::string&)>;
    using GoalTest = std::function<bool(const std::string&)>;

    AStarSolver(std::vector<AStarNode> nodes,
                std::vector<AStarEdge> edges,
                Heuristic heuristic,
                GoalTest goal_test);

    SolverMetadata metadata() const override;
    bool eligible(const MissionProblem& problem) const override;
    RunState run(SolverContext& context) override;
    void cancel() override;

private:
    std::vector<AStarNode> nodes_;
    std::vector<AStarEdge> edges_;
    Heuristic heuristic_;
    GoalTest goal_test_;
    std::atomic<bool> cancelled_{false};
};

} // namespace bluesky::planning
