"""Retire le « const » qui englobe chaque erreur « Invalid constant value »
(ou apparentée) signalée par flutter analyze, jusqu'à ce qu'il n'y en ait plus."""
import re, subprocess, os
CODES=('invalid_constant','const_eval_method_invocation','const_with_non_constant_argument','non_constant_list_element','const_initialized_with_non_constant_value','const_constructor_param_type_mismatch','non_constant_map_value','non_constant_default_value')
env=dict(os.environ, PATH=os.environ['PATH'])
for tour in range(30):
    out=subprocess.run(['flutter','analyze','--no-pub'],capture_output=True,text=True,env=env).stdout
    errs=[l for l in out.splitlines() if any(c in l for c in CODES)]
    if not errs: print('plus d’erreur const après',tour,'tours'); break
    parFichier={}
    for l in errs:
        m=re.search(r'• (lib/[^:]+):(\d+):(\d+) •',l)
        if m: parFichier.setdefault(m.group(1),[]).append((int(m.group(2)),int(m.group(3))))
    for f,locs in parFichier.items():
        s=open(f).read(); lignes=s.split('\n')
        positions=sorted({sum(len(x)+1 for x in lignes[:l-1])+c-1 for l,c in locs}, reverse=True)
        retire=set()
        for pos in positions:
            # const le plus proche avant pos dont l'expression englobe pos
            for m in reversed(list(re.finditer(r'\bconst\s+', s[:pos]))):
                i=m.end(); prof=0; debut=False; j=i
                while j<len(s):
                    c=s[j]
                    if c in '([{': prof+=1; debut=True
                    elif c in ')]}':
                        prof-=1
                        if prof<=0 and debut: break
                    elif c in ',;' and prof==0 and debut: break
                    j+=1
                if j>=pos: retire.add((m.start(),m.end())); break
        for a,b in sorted(retire,reverse=True):
            # « const x = … » : la déclaration devient « final x = … »
            decl=re.match(r'const\s+\w+\s*=',s[a:])
            s=s[:a]+('final ' if decl else '')+s[b:]
        open(f,'w').write(s)
subprocess.run(['dart','format','lib'],capture_output=True,env=env)
subprocess.run(['python3','' + os.path.dirname(os.path.abspath(__file__)) + '/accolades.py'])
subprocess.run(['dart','format','lib'],capture_output=True,env=env)
