# Document 00 — Architecture documentaire (v2)

## 0. Objet

Ce document organise l'ensemble du dossier de conception de **Live v2**. Chaque document est autonome, relu et validé séparément, puis intégré au cahier des charges consolidé.

Principe directeur, conservé de la v1 :

> Tout le monde entre sur Live comme **utilisateur**. Vendre, louer, proposer un service, créer du contenu, représenter une entreprise ou administrer : ce sont des **capacités** accordées par vérification, abonnement ou autorisation. Le seul rôle permanent est le **Super Administrateur**.

---

## 1. Plan du dossier

Le dossier est organisé en **quatre blocs**. On ne rédige pas un bloc tant que le précédent n'est pas validé.

### Bloc A — Fondations (rédigé dans cette version)

| N° | Document | Question à laquelle il répond |
|----|----------|-------------------------------|
| 01 | Vision, identité et positionnement | Qu'est-ce que Live, pour qui, et pourquoi quitter Facebook et TikTok ? |
| 02 | Modèle économique | Qui paie, combien, et comment tout le monde gagne ? |
| 03 | Identité utilisateur, boutiques et capacités | Comment un simple utilisateur devient vendeur, agence ou prestataire ? |
| 04 | Cartographie fonctionnelle | Quels modules, dans quel ordre ? |
| 05 | Cahier des charges fonctionnel — MVP | Que doit-on livrer exactement en premier ? |
| 06 | Paiements : Mobile Money, Visa et séquestre | Comment l'argent circule-t-il légalement et en sécurité ? |
| 07 | Registre des décisions à valider | Qu'est-ce que le promoteur doit trancher ? |

### Bloc B — Spécifications détaillées par module (à rédiger)

| N° | Document |
|----|----------|
| 10 | Live Market : produits et boutiques |
| 11 | Live Immo : immobilier et agences |
| 12 | Live Services : prestataires et réservations |
| 13 | Live Feed et Live Direct : vidéo, social et live shopping |
| 14 | Live Chat : messagerie et négociation |
| 15 | Live Créateurs : monétisation du contenu |
| 16 | Live Confiance : vérification, avis, litiges, modération, anti-fraude |
| 17 | Live Pro et Live Ads : abonnements professionnels et publicité |
| 18 | Live Livraison |
| 19 | **Live IA et Crédits Live** : produits propres de la plateforme (CV, lettres, business plans, exercices par photo, tuteur vocal) |
| 25 | Verticales futures : Live Savoir (éducation, examens), Live Emploi et opportunités |

### Bloc C — Technique et conformité (à rédiger)

| N° | Document |
|----|----------|
| 20 | Architecture technique (mobile, web, backend, vidéo, recherche, hors ligne et faible débit) |
| 21 | Piliers « référence » : Live IA partout, tontines, diaspora, quotidien, cartes |
| 22 | Sécurité, protection des données et conformité (droit congolais et CEMAC) |
| 23 | Administration, modération et support |
| 24 | Parcours utilisateurs détaillés |
| 26 | Back-end : modèle de données, base locale (Drift) et synchronisation |

### Bloc D — Pilotage (à rédiger)

| N° | Document |
|----|----------|
| 30 | Feuille de route et plan de lancement |
| 31 | Business plan et projections financières |
| 32 | Gouvernance, équipe et organisation |
| 40 | **Cahier des charges consolidé** (pour développeurs, investisseurs, partenaires, prestataires) |

---

## 2. Correspondance avec la v1

Rien n'est perdu : chaque document de la v1 trouve sa place.

| Document v1 | Devient en v2 |
|-------------|---------------|
| 05 Live Exam | 19 — Live Savoir (verticale, phase 3) |
| 06 Live Opportunity | 19 — Live Emploi et opportunités (phase 3) |
| 07 Live Learn / 08 Live Studio | 15 — Live Créateurs + 19 — Live Savoir |
| 09 Live Direct | 13 — Live Feed et Live Direct (orienté live shopping) |
| 10 Live Wallet | 06 — Paiements (+ 21, 22) |
| 11 Rémunération des créateurs | 15 — Live Créateurs |
| 12 Live AI | 19 — Live IA et Crédits Live (produit payant du MVP) |
| 13 Réseau social | 13 + 14 |
| 14 Institutions | 03 (organisations) + 17 (Live Pro) |
| 15 Administration et sécurité | 16 + 22 + 23 |
| 16 à 22 | 20 à 40 |

---

## 3. Gabarit commun des documents de module

Chaque document du bloc B suit le même plan, repris de la v1 :

1. Finalité
2. Acteurs concernés
3. Fonctionnalités (identifiants `F-XXX-nn`, priorité MoSCoW)
4. Règles métier (identifiants `R-XXX-nn`)
5. Données manipulées
6. Flux financiers
7. Sécurité, conformité, anti-fraude
8. Risques
9. Indicateurs de succès
10. Décisions à valider
11. Dépendances

Priorités **MoSCoW** :
- **M** (*Must*) : indispensable au MVP ;
- **S** (*Should*) : important, juste après le MVP ;
- **C** (*Could*) : souhaitable ;
- **W** (*Won't now*) : prévu, mais pas dans cette version.

---

## 4. Méthode de validation

1. Le document est proposé (pull request).
2. Le promoteur relit, commente et tranche les points du registre (document 07).
3. Le document passe au statut **Validé** et devient une brique stable.
4. Toute modification ultérieure passe par une nouvelle pull request et une entrée dans l'historique du document.
