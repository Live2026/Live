part of 'expansion_screens.dart';

/// E-FIN-01 — Services financiers en partenariat (phase 3, document 02
/// §4.6) : paiement en 3 fois, tirelire, micro-crédit vendeur, proposés
/// uniquement avec des établissements agréés. Live n'est pas une banque.
class EcranFinance extends StatefulWidget {
  const EcranFinance({super.key});

  @override
  State<EcranFinance> createState() => _EcranFinanceState();
}

class _EcranFinanceState extends State<EcranFinance> {
  var _epargne = 10.0;

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    const prix = 85000;
    const objectif = 150000;
    const epargne = 62000;
    return Scaffold(
      appBar: AppBar(title: const Text('Services financiers')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 12,
            enfants: [
              _Service(
                icone: Icons.splitscreen_rounded,
                titre: 'Payer en 3 fois',
                texte:
                    'Un téléphone à ${fcfa(prix)} : 3 × ${fcfa((prix / 3).ceil())}, sans frais cachés.',
                enfant: const ProgressionEtapes(
                  etapes: ['Aujourd’hui', 'Dans 1 mois', 'Dans 2 mois'],
                  actuelle: 0,
                ),
                action: 'Voir les produits éligibles',
                onTap: () => context.push(
                  '/market/liste?categorie=T%C3%A9l%C3%A9phones',
                ),
              ),
              _Service(
                icone: Icons.savings_rounded,
                titre: 'Tirelire Live',
                texte:
                    'Mettez de côté une part de chaque vente, automatiquement.',
                enfant: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fcfa(epargne)} sur ${fcfa(objectif)} · nouvelle moto',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: epargne / objectif),
                      duration: const Duration(milliseconds: 900),
                      curve: courbeDouce,
                      builder: (_, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        color: LiveColors.succes,
                        backgroundColor: const Color(0xFFE4E8EE),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${_epargne.round()} % de chaque vente'),
                    Slider(
                      value: _epargne,
                      min: 0,
                      max: 30,
                      divisions: 6,
                      label: '${_epargne.round()} %',
                      onChanged: (v) => setState(() => _epargne = v),
                    ),
                  ],
                ),
                action: 'Mettre à jour',
                onTap: () => informer(
                  context,
                  'Tirelire : ${_epargne.round()} % de chaque vente.',
                ),
              ),
              _Service(
                icone: Icons.account_balance_rounded,
                titre: 'Micro-crédit vendeur',
                texte:
                    'Grâce à vos ventes dans Live, jusqu’à ${fcfa(300000)} pour votre stock, remboursés sur vos ventes.',
                enfant: const Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: LiveColors.succes,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text('Éligible : 214 ventes, note 4,8, 0 litige'),
                    ),
                  ],
                ),
                action: 'Simuler un crédit',
                onTap: () => informer(
                  context,
                  'Simulation : ${fcfa(200000)} sur 6 mois, remboursés par 10 % de vos ventes.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Ces services sont fournis par des établissements agréés par la '
            'COBAC. Live transmet votre demande, avec votre accord ; il ne '
            'prête pas lui-même.',
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _Service extends StatelessWidget {
  const _Service({
    required this.icone,
    required this.titre,
    required this.texte,
    required this.enfant,
    required this.action,
    required this.onTap,
  });
  final IconData icone;
  final String titre;
  final String texte;
  final Widget enfant;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: LiveColors.orangeVif),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(texte),
          const SizedBox(height: 10),
          enfant,
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onTap, child: Text(action)),
          ),
        ],
      ),
    );
  }
}
