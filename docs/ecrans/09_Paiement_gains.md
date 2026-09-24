# Écrans — 09. Paiement et gains

Les écrans où circule l'argent. Ils doivent être **les plus clairs et les plus rassurants** de l'application (document 06). Exigences : F-PAY-01 à F-PAY-12.

---

## E-PAY-01 — Choisir le moyen de paiement

```text
┌──────────────────────────────────────────┐
│ ◀  Paiement                              │
├──────────────────────────────────────────┤
│ iPhone 11 64 Go · Grâce Mode ✓           │
│ Total à payer          80 000 FCFA       │
├──────────────────────────────────────────┤
│ Payer avec                               │
│                                          │
│ (•) MTN Mobile Money                     │
│     06 123 45 67        (Modifier)       │
│ ( ) Airtel Money                         │
│     [ 05 ___ __ __                ]      │
│ ( ) Carte Visa                           │
│     Paiement sécurisé 3-D Secure         │
├──────────────────────────────────────────┤
│ [Protégé par Live] 80 000 FCFA           │
│ bloqués jusqu'à votre confirmation       │
│ de réception. Remboursés sinon.          │
├──────────────────────────────────────────┤
│ Code secret de paiement                  │
│       ●  ●  ○  ○                         │
├──────────────────────────────────────────┤
│ [      Payer 80 000 FCFA         ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Numéro | Pré-rempli avec le numéro du compte et l'opérateur détecté ; modifiable |
| PIN de paiement | Créé au premier paiement (4 chiffres, distinct du PIN de l'application) ; demandé à chaque paiement (F-CPT-03) |
| Visa | Ouvre la page sécurisée du prestataire de paiement ; **Live ne voit ni ne stocke la carte** (document 06, section 4.2) ; masqué si Visa n'est pas encore disponible (D-12) |
| Total | Identique au récapitulatif précédent ; aucun frais ajouté |

---

## E-PAY-02 — En attente de validation Mobile Money

```text
┌──────────────────────────────────────────┐
│       Validez sur votre téléphone        │
│                                          │
│    80 000 FCFA · MTN MoMo                │
│    06 123 45 67                          │
│                                          │
│    1. Ouvrez la demande MoMo             │
│       (ou tapez *105#)                   │
│    2. Tapez votre code secret MoMo       │
│                                          │
│             ◐  2:47                      │
│                                          │
│    ▶ Écouter l'explication               │
│                                          │
│    Live ne vous demandera JAMAIS         │
│    votre code secret MoMo.               │
│                                          │
├──────────────────────────────────────────┤
│ ( Je n'ai rien reçu )                    │
│ ( Annuler )                              │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Minuteur | 3 minutes ; au-delà, Live interroge le statut (sans jamais relancer un débit) puis affiche le résultat (F-PAY-10) |
| « Je n'ai rien reçu » | Propose de renvoyer la demande **seulement** si la première a expiré ou échoué ; sinon explique d'attendre |
| Code USSD | Affiché selon l'opérateur ; valeur à confirmer avec MTN et Airtel |
| Application fermée | Le paiement continue ; une notification annonce le résultat |

---

## E-PAY-03 — Résultat du paiement

**Réussi**

```text
┌──────────────────────────────────────────┐
├──────────────────────────────────────────┤
│                                          │
│                                          │
│               ✓                          │
│                                          │
│         Paiement réussi                  │
│                                          │
│       80 000 FCFA · MTN MoMo             │
│       Réf. LV-P-2026-0048213             │
│                                          │
│    L'argent est bloqué par Live.         │
│    Grâce Mode a été prévenue.            │
│    Elle doit accepter votre commande     │
│    dans les 24 h.                        │
│                                          │
├──────────────────────────────────────────┤
│ [      Suivre ma commande        ]       │
│ ( Voir le reçu )                         │
└──────────────────────────────────────────┘
```

**Échoué**

```text
┌──────────────────────────────────────────┐
├──────────────────────────────────────────┤
│                                          │
│                                          │
│               ✕                          │
│                                          │
│         Paiement non abouti              │
│                                          │
│    Solde insuffisant ou demande          │
│    refusée. Aucun montant n'a été        │
│    débité.                               │
│                                          │
├──────────────────────────────────────────┤
│ [          Réessayer             ]       │
│ ( Payer avec Airtel Money )              │
│ ( Payer par carte Visa )                 │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Messages d'échec | Traduits en langage simple selon le code renvoyé (solde insuffisant, délai dépassé, refus, opérateur indisponible) |
| Opérateur indisponible | « MTN MoMo rencontre un problème. Essayez Airtel Money ou la carte Visa. » (document 06, section 8) |

---

## E-PAY-04 — Mes gains

```text
┌──────────────────────────────────────────┐
│ ◀  Mes gains                  (?)        │
├──────────────────────────────────────────┤
│ Disponible                               │
│         184 500 FCFA                     │
│ [        Retirer                 ]       │
│                                          │
│ En attente              96 000 FCFA      │
│ (ventes et prestations pas encore        │
│ confirmées)                     ▶        │
├──────────────────────────────────────────┤
│ Ce mois-ci                               │
│ Ventes             212 000               │
│ Commissions Live   - 12 720              │
│ Retraits           - 150 000             │
├──────────────────────────────────────────┤
│ Historique              [Filtrer ▼]      │
│ + 79 900  Vente iPhone 11      hier      │
│           confirmée · reçu ▶             │
│ +  1 700  Visite 2 ch. Moungali  lun     │
│ - 150 000 Retrait MTN MoMo       lun     │
│           effectué · reçu ▶              │
│ + 23 000  Prestation (attente) 72 h      │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Détail |
|---------|--------|
| Disponible | Montant retirable (F-PAY-05) |
| En attente | Montants bloqués, avec pour chacun la date prévue de disponibilité |
| (?) | Explication simple : « Pourquoi mon argent est-il en attente ? » |
| Vocabulaire | « Mes gains », jamais « compte » ou « dépôt » (document 06, section 2) |
| Espaces | Un sélecteur permet de voir les gains personnels ou ceux d'une boutique ou agence dont on est propriétaire ou comptable |

---

## E-PAY-05 — Retirer

```text
┌──────────────────────────────────────────┐
│ ◀  Retirer mes gains                     │
├──────────────────────────────────────────┤
│ Disponible : 184 500 FCFA                │
│                                          │
│ Montant  [ 150 000             ] FCFA    │
│          [Tout retirer]                  │
│                                          │
│ Vers                                     │
│ (•) MTN MoMo  06 123 45 67               │
│     Grâce Mabiala ✓ (vérifié)            │
│ ( ) Airtel    05 987 65 43               │
│     Grâce Mabiala ✓ (vérifié)            │
│ ( + Ajouter un numéro à mon nom )        │
│                                          │
│ Montant envoyé         150 000 FCFA      │
│ Frais de retrait             0 FCFA      │
│ Vous recevez           150 000 FCFA      │
│                                          │
│ Plafond restant aujourd'hui :            │
│ 350 000 FCFA                             │
├──────────────────────────────────────────┤
│ Code secret de paiement                  │
│       ○  ○  ○  ○                         │
├──────────────────────────────────────────┤
│ [     Retirer 150 000 FCFA       ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Accès | Identité vérifiée (N2) obligatoire ; sinon E-PUB-07 (F-PAY-06) |
| Numéros | Uniquement des numéros **au nom du titulaire vérifié** (document 06, section 4.3) |
| Minimum | 1 000 FCFA (hypothèse, document 02) |
| Contrôle | Certains retraits passent en vérification manuelle : « Votre retrait est en cours de vérification (moins de 24 h). » |
| Échec | Montant recrédité automatiquement, avec un message clair |

---

## E-PAY-06 — Reçu

```text
┌──────────────────────────────────────────┐
│ ◀  Reçu                     (Partager)   │
├──────────────────────────────────────────┤
│ LIVE · Reçu de paiement                  │
│ Réf. LV-P-2026-0048213                   │
│ 30/09/2026 10:21                         │
│                                          │
│ Payé par      Merveille K.               │
│ Payé à        Grâce Mode (boutique)      │
│ Objet         Commande LV-00482          │
│               iPhone 11 64 Go            │
│ Montant       80 000 FCFA                │
│ Moyen         MTN MoMo ···· 4567         │
│ Réf. opérateur MP260930.1021.A1234       │
│ Statut        Bloqué par Live            │
│               (protection acheteur)      │
├──────────────────────────────────────────┤
│ ( Télécharger en PDF )                   │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Contenu | Toujours les deux références : Live et opérateur (utile en cas de réclamation auprès de MTN ou Airtel) |
| Côté vendeur | Même reçu, avec en plus le détail de la commission et le montant net |
