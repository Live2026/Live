# Outils de traduction

Scripts utilisés pour passer les textes des écrans dans `app/lib/l10n/app_fr.arb`
et `app_en.arb`. À lancer depuis `app/`.

| Script | Rôle |
|--------|------|
| `extrait.py fichier.dart…` | Liste les textes d'interface probables d'un fichier |
| `trad.py` | Bibliothèque : `cle()` ajoute une clé (avec description), `tr()` remplace un texte par `context.t.cle` (préfixe selon l'écran), `remplace()` pour les textes avec variables, `enregistre()` écrit les ARB |
| `deconst.py` | Retire les `const` devenus invalides, puis reformate |
| `accolades.py` | Met entre accolades les `if (…) return;` coupés par le formateur |
| `communs.py` | Regroupe les mots communs (Annuler, Continuer…) sous une seule clé |
| `renommer.py ancienne nouvelle` | Renomme une clé partout |
| `ranger.py` | Préfixe les clés par écran et ajoute les descriptions |

Après chaque lot : `flutter gen-l10n`, `python3 ../tools/traduction/deconst.py`,
`flutter analyze`, `flutter test test/textes_test.dart`.
