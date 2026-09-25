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

## E-AUTH-00 — Ouverture (révision du 25/09/2026)

Le logo de Live apparaît sur fond nuit, dans un disque blanc lumineux, avec le nom **« Live »** (L majuscule, jamais « LIVE ») et « La place de marché sociale ». Après 1,8 s, la bienvenue s'ouvre.

---

## E-AUTH-01 — Bienvenue (révision du 25/09/2026)

**But** : dire en une phrase ce qu'est Live, **sans le limiter à une ville ni à un opérateur** : Live vise toute l'Afrique centrale.

```text
┌──────────────────────────────────────────┐
│ (logo) Live                              │  fond nuit, halos orange,
│                                          │  violet et bleu qui respirent
│ Achetez                ← verbe animé :   │
│ en toute confiance.      Achetez, Vendez,│
│                          Louez, Réservez,│
│ La place de marché sociale de            │  Apprenez, Gagnez (une couleur
│ l'Afrique centrale : produits,           │  par verbe)
│ logements, services, cours, créateurs.   │
│                                          │
│ (Market) (Immo) (Services) (Directs)     │  pastilles colorées des espaces
│ (Savoir) (Live IA)                       │
│                                          │
│ 🔒 Mobile Money, carte bancaire ou solde  │
│    Live. Argent protégé jusqu'à la remise│
├──────────────────────────────────────────┤
│ [        Commencer (orange)        ]     │
│ (    Découvrir sans compte    )          │
│         J'ai déjà un compte              │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Verbe animé | Change toutes les 2 s ; fixe si l'utilisateur a demandé moins d'animations |
| « Découvrir sans compte » | Ouvre le fil en mode visiteur (N0) ; toute action (acheter, écrire, aimer) redirige vers E-AUTH-02 |
| Sur ordinateur | La présentation (verbe animé, espaces, trois promesses) occupe la gauche ; à droite, une **carte avec le logo** contient le formulaire (docs/ecrans/00, section 8) |

---

## E-AUTH-02 — Numéro de téléphone

```text
┌──────────────────────────────────────────┐
│ ◀                                        │
├──────────────────────────────────────────┤
│ (icône téléphone orange)                 │
│ Votre numéro de téléphone                │
│ Il sert à vous connecter et à recevoir   │
│ vos paiements. Jamais affiché.           │
│                                          │
│ [ +242 ▼ ] [ 06 123 45 67          ]     │
│              Congo                       │
│ (✓ MTN Mobile Money détecté)             │
│                                          │
│ [ ] J'accepte les Conditions             │
│ [ ] J'accepte la Politique de            │
│     confidentialité                      │
├──────────────────────────────────────────┤
│ [       Recevoir le code           ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Pays | Les 6 pays de la CEMAC (Congo +242, Gabon +241, Cameroun +237, Tchad +235, Centrafrique +236, Guinée équatoriale +240), avec l'exemple de numéro de chaque pays |
| Opérateur | Détecté selon le préfixe, affiché dans une pastille aux couleurs de l'opérateur ; il pré-remplit le moyen de paiement plus tard |
| Protection | Limite d'envois par numéro et par appareil (anti-abus) |
| Consentement | Les deux cases sont **obligatoires et non pré-cochées** ; le bouton reste inactif tant qu'elles ne sont pas cochées (principe 12) |

---

## E-AUTH-03 — Code reçu (révision du 25/09/2026, sur le modèle de WhatsApp)

```text
┌──────────────────────────────────────────┐
│ ◀                                  Aide  │
├──────────────────────────────────────────┤
│            (icône SMS orange)            │
│         Vérifiez votre numéro            │
│  Code envoyé par SMS au +242 06 123 45 67│
│      Mauvais numéro ? Le modifier        │
│                                          │
│   [4] [7] [1] [ ] [ ] [ ]  ← case active │
│                              en orange   │
│   ◔ Renvoyer le code dans 0:45           │
│                                          │
│ (après le décompte)                      │
│ Vous n'avez pas reçu le code ?           │
│ (SMS)      Renvoyer le SMS            ›  │
│ (appel)    M'appeler                  ›  │
│ (WhatsApp) Recevoir sur WhatsApp      ›  │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Six cases | Composant partagé `ChampCode` : case active surlignée, chiffres qui apparaissent avec un rebond, vert quand le code est bon, rouge et tremblement s'il est faux ; lecture automatique du SMS (Android) et collage acceptés |
| Validation | Automatique au 6ᵉ chiffre, sans bouton |
| Renvoi | Après 45 s : SMS, appel automatique qui dicte le code, ou WhatsApp. Chaque renvoi allonge l'attente de 15 s (anti-abus) |
| Aide | « Code non reçu ? » : réseau, numéro, SMS inconnus, délai ; modifier le numéro ; contacter l'assistance |
| Échecs | 5 essais, puis blocage de 15 minutes |
| Compte existant | Si le numéro a déjà un compte : connexion directe, puis demande du PIN (E-AUTH-06) |

---

## Révision du 25/09/2026 : les autres étapes

Toutes les étapes partagent le même en-tête (`EnTeteDemarrage`) : barre de progression en 5 segments (Numéro, Code, Profil, Code secret, Intérêts), grande icône sur un dégradé propre à l'étape, titre et explication.

| Écran | Ce qui change |
|-------|---------------|
| E-AUTH-04 Profil | Icône violette ; l'avatar se dessine au fil de la saisie du prénom ; ville en puces (villes de la CEMAC) ; « 18 ans ou plus » en interrupteur |
| E-AUTH-06 Code secret | Icône verte ; **saisi deux fois** (« Confirmez votre code »), sinon on recommence ; option empreinte ou visage |
| E-AUTH-05 Intérêts | Icône rose ; chaque centre d'intérêt a sa couleur, la tuile se remplit et se coche quand on la choisit |
| E-AUTH-08 Connexion | Même en-tête à chaque étape (numéro, code en six cases, code secret), « Code secret oublié ? » |

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
