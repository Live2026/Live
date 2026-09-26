part of 'direct_screens.dart';

/// E-DIR-03 — Lancer un direct (C-DIRECT, identité vérifiée) : aperçu de
/// la caméra, titre, produits à épingler (live shopping), options.
class EcranLancerDirect extends ConsumerStatefulWidget {
  const EcranLancerDirect({super.key});

  @override
  ConsumerState<EcranLancerDirect> createState() => _EcranLancerDirectState();
}

class _EcranLancerDirectState extends ConsumerState<EcranLancerDirect> {
  late final _titre = TextEditingController(text: context.t.directTitreDemo);
  final _epingles = <String>{'p2'};
  var _cadeaux = true;
  var _commentaires = true;
  var _public = 'Tout le monde';

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final marge = context.grandEcran ? 24.0 : 16.0;
    if (!etat.identiteVerifiee) {
      return Scaffold(
        appBar: AppBar(title: Text(context.t.directLancerUnDirect)),
        body: EtatVide(
          icone: Icons.videocam_off_outlined,
          texte: context.t.directOuvrirUnDirectEst,
          action: context.t.directVerifierMonIdentite,
          onTap: () => context.push('/verifier'),
        ),
      );
    }
    final mesProduits = produitsDe(graceMode);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.directLancerUnDirect)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Vignette(
                  couleur: Color(0xFF334155),
                  icone: Icons.face_retouching_natural,
                  rayon: 16,
                ),
                const Positioned(left: 12, top: 12, child: PastilleDirect()),
                Positioned(
                  right: 12,
                  top: 12,
                  child: BoutonVerre(
                    icone: Icons.flip_camera_ios_rounded,
                    libelle: context.t.directRetournerLaCamera,
                    onTap: () {},
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Etiquette(
                    context.t.directReseauBon720p,
                    icone: Icons.network_check_rounded,
                    fond: Colors.black45,
                    couleur: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titre,
            maxLength: 80,
            decoration: InputDecoration(
              labelText: context.t.directTitreDuDirect,
            ),
          ),
          EnTeteSection(context.t.directProduitsAEpingler),
          Text(
            context.t.directLesSpectateursLesAchetent,
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          for (final p in mesProduits)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _epingles.contains(p.id),
              onChanged: (v) => setState(
                () => v == true ? _epingles.add(p.id) : _epingles.remove(p.id),
              ),
              secondary: Vignette(
                couleur: p.couleur,
                icone: p.icone,
                hauteur: 44,
                largeur: 44,
                rayon: 8,
              ),
              title: Text(p.titre),
              subtitle: Text(fcfa(p.prix)),
            ),
          EnTeteSection(context.t.directReglages),
          LigneMenu(
            icone: Icons.public_rounded,
            titre: context.t.directQuiPeutRegarder,
            valeur: switch (_public) {
              'Mes abonnés' => context.t.directMesAbonnes,
              'Mes fans' => context.t.directMesFans,
              _ => context.t.directToutLeMonde,
            },
            onTap: () async {
              final c = await choisir<String>(
                context,
                titre: context.t.directQuiPeutRegarder,
                actuel: _public,
                options: [
                  ('Tout le monde', context.t.directToutLeMonde, null),
                  ('Mes abonnés', context.t.directMesAbonnes, null),
                  (
                    'Mes fans',
                    context.t.directMesFans,
                    context.t.directAbonnesPayants,
                  ),
                ],
              );
              if (c != null) setState(() => _public = c);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _cadeaux,
            onChanged: (v) => setState(() => _cadeaux = v),
            title: Text(context.t.directAccepterLesCadeaux),
            subtitle: Text(context.t.directVousRecevez75De),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _commentaires,
            onChanged: (v) => setState(() => _commentaires = v),
            title: Text(context.t.directCommentaires),
            subtitle: Text(context.t.directFiltreAntiArnaqueToujours),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFE2C55),
          ),
          onPressed: () => context.pushReplacement('/direct/d1'),
          icon: const Icon(Icons.videocam_rounded),
          label: Text(context.t.directLancerLeDirect),
        ),
      ),
    );
  }
}
