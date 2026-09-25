# Couverture du prototype

> État au 25 septembre 2026. Ce document compare le prototype Flutter (`app/`) aux maquettes (`docs/ecrans/`) et au cahier des charges du MVP (`docs/05`). Il sert à savoir ce qui reste à dessiner en Flutter avant le test terrain complet, puis à construire pour de vrai.

## 1. Résumé

| Élément | Total | Dans le prototype | Reste |
|---------|-------|-------------------|-------|
| Écrans dessinés en Markdown (`docs/ecrans/`) | 92 | 42 | 50 |
| Exigences fonctionnelles du MVP (`docs/05`) | 98 | 43 simulées, dont 12 partiellement | 55 |

Le prototype a été limité volontairement aux **6 parcours du test terrain** (acheter, vendre, visiter, devis, retirer, Live IA), plus l'inscription. Tout ce qui ne sert pas à ces parcours n'y est pas encore.

Parmi les 55 exigences restantes, 21 relèvent du **serveur** (réconciliation, compression vidéo, classement du fil, modération automatique, anti-fraude, détection de photos réutilisées, journal d'audit…). Elles sont décrites dans `docs/20_Architecture_technique.md` et n'ont pas d'écran propre : un prototype ne peut pas les montrer, seule la construction réelle les réalisera.

## 2. Écrans présents dans le prototype (42)

| Module | Écrans |
|--------|--------|
| Démarrage | E-AUTH-01 Bienvenue, 02 Téléphone, 03 Code SMS, 04 Profil, 06 Code secret |
| Fil | E-FEED-01 Pour toi, 02 Près de moi |
| Explorer | E-EXP-01 Explorer, 03 Résultats |
| Market | E-MKT-02 Fiche produit, 04 Commande, 05 Suivi, 07 Mes ventes, 08 Remise |
| Immo | E-IMMO-01 Accueil, 02 Résultats, 03 Fiche, 04 Créneau et paiement, 05 Ma visite |
| Services | E-SRV-01 Accueil, 03 Demande de devis, 04 Comparer, 05 Détail et acceptation, 07 Suivi |
| Publier | E-PUB-01 Que publier, 03 Vendre un produit |
| Messages | E-CHAT-01 Conversations, 02 Conversation (contre-offre, alerte anti-arnaque) |
| Paiement | E-PAY-01 Moyen, 02 Attente MoMo, 03 Résultat, 04 Mes gains, 05 Retrait |
| Moi | E-MOI-01 Moi |
| Live IA | E-IA-01 Accueil, 02 Crédits, 03 Confirmation, 04 Formulaire (CV, lettre, business plan), 06 Résultat, 07 Exercice photo, 08 Mode apprentissage, 11 Mes documents |

## 3. Écrans pas encore dans le prototype (50)

| Priorité | Module | Écrans | Pourquoi cette priorité |
|----------|--------|--------|-------------------------|
| **1** | Confiance | E-CONF-01 Avis, 02 Signaler, 03 Signaler un problème, 04 Suivi de réclamation | La confiance est la promesse centrale de Live |
| **1** | Côté vendeurs et pros | E-MKT-06 Page boutique, E-IMMO-07 Tableau de bord agence, E-IMMO-08 Valider une visite, E-SRV-02 Profil prestataire, E-SRV-08 Créer un devis, E-SRV-09 Mes interventions | Sans eux, on ne teste que le côté client |
| **1** | Compte | E-MOI-02 Gagner de l'argent, 03 Vérifier mon identité, 04 Créer un espace, 07 Profil public, E-AUTH-08 Connexion | Retrait et badges dépendent de la vérification |
| **2** | Market et Immo | E-MKT-01 Accueil Market, 03 Faire une offre, 09 QR de paiement, E-IMMO-06 Offre de réservation | Complètent les parcours existants |
| **2** | Services | E-SRV-06 Service à prix fixe | Deuxième façon d'acheter un service |
| **2** | Publier | E-PUB-02 Photos et vidéo, 04 Publier un bien, 05 Proposer un service, 06 Envois en cours, 07 Vérification requise | Publier est le geste qui fait vivre l'app |
| **2** | Fil et recherche | E-FEED-03 Commentaires, 04 Partager, 05 Options, E-EXP-02 Saisie, 04 Filtres, 05 Alertes | Le social qui retient les gens |
| **2** | Live IA | E-IA-05 Génération en cours, 09 Assistant business plan | Le business plan existe, sans son assistant en 6 étapes |
| **3** | Divers | E-AUTH-05 Centres d'intérêt, 07 Économie de données, E-CHAT-03 Lieu de rendez-vous, E-PAY-06 Reçu, E-MOI-05 Équipe, 06 Paramètres, E-NOTIF-01 Notifications, 02 Préférences | Utiles, sans effet sur les parcours testés |
| **3** | Live IA | E-IA-10 Tuteur vocal | Prévu en phase 2 |
| **À part** | Back-office | E-ADM-01 à 08 (8 écrans) | Outil interne sur ordinateur, construit avec l'application réelle |

## 4. Exigences du MVP par état

**Simulées dans le prototype (31)** : F-CPT-01, 03 ; F-FEED-01, 03 ; F-CHAT-01, 03, 04, 05 ; F-MKT-03, 04, 05 ; F-IMMO-01, 02, 03, 04 ; F-SRV-04, 07, 08 ; F-PAY-01 à 07 ; F-CONF-06 ; F-IA-01, 02, 03, 05, 09.

**Partielles (12)** : F-CPT-02 (profil sans photo ni intérêts), F-FEED-02 (menu Publier sans l'écran vidéo), F-FEED-04 (compteurs sans panneaux), F-MKT-01 (formulaire simplifié), F-SRV-03 (acompte sans agenda), F-PAY-10 (bouton « Je n'ai rien reçu » seulement), F-PRO-02 (chiffres clés sans statistiques), F-IA-04 (CV et lettre, sans amélioration de CV), F-IA-06 (business plan sans assistant), F-IA-07 (listé, sans écran), F-IA-10 (20 crédits offerts, sans don par un tiers), F-CONF-01 (bouton sans écran d'avis).

**À dessiner dans le prototype (34)** : F-CPT-04 à 10, F-FEED-06, F-RECH-01 à 04, F-CHAT-02, 06, 07, F-MKT-02, 06, F-IMMO-05, 06, 08, F-SRV-01, 02, 05, 06, F-PAY-08, 09, 12, F-CONF-02, 03, F-PRO-01, 03, F-NOTIF-03, F-IA-08, 12.

**Serveur ou back-office uniquement (21)** : F-FEED-05, 07, F-MKT-07, F-IMMO-07, 09, 10, F-PAY-11, F-CONF-04, 05, 07, F-NOTIF-01, 02, F-ADM-01 à 08, F-IA-11.
