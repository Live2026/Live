# Document 03 — Identité utilisateur, boutiques et capacités (v2)

## 1. Philosophie (conservée de la v1)

> **Tout le monde est un utilisateur.** Un seul compte, une seule identité, un seul solde, un seul historique. Ce sont les **capacités** qui évoluent.

Aucun compte « vendeur », « agence » ou « créateur » n'est choisi à l'inscription. On découvre d'abord Live comme acheteur ou spectateur, puis on **active** de nouvelles capacités quand on en a besoin : c'est le chemin le plus court entre l'installation de l'application et la première vente.

---

## 2. Trois notions à ne pas confondre

| Notion | Définition | Exemple |
|--------|-----------|---------|
| **Utilisateur** | Une personne physique, identifiée par son numéro de téléphone. | Grâce, 24 ans, Brazzaville |
| **Espace** | Une vitrine publique rattachée à un ou plusieurs utilisateurs : boutique, agence, entreprise de services, chaîne de créateur. | « Grâce Mode », « Agence Les Palmiers » |
| **Capacité** | Un droit d'action, accordé à un utilisateur ou à un espace. | Recevoir des paiements, publier une annonce immobilière |

Un utilisateur peut posséder **plusieurs espaces** (une boutique de pagnes **et** une chaîne de créateur, par exemple) et être **membre** de l'espace d'un autre (l'agent d'une agence).

---

## 3. Cycle de vie d'un utilisateur

### Étape 1 — Inscription (moins de 60 secondes)
- **Numéro de téléphone** (identifiant principal, car c'est aussi le numéro Mobile Money) et code OTP par SMS
- E-mail facultatif
- Prénom, nom, ville (Brazzaville ou Pointe-Noire au lancement)
- Acceptation des conditions générales et de la politique de confidentialité
- Déclaration de l'âge : **18 ans minimum pour acheter, vendre ou être payé** ; les 13–17 ans ont un accès restreint (lecture uniquement)

### Étape 2 — Découverte
- Choix de 3 centres d'intérêt (mode, téléphones, immobilier, beauté, cuisine, musique, services…)
- Parcourir le fil, rechercher, sauvegarder, suivre, commenter, discuter avec un vendeur

### Étape 3 — Premier achat
- Paiement MoMo, Airtel ou Visa, séquestre, confirmation de réception, avis

### Étape 4 — Évolution : « Je veux vendre, louer, proposer un service, créer »
Un bouton unique, **« Gagner de l'argent sur Live »**, guide l'utilisateur vers la bonne capacité.

---

## 4. Niveaux de confiance (KYC progressif)

Plus on veut faire de choses, plus on doit prouver son identité. C'est à la fois une exigence réglementaire (lutte contre le blanchiment) et le moteur de la confiance.

| Niveau | Conditions | Ce qui est permis (hypothèses de plafonds) |
|--------|------------|-------------------------------------------|
| **N0 — Visiteur** | Aucun compte | Consulter le fil et les annonces |
| **N1 — Téléphone vérifié** | Code OTP | Acheter, discuter, commenter, suivre, publier jusqu'à 3 annonces de produits ; encaissements plafonnés, **pas de retrait** |
| **N2 — Identité vérifiée** | Pièce d'identité (CNI ou passeport) + selfie + nom du titulaire Mobile Money identique | Vendre, être payé, **retirer** (plafond mensuel standard), proposer des services, recevoir des cadeaux |
| **N3 — Professionnel vérifié** | N2 + justificatifs (RCCM, NIU, agrément d'agence, adresse physique) | Espace Agence ou Entreprise, plafonds élevés, badge « Pro vérifié », gestion d'équipe |
| **N4 — Partenaire** | Contrat signé avec Live | API, conditions tarifaires négociées, accompagnement dédié |

Le badge affiché publiquement reflète le niveau : c'est l'un des **principaux arguments de confiance** face à Facebook.

---

## 5. Catalogue des capacités

| Code | Capacité | Obtenue par | Niveau min. |
|------|----------|-------------|-------------|
| C-ACHETER | Acheter et payer | Inscription | N1 |
| C-PUBLIER-SOCIAL | Publier des vidéos et des photos dans le fil | Inscription | N1 |
| C-VENDRE | Publier des produits à vendre | Activation | N1 (limité) / N2 |
| C-ENCAISSER | Recevoir des paiements séquestrés | Inscription (plafonné à 100 000 FCFA/mois en N1, sans retrait) ; vérification au-delà | N1 (limité) / N2 |
| C-RETIRER | Retirer vers Mobile Money | Vérification | N2 |
| C-IMMO-PARTICULIER | Publier une annonce immobilière de particulier | Vérification + preuve de lien avec le bien | N2 |
| C-IMMO-AGENCE | Espace agence, plusieurs agents, gestion des visites | Vérification professionnelle ; **gratuit au MVP**, puis abonnement Pro Agence à partir de P2 (D-26) | N3 |
| C-COMMISSIONNAIRE | Percevoir des frais de visite | Vérification + charte signée | N2 |
| C-SERVICES | Proposer des prestations et prendre des réservations | Activation + vérification | N2 |
| C-CREATEUR | Recevoir des cadeaux et des abonnements de fans | Seuil d'audience (ex. 500 abonnés) + vérification | N2 |
| C-DIRECT | Ouvrir un direct | Seuil d'audience ou abonnement Pro | N2 |
| C-DIRECT-VENTE | Vendre pendant un direct (live shopping) | C-DIRECT + C-VENDRE | N2 |
| C-BOOSTER | Acheter de la visibilité | Inscription | N1 |
| C-STATS-AVANCEES | Statistiques détaillées | Abonnement Pro | N2 |
| C-EQUIPE | Ajouter des membres à un espace | Vérification professionnelle (jusqu'à 5 membres gratuits au MVP) ; au-delà, abonnement Pro / Entreprise | N3 |
| C-ANNONCEUR | Créer des campagnes publicitaires | Vérification professionnelle | N3 |
| C-IA | Utiliser les services Live IA avec des crédits | Inscription (13 ans et plus) | N1 |
| C-IA-ACHAT | Acheter des Crédits Live (pour soi ou pour offrir) | Inscription, 18 ans et plus | N1 |
| C-API | Accès API | Contrat partenaire | N4 |

**Modes d'obtention** : activation libre, vérification, abonnement, seuil de réputation, validation manuelle par l'administration, contrat de partenariat.

**Retrait** : chaque capacité peut être **suspendue individuellement** (par exemple, un vendeur signalé perd C-VENDRE mais conserve son compte et ses achats).

---

## 5 bis. Présentation aux utilisateurs : les « super-pouvoirs »

Dans l'application, les capacités s'appellent des **super-pouvoirs** : un mot simple, valorisant, qui dit « vous pouvez gagner de l'argent autrement ». Règles d'affichage (écran E-MOI-02) :

- **Tout le monde est utilisateur.** À l'inscription, on reçoit déjà : acheter protégé, publier des vidéos, vendre (3 annonces), Live IA.
- **Chaque pouvoir dit ce qu'il rapporte** (ex. « Retirer ses gains : sans frais de retrait ») et **comment le débloquer** (vérifier son identité, créer un espace pro, passer à Live Pro).
- **Aucune fonction n'affiche d'erreur de droits** : une fonction réservée explique le pouvoir manquant et mène à l'écran qui le débloque (E-PUB-07).
- **Progression visible** : échelle N1 → N2 → N3 → Pro sur la page Moi.

## 6. Les espaces (boutiques, agences, entreprises, chaînes)

| Type d'espace | Contenu | Membres |
|---------------|---------|---------|
| **Boutique** | Catalogue, vidéos produits, avis, horaires, zone de livraison | Propriétaire + vendeurs (Pro) |
| **Agence immobilière** | Biens, agents, calendrier de visites, avis | Directeur + agents |
| **Prestataire / entreprise de services** | Services, tarifs, portfolio, zones d'intervention, agenda | Propriétaire + techniciens |
| **Chaîne de créateur** | Vidéos, directs, abonnements de fans, boutique associée | Créateur + modérateurs |
| **Organisation** (phase 3) | École, ONG, ministère, média : publications officielles | Gestionnaires délégués |

**Rôles internes à un espace** (définis par le propriétaire, et non par Live) : Propriétaire, Gestionnaire, Agent / Vendeur, Modérateur, Comptable (consultation des finances uniquement).

**Règles**
- Un espace a **toujours au moins un propriétaire** vérifié.
- Les revenus d'un espace sont versés au **solde de l'espace**, retirables uniquement par le propriétaire ou un membre habilité.
- Chaque action d'un membre est **journalisée** (qui a publié, modifié, remboursé…).

---

## 7. Abonnements

Les abonnements **ne créent pas de rôle** : ils **débloquent des capacités** (principe de la v1 conservé). Voir le document 02, section 4.3, pour les offres Pro.

---

## 8. Réputation

Chaque utilisateur et chaque espace a un **score de réputation** visible sous forme simplifiée :

- note moyenne des avis (uniquement des acheteurs ayant réellement payé dans Live) ;
- taux de transactions menées à bien ;
- délai moyen de réponse aux messages ;
- ancienneté ;
- litiges perdus et signalements confirmés.

La réputation conditionne : la position dans les résultats de recherche, l'accès à certaines capacités, les plafonds et la durée du séquestre.

---

## 9. Sécurité du compte

- Connexion par OTP, **code PIN** de l'application et biométrie si le téléphone le permet
- **PIN de paiement** distinct pour chaque paiement et retrait
- Alerte à chaque nouvel appareil
- Changement de numéro : procédure renforcée (ancien numéro + pièce d'identité)
- Suspension possible d'une capacité sans fermeture du compte
- Suppression du compte à la demande de l'utilisateur, sous réserve des obligations légales de conservation des transactions

---

## 10. Administration interne

- **Super Administrateur** : seul rôle permanent, contrôle global (conservé de la v1).
- **Administrateurs délégués**, avec des permissions internes fines (RBAC côté back-office uniquement) : modérateur, agent de vérification KYC, agent de litiges, support, finance / réconciliation, commercial.
- **Double validation** (principe des quatre yeux) pour les actions financières sensibles : remboursement au-delà d'un seuil, déblocage d'un compte gelé, modification de commission.
- **Journal d'audit** inaltérable : connexions, publications, paiements, retraits, modifications, validations, suspensions.

**Fin du Document 03**
