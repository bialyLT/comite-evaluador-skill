---
name: comite-evaluador
description: "Trigger: comite, comité evaluador, tesis, proyecto de investigación, research committee, peer review. Run a 4-agent research committee that interrogates, debates and answers a research request."
license: Apache-2.0
metadata:
  author: "liambialy"
  version: "3.0"
---

## Activation Contract

Load when the user asks the committee to build, assess, evaluate or defend research content: "evaluen la justificación que escribí", "evaluen este cambio metodológico", "tengo estos antecedentes y esta idea". Works for any thesis, research project, report or literature review, in any discipline. Accepts a question, a pasted section, a proposed change, a document corpus, or an external source.

## Hard Rules

- The Jurado interrogates; the three roles answer. The parent moderates and never argues a role's position.
- Round order is fixed: Defensor, then Escéptico, then Metodólogo, each receiving the previous posture. Each round the roles restart from their own posture, never inheriting the previous stance.
- Name the object under evaluation before round 1: the section, the change, or the idea. Pass it to every role so none drifts to auditing something else.
- Never posture on a bare idea. If it has no base (corpus, antecedents, stated context), ground it first and name what is missing.
- Audit only what the material supports. Declare the checks impossible for lack of material instead of guessing.
- The Metodólogo closes every round with `ITERAR: <gap>` or `CERRAR: <reason>`. The parent enforces it; a missing verdict counts as ITERAR. Maximum 3 rounds, then close with pending gaps marked.
- Every claim cites concrete evidence: section, page, line, quoted phrase.
- In audit mode, a piece that does not fit is a fit failure with its consequence, never a suggestion.
- Never end without a closing artifact: response table, compliance matrix, or candidate research lines.

## Decision Gates

| Situation | Action |
|---|---|
| User asks a question or requests a section | Loop: Jurado asks, three roles answer, iterate until CERRAR |
| User asks to evaluate a proposed change | Same loop, with the change as the object; audit its fit against the rules it touches |
| Material is a thesis or project under formal evaluation | Audit mode: Rosario Martínez puzzle law, each role owns one evaluator area, close with the compliance matrix |
| Material is partial, one section only | Audit the supported checks, list the checks needing the missing parts |
| User supplies a corpus | Reader subagent per document or cluster, clustering by theme when large, then the loop |
| User asks to propose research lines from a corpus | Loop, then close with the candidate research lines table |
| User asks for a written dictamen or informe | Static 3-part report instead of live rounds |
| A role returns off-scope or empty | Re-launch that role only |

## Execution Steps

1. Classify the request: build, assess, judge or propose. Treat the list as open.
2. Name the object under evaluation and the base available.
3. Prepare the material: delegate one reader per document or cluster when files exist; wait for all readers.
4. Launch the Jurado to formulate Round 1 questions from the user message, the object and the material.
5. Run the round sequentially: Defensor, Escéptico, Metodólogo. Relay each posture to the user.
6. Read the verdict. ITERAR: named gaps go back to the Jurado for targeted questions, roles restart, return to step 5. CERRAR: go to step 7.
7. Emit the closing artifact and one next action.

## Output Contract

Return the rounds (Jurado questions, three postures, verdict), then close with one of: the response table (eje evaluado, Defensor, Escéptico, Metodólogo y resolución); the compliance matrix (pieza auditada, exigido por, encaja, evidencia, acción correctiva); or the candidate research lines (línea, vacío que ataca, método, viabilidad, recursos, veredicto). Add one immediate next action.

## References

- [references/committee-roles.md](references/committee-roles.md) — role mandates, iteration duty, audit areas, reader mandate.
- [references/deliberation-loop.md](references/deliberation-loop.md) — round protocol, iteration gate, dispatch shapes, grounding, partial material.
- [references/question-templates.md](references/question-templates.md) — question banks per role, per request type, audit mode, change review, research lines.
- [references/rosario-martinez-framework.md](references/rosario-martinez-framework.md) — the puzzle law, the three general rules, criteria A to D, the four evaluators.
- [references/output-format.md](references/output-format.md) — round shape and the three closing artifacts.
