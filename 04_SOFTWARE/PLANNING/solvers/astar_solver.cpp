#include "astar_solver.hpp"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <limits>
#include <queue>
#include <unordered_set>

namespace bluesky::planning {

AStarSolver::AStarSolver(std::vector<AStarNode> nodes,
                         std::vector<AStarEdge> edges,
                         Heuristic heuristic,
                         GoalTest goal_test)
    : nodes_(std::move(nodes)),
      edges_(std::move(edges)),
      heuristic_(std::move(heuristic)),
      goal_test_(std::move(goal_test)) {}

SolverMetadata AStarSolver::metadata() const {
    return {
        "astar",
        "1.0.0",
        {"point_to_point", "constrained_graph_route"},
        false,
        true
    };
}

bool AStarSolver::eligible(const MissionProblem& problem) const {
    const auto& cls = problem.problem_class;
    return cls == "point_to_point" || cls == "constrained_graph_route";
}

RunState AStarSolver::run(SolverContext& context) {
    cancelled_.store(false);

    if (!eligible(context.problem()))
        return RunState::Failed;

    if (nodes_.empty() || edges_.empty() || context.budget().max_candidates == 0)
        return RunState::Failed;

    const auto start_time = std::chrono::steady_clock::now();
    const auto budget_ms = context.budget().wall_time_ms;

    struct QueueItem {
        std::string id;
        double f;
        bool operator>(const QueueItem& other) const { return f > other.f; }
    };

    std::string start = nodes_.front().id;
    std::string goal;
    for (const auto& node : nodes_) {
        if (goal_test_(node.id)) {
            goal = node.id;
            break;
        }
    }
    if (goal.empty()) return RunState::Failed;

    std::unordered_map<std::string, std::vector<AStarEdge>> graph;
    for (const auto& edge : edges_)
        if (edge.cost >= 0.0)
            graph[edge.from].push_back(edge);

    const double inf = std::numeric_limits<double>::infinity();
    std::unordered_map<std::string, double> g;
    std::unordered_map<std::string, std::string> parent;
    std::priority_queue<QueueItem, std::vector<QueueItem>, std::greater<>> open;
    std::unordered_set<std::string> closed;

    for (const auto& node : nodes_) g[node.id] = inf;
    g[start] = 0.0;
    open.push({start, heuristic_(start, goal)});

    while (!open.empty()) {
        if (cancelled_.load() || context.cancelled())
            return RunState::Cancelled;

        if (budget_ms > 0) {
            const auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
                std::chrono::steady_clock::now() - start_time).count();
            if (static_cast<std::uint64_t>(elapsed) >= budget_ms)
                return RunState::Timeout;
        }

        const auto current = open.top();
        open.pop();
        if (closed.contains(current.id)) continue;
        closed.insert(current.id);

        if (goal_test_(current.id)) {
            std::vector<std::string> route;
            for (std::string at = current.id; !at.empty();) {
                route.push_back(at);
                const auto it = parent.find(at);
                if (it == parent.end()) break;
                at = it->second;
            }
            std::reverse(route.begin(), route.end());

            CandidateSolution candidate;
            candidate.candidate_id = "astar-" + context.problem().mission_id;
            candidate.solver_id = metadata().solver_id;
            candidate.solver_version = metadata().version;
            candidate.route_elements = std::move(route);
            candidate.estimated_time_s = g[current.id];
            candidate.estimated_energy_wh = 0.0;
            candidate.estimated_reserve_wh = 0.0;
            candidate.objective_score = g[current.id];
            candidate.feasibility = Feasibility::Feasible;
            context.publish(std::move(candidate));
            return RunState::Completed;
        }

        for (const auto& edge : graph[current.id]) {
            if (closed.contains(edge.to)) continue;
            const double tentative_g = g[current.id] + edge.cost;
            if (tentative_g < g[edge.to]) {
                g[edge.to] = tentative_g;
                parent[edge.to] = current.id;
                open.push({edge.to, tentative_g + heuristic_(edge.to, goal)});
            }
        }
    }

    return RunState::Failed;
}

void AStarSolver::cancel() {
    cancelled_.store(true);
}

} // namespace bluesky::planning
