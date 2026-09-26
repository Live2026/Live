part of 'market_screens.dart';

/// Blocs de l'accueil du Market : carrousel « à la une », vendeurs, commandes,
/// vendre, paiements, aide. Mise en page inspirée des places de marché
/// modernes, aux couleurs de Live ; la logique (séquestre, remise) ne change pas.

/// Carrousel « à la une » qui défile seul (sauf si l'utilisateur a demandé
/// de réduire les animations), avec ses points de position.
class _CarrouselUne extends StatefulWidget {
  const _CarrouselUne();

  @override
  State<_CarrouselUne> createState() => _CarrouselUneState();
}

class _CarrouselUneState extends State<_CarrouselUne> {
  final _pages = PageController();
  Timer? _minuteur;
  var _page = 0;

  static const _slides = [
    (
      '0 % de commission',
      'Vendez pendant 3 mois sans rien payer.',
      Icons.sell_rounded,
      '/vendre',
      [LiveColors.bleu, LiveColors.nuit],
    ),
    (
      'Payé seulement à la réception',
      'Votre argent reste bloqué par Live jusqu’au QR de remise.',
      Icons.verified_user_rounded,
      '/paiements',
      [Color(0xFF1E7B4F), Color(0xFF0B3B26)],
    ),
    (
      'Boutiques vérifiées',
      'Identité et activité contrôlées par Live.',
      Icons.storefront_rounded,
      '/boutique/grace',
      [Color(0xFFC27A25), Color(0xFF6B3A0A)],
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minuteur?.cancel();
    if (!MediaQuery.of(context).disableAnimations) {
      _minuteur = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!_pages.hasClients) return;
        _pages.animateToPage(
          (_page + 1) % _slides.length,
          duration: const Duration(milliseconds: 500),
          curve: courbeDouce,
        );
      });
    }
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView(
            controller: _pages,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              for (final (titre, texte, icone, route, couleurs) in _slides)
                Semantics(
                  button: true,
                  label: titre,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => context.push(route),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: couleurs,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  titre,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: LiveColors.ambreClair,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  texte,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: LiveColors.orangeVif,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Découvrir',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(icone, color: Colors.white24, size: 72),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: i == _page ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i == _page ? LiveColors.orangeVif : LiveColors.brume,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Carte « vendeur à la une » : même taille pour toutes.
class _CarteVendeurUne extends StatelessWidget {
  const _CarteVendeurUne({required this.vendeur});
  final Vendeur vendeur;

  @override
  Widget build(BuildContext context) {
    final v = vendeur;
    return Semantics(
      button: true,
      label: v.nom,
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/boutique/${v.id}'),
        child: Bloc(
          padding: 10,
          child: Column(
            children: [
              Avatar(
                nom: v.nom,
                couleur: v.couleur,
                taille: 52,
                verifie: v.badge.startsWith('Pro'),
              ),
              const SizedBox(height: 8),
              Text(
                v.nom,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                v.badge.startsWith('Pro') ? 'Boutique' : 'Particulier',
                style: const TextStyle(color: LiveColors.gris, fontSize: 12),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: LiveColors.ambre,
                  ),
                  Flexible(
                    child: Text(
                      ' ${note(v.note).replaceAll('/5', '')} (${v.ventes})',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// En-tête des blocs du bas de page, avec lien facultatif.
class _TitreBloc extends StatelessWidget {
  const _TitreBloc(this.titre, {this.route});
  final String titre;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titre,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        if (route != null)
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(0, 32)),
            onPressed: () => context.push(route!),
            child: const Text('Voir tout'),
          ),
      ],
    );
  }
}

/// « Vos commandes » : les achats en cours et leur état.
class _VosCommandes extends StatelessWidget {
  const _VosCommandes({required this.achats});
  final List<Commande> achats;

  @override
  Widget build(BuildContext context) {
    return Bloc(
      padding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TitreBloc('Vos commandes', route: '/commandes'),
          for (final c in achats.take(3)) LigneCommande(commande: c),
        ],
      ),
    );
  }
}

/// Ligne d'une commande : produit, numéro, état et montant.
class LigneCommande extends StatelessWidget {
  const LigneCommande({super.key, required this.commande});
  final Commande commande;

  @override
  Widget build(BuildContext context) {
    final c = commande;
    final (etat, couleur) = switch (c.statut) {
      StatutCommande.reservee => (
        'Réservée · à payer à la remise',
        LiveColors.cuivre,
      ),
      StatutCommande.terminee => ('Terminée', LiveColors.succes),
      _ => ('Payée · argent bloqué par Live', LiveColors.bleu),
    };
    return InkWell(
      onTap: () => context.push('/suivi/${c.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Vignette(
                couleur: c.produit.couleur,
                icone: c.produit.icone,
                rayon: 8,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande ${c.id}',
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    c.produit.titre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    etat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: couleur, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            Text(
              fcfa(c.total),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

/// « Vendre sur Live » : les avantages et l'accès à la vente.
class _VendreSurLive extends StatelessWidget {
  const _VendreSurLive();

  @override
  Widget build(BuildContext context) {
    return Bloc(
      padding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TitreBloc('Vendre sur Live'),
          for (final (icone, texte) in const [
            (
              Icons.groups_rounded,
              'Des milliers d’acheteurs près de chez vous',
            ),
            (Icons.percent_rounded, '0 % de commission pendant 3 mois'),
            (Icons.lock_rounded, 'Paiement garanti avant la remise'),
            (Icons.qr_code_2_rounded, 'Remise confirmée par QR'),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(icone, size: 18, color: LiveColors.orangeVif),
                  const SizedBox(width: 8),
                  Expanded(child: Text(texte)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.push('/vendre'),
              child: const Text('Vendre un produit'),
            ),
          ),
        ],
      ),
    );
  }
}

/// « Paiements sécurisés » : les moyens acceptés et la protection.
class _PaiementsSecurises extends StatelessWidget {
  const _PaiementsSecurises();

  @override
  Widget build(BuildContext context) {
    return Bloc(
      padding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TitreBloc('Paiements sécurisés', route: '/paiements'),
          Row(
            children: [
              for (final (icone, texte) in const [
                (Icons.account_balance_wallet_rounded, 'Solde Live'),
                (Icons.phone_android_rounded, 'MoMo · Airtel'),
                (Icons.credit_card_rounded, 'Visa'),
                (Icons.handshake_rounded, 'À la remise'),
              ])
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: LiveColors.champ2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icone, color: LiveColors.bleu),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        texte,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const BandeauProtection(
            'Remboursé si vous ne recevez pas le produit.',
          ),
        ],
      ),
    );
  }
}

/// « Besoin d'aide ? » : raccourcis vers l'aide et la confiance.
class _BesoinAide extends StatelessWidget {
  const _BesoinAide();

  @override
  Widget build(BuildContext context) {
    return Bloc(
      padding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TitreBloc('Besoin d’aide ?'),
          LigneMenu(
            icone: Icons.payments_outlined,
            titre: 'Ce qui se paie dans Live',
            detail: 'Dans Live, à la remise ou en direct',
            onTap: () => context.push('/paiements'),
          ),
          LigneMenu(
            icone: Icons.report_problem_outlined,
            titre: 'Signaler un problème',
            detail: 'Produit non reçu, non conforme',
            onTap: () => context.push('/probleme/commande/LV-00482'),
          ),
          LigneMenu(
            icone: Icons.support_agent_rounded,
            titre: 'Centre d’aide',
            detail: 'Questions fréquentes, écrire au support',
            onTap: () => context.push('/aide'),
          ),
        ],
      ),
    );
  }
}
