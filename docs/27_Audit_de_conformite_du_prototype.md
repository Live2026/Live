# Document 27 — Audit de conformité du prototype

> Audit du 25/09/2026. Chaque exigence du cahier des charges (document 05) et des piliers (document 21) est rapprochée de l'écran qui la réalise dans le prototype `app/`. Les tests de bout en bout (`app/test_e2e/parcours.js`) ouvrent chaque écran cité, sur téléphone (360 px) et sur ordinateur (1 280 px).

Légende : **OK** couvert ; **Corrigé** manque ou défaut trouvé par l'audit et comblé ; **Back-end** l'écran est prêt, la règle est serveur (document 26).

## 1. Compte, fil, recherche, messagerie

| Réf. | Exigence | Écran | État |
|------|----------|-------|------|
| F-CPT-01 | Inscription par téléphone et OTP | `/telephone`, `/code` (SMS, appel, WhatsApp) | OK |
| F-CPT-02 | Profil, intérêts | `/profil`, `/interets`, `/parametres` | OK |
| F-CPT-03 | Code de l'application et code de paiement | `/pin` (confirmation) | OK |
| F-CPT-04, 05 | Vérification N2 et N3 | `/verifier`, `/admin/kyc` | OK |
| F-CPT-06, 07 | Espaces et rôles internes | `/espace/nouveau`, `/espace/equipe` | OK |
| F-CPT-08 | Suivre | `/abonnes/:id`, `/suivis` | OK |
| F-CPT-09 | Parrainage | Relations, lien d'invitation | OK |
| F-CPT-10 | Suppression du compte | `/donnees` | OK |
| F-FEED-01 à 07 | Fil vidéo, onglets, bouton d'action, partage, économie de données | Accueil, `/publier/media` | OK |
| F-RECH-01 à 04 | Recherche tolérante, filtres, alertes, carte | `/recherche`, `/alertes`, `/carte` | OK |
| F-CHAT-01 à 07 | Conversation liée à l'annonce, photo, note vocale, offre, paiement, alerte hors Live, blocage, réponses rapides | `/conversation`, `/messages/*` | OK |

## 2. Market, Immo, Services

| Réf. | Exigence | Écran | État |
|------|----------|-------|------|
| F-MKT-01 à 07 | Annonce, boutique, séquestre ou à la remise, suivi, QR de remise, variantes, catégories interdites | `/vendre`, `/boutique/:id`, `/commande/:id`, `/suivi/:id`, `/vente/:id/qr` | OK |
| F-IMMO-01 à 10 | Fiche, statut de l'annonceur, frais de visite séquestrés, créneaux, réservation, « Déjà loué », annonce masquée à 30 jours, espace agence, photos déjà utilisées, absence au rendez-vous | `/immo`, `/bien/:id`, `/visite/:id`, `/agence`, `/publier/bien` | OK |
| F-SRV-01 à 08 | Fiche, devis payable, acompte séquestré, fin de prestation, avis, agenda, demande publique de devis, trois schémas de paiement | `/services`, `/services/demande`, `/services/devis`, `/prestation/:id` | OK |

## 3. Argent

| Réf. | Exigence | Écran | État |
|------|----------|-------|------|
| F-PAY-01 à 03 | MTN MoMo, Airtel Money, Visa (3-D Secure) | `/payer`, `/payer/attente` | OK |
| F-PAY-04 | Séquestre | Commandes, visites, prestations | OK |
| F-PAY-05 | Solde : en attente, disponible, historique, reçus | **`/portefeuille` (Mon argent Live)**, `/gains`, `/recu/:id` | **Corrigé** |
| F-PAY-06 | Retrait vers son numéro, N2 | `/retirer` | OK |
| F-PAY-07 à 12 | Commission affichée, remboursement, boosts, échecs, réconciliation, payer à la remise | Paiement, `/admin/finance` | OK ; réconciliation : Back-end |

**Mon argent Live (corrigé).** Le solde n'avait pas d'écran à lui : on ne voyait que « Mes gains », pensé pour les vendeurs. L'écran `/portefeuille` réunit maintenant :

- le solde disponible, l'argent en attente (ventes non confirmées) et l'argent bloqué au séquestre pour ses propres achats ;
- les dépenses du mois par espace ;
- les moyens de paiement ;
- l'historique.

On y accède par une carte en tête de Moi et par Explorer › Argent et quotidien. Conformément à la décision D-15, il n'y a **pas de dépôt libre** : le solde se remplit par les ventes, les remboursements et les transferts reçus.

## 4. Confiance, Pro, notifications

| Réf. | Exigence | Écran | État |
|------|----------|-------|------|
| F-CONF-01 à 07 | Avis après transaction, signalement, litige, file de litiges, modération, badges, anti-fraude | `/avis/*`, `/probleme/*`, `/reclamation/:id`, `/admin/litiges`, `/admin/moderation` | OK ; anti-fraude : Back-end |
| F-PRO-01 à 03 | Boost, statistiques, abonnement Pro | `/mes-ventes`, `/live-pro/offres` | OK |
| F-NOTIF-01 à 03 | Push, SMS, préférences | `/notifications`, `/notifications/preferences` | OK ; envoi : Back-end |

## 5. Back-office (Super administrateur, direction générale)

| Réf. | Exigence | Écran | État |
|------|----------|-------|------|
| F-ADM-01 | 2FA, permissions par fonction | `/admin/connexion`, `/admin/equipe` | OK |
| F-ADM-02, 03 | Files de travail, gestion des utilisateurs | `/admin/kyc`, `/admin/moderation`, `/admin/litiges`, `/admin/utilisateurs` | OK |
| F-ADM-04, 05 | Configuration, finance, export comptable | `/admin/configuration`, `/admin/finance` | OK |
| F-ADM-06, 07 | Double validation, journal d'audit | `/admin/validations`, `/admin/journal` | OK |
| F-ADM-08 | Tableau de bord | `/admin` | **Corrigé** (tuiles alignées 3 + 3) |
| F-IA-11 | Coût réel par service, limites, remboursements en crédits, modération des demandes | **`/admin/ia`** | **Corrigé** |
| Doc. 21 | Supervision des piliers : transferts par devise, tontines, factures, achats groupés | **`/admin/quotidien`** | **Corrigé** |

Autre défaut corrigé : le menu latéral coupait « Retour à l'application » à 1 280 × 760. Les entrées sont désormais plus compactes.

## 6. Live IA

| Réf. | Exigence | Écran | État |
|------|----------|-------|------|
| F-IA-01 à 06, 08 à 10, 12 | Espace, packs, confirmation du prix, CV et lettres, exercice par photo, business plans, rédaction d'annonce, Mes documents, crédits offerts, tuteur vocal | `/ia`, `/ia/*` | OK |
| F-IA-07 | Résumé de document | **Assistant : fichier joint** | **Corrigé** |
| F-IA2-03, 04 | Assistant qui agit, voix en trois langues | **`/ia/assistant`** | **Corrigé** |

**Assistant (corrigé).** L'assistant était une simple liste de bulles avec un micro, et des choix de langue très visibles. Il fonctionne maintenant comme une vraie conversation :

- **Accueil** : un accueil nominatif et des suggestions.
- **Réponses** : pleine largeur, avec des points, une note et des actions ; outils sous chaque réponse (copier, écouter, bien ou pas, régénérer).
- **Zone de saisie** : sur plusieurs lignes, avec les boutons :
  - **+** (photo, appareil photo, fichier, Mes documents) ;
  - dictée ;
  - **mode vocal** plein écran, pour discuter à voix haute.
- **Fichiers acceptés** : PDF, Word, Excel, PowerPoint, texte, Markdown, CSV et image. La lecture est payée en crédits après accord sur le prix (5, 10 ou 20 selon la longueur, F-IA-03).
- **Langue** (français, lingala, kituba) : choisie dans un menu et dans le mode vocal.
- **Conversations récentes** : dans un volet à gauche sur ordinateur.

## 7. Piliers (document 21)

| Réf. | Écran | État |
|------|-------|------|
| F-TON-01 à 06 | `/tontines`, `/tontine/:id`, `/achats-groupes` | OK |
| F-DIA-01 à 06 | `/diaspora`, `/transfert` (10 devises, Envoyer et Recevoir) | OK ; partenaire : Back-end |
| F-QUO-01 à 04 | `/factures`, `/adresse`, `/points-relais` | OK |
| F-CAR-01, 02 | `/carte`, `/rue`, `/livraison/:id` | OK ; Google Maps : Back-end |

## 8. Cohérence d'ensemble (défauts transversaux corrigés)

- **Grilles** : une carte ne reste plus seule sur la dernière ligne (6 cartes : 3 + 3 plutôt que 5 + 1). La règle est appliquée par `GrilleAdaptative` à toute l'application.
- **En-têtes** : l'onglet Moi a maintenant le bouton Messages, comme Accueil, Explorer et IA.
- **Accessibilité** : le bouton de devise de Live Transfert avait perdu son nœud sémantique, parce qu'il était fusionné avec la carte. Il est corrigé et vérifié par les tests de bout en bout.

## 9. Ce qui reste, par nature, au back-end

Envoi réel des SMS (Twilio Verify), paiements réels (API MTN et Airtel), grand livre et réconciliation, vidéo (Mux), cartes et positions en direct (Google Maps, Supabase Realtime), partenaire de transfert agréé, modèles d'IA. L'ordre de construction est fixé par le document 26, §7.

**Fin du Document 27**
