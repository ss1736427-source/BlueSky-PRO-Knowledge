# ARCH-OPS-038 — P0 unified C2 link measurement

## Purpose

Close the executable integration portion of G2-04 by composing per-channel packet loss, latency and observed bandwidth into the existing C2 link measurement boundary.

## Measurement path

MavlinkTransportChannelRuntime
→ LinkMetricsRuntime
→ LinkLatencyRuntime
→ LinkBandwidthRuntime
→ C2LinkRuntimeBridge
→ C2LinkMeasurement
→ C2ChannelManager::ChannelSnapshot

The bridge uses the latest TIMESYNC RTT when present, packet-loss ratio from accepted sequence observations, and observed TX/RX throughput converted to kbps. The latter is an observed throughput value and is not a claim of physical maximum link capacity.

## Authority

C2ChannelManager remains the authority for channel qualification, deterministic selection and failover eligibility. This slice does not add thresholds, hysteresis or physical switching.

MAVLink supports multiple systems on the same link and uses network-unique system IDs plus system-unique component IDs for addressing and routing. This integration therefore keeps measurement keyed to the existing channel boundary and does not yet introduce fleet routing logic. citeturn0search0turn0search6

## Evidence

SIL_C2_UNIFIED_LINK_MEASUREMENT

No field, radio, serial, SITL, HIL, physical, or certification evidence is claimed.
