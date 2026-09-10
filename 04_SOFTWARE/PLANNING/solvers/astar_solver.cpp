#include "astar_solver.hpp"

#include <algorithm>
#include <chrono>
#include <functional>
#include <limits>
#include <queue>
#include <unordered_map>
#include <unordered_set>

namespace bluesky::planning {

AStarSolver::AStarSolver(Heuristic heuristic)
    : heuristic_(std::move(heuristic)) {}

SolverMetadata AStarSolver::metadata() const {
    return {"astar", "1.1.0", {"point_to_point", "graph_route", "constrained_graph_route"}, false, true};
}

bool AStarSolver::eligible(const MissionProblem& problem) const {
    return (problem.problem_class == "point_to_point" ||
            problem.problem_class == "graph_route" ||
            problem.problem_class == "constrained_graph_route") &&
           problem.planning_graph != nullptr && static_cast<bool>(heuristic_);
}

RunState AStarSolver::run(SolverContext& context) {
    cancelled_.store(false);
    if (!eligible(context.problem())) return RunState::Failed;

    const auto& graph = *context.problem().planning_graph;
    if (graph.start_node.empty() || graph.goal_node.empty()) return RunState::Failed;
    if (context.budget().max_candidates == 0) return RunState::Failed;

    const auto started = std::chrono::steady_clock::now();
    const auto budget_ms = context.budget().wall_time_ms;
    const double inf = std::numeric_limits<double>::infinity();

    std::unordered_map<std::string, std::vector<PlanningGraphEdge>> adjacency;
    for (const auto& edge : graph.edges) {
        if (edge.cost >= 0.0) adjacency[edge.from].push_back(edge);
    }

    std::unordered_map<std::string, double> g;
    std::unordered_map<std::string, std::string> parent;
    for (const auto& node : graph.nodes) g[node] = inf;

    struct QueueItem {
        std::string id;
        double f;
        bool operator>(const QueueItem& other) const { return f > other.f; }
    };

    const auto* goal = std::find(graph.nodes.begin(), graph.nodes.end(), graph.goal_node) != graph.nodes.end()
        ? &graph.goal_node : nullptr;
    if (!goal) return RunState::Failed;

    std::priority_queue<QueueItem, std::vector<QueueItem>, std::greater<>> open;
    g[graph.start_node] = 0.0;

    const auto* start_node = std::find_if(graph.nodes.begin(), graph.nodes.end(),
        [&](const std::string& id) { return id == graph.start_node; });
    const auto* goal_node = std::find_if(graph.nodes.begin(), graph.nodes.end(),
        [&](const std::string& id) { return id == graph.goal_node; });
    if (start_node == graph.nodes.end() || goal_node == graph.nodes.end()) return RunState::Failed;

    open.push({graph.start_node, heuristic_(PlanningNode{graph.start_node, 0.0, 0.0},
                                            PlanningNode{graph.goal_node, 0.0, 0.0})});

    while (!open.empty()) {
        if (cancelled_.load() || context.cancelled()) return RunState::Cancelled;
        if (budget_ms > 0) {
            const auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
                std::chrono::steady_clock::now() - started).count();
            if (static_cast<std::uint64_t>(elapsed) >= budget_ms) return RunState::Timeout;
        }

        const auto current = open.top();
        open.pop();
        const double expected_f = g[current.id];
        if (current.id == graph.goal_node) {
            std::vector<std::string> route;
            for (std::string at = current.id; !at.empty();) {
                route.push_back(at);
                const auto it = parent.find(at);
                if (it == parent.end()) break;
                at = it->second;
            }
            std::reverse(route.begin(), route.end());

            CandidateSolution candidate;
            candidate.candidate_id = context.problem().mission_id + ":astar:1";
            candidate.solver_id = metadata().solver_id;
            candidate.solver_version = metadata().version;
            candidate.route_elements = std::move(route);
            candidate.estimated_time_s = g[current.id];
            candidate.objective_score = g[current.id];
            candidate.feasibility = Feasibility::Feasible;
            context.publish(std::move(candidate));
            return RunState::Completed;
        }

        for (const auto& edge : adjacency[current.id]) {
            const double tentative_g = g[current.id] + edge.cost;
            if (tentative_g < g[edge.to]) {
                g[edge.to] = tentative_g;
                parent[edge.to] = current.id;

                // Graph coordinates are not yet part of the MissionProblem lookup;
                // use zero-coordinate nodes here only as a safe baseline. The shared
                // graph model is the authoritative source and the coordinate-aware
                // heuristic is supplied by the caller in the next integration step.
                const PlanningNode from{edge.to, 0.0, 0.0};
                const PlanningNode to{graph.goal_node, 0.0, 0.0};
                open.push({edge.to, tentative_g + heuristic_(from, to)});
            }
        }

        (void)expected_f;
    }

    return RunState::Failed;
}

void AStarSolver::cancel() { cancelled_.store(true); }

} // namespace bluesky::planning
