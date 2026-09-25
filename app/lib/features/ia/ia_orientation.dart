part of 'ia_screens.dart';

/// Champ « Que voulez-vous faire ? » de l'accueil Live IA.
/// Ce n'est pas une conversation facturée au mot : la demande oriente vers un
/// service à prix fixe, affiché avant l'utilisation (R-CR-04).

/// Mots qui orientent vers chaque service (en minuscules, sans accents).
const _motsServices = {
  'exercice': [
    'exercice',
    'equation',
    'maths',
    'math',
    'physique',
    'chimie',
    'devoir',
    'probleme',
    'calcul',
    'bac',
    'bepc',
    'resoudre',
  ],
  'resume': ['resume', 'resumer', 'cours', 'pdf', 'synthese'],
  'cv': ['cv', 'curriculum', 'emploi', 'poste', 'travail'],
  'lettre': ['lettre', 'motivation', 'candidature', 'stage', 'postuler'],
  'candidature': ['candidature', 'postuler', 'offre'],
  'bp_express': [
    'business',
    'plan',
    'activite',
    'commerce',
    'projet',
    'boutique',
  ],
  'bp_complet': [
    'business',
    'plan',
    'banque',
    'pret',
    'financement',
    'previsionnel',
  ],
  'vocal': ['oral', 'entretien', 'anglais', 'parler', 'vocal', 'reviser'],
};

/// Suggestions populaires : un appui lance l'orientation avec ce texte.
const _suggestionsIa = [
  (Icons.calculate_outlined, 'Résoudre un exercice de maths'),
  (Icons.badge_outlined, 'Faire mon CV'),
  (Icons.mail_outline, 'Écrire une lettre de motivation'),
  (Icons.storefront_outlined, 'Monter mon business plan'),
];

String _sansAccents(String s) {
  const de = 'àâäéèêëîïôöùûüç';
  const vers = 'aaaeeeeiioouuuc';
  final b = StringBuffer();
  for (final c in s.toLowerCase().split('')) {
    final i = de.indexOf(c);
    b.write(i < 0 ? c : vers[i]);
  }
  return b.toString();
}

/// Services qui répondent à la demande, du plus pertinent au moins pertinent.
List<ServiceIa> servicesPour(String demande) {
  final mots = _sansAccents(demande).split(RegExp(r'[^a-z0-9]+'));
  final scores = <ServiceIa, int>{};
  for (final s in servicesIa) {
    final cles = _motsServices[s.id] ?? const [];
    final n = mots.where(cles.contains).length;
    if (n > 0) scores[s] = n;
  }
  return scores.keys.toList()..sort((a, b) => scores[b]! - scores[a]!);
}

class _ChampOrientation extends StatefulWidget {
  const _ChampOrientation();

  @override
  State<_ChampOrientation> createState() => _ChampOrientationState();
}

class _ChampOrientationState extends State<_ChampOrientation> {
  final _texte = TextEditingController();

  @override
  void dispose() {
    _texte.dispose();
    super.dispose();
  }

  void _envoyer([String? demande]) {
    final d = (demande ?? _texte.text).trim();
    if (d.isEmpty) return;
    _orienter(context, d);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _texte,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _envoyer(),
          decoration: InputDecoration(
            hintText: 'Que voulez-vous faire ?',
            prefixIcon: const Icon(
              Icons.auto_awesome,
              color: LiveColors.orange,
            ),
            suffixIcon: IconButton(
              tooltip: 'Trouver le bon service',
              onPressed: _envoyer,
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (icone, texte) in _suggestionsIa)
              ActionChip(
                avatar: Icon(icone, size: 18, color: LiveColors.bleu),
                label: Text(texte),
                onPressed: () {
                  _texte.text = texte;
                  _envoyer(texte);
                },
              ),
          ],
        ),
      ],
    );
  }
}

/// Panneau du bas : services proposés pour la demande, prix fixe visible.
Future<void> _orienter(BuildContext context, String demande) {
  final trouves = servicesPour(demande);
  final liste = trouves.isEmpty
      ? servicesIa.where((s) => s.disponible).toList()
      : trouves;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    builder: (ctx) => ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        Text(
          trouves.isEmpty
              ? 'Aucun service ne correspond exactement. Voici ce que Live IA sait faire :'
              : 'Pour « $demande », Live IA vous propose :',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          'Prix fixe, confirmé avant la génération. Aucun coût au mot.',
          style: TextStyle(color: LiveColors.gris),
        ),
        const SizedBox(height: 12),
        for (final s in liste.take(4))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 84,
              child: _CarteService(service: s, avant: () => Navigator.pop(ctx)),
            ),
          ),
      ],
    ),
  );
}
