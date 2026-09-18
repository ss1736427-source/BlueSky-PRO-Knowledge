#include "mavlink_session_boundary.hpp"

#include <cassert>
#include <iostream>

int main() {
    using namespace bluesky::autopilot;

    MavlinkSessionBoundary session("COMMON");
    MavlinkSessionIdentity identity;
    identity.sessionId = "SESSION-018-001";
    identity.dialect = "COMMON";
    identity.systemId = "42";
    identity.componentId = "1";
    identity.autopilot = "REFERENCE";
    identity.firmwareVersion = "FW-BASELINE-1";

    assert(session.connect(identity));
    assert(session.state() == MavlinkSessionState::Connected);

    MavlinkMessageEnvelope heartbeat;
    heartbeat.messageType = "HEARTBEAT";
    heartbeat.sourceSystemId = "42";
    heartbeat.sourceComponentId = "1";
    heartbeat.sequence = 7;
    heartbeat.receivedTimestampMs = 1000;
    assert(session.acceptHeartbeat(heartbeat));
    assert(session.heartbeatFresh(1500, 1000));

    MavlinkMessageEnvelope unsupported = heartbeat;
    unsupported.messageType = "UNKNOWN";
    unsupported.supported = false;
    assert(!session.route(unsupported));

    MavlinkMessageEnvelope malformed = heartbeat;
    malformed.malformed = true;
    assert(!session.route(malformed));

    MavlinkMessageEnvelope command = heartbeat;
    command.messageType = "COMMAND_ACK";
    command.sequence = 8;
    assert(session.route(command));

    session.markLost();
    assert(session.state() == MavlinkSessionState::Lost);
    assert(session.beginRecovery());
    assert(session.state() == MavlinkSessionState::Recovering);

    MavlinkSessionIdentity newSession = identity;
    newSession.sessionId = "SESSION-018-002";
    assert(session.restore(newSession));
    assert(session.state() == MavlinkSessionState::Connected);
    assert(session.identity().sessionId == "SESSION-018-002");
    assert(session.acceptedMessageCount() == 2);
    assert(session.rejectedMessageCount() == 2);

    session.disconnect();
    assert(session.state() == MavlinkSessionState::Disconnected);

    std::cout << "PASS: ARCH-OPS-018 MAVLink session boundary\n";
    return 0;
}
