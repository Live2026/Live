part of 'market_screens.dart';

/// Menu latéral des outils du vendeur.
class _OutilsVendeur extends StatelessWidget {
  const _OutilsVendeur();

  @override
  Widget build(BuildContext context) {
    void aller(String route) {
      Navigator.pop(context);
      context.push(route);
    }

    return Drawer(
      backgroundColor: LiveColors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            ListTile(
              leading: const Avatar(
                nom: 'Grâce Mode',
                couleur: Color(0xFFB45309),
                taille: 44,
                verifie: true,
              ),
              title: const Text(
                'Grâce Mode',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(context.t.marketBoutiqueVerifieeMoungali),
              onTap: () => aller('/boutique/grace'),
            ),
            const Divider(),
            for (final (icone, titre, route) in [
              (
                Icons.add_box_outlined,
                context.t.marketPublierUneAnnonce,
                '/vendre',
              ),
              (
                Icons.receipt_long_outlined,
                context.t.marketCommandes,
                '/mes-ventes',
              ),
              (
                Icons.qr_code_2_rounded,
                context.t.marketQrDePaiementA,
                '/vente/LV-00466/qr',
              ),
              (
                Icons.account_balance_wallet_outlined,
                context.t.marketGainsEtRetraits,
                '/gains',
              ),
              (
                Icons.insights_outlined,
                context.t.marketStatistiquesAvanceesLivePro,
                '/live-pro',
              ),
              (
                Icons.star_outline_rounded,
                context.t.marketAvisDesClients,
                '/boutique/grace',
              ),
              (
                Icons.groups_outlined,
                context.t.marketEquipeDeLaBoutique,
                '/espace/equipe',
              ),
              (
                Icons.payments_outlined,
                context.t.marketCeQuiSePaie,
                '/paiements',
              ),
              (
                Icons.help_outline_rounded,
                context.t.marketSignalerUnProbleme,
                '/probleme/commande/LV-00482',
              ),
            ])
              ListTile(
                leading: Icon(icone, color: LiveColors.bleu),
                title: Text(titre),
                onTap: () => aller(route),
              ),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                context.t.marketOffreDeLancement0,
                style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Annonces en ligne : vues, stock, et actions (modifier, booster, masquer,
/// marquer comme vendu — F-MKT-DASH-04).
class _MesAnnonces extends ConsumerStatefulWidget {
  const _MesAnnonces();

  @override
  ConsumerState<_MesAnnonces> createState() => _MesAnnoncesState();
}

class _MesAnnoncesState extends ConsumerState<_MesAnnonces> {
  final _masquees = <String>{};
  final _vendues = <String>{};

  @override
  Widget build(BuildContext context) {
    final annonces = produitsDe(graceMode);
    return Column(
      children: [
        for (final p in annonces)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Bloc(
              padding: 10,
              child: Row(
                children: [
                  Opacity(
                    opacity: _masquees.contains(p.id) ? 0.4 : 1,
                    child: Vignette(
                      couleur: p.couleur,
                      icone: p.icone,
                      hauteur: 52,
                      largeur: 52,
                      rayon: 8,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.titre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          context.t.marketPrixVues(
                            fcfa(p.prix),
                            compact(p.vues),
                          ),
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          _vendues.contains(p.id)
                              ? context.t.marketVendu
                              : _masquees.contains(p.id)
                              ? context.t.marketMasquee
                              : context.t.marketEnLigneStock(
                                  p.details['Quantité'] ?? '5',
                                ),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color:
                                _vendues.contains(p.id) ||
                                    _masquees.contains(p.id)
                                ? LiveColors.gris
                                : LiveColors.succes,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: context.t.marketGererLAnnonce,
                    onSelected: (a) => setState(() {
                      switch (a) {
                        case 'booster':
                          ouvrirBoost(context, ref, p.titre);
                        case 'masquer':
                          _masquees.contains(p.id)
                              ? _masquees.remove(p.id)
                              : _masquees.add(p.id);
                        case 'vendu':
                          _vendues.add(p.id);
                        case 'dupliquer':
                          informer(
                            context,
                            context.t.marketCopieCreee(p.titre),
                          );
                        case 'modifier':
                          context.push('/produit/${p.id}');
                      }
                    }),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'modifier',
                        child: Text(context.t.marketModifier),
                      ),
                      PopupMenuItem(
                        value: 'dupliquer',
                        child: Text(context.t.marketDupliquer),
                      ),
                      PopupMenuItem(
                        value: 'booster',
                        child: Text(context.t.marketBooster),
                      ),
                      PopupMenuItem(
                        value: 'masquer',
                        child: Text(
                          _masquees.contains(p.id)
                              ? context.t.marketRemettreEnLigne
                              : context.t.marketMasquer,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'vendu',
                        child: Text(context.t.marketMarquerCommeVendu),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
