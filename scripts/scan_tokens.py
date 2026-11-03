#!/usr/bin/env python3
"""Token scan of the Lean sources. Fails on any CODE occurrence (comments and string literals stripped) of
sorry, admit, axiom, native_decide, unsafe, implemented_by, opaque, extern or csimp. Occurrences that appear only inside
comments or strings are listed for information and do not fail the scan. The Lean compiler's own check (the build log has
no 'declaration uses sorry' line, enforced by verify-online.sh) is the authoritative check for unproved declarations."""
import pathlib, re, sys
ROOT = pathlib.Path(__file__).resolve().parent.parent
TOK = re.compile(r"\b(sorry|admit|axiom|native_decide|unsafe|implemented_by|opaque|extern|csimp)\b")
def strip(t):
    out = []; i = 0; n = len(t); depth = 0; instr = False
    while i < n:
        c = t[i]
        if depth == 0 and not instr and t.startswith("--", i):
            j = t.find("\n", i); j = n if j < 0 else j; out.append(" " * (j - i)); i = j; continue
        if not instr and t.startswith("/-", i): depth += 1; out.append("  "); i += 2; continue
        if depth > 0 and t.startswith("-/", i): depth -= 1; out.append("  "); i += 2; continue
        if depth > 0: out.append("\n" if c == "\n" else " "); i += 1; continue
        if c == '"' and (i == 0 or t[i - 1] != "\\"): instr = not instr; out.append(" "); i += 1; continue
        if instr: out.append("\n" if c == "\n" else " "); i += 1; continue
        out.append(c); i += 1
    return "".join(out)
code, com, nfiles = [], [], 0
for p in sorted(ROOT.rglob("*.lean")):
    if ".lake" in p.parts: continue
    nfiles += 1; t = p.read_bytes().decode("utf-8", "replace"); s = strip(t); rel = p.relative_to(ROOT).as_posix()
    for i, (l, ls) in enumerate(zip(t.split("\n"), s.split("\n"))):
        for m in TOK.finditer(ls): code.append("%s:%d: %s" % (rel, i + 1, l.strip()[:100]))
        for m in TOK.finditer(l):
            if not TOK.search(ls): com.append("%s:%d: %s" % (rel, i + 1, l.strip()[:100]))
for x in com: print("note (comment/string only): " + x)
if code:
    for x in code[:20]: print(x)
    print("RESULT: FAIL (token scan found %d code occurrence(s) in %d Lean files)" % (len(code), nfiles)); sys.exit(1)
print("RESULT: PASS (token scan: 0 code occurrences in %d Lean files; %d comment-only mentions listed above)" % (nfiles, len(com)))
