"""Remplace les doublons préfixés des mots communs par la clé commune."""
import json,re,glob,sys,os
sys.path.insert(0,'' + os.path.dirname(os.path.abspath(__file__)) + '')
from trad import COMMUNS
FR='lib/l10n/app_fr.arb'; EN='lib/l10n/app_en.arb'
fr=json.load(open(FR)); en=json.load(open(EN))
ren={}
for k,v in list(fr.items()):
    if k.startswith('@') or v not in COMMUNS: continue
    c=COMMUNS[v]
    if k==c: continue
    if c not in fr: fr[c]=v; en[c]=en[k]; fr['@'+c]={'description':'Écran : commun'}
    ren[k]=c
for k in ren:
    for d in (fr,en): d.pop(k,None); d.pop('@'+k,None)
json.dump(fr,open(FR,'w'),ensure_ascii=False,indent=2); json.dump(en,open(EN,'w'),ensure_ascii=False,indent=2)
for f in glob.glob('lib/**/*.dart',recursive=True):
    if '/gen/' in f: continue
    s=open(f).read(); t=s
    for a,n in ren.items(): t=re.sub(r'\b(t|Textes\.of\([^)]*\))\.'+a+r'\b',lambda m:m.group(1)+'.'+n,t)
    if t!=s: open(f,'w').write(t)
print(ren)
