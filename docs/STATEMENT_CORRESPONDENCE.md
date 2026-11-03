# Statement correspondence (Fefferman's official statement, alternatives A to D)
**What this document is.** The package builder's reading of how the Lean statements in `ClayStatement/Fefferman.lean` correspond to C. Fefferman's official description of the Clay Navier-Stokes problem. It is **not** an independent confirmation, and the builder did not machine-compare the Lean text with the official text. Nothing here establishes that the statements match the official ones beyond what the table and lists show; read the official statement yourself and treat each row as a claim to check.
**Official statements, in the builder's words (not a quotation).** (A) existence and smoothness of solutions on R^3 for smooth, rapidly decaying, divergence-free initial data and zero force, with bounded energy. (B) the same on the 3-torus (periodic data). (C) breakdown on R^3: there are smooth divergence-free initial data and a smooth force, both with the stated decay, for which no smooth, bounded-energy solution exists. (D) breakdown on the 3-torus: the same with periodic data and force and periodic solutions.
**What the Lean file itself says about its source:**

> # Clay Millennium Problem: Navier–Stokes existence and smoothness Formal statements (A), (B), (C), (D) following C. Fefferman's official problem description. Equation numbers refer to that text. The prize is awarded for a proof of any one of the four, so the target is `ClayNavierStokes` below. Fidelity choices, v2 (each is a DC fidelity row for the reader to check). v2 aligns F1, F3 and F4 with Clay's literal text. The v1 choices were planner departures, and the (b) clause read-through exposed them. * F1. Equation (1) holds for t ≥ 0, as in Clay. The time derivative is taken within [0, ∞), so at t = 0 it is the one-sided derivative. * F2. Multi-index bounds |∂_x^α ∂_t^m g| are encoded by the norm of the full iterated Fréchet derivative. For the force, that is the derivative within the closed half-space. This encoding is equivalent to Clay's multi-index form. * F3. Decay exponents K range

## Computed facts about the Lean text (each is a script check, with the result shown)
| Check | Result |
|---|---|
| the file defines all four statements (A)(B)(C)(D) and their disjunction | True |
| number of clause docstrings in the file | 23 |
| clause docstrings mentioning pressure | 0:  |
| clause docstrings mentioning periodicity | 2 |
| `SolTorus` (the solution class of StatementB and StatementD) requires `PeriodicField u` AND `PeriodicField p`, i.e. the pressure is required to be periodic | True |

## The periodic-pressure erratum
The authors' formalization (`NavierStokes/ComparatorDefinitions.lean`, which is OpenAI's, derived from the Formal Conjectures project) says the pressure is also required to be 1-periodic in space, following errata appended to the official statement. Lines naming the errata in that file:

- `The pressure is also required to be 1-periodic, following the errata appended to the`
- `/-- The pressure is 1-periodic in space for all times $t \ge 0$ (Clay errata). -/`

Computed from the Lean text: the publisher's `SolTorus`, which defines the solution class for (B) and (D), requires the pressure to be periodic as well as the velocity (**True**), so the erratum is reflected in the publisher's statements as well as in the authors'. Whether the official text and its errata say exactly this is for a reader to confirm; this document does not establish it.

## Differences that are certain from the package structure (not from comparing text)
- The package proves BOTH the publisher's Fefferman-style statements (`StatementC`, `StatementD`, in `ClayStatement/`) and the authors' formal option statements (`NavierStokes/ComparatorDefinitions.lean`), and links them by bridge theorems; two encodings of one problem are therefore involved and each can differ from the official text.
- The authors' option statements were built for the Formal Conjectures comparator, not for this package.
- A proof of an alternative says nothing about (A) or (B).

## Not established
That the Lean statements transcribe the official statements. This needs an independent reader.
