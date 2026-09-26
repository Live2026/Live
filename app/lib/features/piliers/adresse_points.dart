part of 'piliers_screens.dart';

/// E-QUO-02 — Adresse Live : un code court (quartier et numéro) lié à une
/// position GPS, un repère et la photo du portail. Là où les rues n'ont pas
/// de nom, livreurs, visiteurs et pros vous trouvent avec ce code.
class EcranAdresseLive extends StatelessWidget {
  const EcranAdresseLive({super.key});

  static const _code = 'MNG-4821';
  static const _position = Offset(0.45, 0.47);

  @override
  Widget build(BuildContext context) {
    final grand = context.grandEcran;
    final carte = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: grand ? 460 : 260,
        child: CarteInteractive(
          maPosition: _position,
          lieuVueRue: 'Moungali, derrière le marché Total',
          reperes: [
            Repere(
              position: _position,
              libelle: 'Chez moi',
              selectionne: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Bloc(
          child: Column(
            children: [
              const Text(
                'Mon Adresse Live',
                style: TextStyle(color: LiveColors.gris),
              ),
              const Text(
                _code,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const Text('Moungali · Brazzaville'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => informer(context, 'Code copié : $_code'),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text('Copier'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => partager(
                        context,
                        'Mon Adresse Live : $_code · live.africa/a/$_code',
                      ),
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Partager'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Bloc(
          child: Row(
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: Vignette(
                  couleur: Color(0xFF1D4ED8),
                  icone: Icons.door_front_door_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repère',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Derrière le marché Total, portail bleu, 3e maison '
                      'après la boutique Chez Ya Mado.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final (icone, texte) in const [
          (
            Icons.two_wheeler_rounded,
            'Le livreur voit l’itinéraire et la photo du portail',
          ),
          (
            Icons.home_work_rounded,
            'Vos visiteurs et vos pros trouvent sans appeler',
          ),
          (
            Icons.lock_outline_rounded,
            'Visible seulement par ceux à qui vous l’envoyez',
          ),
        ])
          LigneMenu(icone: icone, titre: texte),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Adresse Live')),
      body: ListView(
        padding: EdgeInsets.all(grand ? 24 : 16),
        children: [
          if (grand)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: carte),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: details),
              ],
            )
          else ...[
            carte,
            const SizedBox(height: 14),
            details,
          ],
        ],
      ),
    );
  }
}

/// E-QUO-03 — Points relais : boutiques partenaires où déposer et retirer
/// un colis, et changer des espèces en Mobile Money (dépôt MoMo, Airtel).
class EcranPointsRelais extends StatefulWidget {
  const EcranPointsRelais({super.key});

  @override
  State<EcranPointsRelais> createState() => _EcranPointsRelaisState();
}

class _EcranPointsRelaisState extends State<EcranPointsRelais> {
  var _choix = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Points relais')),
      body: ListView(
        padding: EdgeInsets.all(context.grandEcran ? 24 : 16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: context.grandEcran ? 380 : 240,
              child: CarteInteractive(
                maPosition: const Offset(0.47, 0.5),
                lieuVueRue: pointsRelais[_choix].$2,
                reperes: [
                  for (final (i, (nom, _, _, pos)) in pointsRelais.indexed)
                    Repere(
                      position: pos,
                      libelle: nom.split(' ').first,
                      selectionne: i == _choix,
                      couleur: LiveColors.succes,
                      onTap: () => setState(() => _choix = i),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final (i, (nom, lieu, horaires, _)) in pointsRelais.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Pressable(
                onTap: () => setState(() => _choix = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: LiveColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: i == _choix ? LiveColors.succes : LiveColors.filet,
                      width: i == _choix ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nom,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '$lieu · $horaires',
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                      const SizedBox(height: 8),
                      const Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Etiquette(
                            'Dépôt de colis',
                            icone: Icons.inventory_2_rounded,
                          ),
                          Etiquette('Retrait', icone: Icons.qr_code_2_rounded),
                          Etiquette(
                            'Espèces en MoMo',
                            icone: Icons.payments_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const Text(
            'Au point relais, le colis est remis contre votre QR ; les '
            'espèces sont converties en Mobile Money par un agent agréé.',
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
