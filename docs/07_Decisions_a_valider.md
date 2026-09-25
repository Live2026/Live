# Document 07 — Registre des décisions

Toutes les décisions ci-dessous sont **arrêtées** pour la version 2.0 du dossier. Toute modification se fait par une nouvelle entrée, avec une date.

Statuts : ✅ Décidée · ⚖️ Décidée, **sous réserve** d'une vérification externe (juriste, prestataire, OAPI).

## 1. Cadrage (validé par le promoteur le 24/09/2026)

| N° | Sujet | Décision |
|----|-------|----------|
| D-00a | Identité | Super-app **commerce + social** ; l'éducation devient une verticale (P3) ✅ |
| D-00b | Pays de lancement | **République du Congo (Brazzaville)**, FCFA XAF ✅ |
| D-00c | Mécanismes de gain | Vente directe, créateurs, prestataires ✅ ; affiliation reportée en P3 |
| D-00d | Moyens de paiement | **MTN MoMo, Airtel Money, Visa** ✅ |
| D-00e | Format du dossier | Markdown versionné dans le dépôt ✅ |
| D-00f | Produits propres | **Live IA** payé en **Crédits Live** achetés en Mobile Money ; Live paie les fournisseurs d'IA (précision du promoteur du 24/09/2026) ✅ |

## 2. Produit

| N° | Sujet | Décision | Statut |
|----|-------|----------|--------|
| D-01 | Nom commercial | **« Live »** reste le nom d'usage. On dépose à l'OAPI une **marque semi-figurative** (logo + mot « Live »), plus protégeable qu'un mot générique seul, après une **recherche d'antériorité**. En cas de refus ou de conflit, repli sur **« Live Congo »**. Réserver dès maintenant les noms de domaine et les comptes sur les réseaux sociaux. | ⚖️ |
| D-02 | Villes pilotes | **Brazzaville et Pointe-Noire** simultanément. | ✅ |
| D-03 | Langues | Interface en français au MVP ; **lingala et kituba** en P2. Les contenus des utilisateurs peuvent être dans toutes les langues dès le départ. | ✅ |
| D-04 | Verticales du MVP | **Immobilier + Produits + Services.** Ordre de recrutement terrain : immobilier d'abord (c'est là que les arnaques sont les plus graves et que le séquestre démontre le mieux sa valeur), puis boutiques, puis prestataires. Si le budget impose une coupe, **Services passe en P2**. | ✅ |
| D-05 | Durée des vidéos | **60 s** au MVP, 3 min en P2. | ✅ |
| D-06 | Âge minimal | 13 ans pour consulter et utiliser Live IA avec des crédits offerts ; **18 ans** pour acheter (y compris des crédits), vendre ou être payé. *(Révisé le 24/09/2026 pour Live IA.)* | ✅ |
| D-07 | Contact hors application | Numéro masqué par défaut. Paiement hors application possible mais **non protégé** (avertissement). | ✅ |
| D-08 | Plateformes | **Android + web** au lancement ; iOS dans les 2 mois. | ✅ |

## 3. Économie

| N° | Sujet | Décision | Statut |
|----|-------|----------|--------|
| D-09 | Commissions | Produits **6 %** (minimum 100 FCFA) · Services **8 %** · Frais de visite **15 %** · Réservation immobilière **2 %** plafonnée à 10 000 FCFA · Créateurs **25 %** (P2). **L'acheteur ne paie aucune commission.** Révision possible une fois les tarifs de l'agrégateur connus, à condition que la marge par transaction reste positive. | ⚖️ |
| D-10 | Offre de lancement | **0 % de commission pendant 3 mois** pour les 1 000 premiers vendeurs et prestataires et les 50 premières agences, avec 3 boosts offerts. | ✅ |
| D-13 | Frais de visite | Payés par le visiteur ; la commission Live est prélevée sur la part de l'annonceur. | ✅ |
| D-14 | Fonds Créateurs | Pas de rémunération aux vues avant la P3 (fonds alimenté par la publicité). | ✅ |
| D-24 | Commission sur réservation immobilière | Payée par **l'annonceur** (bailleur ou agence), jamais par le locataire. | ✅ |
| D-25 | Absence au rendez-vous de visite | Visiteur absent : frais versés à l'annonceur. Annonceur absent : visiteur remboursé et pénalité de réputation (F-IMMO-10). | ✅ |
| D-26 | Espace agence | **Gratuit au MVP** (jusqu'à 5 membres) ; abonnement Pro Agence payant à partir de la P2. | ✅ |
| D-27 | Rentabilité du pilote | Le pilote de 6 mois **n'est pas rentable** : il sert à prouver l'usage. Son déficit (dont les frais Mobile Money absorbés pendant l'offre de lancement) est budgété dans le document 31. | ✅ |

## 4. Paiement et conformité

| N° | Sujet | Décision | Statut |
|----|-------|----------|--------|
| D-11 | Partenaire de paiement | Consulter **CinetPay** et **pawaPay** en parallèle. Choix par défaut : **CinetPay** s'il confirme MTN + Airtel + Visa + décaissements au Congo ; sinon **pawaPay** (MTN, Airtel) + un prestataire carte. Passage aux API directes MTN et Airtel au-delà d'environ 100 transactions par jour. *Voir le document 06, section 3.* | ⚖️ |
| D-12 | Visa au MVP | Oui, si l'agrégateur la couvre ; sinon en P2, **sans retarder le lancement**. | ✅ |
| D-15 | Portefeuille avec dépôts libres | **Non au MVP** ; uniquement un « solde vendeur ». Portefeuille complet en P3, avec un partenaire agréé. | ✅ |
| D-16 | Structure juridique | Création d'une **SAS de droit congolais** (forme OHADA la plus souple pour accueillir des investisseurs) via le guichet unique de création d'entreprises (ACPCE), avec RCCM et NIU ; compte professionnel et **compte séquestre** dans une banque partenaire ; mandat à un **cabinet d'avocats** en réglementation bancaire CEMAC et en protection des données **avant tout encaissement réel**. | ⚖️ |

## 5. Technique (détaillé dans le document 20)

| N° | Sujet | Décision | Statut |
|----|-------|----------|--------|
| D-17 | Application mobile | **Flutter** (Android puis iOS), choix du promoteur du 24/09/2026 ; remplace React Native. Voir DT-01. | ✅ |
| D-18 | Web et back-office | Back-office en **Flutter Web** ; pages de partage publiques générées par une Edge Function ; site web public consultable à décider en P2. Voir DT-01 et DT-03. | ✅ |
| D-19 | Backend et base de données | **PostgreSQL** via **Supabase** au démarrage (authentification, stockage, temps réel) + logique financière dans des **fonctions PostgreSQL** (schéma `pay` non exposé) et des **Edge Functions** pour les webhooks, jamais côté client (DT-02, DT-04). **Monolithe modulaire**, pas de micro-services au MVP. | ✅ |
| D-20 | Vidéo | **Cloudflare Stream** au MVP, derrière une interface interne ; compression sur l'appareil, 360p par défaut sur données mobiles ; réévaluation à 1 million de minutes diffusées par mois (DT-05, DT-06). | ✅ |
| D-21 | Hébergement | Région cloud la plus proche de l'Afrique centrale + CDN ; **mesure de la latence réelle depuis Brazzaville et Pointe-Noire** avant le choix définitif. | ✅ |

## 5 bis. Décisions des spécifications de module

| Réf. | Document | Résumé |
|------|----------|--------|
| DT-01 à DT-11 | [20 — Architecture technique](20_Architecture_technique.md) | Flutter (mobile + back-office web), Supabase, grand livre en PostgreSQL, Cloudflare Stream, recherche PostgreSQL, SMS local, dépôt unique avec CI |
| DI-A-01 à DI-A-06 | [19 — Live IA et Crédits Live](19_Live_IA_et_credits.md) | Live IA au MVP, 1 crédit = 10 FCFA, pack minimum 500 FCFA, prix fixe par service, recrédit en cas d'échec, crédits non convertibles en argent, onglet « IA » dans la navigation |
| DI-01 à DI-06 | [11 — Live Immo](11_Live_Immo.md) | Frais de visite et acompte seuls au MVP, coordonnées révélées après engagement, carte floutée, aucun prix de vente via Live avant la P3 |
| DS-01 à DS-06 | [12 — Live Services](12_Live_Services.md) | Trois schémas de paiement, 10 métiers prioritaires, demande publique de devis, déblocage encadré du matériel, garantie de 24 h ou 72 h, santé, juridique et garde d'enfants exclus |
| DM-01 à DM-06 | [10 — Live Market](10_Live_Market.md) | Payer maintenant **et** payer à la remise via Mobile Money, livraison par le vendeur au MVP, avis réservés aux ventes payées, commission sur le total livraison comprise |

## 6. Organisation

| N° | Sujet | Décision | Statut |
|----|-------|----------|--------|
| D-22 | Équipe minimale | 1 chef de produit, 3–4 développeurs, 1 designer, 2–3 personnes (modération, KYC, support), 2–3 commerciaux terrain. | ✅ |
| D-23 | Stratégie de lancement | **Recruter l'offre avant la demande** : 3 mois de recrutement terrain, puis lancement public avec des créateurs locaux. | ✅ |

## 7. Actions externes à lancer (ce qui dépend du promoteur)

| # | Action | Liée à |
|---|--------|--------|
| 1 | Recherche d'antériorité et dépôt de marque à l'OAPI ; réservation des noms de domaine | D-01 |
| 2 | Création de la SAS (ACPCE), obtention du RCCM et du NIU | D-16 |
| 3 | Choix d'un cabinet d'avocats (réglementation CEMAC, données personnelles) | D-16 |
| 4 | Demandes de devis et de contrat à CinetPay et pawaPay (questions précises : Visa au Congo, décaissements, frais, séquestre) | D-11 |
| 5 | Rendez-vous avec 2 banques pour le compte séquestre | D-16 |

## 8. Revue de cohérence du 24/09/2026 : corrections apportées

| # | Incohérence relevée | Correction |
|---|---------------------|------------|
| 1 | Doc 03 : C-ENCAISSER exigeait N2, alors que N1 prévoit un encaissement plafonné (doc 03 §4, doc 06 §7). | C-ENCAISSER est permis en N1, plafonné à 100 000 FCFA par mois et sans retrait. |
| 2 | L'espace agence exigeait l'abonnement Pro Agence (doc 03), alors que les abonnements arrivent en P2 (doc 04) et que le parcours « agence » fait partie du MVP (doc 05). | Espace agence gratuit au MVP (D-26) ; F-CPT-07 et F-IMMO-08 passent en priorité **M**. |
| 3 | Payeur de la commission sur réservation immobilière « à décider ». | Payée par l'annonceur (D-24). |
| 4 | Absence au rendez-vous de visite non traitée. | Règle F-IMMO-10 (D-25). |
| 5 | Objectifs du pilote inférieurs au point mort, sans que ce soit dit. | Déficit du pilote assumé et budgété (D-27). |
| 6 | D-04 et D-17 laissaient deux options ouvertes. | Une seule option retenue. |
| 7 | D-11 renvoyait à une recherche à faire. | Liste courte et règle de choix (doc 06 §3). |

## 9. Revue du 25/09/2026 : ajouts au prototype

| # | Point | Traitement |
|---|-------|------------|
| 1 | Distinguer ce qui se paie dans Live de ce qui se paie ailleurs (loyers, caution, prix d'un bien). | Étiquettes « Payé dans Live », « À la remise », « En direct » (doc 06 §4.4). Aucune nouvelle règle : mode B du doc 10, entrée complète en P2 (doc 11). |
| 2 | Objets à voir avant d'acheter (téléphone d'occasion…). | Mode B « payer à la remise » : réservation sans paiement, paiement MoMo via Live au rendez-vous. **Pas d'option espèces** (doc 10 §3.6 : Live numérise les espèces). |
| 3 | Live Savoir, Live Emploi (P3), groupes et canaux (P2) montrés au prototype. | Écrans d'**aperçu**, étiquetés « phase 2 » ou « phase 3 », accessibles depuis Explorer ; hors du périmètre du MVP (doc 05 §7). |
| 4 | Commission sur les contenus numériques (aperçu Live Savoir). | **Hypothèse à valider** : 15 % (le créateur garde 85 %). À trancher avec D-09 avant la phase 3. |
| 5 | Prix des modules des phases 2 et 3 montrés au prototype. | **Hypothèses à valider** : frais de service des séjours 5 % ; Pro Vendeur 5 000, Pro Agence 15 000, Pro Prestataire 4 000 FCFA / mois ; course Live Livraison 1 500 FCFA ; abonnements de fans 500 et 1 500 FCFA. Cadeaux et abonnements de fans : 25 % pour Live, conforme à D-09. |

**Fin du Document 07**
