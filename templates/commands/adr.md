---
name: adr
description: "Record an architecture decision as an ADR. Use this whenever a significant, hard-to-reverse technical or architectural choice is made, during or independent of the Spec-Driven Development lifecycle."
---

Record an Architecture Decision Record (ADR) for a significant technical or architectural choice.

An ADR should be created whenever a decision is:
- Hard to reverse, or expensive to change later
- Cross-cutting (affects multiple features, services, or teams)
- A deviation from a previous decision or an established pattern
- Likely to be questioned later ("why did we do it this way?")

Given the decision title/description provided as an argument, do this:

1. Run `scripts/create-new-adr.sh --json "{ARGS}"` from the repo root and parse the JSON output for ADR_NUM, ADR_FILE, ADR_DIR. All file paths must be absolute. The script auto-numbers the ADR and copies `templates/decision-template.md` into ADR_FILE with the number and title already filled in.

2. Gather context before writing:
   - Read the constitution at `/memory/constitution.md` for any principles the decision must align with.
   - IF currently on a feature branch (`specs/NNN-*`): read that feature's `spec.md` and `plan.md` (if present) for the requirements and constraints driving this decision.
   - Scan ADR_DIR for existing ADRs whose titles or topics overlap. If this decision changes or replaces one of them, note which ADR(s) it supersedes.

3. Fill in ADR_FILE following the template's existing section order exactly (Status, Context, Decision, Consequences, Alternatives Considered, Contract Alignment, Notes):
   - **Status**: set to `Proposed` unless the user's request indicates the decision is already agreed upon, in which case use `Accepted`.
   - **Context**: describe the problem being solved and list the concrete constraints (from the constitution and/or feature spec/plan) that bear on this decision.
   - **Decision**: state the decision clearly and explicitly, in one or two sentences that could be quoted on their own.
   - **Consequences**: list concrete Positive and Negative outcomes — trade-offs, not just benefits.
   - **Alternatives Considered**: list at least two real alternatives and the specific reason each was rejected.
   - **Contract Alignment**: note how this decision aligns with (or requires updating) the Repository Generation Contract / constitution.
   - **Notes**: list any follow-up actions, migration steps, or open questions.

4. IF this ADR supersedes an earlier one:
   - Update the old ADR's Status to `Superseded by ADR-NNN` (linking to the new file).
   - Mention the supersession in the new ADR's Notes section.

5. Report completion with the ADR number, file path, and its Status.

Context for this decision: {ARGS}

Keep the ADR self-contained — a reader should understand the decision and its trade-offs without needing to open the linked spec or plan.
