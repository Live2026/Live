part of 'admin_screens.dart';

/// Actions sensibles en attente d'un second agent (F-ADM-06).
const _aValider = [
  (
    'Remboursement total',
    'LV-00491 · iPhone 11 · 85 000 FCFA',
    'Aïcha N. · Superviseure',
    'Au-delà du seuil de 50 000 FCFA',
    false,
  ),
  (
    'Déblocage de fonds gelés',
    'Jean K. · 480 000 FCFA',
    'Merveille L. · Agent litiges',
    'Justificatifs reçus, identité confirmée',
    false,
  ),
  (
    'Modification de commission',
    'Produits : de 6 % à 5 % (Pointe-Noire)',
    'Direction générale',
    'Campagne de lancement',
    true,
  ),
];

/// E-ADM-10 — Double validation (principe des quatre yeux) : l'auteur
/// d'une demande ne peut pas la valider lui-même.
class _Validations extends StatefulWidget {
  const _Validations();

  @override
  State<_Validations> createState() => _ValidationsState();
}

class _ValidationsState extends State<_Validations> {
  final _traitees = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Bloc(
          fond: LiveColors.teinteAmbre,
          child: Row(
            children: [
              Icon(Icons.visibility_rounded, color: LiveColors.cuivre),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Quatre yeux : remboursement au-delà du seuil, déblocage '
                  'de fonds et modification de commission exigent un second '
                  'agent. L’auteur ne valide jamais sa propre demande.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GrilleAdaptative(
          largeurMax: 420,
          espacement: 12,
          enfants: [
            for (final (i, (titre, objet, auteur, motif, deMoi))
                in _aValider.indexed)
              Bloc(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (_traitees.containsKey(i))
                          Etiquette(
                            _traitees[i]! ? 'Validée' : 'Refusée',
                            fond: _traitees[i]!
                                ? LiveColors.teinteVerte
                                : LiveColors.teinteRouge,
                            couleur: _traitees[i]!
                                ? LiveColors.succes
                                : LiveColors.erreur,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(objet),
                    Text(
                      'Demandé par $auteur · $motif',
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (deMoi)
                      const Text(
                        'Votre demande : un autre administrateur doit la valider.',
                        style: TextStyle(
                          color: LiveColors.cuivre,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else if (!_traitees.containsKey(i))
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => _traitees[i] = false),
                              child: const Text('Refuser'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () async {
                                if (await confirmer(
                                  context,
                                  titre: 'Valider : $titre',
                                  texte:
                                      '$objet\nVotre nom est inscrit au journal '
                                      'd’audit avec celui du demandeur.',
                                  action: 'Valider',
                                )) {
                                  setState(() => _traitees[i] = true);
                                }
                              },
                              child: const Text('Valider'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Entrées du journal d'audit : quand, qui, action, cible, famille.
const _journal = [
  (
    '10:42:08',
    'Aïcha N.',
    'Demande de remboursement total',
    'LV-00491',
    'Finance',
  ),
  (
    '10:31:55',
    'Christelle M.',
    'Identité validée (N2)',
    'Grâce Mabiala',
    'KYC',
  ),
  (
    '10:18:12',
    'Brice O.',
    'Annonce retirée : médicaments',
    'Annonce #8812',
    'Modération',
  ),
  (
    '09:58:40',
    'Direction générale',
    'Commission de 6 % à 5 % demandée',
    'Configuration',
    'Finance',
  ),
  ('09:40:03', 'Junior K.', 'Retrait suspendu', 'Jean K.', 'Finance'),
  (
    '09:12:27',
    'Merveille L.',
    'Litige : remboursement partiel',
    'VI-00212',
    'Litiges',
  ),
  (
    '08:55:19',
    'Patrick D.',
    'Connexion refusée : 2FA non activée',
    'Compte agent',
    'Accès',
  ),
  (
    '08:30:02',
    'Aïcha N.',
    'Connexion (2FA) · nouvel appareil',
    'Chrome, Brazzaville',
    'Accès',
  ),
];

/// E-ADM-11 — Journal d'audit (F-ADM-07) : consultable, filtrable,
/// exportable, jamais modifiable.
class _JournalAudit extends StatefulWidget {
  const _JournalAudit();

  @override
  State<_JournalAudit> createState() => _JournalAuditState();
}

class _JournalAuditState extends State<_JournalAudit> {
  String? _famille;

  @override
  Widget build(BuildContext context) {
    final lignes = _journal
        .where((l) => _famille == null || l.$5 == _famille)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Chaque ligne est chaînée à la précédente : une ligne '
          'modifiée ou supprimée casse la chaîne et se voit.',
          style: TextStyle(color: LiveColors.gris),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
            onPressed: () =>
                _decider(context, 'Export CSV du journal (journalisé).'),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Exporter'),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final f in const [
              null,
              'Accès',
              'KYC',
              'Modération',
              'Litiges',
              'Finance',
            ])
              ChoiceChip(
                label: Text(f ?? 'Tout'),
                selected: _famille == f,
                onSelected: (_) => setState(() => _famille = f),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _Tableau(
          colonnes: const [
            ('Heure', 1),
            ('Agent', 2),
            ('Action', 3),
            ('Cible', 2),
          ],
          lignes: [
            for (final (heure, agent, action, cible, famille) in lignes)
              [
                Text(
                  heure,
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Text(agent),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(action),
                    Text(
                      famille,
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(cible),
              ],
          ],
        ),
      ],
    );
  }
}
