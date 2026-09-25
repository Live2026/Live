part of 'market_screens.dart';

/// E-MKT-02 — Fiche produit : photo plein cadre, prix, détails, vendeur,
/// offre de prix et produits similaires.
class EcranProduit extends StatelessWidget {
  const EcranProduit({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final p = produitParId(id);
    final grand = context.grandEcran;
    final surPlace = p.reglement == Reglement.surPlace;
    final entete = <Widget>[
      if (p.vues >= 1000)
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Etiquette(
            'Meilleure vente',
            icone: Icons.local_fire_department_rounded,
            fond: Color(0xFFFFF1E0),
            couleur: LiveColors.cuivre,
          ),
        ),
      Text(
        p.titre,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 4),
      InkWell(
        onTap: () => context.push('/boutique/${p.vendeur.id}'),
        child: Row(
          children: [
            Avatar(nom: p.vendeur.nom, couleur: p.vendeur.couleur, taille: 24),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                p.vendeur.nom,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (p.vendeur.verifie) ...[
              const SizedBox(width: 3),
              const Icon(Icons.verified, size: 15, color: LiveColors.bleu),
            ],
            const SizedBox(width: 8),
            const Icon(Icons.star_rounded, size: 15, color: LiveColors.ambre),
            Text(
              ' ${note(p.vendeur.note).replaceAll('/5', '')} · ${p.vendeur.ventes} ventes',
              style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Text(
        fcfa(p.prix),
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Etiquette(
            p.etat,
            fond: const Color(0xFFE6EBF2),
            couleur: LiveColors.bleu,
          ),
          if (p.negociable)
            const Etiquette(
              'Prix négociable',
              fond: Color(0xFFFFF1E0),
              couleur: LiveColors.cuivre,
            ),
          PastilleReglement(p.reglement),
          Text(
            '${p.quartier} · ${compact(p.vues)} vues',
            style: const TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
        ],
      ),
    ];
    final details = <Widget>[
      _TuilesProduit(produit: p),
      const SizedBox(height: 14),
      Bloc(
        child: Column(
          children: [
            for (final e in p.details.entries)
              LigneMontant(e.key, 0, brut: e.value),
            LigneMontant('Catégorie', 0, brut: p.categorie),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _ReglementProduit(produit: p),
      const SizedBox(height: 14),
      const Text(
        'Remise',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
      LigneMenu(
        icone: Icons.handshake_outlined,
        titre: 'En main propre à ${p.quartier}',
        detail: surPlace
            ? 'Dans un lieu public proposé par Live'
            : 'Vous vérifiez, puis vous montrez votre QR',
        valeur: 'Gratuit',
      ),
      if (p.livraison > 0 && !surPlace)
        LigneMenu(
          icone: Icons.local_shipping_outlined,
          titre: 'Livraison à Brazzaville',
          detail: 'Par le vendeur, sous 24 à 48 h',
          valeur: fcfa(p.livraison),
        ),
      const SizedBox(height: 8),
      const Text(
        'Description',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 4),
      Text(p.description),
    ];
    final vendeur = <Widget>[
      _CarteVendeur(vendeur: p.vendeur),
      const SizedBox(height: 12),
      BandeauProtection(
        surPlace
            ? 'Payez au rendez-vous par MoMo ou Airtel via Live : jamais d’avance.'
            : 'Remboursé si vous ne recevez pas le produit.',
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => signaler(context, 'cette annonce'),
          icon: const Icon(Icons.flag_outlined, size: 18),
          label: const Text('Signaler l’annonce'),
        ),
      ),
    ];
    final similaires = produits
        .where((x) => x.id != p.id && x.categorie == p.categorie)
        .followedBy(
          produits.where((x) => x.id != p.id && x.categorie != p.categorie),
        )
        .take(6)
        .toList();
    final carrousel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EnTeteSection('Vous aimerez aussi'),
        Carrousel(
          largeur: 160,
          hauteur: 250,
          marge: 0,
          enfants: [
            for (final x in similaires) CarteProduit(produit: x, hero: false),
          ],
        ),
      ],
    );
    final actions = BarreAction(
      child: Row(
        children: [
          IconButton.outlined(
            tooltip: 'Écrire au vendeur',
            style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.push('/conversation'),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          const SizedBox(width: 8),
          if (p.negociable) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () => ouvrirOffre(context, p),
                child: const Text('Négocier'),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: FilledButton(
              onPressed: () => context.push('/commande/${p.id}'),
              child: Text(surPlace ? 'Voir sur place' : 'Acheter'),
            ),
          ),
        ],
      ),
    );
    if (grand) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: 'Partager',
              onPressed: () => partager(context, p.titre),
              icon: const Icon(Icons.ios_share_rounded),
            ),
            BoutonFavori(id: p.id, couleur: LiveColors.nuit),
            const SizedBox(width: 12),
          ],
        ),
        body: DeuxColonnes(
          principale: [
            SizedBox(
              height: 420,
              child: Hero(
                tag: 'produit-${p.id}',
                child: Vignette(
                  couleur: p.couleur,
                  icone: p.icone,
                  video: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...details,
            carrousel,
          ],
          secondaire: [...entete, const SizedBox(height: 16), ...vendeur],
        ),
        bottomNavigationBar: actions,
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: BoutonVerre(
                icone: Icons.arrow_back_rounded,
                libelle: 'Retour',
                onTap: () => context.pop(),
              ),
            ),
            actions: [
              BoutonVerre(
                icone: Icons.ios_share_rounded,
                libelle: 'Partager',
                onTap: () => partager(context, p.titre),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BoutonFavori(id: p.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: 'produit-${p.id}',
                child: Vignette(
                  couleur: p.couleur,
                  icone: p.icone,
                  video: true,
                  rayon: 0,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList.list(
              children: [
                ...entete,
                const SizedBox(height: 16),
                ...details,
                const SizedBox(height: 16),
                ...vendeur,
                carrousel,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: actions,
    );
  }
}

/// Carte du vendeur : avatar, badge, réputation, accès à la boutique.
class _CarteVendeur extends ConsumerWidget {
  const _CarteVendeur({required this.vendeur});
  final Vendeur vendeur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vendeur;
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(v.id)),
    );
    return Bloc(
      padding: 12,
      child: Row(
        children: [
          InkWell(
            onTap: () => context.push('/boutique/${v.id}'),
            child: Avatar(
              nom: v.nom,
              couleur: v.couleur,
              taille: 50,
              verifie: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/boutique/${v.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.nom,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  BadgeVerifie(v.badge),
                  Text(
                    '${note(v.note)} · ${v.ventes} ventes · répond en ${v.reponse}',
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(liveProvider.notifier).basculerSuivi(v.id),
            child: Text(suivi ? 'Abonné' : 'Suivre'),
          ),
        ],
      ),
    );
  }
}

/// Comment se paie ce produit : dans Live (neuf, livrable) ou sur place
/// après l'avoir vu (occasion).
class _ReglementProduit extends StatelessWidget {
  const _ReglementProduit({required this.produit});
  final Produit produit;

  @override
  Widget build(BuildContext context) {
    final p = produit;
    if (p.reglement == Reglement.surPlace) {
      return BlocReglement(
        titre: 'Voir avant de payer',
        lignes: [
          LigneReglement(
            'Prix',
            Reglement.surPlace,
            montant: p.prix,
            detail:
                'Rien à payer maintenant. Au rendez-vous, vous vérifiez '
                'l’objet puis vous validez la demande MoMo ou Airtel envoyée '
                'par Live.',
          ),
        ],
        note: 'Ne versez jamais d’avance pour un objet que vous n’avez pas vu.',
      );
    }
    return BlocReglement(
      lignes: [
        LigneReglement(
          'Prix',
          Reglement.dansLive,
          montant: p.prix,
          detail: 'Bloqué par Live jusqu’à la remise',
        ),
        if (p.livraison > 0)
          LigneReglement(
            'Livraison (si vous la choisissez)',
            Reglement.dansLive,
            montant: p.livraison,
          ),
      ],
    );
  }
}

/// Quatre informations clés en tuiles de même taille : état, remise,
/// paiement, protection.
class _TuilesProduit extends StatelessWidget {
  const _TuilesProduit({required this.produit});
  final Produit produit;

  @override
  Widget build(BuildContext context) {
    final p = produit;
    final surPlace = p.reglement == Reglement.surPlace;
    final tuiles = [
      (Icons.new_releases_outlined, p.etat, 'État'),
      (
        Icons.local_shipping_outlined,
        p.livraison > 0 && !surPlace
            ? 'Main propre ou livraison'
            : 'Main propre',
        'Remise',
      ),
      (p.reglement.icone, p.reglement.court, 'Paiement'),
      (
        Icons.verified_user_outlined,
        surPlace ? 'Pas d’avance' : 'Remboursé',
        'Protection',
      ),
    ];
    return GrilleAdaptative(
      largeurMax: 170,
      espacement: 8,
      enfants: [
        for (final (icone, valeur, libelle) in tuiles)
          Bloc(
            padding: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icone, size: 18, color: LiveColors.orangeVif),
                const SizedBox(height: 6),
                Text(
                  valeur,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  libelle,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
