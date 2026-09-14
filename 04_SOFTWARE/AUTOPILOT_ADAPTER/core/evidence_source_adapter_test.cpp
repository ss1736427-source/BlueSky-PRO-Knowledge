#include "evidence_source_adapter.hpp"

#include <cassert>
#include <filesystem>
#include <fstream>
#include <string>

using namespace bluesky::verification;

int main() {
    const auto directory = std::filesystem::temp_directory_path() / "bluesky_source_adapter_test";
    std::filesystem::remove_all(directory);

    FlightEvidenceRecorder recorder(directory);
    recorder.init("SESSION-SA-001", "TEST-SA-001", "FLIGHT-SA-001",
                  "MISSION-SA-001", "CONFIG-SA-001", "2026-09-14T16:00:00Z");

    EvidenceSourceAdapter adapter;
    const SourceRecord source{
        "2026-09-14T16:00:01Z",
        "SRC-01",
        "EC-01",
        "position.latitude",
        "60.1699",
        "deg",
        "RAW-SOURCE-001"
    };

    const EvidenceEvent event = adapter.adapt(source);
    assert(event.timestamp_utc == source.timestamp_utc);
    assert(event.source_id == source.source_id);
    assert(event.evidence_domain_id == source.evidence_domain_id);
    assert(event.parameter == source.parameter);
    assert(event.value == source.value);
    assert(event.unit == source.unit);
    assert(event.raw_record_reference == source.raw_record_reference);

    recorder.collect(event);
    recorder.finalize("2026-09-14T16:00:02Z");

    std::ifstream in(directory / "events.jsonl", std::ios::binary);
    assert(in);
    std::string line;
    std::getline(in, line);
    assert(line.find("SRC-01") != std::string::npos);
    assert(line.find("EC-01") != std::string::npos);
    assert(line.find("RAW-SOURCE-001") != std::string::npos);

    std::filesystem::remove_all(directory);
    return 0;
}
