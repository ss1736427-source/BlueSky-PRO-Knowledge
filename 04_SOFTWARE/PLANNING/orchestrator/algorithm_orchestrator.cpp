#include "algorithm_orchestrator.hpp"

#include <limits>
#include <sstream>

namespace bluesky::planning {

AlgorithmOrchestrator::AlgorithmOrchestrator(std::vector<std::unique_ptr<Solver>> solvers)
    : solvers_(std::move(solvers)) {}

OrchestratorDecision AlgorithmOrchestrator::solve(SolverContext& context) {
    OrchestratorDecision decision;
    double best_score = std::numeric_limits<double>::infinity();
    CandidateSolution best;
    bool have_best = false;

    for (auto& solver : solvers_) {
        if (!solver || !solver->eligible(context.problem())) {
            if (solver) decision.rejected_solvers.push_back(solver->metadata().solver_id);
            continue;
        }

        const auto meta = solver->metadata();
        decision.considered_solvers.push_back(meta.solver_id);

        const auto state = solver->run(context);
        (void)state;

        // Candidates are published into the shared context. The orchestrator
        // selects only candidates marked FEASIBLE and ranks their objective score.
        for (const auto& candidate : context.candidates()) {
            if (candidate.solver_id != meta.solver_id ||
                candidate.feasibility != Feasibility::Feasible) {
                continue;
            }
            if (!have_best || candidate.objective_score < best_score) {
                best_score = candidate.objective_score;
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
                << ", как лучший допустимый кандидат по текущему профилю задачи."
                << " Ограничения безопасности прошли проверку до ранжирования.";
    decision.explanation = explanation.str();
    return decision;
}

} // namespace bluesky::planning
