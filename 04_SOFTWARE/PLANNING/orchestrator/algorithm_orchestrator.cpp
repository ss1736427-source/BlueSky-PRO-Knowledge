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

bool supported_priority(const std::string& priority) {
    return priority == "completion_time" || priority == "time" || priority == "fast" ||
           priority == "minimum_cost" || priority == "route_efficiency" ||
           priority == "energy" || priority == "endurance" || priority == "reserve" ||
           priority == "deterministic";
}

bool objective_priorities_are_supported(const MissionProblem& problem) {
    return !problem.objective_priorities.empty() &&
           std::all_of(problem.objective_priorities.begin(),
                       problem.objective_priorities.end(),
                       supported_priority);
}

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
        has_priority(problem, "fast")) {
        if (solver_id == "astar") {
            return graph_has_heuristic_information(problem) ? 0 : 1;
        }
        return solver_id == "dijkstra" ? 0 : 1;
    }

    if (has_priority(problem, "deterministic") ||
        has_priority(problem, "minimum_cost") ||
        has_priority(problem, "route_efficiency")) {
        return solver_id == "dijkstra" ? 0 : 1;
    }

    return 0;
}

bool route_matches_graph(const CandidateSolution& candidate, const MissionProblem& problem) {
    const auto* graph = problem.planning_graph;
    if (!graph) return true;
    if (candidate.route_elements.empty()) return false;
    if (candidate.route_elements.front() != graph->start_node ||
        candidate.route_elements.back() != graph->goal_node) return false;
    if (!graph->find_node(candidate.route_elements.front()) ||
        !graph->find_node(candidate.route_elements.back())) return false;

    for (std::size_t i = 1; i < candidate.route_elements.size(); ++i) {
        const auto& from = candidate.route_elements[i - 1];
        const auto& to = candidate.route_elements[i];
        if (!graph->find_node(from) || !graph->find_node(to)) return false;

        const bool edge_exists = std::any_of(
            graph->edges.begin(), graph->edges.end(),
            [&](const PlanningGraphEdge& edge) {
                return edge.from == from && edge.to == to &&
                       std::isfinite(edge.cost) && edge.cost >= 0.0;
            });
        if (!edge_exists) return false;
    }
    return true;
}

bool valid_candidate(const CandidateSolution& candidate, const MissionProblem& problem) {
    if (candidate.feasibility != Feasibility::Feasible) return false;
    if (!candidate.constraint_violations.empty()) return false;
    if (candidate.candidate_id.empty() || candidate.solver_id.empty() ||
        candidate.solver_version.empty()) return false;
    if (candidate.route_elements.empty()) return false;
    if (std::any_of(candidate.route_elements.begin(), candidate.route_elements.end(),
                    [](const std::string& element) { return element.empty(); })) {
        return false;
    }
    if (!std::isfinite(candidate.estimated_time_s) ||
        !std::isfinite(candidate.estimated_energy_wh) ||
        !std::isfinite(candidate.estimated_reserve_wh) ||
        !std::isfinite(candidate.objective_score)) return false;
    if (candidate.estimated_time_s < 0.0 ||
        candidate.estimated_energy_wh < 0.0 ||
        candidate.estimated_reserve_wh < 0.0) return false;
    if (!route_matches_graph(candidate, problem)) return false;
    return true;
}

bool accepts_candidates(RunState state) {
    return state == RunState::Candidate || state == RunState::Completed;
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
            priority == "fast") {
            if (better_lower(candidate.estimated_time_s, current.estimated_time_s)) return true;
            if (better_lower(current.estimated_time_s, candidate.estimated_time_s)) return false;
        } else if (priority == "minimum_cost" || priority == "route_efficiency") {
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

    // Do not introduce an implicit optimization criterion after the declared priorities.
    // Once all declared objectives are tied, use stable deterministic ordering only.
    const int candidate_rank = priority_rank(problem, candidate.solver_id);
    const int current_rank = priority_rank(problem, current.solver_id);
    if (candidate_rank != current_rank) return candidate_rank < current_rank;

    return candidate.candidate_id < current.candidate_id;
}

} // namespace

AlgorithmOrchestrator::AlgorithmOrchestrator(std::vector<std::unique_ptr<Solver>> solvers)
    : solvers_(std::move(solvers)) {}

OrchestratorDecision AlgorithmOrchestrator::solve(SolverContext& context) {
    OrchestratorDecision decision;
    CandidateSolution best;
    bool have_best = false;

    if (!objective_priorities_are_supported(context.problem())) {
        decision.feasibility = Feasibility::Uncertain;
        decision.explanation = context.problem().objective_priorities.empty()
            ? "Расчёт остановлен: для задачи не определены приоритеты выбора маршрута."
            : "Расчёт остановлен: задача содержит неподдерживаемый приоритет выбора маршрута.";
        return decision;
    }

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
        if (context.cancelled()) {
            if (solver) solver->cancel();
            decision.feasibility = Feasibility::Uncertain;
            decision.explanation = "Расчёт отменён до завершения поиска допустимого маршрута.";
            return decision;
        }

        if (!solver || !solver->eligible(context.problem())) {
            if (solver) decision.rejected_solvers.push_back(solver->metadata().solver_id);
            continue;
        }

        const auto meta = solver->metadata();
        decision.considered_solvers.push_back(meta.solver_id);

        const auto state = solver->run(context);
        if (context.cancelled()) {
            solver->cancel();
            decision.feasibility = Feasibility::Uncertain;
            decision.explanation = "Расчёт отменён до завершения оценки кандидатов.";
            return decision;
        }
        if (!accepts_candidates(state)) continue;

        for (const auto& candidate : context.candidates()) {
            if (candidate.solver_id != meta.solver_id ||
                candidate.solver_version != meta.version ||
                !valid_candidate(candidate, context.problem())) {
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
