part of 'direct_screens.dart';

/// E-DIR-03 — Lancer un direct (C-DIRECT, identité vérifiée) : aperçu de
/// la caméra, titre, produits à épingler (live shopping), options.
class EcranLancerDirect extends ConsumerStatefulWidget {
  const EcranLancerDirect({super.key});

  @override
  ConsumerState<EcranLancerDirect> createState() => _EcranLancerDirectState();
}

class _EcranLancerDirectState extends ConsumerState<EcranLancerDirect> {
  final _titre = TextEditingController(text: 'Nouvel arrivage wax en direct');
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
        appBar: AppBar(title: const Text('Lancer un direct')),
        body: EtatVide(
          icone: Icons.videocam_off_outlined,
          texte:
              '« Ouvrir un direct » est un super-pouvoir : vérifiez votre '
              'identité (2 minutes). C’est ce qui protège les acheteurs pendant '
              'le live shopping.',
          action: 'Vérifier mon identité',
          onTap: () => context.push('/verifier'),
        ),
      );
    }
    final mesProduits = produitsDe(graceMode);
    return Scaffold(
      appBar: AppBar(title: const Text('Lancer un direct')),
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
                    libelle: 'Retourner la caméra',
                    onTap: () {},
                  ),
                ),
                const Positioned(
                  left: 12,
                  bottom: 12,
                  child: Etiquette(
                    'Réseau bon · 720p',
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
            decoration: const InputDecoration(labelText: 'Titre du direct'),
          ),
          const EnTeteSection('Produits à épingler'),
          const Text(
            'Les spectateurs les achètent sans quitter le direct, payés dans Live.',
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
          const EnTeteSection('Réglages'),
          LigneMenu(
            icone: Icons.public_rounded,
            titre: 'Qui peut regarder',
            valeur: _public,
            onTap: () async {
              final c = await choisir<String>(
                context,
                titre: 'Qui peut regarder',
                actuel: _public,
                options: const [
                  ('Tout le monde', 'Tout le monde', null),
                  ('Mes abonnés', 'Mes abonnés', null),
                  ('Mes fans', 'Mes fans', 'Abonnés payants seulement'),
                ],
              );
              if (c != null) setState(() => _public = c);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _cadeaux,
            onChanged: (v) => setState(() => _cadeaux = v),
            title: const Text('Accepter les cadeaux'),
            subtitle: const Text('Vous recevez 75 % de chaque cadeau'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _commentaires,
            onChanged: (v) => setState(() => _commentaires = v),
            title: const Text('Commentaires'),
            subtitle: const Text('Filtre anti-arnaque toujours actif'),
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
          label: const Text('Lancer le direct'),
        ),
      ),
    );
  }
}
