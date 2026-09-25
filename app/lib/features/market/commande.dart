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

  static const _lieux = [
    ('Station Total Moungali', 'Éclairée, gardiennée'),
    ('Marché Total, entrée principale', 'Très fréquenté'),
    ('Commissariat de Moungali', 'Point de remise sûr'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = produitParId(widget.id);
    if (p.reglement == Reglement.surPlace) return _surPlace(context, p);
    final total = p.prix * widget.quantite + (_livraison ? p.livraison : 0);
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
            subtitle: widget.variante == null && widget.quantite == 1
                ? null
                : Text(
                    [
                      if (widget.variante != null) 'Taille ${widget.variante}',
                      '× ${widget.quantite}',
                    ].join(' · '),
                  ),
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

  /// Occasion à voir avant d'acheter : on fixe un rendez-vous dans un lieu
  /// sûr, rien n'est payé maintenant.
  Widget _surPlace(BuildContext context, Produit p) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voir avant de payer')),
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
          const Text(
            'Lieu du rendez-vous',
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
          const Text(
            'Paiement à la remise',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const LigneMenu(
            icone: Icons.phone_android_rounded,
            titre: 'MoMo ou Airtel, au rendez-vous',
            detail:
                'Vous vérifiez l’objet, le vendeur appuie sur « Encaisser » '
                'et vous validez la demande sur votre téléphone.',
          ),
          const SizedBox(height: 8),
          const BandeauProtection(
            'Rien à payer maintenant. Vérifiez l’objet, testez-le, puis payez.',
          ),
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
          child: const Text('Fixer le rendez-vous'),
        ),
      ),
    );
  }
}
