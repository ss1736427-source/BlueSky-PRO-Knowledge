#include "algorithm_orchestrator.hpp"
#include "../model/planning_graph.hpp"
#include <cassert>
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
    const std::vector<CandidateSolution>& candidates() const { return candidates_; }
private:
    const MissionProblem& p_;
    ComputeBudget b_;
    std::vector<CandidateSolution> candidates_;
};

class FakeSolver final : public Solver {
public:
    FakeSolver(std::string id, double score, Feasibility feasibility)
        : id_(std::move(id)), score_(score), feasibility_(feasibility) {}
    SolverMetadata metadata() const override { return {id_, "test", {"point_to_point"}, false, true}; }
    bool eligible(const MissionProblem& p) const override { return p.problem_class == "point_to_point"; }
    RunState run(SolverContext& c) override {
        CandidateSolution x;
        x.candidate_id = c.problem().mission_id + ":" + id_;
        x.solver_id = id_;
        x.solver_version = "test";
        x.objective_score = score_;
        x.feasibility = feasibility_;
        c.publish(std::move(x));
        return feasibility_ == Feasibility::Feasible ? RunState::Candidate : RunState::Completed;
    }
    void cancel() override {}
private:
    std::string id_;
    double score_;
    Feasibility feasibility_;
};
}

int main() {
    PlanningGraph graph;
    graph.add_node({"A", 0, 0});
    graph.add_node({"B", 1, 0});

    MissionProblem problem;
    problem.mission_id = "ORCH-001";
    problem.problem_class = "point_to_point";
    problem.planning_graph = &graph;

    TestContext context(problem, ComputeBudget{1000, 256, 8});
    std::vector<std::unique_ptr<Solver>> solvers;
    solvers.push_back(std::make_unique<FakeSolver>("solver-safe", 10.0, Feasibility::Feasible));
    solvers.push_back(std::make_unique<FakeSolver>("solver-better", 5.0, Feasibility::Feasible));
    solvers.push_back(std::make_unique<FakeSolver>("solver-rejected", 0.0, Feasibility::Infeasible));

    AlgorithmOrchestrator orchestrator(std::move(solvers));
    const auto decision = orchestrator.solve(context);

    assert(decision.feasibility == Feasibility::Feasible);
    assert(decision.selected_solver_id == "solver-better");
    assert(decision.selected_candidate_id == "ORCH-001:solver-better");
    assert(decision.considered_solvers.size() == 3);
    return 0;
}
