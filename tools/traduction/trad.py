"""Outil de traduction : ajoute des clés aux ARB et remplace les textes."""
import json, re
FR='lib/l10n/app_fr.arb'; EN='lib/l10n/app_en.arb'
_fr=json.load(open(FR)); _en=json.load(open(EN))
def cle(_cle, fr, en, ou=None, **params):
    if ou: _fr.setdefault('@'+_cle,{})['description']=f'Écran : {ou}'
    if _cle in _fr and _fr[_cle]!=fr: raise SystemExit(f"clé {_cle} déjà utilisée autrement")
    _fr[_cle]=fr; _en[_cle]=en
    if params:
        _fr.setdefault('@'+_cle,{})['placeholders']={k:{'type':v} for k,v in params.items()}
def remplace(fichier, pairs, importer=None):
    s=open(fichier).read()
    for a,b in pairs:
        if a not in s: raise SystemExit(f'{fichier}: introuvable : {a[:70]}')
        s=s.replace(a,b)
    m=re.search(r"^part of '([^']+)';", s, re.M)
    if importer and m:
        import os
        open(fichier,'w').write(s)
        return remplace(os.path.join(os.path.dirname(fichier), m.group(1)), [], importer)
    if importer and importer not in s:
        idx=[m.end() for m in re.finditer(r"^import .*;\n",s,re.M)]
        s=s[:idx[-1]]+importer+"\n"+s[idx[-1]:]
    open(fichier,'w').write(s)
def enregistre():
    for d in (_fr,_en):
        for k,v in d.items():
            if isinstance(v,str): d[k]=v.replace('\\n','\n').replace("\\'","’")
    json.dump(_fr,open(FR,'w'),ensure_ascii=False,indent=2)
    json.dump(_en,open(EN,'w'),ensure_ascii=False,indent=2)

import unicodedata
def _nom(fr):
    t=unicodedata.normalize('NFD',fr); t=''.join(c for c in t if unicodedata.category(c)!='Mn')
    mots=[m for m in re.findall(r'[A-Za-z0-9]+',t)][:4] or ['texte']
    k=mots[0].lower()+''.join(m.capitalize() for m in mots[1:])
    if k[0].isdigit(): k='n'+k
    return k
DOM={'feed':'accueil','explore':'explorer','auth':'demarrage'}
def domaine(fichier):
    m=re.match(r'lib/features/([^/]+)/',fichier)
    return DOM.get(m.group(1),m.group(1)) if m else ''
COMMUNS={'Continuer':'continuer','Annuler':'annuler','Valider':'valider','Fermer':'fermer','Confirmer':'confirmer','OK':'ok','Modifier':'modifier','Suivant':'suivant','Passer':'passer','Retour':'retour','Supprimer':'supprimer','Enregistrer':'enregistrer','Partager':'partager'}
def auto(fr,en,prefixe='',ou='',**params):
    if fr in COMMUNS and not params:
        k=COMMUNS[fr]
        if k not in _fr: cle(k,fr,en,'commun')
        return k
    k=_nom(fr)
    if prefixe: k=prefixe+k[0].upper()+k[1:]
    base=k; i=2
    while k in _fr and _fr[k]!=fr: k=f'{base}{i}'; i+=1
    cle(k,fr,en,**params)
    if ou: _fr.setdefault('@'+k,{})['description']=f'Écran : {ou}'
    return k
def tr(fichier, liste, ctx='context.t', importer="import '../../l10n/textes.dart';"):
    """liste : (fr, en) ; remplace chaque littéral 'fr' ou "fr" par ctx.cle."""
    s=open(fichier).read()
    for fr,en in liste:
        k=auto(fr,en,domaine(fichier),fichier.split('/')[-1][:-5]); trouve=False
        for q in ("'",'"'):
            lit=q+fr+q
            if lit in s: s=s.replace(lit,f'{ctx}.{k}'); trouve=True
        if not trouve:
            # texte coupé en plusieurs littéraux collés : 'début '\n  'suite'
            motif="['\"]"+''.join(re.escape(c)+r"(?:['\"]\s*['\"])?" for c in fr)+"['\"]"
            s,n=re.subn(motif,lambda m:f'{ctx}.{k}',s)
            if not n: raise SystemExit(f'{fichier}: introuvable : {fr}')
    open(fichier,'w').write(s)
    if importer: remplace(fichier,[],importer)
