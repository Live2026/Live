part of 'compte_screens.dart';

List<(TypeEspace, IconData, String, String)> _typesEspace(Textes t) => [
  (
    TypeEspace.boutique,
    Icons.storefront_rounded,
    t.compteBoutique,
    t.compteCatalogueVideosLivraison,
  ),
  (
    TypeEspace.agence,
    Icons.apartment_rounded,
    t.compteAgenceImmobiliere,
    t.compteBiensAgentsVisites,
  ),
  (
    TypeEspace.prestataire,
    Icons.handyman_rounded,
    t.comptePrestataire,
    t.compteServicesDevisAgenda,
  ),
  (
    TypeEspace.chaine,
    Icons.live_tv_rounded,
    t.compteChaineDeCreateur,
    t.compteVideosFansDirects,
  ),
];

/// E-MOI-04 — Créer un espace professionnel (passage au niveau N3).
class EcranCreerEspace extends ConsumerStatefulWidget {
  const EcranCreerEspace({super.key});

  @override
  ConsumerState<EcranCreerEspace> createState() => _EcranCreerEspaceState();
}

class _EcranCreerEspaceState extends ConsumerState<EcranCreerEspace> {
  TypeEspace? _type;
  final _nom = TextEditingController(text: 'Grâce Mode Bacongo');
  final _pieces = <String>{};
  var _cree = false;

  List<String> get _justificatifs => [
    context.t.compteRccmRegistreDuCommerce,
    context.t.compteNiuNumeroDIdentification,
    if (_type == TypeEspace.agence) context.t.compteAgrementDAgenceImmobiliere,
    context.t.compteJustificatifDAdresseDu,
  ];

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    if (_cree) return _succes(context);
    final pret =
        _type != null &&
        _nom.text.trim().isNotEmpty &&
        _pieces.length == _justificatifs.length;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteCreerUnEspace)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!etat.identiteVerifiee) ...[
            Bloc(
              fond: LiveColors.teinteCreme,
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: LiveColors.cuivre,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(context.t.compteUnEspaceProDemande)),
                  TextButton(
                    onPressed: () => context.push('/verifier'),
                    child: Text(context.t.compteVerifier),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            context.t.compteQuelEspace,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            hauteur: 120,
            enfants: [
              for (final (type, icone, titre, detail) in _typesEspace(
                context.t,
              ))
                Semantics(
                  button: true,
                  selected: _type == type,
                  label: titre,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => setState(() {
                      _type = type;
                      _pieces.clear();
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _type == type
                            ? LiveColors.voile
                            : LiveColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _type == type
                              ? LiveColors.bleu
                              : LiveColors.filet,
                          width: _type == type ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icone, color: LiveColors.bleu),
                          const Spacer(),
                          Text(
                            titre,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            detail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_type != null) ...[
            const SizedBox(height: 20),
            TextField(
              controller: _nom,
              decoration: InputDecoration(
                labelText: context.t.compteNomDeLEspace,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Text(
              context.t.compteJustificatifs,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            Text(
              context.t.compteVerifiesParLiveSous,
              style: TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 8),
            for (final j in _justificatifs)
              LigneMenu(
                icone: _pieces.contains(j)
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                couleur: _pieces.contains(j)
                    ? LiveColors.succes
                    : LiveColors.bleu,
                titre: j,
                detail: _pieces.contains(j)
                    ? context.t.compteAjoute
                    : context.t.comptePhotoOuPdf,
                onTap: () => setState(() => _pieces.add(j)),
              ),
          ],
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: pret && etat.identiteVerifiee
              ? () {
                  ref
                      .read(liveProvider.notifier)
                      .creerEspace(_nom.text.trim(), _type!);
                  setState(() => _cree = true);
                }
              : null,
          child: Text(context.t.compteCreerMonEspace),
        ),
      ),
    );
  }

  Widget _succes(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CocheAnimee(taille: 96),
              const SizedBox(height: 12),
              Text(
                context.t.compteEspaceCree(_nom.text),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.t.compteSuperPouvoirDebloqueAgence,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/moi'),
                  child: Text(context.t.compteAllerAMonEspace),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/espace/equipe'),
                child: Text(context.t.compteInviterMonEquipe),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-MOI-05 — Équipe de l'espace : membres et rôles internes.
class EcranEquipe extends StatelessWidget {
  const EcranEquipe({super.key});

  @override
  Widget build(BuildContext context) {
    final membres = [
      (
        'Grâce Mabiala',
        context.t.compteProprietaire,
        context.t.compteTousLesDroits,
        Color(0xFF13385C),
      ),
      (
        'Christian N.',
        context.t.compteGestionnaire,
        context.t.compteAnnoncesVisitesMessages,
        Color(0xFF166534),
      ),
      (
        'Mireille O.',
        context.t.compteAgent,
        context.t.compteVisitesEtMessages,
        Color(0xFF7E22CE),
      ),
      (
        'Junior K.',
        context.t.compteAgent,
        context.t.compteVisitesEtMessages,
        Color(0xFF0369A1),
      ),
      (
        'Estelle B.',
        context.t.compteComptable,
        context.t.compteConsultationDesFinances,
        Color(0xFF9A3412),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteEquipe)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.compteN5MembresSur5,
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          for (final (nom, role, droits, couleur) in membres)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Avatar(nom: nom, couleur: couleur, verifie: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nom,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          droits,
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Etiquette(
                    role,
                    fond: LiveColors.voile,
                    couleur: LiveColors.bleu,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          BandeauProtection(context.t.compteSeulLeProprietairePeut),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(context.t.compteAuDelaDe5))),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: Text(context.t.compteInviterUnMembre),
        ),
      ),
    );
  }
}
