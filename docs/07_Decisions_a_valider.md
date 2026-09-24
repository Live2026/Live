# Document 07 — Registre des décisions

Chaque décision porte une **recommandation**. Sans objection du promoteur, **la recommandation s'applique** et le dossier est rédigé en conséquence. Pour la changer, il suffit d'indiquer le numéro de la décision et le nouveau choix.

Statuts : ✅ Validée · 🟡 Recommandée (s'applique par défaut) · 🔴 À trancher impérativement par le promoteur.

## 1. Décisions déjà validées

| N° | Sujet | Décision |
|----|-------|----------|
| D-00a | Identité | Super-app **commerce + social** ; l'éducation devient une verticale (P3) ✅ |
| D-00b | Pays de lancement | **République du Congo (Brazzaville)**, FCFA XAF ✅ |
| D-00c | Mécanismes de gain | Vente directe, créateurs, prestataires ✅ ; affiliation non retenue pour l'instant |
| D-00d | Moyens de paiement | **MTN MoMo, Airtel Money, Visa** ✅ |
| D-00e | Format du dossier | Markdown versionné dans le dépôt ✅ |

## 2. Produit

| N° | Sujet | Recommandation | Statut |
|----|-------|----------------|--------|
| D-01 | Nom commercial | Conserver **« Live »** comme marque, avec des noms de modules en français (Live Market, Live Immo…). Vérifier au préalable la disponibilité de la marque (OAPI) et des noms de domaine, car « Live » est un terme générique difficile à protéger ; un nom plus distinctif (ex. « Live Congo », « LiveCG ») est à envisager. | 🔴 |
| D-02 | Villes pilotes | **Brazzaville et Pointe-Noire** simultanément. | 🟡 |
| D-03 | Langues | Français au MVP, **lingala et kituba** en P2. | 🟡 |
| D-04 | Verticales du MVP | **Produits + Immobilier + Services**. Si les moyens sont limités, commencer par **Immobilier + Produits**, où l'arnaque est la plus forte et la valeur du séquestre la plus visible. | 🟡 |
| D-05 | Durée maximale des vidéos au MVP | **60 secondes** (maîtrise des coûts), 3 minutes en P2. | 🟡 |
| D-06 | Âge minimal | 13 ans pour consulter, **18 ans** pour acheter, vendre ou être payé. | 🟡 |
| D-07 | Contact hors application | Numéro de téléphone **masqué par défaut** ; l'annonceur peut choisir de l'afficher. Paiement hors application autorisé mais **non protégé**, avec un avertissement. | 🟡 |
| D-08 | Plateformes | **Android d'abord** + web ; iOS dans les 2 mois suivant le lancement. | 🟡 |

## 3. Économie

| N° | Sujet | Recommandation | Statut |
|----|-------|----------------|--------|
| D-09 | Commissions | Produits 6 %, services 8 %, frais de visite 15 %, réservation immobilière 2 % plafonnée ; créateurs 25 %. À confirmer après les devis des agrégateurs. | 🔴 |
| D-10 | Offre de lancement | **0 % de commission pendant 3 mois** pour les 1 000 premiers vendeurs et les 50 premières agences, boosts offerts. | 🟡 |
| D-13 | Qui paie les frais de visite ? | Le visiteur paie les frais ; Live prélève sa commission sur la part de l'annonceur. | 🟡 |
| D-14 | Fonds Créateurs | **Pas de rémunération aux vues avant la phase 3** (le fonds sera alimenté par la publicité). | 🟡 |

## 4. Paiement et conformité

| N° | Sujet | Recommandation | Statut |
|----|-------|----------------|--------|
| D-11 | Partenaire de paiement | **Un agrégateur agréé** couvrant MTN, Airtel et Visa au Congo pour le MVP, avec une couche d'abstraction permettant d'ajouter plus tard les API directes. | 🔴 |
| D-12 | Visa au MVP | Oui, **si** l'agrégateur la couvre ; sinon en P2, sans retarder le lancement. | 🟡 |
| D-15 | Portefeuille avec dépôts libres | **Non au MVP** (réglementation) ; uniquement un « solde vendeur ». Portefeuille complet avec un partenaire agréé en phase 3. | 🟡 |
| D-16 | Structure juridique | Créer ou utiliser une **société de droit congolais** (RCCM, NIU), ouvrir un compte bancaire professionnel et engager un **conseil juridique** en réglementation CEMAC et données personnelles. | 🔴 |

## 5. Technique (détaillé dans le document 20)

| N° | Sujet | Recommandation | Statut |
|----|-------|----------------|--------|
| D-17 | Application mobile | **Flutter** ou **React Native (Expo)**, avec **un seul code** pour Android et iOS. Préférence pour **React Native + TypeScript**, afin de partager le langage avec le web et le back-office. | 🟡 |
| D-18 | Web et back-office | **Next.js (TypeScript)**. | 🟡 |
| D-19 | Backend et base de données | **PostgreSQL** (via Supabase au démarrage : authentification, stockage, temps réel) + services **TypeScript** dédiés pour le paiement et le grand livre. Architecture en **monolithe modulaire** (pas de micro-services au MVP). | 🟡 |
| D-20 | Vidéo | Service géré d'encodage et de diffusion (type Mux, Cloudflare Stream ou équivalent) : ne pas construire l'encodage vidéo en interne. | 🟡 |
| D-21 | Hébergement | Cloud avec un point de présence proche de l'Afrique centrale, CDN obligatoire ; mesurer la latence réelle depuis Brazzaville. | 🟡 |

## 6. Organisation

| N° | Sujet | Recommandation | Statut |
|----|-------|----------------|--------|
| D-22 | Équipe minimale du MVP | 1 chef de produit, 3–4 développeurs (mobile, web, backend et paiement), 1 designer, 2–3 personnes pour la modération, le KYC et le support, 2–3 commerciaux terrain pour recruter les agences et les vendeurs. | 🟡 |
| D-23 | Stratégie de lancement | **Recruter l'offre avant la demande** : 3 mois de recrutement terrain (agences, boutiques, prestataires) avant le lancement public, puis une campagne auprès des acheteurs avec des créateurs locaux. | 🟡 |

**Fin du Document 07**
