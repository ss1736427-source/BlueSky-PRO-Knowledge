---
id: SCOPE-DECISION-NO140-002
type: scope_decision
status: controlled_working_baseline
system: BlueSky PRO
---

# BLUE SKY PRO — SCOPE DECISION: ПРИКАЗ №140

## Решение

Приказ Минтранса России №140 **не является источником прямых требований к системе управления и планирования BlueSky PRO**.

Требования к физической посадочной площадке, её владельцу и соответствию площадки находятся вне системной границы BlueSky PRO.

## Документный контур

Приказ №140 может сохраняться в нормативном реестре и учитываться в certification / operational documentation только как внешний нормативный объект, внешнее условие или ограничение — если это необходимо для конкретного certification object и intended operation.

Это не означает автоматического создания SYS-REQ.

## Правило трассировки

Для №140:

```text
№140
→ applicability / scope decision
→ external object / responsibility
→ documentation or operational constraint (where applicable)
```

Для BlueSky SYS-REQ цепочка формируется только из положений, которые после applicability analysis попадают в системную границу:

```text
Regulation
→ Clause
→ Applicability
→ BlueSky Scope
→ SYS-REQ
→ Design / Interface
→ Verification
→ Evidence
```

## Запрещено

- переносить требования к посадочной площадке в SYS-REQ BlueSky;
- создавать требования к BlueSky только на основании наличия №140 в нормативном реестре;
- смешивать ответственность владельца площадки с ответственностью системы управления;
- считать внешний объект частью BlueSky без отдельного утверждённого решения по системной границе.

## Статус

Решение является рабочей фиксацией scope и должно использоваться при дальнейшей reconciliation нормативных источников.
