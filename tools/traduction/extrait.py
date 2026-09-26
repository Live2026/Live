"""Liste les textes d'interface probables d'un fichier : ligne, texte."""
import re, sys
for f in sys.argv[1:]:
    print('==',f)
    for i,l in enumerate(open(f),1):
        if l.lstrip().startswith(('import','//','///','part')): continue
        for m in re.finditer(r"'((?:[^'\\]|\\.)*)'|\"((?:[^\"\\]|\\.)*)\"", l):
            t=m.group(1) if m.group(1) is not None else m.group(2)
            if len(t)<2 or t.startswith('/') or not re.search(r'[A-Za-zÀ-ÿ]',t): continue
            if re.fullmatch(r'[a-z_0-9]+',t) and ' ' not in t: continue
            print(f'{i}: {t}')
