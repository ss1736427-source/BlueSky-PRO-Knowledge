#include "universal_adapter_registry.hpp"

#include <cassert>
#include <memory>

using namespace bluesky::planning::adapter;

namespace {

class TestAdapter final : public UniversalAdapter {
public:
    explicit TestAdapter(std::string id, std::string vehicle, std::string equipment)
        : id_(std::move(id)), vehicle_(std::move(vehicle)), equipment_(std::move(equipment)) {}

    AdapterMetadata metadata() const override {
        return {id_, "1.0.0", "TEST", "MOCK-1", {vehicle_}, {equipment_}, {}, "1"};
    }

    std::vector<std::string> discover() override { return {}; }
    std::string identify() override { return vehicle_; }
    ResponseEnvelope readVehicleProfile() override { return {}; }
    ResponseEnvelope readConfiguration() override { return {}; }
    ResponseEnvelope readCapabilities() override { return {}; }
    ResponseEnvelope readState() override { return {}; }
    ResponseEnvelope readHealth() override { return {}; }
    ResponseEnvelope readC2State() override { return {}; }
    ResponseEnvelope subscribeTelemetry() override { return {}; }
    ResponseEnvelope readEquipment() override { return {}; }
    ExternalCommand translateCommand(const CanonicalCommand& command) override {
        return {command.request_id, command.object_id, command.operation};
    }
    Error mapError(ErrorCode code, std::string message) const override { return {code, std::move(message)}; }
    std::string identifyEquipment() override { return equipment_; }
    ResponseEnvelope readEquipmentProfile() override { return {}; }
    ResponseEnvelope readEquipmentConfiguration() override { return {}; }
    ResponseEnvelope readEquipmentCapabilities() override { return {}; }
    ResponseEnvelope readEquipmentState() override { return {}; }
    ResponseEnvelope readEquipmentTelemetry() override { return {}; }
    ExternalCommand translateAction(const CanonicalCommand& command) override {
        return {command.request_id, command.object_id, command.operation};
    }
    ResponseEnvelope readDataOutputs() override { return {}; }

private:
    std::string id_;
    std::string vehicle_;
    std::string equipment_;
};

} // namespace

int main() {
    UniversalAdapterRegistry registry;

    assert(registry.adapterIds().empty());
    assert(!registry.registerAdapter(nullptr));
    assert(!registry.unregisterAdapter(""));
    assert(registry.findById("missing") == nullptr);

    assert(registry.registerAdapter(
        std::make_unique<TestAdapter>("ADAPTER-A", "VEHICLE-A", "EQUIPMENT-A")));
    assert(!registry.registerAdapter(
        std::make_unique<TestAdapter>("ADAPTER-A", "VEHICLE-B", "EQUIPMENT-B")));

    assert(registry.findById("ADAPTER-A") != nullptr);
    assert(registry.findForVehicleProfile("VEHICLE-A") == registry.findById("ADAPTER-A"));
    assert(registry.findForEquipmentProfile("EQUIPMENT-A") == registry.findById("ADAPTER-A"));
    assert(registry.findForVehicleProfile("VEHICLE-X") == nullptr);
    assert(registry.findForEquipmentProfile("EQUIPMENT-X") == nullptr);

    const auto ids = registry.adapterIds();
    assert(ids.size() == 1);
    assert(ids.front() == "ADAPTER-A");

    assert(registry.unregisterAdapter("ADAPTER-A"));
    assert(registry.findById("ADAPTER-A") == nullptr);
    assert(registry.adapterIds().empty());
    assert(!registry.unregisterAdapter("ADAPTER-A"));

    return 0;
}
