# Couverture du prototype

> État au 25 septembre 2026 (mis à jour en fin de journée). Ce document compare le prototype Flutter (`app/`) aux maquettes (`docs/ecrans/`) et au cahier des charges du MVP (`docs/05`).

## 1. Résumé

| Élément | Total | Dans le prototype |
|---------|-------|-------------------|
| Écrans dessinés en Markdown (`docs/ecrans/`) | 92 | **92** (89 adresses, certains écrans sont des panneaux) |
| Exigences fonctionnelles du MVP (`docs/05`) | 98 | **77 visibles** (simulées) · 21 côté serveur |

Chaque écran s'ouvre dans le prototype, sur téléphone (320 et 360 px) et sur ordinateur (1280 px) : le test `app/test/ecrans_test.dart` les ouvre tous et échoue au moindre débordement ou à la moindre erreur. Le test de bout en bout `app/test_e2e/parcours.js` déroule les 6 parcours puis capture tous les écrans.

Les **21 exigences serveur** (réconciliation automatique, compression vidéo, classement du fil, modération automatique, anti-fraude, détection de photos réutilisées, journal d'audit…) n'ont pas d'écran propre. Leur **résultat** est montré dans le back-office (réconciliation, file de modération, retraits suspects, journal d'audit) ; leur mécanique est décrite dans `docs/20_Architecture_technique.md` et sera réalisée lors de la construction réelle.

## 2. Écrans par module

| Module | Écrans dans le prototype |
|--------|--------------------------|
| Démarrage (8) | E-AUTH-01 Bienvenue, 02 Téléphone, 03 Code SMS, 04 Profil, 05 Centres d'intérêt, 06 Code secret, 07 Économie de données, 08 Connexion |
| Fil (5) | E-FEED-01 Pour toi (façon TikTok), 02 Près de moi, 03 Commentaires, 04 Partager, 05 Options |
| Explorer (5) | E-EXP-01 Explorer, 02 Recherche (suggestions), 03 Résultats par espace, 04 Filtres, 05 Mes alertes |
| Market (11) | E-MKT-01 Accueil (carrousel, vendeurs à la une, commandes, paiements, aide), 02 Fiche produit, 03 Faire une offre, 04 Commande (payer maintenant, ou réservation « voir puis payer à la remise »), 05 Suivi, 06 Page boutique, 07 Mes ventes, 08 Remise, 09 QR de paiement, 10 Liste triable, 11 Mes commandes |
| Immo (8) | E-IMMO-01 Accueil (louer, acheter, catégories, à la une, agences, visites vidéo), 02 Résultats, 03 Fiche, 04 Créneau, 05 Ma visite, 06 Offre de réservation, 07 Tableau de bord agence, 08 Valider une visite |
| Services (9) | E-SRV-01 Accueil, 02 Profil prestataire, 03 Demande de devis, 04 Comparer, 05 Détail, 06 Prix fixe, 07 Suivi, 08 Créer un devis, 09 Mes interventions |
| Publier (7) | E-PUB-01 Que publier, 02 Vidéo, 03 Produit, 04 Bien en 5 étapes, 05 Service, 06 Envois en cours, 07 Vérification requise |
| Messages (6) | E-CHAT-01 Conversations (façon WhatsApp), 02 Conversation (vocal, offre, alerte anti-arnaque), 03 Lieu de rendez-vous, Demandes de messages (arnaque signalée), Archivées, Réglages (qui peut m'écrire, lecture, Wi-Fi) |
| Paiement (6) | E-PAY-01 Moyen, 02 Attente MoMo, 03 Résultat, 04 Gains, 05 Retrait, 06 Reçu |
| Moi (10) | E-MOI-01 Moi, 02 Super-pouvoirs, 03 Vérifier mon identité, 04 Créer un espace, 05 Équipe, 06 Paramètres, 07 Profil public, Abonnés et abonnements (filtres par type), Enregistrés, Ce qui se paie dans Live |
| Confiance (4) | E-CONF-01 Avis, 02 Signaler, 03 Signaler un problème, 04 Suivi de réclamation |
| Notifications (2) | E-NOTIF-01 Centre, 02 Préférences |
| Live IA (11) | E-IA-01 Accueil, 02 Crédits, 03 Confirmation du prix, 04 Formulaire, 05 Génération en cours, 06 Document, 07 Exercice photo, 08 Mode apprentissage, 09 Business plan en 6 étapes, 10 Tuteur vocal, 11 Mes documents |
| Back-office (8) | E-ADM-01 Tableau de bord, 02 File KYC, 03 Dossier KYC, 04 Modération, 05 Litiges et décision, 06 Finance et réconciliation, 07 Utilisateurs et fiche, 08 Configuration |

## 2 bis. Où se paie chaque somme

Chaque fiche porte un bloc « Comment ça se paie » (document 06, §4.4) : **Payé dans Live** (séquestre), **À la remise** (mode B : voir l'objet, puis payer MoMo via Live) ou **En direct** (loyers, caution, prix d'un bien, contre reçu). Le paiement accepte aussi le **solde Live**.

## 2 ter. Toute l'application rassemblée

Depuis le 25/09/2026 (document 07, §10), le prototype montre **toute l'application**, sans bandeau de phase : chaque espace est rangé à sa place naturelle. Les phases du document 04 restent l'**ordre de construction et de lancement**, pas une limite du prototype.

| Espace | Écrans | Où on le trouve |
|--------|--------|-----------------|
| Live Direct | Directs en cours et à venir (rappel), lecteur plein écran (commentaires, cœurs, cadeaux, produit épinglé payable dans Live, visite immobilière en direct), lancer un direct (C-DIRECT) | Pastille « EN DIRECT » du fil, Explorer, Immo (visites en direct), Moi, menu du profil |
| Live Créateurs | Studio (statistiques, outils, progression vers 500 abonnés), page fans (Fan 500 FCFA, Super fan 1 500 FCFA), Fonds Créateurs | Moi → Créer et gagner, menu du profil, Explorer → Outils |
| Groupes et canaux | Groupe (épinglé, PDF, réactions), canal | Messages → Nouveau groupe, Explorer → Outils |
| Séjours meublés | Liste, réservation à la nuit payée dans Live | Explorer (espace Séjours), accueil Immo |
| Live Savoir | Accueil, fiche, panier, mes achats, lecteur, vendre, boutique de savoirs | Explorer (espace Savoir et section « Apprendre ») |
| Live Emploi | Liste, fiche aux coûts transparents, postuler, candidatures, publier | Explorer (espace Emploi et « Opportunités à saisir ») |
| Live Livraison | Suivi du livreur sur le plan de la ville, code de remise | Suivi de commande, Explorer → Outils |
| Live Plus, Publicité, Offres Pro | Formules de crédits, campagne ciblée, offres Vendeur, Agence, Prestataire, Entreprise | Moi → Créer et gagner, menu du profil |
| Services financiers | Paiement en 3 fois, tirelire, micro-crédit vendeur (établissements agréés) | Moi, menu du profil, Explorer → Outils |
| API partenaires | Catalogue, commandes, Live Pay et séquestre, livraison, vérification ; clés test et production, webhook | Menu du profil, offre Entreprise |
| Extension CEMAC | Pays et ville : Congo, Gabon, Cameroun, Tchad, Centrafrique, Guinée équatoriale ; toujours en FCFA | Paramètres → Pays et ville |

## 2 quater. Piliers « référence » (document 21)

| Pilier | Écrans |
|--------|--------|
| Live IA partout | Photo vers annonce (Vendre, étape 1), juste prix (Vendre, fiche produit, fiche logement), Assistant Live `/ia/assistant` (écrit et voix, trois langues), coach vendeur (Mes ventes) |
| Tontines | `/tontines` (mes tontines, créer), `/tontine/:id` (cagnotte, ordre des tours, cotiser, historique), `/achats-groupes` |
| Diaspora | `/diaspora` (proches, que payer, mes envois), `/transfert` (Live Transfert, taux fixe euro) |
| Quotidien | `/factures` (factures, crédit), `/adresse` (Adresse Live), `/points-relais` |
| Cartes | `CarteInteractive` (plan, satellite, ma position, vue rue) sur la carte des biens et des pros, le suivi de livraison, l'Adresse Live et les points relais ; `/rue` (vue rue) |
| Back-office | Connexion 2FA, Équipe Live (Super administrateur), double validation, journal d'audit |

## 3. Super-pouvoirs (capacités du document 03)

Tout le monde commence comme simple utilisateur (N1, téléphone vérifié). Le prototype montre la montée en puissance :

| Pouvoir | Débloqué par | Écran |
|---------|--------------|-------|
| Acheter protégé, publier des vidéos, vendre (3 annonces), Live IA | Inscription | Moi → Mes super-pouvoirs |
| Retirer ses gains, proposer ses services, louer ou vendre un bien, créateur | Vérification d'identité (N2) | Vérifier mon identité |
| Agence ou boutique (équipe, tableau de bord, badge) | Espace pro vérifié (N3) | Créer un espace |
| Live Pro (statistiques, boosts −30 %) | Abonnement 5 000 FCFA / mois | Live Pro |

Une fonction réservée ne montre jamais d'erreur : elle explique le pouvoir manquant et mène à l'écran qui le débloque (E-PUB-07).

## 4. Ce qui reste simulé ou partiel

- **Plus aucun point partiel au MVP** (contrôle du 25/09/2026, exigence par exigence du document 05) : variantes et stock au moment d'acheter (F-MKT-06), carte des biens et des prestataires sur un plan de Brazzaville (F-RECH-04), recherche corrigée « Résultats pour… » (F-RECH-01), blocage depuis une conversation (F-CHAT-06), objets interdits refusés à la publication (F-MKT-07), absence au rendez-vous de visite des deux côtés (F-IMMO-10), « Je n'ai rien reçu » avec nouvelle demande et sans double débit (F-PAY-10), suppression du compte après retrait des gains (F-CPT-10), dupliquer une annonce (F-MKT-DASH-04).
- **Aucun bouton inactif** : chaque action ouvre un écran, un panneau ou une confirmation (paramètres, codes, appareils, langue, aide, données, conditions).

- Paiements, scans de QR, génération IA, envoi de SMS, vérification d'identité : **simulés** (boutons « Simuler » discrets, étiquetés).
- Photos et vidéos : remplacées par des dégradés et des icônes.
- Données : fictives (`app/lib/data/donnees_*.dart`), perdues au redémarrage.
