# Live — règles du dépôt

Ces règles s'appliquent à tout le code de Live (prototype `app/` et application réelle).

## Règle des 500 lignes (immuable)

**Aucun fichier de code n'atteint 500 lignes.** Dès qu'un fichier approche cette taille, il est découpé :

- un écran ou un groupe d'écrans par fichier (`part` / `part of` pour garder les widgets privés ensemble) ;
- les éléments réutilisés vont dans `app/lib/shared/` (voir ci-dessous), jamais recopiés d'un écran à l'autre ;
- les données de démonstration sont rangées par domaine (`app/lib/data/donnees_*.dart`).

Vérification : `find app/lib app/test -name "*.dart" | xargs wc -l | sort -n | tail` ; le plus gros fichier doit rester sous 500 lignes.

## Composants réutilisables

Tout écran se construit avec la bibliothèque `app/lib/shared/` (importer `widgets.dart`) :

| Fichier | Contenu |
|---------|---------|
| `cartes.dart` | `CarteProduit`, `CarteBien`, `CartePro`, `PhotoBien`, `BoutonFavori` |
| `composants.dart` | `EnTeteSection`, `Carrousel`, `Etiquette`, `Avatar`, `Etoiles`, `SelecteurEtoiles`, `EtatVide`, `TuileChiffre`, `PuceIcone` |
| `elements.dart` | `BarreAction`, `LigneMontant`, `LigneMenu`, `Bloc`, `BoutonVerre`, `BoutonMessages`, `BoutonEcouter`, `BoutonSimulation` |
| `confiance.dart` | `BandeauProtection`, `CarteQr`, `BadgeVerifie`, `simulerScan` |
| `feuilles.dart` | panneaux du bas : `signaler`, `partager`, `optionsPublication`, `ouvrirFiltresImmo`, `pouvoirRequis` |
| `saisie.dart`, `frise.dart`, `medias.dart`, `animations.dart` | choix, clavier de code, frise, vignettes, animations |

## Règles de design

- **Même catégorie, même taille** : toutes les cartes d'une même catégorie ont la même taille (image au même format, textes dans des zones de hauteur fixe).
- **Arrondi de 8 px** pour les boutons et les champs de saisie ; palette et contrastes dans `docs/ecrans/00`, section 9.
- **Pleine largeur** : pas de cadre de téléphone sur ordinateur ; grilles adaptatives et deux colonnes sur grand écran.
- **Animations** douces (`courbeDouce`) et coupées quand l'utilisateur demande de réduire les animations.
- **Super-pouvoirs** : tout le monde est utilisateur ; une fonction réservée affiche comment la débloquer (`pouvoirRequis`), jamais une erreur.

## Vérifier avant de pousser

```bash
cd app
flutter analyze                     # aucun problème
flutter test                        # dont les 90 écrans à 320, 360 et 1280 px
flutter build web --release --no-web-resources-cdn
cd test_e2e && node parcours.js     # 6 parcours + tour de tous les écrans
```
