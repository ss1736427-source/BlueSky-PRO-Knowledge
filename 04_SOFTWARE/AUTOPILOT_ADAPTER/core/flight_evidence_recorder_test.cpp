#include "flight_evidence_recorder.hpp"

#include <cassert>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <string>

int main() {
    const auto root = std::filesystem::temp_directory_path() / "bluesky_ec14_recorder_test";
    std::filesystem::remove_all(root);

    bluesky::verification::FlightEvidenceRecorder recorder(root);
    recorder.init("SES-001", "TR-001", "FR-001", "MIS-001", "CFG-001", "2026-09-14T07:00:00Z");
    recorder.collect({"2026-09-14T07:00:01Z", "SRC-01", "EC-01", "link_state", "connected", "", "RAW-001"});
    recorder.collect({"2026-09-14T07:00:02Z", "SRC-02", "EC-02", "altitude", "120.5", "m", "RAW-002"});
    recorder.finalize("2026-09-14T07:00:03Z");

    assert(std::filesystem::exists(root / "record.json"));
    assert(std::filesystem::exists(root / "events.jsonl"));

    std::ifstream raw(root / "events.jsonl", std::ios::binary);
    const std::string original((std::istreambuf_iterator<char>(raw)), {});

    bluesky::verification::FlightEvidenceReplay replay(root);
    const auto events = replay.readAll();
    assert(events.size() == 2);
    assert(events[0].find("RAW-001") != std::string::npos);
    assert(events[1].find("RAW-002") != std::string::npos);

    std::ifstream raw_after(root / "events.jsonl", std::ios::binary);
    const std::string unchanged((std::istreambuf_iterator<char>(raw_after)), {});
    assert(original == unchanged);

    std::filesystem::remove_all(root);
    return 0;
}
