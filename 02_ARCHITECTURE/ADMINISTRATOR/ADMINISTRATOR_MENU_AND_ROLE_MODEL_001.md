---
id: ADMINISTRATOR-MENU-ROLE-001
type: architecture
status: DRAFT
version: 0.1
title: Administrator Menu and Multi-Role User Model
---

# ADMINISTRATOR — MENU AND MULTI-ROLE USER MODEL

## 1. Design principle

ADMINISTRATOR retains the complete functional model required by the system, while the user interface presents only functions permitted to the current user and selected for the user's working profile.

Functional completeness and visual simplicity are separate concerns.

## 2. First-level menu

The first level shall remain minimal:

```text
ADMINISTRATOR
│
├── SYSTEM ADMINISTRATION
├── TECHNICAL
├── EXTERNAL DATA & CONNECTIONS
└── DATA & PROCESSING
```

No required system capability is removed because it is not shown on the first level.

## 3. Second-level expansion

Each first-level block expands only when selected.

### SYSTEM ADMINISTRATION

```text
Users & Roles
Permissions
System Configuration
Organizations
Configuration / Feature Flags
Versions & Change Control
Audit
Security
Backup / Recovery
Deployment / Environment
```

### TECHNICAL

```text
UAV
Energy / Batteries
Equipment / Payload
Configurations
Compatibility
Maintenance / Service
Software / Firmware
Technical Documents
Technical Validation / Readiness
```

### EXTERNAL DATA & CONNECTIONS

```text
Navigation Data
Aeronautical Information
NOTAM
Weather / METEO
Airspace
Operating / Landing Sites
Maps
Terrain
Geofence
C2
Communications
Observation / Surveillance
External Services
Synchronization / DUM
Connection Health
```

### DATA & PROCESSING

```text
Datasets
Collection
Normalization
Validation
Fusion / Aggregation
Data Lineage
Formats
External Processing
Export
Import / Results
Archive
Data Quality
```

## 4. Data and service boundary

Administrator UI is a control surface. Processing itself remains in the relevant system service.

```text
ADMINISTRATOR
      ↓
configuration / policy / source / permissions
      ↓
DUM / HUB / DOMAIN SERVICES
      ↓
normalized authoritative data
      ↓
Mission / Planning / Safety / Analysis
```

External processing follows:

```text
DATASET
  ↓
DATA MANAGER
  ↓
DATA EXCHANGE CONTRACT
  ↓
ADAPTER
  ↓
EXTERNAL SOFTWARE
  ↓
RESULT PACKAGE
  ↓
DATA MANAGER / HUB
```

## 5. Multi-role user model

A user shall have one identity and may have multiple roles and functional assignments.

Example:

```text
USER
 ├── primary role: PILOT
 ├── additional role: TECHNICIAN
 └── additional role: ENGINEER
```

Roles are not mutually exclusive.

## 6. Role composition

The effective access model is:

```text
USER IDENTITY
      ↓
ROLES
      ↓
FUNCTIONS / PERMISSIONS
      ↓
RESOURCE SCOPE
      ↓
VISIBILITY
      ↓
PERSONAL WORKSPACE
```

A role grants a controlled set of capabilities; visibility customization cannot grant permissions.

## 7. Example combined specialist

```text
Ivanov
│
├── PILOT
│   ├── mission preparation
│   ├── preflight functions
│   └── flight functions
│
├── TECHNICIAN
│   ├── UAV condition
│   ├── batteries
│   ├── maintenance
│   └── faults
│
└── ENGINEER
    ├── configurations
    ├── compatibility
    ├── equipment
    └── technical parameters
```

The user may expose only the functions required for the current work profile.

## 8. Permission granularity

Permissions shall distinguish at least:

```text
VIEW
CREATE
EDIT
VALIDATE
APPROVE
ACTIVATE
SUSPEND
ARCHIVE
EXPORT
IMPORT
ADMINISTER
```

A role or function shall not imply all permissions automatically.

Critical permissions such as approval, activation and operational authorization shall remain separately controlled.

## 9. Personalized menu

A user may configure the presentation of functions available to that user.

```text
AVAILABLE FUNCTIONS
        ↓
USER SELECTION / PROFILE
        ↓
MY MENU
```

The personal menu may:

- pin frequently used functions;
- hide non-frequent permitted functions;
- reorder permitted functions;
- save workspace arrangement;
- restore system default.

Hidden functionality remains accessible through the full authorized menu or search/navigation mechanism.

## 10. Required functions vs visibility

The system shall maintain two independent properties:

```text
FUNCTION EXISTS      → system capability
USER MAY USE         → authorization
USER WANTS TO SEE    → personalization
```

Thus:

```text
NO PERMISSION → NOT AVAILABLE
PERMISSION + HIDDEN → AVAILABLE BUT NOT SHOWN IN PERSONAL MENU
PERMISSION + SHOWN → SHOWN
```

## 11. Role overlap and separation

Several users may have the same role. One user may have multiple roles.

Separate approval authority shall not be created merely by assigning an additional technical role.

Where required by safety, certification or organizational policy, approval may require a distinct authority role or organizational rule.

## 12. Technical block visibility

Technical information shall be filtered according to user permissions and purpose.

For example:

```text
TECHNICIAN
→ condition / service / battery / faults

ENGINEER
→ parameters / configuration / compatibility / technical model

PILOT
→ operational readiness / applicable configuration / relevant status
```

A combined user may receive the union of authorized functions while still using a compact personal menu.

## 13. External data visibility

The full external-data catalogue shall remain available to authorized administrators, but each user shall see only relevant permitted domains.

Examples:

```text
Administrator → all
Engineer      → technical/navigation data as authorized
Technician    → technical/service status as authorized
Pilot         → operationally relevant data
```

## 14. Audit

Role assignment, permission changes, profile changes affecting protected functions, configuration changes and administrative actions shall be auditable.

The audit record shall retain actor, action, target, time, resulting state and applicable revision/context.

## 15. Security boundary

The UI shall never be the authority for access control.

```text
QML/UI
  ↓ request
C++ Core / Authorization Service
  ↓ decision
Protected resource / operation
```

Personalization can reduce displayed information, but cannot bypass authorization.

## 16. Relationship to existing architecture

This model connects:

```text
ADMINISTRATOR
   ├── Users / Roles / Permissions
   ├── Technical Configuration
   ├── External Data & Connections
   └── Data & Processing
          ↓
       DUM / HUB
          ↓
   DOMAIN SERVICES
          ↓
 Mission / Pilot / Safety / Analysis
```

It complements the existing DUM, HUB, Data Governance, Configuration Manager, External Processing and traceability architecture without creating a parallel data authority.

## 17. Status

DRAFT — functional structure established; exact organizational roles, authority boundaries and certification-specific approval rules remain subject to the applicable requirements baseline.
