#include "../solver_contract/solver_contract.hpp"
#include "../solver_contract/solver_comparison.hpp"
#include "../solvers/astar_solver.hpp"
#include "../solvers/dijkstra_solver.hpp"

#include <cassert>
#include <chrono>
#include <cmath>
#include <iostream>
#include <vector>

namespace bluesky::planning {

class TestContext final : public SolverContext {
public:
    TestContext(MissionProblem problem, ComputeBudget budget)
        : problem_(std::move(problem)), budget_(budget) {}

    const MissionProblem& problem() const override { return problem_; }
    const ComputeBudget& budget() const override { return budget_; }
    bool cancelled() const override { return cancelled_; }
    void publish(CandidateSolution candidate) override {
        candidates.push_back(std::move(candidate));
    }

    MissionProblem problem_;
    ComputeBudget budget_;
    bool cancelled_{false};
    std::vector<CandidateSolution> candidates;
};

static PlanningGraph make_graph() {
    return {
        {"S", "A", "B", "C", "D", "G"},
        {
            {"S", "A", 2.0}, {"S", "B", 5.0},
            {"A", "B", 1.0}, {"A", "C", 2.0},
            {"B", "C", 1.0}, {"B", "D", 3.0},
            {"C", "D", 1.0}, {"C", "G", 6.0},
            {"D", "G", 1.0}
        },
        "S", "G"
    };
}

int main() {
    const auto graph = make_graph();
    MissionProblem problem{
        "benchmark-astar-dijkstra",
        "1",
        "point_to_point",
        {"UAV-01"},
        {},
        {"route_efficiency"},
        "test-environment",
        &graph
    };
    const ComputeBudget budget{1000, 128, 1};

    AStarSolver astar(
        {{"S"}, {"A"}, {"B"}, {"C"}, {"D"}, {"G"}},
        {{"S", "A", 2.0}, {"S", "B", 5.0}, {"A", "B", 1.0},
         {"A", "C", 2.0}, {"B", "C", 1.0}, {"B", "D", 3.0},
         {"C", "D", 1.0}, {"C", "G", 6.0}, {"D", "G", 1.0}},
        [](const std::string&, const std::string&) { return 0.0; },
        [](const std::string& id) { return id == "G"; });

    DijkstraSolver dijkstra;

    TestContext a_ctx(problem, budget);
    TestContext d_ctx(problem, budget);

    const auto a_start = std::chrono::steady_clock::now();
    const auto a_state = astar.run(a_ctx);
    const auto a_ms = std::chrono::duration_cast<std::chrono::microseconds>(
        std::chrono::steady_clock::now() - a_start).count();

    const auto d_start = std::chrono::steady_clock::now();
    const auto d_state = dijkstra.run(d_ctx);
    const auto d_ms = std::chrono::duration_cast<std::chrono::microseconds>(
        std::chrono::steady_clock::now() - d_start).count();

    assert(a_state == RunState::Completed);
    assert(d_state == RunState::Completed);
    assert(a_ctx.candidates.size() == 1);
    assert(d_ctx.candidates.size() == 1);

    const auto& a = a_ctx.candidates.front();
    const auto& d = d_ctx.candidates.front();
    assert(a.feasibility == Feasibility::Feasible);
    assert(d.feasibility == Feasibility::Feasible);
    assert(std::fabs(a.estimated_time_s - d.estimated_time_s) < 1e-9);
    assert(a.route_elements == d.route_elements);

    const auto* best = SolverCandidateEvaluator::best(a, d, 0.0, 100000.0);
    assert(best != nullptr);

    std::cout << "A* route cost: " << a.estimated_time_s
              << ", time(us): " << a_ms << '\n';
    std::cout << "Dijkstra route cost: " << d.estimated_time_s
              << ", time(us): " << d_ms << '\n';
    std::cout << "Benchmark: PASS\n";
    return 0;
}

} // namespace bluesky::planning

int main() {
    return bluesky::planning::main();
}
