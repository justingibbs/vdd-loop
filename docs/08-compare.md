# 08 — How VDD compares

*Where VDD sits against the methodologies it descends from, borrows from, and
reacts to — and an honest accounting of what is genuinely new here versus
inherited. If you read one section, read "The honest part" first.*

---

## The honest part

**Verification-first is not a new idea.** It is the *original* idea of the
acceptance-test lineage: ATDD, Specification by Example, and BDD all said
"write the executable examples first, and let them drive the build." If you
strip VDD to "write the `.feature` before the code," it is BDD wearing a new
lanyard — and a skeptic who says so is right.

What changed is not the idea but the **economics**. When a human implements,
the spec is the scarce artifact and the tests are labor — so in practice the
BDD lineage decayed into test-automation-after-the-fact for most teams. When
an agent implements, the spec becomes *cheap* (the agent can derive a
perfectly plausible one) and the verification standard becomes the only
artifact the human irreplaceably owns. VDD is what the acceptance-test lineage
looks like when you rebuild it for that inversion, rather than adapting it.

The genuinely new parts are the ones that only make sense with an agent as the
builder:

1. **The Evaluation layer.** BDD has no home for "the summary is faithful and
   neutral" — outcomes with no single correct answer. `@eval` lines (scale,
   threshold, judge blind to the pass bar, gates never averaged) make
   judgment-based outcomes first-class citizens of the standard, next to the
   deterministic scenarios. This matters most for LLM-powered features, where
   classic Gherkin simply runs out of road.
2. **Goal Storming.** The lineage starts at the user story — which already
   presumes someone decided what mattered. Goal Storming starts one level up
   ("what does success mean here?") and derives verifications, constraints,
   and concept from ratified goals, with the LLM as a proposing-never-ratifying
   participant.
3. **The clean-session handoff and derivability.** BDD assumed the people in
   the conversation would build the thing. VDD assumes the builder was *never
   in the room* — so the standard must carry enough context, on its own, for a
   cold session to converge on the intended thing. That constraint (checked by
   `derivability-review`, contracted through `llm.txt`) has no equivalent in
   the older practices, because it never needed one.
4. **A contract instead of a harness.** VDD deliberately does not ship the
   loop. It ships the files and the terms under which a verdict counts
   (standard read-only, executed checks only, bounded loops, blind judges) and
   leaves the execution machinery to the consuming agent. The first dogfood
   run proved this boundary the hard way — see
   `units/gherkin-review/field-notes.md`, FN-10.

## Against each neighbor

### TDD

Same instinct — red before green — different altitude and audience. TDD's unit
tests are written *by the implementer, for the implementer*, at the level of
code units; they are part of the build, and in VDD they remain the coding
agent's own business. VDD's standard sits above: behavior- and outcome-level,
authored by people who may never see the code. TDD proves the code does what
the programmer intended; VDD's standard defines what "done" means before
anyone (human or agent) intends anything.

### BDD / ATDD / Specification by Example

The direct ancestors — the card colors even echo the Three Amigos
conversation. Shared: executable examples first; concrete scenarios as the
shared language; the conversation mattering more than the artifact. Different:
the four numbered items above, plus a shift in what the artifact is *for* — a
BDD feature file is a specification humans align on and a regression suite
afterward; a VDD `.feature` is a **done-signal for an autonomous loop**, which
is why it must be self-sufficient, why negative scenarios must assert the
absence of the effect (a loop will happily pass an error-message check while
the bad thing quietly happens), and why the Evaluation layer exists at all.

### Spec-Driven Development (Boonstra)

The thing VDD is a response to, and the best statement of the opposing bet.
SDD says: with agents doing the building, the **spec** is the production-grade
artifact — invest there. VDD's wager is that a spec, however good, can be
satisfied by the wrong implementation, and that the standard of proof is the
better place for the irreplaceable human investment: derive the spec *from*
the verifications rather than bolting verification onto the spec. The two
agree on far more than they differ (production-grade artifacts, protected
constraint surfaces, agents doing the labor); the difference is which artifact
sits at the root of the dependency tree. `spec.md` survives in VDD — demoted
from root to constraint surface. Read Boonstra's paper; it is the clearer,
more complete argument, and this repo is a riff on it.

### Vibe coding

The other pole. Vibe coding is conversation-driven building with verification
by vibes — you look at what came out and react. It is genuinely the right tool
for exploration, and VDD borrows its spirit in one place: Goal Storming is
loose, generative, and conversational on purpose. The difference is what
happens at the boundary: vibe coding never writes down what would prove the
work correct, so every session re-litigates "is this right?" from scratch, and
nothing bounds the loop. VDD is what you reach for when the cost of being
wrong exceeds the fun of being fast — and a reasonable team uses both, vibing
the prototype and Goal-Storming the thing that ships.

## The comparison in one table

| | Root artifact | Verification | Who builds | Judgment-based outcomes | Loop |
|---|---|---|---|---|---|
| **TDD** | unit tests | code-level, by implementer | human | no home | red-green-refactor, human-paced |
| **BDD / SbE** | executable examples | behavior-level, before build | the people in the conversation | no home | CI regression, human-paced |
| **SDD** | the spec | derived from the spec, after | agent | acknowledged, unstructured | agent loop against spec |
| **Vibe coding** | the conversation | by inspection, after | agent | everything is judgment | unbounded |
| **VDD** | the verification standard | *is* the root artifact | agent, cold, never in the room | first-class (`@eval` layer) | consuming agent's, bounded by contract |

---

*Like everything here, this comparison was written early — after one dogfood
run, zero production uses. The claims about the neighbors are fair summaries;
the claims about VDD are still mostly promises. Field notes will keep score.*
