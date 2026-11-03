# Provenance and authorship
## Who did what (from the R2R1 package's own records and the files, read and checked by script)
| Part | Author per the records | Basis |
|---|---|---|
| The mathematics and the Lean formalization of the blow-up (the `NavierStokes/` modules) | OpenAI (repository NavierStokesAndEuler, commit f9e8bc5b38b6e212696e8a30e3e91517af887bbd, Apache-2.0) | `third_party/NavierStokesAndEuler/`; the R2R1 package's UPSTREAM_AND_CONTRIBUTIONS.md |
| Port to Lean 4.34.1 and Mathlib d13f23b7 (24 upstream files modified) | KTS Global (no person is named for the port patch in any R2R1 record or published text) | R2R1 `SOURCE_PATCH/R2_over_upstream.patch` (not redistributed here) |
| Fefferman-style statements `ClayStatement/Fefferman.lean`, bridges `ClayStatement/Bridge*.lean`, solution modules, R3 additions (`ClayA..D` challenge statements are NOT shipped) | Tim Jacobs, KTS Global, per the R2R1 release notes: "statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation" | same |
| Any proof found by a CHAOS route | **none recorded** | ECR records carry `chaos_route_proof: none recorded` |
| Statement battery and ECR class | builder-run, as returned jobs; class LIBRARY_SUPPORT (never closing) | `docs/ECR.md`, `evidence/ecr/` |

## Attribution and credit (original public credit found; quoted exactly)
The original public credit was looked for in the R2R1 package's README, NOTICE, CITATION and upstream documents and in its **published** release notes and repository README. It exists in the published release notes and the repository README; the package's own files name only the organisation.

**Published release notes of `kts-global/lean-proofs-public`, release `r2-r3-v1` (https://github.com/kts-global/lean-proofs-public/releases/tag/r2-r3-v1, published 2026-10-21T13:48:44Z), line 3:**

> **Inherited mathematics:** OpenAI, [`openai/NavierStokesAndEuler`](https://github.com/openai/NavierStokesAndEuler) at `f9e8bc5b38b6e212696e8a30e3e91517af887bbd` (Apache-2.0). This release adds the statement and bridge layer, the R3 per-alternative files, a public verification script and receipts.

**line 17:**

> **Release contribution:** Tim Jacobs, KTS Global ([ORCID 0009-0008-7130-1448](https://orcid.org/0009-0008-7130-1448)) — statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation. Upstream mathematical attribution to OpenAI is preserved.

**Repository README of `kts-global/lean-proofs-public`, line 16:**

> The mathematics and the Lean formalization are OpenAI's: [`openai/NavierStokesAndEuler`](https://github.com/openai/NavierStokesAndEuler) at commit `f9e8bc5b38b6e212696e8a30e3e91517af887bbd` (Apache-2.0). Toolchain: Lean 4.34.1, Mathlib `d13f23b`.

**line 28:**

> Folder: `R2_FINAL_S524_COMMUNITY_V1/`. Contribution: Tim Jacobs, KTS Global (ORCID [0009-0008-7130-1448](https://orcid.org/0009-0008-7130-1448)).

**R2R1 package, `UPSTREAM_AND_CONTRIBUTIONS.md`, line 3:**

> **Inherited mathematics and formalisation.** The proof of finite-time blowup for forced Navier–Stokes and its Lean formalisation are by **OpenAI** (paper "Finite time blowup for Navier–Stokes"; repository https://github.com/openai/NavierStokesAndEuler at commit `f9e8bc5b38b6e212696e8a30e3e91517af887bbd`; licence Apache-2.0). They are not the packager's work.

**R2R1 package, `THIRD_PARTY_NOTICES.md`, line 3:**

> - **NavierStokesAndEuler** (OpenAI): Apache-2.0; the licence text is `project/LICENSE`; copyright and attribution as stated in `project/README.md` and `project/formalization.yaml`. The files of `project/` that originate there keep that licence.

**R2R1 package, `CITATION.cff`:** line 6 is `- name: "kts-global"` (the organisation; no person); lines 17 and 22 are `- name: "OpenAI"` (the cited upstream work).

**What this establishes and what it does not.** The credit of the statement and bridge layer, R3 per-alternative packaging, and community verification tooling and documentation to **Tim Jacobs, KTS Global** (with the ORCID given in the quotes above) is as published by the repository owner; the OpenAI credit for the mathematics and the formalization is as published and is preserved here. The published credit does **not** name a person for the port patch (24 upstream files), and this package does not either. The operator also stated, on 2026-11-02, that the KTS Global parts are by Tim Jacobs; that statement and the published lines agree on the layers they both mention. No Lean file in the 620 shipped modules carries a credit comment; the one Lean file that mentions OpenAI is this package's own builder-written `CDVerification.lean`.

## What this package changes in the files
Nothing in the 620 shipped Lean modules: each is byte-identical to the R2R1 package's file (checked when this candidate was assembled and again by the archive profiles). The package adds `CDVerification.lean`, `CDNonVacuity.lean`, a new `lakefile.toml` and trimmed `lake-manifest.json` (no `Comparator` or `lean4export` requirement), scripts, documents and evidence.
