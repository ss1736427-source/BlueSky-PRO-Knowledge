#pragma once

#include "universal_adapter.hpp"

#include <memory>
#include <string>
#include <vector>

namespace bluesky::planning::adapter {

class UniversalAdapterRegistry {
public:
    bool registerAdapter(std::unique_ptr<UniversalAdapter> adapter);
    bool unregisterAdapter(const std::string& adapter_id);

    UniversalAdapter* findById(const std::string& adapter_id) const;
    UniversalAdapter* findForVehicleProfile(const std::string& vehicle_profile) const;
    UniversalAdapter* findForEquipmentProfile(const std::string& equipment_profile) const;

    std::vector<std::string> adapterIds() const;

private:
    std::vector<std::unique_ptr<UniversalAdapter>> adapters_;
};

} // namespace bluesky::planning::adapter
