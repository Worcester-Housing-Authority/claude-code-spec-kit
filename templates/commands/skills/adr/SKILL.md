---
name: "speckit-adr"
description: "Record Architecture Decision Records (ADRs) for significant, hard-to-reverse technical or architectural choices made during Spec-Driven Development. Use this whenever you and the user land on a decision that would be expensive to reverse, that deviates from an existing pattern or prior ADR, that picks between competing technical approaches (databases, frameworks, auth models, service boundaries, data formats, etc.), or that the user explicitly asks to document, write up, or 'record' as a decision. Trigger this proactively during /plan or /tasks work when such a choice is made, not only when the user says the word 'ADR.'"
---

# Architecture Decision Records (ADR)

Use this skill to capture significant technical/architectural decisions as numbered, durable records, so future readers (including future-you) know what was decided and why without re-deriving it.

## When to use this

Don't wait for the user to say "ADR." Recognize decision moments and offer or proceed:

- A choice is hard or expensive to reverse (data store, auth model, service boundaries, wire formats, core dependencies)
- The choice cuts across multiple features/services, not just one file
- It deviates from an existing ADR or established project pattern
- Two or more real alternatives were on the table and one was picked
- The user says things like "let's go with X instead of Y," "we decided to...", "document this decision," or "write this up as an ADR"

Skip it for reversible, local implementation details (variable names, a single function's internal structure, formatting choices) — those don't need an ADR.

If it's ambiguous whether a decision is significant enough, ask the user in one line rather than silently skipping or silently creating one.

## Workflow

1. **Create the numbered file.** From the repo root, run:
   ```
   scripts/create-new-adr.sh --json "<short decision title>"
   ```
   Parse the JSON for `ADR_NUM`, `ADR_FILE`, `ADR_DIR`. This auto-increments the ADR number and copies `templates/decision-template.md` into `ADR_FILE` with the number/title pre-filled. Use absolute paths from here on.

2. **Gather context before writing anything else:**
   - Read `/memory/constitution.md` for principles the decision must respect.
   - If on a feature branch (`specs/NNN-*`), read that feature's `spec.md` and `plan.md` (if present) for the requirements driving the decision.
   - List `ADR_DIR` and skim titles of existing ADRs for overlap — this decision may supersede one of them.

3. **Fill in `ADR_FILE`**, preserving the template's section order exactly (Status, Context, Decision, Consequences, Alternatives Considered, Contract Alignment, Notes):
   - **Status** — `Proposed` by default; use `Accepted` only if the user indicates it's already settled and being acted on.
   - **Context** — the problem, plus concrete constraints pulled from the constitution and/or spec/plan.
   - **Decision** — one or two sentences, stated plainly enough to quote on its own.
   - **Consequences** — real trade-offs under Positive and Negative, not just upsides.
   - **Alternatives Considered** — at least two genuine alternatives with the specific reason each was rejected.
   - **Contract Alignment** — how this aligns with, or requires updating, the constitution/Repository Generation Contract.
   - **Notes** — follow-ups, migration steps, open questions.

4. **Handle supersession.** If this decision replaces an earlier ADR, update that ADR's Status to `Superseded by ADR-NNN` (with a link) and note the supersession in the new ADR's Notes.

5. **Confirm, don't just announce.** Tell the user the ADR number and file path, and give a one-line summary of the decision. If you created it proactively (the user didn't ask by name), say so plainly, e.g. "I've logged this as ADR-004 since it's a hard-to-reverse choice — want me to adjust anything?"

## Notes

- This skill and the `/adr` slash command do the same underlying work — the skill exists so the decision gets recorded even when the user doesn't think to invoke the command explicitly.
- Never fabricate alternatives or consequences the user didn't discuss — ask if it's unclear what was actually considered rather than inventing a plausible-sounding rejected option.
- Keep each ADR self-contained: a reader shouldn't need to open the linked spec/plan to understand the decision and its trade-offs.
