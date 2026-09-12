#include "universal_adapter_registry.hpp"

#include <algorithm>

namespace bluesky::planning::adapter {

bool UniversalAdapterRegistry::registerAdapter(std::unique_ptr<UniversalAdapter> adapter) {
    if (!adapter) return false;

    const auto id = adapter->metadata().adapter_id;
    if (id.empty() || findById(id) != nullptr) return false;

    adapters_.push_back(std::move(adapter));
    return true;
}

bool UniversalAdapterRegistry::unregisterAdapter(const std::string& adapter_id) {
    if (adapter_id.empty()) return false;

    const auto it = std::find_if(
        adapters_.begin(), adapters_.end(),
        [&](const std::unique_ptr<UniversalAdapter>& adapter) {
            return adapter && adapter->metadata().adapter_id == adapter_id;
        });

    if (it == adapters_.end()) return false;
    adapters_.erase(it);
    return true;
}

UniversalAdapter* UniversalAdapterRegistry::findById(const std::string& adapter_id) const {
    if (adapter_id.empty()) return nullptr;

    const auto it = std::find_if(
        adapters_.begin(), adapters_.end(),
        [&](const std::unique_ptr<UniversalAdapter>& adapter) {
            return adapter && adapter->metadata().adapter_id == adapter_id;
        });

    return it == adapters_.end() ? nullptr : it->get();
}

UniversalAdapter* UniversalAdapterRegistry::findForVehicleProfile(
    const std::string& vehicle_profile) const {
    if (vehicle_profile.empty()) return nullptr;

    const auto it = std::find_if(
        adapters_.begin(), adapters_.end(),
        [&](const std::unique_ptr<UniversalAdapter>& adapter) {
            if (!adapter) return false;
            const auto& profiles = adapter->metadata().supported_vehicle_profiles;
            return std::find(profiles.begin(), profiles.end(), vehicle_profile) != profiles.end();
        });

    return it == adapters_.end() ? nullptr : it->get();
}

UniversalAdapter* UniversalAdapterRegistry::findForEquipmentProfile(
    const std::string& equipment_profile) const {
    if (equipment_profile.empty()) return nullptr;

    const auto it = std::find_if(
        adapters_.begin(), adapters_.end(),
        [&](const std::unique_ptr<UniversalAdapter>& adapter) {
            if (!adapter) return false;
            const auto& profiles = adapter->metadata().supported_equipment_profiles;
            return std::find(profiles.begin(), profiles.end(), equipment_profile) != profiles.end();
        });

    return it == adapters_.end() ? nullptr : it->get();
}

UniversalAdapter* UniversalAdapterRegistry::findForCapability(
    const std::string& capability) const {
    if (capability.empty()) return nullptr;

    const auto it = std::find_if(
        adapters_.begin(), adapters_.end(),
        [&](const std::unique_ptr<UniversalAdapter>& adapter) {
            if (!adapter) return false;
            const auto& capabilities = adapter->metadata().capabilities;
            return std::find(capabilities.begin(), capabilities.end(), capability) != capabilities.end();
        });

    return it == adapters_.end() ? nullptr : it->get();
}

std::vector<std::string> UniversalAdapterRegistry::adapterIds() const {
    std::vector<std::string> result;
    result.reserve(adapters_.size());

    for (const auto& adapter : adapters_) {
        if (adapter) result.push_back(adapter->metadata().adapter_id);
    }

    return result;
}

} // namespace bluesky::planning::adapter
