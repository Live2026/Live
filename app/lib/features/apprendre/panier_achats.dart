part of 'apprendre_screens.dart';

/// Ligne d'un contenu dans une liste (panier, achats) : visuel 16:10,
/// titre, auteur et élément à droite. Même hauteur pour toutes les lignes.
class _LigneContenu extends StatelessWidget {
  const _LigneContenu({required this.contenu, required this.fin, this.dessous});
  final Contenu contenu;
  final Widget fin;
  final Widget? dessous;

  @override
  Widget build(BuildContext context) {
    final c = contenu;
    return InkWell(
      onTap: () => context.push('/contenu/${c.id}'),
      child: SizedBox(
        height: 92,
        child: Row(
          children: [
            SizedBox(
              width: 104,
              height: 66,
              child: Vignette(
                couleur: c.couleur,
                icone: c.type.icone,
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
                    c.titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${c.type.libelle} · ${c.auteur.nom}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                  if (dessous != null) ...[const SizedBox(height: 4), dessous!],
                ],
              ),
            ),
            const SizedBox(width: 8),
            fin,
          ],
        ),
      ),
    );
  }
}

/// E-APP-03 — Panier de contenus numériques, payé en une fois.
class EcranPanier extends ConsumerWidget {
  const EcranPanier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final store = ref.read(liveProvider.notifier);
    final articles = [for (final id in etat.panier) contenuParId(id)];
    final total = articles.fold(0, (s, c) => s + c.prix);
    if (articles.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panier')),
        body: EtatVide(
          icone: Icons.shopping_cart_outlined,
          texte: 'Votre panier est vide.',
          action: 'Découvrir les cours',
          onTap: () => context.push('/apprendre'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Panier · ${articles.length}')),
      body: DeuxColonnes(
        principale: [
          for (final c in articles)
            _LigneContenu(
              contenu: c,
              fin: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fcfa(c.prix),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    tooltip: 'Retirer',
                    onPressed: () => store.retirerDuPanier(c.id),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => context.push('/apprendre'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Ajouter d’autres contenus'),
          ),
        ],
        secondaire: [
          LigneMontant('Sous-total', total),
          const LigneMontant('Frais', 0, brut: 'Aucun'),
          const Divider(),
          LigneMontant('Total', total, gras: true),
          const SizedBox(height: 12),
          const BlocReglement(
            lignes: [
              LigneReglement(
                'Contenus numériques',
                Reglement.dansLive,
                detail: 'Disponibles tout de suite dans « Mes achats »',
              ),
            ],
            note:
                'Payez avec votre solde Live, MTN MoMo, Airtel Money ou Visa.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            store.preparerPaiement(
              PaiementEnCours(
                type: TypePaiement.numerique,
                montant: total,
                libelle: articles.length == 1
                    ? articles.first.titre
                    : '${articles.length} contenus numériques',
                beneficiaire: articles.first.auteur.nom,
                cibleId: etat.panier.join(','),
              ),
            );
            context.push('/payer');
          },
          child: Text('Payer ${fcfa(total)}'),
        ),
      ),
    );
  }
}

/// E-APP-04 — Mes achats : bibliothèque, progression, téléchargements
/// pour ouvrir sans connexion.
class EcranMesAchats extends ConsumerStatefulWidget {
  const EcranMesAchats({super.key});

  @override
  ConsumerState<EcranMesAchats> createState() => _EcranMesAchatsState();
}

class _EcranMesAchatsState extends ConsumerState<EcranMesAchats> {
  final _telecharges = <String>{'n2'};
  final _enCours = <String>{};
  var _filtre = 0;

  void _telecharger(String id) {
    setState(() => _enCours.add(id));
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _enCours.remove(id);
          _telecharges.add(id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final biblio = ref.watch(liveProvider.select((e) => e.bibliotheque));
    final tous = [for (final id in biblio) contenuParId(id)];
    final liste = _filtre == 0
        ? tous
        : tous.where((c) => _telecharges.contains(c.id)).toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes achats')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final (i, f) in [
                'Tout (${tous.length})',
                'Téléchargés',
              ].indexed)
                ChoiceChip(
                  label: Text(f),
                  selected: _filtre == i,
                  onSelected: (_) => setState(() => _filtre = i),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Bloc(
            fond: const Color(0xFFE7F4EC),
            padding: 12,
            child: const Row(
              children: [
                Icon(Icons.wifi_off_rounded, color: LiveColors.succes),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Téléchargez en Wi-Fi, puis regardez sans consommer votre forfait.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (liste.isEmpty)
            const EtatVide(
              icone: Icons.download_for_offline_outlined,
              texte: 'Aucun contenu téléchargé pour l’instant.',
            ),
          for (final c in liste)
            _LigneContenu(
              contenu: c,
              dessous: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: c.id == 'n2' ? 0.45 : 0.0,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFE4E8EE),
                ),
              ),
              fin: _enCours.contains(c.id)
                  ? const SizedBox(
                      width: 48,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    )
                  : _telecharges.contains(c.id)
                  ? IconButton(
                      tooltip: 'Ouvrir',
                      onPressed: () => context.push('/lecteur/${c.id}'),
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: LiveColors.succes,
                        size: 32,
                      ),
                    )
                  : IconButton(
                      tooltip: 'Télécharger',
                      onPressed: () => _telecharger(c.id),
                      icon: const Icon(Icons.download_rounded, size: 28),
                    ),
            ),
        ],
      ),
    );
  }
}
