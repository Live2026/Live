part of 'market_screens.dart';

/// E-MKT-04 — Récapitulatif de la commande.
class EcranCommande extends ConsumerStatefulWidget {
  const EcranCommande({
    super.key,
    required this.id,
    this.variante,
    this.quantite = 1,
  });
  final String id;

  /// Variante choisie (taille) et quantité (F-MKT-06).
  final String? variante;
  final int quantite;

  @override
  ConsumerState<EcranCommande> createState() => _EcranCommandeState();
}

class _EcranCommandeState extends ConsumerState<EcranCommande> {
  var _livraison = false;
  var _mode = ModePaiement.avance;
  var _lieu = 0;

  late final _lieux = [
    ('Station Total Moungali', context.t.marketEclaireeGardiennee),
    ('Marché Total, entrée principale', context.t.marketTresFrequente),
    ('Commissariat de Moungali', context.t.marketPointDeRemiseSur),
  ];

  @override
  Widget build(BuildContext context) {
    final p = produitParId(widget.id);
    if (p.reglement == Reglement.surPlace) return _surPlace(context, p);
    final total = p.prix * widget.quantite + (_livraison ? p.livraison : 0);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.marketVotreCommande)),
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
            subtitle: widget.variante == null && widget.quantite == 1
                ? null
                : Text(
                    [
                      if (widget.variante != null)
                        context.t.marketTailleX(widget.variante!),
                      '× ${widget.quantite}',
                    ].join(' · '),
                  ),
            trailing: Text(
              fcfa(p.prix),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.marketRemise,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: context.t.marketEnMainPropreQuartier(p.quartier),
            icone: Icons.handshake,
            selectionne: !_livraison,
            onTap: () => setState(() => _livraison = false),
          ),
          if (p.livraison > 0)
            Choix(
              titre: context.t.marketLivraison,
              icone: Icons.delivery_dining,
              trailing: '+ ${fcfa(p.livraison)}',
              selectionne: _livraison,
              onTap: () => setState(() => _livraison = true),
            ),
          if (_livraison)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: context.t.marketAdresseOuRepere,
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
        secondaire: [
          Text(
            context.t.marketPaiement,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: context.t.marketPayerMaintenant,
            sousTitre: context.t.marketArgentBloqueJusquAReception,
            icone: Icons.lock_clock,
            selectionne: _mode == ModePaiement.avance,
            onTap: () => setState(() => _mode = ModePaiement.avance),
          ),
          Choix(
            titre: context.t.marketPayerALaRemise,
            sousTitre: context.t.marketMomoOuAirtelProduitEn,
            icone: Icons.phone_android,
            selectionne: _mode == ModePaiement.remise,
            onTap: () => setState(() => _mode = ModePaiement.remise),
          ),
          BoutonEcouter(context.t.marketPayerMaintenantVousPayezTout),
          const Divider(height: 24),
          LigneMontant(context.t.marketTotalAPayer, total, gras: true),
          Text(
            context.t.marketAucunFraisSupplementaire,
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
          child: Text(context.t.continuer),
        ),
      ),
    );
  }

  /// Occasion à voir avant d'acheter : on fixe un rendez-vous dans un lieu
  /// sûr, rien n'est payé maintenant.
  Widget _surPlace(BuildContext context, Produit p) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.marketVoirAvantDePayer)),
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
            subtitle: Text('${p.vendeur.nom} · ${p.quartier}'),
            trailing: Text(
              fcfa(p.prix),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.marketLieuDuRendezVous,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          for (final (i, (lieu, detail)) in _lieux.indexed)
            Choix(
              titre: lieu,
              sousTitre: detail,
              icone: Icons.verified_user_outlined,
              selectionne: _lieu == i,
              onTap: () => setState(() => _lieu = i),
            ),
        ],
        secondaire: [
          Text(
            context.t.marketPaiementALaRemise,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          LigneMenu(
            icone: Icons.phone_android_rounded,
            titre: context.t.marketMomoOuAirtelAuRendez,
            detail: context.t.marketVousVerifiezLObjetLe,
          ),
          const SizedBox(height: 8),
          BandeauProtection(context.t.marketRienAPayerMaintenantVerifiez),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            final id = ref
                .read(liveProvider.notifier)
                .reserverCommande(p, p.prix);
            context.go('/suivi/$id');
          },
          child: Text(context.t.marketFixerLeRendezVous),
        ),
      ),
    );
  }
}
