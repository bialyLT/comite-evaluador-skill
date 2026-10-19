# Deliberation Loop

## Actors in a round

| Actor | Runs as | Receives | Returns |
|---|---|---|---|
| Jurado | subagent, same session continued across rounds | user message, material, named gaps from the previous round | 3 to 5 numbered questions, each addressed to a named role |
| Defensor | fresh subagent each round | round questions, material, previous round summary | posture, evidence with citations |
| Escéptico | fresh subagent each round | round questions, material, Defensor posture | rebuttal posture, the concrete trap |
| Metodólogo | fresh subagent each round | round questions, material, Defensor + Escéptico postures | integration, gap list, iteration verdict |

The parent is the moderator: it dispatches, relays, and enforces the gate. It never argues a role's position.

## Round protocol

1. The Jurado formulates 3 to 5 questions, each addressed to a named role. Every question must be answerable from the material plus the reader findings, and answerable in one short paragraph.
2. The parent launches the Defensor, waits, relays its posture.
3. The parent launches the Escéptico with the Defensor posture attached, waits, relays.
4. The parent launches the Metodólogo with both postures attached, waits, relays.
5. The parent reads the Metodólogo verdict and applies the gate.

Keep the three roles in one dispatch chain. Launching them in parallel breaks the rebuttal and the integration.

## Iteration gate

The Metodólogo closes with exactly one of:

- `ITERAR: <named gap>` — evidence or a decision is still missing. The parent sends the named gaps back to the Jurado, which formulates new targeted questions, and the three roles restart from their postures.
- `CERRAR: <reason>` — the exchange reached a defensible position. The parent builds the final table.

Rules:

- A missing or ambiguous verdict counts as ITERAR.
- Maximum 3 rounds. The third closes regardless, with pending gaps written into the table as Pendiente.
- Never let a role repeat a posture identical to the previous round. The Jurado must target the named gaps.
- If the user interrupts with a new instruction, treat it as a new request and restart the loop.

## Material resolution

- Corpus present: the material is the reader findings plus the relevant excerpt.
- No corpus: the material is the user's own message, the round objective, and any context already established in the conversation. Never pass an empty Material block; a role with no material must state that it is reasoning from first principles.

## Object under evaluation

The parent names it before round 1 and passes it verbatim in every dispatch:

| User request | Object under evaluation |
|---|---|
| "evaluen la justificación que escribí" | That section only, not the whole thesis |
| "evaluen este cambio metodológico" | The proposed change, judged against the rules it touches |
| "tengo estos antecedentes y esta idea" | The idea, judged against the corpus findings |

Without this, roles drift to auditing the whole thesis and the deliberation answers a question the user did not ask.

## Grounding a bare idea

An idea with no base cannot be evaluated. When the user supplies an idea without corpus, antecedents or stated context, the parent must first ground it: name the base it would rest on, or ask for it, and record the base as a stated assumption in the dispatch. Never let a role posture against an unsupported idea as if it were a research object.

## Partial material in audit mode

Audit mode assumes the full thesis. When only one section is available:

- Audit every check the available material supports.
- List the checks that need the missing parts, naming the part each one needs. Example: "R2 (simetría léxica) no verificable: falta el Título y la Hipótesis General".
- Never infer the missing parts and never report an unverified rule as passing.

## Dispatch shape

Every role subagent receives:

```
## Object under evaluation
<the section, change or idea, named exactly as the parent declared it>

## Round objective
<one sentence: what this round must settle>

## Round questions
<numbered questions from the Jurado, each marked with the addressed role>

## Material
<corpus excerpt, or reader findings, or the user's own text>

## Base and assumptions
<what the evaluation rests on; for a bare idea, the base that was supplied or assumed>

## Previous postures
<Defensor and Escéptico postures for this round, or "first round">

## Your role
<the mandate from committee-roles.md>

## Required output
<posture, evidence with citations, and for the Metodólogo the iteration verdict>
```

## Static dictamen variant

When the user explicitly asks for a written dictamen or informe on a corpus, skip the live rounds and emit the static 3-part report: the four role cards, the roundtable on the sharpest point, then the response table. Roles run as four parallel subagents, because no rebuttal chain is needed.

## Audit mode

When the material is a thesis, research report or project under formal evaluation, the whole committee evaluates under the puzzle law. Read `rosario-martinez-framework.md` before the first round.

- The round objective is one rule (R1, R2, R3) or one section (A, B, C, D).
- The Jurado directs each question to the owner of that area, using the audit question bank.
- The Metodólogo names the piece that does not fit, the rule it breaks and what is missing.
- The closing artifact is the audit compliance matrix, not the generic response table.

## Evaluating a proposed change

When the object is a change to the methodology, the design or a section:

- The round objective is the fit of that change against the rules it touches: R2 when it alters the verb or the variables, R3 when it adds or removes objectives, the design coherence rules of section B when it alters the approach, the operationalization matrix of section C when it alters the instruments.
- The Escéptico attacks the change itself: what breaks, what becomes unverifiable, what was already committed elsewhere in the thesis.
- The Metodólogo states the required knock-on edits, naming every other section that must change for the piece to fit again.
- When the change touches the corpus findings, the reader findings are part of the material.

## Proposing research lines from a corpus

When the user asks what investigations the corpus and the idea enable:

- The loop evaluates the idea against the corpus findings first, using the ordinary round protocol.
- After CERRAR, the closing artifact is the candidate research lines table, not the response table.
- Each candidate must name the gap it attacks, the method, the feasibility, the resources and the committee verdict. A candidate without a gap identified in the corpus is discarded, not proposed.
