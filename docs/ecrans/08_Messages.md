# Écrans — 08. Messages

La messagerie remplace WhatsApp pour les échanges commerciaux : chaque conversation est **rattachée à une annonce**, et l'on peut **négocier et payer** sans la quitter. Exigences : F-CHAT-01 à F-CHAT-07.

---

## E-CHAT-01 — Conversations

```text
┌──────────────────────────────────────────┐
│ Messages                      [⌕]        │
├──────────────────────────────────────────┤
│ [•Tout] [Achats] [Ventes] [Pros]         │
├──────────────────────────────────────────┤
│ ( ▒) Grâce Mode ✓          10:42         │
│      ▒ iPhone 11 · Offre acceptée        │
│      Payer 80 000 FCFA           ●       │
├──────────────────────────────────────────┤
│ ( ▒) Agence Les Palmiers ✓  hier         │
│      ▒ 2 ch. Moungali                    │
│      Visite confirmée mardi 10:30        │
├──────────────────────────────────────────┤
│ ( ▒) Serge · Plombier ✓     hier         │
│      ▒ Devis 25 000 FCFA                 │
│      Vous : D'accord pour 16 h           │
├──────────────────────────────────────────┤
│ ( ▒) Jordy                  lun.         │
│      ▒ Pagne 6 yards (vous vendez)       │
│      Il est encore disponible ?          │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Détail |
|---------|--------|
| Filtres | Achats (je suis acheteur), Ventes (je suis vendeur), Pros (prestataires et agences) |
| Point ● | Action attendue de ma part (répondre, payer, accepter) |
| Espace | Si l'utilisateur gère une boutique ou une agence, un sélecteur en haut permet de basculer entre ses messages personnels et ceux de l'espace |

---

## E-CHAT-02 — Conversation liée à une annonce

```text
┌──────────────────────────────────────────┐
│ ◀ ( ▒) Grâce Mode ✓ · en ligne     ⋮     │
├──────────────────────────────────────────┤
│ ▒▒ iPhone 11 64 Go · 85 000 FCFA  ▶      │
├──────────────────────────────────────────┤
│             Bonjour, toujours dispo ?    │
│                           Vous 10:02     │
│ Oui ! Il est comme sur les photos.       │
│ Grâce 10:05                              │
│ ┌──────────────────────────────────┐     │
│ │ OFFRE · Vous proposez 75 000     │     │
│ │ Refusée par Grâce                │     │
│ └──────────────────────────────────┘     │
│ ┌──────────────────────────────────┐     │
│ │ CONTRE-OFFRE · Grâce : 80 000    │     │
│ │ Valable jusqu'à demain 10:30     │     │
│ │ (Refuser)        [ Accepter ]    │     │
│ └──────────────────────────────────┘     │
│          ▶ ▬▬▬▬▬▬▬▬▬ 0:12 (vocal)        │
│                           Vous 10:20     │
├──────────────────────────────────────────┤
│ [Protégé par Live] Payez uniquement      │
│ avec le bouton Payer.                    │
├──────────────────────────────────────────┤
│ (+) [ Écrire un message...    ] (♪) ➤    │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Carte de l'annonce | Toujours en haut ; un appui ouvre la fiche |
| Cartes d'action | Offre, contre-offre, **devis** (E-SRV-05), **offre de réservation** (E-IMMO-06), **lien de paiement**, **lieu de rendez-vous** : elles portent leurs propres boutons |
| Accepter une offre | Remplace la carte par : `[ Payer 80 000 FCFA ]` (F-CHAT-03, F-CHAT-04) |
| (♪) | Maintenir pour enregistrer un message vocal |
| (+) | Envoyer une photo, un vocal, un lieu de rendez-vous ; côté vendeur : une offre de prix ; côté prestataire : un devis |
| ⋮ | Voir le profil, Signaler, Bloquer, Supprimer la conversation |

### Alerte anti-arnaque (F-CHAT-05)

Quand un message contient un numéro de téléphone, « envoie par MoMo », « paie directement », etc. :

```text
┌──────────────────────────────────────────┐
│ ┌──────────────────────────────────┐     │
│ │ ⚠ Attention                      │     │
│ │ Ce message propose un paiement   │     │
│ │ en dehors de Live. Si vous payez │     │
│ │ hors de l'application, vous      │     │
│ │ n'êtes PAS protégé et vous ne    │     │
│ │ pourrez pas être remboursé.      │     │
│ │ (Signaler)          [ Compris ]  │     │
│ └──────────────────────────────────┘     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Affichage | Chez le destinataire, au-dessus du message concerné |
| Numéro de téléphone | Masqué par défaut dans le message tant qu'aucune transaction n'a eu lieu (D-07) ; affiché après un paiement, une visite ou une réservation confirmés |
| Répétition | Un utilisateur qui pousse régulièrement au paiement hors Live est signalé automatiquement à l'équipe Confiance |

---

## E-CHAT-03 — Proposer un lieu de rendez-vous

```text
┌──────────────────────────────────────────┐
│ ◀  Lieu de remise                        │
├──────────────────────────────────────────┤
│ Suggestions de lieux publics             │
│ près de vous deux :                      │
│                                          │
│ (•) Marché Total · Bacongo               │
│ ( ) Station Total Moungali               │
│ ( ) Rond-point de la Coupole             │
│ ( ) Autre : [ ...                ]       │
│                                          │
│ Date [ Aujourd'hui ] Heure [ 17:00 ]     │
├──────────────────────────────────────────┤
│ Conseil : préférez un lieu public        │
│ et vérifiez le produit avant de          │
│ donner votre code.                       │
├──────────────────────────────────────────┤
│ [         Proposer              ]        │
└──────────────────────────────────────────┘
```

La proposition apparaît dans la conversation sous forme de carte `(Refuser) [ Accepter ]`.
