# Document 21 — Les piliers qui font de Live la référence en Afrique centrale

> Décision du promoteur du 25/09/2026 (document 07, §12). Ce document complète le cahier des charges (document 05) : il décrit ce qui fait passer Live d'une **place de marché de confiance**, qu'on ouvre quand on a besoin d'acheter, à une **application de tous les jours**, ancrée dans les usages d'Afrique centrale.

## 1. Le constat

Le socle (Market, Immo, Services, séquestre, vérification, Live IA) répond à la question « à qui faire confiance pour acheter ? ». Il ne suffit pas pour devenir la référence :

1. **L'IA était un produit à part** (CV, exercices) au lieu d'être l'intelligence de toute l'application.
2. **Le tissu financier et social local manquait** : la tontine, la diaspora, l'achat à plusieurs.
3. **Rien ne faisait revenir chaque jour** : factures, crédit, adresse, points relais.
4. **La carte était un dessin fixe**, alors que se repérer sans adresse est le premier problème de la livraison et des visites.

## 2. Live IA partout

| Réf. | Exigence | Écran du prototype |
|------|----------|--------------------|
| F-IA2-01 | **Une photo suffit pour vendre** : l'objet est reconnu, la catégorie, le titre, les attributs, l'état, la description et un prix conseillé sont proposés ; le vendeur vérifie avant de publier. Gratuit. | Vendre, étape 1 : « Une photo, et c'est prêt » |
| F-IA2-02 | **Le juste prix** : fourchette du marché calculée sur les ventes et locations réelles comparables (modèle, quartier, nombre de chambres) ; verdict « Bon prix », « Prix du marché » ou « Au-dessus du marché ». Affiché au vendeur (étape Prix) et à l'acheteur (fiche produit, fiche logement). | Composant partagé `JustePrix` |
| F-IA2-03 | **Assistant Live qui agit** : il cherche, compare, crée l'alerte, réserve la visite, ouvre le paiement d'une facture. Gratuit pour agir dans Live ; seuls les documents générés coûtent des crédits. | `/ia/assistant` |
| F-IA2-04 | **La voix, en français, lingala et kituba** : dicter une recherche ou une demande à l'assistant. | Micro et choix de la langue dans l'assistant |
| F-IA2-05 | **Coach vendeur** : conseils tirés des vues, contacts et ventes (prix, photo, heure de publication), chacun avec l'action qui l'applique. | Mes ventes, « Conseils de Live IA » |

**Risque à traiter** : la reconnaissance vocale en lingala et en kituba est encore faible dans les modèles du marché. Prévoir une collecte de voix consentie (avec rétribution en crédits) et un repli sur le français.

## 3. Tontines et achats groupés

| Réf. | Exigence |
|------|----------|
| F-TON-01 | Créer une tontine : nom, cotisation (2 000 à 100 000 FCFA), fréquence (semaine ou mois), nombre de membres ; invitation par lien. |
| F-TON-02 | Ordre des tours par **tirage au sort dans l'application** ou choisi ensemble ; visible par tous. |
| F-TON-03 | Rappel la veille ; cotisation en Mobile Money en un geste ; **l'argent est gardé par Live** jusqu'au versement. |
| F-TON-04 | **Versement automatique** de la cagnotte au bénéficiaire le jour du tour ; historique inaltérable. |
| F-TON-05 | Retards : rappels, puis pénalité **votée par le groupe** ; exclusion à la majorité. |
| F-TON-06 | **Achats groupés** : prix de gros débloqué à l'objectif de participants ; argent bloqué ; remboursement automatique si l'objectif échoue ; livraison au point relais. |

Frais : **1 % de la cagnotte versée** ; aucun frais pour cotiser. Écrans : `/tontines`, `/tontine/:id`, `/achats-groupes`.

## 4. Diaspora et Live Transfert

| Réf. | Exigence |
|------|----------|
| F-DIA-01 | **Payer pour un proche** depuis l'étranger, par carte, en euros ou en dollars : loyer, courses, scolarité, santé, factures, un pro. Le proche est prévenu par SMS, montre son QR à la remise ; l'envoyeur reçoit la preuve. Frais : 1,5 %. |
| F-DIA-02 | **Live Transfert** : envoyer de l'argent ; le proche le reçoit en MTN MoMo, en Airtel Money ou sur son solde Live, **sans frais de retrait**. Frais affichés avant l'envoi (hypothèse : 2 %). |
| F-DIA-03 | Taux fixe **1 € = 655,957 FCFA** (parité garantie) : aucune surprise de change depuis la zone euro. |
| F-DIA-04 | Vérification d'identité de l'envoyeur et du bénéficiaire ; plafonds selon la réglementation CEMAC et celle du pays d'envoi. |
| F-DIA-05 | **Toutes les devises de la diaspora** : euro, dollar américain, livre, dollar canadien, franc suisse, franc CFA d'Afrique de l'Ouest, yuan, dirham, rand, naira. L'envoyeur choisit sa devise ; taux fixe pour l'euro et le franc CFA ouest-africain, sinon taux du jour du partenaire **bloqué 30 minutes**. Paiement par carte, virement ou Mobile Money étranger. |
| F-DIA-06 | **Recevoir de l'étranger** : numéro et lien de réception à partager ; transferts reçus en francs CFA sur le solde Live, retirés en MTN MoMo ou Airtel Money sans frais. |

**Cadre légal (à valider avec l'avocat, D-16)** : garder de l'argent pour autrui et faire des transferts internationaux sont des activités réglementées (agrément COBAC d'établissement de paiement ou de monnaie électronique ; agrément de transfert dans le pays d'envoi). **Live n'émet pas de monnaie** : le solde Live et Live Transfert sont opérés par un **partenaire agréé** tant que Live n'a pas son propre agrément. « Payer pour un proche » est un achat de biens et services, plus simple à ouvrir en premier.

Écrans : `/diaspora`, `/transfert` (Envoyer), `/transfert?sens=recevoir` (Recevoir). L'arrivée des fonds passe par l'API d'un partenaire de transfert international, à choisir : les écrans sont prêts, seul le branchement reste (document 26, §6).

## 5. Quotidien, livraison et cartes

| Réf. | Exigence |
|------|----------|
| F-QUO-01 | **Factures** : électricité (E2C), eau (LCDE), télévision ; ajout d'un compteur par sa référence ; rappel avant échéance ; reçu du fournisseur. Sans frais pour l'utilisateur (commission payée par le fournisseur, à négocier). |
| F-QUO-02 | **Crédit et forfaits** MTN et Airtel, pour soi ou un autre numéro. |
| F-QUO-03 | **Adresse Live** : code court (quartier et numéro) lié à une position GPS, un repère écrit et la photo du portail ; partageable ; visible seulement par ceux qui la reçoivent. |
| F-QUO-04 | **Points relais** : boutiques partenaires pour déposer et retirer un colis (remise contre QR) et convertir des espèces en Mobile Money via un agent agréé. |
| F-CAR-01 | **Carte complète** : plan ou satellite, zoom, « ma position » (GPS), itinéraire tracé, vue rue. |
| F-CAR-02 | **Suivi en temps réel** du livreur (position toutes les 5 secondes) et temps d'arrivée. |

**Intégration réelle (Google Maps Platform)** : Maps SDK (plugin `google_maps_flutter`, types plan et satellite), Street View, Directions (itinéraires et temps d'arrivée), Places et Geocoding (recherche de lieux, Adresse Live vers coordonnées). Positions en direct : Supabase Realtime (canal par course). Clés API dans les variables secrètes, restreintes par application. Le prototype simule ces vues (`CarteInteractive`, `/rue`).

## 6. Fournisseurs

| Besoin | Fournisseur |
|--------|-------------|
| Backend, temps réel, fichiers | Supabase |
| Paiements | API directes MTN MoMo et Airtel Money ; prestataire carte à choisir (Visa, diaspora) |
| SMS, appel, WhatsApp pour les codes | Twilio Verify |
| Vidéo et directs | Mux |
| Cartes | Google Maps Platform |
| Transferts et solde | Partenaire agréé COBAC (à sélectionner) |

## 7. Ordre de construction proposé

1. Live IA partout (photo vers annonce, juste prix) et **factures et crédit** : usage quotidien immédiat, faible risque réglementaire.
2. **Tontines**, puis achats groupés : boucle de rétention « argent ».
3. **Adresse Live et points relais**, avec la livraison.
4. **Payer pour un proche** (diaspora), puis **Live Transfert** une fois le partenaire agréé signé.

**Fin du Document 21**
