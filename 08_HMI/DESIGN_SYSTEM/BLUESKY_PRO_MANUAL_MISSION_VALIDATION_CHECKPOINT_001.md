---
id: HMI-MANUAL-VALIDATION-001
type: hmi_behavior_checkpoint
status: checkpoint-for-design-studio-review
system: BlueSky PRO
branch: checkpoint/manual-mission-validation-001
date: 2026-09-26
---

# BlueSky PRO — Manual Mission Validation Checkpoint 001

## Purpose

Freeze the agreed HMI behavior for manually composed missions and provide a dedicated Qt Design Studio preview for operator review.

## Agreed behavior

1. Starting manual mission creation exposes a dedicated «ВАЛИДАЦИЯ МИССИИ» action in the Right Panel.
2. The action uses the controlled green #64FF00 visual treatment and a breathing/pulsing outline.
3. While the operator is assembling template-derived scaffolds on the Flight Chart, the action remains visible but cannot be activated.
4. The map/mission editor signals that the combined mission composition is complete. Only then is the validation action enabled.
5. The operator explicitly presses the action. The HMI emits manualMissionValidationRequested.
6. The action is immediately hidden for that manual-creation pass.
7. The validation request is intended to enter the same downstream planning and verification pipeline as an automatically composed mission. The only difference is manual template selection.
8. The HMI event is not a validation-success result. Readiness and execution authority remain owned by the planning core and safety gate.

## State sequence

MANUAL_CREATION → COMPOSING → COMPOSITION_COMPLETE → VALIDATION_REQUESTED → BUTTON_HIDDEN

- manualCreationMode: selects the manual-creation workflow.
- manualCompositionComplete: controlled by the map/mission editor.
- manualValidationStarted: prevents duplicate requests and hides the button after activation.

## Qt Design Studio review

Open:

qt/BlueSkyPRO-HMI/BlueSkyPRO-ManualValidation-DesignStudio.qmlproject

The preview uses the actual RightPanel component. The preview-only control «ЗАВЕРШИТЬ СБОРКУ (ТЕСТ)» simulates the map editor's completion signal. It is not part of the operational interface and does not invoke the planning core.

### Review steps

1. Open the standalone project in Qt Design Studio.
2. Confirm that the validation action is visible and pulsing, but unavailable before composition completion.
3. Click «ЗАВЕРШИТЬ СБОРКУ (ТЕСТ)».
4. Confirm the action becomes available.
5. Click «ВАЛИДАЦИЯ МИССИИ» in the Right Panel.
6. Confirm the action disappears and the preview status changes to indicate that the request was emitted.
7. Click «СБРОСИТЬ ТЕСТ» to repeat.

## Implementation boundary / known gap

The current Flight Chart is a structural placeholder. It exposes manualCompositionCompleted() as an integration point, but no real map editing/composition detector currently emits it. The preview simulates this event solely to verify the HMI state transition.

The operational request is currently an HMI signal and journal event. Connection to the real mission-planning core, result handling, and authoritative readiness update remain future integration work.

## Files in this checkpoint

- qt/BlueSkyPRO-HMI/qml/RightPanel.ui.qml
- qt/BlueSkyPRO-HMI/qml/MainContent.ui.qml
- qt/BlueSkyPRO-HMI/qml/FlightChart.ui.qml
- qt/BlueSkyPRO-HMI/qml/RightPanel.Validation.Design.ui.qml
- qt/BlueSkyPRO-HMI/BlueSkyPRO-ManualValidation-DesignStudio.qmlproject
- 08_HMI/DESIGN_SYSTEM/BLUESKY_PRO_PANEL_BEHAVIOR_SPECIFICATION_001.md
- This checkpoint record

## Acceptance criteria

- [ ] Validation action appears only in manual creation mode.
- [ ] It pulses while waiting for completion.
- [ ] It cannot be activated before composition completion.
- [ ] It becomes clickable after completion.
- [ ] One click emits one request and hides the action.
- [ ] Starting a new manual mission resets the state.
- [ ] Qt Design Studio opens the project without .ui.qml JavaScript-block errors.
- [ ] No readiness or execution state is granted by the HMI action itself.

This checkpoint records the agreed behavior; it is not a certification approval or evidence that the planning-core integration is complete.
