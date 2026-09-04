---
id: NAVIGATION-DOCUMENT-MAP-001
type: controlled_document_map
status: draft_for_agreement
parent: NAVIGATION
---

# BlueSky PRO — Navigation Document Map

## 1. Purpose

This is the integration map for the existing Navigation documentation set. It does not replace any source document or create a second requirements authority.

Its purpose is to make the Navigation workstream structurally traceable and to prevent duplication.

## 2. Authority model

```text
REGULATORY / OFFICIAL SOURCES
        ↓
CERTIFICATION BASIS
        ↓
MASTER REQUIREMENTS REGISTER
        ↓
SYSTEM REQUIREMENTS SPECIFICATION
        ↓
SYSTEM ARCHITECTURE
        ↓
NAVIGATION STATE / RULES / ALGORITHM / MATH
        ↓
NAVIGATION MODULE SPECIFICATIONS
        ↓
HMI / INTERFACES
        ↓
VERIFICATION
        ↓
EVIDENCE
```

No lower-level document creates a new authoritative requirement merely by containing a statement.

## 3. Existing Navigation records

### 3.1 Core engineering records

- `NAVIGATION_STATE_MODEL.md` — common Navigation State semantics and state structure.
- `NAVIGATION_RULES.md` — Navigation engineering rules.
- `NAVIGATION_ALGORITHM.md` — algorithmic logic.
- `NAVIGATION_MATHEMATICAL_SPECIFICATION_001.md` — mathematical basis and unresolved mathematical parameters.
- `Navigation_Knowledge_Map.md` — navigation knowledge relationships.

### 3.2 Module specifications

- `NAVIGATION_POSITION_MODULE_SPECIFICATION.md`
- `NAVIGATION_VELOCITY_SPEED_MODULE_SPECIFICATION.md`
- `NAVIGATION_HEADING_MODULE_SPECIFICATION.md`
- `NAVIGATION_TRACK_COURSE_MODULE_SPECIFICATION.md`
- `NAVIGATION_WIND_MODULE_SPECIFICATION.md`

These are derived design-level specifications. They must reference the existing authoritative sources rather than reproduce them as independent requirements.

### 3.3 Review / verification records

- `00_PROJECT/KNOWLEDGE/NAVIGATION_KNOWLEDGE_REVIEW_001.md` — review and reconciliation of navigation knowledge.
- `05_VERIFICATION/NAVIGATION/NAVIGATION_TRACEABILITY_MATRIX_001.md` — current Navigation rule/algorithm/verification traceability.
- `05_VERIFICATION/NAVIGATION/NAVIGATION_VERIFICATION_MODEL.md` — verification model.
- `05_VERIFICATION/NAVIGATION/TEST_VECTORS/NAVIGATION_TEST_VECTORS_001.md` — navigation test vectors.

## 4. Requirement authority

Authoritative requirement identity:

`01_REQUIREMENTS/SYSTEM/MASTER_REQUIREMENTS_REGISTER.md`

Derived presentation/specification:

`01_REQUIREMENTS/SYSTEM/SYSTEM_REQUIREMENTS_SPECIFICATION.md`

Candidate Navigation requirement family:

`NAV-REQ-*`

These candidates must be compared against existing SYS-REQ/SAF-REQ records before baseline. No candidate is promoted solely because it appears in a module specification.

## 5. Regulatory authority

Regulatory sources and applicability are controlled through:

- `01_REQUIREMENTS/REGULATORY/REGULATORY_SOURCE_REGISTER.md`
- `01_REQUIREMENTS/REGULATORY/REGULATORY_KNOWLEDGE_BASE.md`
- `01_REQUIREMENTS/REGULATORY/REGULATORY_CLAUSE_MAPPING_001.md`
- applicable certification-basis records under `06_CERTIFICATION/`

A module document may identify regulatory applicability, but the authoritative source/clause remains in the regulatory/certification layer.

## 6. Architecture authority

Navigation module allocation is subordinate to the approved system architecture and interface control.

The architecture layer is the authority for:

```text
block boundaries
module allocation
system interfaces
authority boundaries
```

A module specification must not silently create a new architectural block or authority path.

## 7. Verification authority

Navigation verification is controlled through the verification layer.

```text
Requirement
→ verification method
→ test case / test vector
→ execution result
→ evidence
```

A verification case listed in a module specification is a reference/allocation, not proof of execution. `VERIFIED` requires controlled evidence.

## 8. Cross-module Navigation model

```text
                 ┌──────────────┐
                 │   POSITION   │
                 └──────┬───────┘
                        │
                 ┌──────▼───────┐
                 │ VELOCITY /   │
                 │    SPEED     │
                 └──────┬───────┘
                        │
      ┌─────────────────┼─────────────────┐
      ▼                 ▼                 ▼
 HEADING           WIND             TRACK/COURSE
      │                 │                 │
      └─────────────────┼─────────────────┘
                        ▼
               NAVIGATION STATE
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
          Planning   Safety     Flight
```

The diagram expresses relationships only; it does not grant decision authority to individual Navigation modules.

## 9. Module-level traceability requirement

Every module specification shall contain or reference:

```text
Module ID
Parent block
Authoritative requirements source
Applicable rule/algorithm source
Architecture/interface source
Knowledge source, where applicable
HMI allocation
Verification allocation
Open items
Change/configuration status
```

Where exact requirement IDs are not yet reconciled, the document must explicitly state `TBD` / `PENDING RECONCILIATION` rather than inventing an ID.

## 10. Current consolidation state

```text
Architecture → established baseline
Navigation State → existing
Rules → existing
Algorithm → existing
Mathematical specification → existing
Knowledge map → existing
Module specifications → being consolidated
Requirement linkage → reconciliation required
Regulatory applicability → clause-level reconciliation required
HMI linkage → controlled allocation required
Verification linkage → existing matrix/model must be reused
Evidence → only created by actual verification
```

## 11. No-duplication rule

Before creating any new Navigation document:

```text
SEARCH EXISTING RECORDS
        ↓
IDENTIFY AUTHORITATIVE RECORD
        ↓
CHECK OVERLAP
        ↓
UPDATE / LINK EXISTING RECORD
        ↓
ONLY IF ABSENT → CREATE NEW RECORD
```

## 12. Completion criterion for Navigation

The Navigation block is not complete when all module documents merely exist.

It is complete only when:

```text
all modules
→ requirements reconciled
→ regulatory applicability checked
→ architecture/interfaces linked
→ cross-module semantics consistent
→ HMI allocation linked
→ verification mapped
→ evidence status controlled
→ open items resolved or formally accepted
→ documentation index updated
```

Status: `DRAFT_FOR_AGREEMENT`.
