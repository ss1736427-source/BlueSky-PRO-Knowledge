#include "algorithm_orchestrator.hpp"
#include "../model/planning_graph.hpp"
#include "../solvers/astar_solver.hpp"
#include "../solvers/dijkstra_solver.hpp"

#include <cassert>
#include <cmath>
#include <memory>
#include <vector>

using namespace bluesky::planning;

namespace {
class TestContext final : public SolverContext {
public:
    TestContext(const MissionProblem& p, ComputeBudget b) : p_(p), b_(b) {}
    const MissionProblem& problem() const override { return p_; }
    const ComputeBudget& budget() const override { return b_; }
    bool cancelled() const override { return false; }
    void publish(CandidateSolution c) override { candidates_.push_back(std::move(c)); }
    const std::vector<CandidateSolution>& candidates() const override { return candidates_; }
private:
    const MissionProblem& p_;
    ComputeBudget b_;
    std::vector<CandidateSolution> candidates_;
};

std::vector<std::unique_ptr<Solver>> make_solvers() {
    auto heuristic = [](const PlanningNode& from, const PlanningNode& to) {
        const double dx = from.x - to.x;
        const double dy = from.y - to.y;
        return std::sqrt(dx * dx + dy * dy);
    };
    std::vector<std::unique_ptr<Solver>> solvers;
    solvers.push_back(std::make_unique<AStarSolver>(heuristic));
    solvers.push_back(std::make_unique<DijkstraSolver>());
    return solvers;
}
}

int main() {
    PlanningGraph graph;
    graph.nodes.push_back({"A", 0, 0});
    graph.nodes.push_back({"B", 1, 0});
    graph.nodes.push_back({"C", 0, 1});
    graph.nodes.push_back({"D", 1, 1});
    graph.edges = {
        {"A", "B", 10.0},
        {"A", "C", 2.0},
        {"C", "D", 2.0},
        {"D", "B", 1.0}
    };
    graph.start_node = "A";
    graph.goal_node = "B";

    MissionProblem problem;
    problem.mission_id = "ORCH-REAL-001";
    problem.problem_class = "point_to_point";
    problem.planning_graph = &graph;
    problem.objective_priorities = {"completion_time"};

    // Real graph geometry contains useful heuristic information, so A* is
    // evaluated first for the time-critical mission profile.
    TestContext context(problem, ComputeBudget{1000, 256, 8});
    AlgorithmOrchestrator orchestrator(make_solvers());
    const auto decision = orchestrator.solve(context);

    assert(decision.feasibility == Feasibility::Feasible);
    assert(decision.considered_solvers.size() == 2);
    assert(decision.considered_solvers[0] == "astar");
    assert(decision.considered_solvers[1] == "dijkstra");
    assert(decision.selected_solver_id == "astar");
    assert(decision.selected_candidate_id == "ORCH-REAL-001:astar:1");
    assert(context.candidates().size() == 2);
    assert(std::abs(context.candidates()[0].estimated_time_s - 5.0) < 1e-9);
    assert(std::abs(context.candidates()[1].estimated_time_s - 5.0) < 1e-9);

    // Mission-profile change: minimum-cost profile prefers Dijkstra and
    // therefore evaluates it first; final selection remains candidate-based.
    MissionProblem cost_problem = problem;
    cost_problem.mission_id = "ORCH-PROFILE-002";
    cost_problem.objective_priorities = {"minimum_cost"};
    TestContext cost_context(cost_problem, ComputeBudget{1000, 256, 8});
    AlgorithmOrchestrator cost_orchestrator(make_solvers());
    const auto cost_decision = cost_orchestrator.solve(cost_context);

    assert(cost_decision.feasibility == Feasibility::Feasible);
    assert(cost_decision.considered_solvers.size() == 2);
    assert(cost_decision.considered_solvers[0] == "dijkstra");
    assert(cost_decision.considered_solvers[1] == "astar");
    assert(cost_decision.selected_solver_id == "dijkstra");
    assert(cost_decision.selected_candidate_id == "ORCH-PROFILE-002:dijkstra:1");
    assert(cost_context.candidates().size() == 2);

    // Graph characteristic change: start and goal coincide, so the Euclidean
    // heuristic carries no information. Dijkstra becomes the preferred
    // deterministic ordering even though A* remains eligible.
    PlanningGraph zero_information_graph = graph;
    zero_information_graph.nodes[1].x = 0.0;
    zero_information_graph.nodes[1].y = 0.0;
    zero_information_graph.start_node = "A";
    zero_information_graph.goal_node = "B";

    MissionProblem zero_information_problem = problem;
    zero_information_problem.mission_id = "ORCH-GRAPH-003";
    zero_information_problem.planning_graph = &zero_information_graph;
    TestContext zero_information_context(
        zero_information_problem, ComputeBudget{1000, 256, 8});
    AlgorithmOrchestrator zero_information_orchestrator(make_solvers());
    const auto zero_information_decision = zero_information_orchestrator.solve(zero_information_context);

    assert(zero_information_decision.feasibility == Feasibility::Feasible);
    assert(zero_information_decision.considered_solvers.size() == 2);
    assert(zero_information_decision.considered_solvers[0] == "dijkstra");
    assert(zero_information_decision.considered_solvers[1] == "astar");
    assert(zero_information_decision.selected_solver_id == "dijkstra");
    assert(zero_information_decision.selected_candidate_id == "ORCH-GRAPH-003:dijkstra:1");
    assert(zero_information_context.candidates().size() == 2);

    // Condition change: A* has no heuristic and becomes ineligible; Dijkstra must be selected.
    MissionProblem no_heuristic_problem = problem;
    no_heuristic_problem.mission_id = "ORCH-CONDITION-004";
    TestContext fallback_context(no_heuristic_problem, ComputeBudget{1000, 256, 8});
    std::vector<std::unique_ptr<Solver>> fallback_solvers;
    fallback_solvers.push_back(std::make_unique<AStarSolver>(AStarSolver::Heuristic{}));
    fallback_solvers.push_back(std::make_unique<DijkstraSolver>());

    AlgorithmOrchestrator fallback_orchestrator(std::move(fallback_solvers));
    const auto fallback_decision = fallback_orchestrator.solve(fallback_context);

    assert(fallback_decision.feasibility == Feasibility::Feasible);
    assert(fallback_decision.considered_solvers.size() == 1);
    assert(fallback_decision.considered_solvers[0] == "dijkstra");
    assert(fallback_decision.selected_solver_id == "dijkstra");
    assert(fallback_decision.selected_candidate_id == "ORCH-CONDITION-004:dijkstra:1");
    assert(fallback_context.candidates().size() == 1);
    assert(std::abs(fallback_context.candidates()[0].objective_score - 5.0) < 1e-9);

    return 0;
}
