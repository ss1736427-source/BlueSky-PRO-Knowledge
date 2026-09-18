#include "mavlink_recorded_stream.hpp"

#include <sstream>

namespace bluesky::operations {

MavlinkRecordedStream MavlinkRecordedStreamReader::read(
    const std::string& stream_id,
    const std::string& fixture) {
    MavlinkRecordedStream stream;
    stream.stream_id = stream_id;

    std::istringstream input(fixture);
    std::string line;
    bool header_seen = false;

    while (std::getline(input, line)) {
        if (line.empty() || line[0] == '#') continue;

        std::istringstream fields(line);
        std::string version, dialect, kind, vehicle_id, source_id;
        int system_id = 0, component_id = 0, healthy = 0, valid = 0;
        std::int64_t source_timestamp_ms = 0, received_timestamp_ms = 0;

        if (line.rfind("BLUESKY-MAVLINK-REC,", 0) == 0) {
            const auto comma = line.find(',');
            stream.format_version = line.substr(comma + 1);
            header_seen = true;
            continue;
        }

        if (!header_seen) continue;

        if (!(fields >> version >> dialect >> kind >> vehicle_id >> source_id
              >> system_id >> component_id >> source_timestamp_ms
              >> received_timestamp_ms >> healthy >> valid)) {
            continue;
        }

        if (version != stream.format_version) continue;

        DecodedMavlinkMessage message;
        message.dialect = dialect == "ArduPilot"
            ? MavlinkDialect::ArduPilot : MavlinkDialect::PX4;

        if (kind == "HEARTBEAT") message.kind = MavlinkMessageKind::Heartbeat;
        else if (kind == "GLOBAL_POSITION_INT") message.kind = MavlinkMessageKind::GlobalPositionInt;
        else if (kind == "ATTITUDE") message.kind = MavlinkMessageKind::Attitude;
        else if (kind == "SYS_STATUS") message.kind = MavlinkMessageKind::SysStatus;
        else if (kind == "MISSION_STATE") message.kind = MavlinkMessageKind::MissionState;
        else continue;

        message.vehicle_id = vehicle_id;
        message.source_id = source_id;
        message.system_id = static_cast<std::uint8_t>(system_id);
        message.component_id = static_cast<std::uint8_t>(component_id);
        message.source_timestamp_ms = source_timestamp_ms;
        message.received_timestamp_ms = received_timestamp_ms;
        message.healthy = healthy != 0;
        message.valid = valid != 0;
        stream.messages.push_back(message);
    }

    return stream;
}

} // namespace bluesky::operations
