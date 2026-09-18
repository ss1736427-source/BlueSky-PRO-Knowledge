#include "mavlink_transport_channel_runtime.hpp"

#ifdef NDEBUG
#undef NDEBUG
#endif
#include <cassert>
#include <cstdint>
#include <iostream>
#include <vector>

static void crc(std::uint8_t d, std::uint16_t& c) {
    auto t = static_cast<std::uint8_t>(
        d ^ static_cast<std::uint8_t>(c & 255));
    auto t2 = static_cast<std::uint8_t>(
        t ^ static_cast<std::uint8_t>(t << 4));
    c = static_cast<std::uint16_t>(
        (c >> 8) ^
        (static_cast<std::uint16_t>(t2) << 8) ^
        (static_cast<std::uint16_t>(t2) << 3) ^
        (static_cast<std::uint16_t>(t2) >> 4));
}

static std::vector<std::uint8_t> heartbeat(
    std::uint8_t seq, std::uint8_t health = 3) {
    std::vector<std::uint8_t> f{
        0xFD, 9, 0, 0, seq, 1, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, health, 0, 0, 0};
    std::uint16_t c = 0xffff;
    for (std::size_t i = 1; i < f.size() - 2; ++i) crc(f[i], c);
    crc(50, c);
    f[f.size() - 2] = static_cast<std::uint8_t>(c);
    f[f.size() - 1] = static_cast<std::uint8_t>(c >> 8);
    return f;
}

using namespace bluesky::operations;

static MavlinkTransportChannelConfig config(
    const char* channel,
    const char* session,
    const char* vehicle,
    const char* source,
    std::uint8_t sysid) {
    MavlinkTransportChannelConfig c;
    c.channel_id = channel;
    c.session_id = session;
    c.vehicle_id = vehicle;
    c.source_id = source;
    c.dialect = MavlinkDialect::ArduPilot;
    c.system_id = sysid;
    c.component_id = 1;
    c.transport = MavlinkTransportType::DeterministicMemory;
    return c;
}

int main() {
    MavlinkTransportChannelRuntime r(3000);

    assert(r.registerChannel(config(
        "CH-A", "SESSION-A", "UAV-A", "ArduPilot:MAVLink2:1:1", 1)));
    assert(r.registerChannel(config(
        "CH-B", "SESSION-B", "UAV-B", "ArduPilot:MAVLink2:2:1", 2)));

    assert(r.connect("CH-A"));
    assert(r.connect("CH-B"));

    auto a = r.snapshot("CH-A");
    auto b = r.snapshot("CH-B");
    assert(a && b);
    assert(a->state == MavlinkTransportChannelState::Connected);
    assert(b->state == MavlinkTransportChannelState::Connected);

    auto frame_a = heartbeat(10);
    auto frame_b = heartbeat(200);
    assert(r.send("CH-A", 1000, frame_a));
    assert(r.injectReceive("CH-A", 1000, frame_a));
    assert(r.injectReceive("CH-B", 1000, frame_b));
    assert(r.receive("CH-A").has_value());
    assert(r.receive("CH-B").has_value());

    a = r.snapshot("CH-A");
    b = r.snapshot("CH-B");
    assert(a->stats.transmitted_frames == 1);
    assert(a->stats.received_frames == 1);
    assert(a->stats.accepted_frames == 1);
    assert(a->session && a->session->key.session_id == "SESSION-A");
    assert(b->session && b->session->key.session_id == "SESSION-B");
    assert(b->session->last_sequence == 200);

    assert(r.fail("CH-A"));
    assert(!r.send("CH-A", 2000, frame_a));
    a = r.snapshot("CH-A");
    assert(a->state == MavlinkTransportChannelState::Lost);
    assert(a->stats.link_failures == 1);
    assert(a->stats.transmit_failures == 1);

    assert(r.reconnect("CH-A"));
    a = r.snapshot("CH-A");
    assert(a->state == MavlinkTransportChannelState::Connected);
    assert(a->stats.reconnects == 1);
    assert(a->session && !a->session->sequence_initialized);

    auto recovered = heartbeat(20);
    assert(r.injectReceive("CH-A", 5000, recovered));
    assert(r.receive("CH-A").has_value());
    a = r.snapshot("CH-A");
    assert(a->session &&
           a->session->link_state == MavlinkLinkState::Healthy);
    assert(a->session->last_sequence == 20);

    assert(r.tickSession("SESSION-A", 8301).link_state ==
           MavlinkLinkState::Lost);
    a = r.snapshot("CH-A");
    assert(a->state == MavlinkTransportChannelState::Lost);

    assert(r.disconnect("CH-B"));
    b = r.snapshot("CH-B");
    assert(b->state == MavlinkTransportChannelState::Offline);
    assert(!r.send("CH-B", 9000, frame_b));

    std::cout << "mavlink_transport_channel_runtime_test: PASS\n";
}
