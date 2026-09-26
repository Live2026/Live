part of 'admin_screens.dart';

/// Fonctions internes de Live (document 03, section 10) : le Super
/// Administrateur (direction générale) est le seul rôle permanent ; les
/// autres sont des administrateurs délégués aux permissions fines.
const _fonctions = [
  ('Super administrateur', 'Direction générale · tout, y compris l’équipe'),
  ('Superviseur', 'Toutes les files, sans la configuration'),
  ('Agent KYC', 'Vérifications d’identité et d’espaces pro'),
  ('Modérateur', 'Contenus, annonces, signalements'),
  ('Agent litiges', 'Réclamations et décisions'),
  ('Support', 'Consultation des comptes, sans décision'),
  ('Finance', 'Réconciliation, retraits, export comptable'),
  ('Commercial', 'Espaces pro et abonnements'),
];

/// Permissions et fonctions qui les ont (colonnes de la matrice).
const _permissions = [
  ('Vérifier les identités', {0, 1, 2}),
  ('Retirer un contenu', {0, 1, 3}),
  ('Décider d’un litige', {0, 1, 4}),
  ('Geler des fonds', {0, 1, 4, 6}),
  ('Rembourser (seuil : 2e validation)', {0, 4, 6}),
  ('Modifier les commissions', {0}),
  ('Gérer l’équipe et les permissions', {0}),
  ('Exporter la comptabilité', {0, 6}),
];

const _agents = [
  ('Direction générale', 'dg@live.africa', 0, 'Maintenant', true),
  ('Aïcha N.', 'aicha@live.africa', 1, 'Il y a 5 min', true),
  ('Christelle M.', 'christelle@live.africa', 2, 'Il y a 12 min', true),
  ('Brice O.', 'brice@live.africa', 3, 'Il y a 1 h', true),
  ('Merveille L.', 'merveille@live.africa', 4, 'Hier', true),
  ('Junior K.', 'junior@live.africa', 6, 'Hier', true),
  ('Patrick D.', 'patrick@live.africa', 7, 'Il y a 3 jours', false),
];

/// E-ADM-09 — Équipe Live : réservé au Super Administrateur.
class _EquipeLive extends StatelessWidget {
  const _EquipeLive();

  void _inviter(BuildContext context) {
    var fonction = 2;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, maj) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              16 + MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            children: [
              const Text(
                'Inviter un administrateur',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'Nom complet'),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail professionnel (@live.africa)',
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Fonction',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Le rôle de Super administrateur ne se délègue pas.
                  for (final (i, (nom, _)) in _fonctions.indexed.skip(1))
                    ChoiceChip(
                      label: Text(nom),
                      selected: fonction == i,
                      onSelected: (_) => maj(() => fonction = i),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Bloc(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permissions de « ${_fonctions[fonction].$1} »',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    for (final (p, qui) in _permissions)
                      Row(
                        children: [
                          Icon(
                            qui.contains(fonction)
                                ? Icons.check_circle_rounded
                                : Icons.remove_circle_outline_rounded,
                            size: 18,
                            color: qui.contains(fonction)
                                ? LiveColors.succes
                                : LiveColors.gris,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(p)),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'L’invité active la double authentification à sa première '
                'connexion. L’invitation est inscrite au journal d’audit.',
                style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _decider(context, 'Invitation envoyée (journalisée).');
                },
                child: const Text('Envoyer l’invitation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [LiveColors.bleu, LiveColors.nuit],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    color: LiveColors.ambre,
                    size: 36,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Super administrateur : la direction générale. Seul '
                      'rôle permanent ; il nomme les administrateurs délégués '
                      'et fixe leurs permissions.',
                      style: TextStyle(color: Colors.white, height: 1.35),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: LiveColors.orange,
                  foregroundColor: LiveColors.encre,
                  minimumSize: const Size(0, 44),
                ),
                onPressed: () => _inviter(context),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Inviter un administrateur'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Tableau(
          colonnes: const [
            ('Administrateur', 3),
            ('Fonction', 2),
            ('2FA', 1),
            ('Dernière activité', 2),
          ],
          lignes: [
            for (final (nom, mail, f, quand, a2f) in _agents)
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nom,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      mail,
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Etiquette(
                  _fonctions[f].$1,
                  fond: f == 0 ? LiveColors.teinteOrange : LiveColors.voile,
                  couleur: f == 0 ? LiveColors.cuivre : LiveColors.bleu,
                ),
                Icon(
                  a2f ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
                  color: a2f ? LiveColors.succes : LiveColors.erreur,
                  semanticLabel: a2f ? '2FA active' : '2FA à activer',
                ),
                Text(quand),
              ],
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Matrice des permissions',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 40,
            columns: [
              const DataColumn(label: Text('Permission')),
              for (final (nom, _) in _fonctions)
                DataColumn(label: Text(nom.split(' ').first)),
            ],
            rows: [
              for (final (p, qui) in _permissions)
                DataRow(
                  cells: [
                    DataCell(Text(p)),
                    for (var i = 0; i < _fonctions.length; i++)
                      DataCell(
                        Icon(
                          qui.contains(i)
                              ? Icons.check_rounded
                              : Icons.remove_rounded,
                          size: 18,
                          color: qui.contains(i)
                              ? LiveColors.succes
                              : LiveColors.brume,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
