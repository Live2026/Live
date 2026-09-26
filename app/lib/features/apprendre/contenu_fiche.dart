part of 'apprendre_screens.dart';

/// E-APP-02 — Fiche d'un contenu : aperçu gratuit, auteur, programme,
/// ce que l'on obtient, avis, prix payé dans Live.
class EcranContenu extends ConsumerWidget {
  const EcranContenu({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = contenuParId(id);
    final etat = ref.watch(liveProvider);
    final achete = etat.bibliotheque.contains(c.id);
    final auPanier = etat.panier.contains(c.id);
    final store = ref.read(liveProvider.notifier);
    final principale = <Widget>[
      AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Vignette(couleur: c.couleur, icone: c.type.icone),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      context.t.apprendreApercuGratuit2Min,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Etiquette(c.type.libelle, icone: c.type.icone),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Text(
        c.titre,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          Etiquette(
            context.t.apprendreNoteAvis(note(c.note), compact(c.avis)),
            icone: Icons.star_rounded,
            fond: LiveColors.teinteOrange,
            couleur: LiveColors.cuivre,
          ),
          Etiquette(
            context.t.apprendreNEleves(compact(c.ventes)),
            icone: Icons.people_alt_outlined,
            fond: LiveColors.voile,
            couleur: LiveColors.bleu,
          ),
          Etiquette(c.niveau, fond: LiveColors.voile, couleur: LiveColors.bleu),
        ],
      ),
      const SizedBox(height: 12),
      _Auteur(auteur: c.auteur),
      const SizedBox(height: 12),
      Text(c.description, style: const TextStyle(fontSize: 15)),
      EnTeteSection(context.t.apprendreCeQueVousObtenez),
      for (final (icone, texte) in [
        (Icons.schedule_rounded, c.format),
        (Icons.all_inclusive_rounded, context.t.apprendreAccesAVieSur),
        (
          Icons.download_for_offline_outlined,
          context.t.apprendreHorsConnexion(c.taille),
        ),
        if (c.type == TypeContenu.cours)
          (
            Icons.workspace_premium_outlined,
            context.t.apprendreAttestationLiveALa,
          ),
        (Icons.forum_outlined, context.t.apprendreQuestionsALAuteur),
      ])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icone, size: 20, color: LiveColors.bleu),
              const SizedBox(width: 10),
              Expanded(child: Text(texte)),
            ],
          ),
        ),
      EnTeteSection(context.t.apprendreProgramme),
      for (final (i, titre) in c.programme.indexed)
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: LiveColors.champ2,
            child: Text(
              '${i + 1}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          title: Text(titre, style: const TextStyle(fontSize: 14.5)),
          trailing: i == 0 || achete
              ? const Icon(Icons.play_circle_outline, color: LiveColors.succes)
              : const Icon(Icons.lock_outline, color: LiveColors.gris),
        ),
    ];
    final secondaire = <Widget>[
      Text(
        fcfa(c.prix),
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 8),
      BlocReglement(
        lignes: [
          LigneReglement(
            context.t.apprendrePrix,
            Reglement.dansLive,
            montant: c.prix,
            detail: context.t.apprendreRembourseSous48H,
          ),
        ],
        note: context.t.apprendreSoldeLiveMtnMomo,
      ),
      EnTeteSection(context.t.apprendreAvisDesEleves),
      for (final (nom, texte) in const [
        (
          'Merveille K.',
          'Enfin des explications claires, j’ai eu 15 au BAC blanc.',
        ),
        ('Jordy M.', 'Je regarde les leçons dans le bus, sans forfait.'),
      ])
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Avatar(nom: nom, couleur: LiveColors.bleu, taille: 36),
          title: Text(nom, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(texte),
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: context.t.partager,
            onPressed: () => partager(context, c.titre),
            icon: const Icon(Icons.ios_share_rounded),
          ),
          const BoutonPanier(),
        ],
      ),
      body: DeuxColonnes(principale: principale, secondaire: secondaire),
      bottomNavigationBar: BarreAction(
        child: achete
            ? FilledButton.icon(
                onPressed: () => context.push('/lecteur/${c.id}'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(context.t.apprendreOuvrir),
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: auPanier
                          ? () => context.push('/panier')
                          : () => store.ajouterAuPanier(c.id),
                      child: Text(
                        auPanier
                            ? context.t.apprendreVoirLePanier
                            : context.t.apprendreAuPanier,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        store.ajouterAuPanier(c.id);
                        context.push('/panier');
                      },
                      child: Text(context.t.apprendreAcheter),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Auteur du contenu, avec abonnement.
class _Auteur extends ConsumerWidget {
  const _Auteur({required this.auteur});
  final Vendeur auteur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = auteur;
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(a.id)),
    );
    return Bloc(
      padding: 12,
      child: Row(
        children: [
          InkWell(
            onTap: () => context.push('/boutique/${a.id}'),
            child: Avatar(
              nom: a.nom,
              couleur: a.couleur,
              taille: 46,
              verifie: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/boutique/${a.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.nom,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  BadgeVerifie(a.badge),
                  Text(
                    context.t.apprendreNAbonnes(compact(a.abonnes)),
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(liveProvider.notifier).basculerSuivi(a.id),
            child: Text(
              suivi ? context.t.apprendreAbonne : context.t.apprendreSuivre,
            ),
          ),
        ],
      ),
    );
  }
}
