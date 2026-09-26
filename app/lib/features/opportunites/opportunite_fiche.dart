part of 'opportunites_screens.dart';

/// E-OPP-02 — Fiche d'une opportunité : vidéo de présentation, chiffres clés,
/// conditions, pièces à fournir et transparence totale sur les coûts.
class EcranOpportunite extends ConsumerWidget {
  const EcranOpportunite({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = opportuniteParId(id);
    final etat = ref.watch(liveProvider);
    final postule = etat.candidatures.contains(o.id);
    final enregistre = etat.favoris.contains(o.id);
    final t = o.type;
    final chiffres = [
      (
        Icons.event_rounded,
        context.t.opportunitesDateLimite,
        context.t.opportunitesJMoins(o.joursRestants),
      ),
      (
        Icons.location_on_outlined,
        context.t.opportunitesLieu,
        o.lieu.split(',').first,
      ),
      (Icons.groups_rounded, context.t.opportunitesPlaces, '${o.places}'),
      (
        Icons.how_to_reg_outlined,
        context.t.opportunitesCandidats,
        compact(o.candidats),
      ),
    ];
    final principale = <Widget>[
      if (o.video)
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Vignette(couleur: t.couleur, icone: t.icone),
              Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 56,
                  semanticLabel: context.t.opportunitesPresentationEn30Secondes,
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Etiquette(
                  context.t.opportunitesPresentation30S,
                  icone: Icons.videocam,
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          Etiquette(
            t.libelleDe(context.t),
            icone: t.icone,
            fond: t.couleur.withValues(alpha: 0.12),
            couleur: t.couleur,
          ),
          Etiquette(o.niveau, fond: LiveColors.voile, couleur: LiveColors.bleu),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        o.titre,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () => context.push('/boutique/${o.organisation.id}'),
        leading: Avatar(
          nom: o.organisation.nom,
          couleur: o.organisation.couleur,
          taille: 44,
          verifie: true,
        ),
        title: Text(
          o.organisation.nom,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: BadgeVerifie(o.organisation.badge),
      ),
      GrilleAdaptative(
        largeurMax: 180,
        espacement: 10,
        hauteur: 86,
        enfants: [
          for (final (icone, libelle, valeur) in chiffres)
            Bloc(
              padding: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icone, size: 20, color: LiveColors.bleu),
                  const Spacer(),
                  Text(
                    valeur,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    libelle,
                    maxLines: 1,
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
      const SizedBox(height: 12),
      Text(o.description, style: const TextStyle(fontSize: 15)),
      if (o.remuneration != null) ...[
        const SizedBox(height: 8),
        LigneMenu(
          icone: Icons.payments_outlined,
          titre: o.remuneration!,
          detail: t == TypeOpportunite.bourse
              ? context.t.opportunitesAllocation
              : context.t.opportunitesRemuneration,
        ),
      ],
      EnTeteSection(context.t.opportunitesConditions),
      for (final c in o.conditions) _Puce(Icons.check_circle_outline, c),
      EnTeteSection(context.t.opportunitesPiecesAFournir),
      for (final p in o.pieces) _Puce(Icons.description_outlined, p),
      EnTeteSection(context.t.opportunitesCeQueVousObtenez),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final a in o.avantages)
            Etiquette(
              a,
              icone: Icons.star_rounded,
              fond: LiveColors.teinteOrange,
              couleur: LiveColors.cuivre,
            ),
        ],
      ),
    ];
    final secondaire = <Widget>[
      const SizedBox(height: 4),
      BlocReglement(
        titre: context.t.opportunitesCoutsEtFrais,
        lignes: [
          LigneReglement(
            context.t.opportunitesPostulerSurLive,
            Reglement.dansLive,
            montant: 0,
            detail: context.t.opportunitesToujoursGratuit,
          ),
          LigneReglement(
            context.t.opportunitesFraisDeDossierOfficiels,
            Reglement.direct,
            montant: o.frais,
            detail: o.gratuite
                ? context.t.opportunitesAucunFraisDemande
                : context.t.opportunitesPayesA(o.fraisPayesA),
          ),
        ],
        note: context.t.opportunitesPersonneNePeutVous,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () =>
              signaler(context, context.t.opportunitesCetteOpportunite),
          icon: const Icon(Icons.flag_outlined, size: 18),
          label: Text(context.t.opportunitesOnMADemande),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: context.t.partager,
            onPressed: () => partager(context, o.titre),
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: DeuxColonnes(principale: principale, secondaire: secondaire),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            IconButton.outlined(
              tooltip: enregistre
                  ? context.t.opportunitesRetirerDesEnregistres
                  : context.t.enregistrer,
              style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () =>
                  ref.read(liveProvider.notifier).basculerFavori(o.id),
              icon: Icon(
                enregistre ? Icons.bookmark_rounded : Icons.bookmark_border,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: postule
                    ? () => context.push('/mes-candidatures')
                    : () => context.push('/opportunite/${o.id}/postuler'),
                child: Text(
                  postule
                      ? context.t.opportunitesCandidatureEnvoyee
                      : context.t.opportunitesPostuler,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ligne avec icône pour les conditions et les pièces.
class _Puce extends StatelessWidget {
  const _Puce(this.icone, this.texte);
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: LiveColors.bleu),
          const SizedBox(width: 10),
          Expanded(child: Text(texte)),
        ],
      ),
    );
  }
}
