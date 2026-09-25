part of 'ia_screens.dart';

/// Demandes proposées à l'assistant, avec la réponse qu'il construit.
const _demandes = [
  'Un 2 pièces à Moungali à moins de 100 000',
  'Un plombier demain matin',
  'Un iPhone à moins de 90 000',
  'Payer ma facture d’électricité',
];

/// Langues de la voix : l'assistant comprend et répond dans chacune.
const _langues = [
  ('Français', 'Je cherche un 2 pièces à Moungali à moins de 100 000'),
  ('Lingala', 'Nazali koluka ndako ya bashambre mibale na Moungali'),
  ('Kituba', 'Mono ke sosa nzo ya bashambre zole na Moungali'),
];

/// E-IA-12 — Assistant Live : il cherche, compare, crée l'alerte, réserve la
/// visite ou ouvre le paiement, à l'écrit ou à la voix, en français, lingala
/// ou kituba. Gratuit pour agir dans Live ; les documents restent en crédits.
class EcranAssistant extends StatefulWidget {
  const EcranAssistant({super.key});

  @override
  State<EcranAssistant> createState() => _EcranAssistantState();
}

class _EcranAssistantState extends State<EcranAssistant> {
  final _fil = <(bool, String)>[
    (
      false,
      'Bonjour ! Dites-moi ce que vous cherchez : un logement, un pro, un '
          'objet, une facture à payer… Je m’occupe du reste.',
    ),
  ];
  final _saisie = TextEditingController();
  var _langue = 0;
  var _reflechit = false;
  String? _resultat;

  Future<void> _demander(String texte) async {
    if (texte.trim().isEmpty) return;
    setState(() {
      _fil.add((true, texte.trim()));
      _saisie.clear();
      _reflechit = true;
      _resultat = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final t = texte.toLowerCase();
    final type = t.contains('plomb')
        ? 'pro'
        : t.contains('iphone') || t.contains('téléphone')
        ? 'produit'
        : t.contains('facture') || t.contains('électricité')
        ? 'facture'
        : 'logement';
    setState(() {
      _reflechit = false;
      _resultat = type;
      _fil.add((
        false,
        switch (type) {
          'pro' =>
            'Serge, plombier vérifié à 1,2 km, est libre demain à 8 h. '
                'Note 4,9 sur 71 interventions. Je réserve ?',
          'produit' =>
            'J’ai trouvé 2 iPhone à moins de 90 000 FCFA près de vous. '
                'Le premier est au juste prix du marché.',
          'facture' =>
            'Votre facture E2C de septembre est de 18 450 FCFA, à payer avant '
                'le 5 octobre. Je l’ouvre ?',
          _ =>
            '3 appartements de 2 chambres à Moungali, de 75 000 à 95 000 FCFA. '
                'Le premier se visite mardi à 10 h 30.',
        },
      ));
    });
  }

  void _voix() {
    final (langue, phrase) = _langues[_langue];
    informer(context, 'Écoute en $langue… (simulation)');
    _demander(phrase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFFFF1E0),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: LiveColors.orangeVif,
              ),
            ),
            SizedBox(width: 10),
            Text('Assistant Live'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final (i, (moi, texte)) in _fil.indexed)
                  Apparition(
                    rang: i,
                    child: _Bulle(moi: moi, texte: texte),
                  ),
                if (_reflechit) const _Bulle(moi: false, texte: 'Je cherche…'),
                if (_resultat != null) _Actions(type: _resultat!),
                if (_fil.length == 1) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Essayez :',
                    style: TextStyle(color: LiveColors.gris),
                  ),
                  const SizedBox(height: 6),
                  for (final d in _demandes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ActionChip(
                          avatar: const Icon(
                            Icons.north_east_rounded,
                            size: 16,
                          ),
                          label: Text(d),
                          onPressed: () => _demander(d),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final (i, (langue, _)) in _langues.indexed)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(langue),
                              selected: _langue == i,
                              onSelected: (_) => setState(() => _langue = i),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _saisie,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _demander,
                          decoration: const InputDecoration(
                            hintText: 'Écrivez ou parlez…',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Parler',
                        onPressed: _voix,
                        style: IconButton.styleFrom(
                          backgroundColor: LiveColors.orangeVif,
                        ),
                        icon: const Icon(Icons.mic_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bulle extends StatelessWidget {
  const _Bulle({required this.moi, required this.texte});
  final bool moi;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: moi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: moi ? LiveColors.bleu : const Color(0xFFF3F5F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          texte,
          style: TextStyle(color: moi ? Colors.white : LiveColors.nuit),
        ),
      ),
    );
  }
}

/// Ce que l'assistant propose de faire, selon la demande.
class _Actions extends StatelessWidget {
  const _Actions({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final actions = switch (type) {
      'pro' => [
        ('Réserver Serge demain 8 h', '/pro/s1', Icons.event_available_rounded),
        ('Voir d’autres plombiers', '/services', Icons.handyman_rounded),
      ],
      'produit' => [
        (
          'Voir les 2 iPhone',
          '/market/liste?categorie=T%C3%A9l%C3%A9phones',
          Icons.smartphone_rounded,
        ),
        (
          'M’alerter des nouveaux',
          '/alertes',
          Icons.notifications_active_rounded,
        ),
      ],
      'facture' => [('Payer 18 450 FCFA', '/factures', Icons.bolt_rounded)],
      _ => [
        ('Réserver la visite de mardi', '/bien/b1/visite', Icons.event_rounded),
        ('Voir les 3 logements', '/immo', Icons.home_work_rounded),
        ('Créer l’alerte', '/alertes', Icons.notifications_active_rounded),
      ],
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (libelle, route, icone) in actions)
            ActionChip(
              avatar: Icon(icone, size: 18, color: LiveColors.bleu),
              label: Text(libelle),
              onPressed: () => context.push(route),
            ),
        ],
      ),
    );
  }
}
