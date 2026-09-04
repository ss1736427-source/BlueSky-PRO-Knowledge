---
id: MASTER-DOCUMENT-INDEX-001
type: master_document_index
status: draft_for_agreement
jurisdiction: Russian Federation
system: aviation_system
---

# Master Document Index

## 1. Назначение

Единый реестр controlled documentation проекта BlueSky PRO.

Индекс отвечает на вопросы:

```text
Какой документ существует?
Где он находится?
Каков его тип и статус?
На какой authoritative source / record он опирается?
Какие документы с ним связаны?
```

Индекс не заменяет содержание первичных документов.

## 2. Repository structure

```text
00_PROJECT/
01_REQUIREMENTS/
02_ARCHITECTURE/
03_SYSTEM/
04_SOFTWARE/
05_VERIFICATION/
06_CERTIFICATION/
07_EXTERNAL/
08_HMI/
99_ARCHIVE/
```

### Назначение уровней

- `00_PROJECT` — управление проектом, решения, baseline/control, master indexes и проектные правила.
- `01_REQUIREMENTS` — системные, нормативные, safety и compliance requirements/traceability.
- `02_ARCHITECTURE` — архитектурные решения, system design и interface control.
- `03_SYSTEM` — функциональные блоки и модули BlueSky PRO.
- `04_SOFTWARE` — реализация, software design, API и configuration of software.
- `05_VERIFICATION` — verification plan, test vectors, test cases, results и evidence.
- `06_CERTIFICATION` — certification basis, scope, strategy, requirements и certification documentation.
- `07_EXTERNAL` — внешние системы, источники и среда, не являющиеся внутренними функциями BlueSky PRO.
- `08_HMI` — пользовательский интерфейс, UX, design system и HMI allocation.
- `99_ARCHIVE` — сохранённые исторические/резервные материалы, не являющиеся текущими рабочими записями.

## 3. Source hierarchy

```text
REGULATORY / OFFICIAL SOURCES
        ↓
CERTIFICATION BASIS
        ↓
PROJECT REQUIREMENTS
        ↓
SAFETY / HAZARD
        ↓
ARCHITECTURE
        ↓
DESIGN
        ↓
INTERFACES
        ↓
VERIFICATION
        ↓
EVIDENCE
        ↓
CONFIGURATION / CHANGE HISTORY
```

Для технических знаний:

```text
ORIGINAL SOURCE
→ SPECIALIZED KNOWLEDGE BASE
→ KNOWLEDGE MAP
→ ENGINEERING RULE
→ REQUIREMENT / DESIGN
```

## 4. Current primary records

| Doc ID | Document | Class | Current path |
|---|---|---|---|
| DOC-CERT-001 | CERTIFICATION_BASIS.md | CERT | 06_CERTIFICATION/BASIS/ |
| DOC-CERT-002 | CERTIFICATION_BASIS_WORKING_REGISTER.md | CERT | 06_CERTIFICATION/BASIS/ |
| DOC-CERT-003 | CERTIFICATION_DOCUMENTATION_MASTER_PLAN.md | CERT | 06_CERTIFICATION/MASTER_PLAN/ |
| DOC-CERT-004 | CERTIFICATION_DOCUMENT_INDEX.md | CERT | 06_CERTIFICATION/INDEX/ |
| DOC-CERT-005 | CERTIFICATION_OBJECT_AND_SCOPE.md | CERT | 06_CERTIFICATION/SCOPE/ |
| DOC-CERT-006 | CERTIFICATION_REQUIREMENTS_BASELINE.md | CERT | 06_CERTIFICATION/REQUIREMENTS/ |
| DOC-CERT-007 | CERTIFICATION_STRATEGY.md | CERT | 06_CERTIFICATION/STRATEGY/ |
| DOC-REQ-001 | MASTER_REQUIREMENTS_REGISTER.md | REQ | 01_REQUIREMENTS/SYSTEM/ |
| DOC-REQ-002 | SYSTEM_REQUIREMENTS_SPECIFICATION.md | REQ | 01_REQUIREMENTS/SYSTEM/ |
| DOC-REQ-003 | REQUIREMENTS_INVENTORY.md | REQ | 01_REQUIREMENTS/SYSTEM/ |
| DOC-REQ-004 | REQUIREMENTS_INVENTORY.csv | REQ | 01_REQUIREMENTS/SYSTEM/ |
| DOC-REQ-005 | REQUIREMENTS_TRACEABILITY_MATRIX.md | REQ | 01_REQUIREMENTS/TRACEABILITY/ |
| DOC-REQ-006 | REQUIREMENTS_RECONCILIATION.md | REQ | 01_REQUIREMENTS/TRACEABILITY/ |
| DOC-REQ-007 | REQUIREMENTS_RECONCILIATION.csv | REQ | 01_REQUIREMENTS/TRACEABILITY/ |
| DOC-REQ-008 | REQUIREMENTS_RECONCILIATION_DECISION.md | REQ | 01_REQUIREMENTS/TRACEABILITY/ |
| DOC-REQ-009 | REQUIREMENTS_CONSOLIDATION_REPORT.md | REQ | 01_REQUIREMENTS/TRACEABILITY/ |
| DOC-REG-001 | REGULATORY_KNOWLEDGE_BASE.md | REG | 01_REQUIREMENTS/REGULATORY/ |
| DOC-REG-002 | REGULATORY_SOURCE_REGISTER.md | REG | 01_REQUIREMENTS/REGULATORY/ |
| DOC-REG-003 | REGULATORY_CLAUSE_MAPPING_001.md | REG | 01_REQUIREMENTS/REGULATORY/ |
| DOC-SAF-001 | SAFETY_REQUIREMENTS_BASELINE.md | SAF | 01_REQUIREMENTS/SAFETY/ |
| DOC-SAF-002 | SAFETY_CASE.md | SAF | 01_REQUIREMENTS/SAFETY/ |
| DOC-SAF-003 | HAZARD_LOG.md | SAF | 01_REQUIREMENTS/SAFETY/ |
| DOC-ARCH-001 | SYSTEM_ARCHITECTURE_BASELINE.md | ARCH | 02_ARCHITECTURE/SYSTEM/ |
| DOC-DES-001 | SYSTEM_DESIGN_DESCRIPTION.md | DES | 02_ARCHITECTURE/SYSTEM/ |
| DOC-IF-001 | INTERFACE_CONTROL_DOCUMENT.md | IF | 02_ARCHITECTURE/INTERFACES/ |
| DOC-VER-001 | VERIFICATION_PLAN.md | VER | 05_VERIFICATION/PLAN/ |
| DOC-VER-002 | VERIFICATION_EVIDENCE_INDEX.md | EVD | 05_VERIFICATION/EVIDENCE/ |
| DOC-KB-001 | Самолетовождение_Черный_Кораблин_1973_KNOWLEDGE_BASE.md | KB | 00_PROJECT/ |
| DOC-KB-002 | Navigation_Knowledge_Map.md | KB | 03_SYSTEM/NAVIGATION/ |

## 5. Navigation working set

```text
03_SYSTEM/NAVIGATION/
├── NAVIGATION_ALGORITHM.md
├── NAVIGATION_MATHEMATICAL_SPECIFICATION_001.md
├── NAVIGATION_POSITION_MODULE_SPECIFICATION.md
├── NAVIGATION_RULES.md
├── NAVIGATION_STATE_MODEL.md
└── Navigation_Knowledge_Map.md

00_PROJECT/KNOWLEDGE/
└── NAVIGATION_KNOWLEDGE_REVIEW_001.md

05_VERIFICATION/NAVIGATION/
├── NAVIGATION_TRACEABILITY_MATRIX_001.md
├── NAVIGATION_VERIFICATION_MODEL.md
└── TEST_VECTORS/
    └── NAVIGATION_TEST_VECTORS_001.md
```

Navigation materials are kept separated by role: system/module design, project knowledge/review, and verification.

## 6. C2 working set

C2 materials are separated by their engineering role:

```text
01_REQUIREMENTS/REGULATORY/C2/
01_REQUIREMENTS/SYSTEM/C2/
01_REQUIREMENTS/SAFETY/C2/
01_REQUIREMENTS/TRACEABILITY/C2/
02_ARCHITECTURE/INTERFACES/C2/
05_VERIFICATION/C2/
08_HMI/C2/
```

The original controlled file contents are preserved; structural cleanup changes their repository location only.

## 7. Authoritative record rule

For each topic, exactly one record is designated authoritative at a given baseline.

Examples:

```text
Requirement wording
→ Master Requirements Register / controlled requirement record

Architecture decision
→ ARCH-DEC record

Hazard
→ HAZARD_LOG

Verification result
→ Verification Evidence Index + controlled evidence

Configuration
→ CONFIGURATION_BASELINE

Change
→ CHANGE REGISTER
```

Derived documents must link to the authoritative record.

## 8. Duplicate control

Before adding a document:

```text
Exact filename check
→ Title check
→ Type check
→ ID check
→ Topic check
→ Existing record check
```

If equivalent:

```text
UPDATE / LINK EXISTING RECORD
```

not:

```text
CREATE DUPLICATE
```

## 9. Archive rule

Historical repair backups are retained under:

```text
99_ARCHIVE/REPAIR_BACKUPS/
```

They are not working documents and must not be used as authoritative sources.

## 10. Obsidian

Obsidian remains the navigation/knowledge presentation layer over the same repository mirror.

There is no second independent documentation source. GitHub/main remains the controlled repository; Obsidian presents the synchronized working tree.

## 11. Cleanup status

First structural cleanup completed:

```text
[✓] Requirements separated
[✓] Regulatory material separated
[✓] Safety material separated
[✓] Architecture separated
[✓] Interface control separated
[✓] Navigation system materials separated
[✓] Navigation verification materials separated
[✓] C2 materials separated by role
[✓] Certification materials separated
[✓] Repair backups archived
```

The cleanup did not delete historical project content. Files were structurally relocated; Git history remains available.

## 12. Next rule

Do not create another parallel document when an existing controlled record can be updated.

For the current development sequence, work proceeds from the existing architecture into one block and one module at a time, with the corresponding requirements, design, HMI, verification and technical documentation maintained in their designated layers.

**Status: DRAFT_FOR_AGREEMENT**
