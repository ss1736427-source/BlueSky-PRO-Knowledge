#pragma once

#include "../solver_contract/solver_contract.hpp"
#include <memory>
#include <string>
#include <vector>

namespace bluesky::planning {

struct OrchestratorDecision {
    Feasibility feasibility{Feasibility::Uncertain};
    std::string selected_solver_id;
    std::string selected_candidate_id;
    std::vector<std::string> considered_solvers;
    std::vector<std::string> rejected_solvers;
    std::string explanation;
};

class AlgorithmOrchestrator {
public:
    explicit AlgorithmOrchestrator(std::vector<std::unique_ptr<Solver>> solvers);

    OrchestratorDecision solve(SolverContext& context);

private:
    std::vector<std::unique_ptr<Solver>> solvers_;
};

} // namespace bluesky::planning
