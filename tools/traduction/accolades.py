"""« if (…)\n  return; » (coupé par dart format) → bloc entre accolades."""
import re,glob
for f in glob.glob('lib/**/*.dart',recursive=True):
    s=open(f).read()
    t=re.sub(r'(\n(\s*)if \((?:[^\n]*)\))\n\s+(return[^\n]*;|informer\([^\n]*;)\n', lambda m: f"{m.group(1)} {{\n{m.group(2)}  {m.group(3)}\n{m.group(2)}}}\n", s)
    if t!=s: open(f,'w').write(t); print(f)
