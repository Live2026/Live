"""Range les clés par écran : préfixe de domaine + description pour les traducteurs."""
import json, re, os, glob
DOM={'feed':'accueil','explore':'explorer','auth':'demarrage'}
def dom(chemin):
    m=re.match(r'lib/features/([^/]+)/',chemin)
    return DOM.get(m.group(1),m.group(1)) if m else None
FR='lib/l10n/app_fr.arb'; EN='lib/l10n/app_en.arb'
fr=json.load(open(FR)); en=json.load(open(EN))
fichiers=[f for f in glob.glob('lib/**/*.dart',recursive=True) if '/gen/' not in f]
src={f:open(f).read() for f in fichiers}
cles=[k for k in fr if not k.startswith('@')]
usage={}
for k in cles:
    r=re.compile(r'\b(?:t|Textes\.of\([^)]*\))\.'+k+r'\b')
    usage[k]=sorted(f for f,s in src.items() if r.search(s))
renomme={}
for k in cles:
    doms={dom(f) for f in usage[k]}
    d=doms.pop() if len(doms)==1 else None
    if d and not k.startswith(d):
        n=d+k[0].upper()+k[1:]
        if n not in fr: renomme[k]=n
def ren(d):
    out={}
    for k,v in d.items():
        base=k[1:] if k.startswith('@') else k
        nb=renomme.get(base,base); out[('@' if k.startswith('@') else '')+nb]=v
    return out
fr=ren(fr); en=ren(en)
for k in [k for k in fr if not k.startswith('@')]:
    old=next((o for o,n in renomme.items() if n==k),k)
    ou=', '.join(os.path.basename(f)[:-5] for f in usage.get(old,[])) or 'commun'
    meta=fr.get('@'+k,{}); meta['description']=f'Écran : {ou}'
    # ordre : clé puis @clé
    fr['@'+k]=meta
ordre={}
for k in [k for k in fr if not k.startswith('@')]:
    ordre[k]=fr[k]; ordre['@'+k]=fr['@'+k]
json.dump({'@@locale':'fr',**{k:v for k,v in ordre.items() if k!='@@locale' and k!='@@@locale'}},open(FR,'w'),ensure_ascii=False,indent=2)
json.dump(en,open(EN,'w'),ensure_ascii=False,indent=2)
for f,s in src.items():
    n=s
    for o,nv in renomme.items():
        n=re.sub(r'\b(t|Textes\.of\([^)]*\))\.'+o+r'\b',lambda m:m.group(1)+'.'+nv,n)
    if n!=s: open(f,'w').write(n)
print(len(renomme),'clés renommées ;',len(cles),'clés')
