# Écrans — 13. Back-office (Live Admin)

Application **Flutter Web** réservée aux agents Live (document 20, DT-01). Connexion par e-mail + **double authentification** obligatoire ; chaque agent ne voit que les modules de ses fonctions (modération, KYC, litiges, support, finance, commercial). Exigences : F-ADM-01 à F-ADM-08.

---

## E-ADM-01 — Tableau de bord

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ LIVE ADMIN                                 Nadège (KYC, Litiges)   ⚙  Quitter          │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ MENU            │ Tableau de bord · Brazzaville + Pointe-Noire · 30/09/2026            │
│ Tableau de bord │                                                                      │
│ Files de travail│  Inscrits      Actifs/jour   Transactions/jour  Volume/jour          │
│  · KYC (14)     │  48 210        9 870         1 204              38,4 M FCFA          │
│  · Modération(32)│                                                                     │
│  · Signalements │  Taux de litige  Paiements échoués  Retraits en attente              │
│  · Litiges (7)  │  2,1 %           3,8 %              12 (1 manuel)                    │
│  · Retraits (1) │                                                                      │
│ Utilisateurs    │  ALERTES                                                             │
│ Espaces         │  ! Échecs MTN MoMo en hausse (9 % sur 1 h)                           │
│ Transactions    │  ! Écart de réconciliation Airtel du 29/09 : 4 500 FCFA              │
│ Finance         │  ! 3 annonces signalées « faux bien » (même annonceur)               │
│ Configuration   │                                                                      │
│ Journal d'audit │  Minutes vidéo diffusées hier : 212 400 (≈ 212 $)                    │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Élément | Détail |
|---------|--------|
| Indicateurs | Ceux du document 05, section 6, et du document 20 (coût vidéo) |
| Alertes | Paiements, réconciliation, fraude ; un clic ouvre le dossier concerné |
| Menu | Filtré selon les fonctions de l'agent (F-ADM-01) |

---

## E-ADM-02 — File de vérification d'identité (KYC)

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ KYC · File de travail                       [Niveau ▼] [Ville ▼] [Ancienneté ▼]        │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  Reçu    Utilisateur          Demande   Pièce  Contrôle nom MoMo  Assigné              │
│  08:12   Grâce Mabiala        N2        CNI    ✓ identique        -       [Ouvrir]     │
│  08:40   Agence Les Palmiers  N3        RCCM   -                  Nadège  [Ouvrir]     │
│  09:05   Patrick Ngoma        N2        CNI    ✕ différent        -       [Ouvrir]     │
│  09:31   Sandra Bouanga       N2        Pass.  ✓ identique        -       [Ouvrir]     │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 14 dossiers · délai moyen 3 h 20 · objectif < 24 h                                     │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

## E-ADM-03 — Dossier KYC

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ ◀ KYC · Patrick Ngoma · demande N2                     Reçu le 30/09 à 09:05           │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ PIÈCE (recto)            PIÈCE (verso)           SELFIE                                │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒                        │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒                        │
│ (Agrandir)               (Agrandir)              Vivacité : ✓ réussie                  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ Nom déclaré       Patrick Ngoma           Nom sur la pièce  [ PATRICK NGOMA ]          │
│ Date naissance    14/02/1994              N° pièce          [ ••••••••2231  ]          │
│ Nom MoMo (MTN)    PATRICE NGOMA  ✕ différent (1 lettre)                                │
│ Autres comptes sur cet appareil : 0      Pièce déjà utilisée : non                     │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ Décision   (•) Approuver N2   ( ) Refuser   ( ) Demander un complément                 │
│ Motif      [▼ ...                      ]  Note interne [                     ]         │
│                                                            [ Enregistrer ]             │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Données sensibles | Images servies par URL signée de courte durée ; numéro de pièce masqué par défaut ; chaque consultation est **journalisée** |
| Doublons | Alerte si la pièce ou le selfie correspond à un autre compte |

---

## E-ADM-04 — File de modération

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ Modération · 32 en attente         [Type ▼] [Motif auto ▼] [Priorité ▼]                │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ▒▒▒▒▒▒  Vidéo · @jordy242 · Market       Score nudité 0,71 (douteux)                  │
│  ▒▒▒▒▒▒  « Pagne 6 yards neuf »           ( Publier )  ( Refuser ▼ )  ( ⋮ )            │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ▒▒▒▒▒▒  Annonce Immo · Patrick N.         Photo déjà vue : annonce #88213             │
│  ▒▒▒▒▒▒  « Studio Plateau 40 000 »         (Autre annonceur : Immo Plus ✓)             │
│                                            ( Publier )  ( Refuser ▼ )  ( ⋮ )           │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ▒▒▒▒▒▒  Produit · Beauté · @eclat_cg      Mot interdit : « hydroquinone »             │
│  ▒▒▒▒▒▒  « Crème éclaircissante forte »    ( Publier )  ( Refuser ▼ )  ( ⋮ )           │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Action | Effet |
|--------|-------|
| Refuser ▼ | Motif obligatoire (liste), notification à l'auteur, compteur d'infractions |
| ⋮ | Voir le profil, suspendre une capacité (E-ADM-07), transmettre à un responsable |

---

## E-ADM-05 — Dossier de litige et décision

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ ◀ Réclamation R-2026-0192 · Market · iPhone 11      Montant bloqué : 80 000 FCFA       │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ ACHETEUR  Merveille K. ★4,9 (0 litige)      VENDEUR  Grâce Mode ✓ ★4,8 (1 litige/214)  │
│ Motif : ne correspond pas · Demande : remboursement partiel de 15 000 FCFA             │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ CHRONOLOGIE                                                                            │
│ 30/09 10:21  Paiement MTN 80 000 (bloqué)        30/09 17:04  Remise (code ✓)          │
│ 30/09 19:40  Réclamation + 2 photos               01/10 09:12  Vendeur propose 5 000   │
│ ANNONCE (au moment de l'achat) : « aucune rayure »  [Voir l'instantané]                │
│ CONVERSATION                                      [Ouvrir les 14 messages]             │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ DÉCISION   ( ) Remboursement total     (•) Remboursement partiel [ 10 000 ] FCFA       │
│            ( ) Versement au vendeur                                                    │
│ Motivation (envoyée aux deux parties)                                                  │
│ [ L'annonce indiquait « aucune rayure » ; les photos montrent une rayure    ]          │
│ [ visible. Remboursement partiel de 10 000 FCFA.                            ]          │
│                                         [ Soumettre ]  Double validation : non         │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Instantané | L'annonce telle qu'elle était au moment de l'achat est conservée (le vendeur ne peut pas la modifier après coup) |
| Double validation | Obligatoire au-delà d'un seuil de montant (F-ADM-06) : la décision part chez un second agent avant l'exécution |
| Exécution | La décision déclenche les écritures au grand livre et le remboursement via Live Pay |

---

## E-ADM-06 — Finance et réconciliation

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ Finance · Réconciliation du 29/09/2026                                                 │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ Fournisseur    Relevé fournisseur   Grand livre Live   Écart     Statut                │
│ MTN MoMo       21 480 500           21 480 500         0         ✓ Réconcilié          │
│ Airtel Money   14 212 000           14 207 500         4 500     ! À analyser          │
│ Visa           2 740 000            2 740 000          0         ✓ Réconcilié          │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ Compte séquestre (banque) : 18 934 200     Soldes utilisateurs + séquestres :          │
│                                            18 934 200  ✓                               │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ Écart Airtel : 1 transaction · Réf. opérateur AM2609.8812 · 4 500 FCFA                 │
│ Payée chez Airtel, absente du grand livre (webhook non reçu)                           │
│ ( Voir le webhook )  ( Interroger le statut )  ( Créer une écriture ▼ )                │
│                                                → double validation                     │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Écritures manuelles | Toujours motivées, en double validation, et journalisées (document 06, section 6) |
| Exports | Écritures, commissions, retraits : format tableur pour la comptabilité |

---

## E-ADM-07 — Fiche utilisateur

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ ◀ Patrick Ngoma · N2 · inscrit le 12/08/2026 · Ouenzé      [Journal de ce compte]      │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ CAPACITÉS                       Statut      Source           Action                    │
│ C-VENDRE                        Active      Activation       (Suspendre)               │
│ C-ENCAISSER / C-RETIRER         Actives     Vérification N2  (Suspendre)               │
│ C-IMMO-PARTICULIER              SUSPENDUE   Admin 30/09      (Rétablir)                │
│                                 Motif : photos réutilisées (3 annonces)                │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ Réputation ★ 4,2 · 25 ventes · 1 litige perdu · 2 signalements confirmés               │
│ Gains : dispo 45 000 · en attente 12 000        [ Geler les fonds ] → double val.      │
│ Appareils : 1 · Comptes liés : aucun                                                   │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ SANCTIONS   ( Avertir )  ( Suspendre une capacité )  ( Bannir ) → double val.          │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## E-ADM-08 — Configuration

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ Configuration · Commissions et plafonds          Modifications en double validation    │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ COMMISSIONS                    Taux     Minimum   Plafond    Valable depuis            │
│ Market · vente                 6 %      100       -          01/10/2026                │
│ Services · prestation          8 %      -         -          01/10/2026                │
│ Immo · frais de visite         15 %     -         -          01/10/2026                │
│ Immo · réservation             2 %      -         10 000     01/10/2026                │
│ Offre de lancement             0 %      jusqu'au 31/12/2026 · 1 000 vendeurs           │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ PLAFONDS                       Encaissé/mois   Retrait/jour   Retrait/mois             │
│ N1                             100 000         -              -                        │
│ N2                             2 000 000       500 000        2 000 000                │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ RÉFÉRENTIELS  ( Villes et quartiers )  ( Catégories )  ( Produits interdits )          │
│               ( Prix des boosts )      ( Délais de garantie )  ( Synonymes )           │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Versions | Chaque changement de commission crée une nouvelle version datée ; les transactions gardent le taux appliqué au moment du paiement |
| Journal | Toute modification est enregistrée dans le journal d'audit (F-ADM-07) |

---

## Gouvernance (révision du 25/09/2026, document 03 §10)

| Écran | Adresse | Contenu |
|-------|---------|---------|
| E-ADM-00 Connexion d'un agent | `/admin/connexion` | E-mail professionnel et mot de passe, puis **code de l'application d'authentification** (2FA, F-ADM-01) ; « faire confiance à cet ordinateur 30 jours » ; code de secours remis par la direction générale ; chaque connexion est journalisée |
| E-ADM-09 Équipe Live | `/admin/equipe` | Réservé au **Super administrateur (direction générale)**, seul rôle permanent : liste des administrateurs délégués (fonction, 2FA active ou non, dernière activité), **invitation** avec choix de la fonction et aperçu des permissions, **matrice des permissions** par fonction (Superviseur, Agent KYC, Modérateur, Agent litiges, Support, Finance, Commercial). Le rôle de Super administrateur ne se délègue pas |
| E-ADM-10 Double validation | `/admin/validations` | File des actions sensibles (remboursement au-delà de 50 000 FCFA, déblocage de fonds gelés, modification de commission) : un **second agent** valide ou refuse ; **l'auteur ne peut pas valider sa propre demande** (F-ADM-06) |
| E-ADM-11 Journal d'audit | `/admin/journal` | Toutes les actions des agents (accès, KYC, modération, litiges, finance), filtrables et exportables ; les lignes sont chaînées : une modification se voit (F-ADM-07) |
