#include "universal_equipment_adapter.hpp"

#include <cassert>
#include <type_traits>

namespace {

class ContractEquipmentAdapter final : public bluesky::equipment::UniversalEquipmentAdapter {
public:
    bluesky::equipment::Identity identify() const override { return {}; }
    std::string readProfile() const override { return {}; }
    std::string readConfiguration() const override { return {}; }
    std::vector<bluesky::equipment::Capability> readCapabilities() const override { return {}; }
    bluesky::equipment::EquipmentState readState() const override {
        return bluesky::equipment::EquipmentState::Ready;
    }
    std::optional<bluesky::equipment::Telemetry> readTelemetry() const override {
        return std::nullopt;
    }
    bluesky::equipment::ActionResult translateAction(const std::string&) override { return {}; }
    std::vector<bluesky::equipment::DataOutput> readDataOutputs() const override { return {}; }
};

} // namespace

int main() {
    static_assert(std::is_abstract_v<bluesky::equipment::UniversalEquipmentAdapter>);
    ContractEquipmentAdapter adapter;

    assert(adapter.readState() == bluesky::equipment::EquipmentState::Ready);
    assert(adapter.readProfile().empty());
    assert(adapter.readConfiguration().empty());
    assert(!adapter.readTelemetry().has_value());

    return 0;
}
