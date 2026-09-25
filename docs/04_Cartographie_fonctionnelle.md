# Document 04 — Cartographie fonctionnelle de Live (v2)

## 1. Objectif

Définir les modules de Live, leurs responsabilités, leurs interactions et **l'ordre de réalisation**, avec un objectif prioritaire : **que les gens quittent les réseaux sociaux qui ne leur rapportent rien et restent sur Live.**

---

## 2. Architecture générale : socle + expérience + verticales

```
┌───────────────────────────────────────────────────────────────────┐
│ EXPÉRIENCE      Live Feed · Live Direct · Live Chat · Recherche   │
├───────────────────────────────────────────────────────────────────┤
│ VERTICALES      Live Market · Live Immo · Live Services           │
│  (plus tard)    Live Livraison · Live Savoir · Live Emploi        │
├───────────────────────────────────────────────────────────────────┤
│ ÉCONOMIE        Live Pay · Live Créateurs · Live Pro · Live Ads   │
├───────────────────────────────────────────────────────────────────┤
│ SOCLE           Compte et capacités · Live Confiance ·            │
│                 Notifications · Administration · Statistiques     │
└───────────────────────────────────────────────────────────────────┘
```

**Règle d'architecture** : une verticale (immobilier, services, éducation…) **ne réinvente jamais** le paiement, la messagerie, les avis ou la modération. Elle réutilise le socle. C'est ce qui permet d'ajouter des verticales sans refaire la plateforme.

---

## 3. Pourquoi les gens resteront sur Live : les boucles de rétention

Facebook et TikTok retiennent les gens par le **divertissement**. Live doit les retenir par le divertissement **et** par l'**intérêt économique**. Cinq boucles sont conçues dès le départ :

| Boucle | Mécanisme | Qui est retenu |
|--------|-----------|----------------|
| **1. L'argent** | Mes ventes, mes réservations et mes cadeaux arrivent sur Live ; mon solde et mes retraits sont sur Live. **On revient là où l'on est payé.** | Vendeurs, prestataires, créateurs |
| **2. La confiance** | Mes avis, mon badge vérifié et ma réputation sont sur Live, et ne se transfèrent pas sur Facebook. Plus je vends, plus ma réputation a de la valeur. | Vendeurs, agences |
| **3. Le local** | Le fil montre ce qui se passe **dans ma ville et mon quartier** : nouveautés, bonnes affaires, logements disponibles, directs de commerçants voisins. | Acheteurs |
| **4. Le divertissement** | Vidéos courtes, directs et créateurs locaux, en français, lingala et kituba. | Tout le monde |
| **5. Les conversations** | Le chat avec les vendeurs, les agences et les prestataires, les groupes de quartier et de passion : **on ne passe plus par WhatsApp**. | Tout le monde |

**Mécanismes d'appui**
- **Alertes utiles** : « Un appartement 2 chambres à Bacongo sous 100 000 FCFA vient d'être publié. »
- **Partage vers l'extérieur** : chaque annonce ou vidéo partagée sur WhatsApp ou Facebook ramène vers Live (lien profond et aperçu). On **utilise** les autres réseaux pour les vider.
- **Import facile** : publier une annonce en 30 secondes à partir des photos et vidéos déjà présentes dans le téléphone.
- **Parrainage** : bonus pour le parrain et le filleul après le premier achat ou la première vente.
- **Mode léger** : une application qui fonctionne en 3G et consomme peu de données (vidéos compressées, qualité adaptative, préchargement en Wi-Fi).

---

## 4. Les modules

Priorité : **P1 = MVP**, **P2 = V2** (3 à 6 mois après le lancement), **P3 = V3** et au-delà.

### 4.1 Socle

#### Compte et capacités — P1
Inscription par téléphone et OTP, profil, niveaux KYC, espaces (boutique, agence, prestataire, chaîne), capacités, sécurité (PIN, appareils). *Voir le document 03.*

#### Live Confiance — P1
- Vérification d'identité et vérification professionnelle
- Avis réservés aux transactions réelles
- Signalements (annonce, profil, message, vidéo)
- **Litiges** et médiation liés au séquestre
- Modération : automatique (nudité, violence, mots-clés d'arnaque, photos dupliquées) et humaine
- Anti-fraude : comptes multiples, auto-achats, cartes volées, tentatives de paiement hors application
- Protection des mineurs

#### Notifications — P1
Push, SMS pour les événements critiques (paiement, retrait, code), notifications internes, alertes de recherche sauvegardée.

#### Administration (back-office) — P1
Modération, KYC, litiges, remboursements, gestion des utilisateurs et des capacités, gestion des catégories et des villes, configuration des commissions, réconciliation financière, journal d'audit.

#### Statistiques — P1 (interne) / P2 (vendeurs Pro)
Tableau de bord interne (utilisateurs actifs, volume de transactions, taux de litige) ; statistiques vendeur (vues, contacts, ventes).

### 4.2 Expérience

#### Live Feed — P1
Fil vertical de vidéos courtes et de photos, **où chaque publication peut être liée à un produit, un bien ou un service** (bouton « Acheter », « Réserver » ou « Visiter »). Onglets **« Pour toi »**, **« Près de moi »** et **« Abonnements »**. Commentaires, likes, partages, sauvegardes.

#### Recherche — P1
Recherche plein texte et filtres (catégorie, prix, ville, quartier, état, nombre de chambres…), recherches sauvegardées avec alertes.

#### Live Chat — P1
Messagerie un à un rattachée à une annonce, envoi de photos et de notes vocales, **proposition de prix** (négociation), bouton **« Payer »** dans la conversation, détection des tentatives d'arnaque (numéro de téléphone ou « paie-moi en direct » : avertissement). Groupes (quartier, passion, clients d'une boutique) en P2.

#### Live Direct — P2
Directs vidéo : **live shopping** (produits épinglés, achat pendant le direct), cadeaux virtuels, questions, rediffusion. Visites immobilières en direct.

### 4.3 Verticales

#### Live Market (produits) — P1
Annonces de produits neufs ou d'occasion, boutiques, catalogue, variantes (taille, couleur), stock simple, commande, séquestre, remise en main propre avec **code de confirmation** ou livraison par le vendeur, avis.

#### Live Immo (immobilier) — P1
Annonces de location et de vente (appartement, maison, studio, parcelle, local commercial, bureau), fiches structurées (quartier, chambres, eau, électricité, forage, parking, montant de l'avance ou de la caution), **agences vérifiées**, **commissionnaires vérifiés**, **frais de visite payés et séquestrés**, prise de rendez-vous, **réservation séquestrée**, signalement « bien déjà loué » ou « annonce frauduleuse ». Location meublée de courte durée en P2.

#### Live Services (prestataires) — P1
Catalogue de services (artisans, dépannage, beauté, événementiel, cours particuliers, photo et vidéo, ménage…), profil et portfolio, zone d'intervention, **demande de devis**, **réservation avec acompte séquestré**, confirmation de la prestation, avis.

#### Live Livraison — P2
Réseau de livreurs vérifiés (motos, coursiers), calcul du prix selon la distance, suivi, confirmation par code, paiement du livreur via Live Pay.

#### Live Savoir (éducation) — P3
Reprise des ambitions de la v1 : formations vendues par les créateurs, cours, PDF, directs éducatifs, puis **résultats d'examens et publications officielles** via des conventions avec les institutions.

#### Live Emploi et opportunités — P3
Offres d'emploi, stages, bourses et concours, profils de candidats, alertes, lutte contre les fausses offres.

#### Live IA et Crédits Live — P1 (produit propre, payant)
Services vendus par Live en **Crédits Live** : CV, lettres de motivation, business plans (express et complet), aide aux exercices par photo (mode apprentissage ou solution), résumé de documents ; tuteur vocal, traduction, courriers et présentations en P2. Services **gratuits** pour les vendeurs : rédaction d'annonce à partir des photos. *Voir le document 19.*

### 4.4 Économie

#### Live Pay — P1
Encaissement **MTN MoMo**, **Airtel Money** (P1) et **Visa** (P1 si l'agrégateur le permet, sinon P2), séquestre, soldes vendeurs, retraits, commissions, remboursements, historique, reçus, réconciliation. *Voir le document 06.*

#### Live Créateurs — P2
Chaîne de créateur, cadeaux virtuels, abonnements de fans, revenus, retraits, programme de partenariats avec des marques. Fonds Créateurs en P3 (lorsqu'il est financé par la publicité).

#### Live Pro — P1 (boosts) / P2 (abonnements complets)
Boosts d'annonces (P1), abonnements Pro Vendeur, Pro Agence, Pro Prestataire et Entreprise (P2), gestion d'équipe, statistiques avancées.

#### Live Ads — P2/P3
Campagnes publicitaires en libre-service pour les marques, ciblage par ville et par intérêt, rapports de performance.

---

## 5. Synthèse des phases

| Phase | Modules | Objectif business |
|-------|---------|-------------------|
| **P1 — MVP** (Brazzaville + Pointe-Noire) | Compte et capacités, Live Confiance, Notifications, Back-office, Feed, Recherche, Chat, **Market, Immo, Services**, **Live Pay (MoMo + Airtel + Visa)**, Boosts, **Live IA (Crédits Live)** | Prouver que les vendeurs vendent **plus et en sécurité** sur Live, et **générer un revenu immédiat** avec Live IA. |
| **P2 — Croissance** | Live Direct (live shopping), Live Créateurs, Abonnements Pro, Livraison, Groupes, Live IA vocal et Live Plus, Ads (bêta), location courte durée | Faire rester les gens : divertissement + créateurs payés. |
| **P3 — Expansion** | Live Savoir, Live Emploi, Ads complet, Fonds Créateurs, API partenaires, services financiers en partenariat, extension CEMAC | Devenir la super-app de la région. |

---

## 6. Dépendances clés

- **Live Pay** et **Live Confiance** sont des prérequis de **toutes** les verticales : ce sont eux qui différencient Live de Facebook.
- **Live Feed** dépend de la chaîne vidéo (envoi, compression, diffusion) : c'est le premier poste de coût technique.
- **Live Créateurs** dépend de Live Direct et de Live Pay.
- **Live Savoir, volet examens** dépend de conventions avec l'État : il ne doit **jamais** être sur le chemin critique du lancement.

**Fin du Document 04**
