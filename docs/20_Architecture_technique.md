# Document 20 — Architecture technique

> Choix imposés par le promoteur : **Flutter** (applications) et **Supabase** (backend). Ce document décrit comment construire Live sur ce socle de façon **sûre, économe en données, maîtrisée en coûts et réversible**.
> Les tarifs de fournisseurs cités sont des **ordres de grandeur publics** à revérifier au moment de la signature.

## 1. Principes d'architecture

1. **Le réseau est le premier ennemi** : l'application doit rester utilisable en 3G instable, avec des forfaits de données chers. Chaque octet envoyé ou reçu doit être justifié.
2. **L'argent ne se manipule jamais côté client** : aucune écriture financière ne peut venir de l'application. Tout passe par des fonctions serveur contrôlées.
3. **Monolithe modulaire** : une seule base PostgreSQL découpée en **schémas par domaine**, une seule application Flutter découpée **par fonctionnalité**. Pas de micro-services au MVP.
4. **Services gérés plutôt que faits maison** pour ce qui n'est pas notre métier (vidéo, SMS, notifications push, supervision).
5. **Réversibilité** : chaque fournisseur externe (paiement, vidéo, SMS) est derrière une **interface interne** ; changer de fournisseur ne touche pas le code métier.
6. **Sécurité par défaut** : Row Level Security (RLS) sur toutes les tables exposées, secrets hors du code, journal d'audit inaltérable.

---

## 2. Vue d'ensemble

```
┌──────────────────────── CLIENTS ────────────────────────┐
│  App Flutter Android / iOS      Back-office Flutter Web  │
│  (utilisateurs)                 (agents Live, admin)     │
└──────────────┬───────────────────────────┬──────────────┘
               │ HTTPS / WebSocket          │
┌──────────────▼───────────────────────────▼──────────────┐
│                       SUPABASE                           │
│  Auth (téléphone + OTP)   PostgREST (API auto + RLS)     │
│  Realtime (chat, statuts) Storage (images, documents)    │
│  Edge Functions (Deno/TS) : paiement, webhooks, vidéo,   │
│    notifications, pages de partage, tâches               │
│  PostgreSQL : schémas par domaine + grand livre          │
│    extensions : PostGIS, pg_trgm, unaccent, pg_cron,     │
│    pgmq (files), pgTAP (tests)                           │
└───┬──────────┬──────────┬──────────┬──────────┬─────────┘
    │          │          │          │          │
┌───▼───┐ ┌────▼────┐ ┌───▼────┐ ┌───▼────┐ ┌───▼─────┐
│Paiement│ │  Vidéo  │ │  SMS   │ │  Push  │ │Supervision│
│agrégateur│ │Cloudflare│ │agrégateur│ │  FCM   │ │ Sentry  │
│(CinetPay│ │ Stream  │ │ local  │ │ (+APNs)│ │ PostHog │
│/pawaPay)│ │         │ │        │ │        │ │         │
└────────┘ └─────────┘ └────────┘ └────────┘ └─────────┘
```

---

## 3. Applications Flutter

### 3.1 Cibles

| Application | Techno | Public | Phase |
|-------------|--------|--------|-------|
| **Live** (mobile) | Flutter, Android d'abord puis iOS | Tous les utilisateurs | P1 |
| **Live Admin** (back-office) | **Flutter Web** | Agents Live, Super Administrateur | P1 |
| **Pages de partage publiques** | HTML généré par une Edge Function | Toute personne qui ouvre un lien partagé (WhatsApp, Facebook) | P1 |
| **Live Web** (catalogue public consultable, référencement Google) | À décider en P2 (Flutter Web ou rendu serveur léger) | Visiteurs web, diaspora | P2 |

> **Pourquoi des pages de partage séparées** : Flutter Web ne produit pas de balises d'aperçu lisibles par WhatsApp et Facebook, ni de pages bien référencées. Or chaque lien partagé doit afficher **photo, titre et prix**, puis ouvrir l'application (ou le Play Store). Une Edge Function qui renvoie une petite page HTML avec les balises Open Graph règle ce besoin sans ajouter un second framework.

### 3.2 Choix techniques de l'application

| Sujet | Choix | Raison |
|-------|-------|--------|
| Gestion d'état | **Riverpod** | Testable, adapté à une grosse application modulaire |
| Navigation et liens profonds | **go_router** + **Android App Links / iOS Universal Links** sur le domaine de Live | Les liens `live.xx/p/123` ouvrent directement l'annonce |
| Client backend | **supabase_flutter** | Auth, requêtes, Realtime, Storage |
| Base locale | **drift** (SQLite) | Brouillons hors ligne, cache, file d'envoi |
| Lecture vidéo | Lecteur HLS natif (**video_player** ; `media_kit` à évaluer) | Lecture adaptative |
| Compression vidéo et image sur l'appareil | Plugin de compression natif (Android MediaCodec / iOS AVFoundation) ; WebP pour les images | Diviser la taille des envois (voir section 6.3) |
| Envoi de fichiers reprenable | Protocole **tus** | Reprise après coupure réseau |
| Notifications push | **firebase_messaging** (FCM, APNs pour iOS) | Standard |
| Erreurs et plantages | **sentry_flutter** | Diagnostic en production |
| Analytique produit | **PostHog** (hébergement UE) | Entonnoirs, rétention, sans revendre les données |
| Internationalisation | **flutter_localizations** + fichiers ARB | Français au MVP, lingala et kituba en P2 |

### 3.3 Organisation du code (par fonctionnalité)

```
lib/
  core/            # thème, routage, client Supabase, erreurs, i18n, stockage local
  shared/          # composants UI communs (cartes d'annonce, lecteur vidéo, avatar…)
  features/
    auth/          # inscription, OTP, PIN
    profile/       # profil, espaces, capacités, KYC
    feed/          # fil vidéo, publication
    search/
    chat/
    market/        # Live Market
    immo/          # Live Immo
    services/      # Live Services
    pay/           # paiement, solde, retraits (UI uniquement)
    trust/         # avis, signalements, réclamations
    notifications/
```
Chaque fonctionnalité suit la même structure : `data/` (dépôts, sources), `domain/` (modèles, règles), `presentation/` (écrans, contrôleurs).

### 3.4 Contraintes de performance (NF-01, NF-02)

- Construction en **Android App Bundle** (un APK par architecture) : objectif **< 30 Mo** téléchargés.
- Cible : **Android 8+, 2 Go de RAM** ; tests réguliers sur 3 téléphones d'entrée de gamme vendus localement.
- Premier écran utile en **< 3 s en 3G** : écran d'accueil servi depuis le cache local, puis rafraîchi.
- Images : vignettes chargées d'abord, avec un **aperçu flou (BlurHash)** immédiat.

---

## 4. Supabase : le backend

### 4.1 Organisation de la base (schémas par domaine)

| Schéma | Contenu | Exposé à l'API ? |
|--------|---------|------------------|
| `core` | utilisateurs, profils, espaces, membres, capacités, niveaux KYC, référentiels (villes, quartiers, catégories) | Oui (RLS) |
| `feed` | publications, médias, likes, commentaires, abonnements, événements de visionnage | Oui (RLS) |
| `market` | produits, variantes, commandes, offres | Oui (RLS) |
| `immo` | biens, conditions, visites, réservations, alertes | Oui (RLS) |
| `services` | prestataires, services, demandes, devis, prestations | Oui (RLS) |
| `chat` | conversations, messages, cartes (offres, devis, paiements) | Oui (RLS) |
| `trust` | avis, signalements, réclamations, décisions, modération | Partiellement |
| `pay` | intentions de paiement, transactions, **grand livre**, soldes, retraits, webhooks reçus | **Non** : accès uniquement par fonctions serveur |
| `admin` | agents, permissions du back-office, **journal d'audit** | **Non** : accès par fonctions dédiées |

### 4.2 Authentification

- **Supabase Auth, connexion par téléphone + OTP**.
- Envoi des SMS via le **hook « Send SMS » de Supabase Auth** vers un **agrégateur SMS local ou régional** (meilleure délivrabilité vers MTN et Airtel Congo et coût plus bas que les fournisseurs internationaux). Fournisseur international en secours.
- **PIN de l'application** et **PIN de paiement** gérés côté serveur (haché), avec un nombre de tentatives limité.
- Sessions : jeton court + jeton de rafraîchissement ; liste des appareils ; révocation à distance.
- Comptes des agents du back-office : e-mail + **authentification à deux facteurs** obligatoire.

### 4.3 Sécurité des données (RLS)

- **RLS activée sur 100 % des tables** exposées ; test automatique en CI qui échoue si une table exposée n'a pas de politique.
- Les **capacités** (document 03) sont vérifiées **dans les politiques RLS et les fonctions**, pas seulement dans l'interface (ex. seule une personne ayant `C-IMMO-*` peut insérer dans `immo.bien`).
- Les données sensibles (pièces d'identité, adresse exacte d'un bien, adresse du client d'une prestation) sont dans des **buckets privés** et des colonnes à accès restreint, lues via des **URL signées à durée courte** et des vues filtrées.
- Les secrets (clés de l'agrégateur, clés vidéo) sont dans **Supabase Vault** et les variables secrètes des Edge Functions, **jamais** dans l'application.

### 4.4 Logique serveur

| Mécanisme | Utilisation |
|-----------|-------------|
| **Fonctions PostgreSQL** (`SECURITY DEFINER`, transactionnelles) | Toute opération qui doit être atomique : accepter une commande, confirmer par code, écrire au grand livre, changer un statut |
| **Edge Functions** (Deno / TypeScript) | Appels aux services externes : paiement, vidéo, SMS, push, pages de partage, réception des **webhooks** |
| **Déclencheurs (triggers)** | Journal d'audit, compteurs, mise en file d'événements |
| **pgmq** (files de messages dans Postgres) | Traitements asynchrones fiables : notifications, modération, traitement vidéo, relances |
| **pg_cron** | Tâches planifiées : confirmations automatiques (48 h, 72 h), expiration des annonces, réconciliation quotidienne, purge des vidéos |

### 4.5 Temps réel

- **Supabase Realtime** pour : les nouveaux messages de chat, les changements de statut des commandes et des visites, les indicateurs « en train d'écrire ».
- Écoute limitée aux conversations ouvertes (économie de batterie et de données) ; les autres événements passent par les **notifications push**.
- **Vérifier les quotas de connexions simultanées** du forfait Supabase et prévoir l'extension avant la montée en charge.

### 4.6 Recherche

| Phase | Solution |
|-------|----------|
| P1 | **PostgreSQL** : recherche plein texte (configuration française + `unaccent`), **pg_trgm** pour la tolérance aux fautes, **PostGIS** pour la proximité (quartier, distance), table de synonymes locaux |
| P2+ | Moteur dédié (**Meilisearch** ou **Typesense**) alimenté depuis Postgres, **si** la latence ou la pertinence l'exigent |

### 4.7 Fil « Pour toi » et « Près de moi »

- **MVP sans apprentissage automatique** : un **score calculé en SQL** et rafraîchi toutes les quelques minutes par ville :
  `score = proximité × fraîcheur × qualité (vidéo, fiche complète) × réputation du vendeur × engagement (taux de visionnage complet, partages, sauvegardes) + boost`
- **Journal d'événements** dès le premier jour (vue, visionnage à 25/50/100 %, clic sur « Acheter », partage), stocké dans une table **partitionnée par mois** : il servira à entraîner un vrai algorithme de recommandation en P2 ou P3.
- Diversité imposée : pas plus de 2 publications consécutives d'un même vendeur ; mélange des verticales.

---

## 5. Paiement et grand livre (document 06)

- Schéma `pay` **non exposé** ; seules des fonctions contrôlées y écrivent.
- **Grand livre en partie double** : table `pay.ecriture` (compte débité, compte crédité, montant en **entiers de FCFA**, référence, clé d'idempotence) ; les soldes sont des **vues calculées** (avec un instantané périodique pour la performance).
- **Intention de paiement** créée par une fonction, puis Edge Function `pay-initiate` qui appelle l'agrégateur.
- **Webhooks** reçus par l'Edge Function `pay-webhook` : vérification de la **signature**, enregistrement brut dans `pay.webhook_recu`, traitement **idempotent**, puis écriture au grand livre.
- **Interrogation de statut** (pg_cron + Edge Function) pour les paiements restés sans réponse.
- **Réconciliation quotidienne** : relevé de l'agrégateur ↔ grand livre ↔ compte séquestre ; rapport dans le back-office et alerte en cas d'écart.
- **Interface `PaymentProvider`** (méthodes : initier, statut, rembourser, décaisser, vérifier la signature) avec une implémentation par fournisseur (CinetPay, pawaPay, puis MTN et Airtel en direct).
- Tests automatisés du grand livre (**pgTAP**) : somme des écritures toujours nulle, aucun solde négatif, idempotence.

---

## 6. Vidéo : le cœur technique et le premier poste de coût

### 6.1 Les contraintes

| Contrainte | Conséquence technique |
|------------|-----------------------|
| Forfaits de données **chers** pour les utilisateurs | Débit adaptatif, qualité de départ basse, mode économie de données, pas de préchargement agressif |
| Réseau **3G/4G instable** | Envoi reprenable, lecture qui s'adapte en continu, petites vidéos |
| Téléphones d'**entrée de gamme** | Encodage H.264 (décodage matériel universel), résolution maximale de 720p |
| Coût de diffusion **proportionnel aux minutes regardées** | Durée limitée, purge des vidéos inutiles, mesure fine |
| Contenus à **modérer** | Analyse avant publication (vignettes et extraits) |

### 6.2 Choix du fournisseur

| Option | Principe | Pour | Contre |
|--------|----------|------|--------|
| **Cloudflare Stream** | Envoi, encodage, stockage, diffusion HLS/DASH ; tarif **à la minute stockée et à la minute diffusée**, encodage inclus | Tarif simple et prévisible, envoi direct depuis l'application (tus), URL signées, webhooks, présence mondiale du réseau Cloudflare, offre de direct (Stream Live) pour la P2 | Payé à la minute même en basse qualité ; dépendance à un fournisseur |
| **Mux** | Plateforme vidéo complète, très bonnes statistiques de qualité | Excellente qualité et analytique | Généralement plus cher à grande échelle |
| **Bunny Stream** | Stockage + CDN facturés **au Go** | Moins cher à grande échelle, et la basse qualité coûte moins | Moins complet ; tarifs de diffusion en Afrique à vérifier |
| **Fait maison** (Supabase Storage + serveurs d'encodage FFmpeg + CDN) | Tout contrôler | Le moins cher à très grande échelle | Lourd à exploiter, compétences rares : **pas au MVP** |

**Décision (D-20 précisée)** : **Cloudflare Stream au MVP**, derrière une interface interne `VideoProvider` (créer un envoi, statut, URL de lecture signée, vignette, supprimer). Réévaluation à **1 million de minutes diffusées par mois** : bascule possible vers Bunny ou une solution maison si le coût au Go devient nettement plus avantageux.

### 6.3 Chaîne de publication d'une vidéo

```
1. Téléphone : sélection ou tournage (60 s max, D-05)
2. Téléphone : compression locale → H.264 720p max, ~1,5 Mbit/s, AAC 64 kbit/s
   (une vidéo de 60 s passe d'environ 60-120 Mo à environ 10-12 Mo)
3. Téléphone : génération d'une vignette + BlurHash ; brouillon enregistré hors ligne
4. Edge Function `video-create-upload` : vérifie la capacité et les quotas, crée une URL d'envoi à usage unique
5. Téléphone → Cloudflare Stream directement (tus, reprenable) : le fichier ne passe pas par nos serveurs
6. Cloudflare encode les qualités (240p, 360p, 480p, 720p) → webhook `video-ready`
7. Modération automatique (vignettes et images extraites) → publication, ou file de revue humaine
8. Publication visible dans le fil, avec une URL de lecture signée
```

- **Envoi en Wi-Fi uniquement** : option proposée aux utilisateurs dont le forfait est limité (la publication part automatiquement au retour du Wi-Fi).
- **File d'envoi persistante** : si l'application est fermée ou si le réseau coupe, l'envoi reprend là où il s'était arrêté.

### 6.4 Lecture économe en données

| Mécanisme | Règle |
|-----------|-------|
| **Qualité de départ** | 360p sur données mobiles, 480p ou 720p en Wi-Fi ; puis adaptation automatique (HLS) |
| **Mode économie de données** (activé par défaut au premier lancement si la connexion est lente) | Plafond de 360p, pas de lecture automatique hors du fil principal, vignettes allégées |
| **Préchargement** | Uniquement **les premières secondes** de la vidéo suivante ; rien au-delà sur données mobiles |
| **Cache local** | Segments récemment vus conservés (cache limité, environ 300 Mo, paramétrable) : revoir une vidéo ne coûte rien |
| **Compteur de données** | Écran « Données consommées par Live ce mois-ci » : un argument de transparence face à TikTok |
| **Alternance photos et vidéos** | Le fil mélange photos et vidéos, ce qui réduit la consommation moyenne |

### 6.5 Cycle de vie et purge (maîtrise des coûts de stockage)

| Situation | Règle |
|-----------|-------|
| Annonce vendue, louée ou terminée | Vidéo retirée du fil ; **supprimée du fournisseur 30 jours après** (la vignette est conservée pour l'historique) |
| Annonce masquée depuis 90 jours | Vidéo supprimée |
| Publication sociale sans vue depuis 12 mois | Archivage ou suppression (règle à valider, avec information de l'auteur) |
| Compte supprimé | Suppression de toutes les vidéos (droit à l'effacement) |

### 6.6 Estimation des coûts vidéo (ordre de grandeur à vérifier)

Hypothèses de tarifs publics de Cloudflare Stream : **environ 5 $ par 1 000 minutes stockées par mois** et **environ 1 $ par 1 000 minutes diffusées**, encodage inclus.

| Scénario | Minutes regardées / mois | Minutes stockées | Coût mensuel estimé |
|----------|--------------------------|------------------|---------------------|
| Pilote (2 000 actifs par jour × 10 min) | 600 000 | 20 000 | ≈ 600 $ + 100 $ = **≈ 700 $** |
| Fin du MVP (10 000 actifs par jour × 20 min) | 6 000 000 | 100 000 | ≈ 6 000 $ + 500 $ = **≈ 6 500 $** |
| Croissance (100 000 actifs par jour × 30 min) | 90 000 000 | 500 000 | ≈ 90 000 $ + 2 500 $ : **bascule vers une solution au Go obligatoire avant ce stade** |

**Conséquences** :
1. La vidéo est **le premier poste de coût variable** : elle doit être financée par les transactions et les boosts, d'où la priorité donnée au commerce.
2. Les **minutes regardées par utilisateur** sont un indicateur financier suivi chaque semaine.
3. Le **seuil de bascule** (1 million de minutes par mois) est un point de contrôle de la feuille de route.

### 6.7 Directs et live shopping (P2)

| Besoin | Solution envisagée |
|--------|--------------------|
| Direct d'un vendeur ou d'un créateur vers de nombreux spectateurs | **Cloudflare Stream Live** (envoi RTMPS ou WebRTC depuis le téléphone, lecture HLS basse latence), même fournisseur que la vidéo à la demande |
| Chat, cadeaux, produits épinglés pendant le direct | **Supabase Realtime** (canaux par direct) |
| Achat pendant le direct | Carte produit épinglée, avec le paiement Live Market standard |
| Visite immobilière vidéo en tête-à-tête, appel vidéo acheteur-vendeur | **WebRTC** via un service géré (**LiveKit Cloud** ou **Agora**), à comparer en P2 |
| Rediffusion | Enregistrement automatique du direct, devenant une vidéo à la demande (soumise aux règles de purge) |

### 6.8 Modération de la vidéo

- **Avant publication** : analyse automatique des vignettes et de plusieurs images extraites (nudité, violence, armes) par un service d'analyse d'images ; publication immédiate si le résultat est net, **file humaine** si c'est douteux.
- **Texte** (titre, description, sous-titres) : liste de mots interdits + détection des coordonnées et des tentatives d'arnaque.
- **Après publication** : signalements des utilisateurs → file prioritaire.
- **Directs (P2)** : modérateurs humains sur les directs à forte audience, coupure immédiate possible.

---

## 7. Images et documents

- **Compression sur l'appareil** : WebP, 1 280 px sur le plus grand côté, **< 300 Ko** par photo ; vignette + BlurHash générés localement.
- **Supabase Storage** : buckets publics (photos d'annonces, avec CDN et transformation d'images à la volée) et **buckets privés** (pièces d'identité, justificatifs, preuves de litiges).
- **Empreinte perceptuelle** calculée sur chaque photo d'annonce (détection des photos réutilisées, F-IMMO-PUB-07, F-MKT-PUB-07).
- Suppression des **métadonnées EXIF de localisation** des photos publiques (protection de la vie privée), après extraction de la date de prise de vue.

---

## 8. Notifications

| Canal | Utilisation | Fournisseur |
|-------|-------------|-------------|
| Push | Messages, commandes, visites, alertes de recherche, statut des paiements | FCM (APNs pour iOS) |
| SMS | OTP, paiement reçu, retrait effectué, litige ouvert (événements critiques uniquement : coût) | Agrégateur SMS local, fournisseur international en secours |
| Dans l'application | Centre de notifications | Supabase (table + Realtime) |
| E-mail | Agences et entreprises (rapports, factures) | Service d'envoi transactionnel (P2) |

Toutes les notifications passent par une **file** (`pgmq`) et une Edge Function d'envoi : regroupement, heures de silence et préférences de l'utilisateur appliqués au même endroit.

---

## 9. Hébergement, environnements et livraison

### 9.1 Région

- Choisir la **région Supabase avec la latence la plus faible depuis Brazzaville et Pointe-Noire**. Avant la décision, **mesurer** depuis les deux villes, sur MTN et sur Airtel. À défaut d'une région en Afrique centrale, les régions d'Europe de l'Ouest (Paris, Londres, Francfort) sont les candidates probables, car le trafic congolais y transite souvent.
- Les médias (vidéos, images) sont servis par **CDN** : c'est ce qui compte le plus pour la vitesse perçue.
- Vérifier avec le juriste les **exigences de localisation des données** de la loi congolaise sur la protection des données personnelles (D-16).

### 9.2 Environnements

| Environnement | Usage |
|---------------|-------|
| **Local** | Supabase CLI (base, Auth, Storage et Edge Functions en local) |
| **Préproduction** (projet Supabase dédié) | Tests d'intégration, agrégateur en mode test, recette |
| **Production** (projet Supabase dédié, forfait payant avec sauvegardes point-in-time) | Utilisateurs réels |

### 9.3 Code et intégration continue

- **Un dépôt unique** (celui-ci) : `app/` (Flutter mobile), `admin/` (Flutter web), `supabase/` (migrations SQL, politiques RLS, fonctions, Edge Functions, tests), `docs/`.
- **Migrations versionnées** (Supabase CLI) : aucune modification manuelle de la base de production.
- **GitHub Actions** à chaque pull request : `flutter analyze`, `flutter test`, vérification du formatage, tests SQL **pgTAP** (RLS, grand livre), tests des Edge Functions, contrôle qu'aucune table exposée n'est sans RLS.
- **Déploiement** : migrations et Edge Functions déployées automatiquement en préproduction, puis en production sur validation manuelle.
- **Builds mobiles** : GitHub Actions (ou Codemagic) → Play Console (tests internes, puis tests fermés, puis production progressive).

### 9.4 Supervision

- **Sentry** : plantages Flutter, erreurs des Edge Functions.
- **Journaux Supabase** + alertes : taux d'échec des paiements, webhooks en erreur, écarts de réconciliation, files en retard.
- **Tableau de bord technique** : latence de l'API, temps de démarrage de la vidéo, taux d'erreurs de lecture, minutes diffusées par jour, coût vidéo estimé.

### 9.5 Sauvegardes et continuité

- Sauvegardes quotidiennes + **restauration à un instant donné** (production).
- **Export hebdomadaire chiffré** de la base vers un stockage indépendant de Supabase (réversibilité et sécurité).
- Procédure testée de **restauration** chaque trimestre.
- Mode dégradé : si un opérateur de paiement est indisponible, l'application le signale et propose un autre moyen de paiement (document 06, section 8).

---

## 10. Montée en charge

| Palier | Mesures |
|--------|---------|
| MVP (100 000 inscrits, 10 000 actifs par jour, NF-09) | Forfait Supabase avec une puissance de calcul adaptée, index soignés, fil précalculé par ville, CDN pour tous les médias |
| 100 000 actifs par jour | Réplique en lecture pour le fil et la recherche, moteur de recherche dédié, partitionnement des événements et des messages, surveillance des quotas Realtime |
| Au-delà | Extraction éventuelle des domaines les plus sollicités (chat, fil) en services dédiés ; la base Postgres standard rend cette évolution possible sans réécriture |

---

## 11. Réversibilité

| Composant | Comment en sortir |
|-----------|-------------------|
| Supabase | Tout repose sur **PostgreSQL standard** (export `pg_dump`) ; l'authentification est exportable ; les Edge Functions sont en TypeScript/Deno portable ; Supabase est open source et peut être auto-hébergé |
| Vidéo | Interface `VideoProvider` ; les vidéos originales compressées peuvent être conservées sur notre stockage pour une migration |
| Paiement | Interface `PaymentProvider` ; le grand livre est chez nous |
| SMS, push | Derrière des Edge Functions dédiées |

---

## 12. Estimation des coûts techniques mensuels (MVP, à affiner dans le document 31)

| Poste | Ordre de grandeur |
|-------|-------------------|
| Supabase (forfait payant + puissance de calcul + stockage) | 100 à 600 $ selon la charge |
| Vidéo (Cloudflare Stream) | 700 $ (pilote) à 6 500 $ (fin du MVP), voir 6.6 |
| SMS (OTP et événements critiques) | Dépend du tarif local : à chiffrer avec l'agrégateur (souvent le 2e poste variable) |
| Sentry, PostHog, domaine, magasins d'applications | 100 à 300 $ |
| Modération d'images automatique | Selon le volume ; à chiffrer |

---

## 13. Décisions techniques

| N° | Décision |
|----|----------|
| DT-01 | **Flutter** pour l'application mobile (Android puis iOS) **et** le back-office (Flutter Web). *(Remplace D-17 et D-18.)* |
| DT-02 | **Supabase** : Auth par téléphone, PostgreSQL avec RLS, Storage, Realtime, Edge Functions. *(Confirme D-19.)* |
| DT-03 | **Pages de partage** générées par une Edge Function (aperçus WhatsApp et Facebook, redirection vers l'application). |
| DT-04 | **Grand livre et logique financière dans PostgreSQL** (schéma `pay` non exposé, fonctions transactionnelles), webhooks dans des Edge Functions. |
| DT-05 | **Cloudflare Stream** pour la vidéo au MVP, derrière `VideoProvider` ; réévaluation à 1 million de minutes diffusées par mois. *(Précise D-20.)* |
| DT-06 | Vidéo : **compression sur l'appareil** (720p max, environ 1,5 Mbit/s), envoi direct reprenable, **360p par défaut sur données mobiles**, mode économie de données, purge des vidéos inutiles. |
| DT-07 | Recherche **PostgreSQL** (plein texte, pg_trgm, PostGIS) au MVP. |
| DT-08 | Fil calculé par **score SQL** au MVP ; journal d'événements dès le premier jour pour la recommandation future. |
| DT-09 | **SMS via un agrégateur local** grâce au hook d'envoi de SMS de Supabase Auth. |
| DT-10 | Région Supabase choisie **après mesure de latence** depuis Brazzaville et Pointe-Noire ; CDN pour tous les médias. |
| DT-11 | **Dépôt unique** (app, admin, supabase, docs), migrations versionnées, CI GitHub Actions avec tests RLS et tests du grand livre. |

---

## 14. Dépendances

- Document 06 (paiements) : grand livre, agrégateur, webhooks.
- Document 21 (modèle de données) : détail des tables de chaque schéma.
- Document 22 (sécurité et conformité) : localisation des données, conservation, chiffrement.
- Documents 10, 11, 12 : règles métier implémentées dans les fonctions PostgreSQL.

**Fin du Document 20**
