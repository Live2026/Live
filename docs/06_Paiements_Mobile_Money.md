# Document 06 — Paiements : MTN MoMo, Airtel Money, Visa et séquestre

> ⚠️ Ce document énonce des principes de conception. Le **montage juridique définitif** doit être validé par un avocat spécialisé en réglementation bancaire CEMAC et par le partenaire de paiement retenu.

## 1. Objectif

Faire circuler l'argent dans Live de façon **simple pour l'utilisateur**, **sûre pour tous** et **conforme à la réglementation**, avec trois moyens de paiement : **MTN Mobile Money**, **Airtel Money** et **Visa**.

---

## 2. Le point réglementaire à ne pas manquer

En zone CEMAC, les services de paiement et l'émission de monnaie électronique sont encadrés par la **BEAC** et la **COBAC** (règlement relatif aux services de paiement dans la CEMAC). Concrètement :

- **Conserver l'argent du public** sur un « portefeuille » où il peut déposer librement et duquel il peut retirer est une activité **réservée aux établissements agréés** (banques, établissements de paiement, émetteurs de monnaie électronique).
- Live **ne doit donc pas**, au lancement, se présenter comme une banque ni proposer des « dépôts » libres.

### Montage recommandé pour le MVP

| Élément | Choix |
|---------|-------|
| Encaissement / décaissement | Via un **agrégateur de paiement agréé** couvrant le Congo (MTN, Airtel, Visa), ou via des **contrats marchands directs** avec MTN et Airtel |
| Où est l'argent ? | Sur un **compte de cantonnement / séquestre** ouvert chez une **banque partenaire** ou chez l'agrégateur, **séparé** des fonds propres de Live |
| Ce que Live gère | Un **grand livre interne** qui attribue à chaque vendeur sa part (en attente ou disponible) : une **créance** payable à la demande, et non un compte de dépôt |
| Dépôts libres | **Non** au MVP : chaque encaissement correspond à un achat précis |
| Évolution (phase 3) | Portefeuille complet (dépôts, transferts entre utilisateurs, paiements en magasin) **uniquement** avec un partenaire émetteur agréé, ou après obtention d'un agrément propre |

**Conséquence sur le vocabulaire** : dans l'application, on parle de **« Mes gains »** ou de **« Solde vendeur »**, et non de « compte » ni de « dépôt ».

---

## 3. Choix de l'intégration technique

| Option | Avantages | Inconvénients | Recommandation |
|--------|-----------|---------------|----------------|
| **A. Agrégateur unique** (MTN + Airtel + Visa via une seule API) | Une intégration, un contrat, Visa inclus, conformité partagée | Commission de l'agrégateur en plus, dépendance | ✅ **MVP** |
| **B. API directes** MTN MoMo (collections et disbursements) + Airtel Money + acquéreur Visa | Frais plus bas, contrôle total | 3 contrats, 3 intégrations, délais d'homologation longs | Phase 2, lorsque les volumes le justifient |
| **C. Hybride** | Le meilleur tarif par canal ; redondance | Complexité | Cible à moyen terme |

**Architecture exigée dès le MVP** : une **couche d'abstraction « fournisseur de paiement »** dans le code, pour pouvoir changer d'agrégateur ou ajouter une API directe **sans toucher aux modules métier**. C'est la **stratégie de réversibilité** évoquée dans la v1.

**Décision D-11 — choix de l'agrégateur**

Candidats identifiés (recherche de septembre 2026, **à confirmer par écrit auprès de chaque prestataire**) :

| Candidat | Ce qui est connu | Limite |
|----------|------------------|--------|
| **CinetPay** | Agrégateur très répandu en Afrique francophone, présent au Congo ; regroupe Mobile Money et cartes. | Couverture Visa **au Congo** et décaissements vers MTN et Airtel à confirmer. |
| **pawaPay** (filiale Kerry Payments Brazzaville) | Autorisation d'agrégateur de paiement accordée par l'**ARPCE** en juin 2026 ; API unique vers les opérateurs Mobile Money du Congo. | Mobile Money seulement : Visa via un autre prestataire. |
| **API directes MTN MoMo et Airtel Money** | Frais les plus bas, contrôle total. | Contrats et homologation plus longs ; Visa séparé. |

**Décision retenue :**
1. **Consulter CinetPay et pawaPay en parallèle** (devis, contrat type, environnement de test) dès la création de la société.
2. **Choix par défaut : CinetPay**, s'il confirme **MTN + Airtel + Visa au Congo, avec décaissements** : c'est la seule option qui couvre tout avec une seule intégration.
3. **Sinon : pawaPay pour MTN et Airtel** (agrément ARPCE local) **+ un prestataire carte pour Visa**, rendu possible par la couche d'abstraction.
4. **Passage aux API directes MTN et Airtel** lorsque le volume dépasse environ 100 transactions par jour (réduction des frais).
5. ⚠️ Une autorisation ARPCE d'agrégateur **technique** ne remplace pas le cadre BEAC/COBAC pour la **détention des fonds** : le compte séquestre reste ouvert chez une **banque partenaire agréée**.

Critères de comparaison :
- couverture effective de MTN, d'Airtel **et** de Visa au Congo ;
- agrément et solidité financière ;
- frais d'encaissement **et** de décaissement (payouts vers MoMo et Airtel) ;
- délai de reversement ;
- qualité de l'API (notifications de retour, idempotence, environnement de test) ;
- support local.

---

## 4. Parcours de paiement

### 4.1 Paiement Mobile Money (MTN ou Airtel)
1. L'acheteur choisit « MTN MoMo » ou « Airtel Money » ; son numéro est prérempli.
2. Live crée une **intention de paiement** (avec une clé d'idempotence) et appelle le fournisseur.
3. L'acheteur reçoit sur son téléphone une **demande de confirmation** (USSD ou notification de l'opérateur) et saisit son **code secret Mobile Money** : Live ne voit jamais ce code.
4. Le fournisseur notifie Live (webhook signé) : **succès** ou **échec**.
5. En cas d'absence de réponse, Live **interroge** le statut (sans jamais relancer un débit).
6. Succès : écriture au grand livre, fonds **séquestrés**, notification du vendeur.

### 4.2 Paiement Visa
1. Redirection vers la **page de paiement sécurisée** du fournisseur (3-D Secure).
2. **Aucune donnée de carte ne transite par les serveurs de Live ni n'y est stockée** : Live reste hors du périmètre PCI-DSS lourd.
3. Retour, puis webhook : même suite que le Mobile Money.

### 4.3 Retrait (payout)
1. Le vendeur (N2 minimum) demande un retrait depuis son solde disponible vers **son** numéro MTN ou Airtel (nom du titulaire identique au KYC).
2. Contrôles : PIN de paiement, plafonds, règles anti-fraude, éventuelle revue manuelle.
3. Appel de l'API de décaissement du fournisseur, puis webhook, écriture au grand livre et reçu.
4. En cas d'échec, le montant est recrédité au solde, avec un message clair.

---

## 5. Cycle de vie d'une transaction séquestrée

```
CRÉÉE ─► PAIEMENT_EN_COURS ─► PAYÉE_SÉQUESTRÉE ─► REMISE_DÉCLARÉE ─► CONFIRMÉE ─► FONDS_DISPONIBLES
              │                     │                    │
              ▼                     ▼                    ▼
           ÉCHOUÉE            ANNULÉE (remboursée)    EN_LITIGE ─► REMBOURSÉE (totalement ou en partie)
                                                          └──────► LIBÉRÉE AU VENDEUR
```

**Règles**
- R-PAY-01 : sans litige, la confirmation est **automatique** après le délai propre à la verticale (produit : 48 h après la remise déclarée ; service : 24 h ; visite : immédiate par code).
- R-PAY-02 : la commission Live n'est **définitivement acquise** qu'au passage à CONFIRMÉE ou LIBÉRÉE.
- R-PAY-03 : un remboursement renvoie les fonds **vers le moyen de paiement d'origine** lorsque c'est techniquement possible.
- R-PAY-04 : aucune transition d'état ne se fait sans l'**écriture comptable** correspondante.

---

## 6. Grand livre (exigence technique critique)

- **Comptabilité en partie double** : chaque mouvement débite un compte et en crédite un autre (compte séquestre, solde vendeur, commission Live, frais opérateur, remboursements…).
- **Les soldes sont calculés** à partir des écritures, jamais modifiés directement.
- **Idempotence** de toutes les opérations (un même webhook reçu deux fois n'a qu'un seul effet).
- **Réconciliation quotidienne** : total des écritures = relevé du fournisseur = solde du compte séquestre. Tout écart déclenche une alerte et une investigation.
- Montants stockés en **entiers de FCFA** (pas de nombres à virgule).

---

## 7. Plafonds et contrôles (hypothèses)

| Niveau | Encaissement par mois | Retrait par jour | Retrait par mois |
|--------|----------------------|------------------|------------------|
| N1 | 100 000 FCFA | — | — |
| N2 | 2 000 000 FCFA | 500 000 FCFA | 2 000 000 FCFA |
| N3 | Sur étude | Sur étude | Sur étude |

À aligner sur les plafonds des opérateurs et sur les exigences LBC/FT du partenaire.

---

## 8. Gestion des incidents

| Situation | Comportement |
|-----------|--------------|
| Opérateur indisponible | Message clair, proposition d'un autre moyen de paiement, file de reprise |
| Débit sans notification | Interrogation du statut, puis ticket automatique ; jamais de double débit |
| Retrait échoué | Recrédit automatique et notification |
| Écart de réconciliation | Gel des retraits concernés, alerte finance, investigation |
| Fraude suspectée | Gel de la capacité C-RETIRER, revue manuelle, conservation des preuves |

---

## 9. Conformité (à valider par un juriste)

- Contrat avec un **partenaire agréé** et répartition claire des responsabilités (KYC, LBC/FT, déclaration de soupçon).
- **KYC** avant tout retrait ; conservation des justificatifs pendant la durée légale.
- Respect de la loi congolaise sur la **protection des données à caractère personnel**.
- Conditions générales de vente et de paiement, politique de remboursement et procédure de litige publiées.
- Aspects fiscaux : statut des commissions Live (TVA), éventuelles obligations déclaratives concernant les revenus des vendeurs.

**Fin du Document 06**
