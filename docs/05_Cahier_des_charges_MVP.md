# Document 05 — Cahier des charges fonctionnel du MVP

## 1. Objet et périmètre

Ce document décrit **exactement** ce que la première version publique de Live doit faire. Il s'adresse à l'équipe de développement, aux prestataires et aux investisseurs.

- **Zone** : Brazzaville et Pointe-Noire (République du Congo)
- **Langue de l'interface** : français (lingala et kituba en P2)
- **Monnaie** : FCFA (XAF)
- **Plateformes** : application **Android** (prioritaire), application web responsive (consultation, publication et back-office), **iOS** juste après
- **Paiements** : MTN Mobile Money, Airtel Money, carte Visa

**Objectif du MVP** : démontrer qu'**un vendeur, une agence ou un prestataire gagne plus, et plus sûrement, sur Live que sur Facebook**, et qu'un acheteur préfère payer via Live.

Priorités : **M** = indispensable, **S** = souhaité dans le MVP si possible, **C** = facultatif.

---

## 2. Acteurs du MVP

| Acteur | Description |
|--------|-------------|
| Visiteur | Non connecté ; consulte uniquement. |
| Utilisateur | Connecté ; achète, discute, publie dans le fil. |
| Vendeur | Utilisateur disposant de C-VENDRE, avec ou sans boutique. |
| Agence / bailleur / commissionnaire | Publie des biens immobiliers et encaisse des frais de visite ou des réservations. |
| Prestataire | Propose des services et prend des réservations. |
| Agent Live | Membre de l'équipe : modération, KYC, litiges, support, finance. |
| Super Administrateur | Contrôle global. |

---

## 3. Exigences fonctionnelles

### 3.1 Compte (CPT)

| ID | Exigence | Prio |
|----|----------|------|
| F-CPT-01 | Inscription et connexion par numéro de téléphone congolais et OTP par SMS. | M |
| F-CPT-02 | Profil : photo, nom, ville, quartier, bio, centres d'intérêt. | M |
| F-CPT-03 | PIN de l'application et PIN de paiement distinct. | M |
| F-CPT-04 | Vérification d'identité N2 : photo de la pièce d'identité + selfie, validation manuelle dans le back-office (automatisation en P2). | M |
| F-CPT-05 | Vérification professionnelle N3 : RCCM, NIU, justificatif d'adresse, pour les agences et les entreprises. | M |
| F-CPT-06 | Création d'espaces : boutique, agence, prestataire. | M |
| F-CPT-07 | Ajout de membres à un espace avec rôles internes (propriétaire, gestionnaire, agent), jusqu'à 5 membres au MVP. | M |
| F-CPT-08 | Suivre un utilisateur ou un espace. | M |
| F-CPT-09 | Parrainage avec lien et bonus après la première transaction du filleul. | S |
| F-CPT-10 | Suppression du compte à la demande de l'utilisateur. | M |

### 3.2 Fil et publications (FEED)

| ID | Exigence | Prio |
|----|----------|------|
| F-FEED-01 | Fil vertical de vidéos (≤ 60 s au MVP) et de photos, avec les onglets « Pour toi », « Près de moi » et « Abonnements ». | M |
| F-FEED-02 | Publication d'une vidéo ou de photos avec texte, **liée ou non** à une annonce (produit, bien, service). | M |
| F-FEED-03 | Bouton d'action contextuel sur une publication liée : « Acheter », « Visiter » ou « Réserver ». | M |
| F-FEED-04 | Likes, commentaires, partages, sauvegardes. | M |
| F-FEED-05 | Compression côté serveur et lecture adaptative selon le débit ; mode « économie de données ». | M |
| F-FEED-06 | Partage externe (WhatsApp, Facebook, SMS) par lien profond avec aperçu (image, prix, titre). | M |
| F-FEED-07 | Classement du fil : proximité, intérêts, fraîcheur, réputation du vendeur, boosts (identifiés comme « Sponsorisé »). | M |

### 3.3 Recherche (RECH)

| ID | Exigence | Prio |
|----|----------|------|
| F-RECH-01 | Recherche plein texte tolérante aux fautes d'orthographe. | M |
| F-RECH-02 | Filtres communs (catégorie, prix, ville, quartier) et filtres propres à chaque verticale. | M |
| F-RECH-03 | Recherches sauvegardées avec notification des nouveaux résultats. | M |
| F-RECH-04 | Carte des biens et des prestataires. | S |

### 3.4 Messagerie (CHAT)

| ID | Exigence | Prio |
|----|----------|------|
| F-CHAT-01 | Conversation un à un, rattachée à une annonce (la carte de l'annonce est affichée en haut). | M |
| F-CHAT-02 | Texte, photos et notes vocales. | M |
| F-CHAT-03 | Proposition de prix : l'acheteur propose, le vendeur accepte ou refuse ; une offre acceptée crée un lien de paiement. | M |
| F-CHAT-04 | Bouton « Payer en sécurité » dans la conversation. | M |
| F-CHAT-05 | Avertissement automatique en cas de tentative de paiement hors application (numéro, « envoie par MoMo »). | M |
| F-CHAT-06 | Blocage et signalement d'un interlocuteur. | M |
| F-CHAT-07 | Réponses rapides pour les vendeurs. | C |

### 3.5 Live Market — produits (MKT)

| ID | Exigence | Prio |
|----|----------|------|
| F-MKT-01 | Création d'une annonce : titre, catégorie, photos (≤ 10), vidéo, prix, état, quantité, lieu, options de remise (en main propre ou livraison par le vendeur, avec son prix). | M |
| F-MKT-02 | Boutique : page publique, catalogue, avis, abonnés, bouton de contact. | M |
| F-MKT-03 | Commande avec séquestre (voir 3.8). | M |
| F-MKT-04 | Suivi de commande : payée, en préparation, remise ou expédiée, reçue, terminée, en litige. | M |
| F-MKT-05 | Remise en main propre confirmée par un **code à 4 chiffres** donné par l'acheteur. | M |
| F-MKT-06 | Variantes (taille, couleur) et stock simple. | S |
| F-MKT-07 | Liste de catégories interdites appliquée à la publication (armes, médicaments, faux documents…). | M |

### 3.6 Live Immo — immobilier (IMMO)

| ID | Exigence | Prio |
|----|----------|------|
| F-IMMO-01 | Fiche de bien structurée : type, location ou vente, quartier, prix, avance ou caution (en mois), chambres, salles d'eau, eau (SNDE ou forage), électricité, parking, meublé, photos et vidéo obligatoires. | M |
| F-IMMO-02 | Statut de l'annonceur visible : Particulier vérifié, Commissionnaire vérifié ou Agence vérifiée. | M |
| F-IMMO-03 | **Frais de visite** fixés par l'annonceur, payés dans Live, **séquestrés** et versés après la visite confirmée (code), remboursés si la visite n'a pas lieu du fait de l'annonceur. | M |
| F-IMMO-04 | Prise de rendez-vous de visite (créneaux proposés par l'annonceur). | M |
| F-IMMO-05 | **Réservation séquestrée** d'un bien (acompte), avec des conditions d'annulation affichées. | S |
| F-IMMO-06 | Bouton « Déjà loué » ou « Annonce fausse » ; une annonce signalée plusieurs fois passe en revue. | M |
| F-IMMO-07 | Mise à jour obligatoire : une annonce non confirmée depuis 30 jours est masquée. | M |
| F-IMMO-08 | Espace agence : plusieurs agents, tableau des demandes et des visites. | M |
| F-IMMO-09 | Détection de photos déjà utilisées dans une autre annonce. | S |
| F-IMMO-10 | Absence du visiteur au rendez-vous : les frais de visite sont versés à l'annonceur. Absence de l'annonceur : remboursement intégral du visiteur et pénalité de réputation pour l'annonceur. | M |

### 3.7 Live Services — prestataires (SRV)

| ID | Exigence | Prio |
|----|----------|------|
| F-SRV-01 | Fiche de service : catégorie, description, prix fixe ou « sur devis », zone d'intervention, portfolio (photos et vidéos). | M |
| F-SRV-02 | Demande de devis par messagerie, devis envoyé sous forme de carte payable. | M |
| F-SRV-03 | Réservation d'un créneau avec **acompte séquestré** (pourcentage choisi par le prestataire). | M |
| F-SRV-04 | Confirmation de fin de prestation par le client (code ou bouton), puis versement. | M |
| F-SRV-05 | Avis après la prestation. | M |
| F-SRV-06 | Agenda de disponibilités. | S |

### 3.8 Live Pay — paiement (PAY)

| ID | Exigence | Prio |
|----|----------|------|
| F-PAY-01 | Paiement par **MTN MoMo** (demande de paiement envoyée au téléphone, validation par le code secret MoMo du client). | M |
| F-PAY-02 | Paiement par **Airtel Money** (même principe). | M |
| F-PAY-03 | Paiement par **carte Visa** (page sécurisée 3-D Secure de l'agrégateur ; **aucune donnée de carte stockée par Live**). | M* |
| F-PAY-04 | **Séquestre** : les fonds sont bloqués jusqu'à confirmation, délai expiré sans litige, ou décision de litige. | M |
| F-PAY-05 | **Solde vendeur** : montants « en attente » et « disponibles », historique détaillé et reçus. | M |
| F-PAY-06 | **Retrait** vers un numéro MTN ou Airtel au nom du titulaire vérifié (N2), avec seuil minimal et plafonds. | M |
| F-PAY-07 | Commission calculée et affichée avant la mise en ligne (pour le vendeur) et au paiement. | M |
| F-PAY-08 | Remboursement total ou partiel vers le moyen de paiement d'origine. | M |
| F-PAY-09 | Paiement des **boosts** directement par Mobile Money. | M |
| F-PAY-10 | Gestion des échecs : délai d'expiration, nouvelle tentative, statut « en attente de confirmation de l'opérateur », **aucun double débit**. | M |
| F-PAY-11 | Réconciliation quotidienne automatique avec les relevés de l'agrégateur ou des opérateurs. | M |

\* *Visa : obligatoire au MVP si l'agrégateur retenu la couvre au Congo ; sinon, livrée en P2 sans bloquer le lancement (voir D-12).*

### 3.9 Live Confiance (CONF)

| ID | Exigence | Prio |
|----|----------|------|
| F-CONF-01 | Avis de 1 à 5 étoiles avec commentaire, **uniquement après une transaction payée** dans Live. | M |
| F-CONF-02 | Signalement de tout contenu, profil ou message, avec motifs prédéfinis. | M |
| F-CONF-03 | Ouverture d'un **litige** pendant le délai de confirmation, avec échange de preuves. | M |
| F-CONF-04 | File de litiges dans le back-office ; décision tracée (remboursement total ou partiel, libération). | M |
| F-CONF-05 | Modération automatique à la publication (nudité, violence, mots interdits) avant la mise en ligne publique. | M |
| F-CONF-06 | Badges : Identité vérifiée, Pro vérifié, Agence vérifiée. | M |
| F-CONF-07 | Règles anti-fraude de base : un compte par téléphone, empreinte d'appareil, limite de nouveaux comptes par appareil, interdiction d'acheter à soi-même, vitesse de transactions anormale. | M |

### 3.10 Live Pro — boosts (PRO)

| ID | Exigence | Prio |
|----|----------|------|
| F-PRO-01 | Achat d'un boost (24 h, 3 j, 7 j) pour une annonce, ciblé par ville. | M |
| F-PRO-02 | Statistiques de base pour le vendeur : vues, contacts, ventes. | M |
| F-PRO-03 | Abonnement Pro (paiement mensuel par Mobile Money). | S |

### 3.11 Notifications (NOTIF)

| ID | Exigence | Prio |
|----|----------|------|
| F-NOTIF-01 | Push : nouveau message, commande, paiement reçu, visite confirmée, alerte de recherche. | M |
| F-NOTIF-02 | SMS : OTP, paiement reçu, retrait effectué, litige ouvert. | M |
| F-NOTIF-03 | Préférences de notification par type. | S |

### 3.12 Back-office (ADM)

| ID | Exigence | Prio |
|----|----------|------|
| F-ADM-01 | Authentification forte des agents (2FA), permissions par fonction. | M |
| F-ADM-02 | Files de travail : KYC, modération, signalements, litiges, retraits suspects. | M |
| F-ADM-03 | Gestion des utilisateurs : consultation, suspension d'une capacité, gel des fonds, bannissement. | M |
| F-ADM-04 | Configuration : catégories, villes et quartiers, commissions, plafonds, prix des boosts. | M |
| F-ADM-05 | Finance : transactions, séquestres, soldes, retraits, rapport de réconciliation, export comptable. | M |
| F-ADM-06 | Double validation des actions sensibles (remboursement au-delà d'un seuil, modification de commission). | M |
| F-ADM-07 | Journal d'audit consultable et non modifiable. | M |
| F-ADM-08 | Tableau de bord des indicateurs (voir section 6). | M |

---

## 4. Parcours clés à livrer de bout en bout

1. **« Je vends mon téléphone »** : inscription, publication (photos et vidéo), message d'un acheteur, proposition de prix, paiement MoMo séquestré, remise en main propre avec code, fonds disponibles, retrait vers MoMo.
2. **« Je cherche un appartement à Moungali »** : recherche avec filtres, alerte sauvegardée, notification, paiement des frais de visite (Airtel), rendez-vous, visite confirmée par code, réservation séquestrée.
3. **« Je suis électricien »** : activation de C-SERVICES, vérification, fiche de service, demande de devis, devis payable, acompte séquestré, prestation confirmée, avis.
4. **« L'agence Les Palmiers s'installe »** : vérification professionnelle, espace agence, ajout de 3 agents, publication de 20 biens, boosts.
5. **« J'ai un problème »** : ouverture d'un litige, échange de preuves, décision d'un agent, remboursement.

---

## 5. Exigences non fonctionnelles

| ID | Exigence |
|----|----------|
| NF-01 | Fonctionnement sur Android 8 ou supérieur, avec 2 Go de RAM ; application de moins de 30 Mo. |
| NF-02 | Premier écran utile en moins de 3 s en 3G ; vidéos en qualité adaptative (240p à 720p). |
| NF-03 | Tolérance aux coupures : brouillons d'annonces conservés hors ligne, envoi repris après une coupure. |
| NF-04 | Disponibilité de 99,5 % pour le service de paiement ; file d'attente et reprise en cas d'indisponibilité d'un opérateur. |
| NF-05 | Sécurité : TLS partout, chiffrement des pièces d'identité au repos, secrets hors du code, principe du moindre privilège, tests d'intrusion avant le lancement. |
| NF-06 | Intégrité financière : **grand livre en partie double**, opérations idempotentes, aucun solde modifié sans écriture comptable. |
| NF-07 | Protection des données personnelles conforme à la loi congolaise ; consentement, droit d'accès et droit de suppression. |
| NF-08 | Observabilité : journaux, métriques et alertes sur les paiements en échec et les litiges. |
| NF-09 | Montée en charge cible du MVP : 100 000 utilisateurs inscrits, 10 000 actifs par jour. |
| NF-10 | Accessibilité : textes lisibles, contrastes suffisants, icônes accompagnées de libellés (public peu habitué au numérique). |

---

## 6. Indicateurs de succès du pilote (6 mois)

| Indicateur | Cible indicative |
|------------|------------------|
| Vendeurs, agences et prestataires actifs (au moins 1 annonce) | 5 000 |
| Agences immobilières vérifiées | 50 |
| Transactions séquestrées par mois (au 6e mois) | 10 000 |
| Taux de litige | < 3 % |
| Part des paiements réalisés dans l'application (contre hors application) | En hausse chaque mois |
| Utilisateurs actifs quotidiens / mensuels | > 25 % |
| Délai moyen de retrait | < 24 h |

---

## 7. Hors périmètre du MVP (déjà planifié)

Directs et live shopping, cadeaux et abonnements de créateurs, livraison intégrée, groupes, publicité en libre-service, Live AI, Live Savoir (cours, examens), Live Emploi, location courte durée, application iOS complète (si elle n'est pas prête), langues locales, extension hors du Congo.

**Fin du Document 05**
