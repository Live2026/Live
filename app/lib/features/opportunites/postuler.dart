part of 'opportunites_screens.dart';

/// Étapes d'une candidature, de l'envoi au résultat.
const _etapesCandidature = ['Envoyée', 'Vue', 'Présélection', 'Résultat'];

/// E-OPP-03 — Postuler : profil Live, pièces, motivation. Gratuit.
class EcranPostuler extends ConsumerStatefulWidget {
  const EcranPostuler({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranPostuler> createState() => _EcranPostulerState();
}

class _EcranPostulerState extends ConsumerState<EcranPostuler> {
  final _ajoutees = <String>{};
  var _envoye = false;

  @override
  Widget build(BuildContext context) {
    final o = opportuniteParId(widget.id);
    final etat = ref.watch(liveProvider);
    if (_envoye) return _succes(context, o);
    // Le CV et la pièce d'identité viennent du compte Live quand ils existent.
    bool pret(String piece) =>
        _ajoutees.contains(piece) ||
        (piece == 'CV' && etat.documents.isNotEmpty) ||
        (piece == 'Pièce d’identité' && etat.identiteVerifiee);
    final manquantes = o.pieces.where((p) => !pret(p)).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Postuler')),
      body: DeuxColonnes(
        principale: [
          Text(
            o.titre,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text(
            o.organisation.nom,
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 12),
          Bloc(
            padding: 12,
            child: Row(
              children: [
                Avatar(
                  nom: etat.prenom,
                  couleur: LiveColors.bleu,
                  taille: 44,
                  photo: etat.photoProfil,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${etat.prenom} Mabiala',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${etat.telephone} · profil Live partagé',
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const EnTeteSection('Pièces à fournir'),
          for (final piece in o.pieces)
            LigneMenu(
              icone: pret(piece)
                  ? Icons.check_circle_rounded
                  : Icons.upload_file_rounded,
              couleur: pret(piece) ? LiveColors.succes : LiveColors.bleu,
              titre: piece,
              detail: pret(piece) ? 'Ajouté' : 'Photo ou PDF',
              trailing: pret(piece)
                  ? null
                  : TextButton(
                      onPressed: () => setState(() => _ajoutees.add(piece)),
                      child: const Text('Ajouter'),
                    ),
            ),
          if (o.pieces.contains('CV') && etat.documents.isEmpty)
            TextButton.icon(
              onPressed: () => context.push('/ia/service/cv'),
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: const Text('Pas de CV ? Le créer avec Live IA'),
            ),
        ],
        secondaire: [
          const Text(
            'Motivation',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const TextField(
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'En quelques lignes, pourquoi vous ?',
            ),
          ),
          const SizedBox(height: 12),
          const BandeauProtection(
            'Candidature gratuite. Vos pièces ne sont visibles que par '
            'l’organisation.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: manquantes > 0
              ? null
              : () {
                  ref.read(liveProvider.notifier).postuler(o.id);
                  setState(() => _envoye = true);
                },
          child: Text(
            manquantes > 0
                ? '$manquantes pièce${manquantes > 1 ? 's' : ''} à ajouter'
                : 'Envoyer ma candidature',
          ),
        ),
      ),
    );
  }

  Widget _succes(BuildContext context, Opportunite o) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CocheAnimee(taille: 96),
              const Text(
                'Candidature envoyée',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${o.organisation.nom} a reçu votre dossier. Vous serez '
                'prévenu à chaque étape.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const _Progression(etape: 0),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/mes-candidatures'),
                child: const Text('Mes candidatures'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barre de progression en 4 étapes d'une candidature.
class _Progression extends StatelessWidget {
  const _Progression({required this.etape});
  final int etape;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, e) in _etapesCandidature.indexed)
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= etape
                        ? LiveColors.succes
                        : const Color(0xFFE4E8EE),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: i <= etape ? LiveColors.nuit : LiveColors.gris,
                    fontWeight: i == etape ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// E-OPP-04 — Mes candidatures et leur avancement.
class EcranMesCandidatures extends ConsumerWidget {
  const EcranMesCandidatures({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envoyees = ref.watch(liveProvider.select((e) => e.candidatures));
    final liste = [
      for (final id in envoyees)
        (opportuniteParId(id), 0, 'Envoyée aujourd’hui'),
      (opportuniteParId('o3'), 1, 'Vue par l’organisation hier'),
      (opportuniteParId('o5'), 2, 'Entretien le 28 septembre à 10 h'),
    ];
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes candidatures')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          GrilleAdaptative(
            largeurMax: 460,
            espacement: 12,
            hauteur: 150,
            enfants: [
              for (final (o, etape, detail) in liste)
                Pressable(
                  onTap: () => context.push('/opportunite/${o.id}'),
                  child: Bloc(
                    padding: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Avatar(
                              nom: o.organisation.nom,
                              couleur: o.organisation.couleur,
                              taille: 36,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                o.titre,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: LiveColors.gris),
                        ),
                        const SizedBox(height: 8),
                        _Progression(etape: etape),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/opportunites'),
            icon: const Icon(Icons.search_rounded),
            label: const Text('Trouver d’autres opportunités'),
          ),
        ],
      ),
    );
  }
}
