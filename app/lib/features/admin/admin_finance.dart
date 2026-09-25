part of 'admin_screens.dart';

/// E-ADM-06 — Finance et réconciliation avec l'agrégateur et la banque.
class _Finance extends StatelessWidget {
  const _Finance();

  @override
  Widget build(BuildContext context) {
    const lignes = [
      ('MTN MoMo', '4 812 400', '4 812 400', 'Réconcilié'),
      ('Airtel Money', '1 906 000', '1 906 000', 'Réconcilié'),
      ('Visa', '412 500', '398 000', 'Écart'),
      ('Retraits', '2 105 000', '2 105 000', 'Réconcilié'),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GrilleAdaptative(
          largeurMax: 260,
          espacement: 12,
          enfants: const [
            TuileChiffre(
              libelle: 'Compte de séquestre (banque)',
              valeur: '18,4 M',
              icone: Icons.account_balance_outlined,
              detail: 'FCFA · égal au grand livre',
            ),
            TuileChiffre(
              libelle: 'Soldes vendeurs',
              valeur: '9,7 M',
              icone: Icons.wallet_outlined,
              detail: 'FCFA disponibles',
            ),
            TuileChiffre(
              libelle: 'Commissions du mois',
              valeur: '1,2 M',
              icone: Icons.percent_rounded,
              detail: 'FCFA · 0 % offre de lancement',
              couleur: LiveColors.succes,
            ),
            TuileChiffre(
              libelle: 'Crédits Live vendus',
              valeur: '642 000',
              icone: Icons.auto_awesome_outlined,
              detail: 'FCFA ce mois',
              couleur: LiveColors.cuivre,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Réconciliation du 24 septembre',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _Tableau(
          colonnes: const [
            ('Canal', 2),
            ('Grand livre', 2),
            ('Relevé', 2),
            ('État', 2),
          ],
          lignes: [
            for (final (canal, livre, releve, etat) in lignes)
              [
                Text(
                  canal,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(livre),
                Text(releve),
                _etat(etat),
              ],
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Écart Visa de 14 500 FCFA : un paiement 3-D Secure en attente de confirmation de l’agrégateur.',
          style: TextStyle(color: LiveColors.gris, fontSize: 13),
        ),
        const SizedBox(height: 16),
        const Text(
          'Retraits suspects',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _Tableau(
          colonnes: const [
            ('Compte', 3),
            ('Montant', 2),
            ('Raison', 3),
            ('État', 2),
          ],
          lignes: [
            [
              const Text('Jean K.'),
              Text(fcfa(480000)),
              const Text('Compte créé il y a 2 jours'),
              _etat('Bloqué'),
            ],
            [
              const Text('Boutique Élégance'),
              Text(fcfa(1200000)),
              const Text('Plafond N2 dépassé'),
              _etat('En attente'),
            ],
          ],
          onTap: (_) => context.push('/admin/utilisateurs/u2'),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () =>
                _decider(context, 'Export comptable envoyé (simulation).'),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Export comptable du mois'),
          ),
        ),
      ],
    );
  }
}

const _utilisateurs = [
  ('u1', 'Grâce Mabiala', 'N2', '12 transactions', 'Actif'),
  ('u2', 'Jean K.', 'N1', 'Retrait bloqué', 'Bloqué'),
  ('u3', 'Agence Les Palmiers', 'N3', '38 locations', 'Actif'),
  ('u4', 'Serge Plombier', 'N2', '186 interventions', 'Actif'),
];

/// Liste des utilisateurs (E-ADM-07, vue liste).
class _Utilisateurs extends StatelessWidget {
  const _Utilisateurs();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Nom, numéro, référence de transaction',
          ),
        ),
        const SizedBox(height: 12),
        _Tableau(
          colonnes: const [
            ('Utilisateur', 3),
            ('Niveau', 1),
            ('Activité', 3),
            ('État', 2),
          ],
          lignes: [
            for (final (_, nom, niveau, activite, etat) in _utilisateurs)
              [
                Text(nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(niveau),
                Text(activite),
                _etat(etat),
              ],
          ],
          onTap: (i) =>
              context.push('/admin/utilisateurs/${_utilisateurs[i].$1}'),
        ),
      ],
    );
  }
}

/// E-ADM-07 — Fiche utilisateur : identité, capacités, actions.
class EcranFicheUtilisateur extends StatelessWidget {
  const EcranFicheUtilisateur({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final u = _utilisateurs.firstWhere(
      (x) => x.$1 == id,
      orElse: () => _utilisateurs.first,
    );
    return _CoqueAdmin(
      section: 5,
      titre: u.$2,
      corps: DeuxColonnes(
        principale: [
          Row(
            children: [
              Avatar(
                nom: u.$2,
                couleur: LiveColors.bleu,
                taille: 64,
                verifie: u.$3 != 'N1',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.$2,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('${u.$3} · inscrit le 3 sept. 2026 · 06 123 45 67'),
                    _etat(u.$5),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Super-pouvoirs (capacités)',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in const [
                'C-ACHETER',
                'C-VENDRE',
                'C-RETIRER',
                'C-SERVICES',
                'C-IA',
              ])
                InputChip(
                  label: Text(c),
                  onDeleted: () =>
                      _decider(context, '$c suspendue (journalisé).'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Journal d’audit',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const LigneMenu(
            icone: Icons.history_rounded,
            titre: 'Retrait 50 000 FCFA',
            detail: 'Aujourd’hui 10:58 · par l’utilisateur',
          ),
          const LigneMenu(
            icone: Icons.history_rounded,
            titre: 'Niveau N2 accordé',
            detail: 'Hier 16:12 · par Aïcha (agent KYC)',
          ),
        ],
        secondaire: [
          const Text(
            'Actions',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () =>
                _decider(context, 'Fonds gelés : double validation demandée.'),
            child: const Text('Geler les fonds'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _decider(context, 'Retrait débloqué.'),
            child: const Text('Débloquer le retrait'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: LiveColors.erreur),
            onPressed: () =>
                _decider(context, 'Bannissement : double validation demandée.'),
            child: const Text('Bannir le compte'),
          ),
        ],
      ),
    );
  }
}

/// E-ADM-08 — Configuration : catégories, quartiers, commissions, plafonds.
class _Configuration extends StatelessWidget {
  const _Configuration();

  @override
  Widget build(BuildContext context) {
    const parametres = [
      ('Commission produits', '6 % (min. 100 FCFA)'),
      ('Commission services', '8 %'),
      ('Commission frais de visite', '15 %'),
      ('Réservation immobilière', '2 % plafonné à 10 000 FCFA'),
      ('Offre de lancement', '0 % pendant 3 mois'),
      ('Plafond N1 (encaissement)', '100 000 FCFA / mois, sans retrait'),
      ('Plafond N2 (retrait)', '2 000 000 FCFA / mois'),
      ('Délai de séquestre', '72 h après remise sans litige'),
      ('Crédits Live', '1 crédit = 10 FCFA · 20 offerts à l’inscription'),
      ('Prix des boosts', '24 h 1 000 · 3 j 2 500 · 7 j 5 000 FCFA'),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Bloc(
          child: Column(
            children: [
              for (final (nom, valeur) in parametres)
                LigneMenu(
                  icone: Icons.tune_rounded,
                  titre: nom,
                  valeur: valeur,
                  onTap: () => _decider(
                    context,
                    'Modification soumise à double validation.',
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Toute modification de commission ou de plafond exige la validation d’un second administrateur.',
          style: TextStyle(color: LiveColors.gris, fontSize: 13),
        ),
      ],
    );
  }
}
