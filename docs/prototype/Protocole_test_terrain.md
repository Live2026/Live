# Protocole du test terrain du prototype Live

> Objectif : vérifier, **avant de construire l'application complète**, que de vrais utilisateurs de Brazzaville et de Pointe-Noire comprennent et réussissent les parcours clés, sans aide.

## 1. Participants (15 à 20 personnes)

| Profil | Nombre | Où les trouver |
|--------|--------|----------------|
| Vendeurs actifs sur Facebook ou WhatsApp | 4 | Groupes de vente, marchés |
| Agents immobiliers ou commissionnaires | 3 | Agences, annonces Facebook |
| Artisans et prestataires (plombier, coiffeuse…) | 3 | Quartiers, bouche-à-oreille |
| Acheteurs et locataires (dont 3 peu à l'aise avec le numérique) | 5 | Entourage, marchés |
| Élèves, étudiants, chercheurs d'emploi (Live IA) | 3 à 5 | Lycées, universités, centres de formation |

Mélanger les âges, les deux villes, les opérateurs MTN et Airtel, et des téléphones d'entrée de gamme.

## 2. Matériel

- 2 téléphones Android d'entrée de gamme (2 Go de RAM) avec le prototype ouvert dans le navigateur, et 1 ordinateur portable.
- Connexion en **3G** (pas de Wi-Fi) pour mesurer la réalité.
- Fiche d'observation par participant (section 5), chronomètre, et enregistrement audio si le participant l'accepte.

## 3. Déroulé (30 minutes par participant)

1. **Accueil (3 min)** : expliquer que l'on teste l'application, pas la personne ; aucune réponse n'est mauvaise ; aucun argent réel n'est utilisé.
2. **Premier contact (2 min)** : « Qu'est-ce que vous pensez que cette application permet de faire ? »
3. **Tâches (20 min)** : l'animateur lit la tâche (écran « Scénarios de test » dans Moi), rend le téléphone sur l'écran d'accueil, puis **n'aide pas**. Il demande seulement : « Que cherchez-vous ? Que pensez-vous qu'il va se passer ? »
4. **Questions finales (5 min)** : voir section 6.
5. **Réinitialiser** le prototype (bouton en bas de l'écran « Scénarios de test ») avant le participant suivant.

## 4. Les 6 tâches

| # | Tâche lue au participant | Réussite si… |
|---|--------------------------|--------------|
| 1 | « Vous voulez l'iPhone 11 de Grâce Mode. Achetez-le en payant avec MTN MoMo, puis confirmez que vous l'avez reçu. » | Commande payée et réception confirmée |
| 2 | « Vous voulez vendre votre vieux téléphone 30 000 FCFA. Publiez l'annonce, acceptez la commande, puis remettez le téléphone à l'acheteuse. » | Remise confirmée, gains visibles |
| 3 | « Vous cherchez un logement à Moungali à moins de 100 000 FCFA par mois. Dites combien il coûte pour entrer, et réservez une visite. » | Coût d'entrée cité juste + visite payée |
| 4 | « L'évier de votre cuisine fuit. Trouvez un plombier, choisissez un devis et payez l'acompte. » | Acompte payé |
| 5 | « Retirez 50 000 FCFA de vos gains sur votre MoMo. » | Retrait confirmé |
| 6 | « Achetez 500 FCFA de crédits, faites votre CV de comptable, puis faites-vous expliquer l'exercice 2x + 3 = 11. » | CV généré + exercice terminé |

## 5. Fiche d'observation (par tâche)

| Mesure | Comment la noter |
|--------|------------------|
| Réussite | Seul / avec un indice / échec |
| Temps | En secondes |
| Hésitations | Écran et élément où la personne s'arrête plus de 5 secondes |
| Erreurs | Mauvais bouton, retour en arrière, incompréhension d'un mot |
| Phrases marquantes | Citations exactes (« C'est quoi, séquestre ? ») |
| Confiance | « Payeriez-vous vraiment ainsi ? » : oui / peut-être / non, et pourquoi |

## 6. Questions finales

1. « Sur 10, à quel point feriez-vous confiance à Live pour payer un inconnu ? Pourquoi ? »
2. « Qu'est-ce qui vous ferait utiliser Live plutôt que Facebook ou WhatsApp ? »
3. « Le code QR à montrer au vendeur : était-ce clair ? L'avez-vous confondu avec votre code MoMo ? »
4. « Combien seriez-vous prêt à payer pour un CV ? Pour l'aide à un exercice ? » (vérifier les prix du document 19)
5. « Qu'est-ce qui vous a gêné ou manqué ? »

## 7. Critères de décision

| Indicateur | Seuil pour passer à la construction |
|------------|-------------------------------------|
| Taux de réussite sans aide, par tâche | ≥ 80 % |
| Confusion entre le QR Live et le code MoMo | 0 cas |
| Confiance pour payer via Live (note ≥ 7/10) | ≥ 70 % des participants |
| Compréhension du coût d'entrée d'un logement | ≥ 90 % |
| Disposition à payer les prix Live IA | ≥ 50 % des profils concernés |

Tout indicateur sous le seuil donne lieu à une **correction des maquettes et du prototype**, puis à un **second test** sur 5 nouvelles personnes pour les tâches concernées.

## 8. Restitution

Un rapport de 2 pages : résultats par tâche, 10 problèmes classés par gravité, citations, décisions de correction. Il est ajouté à ce dossier (`docs/prototype/`).
