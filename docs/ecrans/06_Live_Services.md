# Écrans — 06. Live Services

Parcours prestataires (document 12). Promesse : **« Un prestataire vérifié, un prix clair, un acompte protégé, et un recours si le travail n'est pas fait. »**

---

## E-SRV-01 — Accueil Services

```text
┌──────────────────────────────────────────┐
│ ◀  Services        [⌕ Métier, besoin ]   │
├──────────────────────────────────────────┤
│ ┌──────────────────────────────────┐     │
│ │ Décrivez votre besoin et recevez │     │
│ │ des devis de pros vérifiés.      │     │
│ │      [ Demander des devis ]      │     │
│ └──────────────────────────────────┘     │
│                                          │
│ Métiers                                  │
│ [Plombier][Électricien][Clim/Froid]      │
│ [Réparation tél.][Mécanicien]            │
│ [Coiffure/Tresses][Maquillage]           │
│ [Traiteur][Déco][Photo/Vidéo]  Tout ▶    │
│                                          │
│ Disponibles maintenant          Tout ▶   │
│ ( ▒) Bruno · Frigoriste ✓  ★4,8          │
│      Talangaï · répond en 15 min         │
│ ( ▒) Sandra · Tresses ✓    ★4,9          │
│      Bacongo · à domicile                │
│                                          │
│ Mes demandes en cours            ▶       │
│ Fuite d'eau cuisine · 3 devis reçus      │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

---

## E-SRV-02 — Profil prestataire

```text
┌──────────────────────────────────────────┐
│ ◀                           ↗   ♡  ⋮     │
├──────────────────────────────────────────┤
│ ( ▒▒ ) Bruno Nkounkou                    │
│        Frigoriste · Climatisation        │
│        ✓ Identité vérifiée               │
│        ✓ Qualification vérifiée          │
│        ★ 4,8 (57 avis) · 83 presta.      │
│        Répond en moins d'1 h             │
│        Intervient : Talangaï, Ouenzé,    │
│        Djiri, Moungali                   │
├──────────────────────────────────────────┤
│ [Services] [Réalisations] [Avis]         │
├──────────────────────────────────────────┤
│ Installation clim split                  │
│ À partir de 25 000 FCFA · 2 h            │
│                       [ Réserver ]       │
│ Recharge de gaz                          │
│ 15 000 FCFA · 1 h     [ Réserver ]       │
│ Diagnostic panne                         │
│ Déplacement 3 000 FCFA (déduit           │
│ si travaux)           [ Réserver ]       │
│ Autre besoin ?     (Demander un devis)   │
├──────────────────────────────────────────┤
│ (Écrire)                                 │
└──────────────────────────────────────────┘
```

| Onglet | Contenu |
|--------|---------|
| Services | Prix fixes (réservation directe, E-SRV-06) ou sur devis |
| Réalisations | Photos et vidéos avant/après, publiables dans le fil avec « Réserver » |
| Avis | Notes par critère : ponctualité, qualité, propreté, respect du prix (F-SRV-CONF-06) |

---

## E-SRV-03 — Demande de devis (formulaire)

```text
┌──────────────────────────────────────────┐
│ ✕  Demander des devis                    │
├──────────────────────────────────────────┤
│ Métier      [▼ Plomberie             ]   │
│                                          │
│ Décrivez le problème                     │
│ [ Fuite sous l'évier de la cuisine,      │
│   l'eau coule en continu depuis          │
│   hier soir.                      ]      │
│                                          │
│ Photos ou vidéo (recommandé)             │
│ [ ▒▒ ] [ ▒▒ ] [ + ]                      │
│                                          │
│ Quartier    [▼ Moungali              ]   │
│ Quand ?     (•) Dès que possible         │
│             ( ) Date : [ __/__/__ ]      │
│ Budget (facultatif)                      │
│             [ 20 000 ] à [ 40 000 ]      │
├──────────────────────────────────────────┤
│ Votre adresse exacte n'est donnée        │
│ qu'au prestataire que vous choisirez.    │
├──────────────────────────────────────────┤
│ [   Envoyer à des pros vérifiés  ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Diffusion | Aux prestataires vérifiés de la catégorie dont la zone couvre le quartier (R-SRV-08) |
| Limite | Les 5 premiers devis ; la demande expire après 72 h (F-SRV-DEM-02, 04) |
| Confirmation | « Demande envoyée à 12 pros. Vous serez prévenu à chaque devis. » |

---

## E-SRV-04 — Comparer les devis

```text
┌──────────────────────────────────────────┐
│ ◀  Fuite d'eau cuisine                   │
├──────────────────────────────────────────┤
│ 3 devis reçus · expire dans 61 h         │
│ Trier : [•Prix] [Note] [Date]            │
├──────────────────────────────────────────┤
│ ( ▒) Paul ✓ ★4,6 (22)       Mardi        │
│      Total          18 000 FCFA          │
│      dont matériel   6 000               │
│      Acompte         5 000               │
│                      [ Voir ]            │
├──────────────────────────────────────────┤
│ ( ▒) Serge ✓ ★4,9 (71)    Aujourd'hui    │
│      Total          25 000 FCFA          │
│      dont matériel   8 000               │
│      Acompte        10 000               │
│                      [ Voir ]            │
├──────────────────────────────────────────┤
│ ( ▒) Didier ✓ ★4,2 (9)      Demain       │
│      Total          15 000 FCFA          │
│      Payer à la fin                      │
│                      [ Voir ]            │
├──────────────────────────────────────────┤
│ (Annuler la demande)                     │
└──────────────────────────────────────────┘
```

---

## E-SRV-05 — Détail du devis et acceptation

```text
┌──────────────────────────────────────────┐
│ ◀  Devis de Serge ✓ ★4,9                 │
├──────────────────────────────────────────┤
│ Réparation fuite évier cuisine           │
│ Intervention : aujourd'hui 16:00         │
│ Durée estimée : 1 h 30                   │
│                                          │
│ Main-d'œuvre           17 000 FCFA       │
│ Matériel (siphon, joints) 8 000 FCFA     │
│ TOTAL                  25 000 FCFA       │
│                                          │
│ Paiement                                 │
│ Acompte à payer maintenant 10 000        │
│ Solde après les travaux    15 000        │
│                                          │
│ Annulation : gratuite jusqu'à 2 h        │
│ avant. Garantie : 72 h après la fin.     │
├──────────────────────────────────────────┤
│ [Protégé par Live] L'acompte est         │
│ bloqué. La part matériel est versée      │
│ au démarrage (avec votre code), le       │
│ reste à la fin des travaux.              │
├──────────────────────────────────────────┤
│ (Écrire)     [ Accepter et payer ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Schémas de paiement | Affiché selon le devis : tout d'avance, acompte + solde, ou payer à la fin (DS-01) |
| Part matériel | Mentionnée seulement si le prestataire est éligible au déblocage anticipé (F-SRV-PAY-04) |
| Accepter | Paiement de l'acompte (E-PAY-01) ; les autres devis sont refusés automatiquement avec un message poli |

---

## E-SRV-06 — Réserver un service à prix fixe

```text
┌──────────────────────────────────────────┐
│ ◀  Recharge de gaz · Bruno ✓             │
├──────────────────────────────────────────┤
│ 15 000 FCFA · durée 1 h                  │
│                                          │
│ Choisissez un créneau                    │
│ [Lun 29] [•Mar 30] [Mer 1] [Jeu 2]       │
│ ( ) 08:00  (•) 10:00  ( ) 13:00          │
│ ( ) 15:00  ( ) 17:00                     │
│                                          │
│ Où ?                                     │
│ (•) À mon domicile                       │
│     Quartier [▼ Moungali ]               │
│     Adresse  [ ...               ]       │
│ ( ) À l'atelier (Talangaï)               │
│                                          │
│ Paiement                                 │
│ (•) Payer maintenant (bloqué)            │
│ ( ) Payer à la fin                       │
├──────────────────────────────────────────┤
│ Le prestataire confirme sous 12 h,       │
│ sinon vous êtes remboursé.               │
├──────────────────────────────────────────┤
│ [   Réserver · 15 000 FCFA       ]       │
└──────────────────────────────────────────┘
```

---

## E-SRV-07 — Suivi de la prestation (client)

```text
┌──────────────────────────────────────────┐
│ ◀  Prestation · Serge ✓                  │
├──────────────────────────────────────────┤
│ Réparation fuite · aujourd'hui 16:00     │
│                                          │
│  ✓ Acompte payé (10 000 bloqués)         │
│  ✓ Confirmée par Serge                   │
│  ● En route · arrivée ~15:55             │
│  ○ Travaux démarrés                      │
│  ○ Travaux terminés                      │
│  ○ Garantie 72 h                         │
│  ○ Terminé                               │
│                                          │
│ ┌──────────────────────────────────┐     │
│ │ Code de démarrage :  6 0 4 2     │     │
│ │ À donner quand Serge commence.   │     │
│ │ Il débloque la part matériel     │     │
│ │ (8 000 FCFA).                    │     │
│ └──────────────────────────────────┘     │
│                                          │
│ (Partager avec un proche)                │
│ (Appeler)  (Écrire)  (Signaler)          │
├──────────────────────────────────────────┤
│ [Protégé par Live]                       │
└──────────────────────────────────────────┘
```

| Étape | Écran |
|-------|-------|
| Démarrage | Le client donne le **code de démarrage** ; la part matériel est versée (F-SRV-PAY-04) |
| Fin | Le prestataire déclare la fin avec des photos ; s'il reste un solde, le client reçoit la demande de paiement MoMo ou Airtel ; puis un **code de fin** ou le bouton « Travaux conformes » s'affiche |
| Garantie | Compte à rebours de 72 h (ou 24 h selon le métier) avec le bouton « Signaler un problème » (E-CONF-03) |
| Partage | Envoie le nom, la photo, l'heure et le quartier du prestataire à un proche (F-SRV-EXEC-04) |

---

## E-SRV-08 — Créer un devis (prestataire)

```text
┌──────────────────────────────────────────┐
│ ◀  Devis pour : Fuite d'eau cuisine      │
├──────────────────────────────────────────┤
│ Client : Merveille ★4,9 · Moungali       │
│ (Voir la demande et les photos)          │
│                                          │
│ Lignes                                   │
│ Main-d'œuvre [ Réparation ] [17 000]     │
│ Matériel     [ Siphon+joints][ 8 000]    │
│ ( + Ajouter une ligne )                  │
│                                          │
│ Date     [ 30/09 ] à [ 16:00 ]           │
│ Durée    [ 1 h 30 ]                      │
│ Paiement (•) Acompte + solde             │
│          ( ) Tout d'avance               │
│          ( ) Payer à la fin              │
│ Acompte  [ 10 000 ] FCFA                 │
│ Annulation [▼ Gratuite jusqu'à 2 h ]     │
│ Validité [▼ 24 h ]                       │
├──────────────────────────────────────────┤
│ Total client          25 000 FCFA        │
│ Vous recevrez         23 000 FCFA        │
│ (25 000 - 8 % de commission Live)        │
├──────────────────────────────────────────┤
│ [        Envoyer le devis        ]       │
└──────────────────────────────────────────┘
```

---

## E-SRV-09 — Mes interventions (prestataire)

```text
┌──────────────────────────────────────────┐
│ ◀  Mes interventions                     │
├──────────────────────────────────────────┤
│ [Demandes 4] [Aujourd'hui 2] [Semaine]   │
├──────────────────────────────────────────┤
│ 16:00 · Fuite évier · Moungali           │
│ Merveille ★4,9 · acompte payé            │
│ ( Itinéraire )  [ Je suis en route ]     │
├──────────────────────────────────────────┤
│ 18:00 · Recharge gaz · Ouenzé            │
│ Jordy · payer à la fin                   │
│ ( Itinéraire )  [ Je suis en route ]     │
├──────────────────────────────────────────┤
│ NOUVELLE DEMANDE · il y a 5 min          │
│ Clim qui ne refroidit plus               │
│ Talangaï · dès que possible              │
│ ( Ignorer )     [ Faire un devis ]       │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Bouton | Suite |
|--------|-------|
| Je suis en route | Le client est prévenu (statut « En route ») |
| Sur place | « Saisir le code de démarrage » puis, à la fin, « Déclarer la fin des travaux » avec des photos avant/après et, le cas échéant, « Encaisser le solde » |
