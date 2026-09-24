# Document 10 — Live Market : produits et boutiques

> Deuxième verticale du lancement, après Live Immo (D-04). Document rédigé selon le gabarit commun (document 00, section 3).
> Les usages décrits (paiement à la livraison, remise en main propre, envoi par bus entre villes) doivent être **confirmés sur le terrain** auprès d'une trentaine de vendeurs actifs sur Facebook et WhatsApp avant le développement.

## 1. Finalité

Permettre à **n'importe qui**, du particulier qui revend son téléphone à la boutique établie, de **vendre en vidéo à toute sa ville, d'être payé à coup sûr et de fidéliser ses clients**, et permettre aux acheteurs d'**acheter sans risque**.

### 1.1 Constat terrain (à confirmer)

| Réalité actuelle | Conséquence |
|------------------|-------------|
| La vente se fait dans les groupes Facebook, les statuts WhatsApp et les directs TikTok, puis se conclut en message privé. | Aucun catalogue, aucune recherche : le vendeur doit republier sans cesse. |
| L'acheteur hésite à payer d'avance par MoMo à un inconnu. | Beaucoup de ventes échouent ; le **paiement à la livraison en espèces** domine. |
| Le vendeur qui livre sans avoir été payé subit des **refus à la porte** et des « clients fantômes ». | Coûts de livraison perdus et temps gaspillé. |
| Les avis et la réputation ne sont pas vérifiables (captures d'écran de faux clients). | La confiance repose sur le bouche-à-oreille. |
| La contrefaçon et la vente de produits dangereux (médicaments, dépigmentants) circulent librement. | Risque sanitaire et risque juridique pour toute plateforme. |

### 1.2 Promesse Live Market

> **« Le vendeur est payé à coup sûr, l'acheteur ne paie que ce qu'il reçoit. »**

---

## 2. Acteurs

| Acteur | Capacité (doc 03) | Niveau min. | Ce qu'il fait |
|--------|-------------------|-------------|---------------|
| **Acheteur** | C-ACHETER | N1 | Recherche, commande, paiement, confirmation, avis |
| **Vendeur occasionnel** | C-VENDRE (limité) | N1 | Jusqu'à 3 annonces actives, encaissement plafonné à 100 000 FCFA par mois, sans retrait avant N2 |
| **Vendeur vérifié** | C-VENDRE + C-ENCAISSER + C-RETIRER | N2 | Annonces illimitées (à définir), boutique, retraits |
| **Boutique Pro** | + C-STATS-AVANCEES, C-EQUIPE | N3 | Espace boutique, plusieurs vendeurs, statistiques, abonnement Pro (P2) |
| **Livreur** (P2) | C-LIVREUR | N2 | Courses rémunérées via Live Livraison |
| **Agent Live Market** | Back-office | — | Modération des annonces, catégories interdites, litiges produits |

---

## 3. Fonctionnalités

### 3.1 Publication d'un produit (MKT-PUB)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-PUB-01 | **Publication en 30 secondes** : photos et vidéo depuis la galerie ou l'appareil photo, puis titre, prix, catégorie (suggérée automatiquement), état, quartier. Brouillon conservé hors ligne. | M |
| F-MKT-PUB-02 | Champs : titre, description, catégorie, sous-catégorie, **état** (neuf, comme neuf, bon état, à réparer), prix, négociable (oui ou non), quantité, jusqu'à 10 photos, 1 vidéo de 60 s maximum. | M |
| F-MKT-PUB-03 | **Attributs par catégorie** (ex. téléphone : marque, modèle, stockage, IMEI facultatif et privé ; vêtement : taille, couleur ; véhicule : P2). | M |
| F-MKT-PUB-04 | **Modes de remise** proposés par le vendeur : remise en main propre (lieu de rendez-vous), livraison par le vendeur (prix par zone), envoi dans une autre ville (P2 : bus, messagerie). | M |
| F-MKT-PUB-05 | **Variantes** (taille, couleur), chacune avec son stock. | S |
| F-MKT-PUB-06 | Publication automatique d'une vidéo dans Live Feed avec le bouton **« Acheter »**. | M |
| F-MKT-PUB-07 | Modération avant publication : catégories interdites, mots-clés, coordonnées dans le texte ou les images, prix aberrant, images dupliquées d'un autre vendeur. | M |
| F-MKT-PUB-08 | Renouvellement : une annonce sans activité depuis 60 jours est masquée après une notification de confirmation. | M |
| F-MKT-PUB-09 | **Suggestion de titre et de description** par l'IA à partir des photos. | C (P2) |
| F-MKT-PUB-10 | Import de catalogue en masse (tableur + photos). | C (P2) |

### 3.2 Boutique (MKT-BTQ)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-BTQ-01 | Création d'un **espace boutique** : nom, logo, bannière, description, catégories, quartier, horaires, zone de livraison. | M |
| F-MKT-BTQ-02 | Page publique : catalogue filtrable, vidéos, avis, nombre de ventes réalisées via Live, délai de réponse, badges. | M |
| F-MKT-BTQ-03 | **Suivre une boutique** : ses nouveautés apparaissent dans l'onglet « Abonnements » du fil. | M |
| F-MKT-BTQ-04 | **Lien de boutique partageable** (`live.xx/nom-boutique`) avec aperçu sur WhatsApp et Facebook : le vendeur l'utilise pour faire migrer ses clients. | M |
| F-MKT-BTQ-05 | Membres de la boutique (jusqu'à 5 au MVP) : gestionnaire, vendeur. | S |
| F-MKT-BTQ-06 | **Codes promo** et **soldes** (prix barré, durée limitée). | S |
| F-MKT-BTQ-07 | **Message aux abonnés** : une annonce par semaine gratuite (nouveautés, arrivage). | S |
| F-MKT-BTQ-08 | Mode vacances (boutique en pause). | C |

### 3.3 Découverte et recherche (MKT-RECH)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-RECH-01 | Onglet **« Market »** : catégories, nouveautés près de moi, bonnes affaires, boutiques recommandées. | M |
| F-MKT-RECH-02 | Recherche plein texte tolérante aux fautes, avec synonymes locaux (liste administrable). | M |
| F-MKT-RECH-03 | Filtres : catégorie, prix, état, ville, quartier, mode de remise, vendeur vérifié uniquement, avec vidéo. | M |
| F-MKT-RECH-04 | Recherches sauvegardées avec alertes. | M |
| F-MKT-RECH-05 | Favoris ; **alerte de baisse de prix** sur un favori. | S |
| F-MKT-RECH-06 | Recherche par photo (trouver des produits similaires). | C (P3) |

### 3.4 Fiche produit (MKT-FICHE)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-FICHE-01 | Galerie et vidéo, prix, état, attributs, modes de remise et leurs prix, quartier du vendeur. | M |
| F-MKT-FICHE-02 | Bloc vendeur : nom, badge, note, nombre de ventes via Live, délai de réponse. | M |
| F-MKT-FICHE-03 | Boutons : **« Acheter »**, **« Faire une offre »**, **« Écrire »**, **« Partager »**, **« Signaler »**. | M |
| F-MKT-FICHE-04 | Bandeau de protection : « Payez via Live : votre argent est rendu si vous ne recevez pas le produit. » | M |
| F-MKT-FICHE-05 | Autres produits de la boutique et produits similaires. | S |

### 3.5 Négociation et commande (MKT-CMD)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-CMD-01 | **Faire une offre** : l'acheteur propose un prix ; le vendeur accepte, refuse ou fait une contre-offre (3 échanges maximum). L'offre acceptée est valable 24 h. | M |
| F-MKT-CMD-02 | **Panier par boutique** : plusieurs articles du même vendeur, une seule commande et un seul paiement. | S |
| F-MKT-CMD-03 | Choix du mode de remise et, en cas de livraison par le vendeur, de l'adresse ou du repère. | M |
| F-MKT-CMD-04 | Récapitulatif : prix, frais de livraison, **total**. Aucun frais supplémentaire pour l'acheteur. | M |
| F-MKT-CMD-05 | Paiement MoMo, Airtel ou Visa : fonds **séquestrés**, stock réservé. | M |
| F-MKT-CMD-06 | Le vendeur doit **accepter la commande** dans les 24 h ; sinon, annulation et remboursement automatiques. | M |
| F-MKT-CMD-07 | Suivi de commande dans l'application et dans la conversation (voir 5.2). | M |

### 3.6 Deux façons de payer, un seul principe (MKT-PAY)

Le paiement à la livraison en espèces est ancré dans les habitudes. Live ne le combat pas de front : il le **numérise**.

| Mode | Déroulement | Pour qui | Prio |
|------|-------------|----------|------|
| **A. Payer maintenant (séquestre)** | L'acheteur paie à la commande ; l'argent est bloqué ; le vendeur remet le produit ; le vendeur scanne le **QR de confirmation** de l'acheteur (ou l'acheteur confirme dans l'application) ; l'argent est versé au vendeur. | Acheteur qui fait confiance à Live | M |
| **B. Payer à la remise** | La commande est réservée sans paiement. Au moment de la remise, le vendeur appuie sur « Encaisser » ; l'acheteur reçoit la **demande MoMo ou Airtel sur son téléphone** et valide ; le paiement est confirmé en quelques secondes ; le produit est remis. | Acheteur méfiant ; remplace les espèces | M |

**Règles du mode B**
- R-MKT-B1 : le vendeur peut exiger le mode A (par exemple pour les articles chers ou les livraisons lointaines).
- R-MKT-B2 : en mode B, l'argent est versé au vendeur **dès la confirmation du paiement** ; le délai de réclamation reste ouvert **24 h** pour un produit non conforme (avec une réserve temporaire prélevée sur le solde du vendeur si le litige est fondé).
- R-MKT-B3 : un acheteur qui réserve en mode B et ne se présente pas 2 fois perd l'accès au mode B pendant 30 jours.
- R-MKT-B4 : le mode B est également **compté dans les avis et la réputation** : c'est ce qui incite le vendeur à encaisser via Live plutôt qu'en espèces.

> **Pourquoi c'est décisif** : le vendeur garde l'habitude « je remets, je suis payé », mais l'argent arrive **sur Live**, avec une trace, un reçu, un avis et une réputation. C'est ainsi qu'on fait basculer les vendeurs de Facebook sans leur demander de changer leurs habitudes.

### 3.7 Remise et livraison (MKT-LIV)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-LIV-01 | **Remise en main propre** : lieu de rendez-vous proposé dans la conversation, **QR de confirmation** de l'acheteur scanné à la remise. Suggestion de lieux publics (marchés, stations, centres commerciaux). | M |
| F-MKT-LIV-02 | **Livraison par le vendeur** : frais fixés par le vendeur par zone ; le livreur du vendeur scanne le QR de confirmation. | M |
| F-MKT-LIV-03 | Délai de remise annoncé par le vendeur ; relances automatiques ; en l'absence de remise dans ce délai + 48 h, l'acheteur peut annuler avec remboursement. | M |
| F-MKT-LIV-04 | **Envoi dans une autre ville** (Brazzaville ↔ Pointe-Noire) : le vendeur saisit la référence de l'expédition (bus, messagerie) et une photo du bordereau ; la confirmation intervient à la réception. | S (P2) |
| F-MKT-LIV-05 | **Live Livraison** : le vendeur commande un livreur vérifié depuis la commande (prix selon la distance, suivi, code). | P2 |

### 3.8 Confirmation, avis et litiges (MKT-CONF)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-CONF-01 | Confirmation par **QR scanné à la remise** (code `LV-` en secours) ou par bouton « J'ai reçu » ; confirmation automatique **48 h** après la remise déclarée, sans litige. | M |
| F-MKT-CONF-02 | **Réclamation** pendant le délai : « Non reçu », « Non conforme à l'annonce », « Défectueux », « Contrefaçon » ; preuves photo et vidéo. | M |
| F-MKT-CONF-03 | **Résolution amiable** proposée d'abord (remboursement partiel, échange, retour) dans la conversation, puis médiation Live en l'absence d'accord sous 48 h. | M |
| F-MKT-CONF-04 | **Retour** : l'acheteur rend le produit au vendeur (code de retour) ; remboursement après confirmation du vendeur ou décision de Live. | S |
| F-MKT-CONF-05 | Avis sur 5 étoiles + commentaire + photo, uniquement pour une commande payée ; réponse publique du vendeur. | M |
| F-MKT-CONF-06 | Avis du vendeur sur l'acheteur (privé, utilisé pour la réputation de l'acheteur). | S |

### 3.9 Tableau de bord vendeur (MKT-DASH)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-DASH-01 | Commandes à traiter, en cours, terminées, en litige. | M |
| F-MKT-DASH-02 | Revenus : en attente, disponibles, retirés ; bouton de retrait. | M |
| F-MKT-DASH-03 | Statistiques de base : vues, favoris, messages, ventes par produit. | M |
| F-MKT-DASH-04 | Gestion du stock et des annonces (modifier, masquer, dupliquer, marquer comme vendu). | M |
| F-MKT-DASH-05 | Statistiques avancées (provenance des acheteurs, heures de pointe, taux de conversion) : Pro. | P2 |
| F-MKT-DASH-06 | Export des ventes (tableur) pour la comptabilité. | S |

### 3.10 Visibilité (MKT-BOOST)

| ID | Fonctionnalité | Prio |
|----|----------------|------|
| F-MKT-BOOST-01 | Boost d'un produit (24 h, 3 j, 7 j), par ville. | M |
| F-MKT-BOOST-02 | Boost de boutique (mise en avant dans « Boutiques recommandées »). | S |
| F-MKT-BOOST-03 | « Remonter » une annonce : 1 fois par semaine gratuitement, payant au-delà. | S |

---

## 4. Catégories

### 4.1 Catégories du lancement

Téléphones et tablettes · Informatique · Électroménager et électronique · Mode femme · Mode homme · Pagnes et tissus · Chaussures · Beauté et cosmétiques (produits autorisés uniquement) · Bébé et enfants · Maison et décoration · Meubles · Matériaux et bricolage · Sport · Alimentation non périssable et produits locaux · Pièces auto et moto · Livres et fournitures scolaires · Seconde main et friperie.

Les **véhicules**, la **nourriture préparée** et les **produits frais** arrivent en P2 (règles spécifiques : documents du véhicule, hygiène, délais courts).

### 4.2 Produits interdits (liste administrable)

| Interdit | Raison |
|----------|--------|
| Armes, munitions, explosifs | Loi |
| Médicaments, y compris la médecine traditionnelle vendue comme médicament | Santé publique ; circuit pharmaceutique réglementé |
| Produits dépigmentants contenant des substances interdites (hydroquinone, mercure, corticoïdes à forte dose) | Santé publique |
| Drogues et stupéfiants | Loi |
| Contrefaçons déclarées, faux documents, faux diplômes | Loi, propriété intellectuelle |
| Espèces animales protégées, ivoire, viande de brousse d'espèces protégées | Loi (protection de la faune) |
| Contenus et produits pour adultes | Charte Live, protection des mineurs |
| Cartes SIM activées au nom d'un tiers, comptes Mobile Money | Fraude, LBC/FT |
| Biens volés (téléphone signalé volé par son IMEI, si un fichier est accessible) | Loi |

Les listes exactes doivent être **validées par le juriste** (D-16).

---

## 5. Règles métier et cycles de vie

### 5.1 Règles

| ID | Règle |
|----|-------|
| R-MKT-01 | Un vendeur N1 a au maximum 3 annonces actives et 100 000 FCFA d'encaissements par mois, sans retrait avant le passage en N2. |
| R-MKT-02 | Les coordonnées (téléphone, liens externes) sont interdites dans les annonces ; elles sont échangées dans le chat, où un avertissement s'affiche en cas de tentative de paiement hors Live. |
| R-MKT-03 | La commission (6 %, minimum 100 FCFA, D-09) est prélevée **sur le montant versé au vendeur** (produit + frais de livraison) ; l'acheteur paie le prix affiché. |
| R-MKT-04 | Un vendeur ne peut pas acheter ses propres produits (même compte, même appareil ou même numéro Mobile Money). |
| R-MKT-05 | Commande non acceptée en 24 h : annulation et remboursement automatiques ; 3 non-acceptations en 30 jours entraînent une baisse de visibilité. |
| R-MKT-06 | Un vendeur dont le taux de litiges perdus dépasse 5 % sur 30 jours (au moins 10 ventes) voit sa capacité C-VENDRE suspendue et passe en revue. |
| R-MKT-07 | Les avis ne peuvent être ni modifiés ni supprimés par le vendeur ; seul Live peut retirer un avis abusif (insultes, données personnelles). |
| R-MKT-08 | Le prix affiché est le prix payé : pas de frais cachés au moment du paiement. |

### 5.2 Cycle de vie d'une commande

```
MODE A (payer maintenant)
PAYÉE (séquestre) ─► ACCEPTÉE ─► REMISE_DÉCLARÉE ─► CONFIRMÉE (QR / bouton / 48 h) ─► VERSÉE
     │                   │               │
     ▼                   ▼               ▼
 NON ACCEPTÉE 24 h    ANNULÉE        RÉCLAMATION ─► ACCORD / MÉDIATION ─► REMBOURSÉE (totalement ou en partie) / VERSÉE
 ─► REMBOURSÉE       ─► REMBOURSÉE

MODE B (payer à la remise)
RÉSERVÉE ─► ACCEPTÉE ─► ENCAISSEMENT DEMANDÉ ─► PAYÉE ─► VERSÉE (réclamation possible sous 24 h)
     │           │                │
     ▼           ▼                ▼
  EXPIRÉE     ANNULÉE        PAIEMENT ÉCHOUÉ ─► nouvelle tentative ou annulation
```

### 5.3 Cycle de vie d'une annonce

```
BROUILLON ─► EN_MODÉRATION ─► PUBLIÉE ─► ÉPUISÉE / VENDUE ─► ARCHIVÉE
                  │              │
                  ▼              ▼
               REFUSÉE        MASQUÉE (60 jours sans activité, suspendue, retirée)
```

---

## 6. Données manipulées

| Entité | Principaux attributs |
|--------|----------------------|
| `produit` | id, vendeur_id / espace_id, catégorie, attributs (JSON typé par catégorie), titre, description, état, prix, négociable, statut, compteurs |
| `variante` | produit_id, attributs, prix, stock |
| `media_produit` | type, url, empreinte perceptuelle, ordre |
| `mode_remise` | produit_id ou espace_id, type (main propre, livraison vendeur, envoi), zones et prix |
| `offre_prix` | produit_id, acheteur_id, montant, statut, expiration |
| `commande` | acheteur_id, espace_id, lignes, mode de paiement (A ou B), mode de remise, adresse ou repère, total, jeton de confirmation (haché), statut, horodatages |
| `ligne_commande` | commande_id, produit_id, variante_id, quantité, prix unitaire |
| `reclamation` | commande_id, motif, preuves, statut, décision |
| `avis` | commande_id, auteur, cible, note, texte, photo, réponse |
| `code_promo` | espace_id, type, valeur, période, conditions |
| Référentiels | catégories, attributs par catégorie, produits interdits, synonymes de recherche |

Les paiements, séquestres et versements relèvent de **Live Pay** (document 06).

---

## 7. Flux financiers

| Flux | Payeur | Bénéficiaire | Commission Live | Phase |
|------|--------|--------------|-----------------|-------|
| Achat (mode A ou B) | Acheteur | Vendeur | 6 % (minimum 100 FCFA) | P1 |
| Frais de livraison du vendeur | Acheteur | Vendeur | Incluse dans les 6 % | P1 |
| Boost produit ou boutique | Vendeur | Live | 100 % | P1 |
| Abonnement Pro Vendeur | Boutique | Live | 100 % | P2 |
| Live Livraison | Vendeur ou acheteur | Livreur | À définir | P2 |

---

## 8. Sécurité, conformité et anti-fraude

- **Protection des acheteurs** : séquestre (mode A), réclamation sous 24 h (mode B), remboursement vers le moyen de paiement d'origine.
- **Protection des vendeurs** : paiement garanti avant la remise (A) ou au moment de la remise (B) ; réputation des acheteurs ; mode B retiré aux acheteurs qui ne se présentent pas.
- **Signaux de fraude** : auto-achats, avis croisés entre comptes liés, cartes Visa refusées à répétition, remboursements en série, annonces à prix anormalement bas (appâts), photos copiées d'autres vendeurs.
- **Produits interdits** : filtrage automatique + signalements + revue humaine.
- **Contrefaçon** : procédure de signalement pour les titulaires de marques (avec preuves), suppression rapide.
- **Données** : IMEI et adresses de livraison privés et chiffrés.

---

## 9. Risques

| Risque | Probabilité | Impact | Réponse |
|--------|-------------|--------|---------|
| Les vendeurs continuent à encaisser en espèces. | Élevée | Élevé | Mode B « payer à la remise » + avis uniquement pour les ventes payées via Live + offre à 0 % (D-10). |
| Le vendeur déclare une remise fictive. | Moyenne | Moyen | QR de confirmation à la remise ; confirmation automatique seulement 48 h après la remise déclarée ; litige possible. |
| Acheteurs de mauvaise foi (faux « non reçu »). | Moyenne | Moyen | Preuve du scan du QR, historique de l'acheteur, réputation, sanctions. |
| Contrefaçons et produits dangereux. | Élevée | Élevé | Liste des interdits, modération, retrait rapide, coopération avec les autorités. |
| Coût vidéo élevé par rapport à la valeur des ventes. | Moyenne | Moyen | Vidéos de 60 s maximum, compression, qualité adaptative (D-05, D-20). |
| Concurrence de Facebook Marketplace (gratuit). | Certaine | Élevé | Live gagne sur le paiement, la confiance et le local, pas sur le prix. |

---

## 10. Indicateurs

| Indicateur | Cible à 6 mois |
|------------|----------------|
| Vendeurs actifs (au moins 1 annonce) | 4 000 |
| Boutiques vérifiées N3 | 300 |
| Commandes payées via Live par mois | 6 000 |
| Part du mode B dans les commandes | À mesurer (suivi de la conversion des espèces) |
| Taux de réclamation | < 3 % |
| Délai médian entre l'annonce et la première vente | À mesurer |
| Part des acheteurs qui refont un achat à 30 jours | > 30 % |

---

## 11. Décisions propres à Live Market

| N° | Décision |
|----|----------|
| DM-01 | **Deux modes de paiement** au MVP : payer maintenant (séquestre) et **payer à la remise via Mobile Money**. Pas de paiement en espèces enregistré dans Live. |
| DM-02 | Au MVP, la **livraison** est assurée par le vendeur ou par une remise en main propre ; Live Livraison arrive en P2. |
| DM-03 | Les avis ne sont possibles que pour les **ventes payées via Live**. |
| DM-04 | **Véhicules, nourriture préparée et produits frais** : P2. |
| DM-05 | La liste des **produits interdits** est validée par le juriste avant le lancement. |
| DM-06 | La commission de 6 % s'applique au **total versé au vendeur**, livraison comprise, pour éviter que les vendeurs gonflent les frais de livraison afin de réduire la commission. |

---

## 12. Dépendances

- **Compte et capacités** (doc 03) : niveaux N1 à N3, espaces boutique, membres.
- **Live Pay** (doc 06) : séquestre (mode A), encaissement instantané (mode B), versements, remboursements, grand livre.
- **Live Confiance** : modération, produits interdits, réclamations, avis, anti-fraude.
- **Live Feed** : vidéo produit avec bouton « Acheter ».
- **Live Chat** : offres de prix, lieu de rendez-vous, bouton « Payer ».
- **Notifications** : nouvelles commandes, rappels de remise, alertes de recherche et de baisse de prix.
- **Live Livraison** (P2).

**Fin du Document 10**
