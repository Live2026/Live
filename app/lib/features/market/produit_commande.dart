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
    final entete = <Widget>[
      Text(
        fcfa(p.prix),
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
      ),
      Text(
        p.titre,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
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
          Text(
            '${p.quartier} · ${compact(p.vues)} vues',
            style: const TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
        ],
      ),
    ];
    final details = <Widget>[
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
      const Text(
        'Remise',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
      LigneMenu(
        icone: Icons.handshake_outlined,
        titre: 'En main propre à ${p.quartier}',
        detail: 'Vous vérifiez, puis vous montrez votre QR',
        valeur: 'Gratuit',
      ),
      if (p.livraison > 0)
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
      const BandeauProtection('Remboursé si vous ne recevez pas le produit.'),
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
                child: const Text('Faire une offre'),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: FilledButton(
              onPressed: () => context.push('/commande/${p.id}'),
              child: const Text('Acheter'),
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

/// E-MKT-04 — Récapitulatif de la commande.
class EcranCommande extends ConsumerStatefulWidget {
  const EcranCommande({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranCommande> createState() => _EcranCommandeState();
}

class _EcranCommandeState extends ConsumerState<EcranCommande> {
  var _livraison = false;
  var _mode = ModePaiement.avance;

  @override
  Widget build(BuildContext context) {
    final p = produitParId(widget.id);
    final total = p.prix + (_livraison ? p.livraison : 0);
    return Scaffold(
      appBar: AppBar(title: const Text('Votre commande')),
      body: DeuxColonnes(
        principale: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Vignette(
              couleur: p.couleur,
              icone: p.icone,
              hauteur: 50,
              largeur: 50,
              rayon: 8,
            ),
            title: Text(p.titre),
            trailing: Text(
              fcfa(p.prix),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Remise',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: 'En main propre · ${p.quartier}',
            icone: Icons.handshake,
            selectionne: !_livraison,
            onTap: () => setState(() => _livraison = false),
          ),
          if (p.livraison > 0)
            Choix(
              titre: 'Livraison',
              icone: Icons.delivery_dining,
              trailing: '+ ${fcfa(p.livraison)}',
              selectionne: _livraison,
              onTap: () => setState(() => _livraison = true),
            ),
          if (_livraison)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                decoration: InputDecoration(hintText: 'Adresse ou repère…'),
              ),
            ),
          const SizedBox(height: 8),
        ],
        secondaire: [
          const Text(
            'Paiement',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: 'Payer maintenant',
            sousTitre: "Argent bloqué jusqu'à réception.",
            icone: Icons.lock_clock,
            selectionne: _mode == ModePaiement.avance,
            onTap: () => setState(() => _mode = ModePaiement.avance),
          ),
          Choix(
            titre: 'Payer à la remise',
            sousTitre: 'MoMo ou Airtel, produit en main.',
            icone: Icons.phone_android,
            selectionne: _mode == ModePaiement.remise,
            onTap: () => setState(() => _mode = ModePaiement.remise),
          ),
          const BoutonEcouter(
            "Payer maintenant : vous payez tout de suite, mais Live garde l'argent. Le vendeur ne le reçoit que quand vous avez le produit en main. "
            "Payer à la remise : vous ne payez rien maintenant. Au moment où vous recevez le produit, vous validez le paiement MoMo ou Airtel sur votre téléphone.",
          ),
          const Divider(height: 24),
          LigneMontant('Total à payer', total, gras: true),
          const Text(
            'Aucun frais supplémentaire.',
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            final store = ref.read(liveProvider.notifier);
            if (_mode == ModePaiement.avance) {
              store.preparerPaiement(
                PaiementEnCours(
                  type: TypePaiement.commande,
                  montant: total,
                  libelle: p.titre,
                  beneficiaire: p.vendeur.nom,
                  cibleId: p.id,
                ),
              );
              context.push('/payer');
            } else {
              final id = store.reserverCommande(p, total);
              context.go('/suivi/$id');
            }
          },
          child: const Text('Continuer'),
        ),
      ),
    );
  }
}
