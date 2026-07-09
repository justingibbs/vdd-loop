# gherkin-guidelines.md

*How to write a good `.feature` file. This is guidance for the **Validation**
technique, the deterministic half of Verification. Its sibling,
`evaluation-guidelines.md`, plays the same role for the **Evaluation** technique
(`@eval` lines in `.feature` files, with optional `.rubric.md` detail).*

> **Provenance.** This file is **forked and adapted** from
> [AutomationPanda/gherkin-guidelines-for-ai](https://github.com/AutomationPanda/gherkin-guidelines-for-ai)
> by Pandy Knight, used under the MIT License. It retains that MIT license and
> copyright notice (see the end of this file). VDD's adaptation reframes Gherkin as a
> **verification standard** — the thing that proves a goal — rather than a
> specification format, and maps scenarios onto Goal Storming's YELLOW and RED cards.
> The underlying Gherkin craft is Pandy Knight's; the VDD framing is ours.

---

## Where this fits

```
VERIFICATION  ("what proves this is done?")
├── Validation  (deterministic, binary)  → .feature            ← THIS GUIDE
└── Evaluation  (scored, judgment-based) → @eval lines in .feature ← evaluation-guidelines.md
                                           (+ optional .rubric.md detail)
```

In VDD a `.feature` file is not a spec of what to build — it's the **deterministic
verification standard** the agent loop runs against. Each scenario is a validation
that either passes or fails; the loop is done (on the Validation side) when every
scenario is green. The scenarios come from Goal Storming:

- **🟨 YELLOW cards → positive scenarios** — "what deterministic check proves this
  goal?"
- **🟥 RED cards → negative scenarios** — "what must never happen?"

Both live in the same feature file. See *Positive and negative validations* below.

---

## Guiding principles

- **Describe behavior, not implementation.** A scenario says *what* is true, never
  *how* the code achieves it.
- **Write for a human reader first.** Someone who doesn't know the feature should
  understand it. (Pandy Knight's "Golden Rule": write Gherkin for others as you'd
  want it written for you.)
- **Specify with concrete examples.** Real, realistic values — not `foo`/`bar`.
- **One behavior per scenario.** The cardinal rule. A scenario proves exactly one
  thing.
- **Scenarios are independent.** Each runs on its own, in any order, with no
  dependence on another scenario having run first.

These principles are what make a `.feature` file a *trustworthy* verification
standard: a wrong implementation can satisfy a vague spec, but it cannot satisfy a
tight, behavior-focused, independently-runnable scenario.

---

## Files and organization

- Put Gherkin in `*.feature` files, **kebab-case** named.
- In VDD, `.feature` files live in `units/[name]/[name].feature`. Large units may
  split across multiple `.feature` files by capability area — all live in the same
  unit folder. One `Feature` block per file, maximum.
- The unit folder also holds `goals.md`, `@eval`-annotated `.feature` files, an
  optional `.rubric.md`, and the agent working docs. Everything for a unit in one place.

---

## Formatting

- Indent sections (`Feature`, `Background`, `Scenario`, `Scenario Outline`,
  `Examples`) by 2 spaces; indent steps under them.
- Keep lines under ~120 characters.
- One blank line between adjacent scenarios and between major sections. **No** blank
  lines between the steps within a scenario.
- **Minimize comments** — the Gherkin should read for itself.
  - *VDD adaptation:* a short **header comment** tying the file to its 🟩 GREEN goal,
    followed by any `@eval` lines for the Evaluation layer, is the standard header
    form — see the recommended template below. This is the one comment block worth
    keeping. Keep scenario bodies comment-free.

---

## Vocabulary

- Use **consistent terminology** for roles, objects, and states throughout the file.
- Don't swap in synonyms unless the product genuinely distinguishes them ("user" vs
  "admin" only if they behave differently). Drifting vocabulary makes a scenario
  ambiguous, and an ambiguous validation isn't a reliable standard.

---

## The Feature block

- Name the feature after its **behavior area**, and align it with the file name.
- Single-line feature title.
- Put the **user story** right under the title:

```gherkin
Feature: Password reset
  As a user who has forgotten my password
  I want to reset it through a time-boxed, single-use link
  So that I can regain access to my account without contacting support
```

---

## Background

- Optional. Use it **only** when the same setup applies to multiple scenarios.
- At most **one** `Background` per feature.
- Don't use it for setup that only one scenario needs.
- Keep it short — a bloated Background hides context from each scenario.

---

## Scenarios

- **Single-line, behavior-focused title.** The title names the one behavior proven.
- **Chronological steps** that read as Arrange → Act → Assert.
- **Declarative, not imperative.** Say the behavior, not the mechanics. Prefer
  *"the user submits a new password"* over *"the user clicks #submit-btn."*
- **Domain-level abstraction.** No UI selectors, XPath, or clicks; no HTTP endpoints,
  SQL, or schema — **unless the behavior under test is inherently at that layer.**
- **State over navigation.** Prefer a state-based Given ("a valid reset token was
  issued") to a step-by-step tour of how the user got there.
- **Minimal but sufficient Given.** Enough context to make the behavior meaningful,
  no more.
- **Don't bundle unrelated concerns.** Functionality, performance, and accessibility
  are separate scenarios (usually separate goals) unless there's an explicit reason.
- **Concrete, realistic data.** Real-looking emails, amounts, ids.
- **Fewer than ~10 steps.** Use a table for longer data; if a scenario sprawls, it's
  probably testing more than one behavior.
- **`Scenario Outline` only for true input variation** — identical behavior across
  multiple data rows. Don't use it to pad row count without distinct behavioral value.

---

## Steps: language and semantics

- **Third person, present tense, subject–predicate.** *"The account password is
  unchanged."*
- Correct grammar and spelling; minimal punctuation.
- **Double quotes** around string parameters: `"user@example.com"`.
- **One action or assertion per step.** Split compound steps rather than "and"-ing
  inside one.
- **Strict `Given` → `When` → `Then` order.** `Given` arranges, `When` acts, `Then`
  asserts. One `When`/`Then` behavior per scenario — multiple `When-Then` pairs mean
  multiple behaviors, so split them.
- Continue a step type with **`And`** (and `But`); **avoid `Or`** — a branch is two
  scenarios.
- **`Then` outcomes must be observable and checkable.** *"the login is rejected"* is
  verifiable; *"it works"* is not. A `Then` you can't check deterministically belongs
  in a rubric, not here.
- Use **doc strings** (`"""`) for multiline or structured payloads instead of long
  quoted strings.

---

## Tables

- Use a **step data table** for a list or set instead of a long `And` chain.
- Concise, **kebab-case** headers.
- Keep a table to a single screen; if it grows past that, reconsider the scenario.

---

## Positive and negative validations *(VDD adaptation)*

VDD makes the negative case first-class, because "what must never happen" is where
safety, security, and data-integrity live. Both kinds are ordinary scenarios in the
same file; the card color they came from is the only difference.

- **Positive (🟨 YELLOW):** the behavior that proves the goal is met.

  ```gherkin
  Scenario: A valid token lets the user set a new password and log in
    Given a valid, unexpired reset token was issued for "user@example.com"
    When the user submits a new password that meets the password policy
    Then the password is updated
    And the user can log in with the new password
  ```

- **Negative (🟥 RED):** the thing that must never happen, framed as a prohibition,
  with an assertion that the bad outcome did **not** occur.

  ```gherkin
  Scenario: An expired token never grants access
    Given a reset token was issued for "user@example.com" 16 minutes ago
    When the user submits a new password with that token
    Then the request is rejected as expired
    And the account password is unchanged
  ```

A RED scenario should assert the **absence** of the forbidden effect (here, *"the
account password is unchanged"*), not merely that an error was shown — otherwise it
can pass while the bad thing quietly happened.

---

## The boundary with the Evaluation layer

Keep deterministic checks here and judgment-based ones as `@eval` lines. The two can
describe the *same* output at different altitudes:

- *"The summary is 150 words or fewer"* → deterministic → **scenario in this file**.
- *"The summary is concise — no filler"* → judgment → **`@eval` line in this file**.

If a `Then` can't be settled the same way by any competent checker, it's probably an
evaluation, not a validation. Move it to an `@eval` line. (See `evaluation-guidelines.md`.)

---

## Anti-patterns to avoid

- Multiple unrelated behaviors in one scenario.
- Bundling functional + performance + accessibility with no justification.
- UI selectors / automation mechanics leaking into step text.
- Over-specified navigation where a state-based Given is clearer.
- Bloated `Given` chains with context the behavior doesn't need.
- Vague `Then` assertions with no observable signal.
- Placeholder data (`foo`, `test123`) that doesn't read as a real specification.
- `Scenario Outline` rows that add no distinct behavior.
- Walls of text — enormous scenarios or tables.
- A RED scenario that only checks for an error message, not the absence of the effect.

---

## Recommended template

```gherkin
# [name].feature
#
# Verification standard for [unit]. Scenarios come from Goal Storming's YELLOW
# (validation) and RED (negative validation) cards.
# Goal (GREEN): [the one-line goal this unit proves]
#
# @eval | E1 | [Name] | [0-5 | PASS/FAIL] | [≥N | PASS] | [one sentence: what is judged]
# @eval-detail | [name].rubric.md  ← include only when criteria need anchor descriptions
#
# (Remove @eval lines if the unit has no BLUE cards — purely deterministic.)

Feature: [Behavior area]
  As a [role]
  I want [capability]
  So that [outcome / goal]

  Background:
    Given [shared setup used by multiple scenarios]

  # --- YELLOW: validations ---

  Scenario: [one positive behavior]
    Given [state]
    When [action]
    Then [observable outcome]

  # --- RED: negative validations ---

  Scenario: [one thing that must never happen]
    Given [state]
    When [action]
    Then [the request is rejected]
    And [the forbidden effect did not occur]

  # Input variation on identical behavior:
  Scenario Outline: [behavior] for <case>
    Given [state for <case>]
    When [action]
    Then [outcome for <result>]

    Examples:
      | case | result |
      | ...  | ...    |
```

---

## Quick checklist

- [ ] One independently-runnable behavior per scenario.
- [ ] No unrelated concerns bundled together.
- [ ] Consistent vocabulary throughout.
- [ ] Domain-level abstraction — no leaked UI/automation/DB mechanics.
- [ ] State-based Givens over navigation tours.
- [ ] Minimal but sufficient `Given`.
- [ ] Concrete, realistic data.
- [ ] Third person, present tense, subject–predicate steps.
- [ ] Strict `Given` → `When` → `Then`; observable `Then` outcomes.
- [ ] RED scenarios assert the forbidden effect did **not** occur.
- [ ] Fewer than ~10 steps; tables fit one screen.
- [ ] Blank line between scenarios; none within a scenario's steps.
- [ ] Header comment ties the file to its GREEN goal; `@eval` lines present for any BLUE cards.

---

## License and provenance

The Gherkin guidance in this file is adapted from **gherkin-guidelines-for-ai** by
Pandy Knight, provided under the MIT License. VDD's adaptations (the
verification-first framing, the YELLOW/RED card mapping, the Evaluation-boundary
section, and the traceability header convention) are provided under the same MIT
terms. Per that license, the original copyright and permission notice is retained
below:

```
MIT License

Copyright (c) 2026 Pandy Knight

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
