# ADMINISTRATOR — USERS, ROLES & CAPABILITIES

**Document ID:** ADMINISTRATOR_USERS_ROLES_CAPABILITIES_001  
**Status:** BASELINE  
**Scope:** Administrator block / user-based role assignment and personal workspace

## 1. Purpose

Define a simple and extensible model in which the Administrator selects a user and assigns the functions required for that person. One authenticated person may combine several functions.

## 2. Core principle

```text
ADMINISTRATOR
      ↓
   USERNAME
      ↓
 ASSIGN ROLES
      ↓
 CONFIGURE ACCESS
      ↓
 PERSONAL MENU
```

The Administrator works with the **user as the primary object**. Roles are assigned directly to the selected user.

## 3. User functions

The Administrator shall be able to assign one or several functions to the same user:

- SYSTEM ADMINISTRATOR — system-wide administration;
- TECHNICIAN — technical maintenance and service;
- ENGINEER — engineering configuration, diagnostics and technical analysis;
- PILOT / OPERATOR — flight preparation, execution and operational data.

Example:

```text
USER: SERGEY

Roles:
☑ PILOT
☑ TECHNICIAN
☑ ENGINEER
☐ SYSTEM ADMINISTRATOR
```

No duplicate account is required solely because functions are combined.

## 4. Administrator workflow

```text
Users
  ↓
Select user
  ↓
User card
  ↓
Roles
  ↓
Access / scope
  ↓
Save
```

The Administrator does not need to construct a complex role hierarchy for ordinary operation.

## 5. Role combinations

A role represents a functional area assigned to the user. Multiple roles can coexist on one user account.

```text
ONE USER
│
├── PILOT
├── TECHNICIAN
└── ENGINEER
```

The effective capabilities of the user are the combined result of the assigned roles and configured access restrictions.

```text
Effective Access = Assigned Roles × Scope × Policy
```

The system may internally map roles to capabilities, but this complexity should normally remain outside the user's daily Administrator workflow.

## 6. Scope

Where required, the Administrator may restrict a user's access to:

- entire system;
- organization/company;
- site/base;
- UAV/model;
- equipment;
- mission;
- dataset;
- external processing connection.

Default principle: least privilege.

## 7. Personal menu

After roles and access are assigned, the user can configure how permitted functions are displayed.

```text
USER
 ↓
ASSIGNED ROLES
 ↓
AVAILABLE FUNCTIONS
 ↓
PERSONAL MENU
```

The personal menu controls presentation and convenience, not authorization.

Mandatory safety, security, compliance and operational controls remain visible whenever required by policy.

## 8. Administrator responsibilities

The Administrator manages the user's:

- identity / username;
- assigned roles;
- access scope;
- access to external data and processing;
- personal menu defaults;
- security-sensitive permissions;
- audit visibility where authorized.

## 9. Context for multi-role users

If a user has several roles, the interface can provide a simple context selector only when necessary.

```text
SERGEY
[PILOT ▾]
```

Selecting another assigned function changes the working view to the corresponding tools. It does not create another account or identity.

## 10. Safety and security

- UI visibility never grants authorization.
- A user can access only functions permitted by the assigned roles and scope.
- Critical actions require explicit authorization according to policy.
- Changes to roles and security-sensitive access are auditable.
- Personal menu settings cannot bypass authorization.

## 11. Relationship to other Administrator branches

```text
ADMINISTRATOR
│
├── USERS
│     └── User → Roles → Access → Personal Menu
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
      └── administrative actions
```

## 12. Interface principle

The Administrator's daily workflow should be direct:

```text
USERS
 ↓
[SEARCH / SELECT USER]
 ↓
USER CARD
 ↓
[ROLES]
 ↓
[ACCESS]
 ↓
[SAVE]
```

The system hides unnecessary internal complexity. Advanced configuration remains available only where required.

## 13. Next decomposition

The next level is the concrete Administrator interface:

```text
USERS
├── Search / list
├── Select user
├── User card
├── Roles
├── Access
└── Personal menu
```

After this is fixed, the same simple user-centric approach can be applied to the other Administrator branches.