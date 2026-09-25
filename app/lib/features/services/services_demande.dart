part of 'services_screens.dart';

/// E-SRV-01 — Accueil Services : demande de devis, métiers, services à prix
/// fixe et professionnels disponibles.
class EcranServices extends ConsumerWidget {
  const EcranServices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envoyee = ref.watch(liveProvider).demandeEnvoyee;
    final marge = context.grandEcran ? 24.0 : 16.0;
    final fixes = [
      for (final p in prestataires)
        for (final s in p.services.take(1)) (p, s),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            tooltip: 'Voir sur la carte',
            onPressed: () => context.push('/carte?espace=services'),
            icon: const Icon(Icons.map_outlined),
          ),
          const BoutonNotifications(),
          const BoutonMessages(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [LiveColors.bleu, LiveColors.nuit],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Un problème à la maison ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Décrivez-le en 30 secondes, recevez des devis de pros vérifiés. '
                    'Votre acompte est protégé par Live.',
                    style: TextStyle(color: Color(0xFFD7DCE4)),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: LiveColors.nuit,
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: () => context.push('/services/demande'),
                    child: const Text('Demander des devis'),
                  ),
                ],
              ),
            ),
          ),
          if (envoyee)
            Padding(
              padding: EdgeInsets.fromLTRB(marge, 12, marge, 0),
              child: Bloc(
                padding: 4,
                child: ListTile(
                  leading: const Badge(
                    label: Text('3'),
                    child: Icon(
                      Icons.request_quote_outlined,
                      color: LiveColors.bleu,
                    ),
                  ),
                  title: const Text("Fuite d'eau cuisine"),
                  subtitle: const Text('3 devis reçus · expire dans 61 h'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/services/devis'),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('Métiers'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge - 8),
            child: GrilleAdaptative(
              largeurMax: 88,
              espacement: 0,
              hauteur: 92,
              enfants: [
                for (final (icone, nom) in metiers)
                  PuceIcone(
                    icone: icone,
                    texte: nom,
                    onTap: () => context.push('/services/demande'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('Réservez à prix fixe'),
          ),
          Carrousel(
            largeur: 200,
            hauteur: 150,
            marge: marge,
            enfants: [
              for (final (p, s) in fixes) _CarteServiceFixe(pro: p, service: s),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('Disponibles maintenant'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 460,
              espacement: 10,
              enfants: [for (final s in prestataires) CartePro(pro: s)],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 20, marge, 0),
            child: Bloc(
              child: Row(
                children: [
                  const Icon(Icons.handyman_rounded, color: LiveColors.bleu),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Vous êtes plombier, coiffeuse, traiteur ? Proposez vos services '
                      'et recevez des demandes près de chez vous.',
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/publier/service'),
                    child: const Text('Proposer'),
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

/// Service à prix fixe : même format pour toutes les cartes.
class _CarteServiceFixe extends StatelessWidget {
  const _CarteServiceFixe({required this.pro, required this.service});
  final Prestataire pro;
  final ServiceFixe service;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${service.titre} par ${pro.nom}, ${fcfa(service.prix)}',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/pro/${pro.id}/reserver/${service.id}'),
        child: Bloc(
          padding: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Avatar(nom: pro.nom, couleur: pro.couleur, taille: 32),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${pro.nom} · ${note(pro.note)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: LiveColors.gris,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                service.titre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    fcfa(service.prix),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: LiveColors.gris,
                  ),
                  Text(
                    ' ${service.duree}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: LiveColors.gris,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-SRV-03 — Demande de devis.
class EcranDemandeDevis extends ConsumerStatefulWidget {
  const EcranDemandeDevis({super.key});

  @override
  ConsumerState<EcranDemandeDevis> createState() => _EcranDemandeDevisState();
}

class _EcranDemandeDevisState extends ConsumerState<EcranDemandeDevis> {
  final _description = TextEditingController(
    text: "Fuite sous l'évier de la cuisine, l'eau coule en continu.",
  );
  var _metier = 'Plomberie';
  var _photos = 1;
  var _urgent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demander des devis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _metier,
            decoration: const InputDecoration(labelText: 'Métier'),
            items: const [
              DropdownMenuItem(value: 'Plomberie', child: Text('Plomberie')),
              DropdownMenuItem(
                value: 'Électricité',
                child: Text('Électricité'),
              ),
              DropdownMenuItem(
                value: 'Climatisation',
                child: Text('Climatisation'),
              ),
            ],
            onChanged: (v) => setState(() => _metier = v ?? _metier),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Décrivez le problème',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Photos (recommandé)'),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < _photos; i++)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Vignette(
                    couleur: Color(0xFF0369A1),
                    icone: Icons.water_drop,
                    hauteur: 60,
                    largeur: 60,
                    rayon: 8,
                  ),
                ),
              IconButton.outlined(
                tooltip: 'Ajouter une photo',
                onPressed: () => setState(() => _photos++),
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Quartier',
              hintText: 'Moungali',
            ),
          ),
          const SizedBox(height: 12),
          Choix(
            titre: 'Dès que possible',
            selectionne: _urgent,
            onTap: () => setState(() => _urgent = true),
          ),
          Choix(
            titre: 'À une date précise',
            selectionne: !_urgent,
            onTap: () => setState(() => _urgent = false),
          ),
          const Text(
            "Votre adresse exacte n'est donnée qu'au prestataire que vous choisirez.",
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            ref.read(liveProvider.notifier).envoyerDemande();
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Demande envoyée'),
                content: const Text(
                  'Envoyée à 12 pros vérifiés de votre quartier.\n\nPour le test : 3 devis sont arrivés.',
                ),
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(150, 44),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.pushReplacement('/services/devis');
                    },
                    child: const Text('Voir les devis'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Envoyer à des pros vérifiés'),
        ),
      ),
    );
  }
}

/// E-SRV-04 — Comparer les devis.
class EcranDevisRecus extends StatelessWidget {
  const EcranDevisRecus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fuite d'eau cuisine")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '3 devis reçus · expire dans 61 h',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          GrilleAdaptative(
            largeurMax: 480,
            enfants: [
              for (final d in devisRecus)
                Card(
                  child: InkWell(
                    onTap: () =>
                        context.push('/services/devis/${d.prestataire.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: d.prestataire.couleur,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${d.prestataire.nom} · ${note(d.prestataire.note)} (${d.prestataire.avis})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(d.quand),
                                Text(
                                  d.acompte == 0
                                      ? 'Payer à la fin'
                                      : 'Acompte ${fcfa(d.acompte)}',
                                  style: const TextStyle(
                                    color: LiveColors.gris,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            fcfa(d.total),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
