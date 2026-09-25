part of 'social_screens.dart';

/// E-SOC-02 — Activité des comptes suivis : cours, bourses, articles,
/// logements et directs, comme un fil d'abonnements.
class EcranSuivis extends StatelessWidget {
  const EcranSuivis({super.key});

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes abonnements')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
              itemCount: activitesSuivis.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final c = activitesSuivis[i].compte;
                return Semantics(
                  button: true,
                  label: c.nom,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => context.push(activitesSuivis[i].route),
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          Avatar(
                            nom: c.nom,
                            couleur: c.couleur,
                            taille: 58,
                            anneau: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 16),
          for (final (i, a) in activitesSuivis.indexed)
            Apparition(
              rang: i,
              child: Padding(
                padding: EdgeInsets.fromLTRB(marge, 6, marge, 6),
                child: _CarteActivite(activite: a),
              ),
            ),
        ],
      ),
    );
  }
}

/// Carte d'activité : qui, quoi, aperçu cliquable. Hauteur fixe.
class _CarteActivite extends StatelessWidget {
  const _CarteActivite({required this.activite});
  final Activite activite;

  @override
  Widget build(BuildContext context) {
    final a = activite;
    return Pressable(
      onTap: () => context.push(a.route),
      child: Bloc(
        padding: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar(
                  nom: a.compte.nom,
                  couleur: a.compte.couleur,
                  taille: 38,
                  verifie: a.compte.verifie,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: a.compte.nom,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' ${a.action}'),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  a.quand,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: Row(
                children: [
                  SizedBox(
                    width: 108,
                    child: Vignette(
                      couleur: a.couleur,
                      icone: a.icone,
                      rayon: 8,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.titre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          a.detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
