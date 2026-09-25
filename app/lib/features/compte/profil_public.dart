part of 'compte_screens.dart';

const _avisDemo = [
  ('Nadège L.', 5, 'Livraison le jour même, conforme aux photos.', 'hier'),
  ('Jordy M.', 5, 'Vendeur sérieux, je recommande.', 'lun.'),
  ('Prince B.', 4, 'Bon produit, un peu de retard.', '12 sept.'),
];

/// E-MKT-06 — Page boutique ou agence : vitrine publique d'un espace vérifié.
class EcranBoutique extends StatelessWidget {
  const EcranBoutique({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final v = vendeurParId(id);
    final prods = produitsDe(v);
    final lesBiens = biensDe(v);
    return _PageProfil(
      nom: v.nom,
      pseudo: '@${v.id}',
      couleur: v.couleur,
      badge: v.badge,
      bio: v.bio,
      stats: [
        (compact(v.abonnes), 'Abonnés'),
        ('${v.ventes}', lesBiens.isEmpty ? 'Ventes' : 'Locations'),
        (note(v.note).replaceAll('/5', ''), 'Note'),
        (v.reponse, 'Répond en'),
      ],
      idSuivi: v.id,
      onglets: [
        (
          lesBiens.isEmpty ? 'Produits' : 'Biens',
          lesBiens.isEmpty
              ? GrilleAdaptative(
                  largeurMax: 200,
                  espacement: 12,
                  enfants: [for (final p in prods) CarteProduit(produit: p)],
                )
              : GrilleAdaptative(
                  largeurMax: 220,
                  espacement: 12,
                  enfants: [for (final b in lesBiens) CarteBien(bien: b)],
                ),
        ),
        ('Vidéos', _GrilleVideos(couleur: v.couleur)),
        ('Avis', const _ListeAvis()),
      ],
      infos: [
        (Icons.location_on_outlined, '${v.quartier}, Brazzaville'),
        (Icons.calendar_month_outlined, 'Sur Live depuis ${v.depuis}'),
        (Icons.local_shipping_outlined, 'Livraison ou remise en main propre'),
      ],
    );
  }
}

/// E-MOI-07 — Profil public d'un utilisateur (ou le mien, avec « moi »).
class EcranProfilPublic extends ConsumerWidget {
  const EcranProfilPublic({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final moi = id == 'moi';
    final nom = moi ? '${etat.prenom} Mabiala' : 'Merveille K.';
    return _PageProfil(
      nom: nom,
      pseudo: moi ? '@${etat.prenom.toLowerCase()}.mabiala' : '@merveille.k',
      couleur: moi ? LiveColors.bleu : const Color(0xFF7E22CE),
      badge: libelleNiveau(moi ? etat.niveau : 2),
      bio: moi
          ? 'Comptable à Brazzaville. Je vends ce dont je ne me sers plus.'
          : 'Étudiante, fan de mode et de bonnes affaires.',
      stats: const [
        ('128', 'Abonnés'),
        ('4', 'Abonnements'),
        ('4,8', 'Note'),
        ('12', 'Transactions'),
      ],
      idSuivi: moi ? null : 'merveille',
      onglets: [
        (
          'Vidéos',
          _GrilleVideos(
            couleur: moi ? LiveColors.bleu : const Color(0xFF7E22CE),
          ),
        ),
        (
          'Annonces',
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 12,
            enfants: [
              for (final p in produits.skip(3).take(2))
                CarteProduit(produit: p),
            ],
          ),
        ),
        ('Avis', const _ListeAvis()),
      ],
      infos: const [
        (Icons.location_on_outlined, 'Moungali, Brazzaville'),
        (Icons.calendar_month_outlined, 'Sur Live depuis septembre 2026'),
      ],
    );
  }
}

/// Mise en page commune des profils : couverture, avatar, chiffres, onglets.
class _PageProfil extends ConsumerStatefulWidget {
  const _PageProfil({
    required this.nom,
    required this.pseudo,
    required this.couleur,
    required this.badge,
    required this.bio,
    required this.stats,
    required this.idSuivi,
    required this.onglets,
    required this.infos,
  });
  final String nom;
  final String pseudo;
  final Color couleur;
  final String badge;
  final String bio;
  final List<(String, String)> stats;

  /// Identifiant à suivre ; nul pour mon propre profil.
  final String? idSuivi;
  final List<(String, Widget)> onglets;
  final List<(IconData, String)> infos;

  @override
  ConsumerState<_PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends ConsumerState<_PageProfil> {
  var _onglet = 0;

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final suivi =
        w.idSuivi != null &&
        ref.watch(liveProvider.select((e) => e.suivis.contains(w.idSuivi)));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: 'Partager',
                onPressed: () => partager(context, w.nom),
                icon: const Icon(Icons.ios_share_rounded),
              ),
              IconButton(
                tooltip: 'Options',
                onPressed: () => signaler(context, 'ce profil'),
                icon: const Icon(Icons.more_horiz_rounded),
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(marge, 0, marge, 32),
            sliver: SliverList.list(
              children: [
                // Couverture et avatar qui déborde, dans le flux de la page.
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            w.couleur,
                            Color.lerp(w.couleur, LiveColors.nuit, 0.6)!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: -44,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Avatar(
                          nom: w.nom,
                          couleur: w.couleur,
                          taille: 84,
                          verifie: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 52),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      w.nom,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      w.pseudo,
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                    const SizedBox(height: 4),
                    BadgeVerifie(w.badge),
                    const SizedBox(height: 8),
                    Text(w.bio),
                    const SizedBox(height: 8),
                    for (final (icone, texte) in w.infos)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(icone, size: 16, color: LiveColors.gris),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                texte,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        for (final (valeur, libelle) in w.stats)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  valeur,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  libelle,
                                  style: const TextStyle(
                                    color: LiveColors.gris,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (w.idSuivi != null)
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: suivi
                                  ? OutlinedButton.icon(
                                      key: const ValueKey('suivi'),
                                      onPressed: () => ref
                                          .read(liveProvider.notifier)
                                          .basculerSuivi(w.idSuivi!),
                                      icon: const Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Abonné'),
                                    )
                                  : FilledButton(
                                      key: const ValueKey('suivre'),
                                      onPressed: () => ref
                                          .read(liveProvider.notifier)
                                          .basculerSuivi(w.idSuivi!),
                                      child: const Text('Suivre'),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.push('/conversation'),
                              child: const Text('Écrire'),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    SegmentedButton<int>(
                      showSelectedIcon: false,
                      segments: [
                        for (final (i, (titre, _)) in w.onglets.indexed)
                          ButtonSegment(value: i, label: Text(titre)),
                      ],
                      selected: {_onglet},
                      onSelectionChanged: (s) =>
                          setState(() => _onglet = s.first),
                    ),
                    const SizedBox(height: 14),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: KeyedSubtree(
                        key: ValueKey(_onglet),
                        child: w.onglets[_onglet].$2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grille de vidéos en 9:16, 3 colonnes, avec le nombre de vues.
class _GrilleVideos extends StatelessWidget {
  const _GrilleVideos({required this.couleur});
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    const vues = ['12,4k', '8,1k', '3,2k', '21k', '980', '4,4k'];
    return LayoutBuilder(
      builder: (context, c) {
        final colonnes = c.maxWidth > 700 ? 5 : 3;
        final largeur = (c.maxWidth - 4 * (colonnes - 1)) / colonnes;
        return Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final (i, v) in vues.indexed)
              SizedBox(
                width: largeur,
                height: largeur * 16 / 9,
                child: InkWell(
                  onTap: () => context.go('/accueil'),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Vignette(
                        couleur: Color.lerp(couleur, Colors.black, i * 0.08)!,
                        icone: Icons.play_arrow_rounded,
                        rayon: 6,
                      ),
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.play_arrow_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                            Text(
                              v,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ListeAvis extends StatelessWidget {
  const _ListeAvis();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              '4,8',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Etoiles(4.8, taille: 18),
                Text(
                  '214 avis vérifiés · acheteurs ayant payé dans Live',
                  style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                ),
              ],
            ),
          ],
        ),
        const Divider(height: 24),
        for (final (nom, n, texte, quand) in _avisDemo)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(nom: nom, couleur: const Color(0xFF475569), taille: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            nom,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 6),
                          Etoiles(n.toDouble(), taille: 14),
                          const Spacer(),
                          Text(
                            quand,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(texte),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
