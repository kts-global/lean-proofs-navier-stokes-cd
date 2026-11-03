# Changes from the R2R1 package

- **Lean sources:** none. The 620 modules in the import closure of the twelve verified results are copied byte for byte. The R2R1 package's other 2,057 Lean files (the Comparator challenge files, which contain `sorry` by design, the Euler library and modules no verified result imports) are **not shipped**.
- **New:** `CDVerification.lean` (axiom policy and statement pins), `CDNonVacuity.lean` (the solution classes are not empty, the four statements are pairwise not definitionally equal), `lakefile.toml`, `lake-manifest.json` (nine dependencies pinned to the same revisions as R2R1), scripts, documents, evidence.
- **Why the closure only:** the R2R1 project's own build reports 8 declarations that use `sorry`, all in files outside this closure; the verified target must have none.
- **v1.0.1:** no Lean source, lakefile, manifest or toolchain file changed; see `CHANGELOG.md`.
