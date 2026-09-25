part of 'piliers_screens.dart';

/// Ce que la diaspora paie pour un proche, et le bénéficiaire payé.
const _besoins = [
  (Icons.home_rounded, 'Loyer', 'Payé à l’agence, reçu à votre nom', 90000),
  (
    Icons.shopping_basket_rounded,
    'Courses',
    'Livrées ou retirées au point relais',
    25000,
  ),
  (Icons.school_rounded, 'Scolarité', 'Versée à l’école, reçu officiel', 60000),
  (
    Icons.local_hospital_rounded,
    'Santé',
    'Pharmacie ou clinique partenaire',
    15000,
  ),
  (Icons.bolt_rounded, 'Factures', 'Électricité, eau, télévision', 18450),
  (Icons.handyman_rounded, 'Un pro', 'Plombier, électricien, maçon…', 25000),
];

/// E-DIA-01 — Diaspora : payer, depuis l'étranger, ce dont un proche a
/// besoin au pays, avec preuve de remise ; ou lui envoyer de l'argent
/// (Live Transfert). Paiement par carte dans la devise choisie (donnees_devises).
class EcranDiaspora extends ConsumerStatefulWidget {
  const EcranDiaspora({super.key});

  @override
  ConsumerState<EcranDiaspora> createState() => _EcranDiasporaState();
}

class _EcranDiasporaState extends ConsumerState<EcranDiaspora> {
  var _proche = 0;

  void _payerBesoin(String besoin, int montant) {
    final (nom, _, _, _) = proches[_proche];
    final d = deviseParCode(ref.read(liveProvider).devise);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$besoin pour $nom',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              LigneMontant('Montant au pays', montant),
              LigneMontant(
                'Soit, par carte',
                0,
                brut: d.ecrire(d.depuisFcfa(montant), decimales: true),
              ),
              const LigneMontant('Frais Live', 0, brut: '1,5 %'),
              const SizedBox(height: 8),
              const Text(
                'Votre proche est prévenu par SMS et montre son QR à la '
                'remise : vous recevez la photo du reçu et la confirmation.',
                style: TextStyle(color: LiveColors.gris),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _payer(
                    context,
                    ref,
                    TypePaiement.pourUnProche,
                    (montant * 1.015).round(),
                    '$besoin pour $nom',
                    besoin,
                    beneficiaire: nom,
                  );
                },
                child: const Text('Payer par carte'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final envois = ref.watch(liveProvider.select((e) => e.envois));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Diaspora')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.flight_land_rounded,
            titre: 'D’ici, prenez soin de ceux de là-bas',
            texte:
                'Payez le loyer, les courses ou l’école de vos proches, avec '
                'preuve de remise. Payez dans votre devise : euro, dollar, '
                'livre, franc suisse, yuan…',
            couleurs: const [Color(0xFF0369A1), LiveColors.nuit],
            enfant: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: LiveColors.orange,
                foregroundColor: LiveColors.nuit,
                minimumSize: const Size(0, 44),
              ),
              onPressed: () => context.push('/transfert'),
              icon: const Icon(Icons.send_rounded),
              label: const Text('Envoyer de l’argent · Live Transfert'),
            ),
          ),
          const EnTeteSection('Pour qui ?'),
          SizedBox(
            height: 104,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final (i, (nom, lieu, _, couleur)) in proches.indexed)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _proche = i),
                      child: Semantics(
                        selected: _proche == i,
                        button: true,
                        child: SizedBox(
                          width: 92,
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _proche == i
                                        ? LiveColors.orangeVif
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Avatar(
                                  nom: nom,
                                  couleur: couleur,
                                  taille: 52,
                                ),
                              ),
                              Text(
                                nom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                lieu.split(',').first,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 92,
                  child: Column(
                    children: [
                      IconButton.filledTonal(
                        tooltip: 'Ajouter un proche',
                        iconSize: 30,
                        onPressed: () =>
                            informer(context, 'Ajout par numéro de téléphone.'),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
                      const Text('Ajouter'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const EnTeteSection('Que voulez-vous payer ?'),
          GrilleAdaptative(
            largeurMax: 260,
            espacement: 10,
            hauteur: 112,
            enfants: [
              for (final (i, (icone, titre, texte, montant))
                  in _besoins.indexed)
                Apparition(
                  rang: i,
                  child: Pressable(
                    onTap: () => _payerBesoin(titre, montant),
                    child: Bloc(
                      padding: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icone, color: const Color(0xFF0369A1)),
                          const Spacer(),
                          Text(
                            titre,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            texte,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const EnTeteSection('Mes envois'),
          if (envois.isEmpty)
            const Text(
              'Vos paiements et transferts apparaîtront ici, avec leur preuve.',
              style: TextStyle(color: LiveColors.gris),
            )
          else
            for (final e in envois)
              LigneMenu(
                icone: Icons.verified_rounded,
                titre: e,
                detail: 'Payé · votre proche a été prévenu',
                couleur: LiveColors.succes,
              ),
        ],
      ),
    );
  }
}
