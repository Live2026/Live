# Écrans — 03. Explorer et recherche

L'onglet **Explorer** est la porte d'entrée des trois verticales et de la recherche. Exigences : F-RECH-01 à F-RECH-04, F-MKT-RECH, F-IMMO-RECH, F-SRV-RECH.

---

## E-EXP-01 — Explorer (hub)

```text
┌──────────────────────────────────────────┐
│ [⌕ Rechercher sur Live...         ]      │
├──────────────────────────────────────────┤
│ ┌──────────┐┌──────────┐┌──────────┐     │
│ │  MARKET  ││   IMMO   ││ SERVICES │     │
│ │ Acheter  ││  Louer   ││ Trouver  │     │
│ │ Vendre   ││ Acheter  ││ un pro   │     │
│ └──────────┘└──────────┘└──────────┘     │
│                                          │
│ Bonnes affaires près de vous    Tout ▶   │
│ ▒▒▒▒▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒▒           │
│ 12 000  45 000  8 500   60 000           │
│                                          │
│ Nouveaux logements à Moungali   Tout ▶   │
│ ▒▒▒▒▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒▒                   │
│ 2 ch.   Studio  3 ch.                    │
│ 90 000  45 000  150 000                  │
│                                          │
│ Pros disponibles aujourd'hui    Tout ▶   │
│ ( ▒) Plombier   ★4,9  Talangaï           │
│ ( ▒) Coiffeuse  ★4,7  Bacongo            │
│                                          │
│ Boutiques recommandées          Tout ▶   │
│ ( ▒) ( ▒) ( ▒) ( ▒)                      │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Barre de recherche | Ouvre E-EXP-02 avec les recherches récentes et sauvegardées |
| Tuiles | Ouvrent l'accueil de chaque verticale : E-MKT-01, E-IMMO-01, E-SRV-01 |
| Sections | Calculées selon le quartier et les centres d'intérêt ; chaque section a son « Tout ▶ » |

---

## E-EXP-02 — Recherche : saisie

```text
┌──────────────────────────────────────────┐
│ ◀ [⌕ climatiseur              ] ✕        │
├──────────────────────────────────────────┤
│ Dans : [•Tout][Market][Immo][Services]   │
│                                          │
│ Suggestions                              │
│ ⌕ climatiseur split                      │
│ ⌕ climatiseur occasion                   │
│ ⌕ réparation climatiseur  (Services)     │
│                                          │
│ Recherches récentes                      │
│ ↺ appartement Moungali          ✕        │
│ ↺ iphone 11                     ✕        │
│                                          │
│ Mes alertes                              │
│ » 2 ch. Moungali < 100 000  3 nouv.      │
└──────────────────────────────────────────┘
```

---

## E-EXP-03 — Recherche : résultats

```text
┌──────────────────────────────────────────┐
│ ◀ [⌕ climatiseur              ] ✕        │
├──────────────────────────────────────────┤
│ [Filtres (2)] [Trier ▼] [Carte]          │
│ Brazzaville · Neuf ou occasion           │
├──────────────────────────────────────────┤
│ 128 résultats      (Créer une alerte)    │
│                                          │
│ ▒▒▒▒▒▒▒▒  Clim split 1,5 CV LG           │
│ ▒▒▒▒▒▒▒▒  185 000 FCFA                   │
│ ▒▒ 0:30▒  Poto-Poto · il y a 3 h         │
│ ▒▒▒▒▒▒▒▒  ÉlectroPlus ✓ ★ 4,6    (♡)     │
│                                          │
│ ▒▒▒▒▒▒▒▒  Clim 1 CV occasion             │
│ ▒▒▒▒▒▒▒▒  90 000 FCFA   négociable       │
│ ▒▒▒▒▒▒▒▒  Ouenzé · hier                  │
│ ▒▒▒▒▒▒▒▒  Patrick ✓ ★ 4,2        (♡)     │
│                                          │
│ ──── Services liés ────                  │
│ ( ▒) Frigoriste Bruno ★4,8  Devis ▶      │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Résultats mixtes | Quand la recherche vise « Tout », les services liés apparaissent sous les produits |
| Tri | Pertinence, plus récent, prix croissant, prix décroissant, plus proche, mieux noté |
| Carte | Vue carte avec des points **approximatifs** (P1 : Immo et Services, F-RECH-04) |
| Créer une alerte | Sauvegarde la recherche et ses filtres (F-RECH-03) |
| Aucun résultat | « Aucun résultat. Créez une alerte : nous vous préviendrons dès qu'une annonce correspond. » |

---

## E-EXP-04 — Filtres

Les filtres changent selon la verticale. Exemple **Market** :

```text
┌──────────────────────────────────────────┐
│ ✕  Filtres               (Effacer)       │
├──────────────────────────────────────────┤
│ Catégorie   [▼ Électroménager     ]      │
│ Prix (FCFA) [ min    ] - [ max    ]      │
│ État        [x] Neuf  [x] Comme neuf     │
│             [ ] Bon état [ ] À réparer   │
│ Ville       [▼ Brazzaville         ]     │
│ Quartiers   [ Moungali ✕][ Ouenzé ✕]     │
│             ( + Ajouter un quartier )    │
│ Remise      [x] En main propre           │
│             [x] Livraison                │
│ Vendeur     [x] Vérifié uniquement       │
│ Médias      [ ] Avec vidéo uniquement    │
├──────────────────────────────────────────┤
│ [      Voir 128 résultats        ]       │
└──────────────────────────────────────────┘
```

Exemple **Immo** (filtres propres, F-IMMO-RECH-01) :

```text
┌──────────────────────────────────────────┐
│ ✕  Filtres Immo           (Effacer)      │
├──────────────────────────────────────────┤
│ [•Location] [ Vente ] [ Meublé court]    │
│ Type    [x]Appartement [x]Maison         │
│         [ ]Studio [ ]Chambre [ ]Local    │
│ Loyer   [ min    ] - [ 100 000 ]         │
│ Coût d'entrée max  [ 500 000      ]      │
│ Chambres [1][•2][3][4+]                  │
│ Quartiers [ Moungali ✕][ Plateau ✕]      │
│ Eau      [x] Réseau [x] Forage           │
│ Élec.    [x] Compteur individuel         │
│ Autres   [ ] Parking [ ] Meublé          │
│          [ ] Non inondable               │
│ Annonceur [x] Vérifié uniquement         │
│           [ ] Agences uniquement         │
├──────────────────────────────────────────┤
│ [       Voir 42 logements        ]       │
└──────────────────────────────────────────┘
```

---

## E-EXP-05 — Mes alertes

```text
┌──────────────────────────────────────────┐
│ ◀  Mes alertes                           │
├──────────────────────────────────────────┤
│ 2 ch. · Moungali, Plateau                │
│ Loyer < 100 000 · Vérifiés               │
│ 3 nouveaux  · Push activé   [ Voir ]     │
│ (Modifier) (Suspendre) (Supprimer)       │
├──────────────────────────────────────────┤
│ iPhone 11 · Brazzaville                  │
│ Prix < 100 000                           │
│ 0 nouveau  · Push activé    [ Voir ]     │
│ (Modifier) (Suspendre) (Supprimer)       │
├──────────────────────────────────────────┤
│ Plombier · Talangaï                      │
│ 1 nouveau  · Push désactivé [ Voir ]     │
│ (Modifier) (Suspendre) (Supprimer)       │
├──────────────────────────────────────────┤
│ ( + Créer une alerte )                   │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Fréquence | Immédiate (push) ou résumé quotidien (au choix) |
| Limite | 10 alertes actives par utilisateur au MVP |
