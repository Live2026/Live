part of 'apprendre_screens.dart';

/// E-APP-06 — Vendre un contenu : assistant en 6 étapes (type, informations,
/// fichiers, prix, aperçu gratuit, vérification).
class EcranVendreContenu extends ConsumerStatefulWidget {
  const EcranVendreContenu({super.key});

  @override
  ConsumerState<EcranVendreContenu> createState() => _EcranVendreContenuState();
}

class _EcranVendreContenuState extends ConsumerState<EcranVendreContenu> {
  late final _titres = [
    context.t.apprendreQueVendezVous,
    context.t.apprendreInformations,
    context.t.apprendreFichiers,
    context.t.apprendrePrix,
    context.t.apprendreApercuGratuit,
    context.t.apprendreVerification,
  ];
  static const _prixProposes = [1000, 2500, 5000, 10000, 15000];

  var _etape = 0;
  var _type = TypeContenu.cours;
  late final _titre = TextEditingController(
    text: context.t.apprendreComptabiliteCommercants,
  );
  late var _niveau = context.t.apprendreDebutant;
  final _fichiers = <String>['Leçon 1 · Bienvenue.mp4 · 38 Mo'];
  var _prix = 5000;
  var _apercu = 0;
  var _bandeAnnonce = true;
  var _droits = false;
  var _publie = false;

  bool get _valide => switch (_etape) {
    1 => _titre.text.trim().isNotEmpty,
    2 => _fichiers.isNotEmpty,
    5 => _droits,
    _ => true,
  };

  @override
  Widget build(BuildContext context) {
    if (_publie) return _succes(context);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.apprendreVendreUnContenu)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          EtapesAssistant(titres: _titres, etape: _etape),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(key: ValueKey(_etape), child: _contenu()),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: BoutonsAssistant(
          etape: _etape,
          derniere: _etape == _titres.length - 1,
          onRetour: () => setState(() => _etape--),
          onSuivant: !_valide
              ? null
              : () {
                  if (_etape < _titres.length - 1) {
                    setState(() => _etape++);
                  } else {
                    ref.read(liveProvider.notifier).publierContenu(_titre.text);
                    setState(() => _publie = true);
                  }
                },
        ),
      ),
    );
  }

  Widget _contenu() {
    final gain = (_prix * 0.85).round();
    return switch (_etape) {
      0 => Column(
        children: [
          for (final t in TypeContenu.values)
            Choix(
              titre: t.libelleDe(context.t),
              icone: t.icone,
              sousTitre: switch (t) {
                TypeContenu.cours =>
                  context.t.apprendreLeconsVideoAvecExercices,
                TypeContenu.pdf => context.t.apprendreFichesAnnalesModeles,
                TypeContenu.video => context.t.apprendreUneVideoOuUn,
                TypeContenu.livre => context.t.apprendreEpubOuPdf,
                TypeContenu.serie => context.t.apprendreEpisodesCourtsReguliers,
                TypeContenu.qcm =>
                  context.t.apprendreQuestionsCorrigeesEtChronometrees,
                TypeContenu.coaching => context.t.apprendreSeanceEnDirectSur,
              },
              selectionne: _type == t,
              onTap: () => setState(() => _type = t),
            ),
        ],
      ),
      1 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titre,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(labelText: context.t.apprendreTitre),
          ),
          const SizedBox(height: 12),
          TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: context.t.apprendreDescription,
              hintText: context.t.apprendreCeQueLEleve,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.t.apprendreNiveau,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final n in [
                context.t.apprendreDebutant,
                context.t.apprendreIntermediaire,
                context.t.apprendreTerminale,
                context.t.apprendreProfessionnel,
              ])
                ChoiceChip(
                  label: Text(n),
                  selected: _niveau == n,
                  onSelected: (_) => setState(() => _niveau = n),
                ),
            ],
          ),
        ],
      ),
      2 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final f in _fichiers)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: Text(f),
              trailing: const Icon(
                Icons.check_circle,
                color: LiveColors.succes,
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => _fichiers.add(
                context.t.apprendreLeconExercices(_fichiers.length + 1),
              ),
            ),
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(context.t.apprendreAjouterUnFichier),
          ),
          const SizedBox(height: 10),
          Text(
            context.t.apprendreVideosPdfEpubImages,
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      3 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _prixProposes)
                ChoiceChip(
                  label: Text(fcfa(p)),
                  selected: _prix == p,
                  onSelected: (_) => setState(() => _prix = p),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Bloc(
            child: Column(
              children: [
                LigneMontant(context.t.apprendrePrixPayeParL, _prix),
                LigneMontant(context.t.apprendrePartDeLive15, _prix - gain),
                const Divider(),
                LigneMontant(context.t.apprendreVousRecevez, gain, gras: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.apprendreVerseSurVotreSolde,
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      4 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t.apprendrePartieOfferteEnApercu),
          const SizedBox(height: 6),
          for (final (i, f) in _fichiers.indexed)
            Choix(
              titre: f.split(' · ').take(2).join(' · '),
              selectionne: _apercu == i,
              onTap: () => setState(() => _apercu = i),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _bandeAnnonce,
            onChanged: (v) => setState(() => _bandeAnnonce = v),
            title: Text(context.t.apprendreVideoVerticaleDe30),
            subtitle: Text(context.t.apprendreVosFutursElevesVous),
          ),
        ],
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: CarteContenu(
              contenu: Contenu(
                id: 'apercu',
                titre: _titre.text,
                type: _type,
                auteur: Vendeur(ref.watch(liveProvider).prenom),
                prix: _prix,
                couleur: const Color(0xFF0F766E),
                format: context.t.apprendreNFichiers(_fichiers.length),
                nouveau: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _droits,
            onChanged: (v) => setState(() => _droits = v ?? false),
            title: Text(context.t.apprendreJeSuisLAuteur),
          ),
          Text(
            context.t.apprendreLiveVerifieChaqueContenu,
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
    };
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
              Text(
                context.t.apprendreContenuEnvoye,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                context.t.apprendreEnVerification(_titre.text),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/apprendre/boutique'),
                child: Text(context.t.apprendreVoirMaBoutique),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
