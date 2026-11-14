# eval-cal-node — Compiled System Reference

**Designation:** ECN
**Document role:** Canonical compiled technical reference for the eval-cal-node post-implementation calibration subsystem
**Source:** `doc/system/`
**Build command:** `bash doc/system/BUILD.sh`
**Document version:** 2.0 (2026-11-14) — canonical-compliance pass: added designation/source/build-command markers and the generated-artifact warning, removed the orphaned retired-subdirectory `.gitkeep` stubs (BDS Documentation Protocol v2.0 §5.3), made `BUILD.sh` fail-closed
**Protocol:** BDS Documentation Protocol v2.0

> **Generated artifact warning:** `doc/ECNSYSTEM.md` is assembled output. Edit
> the source modules under `doc/system/` and rebuild. Hand edits to the
> compiled artifact are overwritten by the next build.

This `doc/system/` tree is the canonical source of truth for eval-cal-node. It
uses explicit **truth classes**: *canonical facts* define the authority
boundary (proposal-emission only, mandatory human approval at Gate 3) and the
three-gate autonomy model; *snapshot facts* are dated, audit-derived
implementation inventory that may drift between audits. Chapters are
assembled into a designation-bound canonical artifact.

Assembly contract:

- Command: `bash doc/system/BUILD.sh`
- Validation: `bash doc/system/validate_snapshots.sh` runs during assembly
- Primary output: `doc/ECNSYSTEM.md`

| Part | File | Contents |
| --- | --- | --- |
| §1 | `00-overview.md` | System identity, role, and boundary with the rest of the Forge ecosystem. |
| §2 | `01-architecture.md` | High-level architecture, authority posture, and surface ownership. |
| §3 | `10-service-contract.md` | Public service contract, authority scope, and invariants. |
| §4 | `20-runtime.md` | Runtime topology, managed state, and lifecycle control. |
| §5 | `30-dependencies.md` | Upstream/downstream dependencies and degradation posture. |
| §6 | `40-governance.md` | Governance authority boundary, evidence, and audit posture. |
| §7 | `50-operations.md` | Deployment, observability, and bounded operator repair. |
| §8 | `90-appendices.md` | Appendices, glossary, and cross-references. |

## Quick Assembly

```bash
bash doc/system/BUILD.sh
```
