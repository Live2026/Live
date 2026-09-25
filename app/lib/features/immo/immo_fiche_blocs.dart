part of 'immo_screens.dart';

/// Quartier : carte stylisée, zone approximative, repère.
class _Quartier extends StatelessWidget {
  const _Quartier({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    return Bloc(
      padding: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 130,
              child: CustomPaint(
                painter: _CarteQuartier(),
                child: const Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 38,
                    color: LiveColors.bleu,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${bien.quartier}, Brazzaville',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text('Repère : ${bien.repere}'),
                const SizedBox(height: 4),
                const Text(
                  'Adresse exacte visible après le paiement de la visite.',
                  style: TextStyle(color: LiveColors.gris, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                      ),
                      onPressed: () => context.push(
                        '/rue?lieu=${Uri.encodeComponent('${bien.quartier}, Brazzaville')}',
                      ),
                      icon: const Icon(Icons.streetview_rounded, size: 18),
                      label: const Text('Vue rue'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                      ),
                      onPressed: () => context.push('/carte'),
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Sur la carte'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Plan de quartier stylisé (rues et zone approximative), dessiné sans carte réelle.
class _CarteQuartier extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFEAF0F5));
    final rue = Paint()
      ..color = Colors.white
      ..strokeWidth = 8;
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(0, s.height * (0.15 + i * 0.2)),
        Offset(s.width, s.height * (0.05 + i * 0.22)),
        rue,
      );
      canvas.drawLine(
        Offset(s.width * (0.1 + i * 0.22), 0),
        Offset(s.width * (0.2 + i * 0.2), s.height),
        rue,
      );
    }
    canvas.drawCircle(
      Offset(s.width / 2, s.height / 2),
      46,
      Paint()..color = LiveColors.bleu.withValues(alpha: 0.14),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Annonceur extends ConsumerWidget {
  const _Annonceur({required this.vendeur});
  final Vendeur vendeur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vendeur;
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(v.id)),
    );
    return Bloc(
      child: Column(
        children: [
          InkWell(
            onTap: () => context.push('/boutique/${v.id}'),
            child: Row(
              children: [
                Avatar(
                  nom: v.nom,
                  couleur: v.couleur,
                  taille: 52,
                  verifie: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.nom,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      BadgeVerifie(v.badge),
                      Text(
                        '${note(v.note)} · ${v.ventes} locations via Live · répond en ${v.reponse}',
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/boutique/${v.id}'),
                  child: Text(
                    v.badge.startsWith('Agence')
                        ? "Voir l'agence"
                        : 'Voir le profil',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: suivi
                    ? OutlinedButton(
                        onPressed: () =>
                            ref.read(liveProvider.notifier).basculerSuivi(v.id),
                        child: const Text('Suivi'),
                      )
                    : FilledButton.tonal(
                        onPressed: () =>
                            ref.read(liveProvider.notifier).basculerSuivi(v.id),
                        child: const Text('Suivre'),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Similaires extends StatelessWidget {
  const _Similaires({required this.biens});
  final List<Bien> biens;

  @override
  Widget build(BuildContext context) {
    if (biens.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EnTeteSection('Biens similaires'),
        Carrousel(
          largeur: 220,
          hauteur: 262,
          marge: 0,
          enfants: [for (final b in biens) CarteBien(bien: b, hero: false)],
        ),
      ],
    );
  }
}

/// Ce qui se paie dans Live (visite, acompte) et ce qui se paie en direct
/// au propriétaire ou à l'agence, contre reçu (loyers, caution, prix).
class _ReglementBien extends StatelessWidget {
  const _ReglementBien({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    final qui = b.agence ? "l'agence" : 'le propriétaire';
    return BlocReglement(
      lignes: [
        LigneReglement(
          'Frais de visite',
          Reglement.dansLive,
          montant: b.fraisVisite,
          detail: 'Bloqués jusqu’à la visite, remboursés si elle n’a pas lieu',
        ),
        LigneReglement(
          'Acompte de réservation (facultatif)',
          Reglement.dansLive,
          detail: 'Après la visite, pour bloquer le bien',
        ),
        if (b.vente)
          LigneReglement(
            'Prix de vente',
            Reglement.direct,
            montant: b.loyer,
            detail: 'Chez le notaire, à la signature de l’acte',
          )
        else ...[
          LigneReglement(
            'Avance, caution et commission',
            Reglement.direct,
            montant: b.coutEntree,
            detail: 'À $qui, à la signature du bail, contre reçu',
          ),
          LigneReglement(
            'Loyer mensuel',
            Reglement.direct,
            montant: b.loyer,
            detail: 'Chaque mois, à $qui',
          ),
        ],
      ],
    );
  }
}
