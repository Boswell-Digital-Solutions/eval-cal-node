# 50 — Operations

## Install

```bash
pip install -e .
```

Exposes the `eval-cal-node` console entrypoint.

## Commands

```bash
# Ingest a calibration record (optionally backfilling from prior records)
eval-cal-node record --input <record.json> [--backfill]

# Node status: revision, recent proposals, gate posture
eval-cal-node status

# Review a Gate-3 proposal awaiting human approval
eval-cal-node review --proposal <proposal_id>
```

## Configuration

All operational tuning lives in `config/cal_node_config.json`:

- `node_revision` — calibration math revision (change = explicit, auditable evolution).
- `min_sample_size`, `min_recurrence`, `min_new_recurrence` — sufficiency thresholds.
- `effect_floor`, `sensitivity_factor`, `rounding_digits` — bounded-movement math.
- `hold_after_decline_cycles` — anti-churn hold after a declined proposal.
- `parameters.*` — per-target control envelope (`current_value`, `param_min`,
  `param_max`, `max_movement`, `allowed`).

## Determinism + audit

- A run is reproducible: fixed record set + config + `node_revision` ⇒ identical
  proposals and decisions (same proposal ids).
- Proposals and decisions are written as versioned artifacts; provenance is
  emitted to DataForge-Local lineage when reachable.

## Documentation assembly

This `doc/system/` tree assembles into the canonical artifact:

```bash
bash doc/system/BUILD.sh          # -> doc/ECNSYSTEM.md (validated during assembly)
bash doc/system/validate_snapshots.sh
```

## Health / degraded modes

- DataForge-Local unreachable → lineage `lineage_missing`; calibration still
  completes and proposals are still written.
- Invalid record or config → fail-closed; no proposal emitted, non-zero exit.

## Which CI runs for which change

A change that touches only documentation runs the Documentation CI and no code CI.
A change that touches any other file runs the code CI.
A change that touches both runs both.
If the scope is unknown, the code CI runs.

The code CI is `.github/workflows/ci.yml`.
It installs the package and runs `pytest`.
It has a workflow-level `paths-ignore` filter on `push` and `pull_request`.
The filter ignores `docs/**`, `doc/**` and `**/*.md`.
A change to `.github/workflows/**` is code and runs the code CI.

No re-include exists.
No source file or test reads a documentation file from the repository.
The tests write and read Markdown summaries only in temporary directories.
`pyproject.toml` has no `readme` field, and the package data lists only `schemas/*.json` and `data/*.json`.
If code starts to read a documentation file, the filter must re-include that path.
Then the filter must use `paths` with `!` patterns, because `paths-ignore` cannot re-include.

The Documentation CI is `.github/workflows/documentation.yml`.
It runs on changes to `docs/**`, `doc/**`, `**/*.md` and its own file.
It runs `bash doc/system/BUILD.sh`.
It fails if `git diff --exit-code -- doc` shows a difference.
The assembled `doc/ECNSYSTEM.md` must be built from its parts and committed.

No scheduled run exists.
No secret scan or other security scan exists in this repository.
If a scan is added, it must run on every change, documentation included.

Do not add a required check on a path-filtered workflow.
A workflow that does not start leaves the check pending, and the pending check blocks the merge.
