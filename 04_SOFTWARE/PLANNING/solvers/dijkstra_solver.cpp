#include "dijkstra_solver.hpp"

#include <chrono>
#include <functional>
#include <limits>
#include <queue>
#include <unordered_map>
#include <unordered_set>

namespace bluesky::planning {

SolverMetadata DijkstraSolver::metadata() const {
    return SolverMetadata{
        "dijkstra",
        "0.1.0",
        {"point_to_point", "graph_route", "constrained_route"},
        false,
        true
    };
}

bool DijkstraSolver::eligible(const MissionProblem& problem) const {
    return problem.problem_class == "point_to_point" ||
           problem.problem_class == "graph_route" ||
           problem.problem_class == "constrained_route";
}

RunState DijkstraSolver::run(SolverContext& context) {
    cancelled_.store(false);

    const auto started = std::chrono::steady_clock::now();
    const auto limit = context.budget().wall_time_ms;

    if (!eligible(context.problem())) {
        return RunState::Failed;
    }

    // The current contract does not yet expose a graph in MissionProblem.
    // Therefore this implementation establishes the deterministic solver
    // lifecycle and returns a controlled PARTIAL result until the normalized
    // planning graph is added to the shared problem model.
    if (cancelled_.load() || context.cancelled()) {
        return RunState::Cancelled;
    }

    if (limit != 0 &&
        std::chrono::duration_cast<std::chrono::milliseconds>(
            std::chrono::steady_clock::now() - started).count() >= limit) {
        return RunState::Timeout;
    }

    CandidateSolution candidate;
    candidate.candidate_id = context.problem().mission_id + ":dijkstra:partial";
    candidate.solver_id = metadata().solver_id;
    candidate.solver_version = metadata().version;
    candidate.feasibility = Feasibility::Partial;
    candidate.objective_score = 0.0;

    context.publish(std::move(candidate));
    return RunState::Candidate;
}

void DijkstraSolver::cancel() {
    cancelled_.store(true);
}

} // namespace bluesky::planning
