part of 'expansion_screens.dart';

/// E-API-01 — API partenaires (document 04, section 5) : banques, livreurs,
/// agences et écoles branchent leurs outils sur Live (catalogue, commandes,
/// Live Pay et séquestre, livraison), avec des clés de test puis de production.
class EcranPartenaires extends StatefulWidget {
  const EcranPartenaires({super.key});

  @override
  State<EcranPartenaires> createState() => _EcranPartenairesState();
}

class _EcranPartenairesState extends State<EcranPartenaires> {
  var _production = false;
  var _cleVisible = false;

  static const _apis = [
    (
      Icons.inventory_2_rounded,
      'Catalogue',
      'Publier et mettre à jour annonces, prix et stock depuis votre logiciel.',
    ),
    (
      Icons.receipt_long_rounded,
      'Commandes',
      'Recevoir les commandes, les accepter, suivre la remise par QR.',
    ),
    (
      Icons.lock_rounded,
      'Live Pay et séquestre',
      'Encaisser MoMo, Airtel Money et Visa ; argent bloqué jusqu’à la remise.',
    ),
    (
      Icons.two_wheeler_rounded,
      'Livraison',
      'Recevoir des courses, envoyer la position du livreur et le code de remise.',
    ),
    (
      Icons.verified_user_rounded,
      'Vérification',
      'Savoir si un vendeur ou une agence est vérifié, avec son accord.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final cle = _production ? 'live_prod_7Hq2…Xk91' : 'live_test_4Fz8…Mb20';
    return Scaffold(
      appBar: AppBar(title: const Text('API partenaires')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [LiveColors.bleu, LiveColors.nuit],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hub_rounded, color: LiveColors.ambreClair, size: 32),
                SizedBox(height: 8),
                Text(
                  'Branchez votre activité sur Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pour les banques, livreurs, agences, écoles et grandes '
                  'boutiques. Réservé aux espaces Pro vérifiés.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const EnTeteSection('Ce que vous pouvez faire'),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 10,
            hauteur: 86,
            enfants: [
              for (final (i, (icone, titre, texte)) in _apis.indexed)
                Apparition(
                  rang: i,
                  child: Bloc(
                    padding: 12,
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: LiveColors.voile,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icone, color: LiveColors.bleu),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                texte,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const EnTeteSection('Mes clés'),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Test')),
              ButtonSegment(value: true, label: Text('Production')),
            ],
            selected: {_production},
            onSelectionChanged: (v) => setState(() {
              _production = v.first;
              _cleVisible = false;
            }),
          ),
          const SizedBox(height: 10),
          Bloc(
            child: Row(
              children: [
                const Icon(Icons.key_rounded, color: LiveColors.cuivre),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _cleVisible ? cle : '•••• •••• •••• ••••',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: _cleVisible ? 'Masquer la clé' : 'Afficher la clé',
                  onPressed: () async {
                    if (_cleVisible) {
                      setState(() => _cleVisible = false);
                    } else if (await confirmer(
                      context,
                      titre: 'Afficher la clé',
                      texte: 'Ne la partagez jamais : elle donne accès à vos commandes et paiements.',
                      action: 'Afficher',
                    )) {
                      setState(() => _cleVisible = true);
                    }
                  },
                  icon: Icon(
                    _cleVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _production
                ? 'Production : vraies transactions. Afficher la clé demande votre code Live.'
                : 'Test : paiements simulés, aucun argent réel ne circule.',
            style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
          const EnTeteSection('Utilisation ce mois-ci'),
          const GrilleAdaptative(
            largeurMax: 260,
            espacement: 10,
            enfants: [
              TuileChiffre(
                icone: Icons.swap_horiz_rounded,
                valeur: '6 214',
                libelle: 'Appels',
              ),
              TuileChiffre(
                icone: Icons.check_circle_rounded,
                valeur: '99,8 %',
                libelle: 'Réussis',
                couleur: LiveColors.succes,
              ),
              TuileChiffre(
                icone: Icons.card_giftcard_rounded,
                valeur: '10 000',
                libelle: 'Appels gratuits par mois',
                couleur: LiveColors.cuivre,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LigneMenu(
            icone: Icons.webhook_rounded,
            titre: 'Adresse de notification (webhook)',
            detail: 'https://boutique-grace.cg/live',
            onTap: () => informer(context, 'Notification de test envoyée.'),
          ),
          LigneMenu(
            icone: Icons.menu_book_rounded,
            titre: 'Documentation',
            detail: 'Exemples en JavaScript, PHP et Python',
            onTap: () =>
                informer(context, 'Documentation : developpeurs.live.africa'),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton.icon(
          onPressed: () => informer(
            context,
            'Demande envoyée : un conseiller Live vous rappelle sous 48 h.',
          ),
          icon: const Icon(Icons.handshake_rounded),
          label: const Text('Devenir partenaire'),
        ),
      ),
    );
  }
}
