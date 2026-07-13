# field-notes.md — settle-up pilot

*Continues the numbering convention from `units/gherkin-review/field-notes.md`
(FN-1…11); these are FN-P1… for the pilot.*

## FN-P1 — the derivability probe demonstrably paid for itself

The causal chain is unusually clean: the probe found 8 risky gaps (SPEC
1.0.0), the authoring session closed them (1.1.0), and the cold builder then
went green in one iteration and *unprompted* credited the derivability pass
for "removing essentially all guesswork." This is the best evidence yet for
the skill the restructure bet on. Corollary: the probe's sharpest finding —
"the standard is airtight for the 8 pinned inputs and silent on the wider
surface; two green implementations could differ on real ledgers" — is a
failure mode *nothing else in the flow* would have caught.

## FN-P2 — another first-iteration PASS; the loop's failure states remain unexercised

Same pattern as the dogfood (FN-8), but stronger evidence this time because
author and builder were genuinely separate contexts. Two readings, both
probably true: (a) tight standards produce one-shot builds — that *is* the
claim working; (b) VDD has still never observed its own PAUSE/stuck/GIVE-UP
machinery in the wild. A future pilot could deliberately hand off with known
gaps (skip the derivability fixes) to watch the loop struggle — a controlled
experiment the two runs so far have accidentally avoided.

## FN-P3 — builder friction worth folding back into the docs

From the builder's own report: (1) "recompute independently of the settle
package" is underspecified at the edges — may the oracle share stdlib parsing?
(2) error-*reason* wording is barely constrained — a hostile implementation
could pass the `mentions` checks with unhelpful text; either pin a reason
grammar or accept the looseness explicitly; (3) a wrong-field-count row can't
"name the offending field," and SPEC doesn't say what that reason looks like;
(4) `standard.checksums` existed but no contract line told the builder to
verify it — it did so voluntarily. Candidate one-liners for `llm.txt` (verify
checksums when present) and for authoring guidance (state the oracle's
independence boundary).

## FN-P4 — the contract held under interruption

The builder hit a session limit mid-build. On resume it *re-ran behave rather
than trusting its earlier output* — exactly the executed-checks-only behavior
the contract demands, held across a context break. Also its self-reported
"closest temptation" (stub the property steps thinly after "seeing" the core
was correct) is precisely the failure mode the independent-oracle protocol
line was added to prevent — the line, added because of the probe, did its job.

## FN-P5 — the builder generalized beyond the pinned scenarios

The audit probed two SPEC-only rules no scenario verifies (negative amount,
missing file / exit 2) and both were implemented correctly. Encouraging, but
it is *one* builder: the probe's warning that the unpinned surface is where
implementations diverge stands. If the unpinned behavior matters, pin it —
SPEC prose is context, scenarios are proof.

## FN-P6 — bootstrap and goal storming were the frictionless stations

Bootstrap was mechanical; the solo-mode Goal Storming (proposal → ratification
→ hardening) took one interaction at the gate. The methodology's overhead
landed almost entirely in standard-tightening — which FN-P1 suggests is
exactly where the value is. Cost and value are currently co-located; a good
sign, worth re-checking on a larger unit.
