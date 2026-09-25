# Écrans — 01. Démarrage et compte

Parcours d'inscription : **moins de 60 secondes** entre l'ouverture de l'application et le fil (document 03, section 3). Exigences : F-CPT-01 à F-CPT-03.

| Étape | Temps visé |
|-------|-----------|
| Numéro + cases de consentement | 10 s |
| Code SMS (lecture automatique sur Android) | 10 s |
| Prénom, nom, ville, âge | 20 s |
| Intérêts (facultatif) | 0 à 10 s |
| Code secret (ou empreinte) | 10 s |
| **Total** | **50 à 60 s** |

---

## E-AUTH-01 — Bienvenue

**But** : dire en une phrase ce qu'est Live et pourquoi rester.

```text
┌──────────────────────────────────────────┐
│             L I V E                      │
│                                          │
│    Achetez, vendez, louez, réservez.     │
│    Payez avec MTN MoMo, Airtel Money     │
│    ou Visa.                              │
│                                          │
│         ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒             │
│         ▒  vidéo de présentation ▒       │
│         ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒             │
│                                          │
│    ✓ Vendeurs vérifiés                   │
│    ✓ Argent protégé jusqu'à réception    │
│    ✓ Près de chez vous                   │
│                                          │
├──────────────────────────────────────────┤
│ [          Commencer               ]     │
│ (    Découvrir sans compte    )          │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Vidéo | 10 s, en boucle, **sans son**, basse qualité (légère), remplacée par une image si la connexion est lente |
| « Découvrir sans compte » | Ouvre le fil en mode visiteur (N0) ; toute action (acheter, écrire, aimer) redirige vers E-AUTH-02 |

---

## E-AUTH-02 — Numéro de téléphone

```text
┌──────────────────────────────────────────┐
│ ◀                                        │
├──────────────────────────────────────────┤
│ Votre numéro de téléphone                │
│                                          │
│ Pour vous connecter et recevoir          │
│ vos paiements Mobile Money.              │
│                                          │
│ [▼ +242 ] [ 06 123 45 67          ]      │
│ Opérateur détecté : MTN                  │
│                                          │
│ [ ] J'accepte les Conditions             │
│     d'utilisation (Lire)                 │
│ [ ] J'accepte la Politique de            │
│     confidentialité (Lire)               │
├──────────────────────────────────────────┤
│ [   Recevoir le code par SMS       ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Format | Numéros congolais au MVP (+242), validation locale avant l'envoi |
| Opérateur | Détecté selon le préfixe (MTN ou Airtel), affiché pour rassurer ; il pré-remplit le moyen de paiement plus tard |
| Protection | Limite d'envois de SMS par numéro et par appareil (anti-abus) |
| Consentement | Les deux cases sont **obligatoires et non pré-cochées** ; le bouton reste inactif tant qu'elles ne sont pas cochées (principe 12) |

---

## E-AUTH-03 — Code reçu par SMS

```text
┌──────────────────────────────────────────┐
│ ◀                                        │
├──────────────────────────────────────────┤
│ Entrez le code reçu au                   │
│ 06 123 45 67                             │
│                                          │
│    [ 4 ] [ 7 ] [ 1 ] [ _ ] [ _ ] [ _ ]   │
│                                          │
│ Renvoyer le code dans 0:45               │
│ (Modifier le numéro)                     │
│                                          │
├──────────────────────────────────────────┤
│ [          Valider               ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Lecture automatique | Le code est lu automatiquement sur Android (API SMS Retriever) |
| Échecs | 5 essais, puis blocage de 15 minutes |
| Compte existant | Si le numéro a déjà un compte : connexion directe, puis demande du PIN (E-AUTH-06) |

---

## E-AUTH-04 — Votre profil

```text
┌──────────────────────────────────────────┐
│ ◀                                 1/2    │
├──────────────────────────────────────────┤
│ Faisons connaissance                     │
│                                          │
│ Prénom [ Grâce                      ]    │
│ Nom    [ Mabiala                    ]    │
│ Ville  [▼ Brazzaville               ]    │
│                                          │
│ [x] J'ai 18 ans ou plus                  │
│                                          │
│ Photo et quartier : plus tard, dans      │
│ votre profil.                            │
├──────────────────────────────────────────┤
│ [            Continuer             ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Âge | Case décochée : l'application demande « Avez-vous au moins 13 ans ? » ; non : inscription refusée ; oui : compte en consultation seule (D-06). La date de naissance exacte est vérifiée au KYC (pièce d'identité). |
| Ville | Brazzaville ou Pointe-Noire au lancement ; les autres villes sont inscrites sur une **liste d'attente** |
| Quartier et photo | Demandés plus tard (au premier usage de « Près de moi », à la première annonce) : l'inscription reste courte |

---

## E-AUTH-05 — Centres d'intérêt

```text
┌──────────────────────────────────────────┐
│ ◀                        2/2  (Passer)   │
├──────────────────────────────────────────┤
│ Qu'est-ce qui vous intéresse ?           │
│ (facultatif)                             │
│                                          │
│ [x] Téléphones    [ ] Informatique       │
│ [x] Mode femme    [ ] Mode homme         │
│ [ ] Beauté        [x] Logement           │
│ [ ] Maison        [ ] Bébé               │
│ [ ] Auto et moto  [ ] Événements         │
│ [ ] Artisans      [ ] Coiffure           │
│ [ ] Cuisine       [ ] Musique            │
│ [ ] Humour        [ ] Bonnes affaires    │
│                                          │
├──────────────────────────────────────────┤
│ [      Continuer (3 choisis)       ]     │
└──────────────────────────────────────────┘
```

---

| Règle | Détail |
|-------|--------|
| Passer | Le fil démarre avec les contenus les plus populaires de la ville ; il s'ajuste ensuite au comportement |

---

## E-AUTH-06 — Code secret de l'application (PIN)

```text
┌──────────────────────────────────────────┐
│ ◀                                        │
├──────────────────────────────────────────┤
│ Créez votre code secret                  │
│                                          │
│ Il protège votre compte et vos           │
│ paiements. Ne le donnez jamais,          │
│ même à un agent Live.                    │
│                                          │
│       ●  ●  ●  ○                         │
│                                          │
│    [1]   [2]   [3]                       │
│    [4]   [5]   [6]                       │
│    [7]   [8]   [9]                       │
│          [0]   [⌫]                       │
│                                          │
│ (Utiliser l'empreinte digitale)          │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| PIN | 4 chiffres ; les suites simples (1234, 0000) sont refusées ; saisie deux fois |
| PIN de paiement | Distinct ; créé au **premier paiement** (E-PAY-01), pas ici, pour ne pas alourdir l'inscription |
| Biométrie | Proposée si le téléphone la permet ; le PIN reste la solution de secours |

---

## E-AUTH-07 — Économie de données

Affiché une seule fois à la fin de l'inscription, **uniquement** si la connexion détectée est lente ou mobile.

```text
┌──────────────────────────────────────────┐
├──────────────────────────────────────────┤
│ Économisez vos données                   │
│                                          │
│ Live peut réduire la qualité des         │
│ vidéos pour consommer moins de           │
│ données mobiles.                         │
│                                          │
│ (•) Économie de données (recommandé)     │
│     Vidéos en 360p, pas de               │
│     préchargement                        │
│                                          │
│ ( ) Qualité automatique                  │
│     S'adapte à votre connexion           │
│                                          │
│ Modifiable à tout moment dans            │
│ Paramètres > Données.                    │
│                                          │
├──────────────────────────────────────────┤
│ [       Aller à l'accueil        ]       │
└──────────────────────────────────────────┘
```

---

## E-AUTH-08 — Connexion (retour d'un utilisateur)

```text
┌──────────────────────────────────────────┐
├──────────────────────────────────────────┤
│ Bon retour, Grâce                        │
│                                          │
│         ( ▒▒ )                           │
│                                          │
│ Entrez votre code secret                 │
│                                          │
│       ●  ●  ○  ○                         │
│                                          │
│    [1]   [2]   [3]                       │
│    [4]   [5]   [6]                       │
│    [7]   [8]   [9]                       │
│          [0]   [⌫]                       │
│                                          │
│ (Code oublié ?)                          │
│ (Ce n'est pas moi)                       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Code oublié | Nouveau code SMS + questions de contrôle ; si des gains sont disponibles, la pièce d'identité est aussi demandée |
| Nouvel appareil | Code SMS obligatoire + notification sur les anciens appareils (F-CPT-03, document 03, section 9) |
