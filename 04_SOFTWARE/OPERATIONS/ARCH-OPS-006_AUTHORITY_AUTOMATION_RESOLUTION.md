# ARCH-OPS-006 — Authority / Automation Resolution

This implementation stage closes the authority/automation resolution step required by the Operational Orchestrator integration contract.

The resolver composes the existing action automation level with current authority context after mandatory safety, regulatory, energy and authorization gates. It produces a deterministic execution status without executing UAV commands.

Verification is provided by the dedicated CTest target and CI workflow.
