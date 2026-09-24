# Document 11 — Live Immo : immobilier et agences

> Verticale prioritaire du lancement (D-04). Document rédigé selon le gabarit commun (document 00, section 3).
> Les usages locaux décrits (frais de visite, avance, commission du commissionnaire) doivent être **confirmés sur le terrain** par l'équipe commerciale auprès d'une dizaine d'agences et de bailleurs avant le développement.

## 1. Finalité

Faire de Live **l'endroit où l'on trouve un logement ou un local au Congo sans se faire arnaquer**, et où agences, bailleurs et commissionnaires sérieux **gagnent plus vite et plus proprement**.

### 1.1 Constat terrain (à confirmer)

| Réalité actuelle | Conséquence |
|------------------|-------------|
| Les annonces circulent dans les groupes Facebook et WhatsApp, sans vérification. | Faux biens, biens déjà loués, photos volées. |
| Le candidat locataire paie des **frais de visite** en espèces ou par MoMo à un intermédiaire inconnu. | Argent perdu si la visite est fictive ou si le bien ne correspond pas. |
| La location exige une **avance de plusieurs mois de loyer** et une **caution**, parfois versées avant la signature. | Arnaques aux avances, avec de gros montants en jeu. |
| Le **commissionnaire** (démarcheur) perçoit une commission, souvent l'équivalent d'un mois de loyer, sans contrat ni trace. | Aucune protection pour l'une ou l'autre partie, et des conflits. |
| Pour les parcelles, la **double vente** et les titres contestés sont fréquents. | Pertes considérables pour les acheteurs, notamment dans la diaspora. |
| Les agences sérieuses ont peu de visibilité numérique et sont noyées dans la masse. | Aucune prime à l'honnêteté. |

### 1.2 Promesse Live Immo

> **« Visite payée = visite garantie. Réservation payée = argent protégé. Annonceur vérifié = interlocuteur réel. »**

---

## 2. Acteurs

| Acteur | Capacité (doc 03) | Niveau min. | Ce qu'il fait |
|--------|-------------------|-------------|---------------|
| **Chercheur** (locataire ou acheteur) | C-ACHETER | N1 | Recherche, alertes, paiement des frais de visite, réservation, avis |
| **Particulier propriétaire** | C-IMMO-PARTICULIER | N2 | Publie **ses propres** biens (preuve de lien avec le bien demandée) |
| **Commissionnaire** | C-COMMISSIONNAIRE | N2 + charte | Publie des biens **avec l'accord** du propriétaire ; perçoit les frais de visite et la commission |
| **Agence immobilière** | C-IMMO-AGENCE | N3 | Espace agence, agents, portefeuille de biens, tableau des visites |
| **Agent d'agence** | Membre d'un espace | N2 | Publie et gère les visites au nom de l'agence |
| **Promoteur / constructeur** (P2) | C-IMMO-AGENCE | N3 | Programmes neufs, préventes |
| **Agent Live Immo** | Back-office | — | Vérifie les annonceurs, traite les signalements et les litiges immobiliers |
| **Notaire / géomètre partenaire** (P3) | Partenaire N4 | — | Vérification foncière pour les ventes de parcelles |

---

## 3. Fonctionnalités

### 3.1 Types de biens et de transactions

| Transaction | Types de biens | Phase |
|-------------|----------------|-------|
| **Location longue durée** | Studio, chambre, appartement, maison, villa, local commercial, bureau, entrepôt | P1 |
| **Vente** | Maison, appartement, villa, **parcelle / terrain**, immeuble, local | P1 (annonce et visite) ; P3 (transaction sécurisée) |
| **Location meublée de courte durée** | Studio meublé, appartement meublé, chambre | P2 |
| **Location de salle et d'espace** | Salle de fête, salle de réunion, terrain pour un événement | P2 |
| **Programmes neufs** | Lots d'un promoteur | P3 |

### 3.2 Publication d'une annonce (IMMO-PUB)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-PUB-01 | Assistant de publication en 5 écrans : type → emplacement → caractéristiques → prix et conditions → médias. Brouillon conservé hors ligne. | M |
| F-IMMO-PUB-02 | **Emplacement** : ville, arrondissement, quartier (listes gérées par le back-office), repère libre (« derrière le marché Total »), point sur la carte **facultatif et flouté** (précision d'environ 200 m publiquement ; adresse exacte communiquée après le paiement de la visite). | M |
| F-IMMO-PUB-03 | **Caractéristiques** : chambres, salons, salles d'eau (internes ou externes), cuisine, surface (facultative), étage, **eau** (réseau public, forage, puits, aucune), **électricité** (réseau, compteur prépayé ou individuel, groupe électrogène, solaire), clôture, gardiennage, parking, carrelage, climatisation, meublé, accès (goudron, piste), inondable (oui ou non). | M |
| F-IMMO-PUB-04 | **Prix et conditions (location)** : loyer mensuel, **nombre de mois d'avance**, **caution** (en mois), commission de l'intermédiaire (en mois ou en montant), frais de visite, charges incluses. Affichage automatique du **coût total d'entrée** (avance + caution + commission). | M |
| F-IMMO-PUB-05 | **Prix et conditions (vente)** : prix, négociable (oui ou non), **nature du document foncier déclaré** (titre foncier, attestation, acte de vente, aucun), commission. | M |
| F-IMMO-PUB-06 | **Médias obligatoires** : au moins 4 photos **prises récemment** (métadonnées vérifiées quand elles existent) et, fortement recommandée, une vidéo de visite de 60 s (badge « Vidéo réelle »). Façade, pièces principales, eau, sanitaires. | M |
| F-IMMO-PUB-07 | Détection des **photos déjà publiées** dans une autre annonce (empreinte perceptuelle) : blocage et revue si l'annonceur est différent. | S |
| F-IMMO-PUB-08 | Déclaration du **lien avec le bien** : propriétaire, mandataire (agence), commissionnaire avec l'accord du propriétaire. Pour un commissionnaire : numéro du propriétaire (non public), que Live peut appeler pour vérification aléatoire. | M |
| F-IMMO-PUB-09 | Modération avant publication (photos, texte, prix aberrant, coordonnées dans la description). | M |
| F-IMMO-PUB-10 | **Création de la publication vidéo** dans Live Feed à partir de l'annonce, en un clic (bouton « Visiter »). | M |
| F-IMMO-PUB-11 | Duplication d'annonce (même immeuble, plusieurs appartements). | S |
| F-IMMO-PUB-12 | Import en masse pour les agences (fichier tableur + dossier de photos). | C |

### 3.3 Recherche et découverte (IMMO-RECH)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-RECH-01 | Filtres : location ou vente, type, ville, **arrondissement / quartier (sélection multiple)**, loyer minimum et maximum, **coût d'entrée maximum**, chambres, eau, électricité, meublé, parking, annonceur vérifié uniquement, avec vidéo uniquement. | M |
| F-IMMO-RECH-02 | Tri : plus récent, prix croissant, proximité, meilleure réputation de l'annonceur. | M |
| F-IMMO-RECH-03 | **Alerte logement** : recherche sauvegardée, avec notification push à chaque nouvelle annonce correspondante. | M |
| F-IMMO-RECH-04 | Vue carte (points floutés). | S |
| F-IMMO-RECH-05 | Onglet **« Immo »** dans Live Feed : vidéos de biens près de moi. | M |
| F-IMMO-RECH-06 | Favoris et comparaison de 2 à 3 biens. | S |
| F-IMMO-RECH-07 | **Demande inversée** : « Je cherche un 2 chambres à Moungali, 80 000 FCFA maximum » ; les annonceurs vérifiés qui ont un bien correspondant peuvent répondre. | S |

### 3.4 Fiche de bien (IMMO-FICHE)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-FICHE-01 | Galerie photo et vidéo, caractéristiques, **coût total d'entrée** mis en évidence. | M |
| F-IMMO-FICHE-02 | **Bloc annonceur** : nom, badge (Particulier vérifié, Commissionnaire vérifié, Agence vérifiée), note, nombre de biens loués via Live, délai de réponse. | M |
| F-IMMO-FICHE-03 | **Fraîcheur** : « Disponibilité confirmée il y a X jours ». | M |
| F-IMMO-FICHE-04 | Boutons : **« Demander une visite »**, **« Écrire »**, **« Signaler »**, **« Partager »**. | M |
| F-IMMO-FICHE-05 | Bandeau de sécurité : « Ne payez jamais de frais de visite ou d'avance en dehors de Live : vous ne seriez pas protégé. » | M |

### 3.5 Visites (IMMO-VIS)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-VIS-01 | L'annonceur définit des **créneaux de visite** (jours et heures) ou accepte les demandes libres. | M |
| F-IMMO-VIS-02 | Le chercheur choisit un créneau et **paie les frais de visite** (MoMo, Airtel ou Visa) : les fonds sont **séquestrés**. Frais nuls possibles : la visite est alors réservée sans paiement. | M |
| F-IMMO-VIS-03 | Après le paiement, l'**adresse précise** et le **numéro de l'annonceur** sont révélés au chercheur. | M |
| F-IMMO-VIS-04 | Rappels automatiques (veille et 2 h avant) aux deux parties. | M |
| F-IMMO-VIS-05 | Sur place, le chercheur communique son **code de visite à 4 chiffres** ; l'annonceur le saisit : la visite est confirmée et les frais lui sont versés (moins la commission de 15 %). | M |
| F-IMMO-VIS-06 | **Absences** (D-25) : visiteur absent, frais versés à l'annonceur après déclaration et délai de contestation de 24 h ; annonceur absent ou bien indisponible, remboursement intégral et pénalité de réputation. | M |
| F-IMMO-VIS-07 | **« Le bien ne correspond pas à l'annonce »** : le chercheur peut le déclarer dans les 2 h suivant le créneau, avec photos ; les frais sont bloqués et un litige est ouvert. | M |
| F-IMMO-VIS-08 | Frais de visite **multi-biens** : un seul paiement pour visiter 3 biens du même annonceur le même jour. | S |
| F-IMMO-VIS-09 | **Visite vidéo en direct** (appel vidéo depuis l'application) pour la diaspora et les chercheurs éloignés. | S (P2) |

### 3.6 Réservation et entrée dans les lieux (IMMO-RES)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-RES-01 | Après la visite, l'annonceur peut envoyer une **offre de réservation** : montant de l'acompte, date limite de signature, conditions d'annulation. | S (MVP) |
| F-IMMO-RES-02 | Le chercheur paie l'acompte, qui est **séquestré** ; le bien passe au statut « Réservé » (et disparaît des recherches). | S (MVP) |
| F-IMMO-RES-03 | **Signature confirmée par les deux parties** : acompte versé à l'annonceur, moins 2 % (plafonné à 10 000 FCFA, payé par l'annonceur, D-24). | S (MVP) |
| F-IMMO-RES-04 | Annulation : par l'annonceur, remboursement intégral ; par le chercheur, selon les conditions affichées au moment du paiement ; désaccord, litige. | S (MVP) |
| F-IMMO-RES-05 | **Paiement complet de l'entrée** via Live (avance + caution + commission), avec ventilation automatique : bailleur, commissionnaire ou agence, commission Live. | P2 |
| F-IMMO-RES-06 | **Contrat de bail type** généré (modèle validé par un juriste), signé électroniquement dans l'application. | P2 |
| F-IMMO-RES-07 | **Paiement mensuel du loyer via Live** (rappels, reçus, historique pour le locataire comme pour le bailleur). | P3 |
| F-IMMO-RES-08 | **Gestion locative** pour les bailleurs et les agences : état des loyers, relances, quittances, états des lieux avec photos. | P3 |

> **Pourquoi F-IMMO-RES-07 et 08 sont stratégiques** : le loyer est un paiement **mensuel et récurrent**. Un locataire qui paie son loyer sur Live revient **chaque mois**, et un bailleur qui gère ses loyers sur Live ne le quitte plus. C'est la boucle de rétention la plus forte de la verticale.

### 3.7 Espace agence (IMMO-AG)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-AG-01 | Page agence vérifiée : logo, description, adresse physique, horaires, équipe, biens, avis, nombre de biens loués via Live. | M |
| F-IMMO-AG-02 | Jusqu'à 5 agents au MVP (D-26) : chaque annonce est affectée à un agent. | M |
| F-IMMO-AG-03 | **Tableau de bord** : demandes, visites du jour, visites confirmées, réservations, revenus. | M |
| F-IMMO-AG-04 | Messagerie partagée : les conversations de l'agence sont visibles par les membres habilités. | S |
| F-IMMO-AG-05 | Statistiques par bien : vues, contacts, visites, délai de location. | S |
| F-IMMO-AG-06 | Abonnement Pro Agence (P2) : agents illimités, boosts inclus, mise en avant « Agence partenaire », import en masse, API. | P2 |

### 3.8 Confiance et anti-arnaque (IMMO-CONF)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-CONF-01 | **Vérification des annonceurs** : N2 pour les particuliers et les commissionnaires, N3 pour les agences (RCCM, NIU, adresse, visite physique de l'agence par un commercial Live pour le badge « Agence vérifiée »). | M |
| F-IMMO-CONF-02 | **Charte du commissionnaire** signée électroniquement : n'annoncer que des biens réels avec l'accord du propriétaire, aucun paiement hors Live, retrait immédiat d'un bien loué. | M |
| F-IMMO-CONF-03 | **Confirmation de disponibilité** tous les 15 jours (une notification, un clic) ; une annonce non confirmée depuis 30 jours est masquée (F-IMMO-07). | M |
| F-IMMO-CONF-04 | Signalements spécifiques : « Déjà loué », « Faux bien », « Prix différent », « Demande de paiement hors Live », « Photos volées ». | M |
| F-IMMO-CONF-05 | **Règles automatiques** : une annonce signalée 3 fois pour « faux bien » est suspendue et revue ; un annonceur ayant 2 litiges perdus est suspendu de C-IMMO-*. | M |
| F-IMMO-CONF-06 | **Contrôles aléatoires** : l'équipe Live appelle le propriétaire déclaré ou se rend sur place (échantillon mensuel). | S |
| F-IMMO-CONF-07 | Badge **« Bien vérifié par Live »** (visite réalisée par un agent Live, service payant pour l'annonceur). | P2 |
| F-IMMO-CONF-08 | **Vérification foncière** pour les parcelles, en partenariat avec des notaires et géomètres (service payant). | P3 |

### 3.9 Visibilité payante (IMMO-BOOST)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-IMMO-BOOST-01 | Boost d'une annonce : 24 h, 3 j ou 7 j, par ville ou par arrondissement. | M |
| F-IMMO-BOOST-02 | **« À la une »** : carrousel en tête de l'onglet Immo (nombre de places limité, par ville). | S |
| F-IMMO-BOOST-03 | Remontée automatique d'une annonce (« actualiser ») : 1 fois par semaine gratuitement, payant au-delà. | S |

---

## 4. Règles métier

| ID | Règle |
|----|-------|
| R-IMMO-01 | Un bien ne peut être publié que par un annonceur **N2 minimum** ; une agence doit être **N3**. |
| R-IMMO-02 | Les **coordonnées** (téléphone, adresse exacte) sont interdites dans le texte et les photos de l'annonce ; elles sont révélées après le paiement de la visite ou l'acceptation d'une demande de visite gratuite. |
| R-IMMO-03 | Les frais de visite sont plafonnés par la configuration (valeur initiale à fixer après l'enquête terrain, par ville). |
| R-IMMO-04 | Le **coût total d'entrée** est toujours calculé et affiché ; une annonce sans loyer ni conditions d'entrée ne peut pas être publiée. |
| R-IMMO-05 | Un bien au statut « Réservé » n'accepte plus de nouvelles visites payantes. |
| R-IMMO-06 | Un bien loué via Live passe au statut « Loué » et est archivé ; il est compté dans la réputation de l'annonceur. |
| R-IMMO-07 | Un même bien (mêmes photos, même emplacement) ne peut être publié que **par un seul annonceur** ; en cas de conflit, la priorité va au propriétaire vérifié, puis au mandataire désigné par lui. |
| R-IMMO-08 | La commission Live sur les frais de visite (15 %) et sur la réservation (2 %, plafonnée à 10 000 FCFA) est prélevée sur la part de l'annonceur (D-13, D-24). **Le chercheur ne paie que les montants affichés.** |
| R-IMMO-09 | Délai de contestation après une visite : 2 h pour « ne correspond pas », 24 h pour une absence déclarée. |
| R-IMMO-10 | Les annonces de vente de parcelles affichent en permanence l'avertissement : « Live ne garantit pas la situation foncière. Vérifiez le titre auprès d'un notaire avant tout paiement. » (jusqu'au service F-IMMO-CONF-08). |
| R-IMMO-11 | Aucun paiement de **prix de vente** d'un bien immobilier ne transite par Live avant la P3 et la validation juridique (montants élevés, risques LBC/FT). |

---

## 5. Cycles de vie

### 5.1 Annonce
```
BROUILLON ─► EN_MODÉRATION ─► PUBLIÉE ─► RÉSERVÉE ─► LOUÉE / VENDUE (archivée)
                 │               │  ▲         │
                 ▼               ▼  │         ▼
              REFUSÉE          MASQUÉE      PUBLIÉE (réservation annulée)
                         (non confirmée 30 j, suspendue ou retirée par l'annonceur)
```

### 5.2 Visite
```
DEMANDÉE ─► PAYÉE (séquestre) ─► CONFIRMÉE (code) ─► FRAIS VERSÉS
    │             │
    │             ├─► ANNULÉE PAR L'ANNONCEUR ─► REMBOURSÉE
    │             ├─► VISITEUR ABSENT (24 h de contestation) ─► FRAIS VERSÉS
    │             ├─► ANNONCEUR ABSENT ─► REMBOURSÉE + pénalité
    │             └─► NON CONFORME ─► LITIGE ─► REMBOURSÉE / VERSÉE
    └─► (visite gratuite) ACCEPTÉE ─► RÉALISÉE / ANNULÉE
```

### 5.3 Réservation
```
OFFRE_ENVOYÉE ─► ACOMPTE_PAYÉ (séquestre) ─► SIGNATURE_CONFIRMÉE ─► ACOMPTE VERSÉ (−2 %)
       │                  │
       ▼                  ├─► ANNULÉE PAR L'ANNONCEUR ─► REMBOURSÉE
    EXPIRÉE               ├─► ANNULÉE PAR LE CHERCHEUR ─► selon les conditions
                          └─► LITIGE ─► décision de Live Confiance
```

---

## 6. Données manipulées

| Entité | Principaux attributs |
|--------|----------------------|
| `bien_immo` | id, espace_id / annonceur_id, agent_id, transaction (location, vente, courte durée), type, ville, arrondissement, quartier, repère, géopoint (précis, privé), caractéristiques (JSON typé), statut, dernière confirmation, compteurs |
| `conditions_location` | loyer, mois d'avance, mois de caution, commission, frais de visite, charges, coût d'entrée (calculé) |
| `conditions_vente` | prix, négociable, document foncier déclaré, commission |
| `media_bien` | type, url, empreinte perceptuelle, date de prise de vue, ordre |
| `lien_bien` | nature (propriétaire, mandataire, commissionnaire), contact du propriétaire (chiffré), preuve |
| `creneau_visite` | bien_id, début, fin, capacité |
| `visite` | bien_id, chercheur_id, créneau, transaction_id, code (haché), statut, horodatages |
| `reservation` | bien_id, chercheur_id, montant, date limite, conditions d'annulation, transaction_id, statut |
| `alerte_immo` | utilisateur_id, critères (JSON), fréquence |
| `signalement_immo` | bien_id, auteur, motif, preuves, statut |
| Référentiels | villes, arrondissements, quartiers (administrables) |

Les transactions financières (paiements, séquestres, reversements) sont gérées par **Live Pay** (document 06) : Live Immo ne stocke que les références.

---

## 7. Flux financiers

| Flux | Payeur | Bénéficiaire | Commission Live | Phase |
|------|--------|--------------|-----------------|-------|
| Frais de visite | Chercheur | Annonceur | 15 % des frais | P1 |
| Acompte de réservation | Chercheur | Annonceur | 2 % plafonnée à 10 000 FCFA | P1 (S) |
| Boost / À la une | Annonceur | Live | 100 % | P1 |
| Abonnement Pro Agence | Agence | Live | 100 % | P2 |
| Badge « Bien vérifié » | Annonceur | Live | 100 % | P2 |
| Entrée complète (avance, caution, commission) | Locataire | Bailleur, intermédiaire | À définir (1 à 2 %) | P2 |
| Loyer mensuel | Locataire | Bailleur | À définir (≤ 1 % ou inclus dans l'abonnement de gestion) | P3 |
| Vérification foncière | Acheteur | Partenaire notaire | Commission d'apport | P3 |

---

## 8. Sécurité, conformité et anti-fraude

- **Adresse exacte et contact du propriétaire** chiffrés, jamais exposés publiquement.
- Coordonnées révélées **uniquement** après engagement (paiement ou acceptation).
- **Plafonds** : l'acompte de réservation est limité par le niveau KYC de l'annonceur (document 06, section 7).
- **LBC/FT** : pas de paiement du prix de vente via Live avant la P3 (R-IMMO-11).
- **Données personnelles** : les pièces d'identité et les justificatifs de propriété sont conservés dans un stockage chiffré, avec un accès journalisé.
- **Signaux de fraude** surveillés : photos dupliquées, frais de visite anormalement élevés, nombreuses visites encaissées sans location, annonceur récent avec de nombreux biens, messages contenant des coordonnées.

---

## 9. Risques

| Risque | Probabilité | Impact | Réponse |
|--------|-------------|--------|---------|
| Les commissionnaires refusent la transparence et restent sur Facebook. | Élevée | Élevé | Offre de lancement à 0 %, visibilité supérieure, badge « Vérifié » qui fait vendre, recrutement terrain. |
| Paiements contournés (le chercheur paie en espèces après le premier contact). | Élevée | Moyen | Coordonnées révélées uniquement après paiement, avertissements, aucune protection hors Live. |
| Faux biens publiés par des annonceurs vérifiés. | Moyenne | Élevé | Séquestre + litiges + suspension + contrôles aléatoires. |
| Enjeux juridiques de l'intermédiation immobilière (statut des commissionnaires, carte professionnelle). | Moyenne | Élevé | Consultation d'un juriste (D-16) ; Live reste une **plateforme de mise en relation et de paiement**, et non une agence. |
| Litiges fonciers sur les ventes de parcelles. | Élevée | Très élevé | Avertissement permanent (R-IMMO-10), aucun paiement du prix via Live (R-IMMO-11), partenariat notarial en P3. |
| Faible qualité des photos et des vidéos. | Élevée | Moyen | Guide de prise de vue dans l'application, badge « Vidéo réelle », mise en avant algorithmique des annonces complètes. |

---

## 10. Indicateurs

| Indicateur | Cible à 6 mois |
|------------|----------------|
| Agences vérifiées | 50 |
| Commissionnaires et particuliers vérifiés | 1 000 |
| Annonces actives (confirmées depuis moins de 30 jours) | 5 000 |
| Visites payées par mois | 3 000 |
| Taux de visites confirmées par code | > 80 % |
| Taux de litige sur les visites | < 3 % |
| Délai médian entre publication et location | À mesurer (référence de départ) |
| Part des annonces avec vidéo | > 50 % |

---

## 11. Décisions propres à Live Immo

| N° | Décision |
|----|----------|
| DI-01 | Au MVP, **les frais de visite et l'acompte de réservation** sont les seuls flux financiers immobiliers. L'entrée complète passe en P2, les loyers en P3. |
| DI-02 | Les **coordonnées** ne sont révélées qu'après un engagement (R-IMMO-02) : c'est la clé pour que le paiement reste dans Live. |
| DI-03 | Le point sur la carte est **flouté** publiquement (environ 200 m). |
| DI-04 | Aucun **prix de vente** ne transite par Live avant la P3 (R-IMMO-11). |
| DI-05 | Le **badge « Agence vérifiée »** exige une visite physique de l'agence par Live. |
| DI-06 | Le plafond des frais de visite sera fixé **après l'enquête terrain** auprès de 10 agences et de 10 commissionnaires dans chaque ville pilote. |

---

## 12. Dépendances

- **Compte et capacités** (doc 03) : N2 et N3, espaces agence, membres.
- **Live Pay** (doc 06) : séquestre, versements, remboursements, grand livre.
- **Live Confiance** : signalements, litiges, modération des médias, détection des doublons.
- **Live Feed** : publication vidéo liée au bien.
- **Live Chat** : conversation rattachée au bien.
- **Notifications** : alertes logement, rappels de visite.
- **Back-office** : référentiel des quartiers, file de vérification des agences, litiges immobiliers.

**Fin du Document 11**
