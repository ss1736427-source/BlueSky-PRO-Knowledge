---
id: NO140-REQUIREMENTS-ALLOCATION-001
type: requirements_allocation
status: controlled_working_draft
system: BlueSky PRO
basis: NO140-REG-MAPPING-001
master_register: MASTER_REQUIREMENTS_REGISTER.md
---

# BLUE SKY PRO — №140 REQUIREMENTS ALLOCATION 001

## 1. Правило allocation

Новые требования по №140 не создаются как SYS-REQ автоматически. Сначала выполняется поиск существующего requirement identity в MASTER_REQUIREMENTS_REGISTER.

Правило проекта:

```text
EXISTING REQUIREMENT
→ REUSE
→ ADD REGULATORY RELATIONSHIP

NO SUITABLE EXISTING REQUIREMENT
→ CREATE CONTROLLED NEW ID
```

## 2. Current allocation status

На текущем проходе отдельные существующие SYS-REQ с однозначным соответствием параметрам посадочной площадки не подтверждены. Поэтому N140-REQ-001…006 сохраняются как кандидаты и не переводятся в baseline.

| Candidate | Current disposition | Reason |
|---|---|---|
| N140-REQ-001 | HOLD | требуется определить authoritative landing-site data set |
| N140-REQ-002 | HOLD | требуется определить конкретные planning constraints и их applicability |
| N140-REQ-003 | HOLD | требуется определить источник и configuration control параметров |
| N140-REQ-004 | HOLD | safety/validation policy требует allocation в существующую архитектуру требований |
| N140-REQ-005 | HOLD | требуется определить конкретный obstacle/profile calculation scope |
| N140-REQ-006 | HOLD | требуется определить границу между regulatory data, site data и BlueSky calculation |

## 3. Не допускается

- назначать N140-REQ-* окончательными SYS-REQ без review;
- создавать дубли существующих SYS-REQ;
- переносить физическое требование к площадке в программное требование без rationale;
- считать наличие параметра в БД доказательством физического соответствия площадки;
- вводить численные acceptance criteria без установленного basis.

## 4. Следующая операция

1. Выделить authoritative data, необходимые Flight Planning.
2. Сопоставить их с существующими SRS/architecture/interface requirements.
3. Выполнить safety impact assessment.
4. Только после этого обновить MASTER_REQUIREMENTS_REGISTER.
5. Создать verification/evidence links.

## 5. Status

**CONTROLLED WORKING DRAFT — NOT BASELINED**
