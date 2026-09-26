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
| [14 — Live IA et Crédits Live](14_Live_IA.md) | Services IA payants, achat de crédits, documents |

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
10. **Codes de confirmation Live : un QR, jamais un code à dicter** (révision du 24/09/2026, voir section 7).
11. **Peu de texte** : 3 lignes d'explication au maximum par bloc ; une icône devant chaque option ; sur les écrans d'argent, un bouton **« ▶ Écouter »** lit l'explication à voix haute (français, puis lingala et kituba en P2).
12. **Consentement explicite** : cases à cocher non pré-cochées pour les conditions, la confidentialité et le traitement des pièces d'identité (à valider par le juriste, D-16).

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
| `⌂ ⌕ (+) ✦ ☺` | Onglets : Accueil, Explorer, Publier, **IA**, Moi |
| `✉` | Messages : icône en haut à droite de l'Accueil, d'Explorer et de Live IA |
| `✦` | Crédits Live |
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
│  ⌂ Accueil     ⌕ Explorer     (+) Publier     ✦ IA           ☺ Moi       │
└────┬──────────────┬──────────────┬──────────────┬──────────────┬─────────┘
     ▼              ▼              ▼              ▼              ▼
  Fil vidéo      Hub Market     Choisir quoi   Live IA        Profil
  E-FEED-01/02   Immo/Services  publier        E-IA-01        E-MOI-01
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
│ ⌂Accueil ⌕Explorer (+) ✦IA ☺Moi          │
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

### 5.6 Carte de confirmation Live (QR)

Remplace tous les « codes à 4 chiffres » (remise, visite, démarrage et fin de prestation).
```text
┌──────────────────────────────────────────┐
│ ┌──────────────────────────────────┐     │
│ │ CONFIRMER LA REMISE              │     │
│ │        ▓▓▓▓▓▓▓▓▓▓▓▓              │     │
│ │        ▓▓▓  QR  ▓▓▓              │     │
│ │        ▓▓▓▓▓▓▓▓▓▓▓▓              │     │
│ │ Code de secours : LV-K4827       │     │
│ │ Montrez-le au vendeur quand vous │     │
│ │ avez vérifié le produit.         │     │
│ │ Ce n'est PAS votre code MoMo.    │     │
│ └──────────────────────────────────┘     │
└──────────────────────────────────────────┘
```

Côté vendeur, annonceur ou prestataire :
```text
┌──────────────────────────────────────────┐
│ [   Scanner le QR de l'acheteur    ]     │
│ (Saisir le code LV- à la place)          │
└──────────────────────────────────────────┘
```

### 5.7 Bouton « Écouter »
```text
┌──────────────────────────────────────────┐
│ ▶ Écouter l'explication                  │
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

---

## 8. Mise en page adaptative : tout l'écran est utilisé (révision du 24/09/2026)

Les maquettes sont dessinées au format téléphone, mais l'application **occupe toute la largeur de l'écran**, sans marges latérales imposées, et **réorganise son contenu** selon la largeur disponible. Les seuils suivent les classes de taille de fenêtre de Material Design 3.

| Largeur | Classe | Navigation | Contenu |
|---------|--------|-----------|---------|
| < 600 px | Compacte (téléphone) | Barre d'onglets en bas | Une colonne ; listes pleine largeur ; marges intérieures de 16 px |
| 600 à 839 px | Moyenne (grand téléphone à l'horizontale, petite tablette) | **Rail de navigation** à gauche | Grilles de 2 à 3 colonnes ; fiches sur deux colonnes |
| ≥ 840 px | Étendue (tablette, ordinateur) | Rail de navigation **étendu** (avec libellés) | Grilles de 3 à 6 colonnes selon la largeur ; fiches et formulaires sur deux colonnes (médias ou formulaire à gauche, informations ou aperçu à droite) ; fil vidéo au centre avec le détail de l'annonce à droite |

**Règles**
1. **Pas de colonne étroite centrée** : les grilles (produits, logements, services, Live IA) utilisent une **largeur de carte maximale** (environ 240 à 420 px selon le contenu) et remplissent la ligne avec autant de colonnes que possible.
2. **Textes longs** (descriptions, conditions) : largeur de ligne limitée à environ 80 caractères **dans leur colonne**, pour rester lisibles ; la page, elle, reste pleine largeur.
3. **Bouton principal** : en bas de l'écran sur téléphone ; dans la colonne d'action (à droite) sur grand écran.
4. **Même contenu, même ordre** sur toutes les tailles : seule la disposition change (aucune fonctionnalité réservée à une taille d'écran).
5. **La barre latérale ne disparaît jamais** sur grand écran (révision du 25/09/2026) : toute page ouverte depuis un onglet (Mes ventes, Messages, relations, paiement…) garde la barre et y signale son onglet de rattachement. Seuls le back-office (qui a sa propre barre), la caméra, le lecteur de direct et le lecteur de cours occupent tout l'écran.
6. **Démarrage sur ordinateur** : la marque et ses quatre promesses (argent protégé, vérification, Mobile Money, Live IA) à gauche, le formulaire à droite dans une colonne de 480 px au plus. Révision du 26/09/2026, sur le modèle de WhatsApp Web (simple et propre) : fond crème très clair (ou l'image `app/assets/images/fond_demarrage.jpg` si elle est déposée), logo en haut à gauche, une seule carte centrée de 560 px à hauteur de son contenu, bord fin sans ombre. Dans la carte (`DansCarte`), chaque page se simplifie d'elle-même : titre et texte centrés, sans icône colorée ni barre d'étapes, bouton compact centré, cases de consentement compactes (elles restent, règle 12). L'accueil reprend celui de WhatsApp : une illustration (`IllustrationLive`, les espaces de Live au trait autour du logo), un titre, « Commencer » et « Découvrir sans compte ». Sous la carte : « Déjà un compte Live ? Se connecter » ou « Pas encore de compte ? Créer un compte », la promesse de protection, puis Conditions · Confidentialité · Aide. Sur ordinateur, la connexion propose aussi le code QR (`/connexion/qr`, E-AUTH-09), scanné depuis Paramètres › Appareils connectés › Connecter un appareil ; pas de SMS à payer, code renouvelé toutes les 30 secondes. Le numéro se saisit dans un seul champ (`ChampTelephone` : drapeau et indicatif, liste des six pays sous le champ, numéro groupé, opérateur reconnu), sans bibliothèque externe.

   **Image de fond (facultative)** : 2 560 × 1 440 px (16:9), JPEG ou WebP de 300 Ko au plus. Image claire et douce (la carte blanche et le texte gris doivent ressortir) ; motif ou illustration au trait aux couleurs de Live (bleu #13385C, orange #FB9618) en faible contraste, dans l'esprit du motif de WhatsApp, plutôt qu'une photo chargée. Rien d'important au centre (la carte couvre environ 600 × 520 px au milieu) ni en haut à gauche (logo) ni sous la carte (liens) ; les sujets éventuels sur les bords gauche et droit. Aucun texte ni logo dans l'image.
7. **Messages sur ordinateur** : deux panneaux, façon WhatsApp Web. La liste des conversations à gauche (400 px), la conversation ouverte à droite.
8. **Barre latérale repliable** : le bouton « Replier » la réduit aux icônes (84 px), « Déplier » la rouvre ; le choix est gardé d'une page à l'autre, dans l'application comme dans le back-office.
9. **Recherche dans l'en-tête** : sur les pages qui filtrent une liste (Explorer, Messages, Mes relations…), une **loupe** dans l'en-tête déploie le champ de saisie avec une animation ; la croix le referme et efface la saisie (composant `EnTeteRecherche`). Pas de barre de recherche permanente en haut de page.
10. **Le nom s'écrit « Live »** (L majuscule), accompagné du logo (`LogoLive`), jamais « LIVE ».

---

## 9. Charte visuelle (révision du 24/09/2026)

### 9.1 Palette officielle

| Rôle | Couleur | Code | Usage |
|------|---------|------|-------|
| **Principale** | Bleu Live | `#13385C` | Boutons principaux, liens, navigation active, frises |
| Texte fort | Bleu nuit | `#041936` | Titres, montants, texte posé sur l'orange ou l'ambre |
| Accent | Orange | `#FB9618` | Symbole des Crédits Live, mises en avant ponctuelles — **jamais en texte sur blanc** |
| Signal | Orange vif | `#FF8000` | Pastilles de notification, « Nouvelle » commande |
| Étoiles | Ambre | `#FCAF20` | Notes (étoiles) uniquement |
| Fonds chauds | Ambre clair `#FBCC6A`, crème `#FBE2AC` | | Alertes et encarts d'information, avec parcimonie |
| Texte chaud | Cuivre | `#C27A25` | Icônes d'alerte, texte en **grands caractères** seulement |
| Neutre | Brume | `#D7DCE4` | Bordures, séparateurs, surfaces neutres |
| États (hors marque) | Succès `#1E7B4F`, erreur `#C62828` | | Réussite d'un paiement, erreurs : jamais confondus avec la marque |
| Texte secondaire | Gris ardoise | `#5B6573` | Informations secondaires (contraste 5,9 : 1) |

**Contrastes vérifiés (norme WCAG AA : 4,5 : 1 pour le texte courant)**

| Combinaison | Contraste | Verdict |
|-------------|-----------|---------|
| Blanc sur bleu `#13385C` | 12,0 : 1 | ✅ |
| Bleu nuit sur blanc | 17,5 : 1 | ✅ |
| Bleu nuit sur orange | 7,9 : 1 | ✅ |
| Blanc sur orange | 2,2 : 1 | ❌ interdit |
| Orange sur blanc | 2,2 : 1 | ❌ interdit (texte) |
| Cuivre sur blanc | 3,4 : 1 | ⚠️ grands caractères seulement |

**Règle de dosage** : le bleu et le blanc dominent ; l'orange et l'ambre restent des **touches** (moins de 5 % de la surface d'un écran). Pas de grands aplats jaunes.

### 9.2 Formes

| Élément | Arrondi | Hauteur |
|---------|---------|---------|
| **Boutons** (tous) | **8 px** | 48 px (principal), 46 px (secondaire), 40 px (bouton dans une carte) |
| **Champs de saisie** | **8 px** | environ 48 px, fond `#F3F5F8`, bordure discrète, bleu au focus |
| Puces, onglets segmentés, éléments de navigation | 8 px | |
| Cartes | 12 px | bordure `#E4E8EE`, sans ombre (ombre légère réservée aux éléments flottants : QR, boîtes de dialogue) |

### 9.3 Hiérarchie des boutons

1. **Plein bleu** : l'action principale de l'écran, **une seule** par écran.
2. **Tonal** (fond bleu très léger, texte bleu) : action secondaire importante (« J'ai reçu le produit », « Laisser un avis »).
3. **Contour** : alternative (« Écrire »).
4. **Texte (transparent)** : actions tertiaires (« Refuser », « Signaler un problème »).
5. Pas de bouton géant inutile : largeur pleine uniquement pour l'action principale en bas d'écran sur téléphone ; ailleurs, le bouton prend la largeur de son libellé.

### 9.4 Mouvement

| Animation | Où | Durée |
|-----------|----|-------|
| Transition de page glissée (style iOS, avec parallaxe) | Toutes les navigations | Système |
| Image qui s'envole de la liste vers la fiche (« hero ») | Produits, logements | Système |
| Enfoncement léger au toucher (échelle 0,97) | Cartes tapables | 140 ms |
| Apparition en cascade (fondu + montée de 14 px) | Grilles et listes | 420 ms + 45 ms par élément |
| Chiffres qui défilent jusqu'à leur valeur | Soldes, gains, statistiques | 700 à 900 ms |
| Coche de réussite avec rebond | Paiement, remise, visite, retrait | 700 ms |

Courbe de référence : démarrage vif, arrivée amortie (`cubic(0.2, 0.8, 0.2, 1)`). Les animations restent **courtes** et ne retardent jamais une action ; elles respectent le réglage « réduire les animations » du téléphone.

---

### 9.5 Tailles et références (révision du 25/09/2026)

- **Même catégorie, même taille.** Toutes les cartes d'une même catégorie (produits, logements, pros, tuiles de chiffres, raccourcis) ont exactement la même taille : image au même format (1:1 pour les produits, 4:3 pour les logements, 9:16 pour les vidéos) et textes dans des zones de hauteur fixe (titre sur 2 lignes pour un produit, 1 ligne pour un logement). Un titre court ne rend jamais une carte plus petite que sa voisine.
- **Références assumées.** Le fil suit les codes de TikTok (vidéo plein écran, actions à droite, auteur avec « + », disque du son, barre de progression, double toucher pour aimer). La messagerie suit ceux de WhatsApp (liste avec non lus et coches, bulles à pointe, heure et coches dans la bulle, note vocale, fond à motif discret, réponses rapides). Les profils et boutiques suivent Instagram (couverture, avatar qui déborde, chiffres, onglets Produits / Vidéos / Avis).
- **Boutons « verre ».** Sur une photo ou une vidéo, les boutons sont ronds et translucides (flou d'arrière-plan), jamais des blocs opaques.

## 7. Journal des révisions : défauts corrigés avant le prototype (24/09/2026)

| # | Défaut relevé | Correction |
|---|---------------|------------|
| 1 | **Trop de codes secrets à 4 chiffres** (PIN de l'application, PIN de paiement, code MoMo, codes de remise, de visite, de démarrage, de fin) : un escroc peut obtenir le code MoMo en réclamant « le code ». | Les codes de confirmation deviennent une **carte QR** que l'autre partie **scanne** (5.6). Le code de secours a une forme différente, `LV-` + 1 lettre + 4 chiffres (ex. `LV-K4827`), et la carte rappelle « Ce n'est PAS votre code MoMo ». Les PIN restent des points `● ● ○ ○`, jamais affichés. |
| 2 | **Trop de texte** sur les écrans d'argent. | Textes raccourcis, icônes, bouton « ▶ Écouter » (principe 11). Écrans revus : E-MKT-04, E-IMMO-06, E-SRV-05, E-PAY-02. |
| 3 | **Fil surchargé** : la carte produit cachait la vidéo sur un petit écran. | Carte réduite à une **pastille** d'une ligne, qui s'agrandit au toucher (E-FEED-01, E-FEED-02). |
| 4 | **Payer à la remise sans solution de secours** si la demande MoMo n'arrive pas. | Le vendeur affiche un **QR de paiement** ; l'acheteur paie depuis sa propre application (E-MKT-08, E-MKT-09). Code marchand USSD à étudier avec l'agrégateur. |
| 5 | **Inscription trop longue** pour tenir en 60 s. | Prénom, nom et ville seulement ; case « J'ai 18 ans ou plus » à la place de la date de naissance (vérifiée au KYC) ; centres d'intérêt facultatifs ; quartier et photo demandés plus tard (E-AUTH-02 à 05). |
| 6 | **Consentement trop implicite** aux données personnelles. | Cases explicites à l'inscription (E-AUTH-02) et avant l'envoi des pièces d'identité (E-MOI-03). |
| 7 | Les dessins en texte ne valident ni le visuel ni l'usage réel. | **Prototype cliquable Flutter** (`app/`) et test terrain avec 15 à 20 utilisateurs avant la construction complète. |
