---
id: UAV-CONFIGURATION-REFERENCE-CATALOG-001
type: uav_configuration_reference_catalog
status: reference_only
---

# BlueSky PRO — UAV Configuration Reference Catalog 001

## 1. Purpose

Provide the first controlled reference population for the Administrator configuration model using manufacturer-documented data. These records are reference inputs for the configuration engine and are not BlueSky PRO certification approval by themselves.

## 2. Selection rule

Only explicit manufacturer-supported relationships shall be marked `COMPATIBLE`.

`UNKNOWN` shall remain unavailable to the operator and shall not be used by automatic configuration.

## 3. Reference UAV — DJI Matrice 350 RTK

| Parameter | Manufacturer-declared value | Provenance |
|---|---|---|
| Model | Matrice 350 RTK | DJI official specifications |
| Weight, with single downward gimbal, without batteries | approx. 3.77 kg | DJI official specifications |
| Weight, with two TB65 batteries | approx. 6.47 kg | DJI official specifications |
| Max takeoff weight | 9.2 kg | DJI official specifications |
| Max horizontal speed | 23 m/s | DJI official specifications |
| Max wind resistance | 12 m/s | DJI official specifications |
| Max flight time | 55 min, reference test condition | DJI official specifications |
| IP rating | IP55 | DJI official specifications |
| Operating temperature | -20 °C to +50 °C | DJI official specifications |
| GNSS | GPS + GLONASS + BeiDou + Galileo | DJI official specifications |
| RTK accuracy, horizontal | 1 cm + 1 ppm | DJI official specifications |
| RTK accuracy, vertical | 1.5 cm + 1 ppm | DJI official specifications |
| Single gimbal damper max payload | 960 g | DJI official specifications |

Official source: DJI Matrice 350 RTK Specifications.

## 4. M350 battery compatibility

### TB65

`M350 RTK ↔ TB65 = COMPATIBLE`

TB65 manufacturer-declared reference values:

- capacity: 5880 mAh;
- voltage: 44.76 V;
- energy: 263.2 Wh;
- chemistry: Li-ion;
- mass: approx. 1.35 kg;
- operating temperature: -20 °C to +50 °C.

DJI also states that M350 RTK can use two TB60 batteries simultaneously, but TB60 and TB65 must not be mixed during use.

Therefore the configuration engine shall model the battery set as a constrained set, not as independent battery selections.

## 5. M350 payload compatibility

The current DJI specification identifies support for:

- Zenmuse H30;
- Zenmuse H30T;
- Zenmuse H20;
- Zenmuse H20T;
- Zenmuse H20N;
- Zenmuse L2;
- Zenmuse L1;
- Zenmuse P1;
- Zenmuse S1;
- Zenmuse V1;
- certified third-party payloads developed based on the DJI Payload SDK.

The specification also defines supported gimbal arrangements including single downward, single upward, dual downward, downward + upward, and dual downward + upward configurations.

The configuration engine shall therefore represent payload placement/configuration separately from simple payload identity.

## 6. Reference UAV — DJI Matrice 300 RTK

| Parameter | Manufacturer-declared value | Provenance |
|---|---|---|
| Model | Matrice 300 RTK | DJI official specifications |
| Weight, with single downward gimbal, without batteries | approx. 3.6 kg | DJI official specifications |
| Weight with two TB60 batteries | approx. 6.3 kg | DJI official specifications |
| Max takeoff weight | 9 kg | DJI official specifications |
| Max horizontal speed | 23 m/s | DJI official specifications |
| Max wind resistance | 12 m/s | DJI official specifications |
| Max flight time | 55 min, reference test condition | DJI official specifications |
| IP rating | IP45 | DJI official specifications |
| Operating temperature | -20 °C to +50 °C | DJI official specifications |
| GNSS | GPS + GLONASS + BeiDou + Galileo | DJI official specifications |
| Single gimbal damper max payload | 930 g | DJI official specifications |

## 7. M300 battery compatibility

### TB60

`M300 RTK ↔ TB60 = COMPATIBLE`

DJI explicitly states that M300 RTK does not support TB50/TB55 and that TB60 is the applicable Intelligent Flight Battery.

The configuration engine shall not expose unsupported battery models for M300 RTK.

## 8. Initial compatibility seed

| UAV | Component | Relationship | Condition |
|---|---|---|---|
| M350 RTK | TB65 | COMPATIBLE | two-battery set as supported by aircraft |
| M350 RTK | TB60 | COMPATIBLE | two TB60 batteries; do not mix TB60/TB65 |
| M350 RTK | TB65 + TB60 mixed set | INCOMPATIBLE | explicitly prohibited |
| M300 RTK | TB60 | COMPATIBLE | supported battery |
| M300 RTK | TB50 | INCOMPATIBLE | manufacturer states not supported |
| M300 RTK | TB55 | INCOMPATIBLE | manufacturer states not supported |
| M350 RTK | listed DJI gimbals | COMPATIBLE | subject to supported mounting arrangement |
| M350 RTK | non-certified third-party payload | UNKNOWN / EXCLUDED | only certified Payload SDK payloads may qualify |

## 9. Configuration-engine rule

The reference catalog is not a list from which the operator may freely combine records.

The engine shall evaluate the relationship graph first:

```text
UAV MODEL
   ↓
BATTERY COMPATIBILITY
   ↓
PAYLOAD COMPATIBILITY
   ↓
MOUNT / INTERFACE
   ↓
MASS / MTOW
   ↓
POWER / ENERGY
   ↓
NAVIGATION / COMMUNICATION
   ↓
VALID CONFIGURATION
```

Only records surviving all mandatory checks enter the operator-facing candidate set.

## 10. Automatic mission selection

The operational interface shall preferably request mission requirements rather than individual hardware choices.

The engine shall:

1. identify UAV models capable of the mission;
2. obtain only compatible equipment candidates;
3. construct only valid configurations;
4. reject configurations violating limits;
5. evaluate configuration-specific energy behaviour;
6. rank valid configurations against mission objectives;
7. return the recommended configuration and valid alternatives.

## 11. Data provenance

Each populated parameter must retain:

- source organization;
- source document;
- source revision/date;
- exact applicability to UAV/component;
- BlueSky record revision;
- qualification state.

The official DJI specifications and compatibility documentation are external source evidence; they are not silently converted into BlueSky PRO acceptance criteria.

## 12. Sources

- DJI Matrice 350 RTK official specifications: https://enterprise.dji.com/matrice-350-rtk/specs
- DJI Matrice 350 RTK official FAQ: https://enterprise.dji.com/matrice-350-rtk/faq
- DJI Matrice 350 RTK Download Center, including accessory compatibility documentation: https://www.dji.com/downloads/products/matrice-350-rtk
- DJI Matrice 300 RTK official specifications/support: https://www.dji.com/support/product/matrice-300
- DJI Matrice 300 RTK Download Center, including accessory compatibility documentation: https://www.dji.com/downloads/products/matrice-300

## 13. Status

**REFERENCE_ONLY — initial seed.**

This catalog is sufficient to establish the first machine-readable compatibility relationships conceptually, but further component records and controlled qualification are required before any configuration can be considered an approved operational configuration for BlueSky PRO.