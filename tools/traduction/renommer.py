"""renommer.py ancienne nouvelle : renomme une clé (ARB et code)."""
import json, re, sys, glob
a,n=sys.argv[1:3]
for f in ['lib/l10n/app_fr.arb','lib/l10n/app_en.arb']:
    d=json.load(open(f)); d={(n if k==a else '@'+n if k=='@'+a else k):v for k,v in d.items()}
    if '@'+n in d: d['@'+n]['description']='Écran : commun'
    json.dump(d,open(f,'w'),ensure_ascii=False,indent=2)
for f in glob.glob('lib/**/*.dart',recursive=True):
    if '/gen/' in f: continue
    s=open(f).read(); t=re.sub(r'\b(t|Textes\.of\([^)]*\))\.'+a+r'\b',lambda m:m.group(1)+'.'+n,s)
    if t!=s: open(f,'w').write(t)
