# Document 26 — Back-end : modèle de données, base locale (Drift) et synchronisation

> Rédigé le 25/09/2026, à la fin de la maquette complète (prototype `app/`, mobile et ordinateur). Ce document complète le document 20 (architecture technique) : il fixe **comment on passe du prototype à l'application branchée sur Supabase**, ce que la base locale **Drift** garde sur le téléphone, et comment les deux restent d'accord.

## 1. Point de départ

- **Ce qui est fait** : le front-end sous forme de maquette complète et cliquable. Tous les écrans, tous les parcours et les règles d'affichage (où se paie chaque somme, super-pouvoirs, commissions) sont en place. 44 tests Flutter et 6 parcours de bout en bout le vérifient.
- **Ce qui ne l'est pas** : aucune donnée n'est réelle. Tout vient de `app/lib/data/` (données fictives et `LiveStore`, un état unique en mémoire). Il n'y a encore ni compte, ni paiement, ni message qui quitte le téléphone.
- **Principe qui ne change pas** (document 20, §1) : **le serveur est la seule vérité pour l'argent**. Drift sert au confort (vitesse, hors ligne, brouillons) et ne décide jamais d'un solde.

## 2. Les couches de l'application réelle

```
Écran (inchangé)            ← widgets de app/lib/shared et features/
  │ observe
Contrôleur Riverpod         ← un par domaine : market, immo, pay, chat…
  │ appelle
Dépôt (interface Dart)      ← DepotMarket, DepotPaiement, DepotTontine…
  ├── Source locale  : Drift (SQLite)           cache, brouillons, file d'envoi
  └── Source distante: Supabase                 PostgREST, RPC, Realtime, Storage
```

- Les écrans ne parlent **jamais** directement à Supabase ni à Drift : ils observent un contrôleur, qui passe par un **dépôt**.
- Chaque dépôt a **deux implémentations** : `…Demo`, qui reprend les données actuelles du prototype, et `…Supabase`, la vraie. Les tests et la galerie gardent la première. On bascule domaine par domaine, sans casser l'application.
- `LiveStore` est découpé en contrôleurs par domaine au fil du branchement. Il disparaît quand le dernier domaine est branché.

## 3. Drift : ce que le téléphone garde

Drift est déjà retenu (document 20, §3.2). Il est typé, relationnel, testable et migré par versions, et ses requêtes sont **observables** (flux). Il fonctionne sur Android, iOS, ordinateur et web (WebAssembly).

### 3.1 Tables locales

| Table | Contenu | Durée de vie |
|-------|---------|--------------|
| `annonce_cache` | Produits, biens et services déjà vus (fiche, photo de couverture, prix, vendeur) | 7 jours, 50 Mo au plus (les moins consultés partent en premier) |
| `fil_cache` | Dernière page de l'accueil et d'Explorer | Remplacée à chaque rafraîchissement |
| `brouillon` | Annonces, demandes et avis en cours d'écriture, avec les chemins des photos et vidéos locales | Jusqu'à la publication (NF-03) |
| `file_envoi` | Actions faites sans réseau : identifiant unique, type, contenu JSON, tentatives, état | Jusqu'à la confirmation du serveur |
| `conversation`, `message` | Conversations ouvertes et leurs 200 derniers messages | 30 jours sans ouverture |
| `favori`, `alerte`, `recherche_recente` | Enregistrés, alertes, dernières recherches | Synchronisés |
| `profil_moi`, `parametre` | Mon profil, mes espaces et rôles, langue, ville, devise d'envoi, économie de données | Synchronisés |
| `taux_devise` | Derniers taux connus (affichage seulement), avec leur heure | Rafraîchis à l'ouverture de Live Transfert |
| `notification` | Dernières notifications | 30 jours |

### 3.2 Ce que Drift ne garde jamais comme vérité

- **Soldes, grand livre, séquestre, statut d'un paiement, cotisations de tontine, crédits Live IA** : on peut afficher la dernière valeur connue, marquée « au dernier passage, hh:mm ». Toute action sur l'argent **exige le réseau** et la réponse du serveur.
- **Pièces d'identité, code secret, clés d'API** : jamais sur le téléphone. Le code secret est vérifié côté serveur (document 20, §4.2).
- **Back-office** (Flutter Web) : **pas de base locale**. Il travaille en ligne uniquement, parce que ses données sont sensibles et qu'un poste d'agent peut être partagé.

### 3.3 Protection

- Base chiffrée avec **SQLCipher** (`sqlcipher_flutter_libs`), clé tirée au premier lancement et gardée dans le coffre du téléphone (`flutter_secure_storage`).
- « Se déconnecter » et « Supprimer mon compte » effacent la base locale.

## 4. Synchronisation

| Sens | Règle |
|------|-------|
| **Lecture** | Cache d'abord, réseau ensuite : l'écran s'affiche tout de suite depuis Drift, puis se met à jour (premier écran utile en moins de 3 s en 3G, NF-01). |
| **Mises à jour** | Chaque table serveur a `updated_at` et `deleted_at` (suppression logique). L'application demande « ce qui a changé depuis mon dernier passage », table par table. |
| **Temps réel** | Supabase Realtime (messages, statut des commandes et des visites, position du livreur) **écrit dans Drift** ; l'écran observe Drift. Une seule source pour l'interface. |
| **Écriture** | Toute action passe par `file_envoi` avec une **clé d'idempotence** (UUID v7 créé sur le téléphone), puis par une fonction Postgres qui l'accepte une seule fois. Une coupure réseau ne crée ni doublon ni perte. |
| **Conflits** | Le serveur gagne, sauf pour les brouillons, qui n'existent que sur le téléphone. |
| **Argent** | Pas de file d'envoi : paiement, cotisation, transfert et retrait se font en ligne, avec un écran d'attente et la confirmation du serveur (webhook de l'opérateur). |

**Solution clé en main évaluée : PowerSync.** Il synchronise Postgres et SQLite, s'intègre à Supabase et accepte Drift. On commence avec la synchronisation décrite ci-dessus, qui est simple et maîtrisée. On passe à PowerSync si le nombre de tables synchronisées ou les conflits deviennent lourds, sans changer les écrans, parce que les dépôts isolent ce choix.

**Écartés** : Hive et Isar (pas relationnels, suivi incertain) et le cache HTTP seul (ni hors ligne, ni file d'envoi).

## 5. Modèle de données serveur (PostgreSQL, schémas du document 20, §4.1)

Montants : **entiers de francs CFA** partout. Une somme en devise étrangère est stockée en `numeric(18,4)` avec son code ISO 4217 **et le taux utilisé**. Elle n'est jamais recalculée après coup.

| Schéma | Tables principales |
|--------|--------------------|
| `core` | `utilisateur`, `profil`, `niveau_kyc`, `espace`, `membre_espace` (rôle : propriétaire, gestionnaire, agent, modérateur, comptable), `capacite`, `ville`, `quartier`, `categorie`, `adresse_live` (code, position PostGIS, repère, photo) |
| `feed` | `publication`, `media` (identifiant Mux), `aime`, `commentaire`, `abonnement`, `direct`, `evenement_vue` (partitionnée par mois) |
| `market` | `produit`, `variante`, `commande`, `offre`, `achat_groupe`, `participation_groupe` |
| `immo` | `bien`, `condition_location`, `visite`, `sejour`, `reservation`, `alerte` |
| `services` | `prestataire`, `service`, `demande`, `devis`, `prestation` |
| `chat` | `conversation`, `participant`, `message`, `groupe`, `canal` |
| `trust` | `avis`, `signalement`, `reclamation`, `decision`, `verification` |
| `pay` (non exposé) | `intention`, `transaction`, `ecriture` (grand livre en partie double), `retrait`, `webhook_recu`, `transfert`, `taux_devise`, `facture_payee` |
| `tontine` | `tontine`, `membre`, `tour` (ordre, bénéficiaire, date), `cotisation` (liée à une écriture du grand livre), `penalite`, `vote` |
| `quotidien` | `compteur` (E2C, LCDE, décodeur), `facture`, `recharge`, `point_relais`, `depot_colis` |
| `ia` | `demande`, `credit_ecriture`, `document`, `cout` |
| `admin` (non exposé) | `agent`, `role`, `permission`, `validation` (double validation : `demandeur` ≠ `valideur`, contrainte en base), `audit` (ajout seul, aucune modification ni suppression) |

### 5.1 Live Transfert (`pay.transfert`)

| Colonne | Rôle |
|---------|------|
| `devise_source`, `montant_source` | Ce que l'envoyeur paie, dans sa devise (`EUR`, `USD`, `GBP`, `CAD`, `CHF`, `XOF`, `CNY`, `AED`, `ZAR`, `NGN`…) |
| `taux`, `taux_fixe`, `taux_bloque_jusqua` | Taux appliqué : fixe pour l'euro et le franc CFA d'Afrique de l'Ouest, sinon cotation du partenaire bloquée 30 minutes |
| `montant_xaf`, `frais_source` | Ce que le proche reçoit en francs CFA ; frais Live (hypothèse : 2 %) |
| `moyen_paiement` | Carte, virement, Mobile Money étranger |
| `mode_retrait` | MTN MoMo, Airtel Money, solde Live |
| `partenaire`, `reference_partenaire`, `statut` | Suivi auprès du partenaire agréé : coté, payé, crédité, retiré, remboursé |

## 6. Fournisseurs derrière des interfaces

| Interface | Implémentation retenue ou à choisir |
|-----------|-------------------------------------|
| `PaymentProvider` (initier, statut, rembourser, décaisser, vérifier la signature) | **API directes MTN MoMo et Airtel Money** (décision du promoteur) |
| `TransfertInternationalProvider` (coter, initier, statut, webhook) | **À choisir** : un réseau de transfert vers le Mobile Money agréé en zone CEMAC (candidats à évaluer : Thunes, TerraPay, Onafriq), et un prestataire carte pour l'encaissement en devises |
| `OtpProvider` | Twilio Verify (SMS, appel, WhatsApp) |
| `VideoProvider` | Mux |
| `CarteProvider` | Google Maps Platform |
| `IaFournisseur` | Document 19 |

Le prototype est déjà prêt pour le transfert : choix de la devise, taux fixe ou taux du jour, moyen de paiement, mode de retrait, et côté pays la réception et le retrait. Brancher le partenaire revient à écrire `TransfertInternationalProvider` ; les écrans ne bougent pas.

## 7. Ordre de construction

| Étape | Contenu | Écrans branchés |
|-------|---------|-----------------|
| 1. Socle | Projets Supabase (développement, préproduction, production), migrations versionnées, Auth par téléphone avec Twilio Verify, profils, RLS et ses tests, base Drift, dépôts `…Demo` | Démarrage, Moi, Paramètres |
| 2. Market | Produits, recherche PostgreSQL, Storage des photos, brouillons et file d'envoi | Market, Vendre, fiche produit |
| 3. Argent | Grand livre, séquestre, `PaymentProvider` MTN et Airtel, webhooks, réconciliation | Paiement, solde, retraits, commandes |
| 4. Messages | Conversations en temps réel, cache Drift | Messages, groupes |
| 5. Immo et Services | Biens, visites, séjours, prestataires, devis | Live Immo, Live Services |
| 6. Vidéo | Mux : envoi reprenable, lecture adaptative, directs | Accueil, Directs, Studio |
| 7. Back-office | Agents, rôles, double validation, journal d'audit, 2FA | Administration |
| 8. Quotidien | Factures, recharge, Adresse Live, points relais, cartes Google | Argent et quotidien |
| 9. Tontines et achats groupés | Cotisations au grand livre, versements planifiés (pg_cron) | Tontines |
| 10. Diaspora et transfert | Encaissement par carte en devises, puis Live Transfert avec le partenaire agréé | Diaspora, Live Transfert |

Chaque étape se termine comme aujourd'hui : analyse, tests, tests de bout en bout, galerie. On y ajoute les **tests pgTAP** du grand livre et de la RLS.

## 8. État d'avancement (25/09/2026)

| Élément | État |
|---------|------|
| Couche dépôt (`app/lib/data/depots/depots.dart`) | Fait : réglages, brouillons, favoris, file d'envoi ; version en mémoire et version Drift |
| Base locale Drift (`app/lib/data/local/base_locale.dart`) | Fait : tables `parametres`, `brouillons`, `favoris`, `file_envoi` ; schéma v1 ; web par `sqlite3.wasm` et `drift_worker.js` (dossier `web/`) |
| Premier domaine branché | Fait : ville, devise, économie de données, centres d'intérêt et favoris gardés entre deux ouvertures ; brouillon de vente repris à l'ouverture de « Vendre » |
| Tests | Dépôts Drift sur SQLite en mémoire ; réouverture de l'application simulée |
| À suivre | Tables `annonce_cache`, `conversation`, `message`, `notification` ; chiffrement SQLCipher (§3.3) ; rejouer la file d'envoi au retour du réseau quand Supabase sera branché |

**Fin du Document 26**
