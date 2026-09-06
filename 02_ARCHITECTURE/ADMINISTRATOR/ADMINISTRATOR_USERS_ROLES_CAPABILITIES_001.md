# ADMINISTRATOR — USERS, ROLES & CAPABILITIES

**Document ID:** ADMINISTRATOR_USERS_ROLES_CAPABILITIES_001  
**Status:** BASELINE  
**Scope:** Administrator block / identity, roles, capabilities, visibility and personal workspace

## 1. Purpose

Define a minimal and extensible model in which one authenticated person may receive several operational functions while the interface exposes only the information and controls required for the currently selected function.

## 2. Core principle

```text
USER
  ↓
IDENTITY
  ↓
ROLES / FUNCTIONS
  ↓
CAPABILITIES
  ↓
RESOURCE SCOPE
  ↓
VISIBILITY
  ↓
PERSONAL MENU
```

Visibility is not authorization. Hiding an item never grants or removes a permission.

## 3. Initial user functions

The Administrator shall support at least these functions:

- SYSTEM ADMINISTRATOR — system-wide administration;
- TECHNICIAN — technical maintenance and service;
- ENGINEER — engineering configuration, diagnostics and technical analysis;
- PILOT / OPERATOR — flight preparation, execution and operational data.

One person may hold multiple functions simultaneously, for example:

```text
USER A
├── PILOT
├── TECHNICIAN
└── ENGINEER
```

No duplicate account is required solely because functions are combined.

## 4. Capability model

A role is a convenient grouping of capabilities. Effective access is calculated from the user's assigned roles and the applicable resource scope.

```text
Effective Access = Roles × Capabilities × Scope × Policy
```

Examples of capabilities:

- view;
- create;
- edit;
- approve;
- configure;
- diagnose;
- maintain;
- export;
- process;
- manage connection;
- manage users and roles;
- access audit information.

## 5. Resource scope

Capabilities may be restricted by scope, such as:

- entire system;
- organization/company;
- site/base;
- UAV/model;
- equipment;
- mission;
- dataset;
- external processing connection.

A user with a technical role does not automatically receive system-administrator access.

## 6. Personal menu

The user interface shall be configurable per user.

```text
AVAILABLE
├── allowed by role
├── allowed by capability
└── allowed by scope

        ↓
PERSONAL WORKSPACE
├── pinned
├── frequently used
├── hidden
└── ordered
```

The system shall preferentially present only relevant functions. Mandatory safety, security, compliance and operational controls cannot be removed when their display is required by policy.

## 7. Context switching

When a user has several functions, the interface may expose a compact function/context selector instead of duplicating menus.

Example:

```text
SERGEY
[PILOT ▾]

Flight
  ├── Mission
  ├── UAV
  └── Telemetry
```

Switching to TECHNICIAN changes the working context and visible tools without changing the underlying identity.

## 8. Administrator responsibilities

The Administrator manages:

- users;
- assigned functions/roles;
- capabilities;
- scopes;
- role combinations;
- mandatory controls;
- personal menu defaults;
- external-data and processing access;
- audit policy.

The Administrator shall be able to create organization-specific role profiles without changing the core application model.

## 9. Safety and security constraints

- Least privilege is the default.
- Administrative capability cannot be inferred from UI visibility.
- Critical actions require explicit authorization according to policy.
- Changes to roles, permissions and security-sensitive configuration are auditable.
- A user's personal menu may simplify access but must not bypass authorization.

## 10. Relationship to other Administrator branches

```text
ADMINISTRATOR
│
├── USERS & ROLES
│     └── CAPABILITIES / SCOPE / PERSONAL MENU
│
├── UAV & CONFIGURATION
│     └── compatible equipment configuration
│
├── DATA & PROCESSING
│     └── datasets / preparation / export / results
│
├── EXTERNAL CONNECTIONS
│     └── data and processing integrations
│
└── LOG / AUDIT
      └── traceability of administrative actions
```

## 11. Next decomposition

The next level shall define the concrete `USERS & ROLES` interface and its workflow:

```text
Users
 → User card
 → Functions
 → Capabilities
 → Scope
 → Personal menu
 → Audit
```

Only after this layer is stable should detailed role matrices be expanded.