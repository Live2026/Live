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
      appBar: EnTeteRecherche(
        titre: Text(context.t.explorerServices),
        indice: context.t.servicesPlombierCoiffureCours,
        onSubmitted: (q) => context.push('/recherche', extra: q),
        actions: [
          IconButton(
            tooltip: context.t.servicesVoirSurLaCarte,
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
                  Text(
                    context.t.servicesUnProblemeALa,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.t.servicesDecrivezLeEn30,
                    style: TextStyle(color: LiveColors.brumeClaire),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: LiveColors.surface,
                      foregroundColor: LiveColors.encre,
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: () => context.push('/services/demande'),
                    child: Text(context.t.servicesDemanderDesDevis),
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
                  title: Text(context.t.servicesFuiteDEauCuisine),
                  subtitle: Text(context.t.servicesN3DevisRecusExpire),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/services/devis'),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(context.t.servicesMetiers),
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
            child: EnTeteSection(context.t.servicesReservezAPrixFixe),
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
            child: EnTeteSection(context.t.servicesDisponiblesMaintenant),
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
                  Expanded(
                    child: Text(context.t.servicesVousEtesPlombierCoiffeuse),
                  ),
                  TextButton(
                    onPressed: () => context.push('/publier/service'),
                    child: Text(context.t.servicesProposer),
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
      label: context.t.servicesServiceParPro(
        service.titre,
        pro.nom,
        fcfa(service.prix),
      ),
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
  late final _description = TextEditingController(
    text: context.t.servicesFuiteSousLEvier,
  );
  var _metier = 'Plomberie';
  var _photos = 1;
  var _urgent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.servicesDemanderDesDevis)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _metier,
            decoration: InputDecoration(labelText: context.t.servicesMetier),
            items: [
              DropdownMenuItem(
                value: 'Plomberie',
                child: Text(context.t.servicesPlomberie),
              ),
              DropdownMenuItem(
                value: 'Électricité',
                child: Text(context.t.servicesElectricite),
              ),
              DropdownMenuItem(
                value: 'Climatisation',
                child: Text(context.t.servicesClimatisation),
              ),
            ],
            onChanged: (v) => setState(() => _metier = v ?? _metier),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: context.t.servicesDecrivezLeProbleme,
            ),
          ),
          const SizedBox(height: 12),
          Text(context.t.servicesPhotosRecommande),
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
                tooltip: context.t.servicesAjouterUnePhoto,
                onPressed: () => setState(() => _photos++),
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: context.t.servicesQuartier,
              hintText: 'Moungali',
            ),
          ),
          const SizedBox(height: 12),
          Choix(
            titre: context.t.servicesDesQuePossible,
            selectionne: _urgent,
            onTap: () => setState(() => _urgent = true),
          ),
          Choix(
            titre: context.t.servicesAUneDatePrecise,
            selectionne: !_urgent,
            onTap: () => setState(() => _urgent = false),
          ),
          Text(
            context.t.servicesVotreAdresseExacteN,
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
                title: Text(context.t.servicesDemandeEnvoyee),
                content: Text(context.t.servicesEnvoyeeA12Pros),
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(150, 44),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.pushReplacement('/services/devis');
                    },
                    child: Text(context.t.servicesVoirLesDevis),
                  ),
                ],
              ),
            );
          },
          child: Text(context.t.servicesEnvoyerADesPros),
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
      appBar: AppBar(title: Text(context.t.servicesFuiteDEauCuisine)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.servicesN3DevisRecusExpire,
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
                                      ? context.t.servicesPayerALaFin
                                      : context.t.servicesAcompteMontant(
                                          fcfa(d.acompte),
                                        ),
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
