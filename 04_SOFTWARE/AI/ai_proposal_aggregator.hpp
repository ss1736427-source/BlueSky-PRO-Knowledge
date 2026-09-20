#pragma once
#include "ai_orchestration_boundary.hpp"
#include <string>
namespace bluesky::ai {
struct ProposalSubmission { Proposal proposal; std::string source_result_id; std::string proposal_digest; };
class ProposalAggregator final {
public:
 bool submit(const ProposalSubmission&);
 const ProposalSubmission* get(const std::string&) const noexcept;
private:
 std::unordered_map<std::string, ProposalSubmission> proposals_;
};
}
