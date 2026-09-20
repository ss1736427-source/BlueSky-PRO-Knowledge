#include "ai_runtime_lifecycle.hpp"
#include <algorithm>
namespace bluesky::ai {
TraceStage AiRuntimeLifecycle::trace_stage(LifecycleEventKind kind) noexcept {
    switch (kind) {
        case LifecycleEventKind::SystemEvent:
        case LifecycleEventKind::RecoveryStarted:
        case LifecycleEventKind::RecoveryAccepted:
        case LifecycleEventKind::RecoveryRejected: return TraceStage::SystemEvent;
        case LifecycleEventKind::TaskCreated: return TraceStage::AiTask;
        case LifecycleEventKind::TaskAssigned: return TraceStage::Orchestrator;
        case LifecycleEventKind::AgentResultAccepted: return TraceStage::Agent;
        case LifecycleEventKind::ProposalCreated:
        case LifecycleEventKind::ProposalSubmitted: return TraceStage::Proposal;
        case LifecycleEventKind::TaskCompleted:
        case LifecycleEventKind::TaskConflicted:
        case LifecycleEventKind::TaskTimedOut:
        case LifecycleEventKind::TaskFailed: return TraceStage::Result;
    }
    return TraceStage::SystemEvent;
}
bool AiRuntimeLifecycle::record(const LifecycleEvent& event) noexcept {
    if (event.event_id.empty() || event.correlation_id.empty() || event.subject_id.empty() || event.sequence == 0) return false;
    for (const auto& existing : events_) {
        if (existing.event_id == event.event_id) return false;
        if (existing.correlation_id == event.correlation_id && existing.sequence == event.sequence) return false;
    }
    TraceEvent trace_event{event.event_id,event.correlation_id,trace_stage(event.kind),event.subject_id,
                           "seq:" + std::to_string(event.sequence),
                           "lifecycle-sequence:" + std::to_string(event.sequence)};
    if (!runtime_.append_trace(trace_event)) return false;
    events_.push_back(event);
    return true;
}
std::vector<LifecycleEvent> AiRuntimeLifecycle::events_for(const std::string& correlation_id) const {
    std::vector<LifecycleEvent> result;
    for (const auto& event : events_) if (event.correlation_id == correlation_id) result.push_back(event);
    std::sort(result.begin(), result.end(), [](const LifecycleEvent& a, const LifecycleEvent& b){ return a.sequence < b.sequence; });
    return result;
}
bool AiRuntimeLifecycle::validate_sequence(const std::string& correlation_id) const noexcept {
    const auto events = events_for(correlation_id);
    if (events.empty()) return false;
    for (std::size_t i=1; i<events.size(); ++i) if (events[i].sequence != events[i-1].sequence+1) return false;
    const auto terminal=events.back().kind;
    return terminal==LifecycleEventKind::TaskCompleted || terminal==LifecycleEventKind::TaskConflicted ||
           terminal==LifecycleEventKind::TaskTimedOut || terminal==LifecycleEventKind::TaskFailed ||
           terminal==LifecycleEventKind::RecoveryAccepted || terminal==LifecycleEventKind::RecoveryRejected;
}
} // namespace bluesky::ai
