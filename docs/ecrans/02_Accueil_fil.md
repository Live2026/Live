# Écrans — 02. Accueil et fil

Le fil est l'écran d'ouverture de l'application : il **divertit** et il **vend**. Exigences : F-FEED-01 à F-FEED-07.

---

## E-FEED-01 — Fil « Pour toi » (vidéo plein écran)

```text
┌──────────────────────────────────────────┐
│ Abonnements  [Pour toi]  Près de moi     │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ ( ▒▒)   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ + Suiv. │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒         │
│ ▒▒▒▒▒▒▒▒▒▒▒▒ VIDÉO ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ♡   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ 1,2k    │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ✉      │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  84     │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ↗      │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Part.   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ⚑      │
│ @grace.mode ✓ · Moungali                 │
│ Nouvel arrivage de robes en wax !        │
│ #mode #brazzaville                       │
│ ┌──────────────────────────────────┐     │
│ │▒▒ Robe wax longue    15 000 FCFA │     │
│ │   Livraison possible  [ Acheter ]│     │
│ └──────────────────────────────────┘     │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Onglets du haut | **Pour toi** (recommandé), **Près de moi** (E-FEED-02), **Abonnements** (comptes suivis) |
| Geste | Glisser vers le haut : vidéo suivante ; appui : pause ; double appui : « J'aime » |
| Colonne droite | Photo de l'auteur (+ suivre), J'aime, Commentaires (E-FEED-03), Partager (E-FEED-04), Signaler |
| **Carte d'annonce** | Présente si la publication est liée à un produit, un bien ou un service. Bouton selon la verticale : **Acheter** (Market), **Visiter** (Immo), **Réserver** (Services). Un appui sur la carte ouvre la fiche. |
| Mention « Sponsorisé » | Affichée sous le nom de l'auteur pour les publications boostées (F-FEED-07) |
| Données | 360p par défaut sur données mobiles ; seules les premières secondes de la vidéo suivante sont préchargées (document 20, section 6.4) |
| Publication photo | Même écran, avec un carrousel horizontal de photos à la place de la vidéo |

---

## E-FEED-02 — Fil « Près de moi »

Même présentation que E-FEED-01, avec :

```text
┌──────────────────────────────────────────┐
│ Abonnements  Pour toi  [Près de moi]     │
├──────────────────────────────────────────┤
│ Autour de : Moungali (▼ Changer)         │
│ Rayon : [ 2 km ][ 5 km ][•Ville]         │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒ VIDÉO ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ♡   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ✉      │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ↗      │
│ @agence.palmiers ✓ · à 1,2 km            │
│ Appartement 2 chambres, forage,          │
│ parking. Disponible de suite.            │
│ ┌──────────────────────────────────┐     │
│ │▒▒ 2 ch. Moungali 90 000 FCFA/mois│     │
│ │   Entrée : 450 000    [ Visiter ]│     │
│ └──────────────────────────────────┘     │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Position | Quartier du profil par défaut ; la géolocalisation n'est demandée que si l'utilisateur choisit « Autour de moi » |
| Distance | Affichée de façon approximative (jamais l'adresse exacte, DI-03) |
| Carte Immo | Affiche aussi le **coût d'entrée** (F-IMMO-PUB-04) |

---

## E-FEED-03 — Commentaires (panneau du bas)

```text
┌──────────────────────────────────────────┐
│ ▒▒▒▒▒▒▒▒▒▒ vidéo réduite ▒▒▒▒▒▒▒▒▒▒▒▒▒   │
├──────────────────────────────────────────┤
│ 84 commentaires                   ✕      │
│                                          │
│ ( ▒) Merveille · 2 h                     │
│      Elle existe en taille M ?           │
│      ♡ 3   Répondre                      │
│      └ ( ▒) Grâce Mode ✓ · Vendeur       │
│             Oui, écrivez-moi en privé    │
│             ♡ 1   Répondre               │
│                                          │
│ ( ▒) Jordy · 5 h                         │
│      Prix final ?                        │
│      ♡ 0   Répondre                      │
│                                          │
├──────────────────────────────────────────┤
│ ( ▒) [ Ajouter un commentaire...  ] ➤    │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Réponse du vendeur | Badge « Vendeur » pour identifier l'auteur de l'annonce |
| Modération | Les commentaires contenant un numéro de téléphone ou des mots interdits sont bloqués avec un message d'explication |
| Actions sur un commentaire | Appui long : Signaler, Bloquer l'auteur, Supprimer (si c'est le sien ou sur sa propre publication) |

---

## E-FEED-04 — Partager (panneau du bas)

```text
┌──────────────────────────────────────────┐
│ Partager                          ✕      │
├──────────────────────────────────────────┤
│   (WhatsApp) (Facebook) (SMS) (Lien)     │
│                                          │
│   ( ▒ ) ( ▒ ) ( ▒ ) ( ▒ )                │
│   Envoyer à vos contacts Live            │
│                                          │
├──────────────────────────────────────────┤
│ ( Enregistrer )  ( Pas intéressé )       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Lien partagé | Lien profond `live.xx/v/{id}` avec aperçu (image, titre, prix) : il ramène les gens de WhatsApp et Facebook vers Live (F-FEED-06) |
| Parrainage | Le lien contient le code de parrainage de l'utilisateur (F-CPT-09) |
| « Pas intéressé » | Réduit la présence de contenus similaires dans le fil |

---

## E-FEED-05 — Menu d'options d'une publication (⋮)

```text
┌──────────────────────────────────────────┐
├──────────────────────────────────────────┤
│ ( Signaler cette publication       )     │
│ ( Pas intéressé                    )     │
│ ( Masquer les publications de      )     │
│ (   @grace.mode                    )     │
│ ( Copier le lien                   )     │
│ ( Qualité vidéo : Économie ▶       )     │
├──────────────────────────────────────────┤
│ [           Fermer               ]       │
└──────────────────────────────────────────┘
```
