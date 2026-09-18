# ARCH-OPS-038 — Unified C2 link measurement bridge

Status: IMPLEMENTATION BASELINE — CI verification pending

## Scope

Integrates the executable G2-04 link measurements into the existing C2 bridge without duplicating channel selection or failover authority.

## Derived measurement

measureFromTransport() derives:

- latency from the latest observed MAVLink TIMESYNC RTT when available;
- packet loss from accepted per-channel sequence metrics;
- observed bandwidth from the greater of measured TX/RX byte rates, converted to kbps;
- integrity/authentication from the caller's established trust boundary;
- measurement timestamp from the caller.

The resulting C2LinkMeasurement is then mapped to the existing C2ChannelManager::ChannelSnapshot.

## Authority boundary

The bridge only supplies measurements. C2ChannelManager remains responsible for qualification, selection and failover eligibility.

No quality thresholds, hysteresis, physical-capacity inference, or automatic channel switching are introduced.

## Evidence

SIL_C2_UNIFIED_LINK_MEASUREMENT

No field, radio, serial, SITL, HIL, physical, or certification evidence is claimed.
