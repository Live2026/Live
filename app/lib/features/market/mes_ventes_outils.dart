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
      backgroundColor: Colors.white,
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
              subtitle: const Text('Boutique vérifiée · Moungali'),
              onTap: () => aller('/boutique/grace'),
            ),
            const Divider(),
            for (final (icone, titre, route) in const [
              (Icons.add_box_outlined, 'Publier une annonce', '/vendre'),
              (Icons.receipt_long_outlined, 'Commandes', '/mes-ventes'),
              (
                Icons.qr_code_2_rounded,
                'QR de paiement à la remise',
                '/vente/LV-00466/qr',
              ),
              (
                Icons.account_balance_wallet_outlined,
                'Gains et retraits',
                '/gains',
              ),
              (
                Icons.insights_outlined,
                'Statistiques avancées (Live Pro)',
                '/live-pro',
              ),
              (
                Icons.star_outline_rounded,
                'Avis des clients',
                '/boutique/grace',
              ),
              (
                Icons.groups_outlined,
                'Équipe de la boutique',
                '/espace/equipe',
              ),
              (
                Icons.payments_outlined,
                'Ce qui se paie dans Live',
                '/paiements',
              ),
              (
                Icons.help_outline_rounded,
                'Signaler un problème',
                '/probleme/commande/LV-00482',
              ),
            ])
              ListTile(
                leading: Icon(icone, color: LiveColors.bleu),
                title: Text(titre),
                onTap: () => aller(route),
              ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Offre de lancement : 0 % de commission jusqu’au 31 décembre.',
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
                          '${fcfa(p.prix)} · ${compact(p.vues)} vues',
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          _vendues.contains(p.id)
                              ? 'Vendu'
                              : _masquees.contains(p.id)
                              ? 'Masquée'
                              : 'En ligne · stock ${p.details['Quantité'] ?? '5'}',
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
                    tooltip: 'Gérer l’annonce',
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
                            'Copie créée : « ${p.titre} » en brouillon.',
                          );
                        case 'modifier':
                          context.push('/produit/${p.id}');
                      }
                    }),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'modifier',
                        child: Text('Modifier'),
                      ),
                      const PopupMenuItem(
                        value: 'dupliquer',
                        child: Text('Dupliquer'),
                      ),
                      const PopupMenuItem(
                        value: 'booster',
                        child: Text('Booster'),
                      ),
                      PopupMenuItem(
                        value: 'masquer',
                        child: Text(
                          _masquees.contains(p.id)
                              ? 'Remettre en ligne'
                              : 'Masquer',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'vendu',
                        child: Text('Marquer comme vendu'),
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
