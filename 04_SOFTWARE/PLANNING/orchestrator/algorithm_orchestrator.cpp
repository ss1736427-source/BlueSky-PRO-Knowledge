#include "algorithm_orchestrator.hpp"

#include <algorithm>
#include <cmath>
#include <limits>
#include <sstream>
#include <string>

namespace bluesky::planning {

namespace {

bool has_priority(const MissionProblem& problem, const std::string& token) {
    return std::find(problem.objective_priorities.begin(),
                     problem.objective_priorities.end(), token) !=
           problem.objective_priorities.end();
}

// A* is useful only when the supplied graph geometry gives its heuristic
// information. If start and goal coincide, Euclidean h is zero everywhere
// for this model and Dijkstra is the appropriate deterministic ordering.
bool graph_has_heuristic_information(const MissionProblem& problem) {
    if (!problem.planning_graph) return false;

    const auto* start = problem.planning_graph->find_node(problem.planning_graph->start_node);
    const auto* goal = problem.planning_graph->find_node(problem.planning_graph->goal_node);
    if (!start || !goal) return false;

    const double dx = start->x - goal->x;
    const double dy = start->y - goal->y;
    return std::sqrt(dx * dx + dy * dy) > 1e-9;
}

int priority_rank(const MissionProblem& problem, const std::string& solver_id) {
    if (has_priority(problem, "completion_time") ||
        has_priority(problem, "time") ||
        has_priority(problem, "fast") ||
        has_priority(problem, "route_efficiency")) {
        if (solver_id == "astar") {
            return graph_has_heuristic_information(problem) ? 0 : 1;
        }
        return solver_id == "dijkstra" ? 0 : 1;
    }

    if (has_priority(problem, "deterministic") || has_priority(problem, "minimum_cost")) {
        return solver_id == "dijkstra" ? 0 : 1;
    }

    return 0;
}

bool valid_candidate(const CandidateSolution& candidate) {
    if (candidate.feasibility != Feasibility::Feasible) return false;
    if (candidate.candidate_id.empty() || candidate.solver_id.empty()) return false;
    if (candidate.route_elements.empty()) return false;
    if (!std::isfinite(candidate.estimated_time_s) ||
        !std::isfinite(candidate.estimated_energy_wh) ||
        !std::isfinite(candidate.estimated_reserve_wh) ||
        !std::isfinite(candidate.objective_score)) return false;
    if (candidate.estimated_time_s < 0.0 ||
        candidate.estimated_energy_wh < 0.0 ||
        candidate.estimated_reserve_wh < 0.0) return false;
    return true;
}

bool better_candidate(const CandidateSolution& candidate,
                      const CandidateSolution& current,
                      const MissionProblem& problem) {
    const auto better_lower = [](double lhs, double rhs) {
        return lhs + 1e-9 < rhs;
    };
    const auto better_higher = [](double lhs, double rhs) {
        return lhs > rhs + 1e-9;
    };

    for (const auto& priority : problem.objective_priorities) {
        if (priority == "completion_time" || priority == "time" ||
            priority == "fast" || priority == "route_efficiency") {
            if (better_lower(candidate.estimated_time_s, current.estimated_time_s)) return true;
            if (better_lower(current.estimated_time_s, candidate.estimated_time_s)) return false;
        } else if (priority == "minimum_cost") {
            if (better_lower(candidate.objective_score, current.objective_score)) return true;
            if (better_lower(current.objective_score, candidate.objective_score)) return false;
        } else if (priority == "energy") {
            if (better_lower(candidate.estimated_energy_wh, current.estimated_energy_wh)) return true;
            if (better_lower(current.estimated_energy_wh, candidate.estimated_energy_wh)) return false;
        } else if (priority == "endurance" || priority == "reserve") {
            if (better_higher(candidate.estimated_reserve_wh, current.estimated_reserve_wh)) return true;
            if (better_higher(current.estimated_reserve_wh, candidate.estimated_reserve_wh)) return false;
        }
    }

    if (candidate.objective_score + 1e-9 < current.objective_score) return true;
    if (current.objective_score + 1e-9 < candidate.objective_score) return false;

    return priority_rank(problem, candidate.solver_id) <
           priority_rank(problem, current.solver_id);
}

} // namespace

AlgorithmOrchestrator::AlgorithmOrchestrator(std::vector<std::unique_ptr<Solver>> solvers)
    : solvers_(std::move(solvers)) {}

OrchestratorDecision AlgorithmOrchestrator::solve(SolverContext& context) {
    OrchestratorDecision decision;
    CandidateSolution best;
    bool have_best = false;

    // Mission profile and graph characteristics define a deterministic solver
    // preference. The preferred solver is evaluated first, while all eligible
    // solvers remain available so that the final decision is candidate-based.
    std::stable_sort(solvers_.begin(), solvers_.end(),
                     [&context](const std::unique_ptr<Solver>& lhs,
                                const std::unique_ptr<Solver>& rhs) {
                         if (!lhs) return false;
                         if (!rhs) return true;
                         const int lrank = priority_rank(context.problem(), lhs->metadata().solver_id);
                         const int rrank = priority_rank(context.problem(), rhs->metadata().solver_id);
                         return lrank < rrank;
                     });

    for (auto& solver : solvers_) {
        if (!solver || !solver->eligible(context.problem())) {
            if (solver) decision.rejected_solvers.push_back(solver->metadata().solver_id);
            continue;
        }

        const auto meta = solver->metadata();
        decision.considered_solvers.push_back(meta.solver_id);

        const auto state = solver->run(context);
        (void)state;

        for (const auto& candidate : context.candidates()) {
            if (candidate.solver_id != meta.solver_id || !valid_candidate(candidate)) {
                continue;
            }
            if (!have_best || better_candidate(candidate, best, context.problem())) {
                best = candidate;
                have_best = true;
            }
        }
    }

    if (!have_best) {
        decision.feasibility = Feasibility::Infeasible;
        decision.explanation = "Допустимый маршрут не найден доступными алгоритмами.";
        return decision;
    }

    decision.feasibility = Feasibility::Feasible;
    decision.selected_solver_id = best.solver_id;
    decision.selected_candidate_id = best.candidate_id;

    std::ostringstream explanation;
    explanation << "Выбран маршрут, рассчитанный алгоритмом " << best.solver_id
                << ", как лучший допустимый кандидат с учётом приоритетов текущей задачи."
                << " Ограничения безопасности прошли проверку до ранжирования.";
    decision.explanation = explanation.str();
    return decision;
}

} // namespace bluesky::planning
