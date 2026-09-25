# Écrans — 14. Live IA et Crédits Live

Produits propres de la plateforme, payés en **Crédits Live** (document 19). Exigences : F-IA-01 à F-IA-12.

---

## E-IA-01 — Accueil Live IA (onglet « IA »)

```text
┌──────────────────────────────────────────┐
│ Live IA                          ✉       │
├──────────────────────────────────────────┤
│ ┌──────────────────────────────────────┐ │
│ │ Mes crédits                 50 ✦     │ │
│ │ 20 offerts expirent dans 58 j        │ │
│ │ [  Acheter des crédits  ]            │ │
│ └──────────────────────────────────────┘ │
│                                          │
│ RÉUSSIR À L'ÉCOLE                        │
│ [▒ Exercice par photo   dès 5 ✦]         │
│ [▒ Résumer un cours          5 ✦]        │
│                                          │
│ TROUVER UN EMPLOI                        │
│ [▒ CV complet               20 ✦]        │
│ [▒ Lettre de motivation     10 ✦]        │
│ [▒ Pack candidature         25 ✦]        │
│                                          │
│ LANCER MON ACTIVITÉ                      │
│ [▒ Business plan express    50 ✦]        │
│ [▒ Business plan complet   150 ✦]        │
│                                          │
│ BIENTÔT                                  │
│ [▒ Tuteur vocal         5 ✦/min]         │
│                                          │
│ Mes documents (4)                 ▶      │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✦IA ☺Moi          │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| ✦ | Symbole des Crédits Live, toujours accompagné du nombre |
| Solde | Un appui ouvre l'historique des crédits (achats, dépenses, offerts, expirations) |
| « Que voulez-vous faire ? » | Champ libre et suggestions populaires : la demande **oriente vers un service à prix fixe** (panneau avec les services et leur prix). Ce n'est pas une conversation facturée au mot (R-CR-04) |
| Crédits bas | Sous 20 crédits, un bandeau indique ce que permet le solde et le prix du pack Découverte |
| Services | Prix toujours visible sur la carte ; un appui ouvre le service |
| Grand écran | Les services s'affichent en grille (2 à 4 colonnes, voir 00, section 8) |

---

## E-IA-01b — Historique des crédits (appui sur le solde)

```text
┌──────────────────────────────────────────┐
│ ←  Mes crédits                           │
├──────────────────────────────────────────┤
│ Solde disponible 45 ✦      [Recharger]   │
│ 25 crédits utilisés                      │
│                                          │
│ OÙ VONT MES CRÉDITS                      │
│ CV complet         20 crédits · 80 %     │
│ ████████████████░░░░                     │
│ Exercice par photo  5 crédits · 20 %     │
│ ████░░░░░░░░░░░░░░░░                     │
│                                          │
│ MOUVEMENTS                               │
│ ✦ Exercice par photo               −5    │
│ ✦ CV complet                      −20    │
│ ⊕ Achat · 500 FCFA                +50    │
│ ⊕ Crédits offerts à l'inscription +20    │
│                                          │
│ Comment sont comptés les crédits         │
│ 🔒 Documents privés, jamais utilisés     │
│    pour entraîner une IA                 │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Répartition | Part de chaque service dans les dépenses (grand livre des crédits, R-CR-08) |
| Mouvements | Achats, dépenses, crédits offerts et recrédits automatiques (R-CR-05) |
| Rappels | Prix fixe confirmé avant, révision gratuite, recrédit en cas d'échec, confidentialité (R-IA-06) |

---

## E-IA-02 — Acheter des crédits

```text
┌──────────────────────────────────────────┐
│ ◀  Acheter des crédits                   │
├──────────────────────────────────────────┤
│ Votre solde : 50 ✦                       │
│                                          │
│ (•) 500 FCFA          50 ✦               │
│ ( ) 1 000 FCFA       110 ✦  +10 %        │
│ ( ) 2 500 FCFA       300 ✦  +20 %        │
│ ( ) 5 000 FCFA       650 ✦  +30 %        │
│                                          │
│ Exemples : 1 CV = 20 ✦ · 1 lettre        │
│ = 10 ✦ · 1 exercice = 5 ✦                │
│                                          │
│ ( Offrir des crédits à un proche )       │
├──────────────────────────────────────────┤
│ Crédits valables 12 mois. Non            │
│ remboursables en argent.                 │
├──────────────────────────────────────────┤
│ [      Payer 500 FCFA              ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Paiement | Écrans communs E-PAY-01 à E-PAY-03 ; crédits disponibles dès la confirmation, puis retour au service en cours |
| Âge | Achat réservé aux 18 ans et plus ; un mineur voit « Demandez à un parent de vous offrir des crédits » (R-IA-02) |
| Offrir | Numéro du bénéficiaire, pack, message ; le bénéficiaire reçoit une notification |

---

## E-IA-03 — Confirmation du prix

Affichée avant chaque génération (R-CR-04).

```text
┌──────────────────────────────────────────┐
│ ┌──────────────────────────────────────┐ │
│ │ CV complet                           │ │
│ │                                      │ │
│ │ Ce service coûte        20 ✦         │ │
│ │ Votre solde             50 ✦         │ │
│ │ Après                   30 ✦         │ │
│ │                                      │ │
│ │ Une révision gratuite incluse.       │ │
│ │ Recrédité si la génération échoue.   │ │
│ │                                      │ │
│ │ (Annuler)          [ Générer ]       │ │
│ └──────────────────────────────────────┘ │
└──────────────────────────────────────────┘
```

Solde insuffisant : le bouton devient **[ Acheter des crédits ]** et ramène ici après l'achat.

---

## E-IA-04 — CV complet : informations

```text
┌──────────────────────────────────────────┐
│ ◀  CV complet                   20 ✦     │
├──────────────────────────────────────────┤
│ ( Remplir avec mon profil Live )         │
│                                          │
│ Poste visé [ Comptable            ]      │
│ Nom        [ Grâce Mabiala        ]      │
│ Téléphone  [ 06 123 45 67         ]      │
│ Ville      [ Brazzaville          ]      │
│                                          │
│ Expériences                              │
│ [ Aide-comptable, Cabinet X,             │
│   2022-2024 : saisie, paie...    ]       │
│ ( + Ajouter une expérience )             │
│                                          │
│ Formation  [ BTS Comptabilité 2021 ]     │
│ Compétences[ Sage, Excel, paie    ]      │
│ Langues    [ Français, anglais    ]      │
│ Modèle     [•Sobre][Moderne][Couleur]    │
├──────────────────────────────────────────┤
│ [      Générer mon CV · 20 ✦       ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Champs vides | L'IA propose des formulations ; elle **n'invente pas** d'expérience ni de diplôme |
| Grand écran | Formulaire à gauche, aperçu du modèle à droite |

---

## E-IA-05 — Génération en cours

```text
┌──────────────────────────────────────────┐
│ ◀  CV complet                            │
├──────────────────────────────────────────┤
│                                          │
│                                          │
│       ✦  Rédaction de votre CV…          │
│                                          │
│   ██████████████░░░░░░░░  60 %           │
│                                          │
│   ✓ Profil analysé                       │
│   ✓ Expériences reformulées              │
│   ● Mise en page…                        │
│                                          │
│                                          │
│  Vous pouvez quitter l'écran : vous      │
│  serez prévenu quand ce sera prêt.       │
└──────────────────────────────────────────┘
```

---

## E-IA-06 — Résultat (document)

```text
┌──────────────────────────────────────────┐
│ ◀  Mon CV                         ⋮      │
├──────────────────────────────────────────┤
│ ┌──────────────────────────────────────┐ │
│ │ GRÂCE MABIALA                        │ │
│ │ Comptable · Brazzaville              │ │
│ │ 06 123 45 67                         │ │
│ │ ──────────────────────────────────── │ │
│ │ PROFIL                               │ │
│ │ Comptable rigoureuse, 3 ans          │ │
│ │ d'expérience en cabinet…             │ │
│ │ EXPÉRIENCE                           │ │
│ │ Aide-comptable · Cabinet X           │ │
│ │ 2022-2024                            │ │
│ │ • Saisie et révision…                │ │
│ └──────────────────────────────────────┘ │
│ (Modifier le texte) (Révision gratuite)  │
├──────────────────────────────────────────┤
│ [ Télécharger PDF ] (Word) (Partager)    │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Modifier le texte | Édition directe, sans frais |
| Révision gratuite | « Que voulez-vous changer ? » puis nouvelle génération (une fois, R-CR-06) |
| Mention | « Généré avec Live IA : relisez avant d'envoyer » |
| Avis | Note de 1 à 5 après le téléchargement (indicateur de satisfaction) |

---

## E-IA-07 — Exercice par photo : prise de vue

```text
┌──────────────────────────────────────────┐
│ ◀  Exercice par photo                    │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒  Cadrez l'énoncé dans le cadre  ▒▒    │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ✓ Photo nette   ✓ Texte lisible          │
│           ( Reprendre )                  │
├──────────────────────────────────────────┤
│ Niveau  [Collège][•Lycée][Université]    │
│ Matière [▼ Mathématiques           ]     │
│                                          │
│ (•) M'aider à comprendre       5 ✦       │
│     Étape par étape, avec des            │
│     questions                            │
│ ( ) Solution complète          8 ✦       │
├──────────────────────────────────────────┤
│ [         Envoyer · 5 ✦            ]     │
└──────────────────────────────────────────┘
```

---

## E-IA-08 — Exercice : mode apprentissage

```text
┌──────────────────────────────────────────┐
│ ◀  Équation · Lycée                      │
├──────────────────────────────────────────┤
│ Énoncé : Résoudre 2x + 3 = 11            │
│                                          │
│ ÉTAPE 1 SUR 3                            │
│ On veut isoler x. Que faut-il            │
│ faire en premier avec le « + 3 » ?       │
│                                          │
│ ( Le soustraire des deux côtés )         │
│ ( Le multiplier par 2 )                  │
│ ( Je ne sais pas )                       │
│                                          │
├──────────────────────────────────────────┤
│ ( Je n'ai pas compris cette étape )      │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Progression | L'étape suivante s'affiche après la réponse ; une mauvaise réponse déclenche une explication |
| Fin | Récapitulatif + « Un exercice semblable pour t'entraîner ? » (gratuit, sans correction détaillée) |
| Mineurs | La solution complète n'est proposée qu'après le mode apprentissage (R-IA-01) |

---

## E-IA-09 — Business plan : assistant

```text
┌──────────────────────────────────────────┐
│ ◀  Business plan complet    2 / 6        │
├──────────────────────────────────────────┤
│ ●───●───○───○───○───○                    │
│ Projet Clients Concur. Offre Moyens Fin. │
│                                          │
│ Qui sont vos clients ?                   │
│ [ Familles de Moungali et Ouenzé,        │
│   revenus moyens               ]         │
│                                          │
│ Combien en espérez-vous par mois ?       │
│ [ 300                           ]        │
│                                          │
│ Prix moyen d'une vente                   │
│ [ 2 500 ] FCFA                           │
├──────────────────────────────────────────┤
│ ▶ Écouter l'explication                  │
├──────────────────────────────────────────┤
│ [           Suivant                ]     │
└──────────────────────────────────────────┘
```

| Étape | Contenu |
|-------|---------|
| 1 Projet | Activité, ville, forme juridique envisagée (entreprise individuelle, SARL, SAS…) |
| 2 Clients | Cible, volume, prix |
| 3 Concurrence | Concurrents connus, avantages |
| 4 Offre | Produits ou services, prix |
| 5 Moyens | Local, matériel, personnel, stock de départ |
| 6 Financement | Apport, prêt recherché, subvention |
| Résultat | Dossier par sections (résumé, marché, stratégie, organisation, prévisionnel sur 3 ans en FCFA) + avertissement R-IA-03, export PDF et Word |

---

## E-IA-10 — Tuteur vocal (P2)

```text
┌──────────────────────────────────────────┐
│ ◀  Tuteur vocal               5 ✦/min    │
├──────────────────────────────────────────┤
│ Sujet [▼ Préparer un entretien    ]      │
│                                          │
│   IA : Présentez-vous en une             │
│   minute, comme devant un                │
│   recruteur.                             │
│                                          │
│   Vous : Je m'appelle Grâce…             │
│                                          │
│            ( ●  )                        │
│     Maintenir pour parler                │
│                                          │
│    02:14 · 12 ✦ utilisés                 │
├──────────────────────────────────────────┤
│ [      Terminer la session         ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Facturation | À la minute entamée ; la session s'arrête d'elle-même quand le solde est épuisé, avec un avertissement 1 minute avant |
| Données | L'audio n'est pas conservé ; la transcription peut être enregistrée dans « Mes documents » |

---

## E-IA-11 — Mes documents

```text
┌──────────────────────────────────────────┐
│ ◀  Mes documents                         │
├──────────────────────────────────────────┤
│ [Tout][CV][Lettres][Business][Exos]      │
├──────────────────────────────────────────┤
│ ▒ CV · Comptable          aujourd'hui    │
│   PDF · Word               ( ⋮ )         │
│ ▒ Lettre · Cabinet X            hier     │
│   PDF · Word               ( ⋮ )         │
│ ▒ Business plan · Boulangerie  lun.      │
│   PDF · Word               ( ⋮ )         │
│ ▒ Exercice · Équation          lun.      │
│                            ( ⋮ )         │
└──────────────────────────────────────────┘
```

⋮ : Ouvrir, Télécharger, Renommer, Supprimer (suppression définitive, R-IA-06).
