#include "ai_runtime_lifecycle.hpp"
#include <algorithm>
namespace bluesky::ai {
bool AiRuntimeLifecycle::record(const LifecycleEvent& event) noexcept {
    if (event.event_id.empty() || event.correlation_id.empty() || event.subject_id.empty() || event.sequence == 0) return false;
    for (const auto& existing : events_) {
        if (existing.event_id == event.event_id) return false;
        if (existing.correlation_id == event.correlation_id && existing.sequence == event.sequence) return false;
    }
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
