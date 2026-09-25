part of 'explore_screen.dart';

/// F-RECH-04 — Carte des biens et des prestataires : plan de Brazzaville en
/// plein écran, repères avec le prix, fiches en bas synchronisées avec le
/// repère choisi (glisser d'une fiche à l'autre déplace la sélection).
class EcranCarte extends StatefulWidget {
  const EcranCarte({super.key, this.espace = 'immo'});
  final String espace;

  @override
  State<EcranCarte> createState() => _EcranCarteState();
}

class _EcranCarteState extends State<EcranCarte> {
  late var _immo = widget.espace != 'services';
  var _choix = 0;
  final _fiches = PageController(viewportFraction: 0.86);

  @override
  void dispose() {
    _fiches.dispose();
    super.dispose();
  }

  void _selectionner(int i) {
    setState(() => _choix = i);
    if (_fiches.hasClients) {
      _fiches.animateToPage(
        i,
        duration: const Duration(milliseconds: 350),
        curve: courbeDouce,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = _immo ? biens.length : prestataires.length;
    final choix = _choix.clamp(0, n - 1);
    final reperes = [
      for (var i = 0; i < n; i++)
        Repere(
          position: _immo
              ? positionDe(biens[i].quartier, i % 3)
              : positionDe(prestataires[i].zone, i % 3),
          libelle: _immo
              ? fcfaCourt(biens[i].loyer).replaceAll(' FCFA', '')
              : prestataires[i].metier,
          selectionne: i == choix,
          couleur: _immo ? LiveColors.bleu : const Color(0xFF0369A1),
          onTap: () => _selectionner(i),
        ),
    ];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: PlanVille(reperes: reperes)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Row(
                children: [
                  BoutonVerre(
                    icone: Icons.arrow_back_rounded,
                    libelle: 'Retour',
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Color(0x22041936), blurRadius: 8),
                        ],
                      ),
                      child: Row(
                        children: [
                          for (final (i, t) in const [
                            'Logements',
                            'Prestataires',
                          ].indexed)
                            Expanded(
                              child: Semantics(
                                button: true,
                                selected: (i == 0) == _immo,
                                label: t,
                                excludeSemantics: true,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _immo = i == 0;
                                    _choix = 0;
                                    if (_fiches.hasClients) {
                                      _fiches.jumpToPage(0);
                                    }
                                  }),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: (i == 0) == _immo
                                          ? LiveColors.bleu
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      t,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: (i == 0) == _immo
                                            ? Colors.white
                                            : LiveColors.nuit,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 128,
                child: PageView.builder(
                  controller: _fiches,
                  itemCount: n,
                  onPageChanged: (i) => setState(() => _choix = i),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
                    child: _immo
                        ? _FicheCarte(
                            couleur: biens[i].couleur,
                            icone: biens[i].type.icone,
                            titre: biens[i].titre,
                            detail:
                                '${biens[i].quartier} · ${biens[i].chambres} ch.',
                            prix: biens[i].vente
                                ? fcfaCourt(biens[i].loyer)
                                : '${fcfa(biens[i].loyer)} / mois',
                            route: '/bien/${biens[i].id}',
                          )
                        : _FicheCarte(
                            couleur: prestataires[i].couleur,
                            icone: Icons.handyman_rounded,
                            titre: prestataires[i].nom,
                            detail:
                                '${prestataires[i].metier} · ${note(prestataires[i].note)}',
                            prix: 'Dès ${fcfa(prestataires[i].prixDepuis)}',
                            route: '/pro/${prestataires[i].id}',
                          ),
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

/// Fiche compacte sous la carte.
class _FicheCarte extends StatelessWidget {
  const _FicheCarte({
    required this.couleur,
    required this.icone,
    required this.titre,
    required this.detail,
    required this.prix,
    required this.route,
  });
  final Color couleur;
  final IconData icone;
  final String titre;
  final String detail;
  final String prix;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Color(0x2A041936), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: Vignette(couleur: couleur, icone: icone, rayon: 10),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prix,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: LiveColors.bleu,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: LiveColors.gris),
          ],
        ),
      ),
    );
  }
}
