#pragma once

#include "autopilot_adapter_baseline.hpp"

#include <optional>
#include <string>

namespace bluesky::autopilot {

// Representative protocol-specific adapter. MAVLink2 framing is modeled at
// the boundary; no real transport or aircraft is implied.
class Mavlink2Adapter final : public AutopilotAdapterBaseline {
public:
    explicit Mavlink2Adapter(Identity identity);

    static constexpr const char* kProtocol = "MAVLink2";
    static constexpr const char* kProtocolVersion = "2";

    std::string encodeCommand(const CommandResult& result) const;
    std::optional<CommandResult> decodeCommandAck(const std::string& frame) const;
    std::string encodeMissionReadback(const std::string& mission) const;
    std::optional<std::string> decodeMissionReadback(const std::string& frame) const;
};

} // namespace bluesky::autopilot
