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
        Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Etiquette(
            context.t.marketMeilleureVente,
            icone: Icons.local_fire_department_rounded,
            fond: LiveColors.teinteOrange,
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
              ' ${context.t.marketNoteVentes(note(p.vendeur.note).replaceAll('/5', ''), p.vendeur.ventes)}',
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
          Etiquette(p.etat, fond: LiveColors.voile, couleur: LiveColors.bleu),
          if (p.negociable)
            Etiquette(
              context.t.marketPrixNegociable,
              fond: LiveColors.teinteOrange,
              couleur: LiveColors.cuivre,
            ),
          PastilleReglement(p.reglement),
          Text(
            context.t.marketQuartierVues(p.quartier, compact(p.vues)),
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
            LigneMontant(context.t.marketCategorie, 0, brut: p.categorie),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Builder(
        builder: (context) {
          final (bas, haut) = fourchetteMarche(p.prix, p.id.hashCode);
          return JustePrix(
            prix: p.prix,
            bas: bas,
            haut: haut,
            base: context.t.marketVentesComparables(p.categorie),
          );
        },
      ),
      const SizedBox(height: 14),
      _ReglementProduit(produit: p),
      const SizedBox(height: 14),
      Text(
        context.t.marketRemise,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
      LigneMenu(
        icone: Icons.handshake_outlined,
        titre: context.t.marketEnMainPropreA(p.quartier),
        detail: surPlace
            ? context.t.marketDansUnLieuPublicPropose
            : context.t.marketVousVerifiezPuisVousMontrez,
        valeur: context.t.marketGratuit,
      ),
      if (p.livraison > 0 && !surPlace)
        LigneMenu(
          icone: Icons.local_shipping_outlined,
          titre: context.t.marketLivraisonABrazzaville,
          detail: context.t.marketParLeVendeurSous24,
          valeur: fcfa(p.livraison),
        ),
      const SizedBox(height: 8),
      Text(
        context.t.marketDescription,
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
            ? context.t.marketPayezAuRendezVousPar
            : context.t.marketRembourseSiVousNeRecevez,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => signaler(context, context.t.marketCetteAnnonce),
          icon: const Icon(Icons.flag_outlined, size: 18),
          label: Text(context.t.marketSignalerLAnnonce),
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
        EnTeteSection(context.t.marketVousAimerezAussi),
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
            tooltip: context.t.marketEcrireAuVendeur,
            style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.push('/conversation'),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          const SizedBox(width: 8),
          if (p.negociable) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () => ouvrirOffre(context, p),
                child: Text(context.t.marketNegocier),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: FilledButton(
              onPressed: () => p.details.containsKey('Tailles')
                  ? ouvrirVariantes(context, p)
                  : context.push('/commande/${p.id}'),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  surPlace ? context.t.marketVoirEtPayer : context.t.acheter,
                ),
              ),
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
              tooltip: context.t.partager,
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
            backgroundColor: LiveColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: BoutonVerre(
                icone: Icons.arrow_back_rounded,
                libelle: context.t.retour,
                onTap: () => context.pop(),
              ),
            ),
            actions: [
              BoutonVerre(
                icone: Icons.ios_share_rounded,
                libelle: context.t.partager,
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
                    context.t.marketNoteVentesReponse(
                      note(v.note),
                      v.ventes,
                      v.reponse,
                    ),
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
            child: Text(suivi ? context.t.abonne : context.t.marketSuivre),
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
        titre: context.t.marketVoirAvantDePayer,
        lignes: [
          LigneReglement(
            context.t.marketPrix,
            Reglement.surPlace,
            montant: p.prix,
            detail: context.t.marketRienAPayerMaintenantAu,
          ),
        ],
        note: context.t.marketNeVersezJamaisDAvance,
      );
    }
    return BlocReglement(
      lignes: [
        LigneReglement(
          context.t.marketPrix,
          Reglement.dansLive,
          montant: p.prix,
          detail: context.t.marketBloqueParLiveJusquA,
        ),
        if (p.livraison > 0)
          LigneReglement(
            context.t.marketLivraisonSiVousLaChoisissez,
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
      (Icons.new_releases_outlined, p.etat, context.t.marketEtat),
      (
        Icons.local_shipping_outlined,
        p.livraison > 0 && !surPlace
            ? context.t.marketMainPropreOuLivraison
            : context.t.marketMainPropre,
        context.t.marketRemise,
      ),
      (p.reglement.icone, p.reglement.court, context.t.marketPaiement),
      (
        Icons.verified_user_outlined,
        surPlace ? context.t.marketPasDAvance : context.t.marketRembourse,
        context.t.marketProtection,
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
