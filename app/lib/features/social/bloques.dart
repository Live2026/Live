part of 'social_screens.dart';

/// Libellés des comptes bloqués qui ne sont pas des comptes publics.
const _inconnus = {
  'inconnu1': (
    'Inconnu +242 05 ••• 12',
    'A demandé de l’argent pour une bourse',
  ),
  'inconnu2': ('Faux « Service client Live »', 'Demandait le code MoMo'),
};

/// E-SOC-03 — Comptes bloqués : ils ne voient plus votre profil et ne
/// peuvent plus vous écrire. Débloquer à tout moment.
class EcranBloques extends ConsumerWidget {
  const EcranBloques({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloques = ref.watch(liveProvider.select((e) => e.bloques)).toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Comptes bloqués')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 8),
            child: const Text(
              'Un compte bloqué ne voit plus votre profil ni vos annonces et ne '
              'peut plus vous écrire. Il n’est pas prévenu.',
              style: TextStyle(color: LiveColors.gris),
            ),
          ),
          if (bloques.isEmpty)
            const EtatVide(
              icone: Icons.verified_user_outlined,
              texte: 'Aucun compte bloqué.',
            ),
          for (final id in bloques)
            Builder(
              builder: (context) {
                final (nom, detail) =
                    _inconnus[id] ?? (compteParId(id).nom, compteParId(id).bio);
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: marge),
                  leading: Avatar(
                    nom: nom,
                    couleur: LiveColors.gris,
                    taille: 44,
                  ),
                  title: Text(
                    nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                    ),
                    onPressed: () =>
                        ref.read(liveProvider.notifier).debloquer(id),
                    child: const Text('Débloquer'),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
