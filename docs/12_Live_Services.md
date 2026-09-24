# Document 12 — Live Services : prestataires et réservations

> Troisième verticale du lancement (D-04) ; la première à passer en P2 si le budget impose une coupe. Document rédigé selon le gabarit commun (document 00, section 3).
> Les usages décrits (acompte pour le matériel, frais de déplacement, paiement à la fin du chantier) doivent être **confirmés sur le terrain** auprès d'une trentaine de prestataires avant le développement.

## 1. Finalité

Permettre à **chaque artisan, professionnel de la beauté, prestataire événementiel ou indépendant** d'être **trouvé, réservé et payé** via Live, et permettre à chaque client de trouver **quelqu'un de fiable** près de chez lui, avec un recours en cas de problème.

### 1.1 Constat terrain (à confirmer)

| Réalité actuelle | Conséquence |
|------------------|-------------|
| On trouve un plombier, un électricien ou une coiffeuse par le bouche-à-oreille ou dans les groupes Facebook. | Offre invisible, choix au hasard, prix opaques. |
| Le prestataire demande souvent un **acompte pour acheter le matériel**. | Le client craint que le prestataire disparaisse avec l'acompte, et cela arrive. |
| Le client refuse parfois de payer le solde (« ce n'est pas bien fait »). | Le prestataire n'a aucun recours ; les conflits se règlent à l'amiable ou mal. |
| Les bons prestataires n'ont **aucun moyen de prouver leur sérieux** (pas d'avis vérifiables, pas de portfolio). | Le prix devient le seul critère de choix. |
| Pour les événements (mariages, deuils, anniversaires), les montants sont élevés et les délais courts. | Risque de défaillance le jour J. |

### 1.2 Promesse Live Services

> **« Un prestataire vérifié, un prix clair, un acompte protégé, et un recours si le travail n'est pas fait. »**

---

## 2. Acteurs

| Acteur | Capacité (doc 03) | Niveau min. | Ce qu'il fait |
|--------|-------------------|-------------|---------------|
| **Client** | C-ACHETER | N1 | Recherche, demande de devis, réservation, paiement, confirmation, avis |
| **Prestataire indépendant** | C-SERVICES + C-ENCAISSER + C-RETIRER | N2 | Fiche de services, devis, agenda, encaissement |
| **Entreprise de services** | C-SERVICES + C-EQUIPE | N3 | Espace prestataire, plusieurs techniciens, répartition des interventions |
| **Technicien d'entreprise** | Membre d'un espace | N2 | Réalise les interventions au nom de l'entreprise |
| **Agent Live Services** | Back-office | — | Vérification des prestataires, catégories, réclamations |

---

## 3. Catégories

### 3.1 Catégories du lancement

| Famille | Exemples |
|---------|----------|
| **Dépannage et bâtiment** | Plomberie, électricité, maçonnerie, menuiserie, soudure, peinture, carrelage, climatisation et froid, installation solaire, serrurerie |
| **Réparation** | Téléphones, ordinateurs, électroménager, télévision, mécanique automobile et moto |
| **Beauté et bien-être** | Coiffure, tresses, barbier, onglerie, maquillage, esthétique (à domicile ou en salon) |
| **Événementiel** | Traiteur, décoration, DJ et sonorisation, animateur (MC), photographe, vidéaste, location de chaises, bâches et vaisselle |
| **Maison** | Ménage, blanchisserie et repassage, jardinage, désinsectisation, déménagement |
| **Numérique et création** | Graphisme, montage vidéo, community management, création de sites, impression |
| **Cours et accompagnement** | Répétiteurs à domicile, cours de langue, de musique, de conduite (passerelle vers Live Savoir) |

### 3.2 Catégories reportées ou exclues

| Catégorie | Décision | Raison |
|-----------|----------|--------|
| **Garde d'enfants, aide aux personnes âgées** | P2, avec une vérification renforcée (casier judiciaire, références) | Personnes vulnérables |
| **Santé** (médecins, infirmiers, kinésithérapeutes) | Exclue jusqu'à la P3 | Professions réglementées ; vérification de l'ordre professionnel nécessaire |
| **Juridique et comptable** (avocats, notaires, experts-comptables) | P3, avec une vérification de l'inscription professionnelle | Professions réglementées |
| **Transport de personnes** (taxi, moto-taxi) | Exclue | Autre métier (VTC), réglementation spécifique |
| **Services illégaux ou pour adultes** | Interdits | Loi, charte Live |

---

## 4. Fonctionnalités

### 4.1 Profil et fiches de services (SRV-PROF)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-PROF-01 | **Profil prestataire** : photo, métier(s), description, années d'expérience, quartier de base, **zones d'intervention** (arrondissements), langues parlées, disponibilité à domicile ou en atelier/salon. | M |
| F-SRV-PROF-02 | **Portfolio** : photos et vidéos de réalisations (avant/après), publiables dans Live Feed avec le bouton **« Réserver »**. | M |
| F-SRV-PROF-03 | **Fiches de services** : intitulé, catégorie, description, **type de tarif** (prix fixe, à partir de, sur devis, à l'heure), durée estimée, lieu (domicile du client, atelier). | M |
| F-SRV-PROF-04 | **Frais de déplacement ou de diagnostic** facultatifs, affichés d'avance (déduits du devis si le client confirme les travaux, option du prestataire). | M |
| F-SRV-PROF-05 | Badges : Identité vérifiée, Pro vérifié, « Répond en moins d'une heure », nombre de prestations réalisées via Live. | M |
| F-SRV-PROF-06 | **Justificatifs de qualification** facultatifs (diplôme, attestation de formation) vérifiés par Live : badge « Qualification vérifiée ». | S |

### 4.2 Recherche (SRV-RECH)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-RECH-01 | Onglet **« Services »** : familles, prestataires près de moi, mieux notés, disponibles aujourd'hui. | M |
| F-SRV-RECH-02 | Recherche plein texte (métier, service), filtres : catégorie, quartier d'intervention, note minimale, vérifié, à domicile, disponible à une date, fourchette de prix. | M |
| F-SRV-RECH-03 | **Urgence** : filtre « Disponible maintenant » (le prestataire active un statut « En service »). | S |
| F-SRV-RECH-04 | Favoris et « Refaire appel à ce prestataire ». | M |

### 4.3 Demande publique de devis (SRV-DEM)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-DEM-01 | Le client **décrit son besoin** : catégorie, description, photos ou vidéo, quartier, date souhaitée, budget indicatif. | M |
| F-SRV-DEM-02 | La demande est diffusée aux **prestataires vérifiés correspondants** (catégorie + zone), avec une limite de réponses (ex. les 5 premiers devis). | M |
| F-SRV-DEM-03 | Les prestataires répondent par un **devis payable** (voir 4.4) ; le client compare les devis (prix, délai, note). | M |
| F-SRV-DEM-04 | La demande expire après 72 h ou dès qu'un devis est accepté. | M |

> **Pourquoi c'est prioritaire** : sur Facebook, le client publie « Je cherche un plombier à Talangaï » et reçoit des numéros de téléphone d'inconnus. Sur Live, il reçoit en quelques heures des **devis comparables de prestataires vérifiés et notés**. C'est l'argument le plus immédiat pour faire basculer les clients.

### 4.4 Devis (SRV-DEV)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-DEV-01 | Devis structuré, envoyé dans la conversation sous forme de **carte payable** : lignes (main-d'œuvre, matériel), total, date d'intervention, durée, **acompte demandé**, conditions d'annulation, validité. | M |
| F-SRV-DEV-02 | Le client accepte le devis et paie l'acompte (MoMo, Airtel ou Visa) : **séquestré**. | M |
| F-SRV-DEV-03 | Modification du devis avant acceptation ; **avenant** en cours de prestation (travaux supplémentaires), payé séparément. | S |
| F-SRV-DEV-04 | Devis en PDF téléchargeable (utile pour les entreprises clientes). | C |

### 4.5 Réservation à prix fixe (SRV-RES)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-RES-01 | Pour les services à prix fixe (coiffure, ménage, réparation standard), **réservation directe d'un créneau** dans l'agenda du prestataire. | M |
| F-SRV-RES-02 | **Agenda** du prestataire : horaires habituels, jours de fermeture, blocage manuel de créneaux, durée par service. | M |
| F-SRV-RES-03 | Le prestataire **confirme** la réservation dans un délai de 12 h (paramétrable) ; sinon, annulation et remboursement automatiques. | M |
| F-SRV-RES-04 | Rappels automatiques aux deux parties (veille et 2 h avant). | M |
| F-SRV-RES-05 | Réservation d'un technicien donné dans une entreprise. | S |

### 4.6 Paiement de la prestation (SRV-PAY)

Trois schémas couvrent l'essentiel des situations :

| Schéma | Déroulement | Usage type | Prio |
|--------|-------------|-----------|------|
| **A. Tout payé d'avance** | Le client paie la totalité à la réservation, qui est **séquestrée** ; elle est versée après la confirmation de fin de prestation. | Coiffure, ménage, petites réparations | M |
| **B. Acompte + solde** | Acompte **séquestré** à l'acceptation du devis ; le solde est payé à la fin (via Live, avec une demande de paiement déclenchée par le prestataire comme dans Live Market, mode B) ; l'ensemble est versé après la confirmation. | Chantiers, événements | M |
| **C. Payer à la fin** | Aucune avance ; à la fin, le prestataire appuie sur « Encaisser » et le client valide sur son téléphone. | Dépannage rapide, prestataire qui veut rassurer | M |

**Acompte pour matériel** (F-SRV-PAY-04, M)

Beaucoup de prestataires ne peuvent pas avancer le prix du matériel. Live l'autorise **de façon encadrée** :
- le devis distingue une ligne **« Matériel »** ;
- au **démarrage de l'intervention**, le client saisit un **code de démarrage** (ou confirme dans l'application) : la part « matériel » de l'acompte est **libérée immédiatement** au prestataire ;
- ce déblocage anticipé est réservé aux prestataires **N2 ayant au moins 3 prestations réussies** (ou N3), plafonné (hypothèse : 150 000 FCFA ou 50 % du devis) ;
- le reste (main-d'œuvre) reste séquestré jusqu'à la fin.

### 4.7 Déroulement et confirmation (SRV-EXEC)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-EXEC-01 | Statuts de l'intervention : confirmée → en route → **démarrée** (code de démarrage) → **terminée** (déclarée par le prestataire) → confirmée par le client. | M |
| F-SRV-EXEC-02 | Photos « avant / après » jointes par le prestataire à la déclaration de fin (recommandées ; obligatoires pour les chantiers de plus de 100 000 FCFA). | M |
| F-SRV-EXEC-03 | Le client confirme par un **code de fin** ou un bouton ; **confirmation automatique** si aucune réclamation n'est ouverte dans le délai de garantie (24 h pour la beauté, le ménage et l'événementiel ; **72 h** pour le bâtiment et la réparation). | M |
| F-SRV-EXEC-04 | **Partage de sécurité** : le client ou le prestataire peut partager les détails de l'intervention (nom, photo, heure, adresse) avec un proche, en un clic. | S |
| F-SRV-EXEC-05 | Chantiers en **plusieurs étapes (jalons)**, chacune payée et confirmée séparément. | P2 |

### 4.8 Réclamations et garanties (SRV-CONF)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-CONF-01 | Réclamation pendant le délai de garantie : « Prestataire absent », « Travail non terminé », « Malfaçon », « Différent du devis », « Dégâts ». Preuves photo et vidéo. | M |
| F-SRV-CONF-02 | **Solutions proposées d'abord** : reprise des travaux par le prestataire à une date fixée, remboursement partiel ; puis médiation Live. | M |
| F-SRV-CONF-03 | **Absence du prestataire** : remboursement intégral + pénalité de réputation ; 2 absences en 30 jours suspendent C-SERVICES. | M |
| F-SRV-CONF-04 | **Absence du client** (domicile fermé, injoignable) : les frais de déplacement sont versés au prestataire ; le reste est remboursé. | M |
| F-SRV-CONF-05 | Annulation par le client : gratuite jusqu'à 24 h avant ; au-delà, conditions du devis (frais de déplacement ou pourcentage de l'acompte). | M |
| F-SRV-CONF-06 | Avis sur 5 étoiles avec des critères (ponctualité, qualité, propreté, respect du prix) ; réponse publique du prestataire. | M |

### 4.9 Tableau de bord prestataire (SRV-DASH)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-DASH-01 | Demandes à traiter, devis envoyés, interventions du jour et de la semaine, réclamations. | M |
| F-SRV-DASH-02 | Revenus : en attente, disponibles, retirés. | M |
| F-SRV-DASH-03 | Statistiques : vues du profil, demandes reçues, taux de transformation des devis. | S |
| F-SRV-DASH-04 | Entreprises : répartition des interventions entre techniciens, vue par technicien. | S |
| F-SRV-DASH-05 | **Carnet de clients** et relance « Il est temps de refaire votre entretien de climatisation ». | P2 |
| F-SRV-DASH-06 | **Abonnements de service récurrents** (ménage hebdomadaire, entretien mensuel) prélevés chaque mois. | P2 |

### 4.10 Visibilité (SRV-BOOST)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-SRV-BOOST-01 | Boost du profil ou d'un service, par ville ou par arrondissement (24 h, 3 j, 7 j). | M |
| F-SRV-BOOST-02 | Priorité de réception des **demandes publiques de devis** dans sa catégorie (abonnement Pro Prestataire, P2). | P2 |

---

## 5. Règles métier

| ID | Règle |
|----|-------|
| R-SRV-01 | Proposer des services exige le niveau **N2** (identité vérifiée) : il n'y a pas de prestataire anonyme, puisque le prestataire entre chez les gens. |
| R-SRV-02 | Les coordonnées (téléphone, adresse exacte du client) ne sont échangées **qu'après une réservation confirmée** ou un devis accepté. |
| R-SRV-03 | La commission Live est de **8 %** (D-09), prélevée sur le montant versé au prestataire (main-d'œuvre + matériel + déplacement). Le client paie le prix du devis. |
| R-SRV-04 | Le déblocage anticipé de la part « matériel » exige le code de démarrage, un prestataire éligible (4.6) et respecte le plafond. |
| R-SRV-05 | Un prestataire ne peut pas réserver ses propres services, ni recevoir de devis d'un compte lié (même appareil ou même numéro Mobile Money). |
| R-SRV-06 | Délai de garantie : 24 h (beauté, ménage, événementiel, numérique) ; 72 h (bâtiment, réparation). Aucun versement définitif de la main-d'œuvre avant son expiration, sauf confirmation explicite du client. |
| R-SRV-07 | Un prestataire dont le taux de réclamations fondées dépasse 5 % sur 30 jours (au moins 10 prestations) passe en revue ; C-SERVICES peut être suspendue. |
| R-SRV-08 | Les **demandes publiques** ne sont diffusées qu'aux prestataires vérifiés dont la zone d'intervention couvre le quartier du client. |
| R-SRV-09 | Les avis ne sont possibles que pour les prestations payées via Live (schémas A, B ou C). |

---

## 6. Cycle de vie d'une prestation

```
          (demande publique ou message)
DEMANDE ─► DEVIS_ENVOYÉ ─► DEVIS_ACCEPTÉ + ACOMPTE_PAYÉ (séquestre)
                │                         │
                ▼                         ▼
             EXPIRÉ                   CONFIRMÉE ─► EN_ROUTE ─► DÉMARRÉE (code ; déblocage éventuel du matériel)
                                          │                         │
                                          ▼                         ▼
                        ANNULÉE (client ou prestataire)    TERMINÉE_DÉCLARÉE (+ encaissement du solde)
                        ─► remboursement selon les règles           │
                                                                    ▼
                                                  CONFIRMÉE_CLIENT (code / bouton / fin de garantie) ─► VERSÉE
                                                                    │
                                                                    ▼
                                                  RÉCLAMATION ─► REPRISE / ACCORD / MÉDIATION
                                                               ─► REMBOURSÉE (totalement ou en partie) / VERSÉE

Réservation à prix fixe : CRÉNEAU_RÉSERVÉ (payé ou non selon le schéma) ─► CONFIRMÉE par le prestataire ─► suite identique
```

---

## 7. Données manipulées

| Entité | Principaux attributs |
|--------|----------------------|
| `profil_prestataire` | utilisateur_id / espace_id, métiers, description, expérience, quartier de base, zones d'intervention, domicile/atelier, qualifications (vérifiées ou non), statut « En service » |
| `service` | prestataire_id, catégorie, intitulé, description, type de tarif, prix, durée, lieu, frais de déplacement |
| `disponibilite` | prestataire_id, créneaux habituels, exceptions, réservations |
| `demande_publique` | client_id, catégorie, description, médias, quartier, date souhaitée, budget, statut, expiration |
| `devis` | demande_id ou conversation_id, prestataire_id, lignes (type : main-d'œuvre, matériel, déplacement), total, acompte, date, conditions, validité, statut |
| `prestation` | devis_id ou service_id, client_id, prestataire_id, technicien_id, schéma de paiement (A, B, C), codes de démarrage et de fin (hachés), photos avant/après, statut, horodatages |
| `reclamation_srv` | prestation_id, motif, preuves, solution proposée, décision |
| `avis_srv` | prestation_id, notes par critère, texte, réponse |
| Référentiels | catégories, familles, délais de garantie par famille, catégories exclues |

Les paiements, séquestres, déblocages partiels et versements relèvent de **Live Pay** (document 06).

---

## 8. Flux financiers

| Flux | Payeur | Bénéficiaire | Commission Live | Phase |
|------|--------|--------------|-----------------|-------|
| Prestation (schémas A, B, C) | Client | Prestataire | 8 % | P1 |
| Frais de déplacement ou de diagnostic | Client | Prestataire | 8 % | P1 |
| Boost profil ou service | Prestataire | Live | 100 % | P1 |
| Abonnement Pro Prestataire | Prestataire | Live | 100 % | P2 |
| Services récurrents (prélèvement mensuel) | Client | Prestataire | 8 % | P2 |

---

## 9. Sécurité, conformité et anti-fraude

- **Sécurité physique** : prestataires obligatoirement N2 ; partage de l'intervention avec un proche ; signalement prioritaire des comportements dangereux (traité en moins de 2 h, suspension immédiate possible).
- **Adresse du client** révélée uniquement au prestataire confirmé, et masquée après la prestation.
- **Signaux de fraude** : prestataires qui encaissent des acomptes « matériel » puis disparaissent (plafonds, éligibilité, suspension au premier cas), faux avis entre comptes liés, devis gonflés puis annulés.
- **Catégories réglementées** exclues ou reportées (3.2).
- **Garde d'enfants et personnes vulnérables** : non ouvertes au MVP.

---

## 10. Risques

| Risque | Probabilité | Impact | Réponse |
|--------|-------------|--------|---------|
| Les prestataires préfèrent l'espèce et le contact direct après la première mise en relation. | Élevée | Élevé | Schéma C (payer à la fin via MoMo), avis et badges réservés aux prestations payées via Live, garantie visible pour le client, offre à 0 % (D-10). |
| Litiges sur la qualité des travaux, difficiles à trancher à distance. | Élevée | Moyen | Photos avant/après, devis détaillé, reprise des travaux proposée en premier, médiation. |
| Acomptes « matériel » détournés. | Moyenne | Élevé | Éligibilité, plafond, code de démarrage, suspension. |
| Incident de sécurité au domicile d'un client. | Faible | Très élevé | Vérification N2, partage de sécurité, signalement prioritaire, coopération avec les autorités. |
| Offre trop dispersée (trop de catégories, pas assez de prestataires par catégorie). | Moyenne | Moyen | Lancement ciblé sur 10 métiers prioritaires (section 12, DS-02). |

---

## 11. Indicateurs

| Indicateur | Cible à 6 mois |
|------------|----------------|
| Prestataires vérifiés actifs | 1 500 |
| Demandes publiques de devis par mois | 3 000 |
| Taux de demandes recevant au moins 1 devis en 24 h | > 70 % |
| Prestations payées via Live par mois | 2 500 |
| Taux de réclamation | < 4 % |
| Part des clients qui refont appel à un prestataire à 60 jours | > 25 % |

---

## 12. Décisions propres à Live Services

| N° | Décision |
|----|----------|
| DS-01 | **Trois schémas de paiement** au MVP : tout d'avance, acompte + solde, payer à la fin via Mobile Money. |
| DS-02 | Lancement concentré sur **10 métiers prioritaires** : plomberie, électricité, climatisation et froid, réparation de téléphones, mécanique, coiffure et tresses, maquillage, traiteur, décoration événementielle, photographie et vidéo. Les autres catégories sont ouvertes mais non promues. |
| DS-03 | **Demande publique de devis** incluse au MVP (argument principal face à Facebook). |
| DS-04 | **Déblocage anticipé de la part « matériel »** autorisé, avec éligibilité et plafond (4.6). |
| DS-05 | Délai de garantie : 24 h ou 72 h selon la famille (R-SRV-06). |
| DS-06 | **Santé, juridique, garde d'enfants et transport de personnes** : exclus du MVP. |

---

## 13. Dépendances

- **Compte et capacités** (doc 03) : N2 obligatoire, espaces prestataire, membres (techniciens).
- **Live Pay** (doc 06) : séquestre, déblocage partiel, encaissement à la fin, versements, remboursements.
- **Live Confiance** : vérification des qualifications, réclamations, avis, signalement prioritaire.
- **Live Feed** : portfolio vidéo avec bouton « Réserver ».
- **Live Chat** : devis sous forme de cartes payables.
- **Notifications** : nouvelles demandes, rappels d'intervention, fin de garantie.
- **Live Savoir** (P3) : cours particuliers et formations.

**Fin du Document 12**
