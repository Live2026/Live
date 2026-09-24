# Écrans — 00. Principes d'interface et navigation

> Maquettes fonctionnelles (wireframes) de l'application **Live** (Flutter). Elles fixent **le contenu, l'ordre et les actions** de chaque écran, pas le style graphique final, qui revient au designer.
> Chaque écran porte un identifiant `E-XXX-nn` et renvoie aux exigences du cahier des charges (`F-...`, documents 05, 10, 11, 12).

## 1. Index des fichiers

| Fichier | Contenu |
|---------|---------|
| [00 — Principes et navigation](00_Principes_et_navigation.md) | Règles communes, légende, carte de navigation, composants |
| [01 — Démarrage et compte](01_Demarrage_compte.md) | Bienvenue, téléphone, code SMS, profil, intérêts, PIN |
| [02 — Accueil et fil](02_Accueil_fil.md) | Fil vidéo « Pour toi » et « Près de moi », commentaires, partage |
| [03 — Explorer et recherche](03_Explorer_recherche.md) | Hub des verticales, recherche, filtres, alertes |
| [04 — Live Market](04_Live_Market.md) | Produits, boutique, offre, commande, remise, côté vendeur |
| [05 — Live Immo](05_Live_Immo.md) | Biens, fiche, visite, réservation, agence |
| [06 — Live Services](06_Live_Services.md) | Prestataires, demande de devis, devis, réservation, prestation |
| [07 — Publier](07_Publier.md) | Bouton « + », produit, bien, service, vidéo, envois |
| [08 — Messages](08_Messages.md) | Conversations, négociation, cartes payables |
| [09 — Paiement et gains](09_Paiement_gains.md) | Payer, attente MoMo/Airtel, reçus, gains, retrait |
| [10 — Moi, espaces et vérification](10_Moi_espaces.md) | Profil, « Gagner de l'argent », KYC, espaces, paramètres |
| [11 — Confiance](11_Confiance.md) | Avis, signalement, réclamation, suivi de litige |
| [12 — Notifications](12_Notifications.md) | Centre de notifications |
| [13 — Back-office](13_Back_office.md) | Outil web des agents Live |

---

### Modifier ou ajouter une maquette

1. Écrire le contenu de l'écran dans un bloc de code étiqueté `ecran` (téléphone, 40 caractères de large) ou `ecran-large` (back-office, 86 caractères), sans cadre ; une ligne `---` trace une séparation.
2. Lancer `python3 tools/cadre_ecrans.py` : le script ajoute le cadre, aligne les bords et signale toute ligne trop longue.
3. Pour modifier un écran déjà encadré, éditer directement le bloc `text` en conservant l'alignement du bord droit.

---

## 2. Principes d'interface

1. **Tout faire avec le pouce** : actions principales en bas de l'écran, boutons larges (48 px minimum).
2. **Un écran = une décision** : un seul bouton principal par écran, toujours en bas.
3. **Le prix total est toujours visible** avant un paiement ; aucune surprise.
4. **La protection se voit** : chaque écran qui touche à l'argent affiche le bandeau « Protégé par Live ».
5. **Économe en données** : images floues d'abord (BlurHash), vidéo 360p par défaut sur données mobiles, indicateur du mode économie.
6. **Fonctionne hors ligne** : brouillons conservés, bandeau « Hors connexion : vos actions seront envoyées au retour du réseau ».
7. **Langage simple** : phrases courtes, pas de jargon (« Mes gains » plutôt que « solde créditeur »). **Vouvoiement** dans toute l'application (argent et confiance).
8. **Montants** toujours écrits `25 000 FCFA` (espace comme séparateur des milliers).
9. **Accessibilité** : contrastes suffisants, icônes toujours accompagnées d'un libellé, tailles de texte système respectées.

---

## 3. Légende des maquettes

| Symbole | Signification |
|---------|---------------|
| `[ Bouton ]` | Bouton principal (plein) |
| `( Bouton )` | Bouton secondaire (contour) |
| `[________]` | Champ de saisie |
| `[▼ Choix ]` | Liste déroulante |
| `(•)` / `( )` | Choix unique sélectionné / non sélectionné |
| `[x]` / `[ ]` | Case cochée / non cochée |
| `◀` | Retour |
| `⋮` | Menu d'options |
| `▒▒▒▒` | Image, vignette ou vidéo |
| `★ 4,8` | Note |
| `✓ Vérifié` | Badge de vérification |
| `⌂ ⌕ (+) ✉ ☺` | Onglets : Accueil, Explorer, Publier, Messages, Moi |
| `[Protégé par Live]` | Bandeau de protection des paiements |
| Ligne `├───┤` | Séparation de zones (en-tête, contenu, barre du bas) |

---

## 4. Carte de navigation

```
                         ┌──────────────┐
                         │  Démarrage   │  E-AUTH-01 à 07
                         └──────┬───────┘
                                ▼
┌─────────────────── BARRE D'ONGLETS (toujours visible) ───────────────────┐
│  ⌂ Accueil     ⌕ Explorer     (+) Publier     ✉ Messages     ☺ Moi       │
└────┬──────────────┬──────────────┬──────────────┬──────────────┬─────────┘
     ▼              ▼              ▼              ▼              ▼
  Fil vidéo      Hub Market     Choisir quoi   Conversations  Profil
  E-FEED-01/02   Immo/Services  publier        E-CHAT-01      E-MOI-01
     │           E-EXP-01       E-PUB-01          │              │
     │              │              │              ▼              ├─► Mes gains E-PAY-04
     ▼              ▼              ▼           Conversation      ├─► Gagner de l'argent E-MOI-02
  Fiche produit  Recherche      Formulaires    E-CHAT-02         ├─► Vérification E-MOI-03
  / bien /       E-EXP-02       E-PUB-03/04/   (offres, devis,   ├─► Mes espaces E-MOI-04
  service        + filtres      05             payer)            └─► Paramètres E-MOI-06
     │
     ▼
  Paiement E-PAY-01 ─► Attente MoMo/Airtel E-PAY-02 ─► Résultat E-PAY-03
     │
     ▼
  Suivi : commande E-MKT-05 · visite E-IMMO-05 · prestation E-SRV-06
     │
     ▼
  Avis E-CONF-01   ou   Réclamation E-CONF-03 ─► Suivi du litige E-CONF-04
```

**Liens profonds** (liens partagés sur WhatsApp et Facebook) :

| Lien | Écran ouvert |
|------|--------------|
| `live.xx/p/{id}` | Fiche produit E-MKT-02 |
| `live.xx/b/{id}` | Fiche bien E-IMMO-03 |
| `live.xx/s/{id}` | Profil prestataire E-SRV-02 |
| `live.xx/{nom-boutique}` | Boutique E-MKT-06 |
| `live.xx/v/{id}` | Vidéo dans le fil E-FEED-01 |

---

## 5. Composants communs

### 5.1 Barre d'onglets
```text
┌──────────────────────────────────────────┐
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

### 5.2 Carte d'annonce (liste)
Utilisée dans les résultats, les boutiques, les favoris.
```text
┌──────────────────────────────────────────┐
│ ▒▒▒▒▒▒▒▒  iPhone 11 64 Go, très bon      │
│ ▒▒▒▒▒▒▒▒  85 000 FCFA        négociable  │
│ ▒▒ 0:45▒  Moungali · il y a 2 h          │
│ ▒▒▒▒▒▒▒▒  Grâce Mode ✓ ★ 4,8      (♡)    │
└──────────────────────────────────────────┘
```

### 5.3 Bandeau de protection
Présent sur les fiches et les écrans de paiement.
```text
┌──────────────────────────────────────────┐
│ [Protégé par Live] Votre argent est      │
│ bloqué jusqu'à la réception. Ne payez    │
│ jamais en dehors de l'application.       │
└──────────────────────────────────────────┘
```

### 5.4 Bandeau hors connexion
```text
┌──────────────────────────────────────────┐
│ Hors connexion - vos actions seront      │
│ envoyées au retour du réseau.            │
└──────────────────────────────────────────┘
```

### 5.5 Bandeau mode économie de données
```text
┌──────────────────────────────────────────┐
│ Économie de données activée · 360p       │
│ (Modifier)                               │
└──────────────────────────────────────────┘
```

---

## 6. États communs à tous les écrans

| État | Affichage |
|------|-----------|
| **Chargement** | Squelettes gris à l'emplacement du contenu (jamais d'écran blanc) ; aperçus flous des images |
| **Vide** | Illustration simple + phrase utile + bouton d'action (ex. « Aucune annonce ici. Créer une alerte ») |
| **Erreur réseau** | Message clair + `( Réessayer )` ; contenu en cache affiché si disponible |
| **Hors connexion** | Bandeau 5.4 ; les écrans déjà consultés restent lisibles |
| **Action refusée (capacité manquante)** | Explication + bouton vers la vérification (ex. « Vérifiez votre identité pour retirer vos gains ») |
