# LIVE — Dossier de conception (version 2)

> **Live est la place de marché sociale de l'Afrique centrale** : on y découvre, on y vend, on y loue, on y réserve et on y est payé, en Mobile Money, en toute confiance.

Ce dossier remplace la version 1 (plateforme éducative), archivée dans [`archives/v1-education/`](archives/v1-education/).

---

## 1. Pourquoi une version 2 ?

### 1.1 Diagnostic de la version 1 (le « méli-mélo »)

La version 1 contenait de très bonnes idées, mais elle souffrait de cinq problèmes structurels :

| # | Problème | Conséquence |
|---|----------|-------------|
| 1 | **Identité contradictoire** : « plateforme de référence de l'éducation » alors que la vision réelle du promoteur est un **marché où l'on peut tout faire**. | Impossible de prioriser : tout paraît central. |
| 2 | **16 modules présentés au même niveau** (Feed, Exam, Opportunity, Learn, Studio, Direct, Community, Wallet, AI, Marketplace, Institution, Admin, Analytics, Notifications, Support, Safety). | Un MVP qui contient 5 modules lourds (dont Live Exam, qui dépend de conventions avec l'État) n'est pas un MVP. |
| 3 | **Économie sans moteur principal** : abonnements, commissions, crédits IA, fonds créateurs, publicité… sans dire lequel paie les factures au démarrage. | Risque de lancer une plateforme coûteuse (vidéo, IA) sans revenu récurrent. |
| 4 | **Portefeuille décrit comme une banque** (dépôts, soldes, retraits) sans cadre réglementaire. | En zone CEMAC, détenir l'argent du public est une activité réglementée (établissement de paiement / monnaie électronique). |
| 5 | **Pas de réponse à la question « pourquoi quitter Facebook et TikTok ? »** | Sans avantage décisif pour les vendeurs, ils resteront là où est l'audience. |

### 1.2 Ce que la version 2 change

1. **Un cœur clair** : le **commerce social** (vendre, louer, réserver, promouvoir). L'éducation, les examens et les opportunités deviennent des **verticales** qui se branchent sur ce cœur, plus tard.
2. **Un moteur économique principal** : la **commission sur les transactions sécurisées**, complétée par les **boosts** et les **abonnements Pro**. Le reste (publicité, IA, fonds créateurs) vient ensuite.
3. **Une promesse anti-Facebook** : sur Live, **l'argent circule dans l'application** et **l'acheteur est protégé** (paiement séquestré), ce que Facebook, TikTok et WhatsApp ne font pas au Congo.
4. **Un MVP réaliste** : Brazzaville et Pointe-Noire, trois verticales (produits, immobilier, services), paiement MTN MoMo et Airtel Money.
5. **Conservation des bons principes de la v1** : compte unique, capacités plutôt que rôles, Super Administrateur unique, journalisation, vérification avant retrait.

> **Principe de non-simplification (conservé de la v1)** : aucune ambition n'est supprimée. On change l'**ordre** de déploiement, pas la vision.

---

## 2. Index des documents

| N° | Document | Statut |
|----|----------|--------|
| 00 | [Architecture documentaire](00_Architecture_documentaire.md) | Arrêté (v2.0) |
| 01 | [Vision, identité et positionnement](01_Vision_identite_positionnement.md) | Arrêté (v2.0) |
| 02 | [Modèle économique](02_Modele_economique.md) | Arrêté (v2.0) |
| 03 | [Identité utilisateur, boutiques et capacités](03_Identite_utilisateur_capacites.md) | Arrêté (v2.0) |
| 04 | [Cartographie fonctionnelle](04_Cartographie_fonctionnelle.md) | Arrêté (v2.0) |
| 05 | [Cahier des charges fonctionnel — MVP](05_Cahier_des_charges_MVP.md) | Arrêté (v2.0) |
| 06 | [Paiements : Mobile Money, Visa et séquestre](06_Paiements_Mobile_Money.md) | Arrêté (v2.0) |
| 07 | [Registre des décisions](07_Decisions_a_valider.md) | **Arrêté** (4 points sous réserve externe) |
| 11 | [Live Immo : immobilier et agences](11_Live_Immo.md) | Proposé |

Statuts possibles : *Proposé* → *Arrêté* → *Validé* (après les vérifications externes du document 07, section 7) → *Révisé*.

---

## 3. Hypothèses de cadrage (validées le 24/09/2026)

| Sujet | Décision |
|-------|----------|
| Cœur du produit | Super-app **commerce + social** ; l'éducation devient une verticale |
| Pays de lancement | **République du Congo (Brazzaville)** : FCFA (XAF), zone CEMAC / BEAC |
| Mécanismes de gain | **Vente directe**, **créateurs de contenu**, **prestataires de services** |
| Paiements | **MTN Mobile Money**, **Airtel Money**, puis **Visa** |
| Format du dossier | Markdown versionné dans ce dépôt |
| Affiliation / revendeurs | **Non retenue** pour le moment (peut revenir en phase 3) |
