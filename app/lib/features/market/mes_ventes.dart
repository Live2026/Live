part of 'market_screens.dart';

/// E-MKT-07 — Mes ventes : tableau de bord du vendeur. Revenus et solde,
/// statistiques de base (vues, contacts, conversion, note — F-PRO-02),
/// graphique des ventes, commandes par état avec délai de 24 h, annonces à
/// gérer (F-MKT-DASH-04) et menu latéral des outils.
class EcranMesVentes extends ConsumerStatefulWidget {
  const EcranMesVentes({super.key});

  @override
  ConsumerState<EcranMesVentes> createState() => _EcranMesVentesState();
}

class _EcranMesVentesState extends ConsumerState<EcranMesVentes> {
  var _onglet = 0; // 0 à traiter, 1 en cours, 2 terminées
  var _periode = 7;

  static int _rang(StatutCommande s) => switch (s) {
    StatutCommande.payee || StatutCommande.reservee => 0,
    StatutCommande.acceptee || StatutCommande.remise => 1,
    StatutCommande.terminee => 2,
  };

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final ventes = etat.ventes;
    final nombre = [
      for (var i = 0; i < 3; i++)
        ventes.where((v) => _rang(v.statut) == i).length,
    ];
    final visibles = ventes.where((v) => _rang(v.statut) == _onglet).toList();
    final encaisse = ventes
        .where((v) => v.statut == StatutCommande.terminee)
        .fold(0, (s, v) => s + v.total);
    final bloque = ventes
        .where((v) => v.statut != StatutCommande.terminee)
        .fold(0, (s, v) => s + v.total);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      endDrawer: const _OutilsVendeur(),
      appBar: AppBar(
        title: const Text('Mes ventes'),
        actions: [
          IconButton(
            tooltip: 'Booster une annonce',
            onPressed: () => ouvrirBoost(context, ref, 'Pagne wax 6 yards'),
            icon: const Icon(Icons.rocket_launch_outlined),
          ),
          Builder(
            builder: (ctx) => IconButton(
              tooltip: 'Outils du vendeur',
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          _CarteRevenus(
            encaisse: 78000 + encaisse - 48000,
            disponible: etat.disponible,
            bloque: bloque,
          ),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            hauteur: 112,
            enfants: const [
              TuileChiffre(
                libelle: 'Vues',
                valeur: '1 240',
                icone: Icons.visibility_outlined,
                detail: '+12 % cette semaine',
              ),
              TuileChiffre(
                libelle: 'Contacts',
                valeur: '86',
                icone: Icons.chat_bubble_outline_rounded,
                detail: 'messages et offres',
              ),
              TuileChiffre(
                libelle: 'Conversion',
                valeur: '4,2 %',
                icone: Icons.trending_up_rounded,
                detail: 'des vues aux ventes',
                couleur: LiveColors.succes,
              ),
              TuileChiffre(
                libelle: 'Note clients',
                valeur: '4,8/5',
                icone: Icons.star_rounded,
                detail: '37 avis',
                couleur: LiveColors.cuivre,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _GraphiqueVentes(
            periode: _periode,
            onPeriode: (p) => setState(() => _periode = p),
          ),
          if (nombre[0] > 0) ...[
            const SizedBox(height: 12),
            _AlerteDelai(nombre: nombre[0]),
          ],
          const SizedBox(height: 16),
          _OngletsVentes(
            actif: _onglet,
            nombres: nombre,
            onTap: (i) => setState(() => _onglet = i),
          ),
          const SizedBox(height: 12),
          if (visibles.isEmpty)
            EtatVide(
              icone: Icons.inventory_2_outlined,
              texte: _onglet == 0
                  ? 'Aucune commande à traiter.'
                  : 'Rien ici pour le moment.',
              action: 'Publier une annonce',
              onTap: () => context.push('/vendre'),
            )
          else
            GrilleAdaptative(
              largeurMax: 560,
              espacement: 10,
              enfants: [
                for (final (i, v) in visibles.indexed)
                  Apparition(
                    rang: i,
                    child: _CarteVente(
                      vente: v,
                      onAcceptee: () => setState(() => _onglet = 1),
                    ),
                  ),
              ],
            ),
          const _CoachIa(),
          const EnTeteSection('Mes annonces'),
          const _MesAnnonces(),
        ],
      ),
    );
  }
}

/// Carte des revenus : vendu ce mois (chiffre animé), disponible, bloqué.
class _CarteRevenus extends StatelessWidget {
  const _CarteRevenus({
    required this.encaisse,
    required this.disponible,
    required this.bloque,
  });
  final int encaisse;
  final int disponible;
  final int bloque;

  @override
  Widget build(BuildContext context) {
    const blanc = TextStyle(color: Colors.white70, fontSize: 12.5);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [LiveColors.bleu, LiveColors.nuit],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('Vendu ce mois', style: blanc),
              Spacer(),
              Etiquette(
                '+18 % vs août',
                icone: Icons.north_east_rounded,
                fond: Color(0x3322C55E),
                couleur: Color(0xFF86EFAC),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: ChiffreAnime(
              valeur: encaisse,
              format: fcfa,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Disponible', style: blanc),
                    Text(
                      fcfaCourt(disponible),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bloqué par Live', style: blanc),
                    Text(
                      fcfaCourt(bloque),
                      style: const TextStyle(
                        color: LiveColors.ambreClair,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: LiveColors.orangeVif,
                  minimumSize: const Size(0, 40),
                ),
                onPressed: () => context.push('/retirer'),
                child: const Text('Retirer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Histogramme des ventes sur 7 ou 30 jours ; les barres poussent à l'ouverture.
class _GraphiqueVentes extends StatelessWidget {
  const _GraphiqueVentes({required this.periode, required this.onPeriode});
  final int periode;
  final ValueChanged<int> onPeriode;

  static const _semaine = [3, 5, 2, 6, 4, 8, 7];
  static const _jours = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final valeurs = periode == 7
        ? _semaine
        : [for (var i = 0; i < 30; i++) 2 + (i * 7 % 9) + (i ~/ 6)];
    final max = valeurs.reduce((a, b) => a > b ? a : b);
    final total = valeurs.fold(0, (s, v) => s + v);
    return Bloc(
      padding: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Commandes',
                      style: TextStyle(color: LiveColors.gris, fontSize: 13),
                    ),
                    Text(
                      '$total sur $periode jours',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              for (final p in const [7, 30])
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text('$p j'),
                    selected: periode == p,
                    onSelected: (_) => onPeriode(p),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, v) in valeurs.indexed)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: periode == 7 ? 6 : 1.5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TweenAnimationBuilder<double>(
                            key: ValueKey('$periode-$i'),
                            tween: Tween(begin: 0, end: v / max),
                            duration: Duration(milliseconds: 500 + i * 30),
                            curve: courbeDouce,
                            builder: (_, f, _) => Container(
                              height: 90 * f,
                              decoration: BoxDecoration(
                                color: i == valeurs.length - 2
                                    ? LiveColors.orangeVif
                                    : LiveColors.bleu,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          if (periode == 7) ...[
                            const SizedBox(height: 6),
                            Text(
                              _jours[i],
                              style: const TextStyle(
                                fontSize: 12,
                                color: LiveColors.gris,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rappel du délai d'acceptation (24 h, F-MKT-CMD-06).
class _AlerteDelai extends StatelessWidget {
  const _AlerteDelai({required this.nombre});
  final int nombre;

  @override
  Widget build(BuildContext context) {
    return Bloc(
      fond: LiveColors.fondAlerte,
      padding: 12,
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: LiveColors.cuivre),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$nombre commande${nombre > 1 ? 's' : ''} à accepter avant '
              '23 h 12. Sans réponse, l’acheteur est remboursé.',
            ),
          ),
        ],
      ),
    );
  }
}

/// Onglets À traiter, En cours, Terminées, avec pastille du nombre.
class _OngletsVentes extends StatelessWidget {
  const _OngletsVentes({
    required this.actif,
    required this.nombres,
    required this.onTap,
  });
  final int actif;
  final List<int> nombres;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: LiveColors.champ2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final (i, t) in const [
            'À traiter',
            'En cours',
            'Terminées',
          ].indexed)
            Expanded(
              child: Semantics(
                button: true,
                selected: actif == i,
                label: '$t, ${nombres[i]}',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: courbeDouce,
                    height: 40,
                    decoration: BoxDecoration(
                      color: actif == i
                          ? LiveColors.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: actif == i
                          ? const [
                              BoxShadow(
                                color: Color(0x14041936),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            t,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: actif == i
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: actif == i
                                  ? LiveColors.encre
                                  : LiveColors.gris,
                            ),
                          ),
                        ),
                        if (nombres[i] > 0) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? LiveColors.orangeVif
                                  : LiveColors.brume,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${nombres[i]}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: i == 0 ? Colors.white : LiveColors.nuit,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
