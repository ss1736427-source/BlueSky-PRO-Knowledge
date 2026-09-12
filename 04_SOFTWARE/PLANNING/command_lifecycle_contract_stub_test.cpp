#include "command_lifecycle_contract_stub.hpp"

#include <cassert>
#include <type_traits>
#include <utility>

namespace {

class TestCommandLifecycle final : public bluesky::planning::command::CommandLifecycleContract {
public:
    bluesky::planning::command::CommandTransition validate(
        const bluesky::planning::command::CommandRequest&) override {
        return {bluesky::planning::command::CommandState::Validating, 10, ""};
    }

    bluesky::planning::command::CommandTransition dispatch(
        const bluesky::planning::command::CommandRequest&) override {
        return {bluesky::planning::command::CommandState::Dispatched, 20, ""};
    }

    bluesky::planning::command::CommandTransition acknowledge(
        const bluesky::planning::command::CommandRequest&) override {
        return {bluesky::planning::command::CommandState::Acknowledged, 30, ""};
    }

    bluesky::planning::command::CommandTransition complete(
        const bluesky::planning::command::CommandRequest&) override {
        return {bluesky::planning::command::CommandState::Completed, 40, ""};
    }

    bluesky::planning::command::CommandTransition fail(
        const bluesky::planning::command::CommandRequest&, std::string reason) override {
        return {bluesky::planning::command::CommandState::Failed, 50, std::move(reason)};
    }

    bluesky::planning::command::CommandTransition cancel(
        const bluesky::planning::command::CommandRequest&, std::string reason) override {
        return {bluesky::planning::command::CommandState::Cancelled, 60, std::move(reason)};
    }

    bluesky::planning::command::CommandTransition timeout(
        const bluesky::planning::command::CommandRequest&) override {
        return {bluesky::planning::command::CommandState::Timeout, 70, ""};
    }

    bluesky::planning::command::CommandTransition unknown(
        const bluesky::planning::command::CommandRequest&, std::string reason) override {
        return {bluesky::planning::command::CommandState::Unknown, 80, std::move(reason)};
    }
};

} // namespace

int main() {
    static_assert(std::is_abstract_v<bluesky::planning::command::CommandLifecycleContract>);

    TestCommandLifecycle lifecycle;
    const bluesky::planning::command::CommandRequest request{
        "CMD-TEST-001", "MISSION-001", "VEH-TEST-001", "TAKEOFF", "{}", "BLUE_SKY", 1, "CORR-001"};

    assert(lifecycle.validate(request).state == bluesky::planning::command::CommandState::Validating);
    assert(lifecycle.dispatch(request).state == bluesky::planning::command::CommandState::Dispatched);
    assert(lifecycle.acknowledge(request).state == bluesky::planning::command::CommandState::Acknowledged);
    assert(lifecycle.complete(request).state == bluesky::planning::command::CommandState::Completed);
    assert(lifecycle.fail(request, "test failure").reason == "test failure");
    assert(lifecycle.cancel(request, "test cancellation").reason == "test cancellation");
    assert(lifecycle.timeout(request).state == bluesky::planning::command::CommandState::Timeout);
    assert(lifecycle.unknown(request, "link lost").reason == "link lost");

    const bluesky::planning::command::CommandResult result{
        bluesky::planning::command::CommandState::Completed, true, true, "confirmed"};
    assert(result.vehicle_acknowledged);
    assert(result.execution_confirmed);

    return 0;
}
