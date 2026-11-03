#!/usr/bin/env python3
"""Measure how this package's copy of OpenAI's NavierStokesAndEuler library differs from the upstream commit it was ported from.

Standard library and git only. Reads; changes nothing in the package or the upstream checkout. Prints only relative paths and counts.

  git archive v1.0.0 | tar -x -C package_tree          # the package tree to measure (any tree works)
  git clone https://github.com/openai/NavierStokesAndEuler upstream_checkout
  python3 measure_port.py --package package_tree --upstream upstream_checkout --out out_dir [--check-patch docs/PORT_DIFF.patch]

What is counted (each number below is printed with its definition):
  * Lean files = paths NavierStokes/*.lean. Compared as raw git blobs (upstream) against the package's bytes; a second figure normalizes CRLF to LF.
  * Build files = lean-toolchain, lake-manifest.json, lakefile.toml. Together with the modified Lean files these are the upstream files the port changed.
  * Hunks = hunks of `git diff` (3 lines of context) over the modified files, upstream -> package, generated in a scratch repository with autocrlf off.
  * 'statement' versus 'proof' is a POSITION HEURISTIC: a changed line is 'statement' when it lies before the first `:=` / trailing `by` / `where` of its declaration,
    'proof' when after it. It records WHERE text changed, not what was repaired or why.
"""
import argparse, collections, difflib, json, pathlib, re, subprocess, sys, tempfile, shutil

ap = argparse.ArgumentParser()
ap.add_argument("--package", required=True); ap.add_argument("--upstream", required=True)
ap.add_argument("--commit", default="f9e8bc5b38b6e212696e8a30e3e91517af887bbd"); ap.add_argument("--out", default=None); ap.add_argument("--check-patch", default=None)
A = ap.parse_args(); PK = pathlib.Path(A.package); UP = pathlib.Path(A.upstream); SHA = A.commit
BUILD = ("lean-toolchain", "lake-manifest.json", "lakefile.toml")
is_lean = lambda p: p.startswith("NavierStokes/") and p.endswith(".lean")

def git(*a, cwd=None, check=True):
    r = subprocess.run(["git", *a], capture_output=True, cwd=str(cwd) if cwd else None, timeout=600)
    if check and r.returncode != 0: sys.exit("git %s failed: %s" % (" ".join(a[:3]), r.stderr.decode("utf-8", "replace")[-200:]))
    return r.stdout

if git("rev-parse", "--verify", SHA + "^{commit}", cwd=UP).decode().strip() != SHA: sys.exit("the upstream checkout does not hold commit " + SHA)
up_all = [p for p in git("ls-tree", "-r", "-z", "--name-only", SHA, cwd=UP).decode("utf-8").split("\0") if p]
pk_all = sorted(p.relative_to(PK).as_posix() for p in PK.rglob("*") if p.is_file() and ".git" not in p.relative_to(PK).parts)
up_blob = lambda p: git("show", "%s:%s" % (SHA, p), cwd=UP); pk_bytes = lambda p: (PK / p).read_bytes(); lf = lambda b: b.replace(b"\r\n", b"\n")
up_set, pk_set = set(up_all), set(pk_all); R = {}
print("upstream commit %s, committed %s" % (SHA[:12], git("log", "-1", "--format=%cI", SHA, cwd=UP).decode().strip()))
lic = up_blob("LICENSE").decode("utf-8", "replace"); R["upstream_license_apache_2_0"] = ("Apache License" in lic and "Version 2.0" in lic); print("upstream LICENSE is Apache License 2.0: %s" % R["upstream_license_apache_2_0"])
def pin(read, name):
    j = json.loads(read(name).decode("utf-8")); m = next(x for x in j["packages"] if x["name"] == "mathlib"); return (m["rev"][:12], m.get("inputRev"))
R["upstream_lean_toolchain"] = up_blob("lean-toolchain").decode().strip(); R["package_lean_toolchain"] = pk_bytes("lean-toolchain").decode().strip()
R["upstream_mathlib"] = pin(up_blob, "lake-manifest.json"); R["package_mathlib"] = pin(pk_bytes, "lake-manifest.json")
print("upstream: Lean toolchain %s, Mathlib %s (%s)" % (R["upstream_lean_toolchain"], *R["upstream_mathlib"])); print("package : Lean toolchain %s, Mathlib %s (%s)" % (R["package_lean_toolchain"], *R["package_mathlib"]))
# ---- Lean files
up_l = {p for p in up_set if is_lean(p)}; pk_l = {p for p in pk_set if is_lean(p)}; shared_l = sorted(up_l & pk_l)
ident = [p for p in shared_l if up_blob(p) == pk_bytes(p)]; mod = [p for p in shared_l if up_blob(p) != pk_bytes(p)]; ident_n = [p for p in shared_l if lf(up_blob(p)) == lf(pk_bytes(p))]
R.update(upstream_lean_files=len(up_l), package_lean_files=len(pk_l), shared_lean_files=len(shared_l), byte_identical=len(ident), byte_identical_after_line_ending_normalization=len(ident_n), modified=len(mod), package_only=sorted(pk_l - up_l), upstream_not_shipped=len(up_l - pk_l), modified_files=mod)
print("NavierStokes/*.lean: upstream %d, package %d" % (len(up_l), len(pk_l))); print("  shared %d: byte-identical %d (%d after CRLF->LF), modified %d" % (len(shared_l), len(ident), len(ident_n), len(mod))); print("  package-only %d: %s" % (len(R["package_only"]), ", ".join(R["package_only"]))); print("  upstream files not shipped %d" % len(up_l - pk_l))
# ---- build files and the rest of the tree
bmod = [p for p in BUILD if p in up_set and p in pk_set and up_blob(p) != pk_bytes(p)]; other = sorted(p for p in (up_set & pk_set) if not is_lean(p) and p not in BUILD and up_blob(p) != pk_bytes(p))
R.update(build_files_modified=bmod, other_shared_files_modified=other, upstream_files_modified_lean_plus_build=len(mod) + len(bmod))
print("build files modified (%d): %s" % (len(bmod), ", ".join(bmod))); print("upstream files the port modified = %d Lean + %d build = %d" % (len(mod), len(bmod), len(mod) + len(bmod)))
print("other shared files that differ (package-owned: not part of the port): %s" % (", ".join(other) or "none"))
# ---- hunks (scratch repository, autocrlf off, raw upstream blobs then the package's bytes)
def diff_for(files):
    d = pathlib.Path(tempfile.mkdtemp(prefix="portdiff_")); 
    try:
        git("init", "-q", cwd=d); git("config", "core.autocrlf", "false", cwd=d); git("config", "core.safecrlf", "false", cwd=d)
        for p in files: (d / p).parent.mkdir(parents=True, exist_ok=True); (d / p).write_bytes(up_blob(p))
        git("add", "-A", cwd=d); git("-c", "user.name=measure", "-c", "user.email=measure@example.invalid", "commit", "-q", "-m", "upstream", cwd=d)
        for p in files: (d / p).write_bytes(pk_bytes(p))
        return git("diff", "--no-color", "--src-prefix=upstream/", "--dst-prefix=package/", cwd=d)
    finally: shutil.rmtree(d, ignore_errors=True)
patch = diff_for(mod); bpatch = diff_for(bmod); hunks = len(re.findall(rb"(?m)^@@ ", patch)); bhunks = len(re.findall(rb"(?m)^@@ ", bpatch))
R.update(patch_hunks=hunks, patch_bytes=len(patch), build_patch_hunks=bhunks, build_patch_bytes=len(bpatch))
print("PORT_DIFF.patch: %d files, %d hunks, %d bytes" % (len(re.findall(rb"(?m)^diff --git ", patch)), hunks, len(patch))); print("PORT_DIFF_BUILD.patch: %d files, %d hunks, %d bytes" % (len(re.findall(rb"(?m)^diff --git ", bpatch)), bhunks, len(bpatch)))
# ---- position heuristic
DECL = re.compile(r"^(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(theorem|lemma|def|instance|abbrev|structure|inductive|class|example)\b\s*([^\s:({\[]*)")
def regions(lines):
    reg = ["other"] * len(lines); nm = [None] * len(lines); i = 0
    while i < len(lines):
        m = DECL.match(lines[i])
        if m:
            j = i; se = None
            while j < len(lines) and not (j > i and lines[j].strip() == "" and lines[j - 1].strip() == ""):
                if se is None and (":=" in lines[j] or re.search(r"\bby\s*$", lines[j]) or lines[j].rstrip().endswith("where")): se = j
                if j > i and DECL.match(lines[j]): break
                j += 1
            se = se if se is not None else i
            for q in range(i, min(se, j - 1) + 1): reg[q] = "stmt"; nm[q] = m.group(2) or "<anonymous>"
            for q in range(min(se, j - 1) + 1, j): reg[q] = "proof"; nm[q] = m.group(2) or "<anonymous>"
            i = j
        else: i += 1
    return reg, nm
stmt, proof, outside = set(), set(), 0
for p in mod:
    a = lf(up_blob(p)).decode("utf-8", "replace").split("\n"); b = lf(pk_bytes(p)).decode("utf-8", "replace").split("\n"); reg, nm = regions(a)
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes():
        if tag == "equal": continue
        rs = {(reg[q], nm[q]) for q in range(i1, max(i2, i1 + 1)) if q < len(reg) and reg[q] != "other"}
        if not rs: outside += 1
        for r_, n_ in rs: (stmt if r_ == "stmt" else proof).add((p, n_))
proof_only = proof - stmt; R.update(declarations_changed_in_statement=len(stmt), declarations_changed_in_proof_body_only=len(proof_only), edits_outside_any_declaration=outside)
print("position heuristic over the %d modified Lean files: %d declarations changed in their statement region, %d changed in their proof body only, %d edits outside any declaration" % (len(mod), len(stmt), len(proof_only), outside))
if A.check_patch:
    same = pathlib.Path(A.check_patch).read_bytes() == patch; R["check_patch_identical"] = same; print("%s is %s the patch generated above" % (pathlib.Path(A.check_patch).name, "IDENTICAL to" if same else "DIFFERENT from"))
if A.out:
    o = pathlib.Path(A.out); o.mkdir(parents=True, exist_ok=True); (o / "PORT_DIFF.patch").write_bytes(patch); (o / "PORT_DIFF_BUILD.patch").write_bytes(bpatch)
    R["upstream_commit"] = SHA; (o / "measurement.json").write_text(json.dumps(R, indent=1, sort_keys=True), encoding="utf-8", newline="\n")
