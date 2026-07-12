#!/usr/bin/env python3
"""Mechanical Validation runner for the gherkin-review unit.

Asserts, with a binary exit status, every deterministic scenario in
gherkin-review.feature. No LLM is involved in any verdict here (FN-6):
the skill's findings reports are inputs, this script is the judge of record
for the Validation layer.
"""

import hashlib
import re
import sys
from pathlib import Path

UNIT = Path(__file__).resolve().parent
REPO = UNIT.parent.parent
RUNS = UNIT / "runs"
GUIDELINES = [REPO / "gherkin-guidelines.md", REPO / "evaluation-guidelines.md"]

failures: list[str] = []
passes: list[str] = []


def check(name: str, ok: bool, detail: str = "") -> None:
    (passes if ok else failures).append(f"{name}{': ' + detail if detail and not ok else ''}")
    print(f"{'PASS' if ok else 'FAIL'}  {name}" + (f"  [{detail}]" if detail and not ok else ""))


def norm(s: str) -> str:
    s = s.lower()
    s = re.sub(r"[#*`_]", "", s)
    s = re.sub(r"\s+", " ", s)
    return s.strip()


def findings_rows(path: Path) -> list[dict]:
    """Parse `| severity | location | guideline | finding |` rows."""
    rows = []
    if not path.exists():
        return rows
    for line in path.read_text().splitlines():
        if not line.strip().startswith("|"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 4:
            continue
        if cells[0].lower() == "severity" or set(cells[0]) <= {"-", " ", ":"}:
            continue
        rows.append({"severity": cells[0].lower(), "location": cells[1],
                     "guideline": cells[2], "finding": cells[3]})
    return rows


def heading_matches(cited: str, headings: list[str]) -> bool:
    c = norm(cited)
    return any(c and (c in h or h in c) for h in headings)


# --- Collect real guideline headings (for the RED citation scenario) ---
real_headings = []
for g in GUIDELINES:
    for line in g.read_text().splitlines():
        if line.startswith("## ") or line.startswith("### "):
            real_headings.append(norm(line))

# --- Scenario Outline: each seeded violation caught, located, cited ---
manifest = (UNIT / "fixtures" / "manifest.tsv").read_text().splitlines()
for row in manifest[1:]:
    if not row.strip():
        continue
    fixture, token, citations = row.split("\t")
    accepted = [norm(c) for c in citations.split(";")]
    report = RUNS / (Path(fixture).stem + ".findings.md")
    rows = findings_rows(report)
    hit = any(token.lower() in r["location"].lower()
              and heading_matches(r["guideline"], accepted) for r in rows)
    check(f"seeded defect caught: {fixture}", hit,
          f"no finding at '{token}' citing one of {citations}" if not hit else "")

# --- Scenario: clean exemplar has no must-fix findings ---
clean = findings_rows(RUNS / "password-reset.findings.md")
must_fix = [r for r in clean if r["severity"] == "must-fix"]
check("clean exemplar: no must-fix findings",
      (RUNS / "password-reset.findings.md").exists() and not must_fix,
      f"{len(must_fix)} must-fix finding(s)" if must_fix else "report missing")

# --- Scenario: SKILL.md conforms to the family format ---
skill = REPO / "skills" / "gherkin-review" / "SKILL.md"
if skill.exists():
    text = skill.read_text()
    fm = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    ok_fm = bool(fm) and "name:" in fm.group(1) and "description:" in fm.group(1)
    sections = ["## Purpose", "## Inputs", "## Outputs", "## Invariants",
                "## Procedure", "## Composes with"]
    missing = [s for s in sections if s not in text]
    check("SKILL.md family format", ok_fm and not missing,
          f"frontmatter ok={ok_fm}, missing sections={missing}")
else:
    check("SKILL.md family format", False, "skills/gherkin-review/SKILL.md missing")

# --- RED: reviewed files unmodified (checksums) ---
before = UNIT / "checksums.before"
if before.exists():
    changed = []
    for line in before.read_text().splitlines():
        if not line.strip():
            continue
        digest, rel = line.split(None, 1)
        p = REPO / rel.strip()
        now = hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else "MISSING"
        if now != digest:
            changed.append(rel.strip())
    check("reviewed files unmodified", not changed, f"changed: {changed}")
else:
    check("reviewed files unmodified", False, "checksums.before missing")

# --- RED: every citation resolves to a real guideline heading ---
bad_citations = []
for report in sorted(RUNS.glob("*.findings.md")) if RUNS.exists() else []:
    for r in findings_rows(report):
        if not heading_matches(r["guideline"], real_headings):
            bad_citations.append(f"{report.name}: '{r['guideline']}'")
check("all citations resolve to real guideline headings", not bad_citations,
      "; ".join(bad_citations))

print(f"\n{len(passes)} passed, {len(failures)} failed")
sys.exit(0 if not failures else 1)
