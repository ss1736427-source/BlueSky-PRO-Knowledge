# BlueSky PRO — Vehicle / Payload Capability Model

**Status:** ARCHITECTURE BASELINE — P0 integration contract

## 1. Purpose

The Capability Model is the bridge between the abstract mission and the real fleet. BlueSky shall determine automatically whether a UAV + autopilot + payload configuration can perform the requested task and which vehicle is the most appropriate.

The pilot does not select an algorithm or manually translate mission requirements into aircraft capabilities.

## 2. Position in the system

```text
MISSION OBJECTIVE
      ↓
REQUIRED CAPABILITIES
      ↓
FLEET CAPABILITY REGISTRY
      ↓
CAPABILITY MATCHING
      ↓
┌───────────────────────────────┐
│ UAV + AUTOPILOT + PAYLOAD     │
│ + C2 + BATTERY + EQUIPMENT    │
└───────────────────────────────┘
      ↓
FEASIBILITY / RANKING
      ↓
ALGORITHM ORCHESTRATOR
      ↓
MISSION ALLOCATION
```

## 3. Vehicle identity

Each vehicle profile shall have a stable identity and versioned configuration containing, as applicable:

- vehicle identifier;
- vehicle type/model;
- airframe configuration;
- propulsion configuration;
- autopilot type and version;
- supported protocol(s);
- firmware/software compatibility;
- navigation capabilities;
- communication capabilities;
- battery type/capacity/state model;
- payload interfaces;
- operational limits;
- recovery capabilities;
- maintenance/resource state.

## 4. Flight capability model

The profile shall represent capabilities rather than merely nominal specifications.

Examples:

- minimum/maximum airspeed;
- cruise/economic speed ranges;
- climb/descent limits;
- altitude envelope;
- turning/trajectory limits;
- endurance model;
- usable energy model;
- wind tolerance/model;
- navigation sensor availability;
- GNSS-denied/recovery capability;
- C2 requirements;
- return/recovery constraints;
- environmental operating limits.

Where a parameter is configuration-dependent, the active configuration is authoritative for planning.

## 5. Energy capability

Energy capability shall be represented as a model, not as a single catalogue endurance number.

The model shall permit calculation using:

- battery usable energy;
- battery state/health;
- degradation coefficient;
- payload mass and power;
- propulsion configuration;
- flight mode;
- wind;
- route geometry;
- environmental conditions;
- reserve requirement;
- recovery/return requirement.

The planner and validator shall consume the same energy model to avoid divergence between predicted feasibility and release validation.

## 6. Propulsion/resource capability

Where applicable, the profile shall include:

- engine/motor type;
- propulsion configuration;
- propeller configuration;
- resource/operating-hour state;
- applicable limits;
- configuration-specific performance data.

Resource constraints are part of candidate evaluation but shall never override mandatory safety or energy constraints.

## 7. Payload capability

A payload profile shall identify:

- sensor/camera type;
- payload identifier and version;
- mass and balance impact;
- electrical power requirements;
- interface/protocol;
- supported modes;
- field of view and relevant optics parameters;
- resolution/GSD-related parameters;
- stabilization/gimbal capability;
- triggering/control capabilities;
- data output requirements;
- operational restrictions.

## 8. Task capability requirements

Mission requirements shall be translated into capability requirements before vehicle allocation.

```text
INSPECTION
 → required sensor
 → required viewpoint
 → required resolution
 → required endurance
 → required clearance

DELIVERY
 → payload mass/volume
 → range
 → recovery margin
 → ETA

3D
 → imaging geometry
 → overlap
 → viewing angles
 → sensor capability
```

## 9. Matching logic

BlueSky shall distinguish:

**Hard capability requirements** — failure makes the vehicle unsuitable.

**Soft capability preferences** — influence ranking among suitable vehicles.

A vehicle may be rejected before route optimization if it cannot satisfy a mandatory capability.

## 10. Configuration validity

A vehicle is not considered available merely because its airframe profile exists.

The active configuration must be valid for the intended mission, including:

```text
AIRFRAME
 + AUTOPILOT
 + FIRMWARE
 + BATTERY
 + PROPULSION
 + PAYLOAD
 + C2
 + REQUIRED EQUIPMENT
      ↓
CONFIGURATION VALID
```

Configuration changes shall invalidate affected calculations and trigger revalidation.

## 11. Multi-UAV allocation

For a group mission, BlueSky shall evaluate the fleet as a heterogeneous set.

Different UAVs may receive different subtasks when this produces a better admissible operational solution.

Allocation shall consider:

- capability match;
- energy margin;
- payload suitability;
- route characteristics;
- C2 availability;
- coordination constraints;
- mission timing;
- resource state.

## 12. Autopilot independence

The capability model shall not embed ArduPilot-, PX4- or OEM-specific assumptions into the mission model.

Autopilot-specific capabilities are exposed through the Autopilot Adapter and mapped into the common capability model.

```text
COMMON CAPABILITY MODEL
        ↑
AUTOPILOT ADAPTER
   ↑       ↑       ↑
ArduPilot  PX4     OEM
```

## 13. Capability discovery

Where supported, BlueSky shall obtain machine-readable capabilities from the connected autopilot/vehicle and compare them with the stored approved profile.

Discrepancies shall be surfaced before mission release.

## 14. Readiness relationship

Capability matching is a prerequisite to route optimization and final readiness validation.

```text
CAPABILITY MATCH
      ↓
ROUTE OPTIMIZATION
      ↓
ENERGY / SAFETY / REGULATORY GATES
      ↓
OPERATIONAL VALIDATION
      ↓
READY FOR FLIGHT
```

## 15. Traceability

Every mission solution shall retain the exact vehicle, autopilot, payload, battery/configuration and capability-model versions used for planning and validation.

## 16. Acceptance criteria

The capability model is considered contract-complete when:

1. any supported fleet can be represented without changing the mission model;
2. mandatory and preferred capabilities are distinguishable;
3. vehicle allocation can be performed automatically;
4. heterogeneous UAVs can be allocated different subtasks;
5. energy and payload effects are represented;
6. configuration changes trigger affected revalidation;
7. autopilot-specific data is isolated behind adapters;
8. capability versions are traceable;
9. planning and validation use the same authoritative capability data.

## 17. Implementation boundary

This document defines the common contract. Concrete profiles, adapters and verified performance parameters are implementation/configuration artifacts and shall be independently versioned and verified.
