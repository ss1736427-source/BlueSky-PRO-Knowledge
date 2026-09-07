# BLUESKY PRO — TECHNICIAN SHIFT WORK ASSIGNMENT AND COMPLETION 001

## Status
CANDIDATE_FOR_AGREEMENT

## Purpose
Define the minimal Technician workflow for receiving work assigned by the Engineer for the current shift, performing the authorized work, and recording its completion in BlueSky PRO.

## Role Boundary
The Administrator assigns users to their roles. The Engineer determines which work a Technician is authorized and assigned to perform within the Engineer's authority and the Technician's permissions.

The Technician shall see and act only on work assigned to the Technician and within the Technician's granted access.

## Primary Technician Workflow

```text
ENGINEER
   ↓
ASSIGN WORK
   ↓
TECHNICIAN — CURRENT SHIFT
   ↓
VIEW ASSIGNED WORK
   ↓
OPEN TASK
   ↓
PERFORM WORK
   ↓
ENTER RESULT
   ↓
COMPLETE / REPORT FINDING
   ↓
ENGINEER REVIEW WHERE REQUIRED
```

## Technician Main View

The Technician's primary work screen shall be task-oriented and shall show the work relevant to the current shift rather than the full technical structure of the fleet.

Minimum immediately available information:

- task status;
- assigned work;
- priority where applicable;
- UAV identifier;
- equipment/component concerned;
- required action;
- relevant due time/date where applicable;
- indication when Engineer attention is required.

Detailed technical information shall be available from the selected task when needed and shall not permanently occupy the main screen.

## Work Assignment

An Engineer shall be able to assign a defined maintenance/technical task to a Technician.

The assignment should identify, as applicable:

- Technician;
- UAV;
- equipment/component;
- task description;
- applicable procedure or reference;
- priority;
- planned completion period;
- restrictions or special instructions.

The assignment shall be traceable to its assigning Engineer.

## Task States

The implementation should support a controlled task lifecycle. At minimum:

```text
ASSIGNED
   ↓
IN PROGRESS
   ↓
COMPLETED
```

Additional states such as `BLOCKED`, `REQUIRES ATTENTION` or `REJECTED FOR EXECUTION` may be introduced if required by the operational workflow, without changing the basic model.

## Completion Entry

After performing the assigned work, the Technician shall be able to record the result directly against the task.

The completion record shall support, as applicable:

- completion status;
- date/time;
- Technician identification;
- work/result note;
- findings or defects discovered;
- indication that additional work is required;
- relevant measured values or evidence where required by the applicable procedure;
- reference to attached technical evidence where supported.

The system shall distinguish between:

`WORK COMPLETED`

and

`UAV READY FOR FLIGHT`.

Completion of a Technician task shall not by itself release the UAV for operation.

## Findings / Exception Handling

If the Technician discovers a defect, abnormal condition or work that cannot be completed, the Technician shall be able to record the finding instead of falsely marking the task as completed.

The task shall then be routed for the appropriate Engineer decision where required.

```text
TASK
 ↓
FINDING
 ↓
ENGINEER REVIEW
 ├── additional work
 ├── restriction
 ├── corrective action
 └── other authorized disposition
```

## Engineer Control

The Engineer shall retain visibility of assigned work and its current state.

Where Engineer review is required, the completion/finding record shall become an input to the Engineer's fleet/UAV technical view.

## Access Control

Technician access is constrained by the permissions and technical scope determined by the Engineer. The Technician must not be able to use completion entry to grant themselves access, modify their authority, release a UAV, or alter Engineer-controlled permissions.

## UX Principle

The Technician interface shall answer one primary question immediately:

**"What work do I need to do on this shift?"**

The interface should therefore prioritize the current assigned work list and its status. Fleet-wide technical information, administrative functions and unrelated configuration data shall not be presented as persistent information.

## Integration

The workflow shall be compatible with the external maintenance integration architecture. BlueSky PRO may receive assignments or maintenance context from an external system and may return completion/finding records through the integration boundary where such integration is implemented.

The Technician workflow must remain usable without requiring BlueSky PRO to become a standalone MRO system.

## Traceability / Verification Considerations

Verify at minimum:

- only assigned tasks are visible to the Technician;
- task assignment is traceable to the Engineer;
- Technician access respects Engineer-defined scope;
- task state transitions are controlled;
- completion records retain author and timestamp;
- incomplete/blocked work cannot be falsely represented as completed;
- findings can be escalated to Engineer review;
- task completion does not independently produce flight release;
- completion data is available to the Engineer where required;
- the workflow remains usable with the intended minimal-information UX.
