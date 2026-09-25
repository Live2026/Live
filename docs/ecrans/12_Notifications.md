# Écrans — 12. Notifications

Exigences : F-NOTIF-01 à F-NOTIF-03 ; envoi par file d'attente et regroupement (document 20, section 8).

---

## E-NOTIF-01 — Centre de notifications

Accessible depuis l'onglet Moi (ligne « Notifications ») et par un appui sur une notification push.

```text
┌──────────────────────────────────────────┐
│ ◀  Notifications      (Tout marquer lu)  │
├──────────────────────────────────────────┤
│ [•Tout] [Argent] [Activité] [Alertes]    │
├──────────────────────────────────────────┤
│ AUJOURD'HUI                              │
│ ● ✓ Paiement reçu : 79 900 FCFA          │
│     Vente iPhone 11 · disponible         │
│     10:42                                │
│ ● Nouvelle commande : Robe wax ×2        │
│     Acceptez avant demain 09:30          │
│     09:31                                │
│   Visite demain 10:30 · 2 ch.            │
│     Moungali. Code : dans l'appli        │
│     08:00                                │
├──────────────────────────────────────────┤
│ HIER                                     │
│   3 nouveaux logements pour votre        │
│     alerte « 2 ch. Moungali »            │
│   Serge a envoyé un devis :              │
│     25 000 FCFA                          │
│   Merveille et 12 autres aiment          │
│     votre vidéo                          │
└──────────────────────────────────────────┘
```

| Onglet | Contenu |
|--------|---------|
| Argent | Paiements, gains disponibles, retraits, remboursements |
| Activité | Commandes, visites, prestations, messages, avis |
| Alertes | Recherches sauvegardées, baisses de prix |

---

## E-NOTIF-02 — Préférences

```text
┌──────────────────────────────────────────┐
│ ◀  Notifications                         │
├──────────────────────────────────────────┤
│                          Push  SMS       │
│ Paiements et retraits    [ON] [ON]       │
│ Commandes, visites,                      │
│ prestations              [ON] [OFF]      │
│ Messages                 [ON]  -         │
│ Alertes de recherche     [ON]  -         │
│   Fréquence [▼ Immédiate   ]             │
│ Baisses de prix          [ON]  -         │
│ J'aime, abonnés          [OFF] -         │
│ Offres et nouveautés     [OFF] -         │
├──────────────────────────────────────────┤
│ Heures de silence                        │
│ [x] 22:00 → 07:00                        │
│ (sauf paiements et sécurité)             │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| SMS | Réservés aux événements critiques (coût) : code de connexion, paiement reçu, retrait, litige (F-NOTIF-02) ; les SMS de sécurité ne sont pas désactivables |
| Regroupement | Les notifications sociales sont regroupées (« Merveille et 12 autres ») |
