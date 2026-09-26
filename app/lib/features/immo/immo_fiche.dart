part of 'immo_screens.dart';

/// E-IMMO-03 — Fiche logement : galerie plein cadre, caractéristiques en
/// tuiles, coût d'entrée détaillé, équipements, quartier, annonceur.
class EcranBien extends ConsumerWidget {
  const EcranBien({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = bienParId(id);
    final grand = context.grandEcran;
    final principal = <Widget>[
      _EnTeteBien(bien: b),
      const SizedBox(height: 16),
      _TuilesSpecs(bien: b),
      const SizedBox(height: 16),
      _CoutEntree(bien: b),
      const SizedBox(height: 16),
      Builder(
        builder: (context) {
          final (bas, haut) = fourchetteMarche(b.loyer, b.id.hashCode);
          return JustePrix(
            prix: b.loyer,
            bas: bas,
            haut: haut,
            suffixe: b.vente ? '' : context.t.immoParMoisSuffixe,
            base: b.vente
                ? context.t.immoVentesComparablesA(b.quartier)
                : context.t.immoLoyersDe(b.chambres, b.quartier),
          );
        },
      ),
      const SizedBox(height: 14),
      _ReglementBien(bien: b),
      const SizedBox(height: 16),
      _Equipements(bien: b),
    ];
    final secondaire = <Widget>[
      _Quartier(bien: b),
      const SizedBox(height: 16),
      _Annonceur(vendeur: b.annonceur),
      const SizedBox(height: 12),
      BandeauProtection(context.t.immoFraisDeVisiteEt),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () =>
              signaler(context, context.t.immoCetteAnnonce, immo: true),
          icon: const Icon(Icons.flag_outlined, size: 18),
          label: Text(context.t.immoDejaLoueOuAnnonce),
        ),
      ),
    ];
    final similaires = biens
        .where((x) => x.id != b.id && x.vente == b.vente)
        .take(6)
        .toList();
    final actions = BarreAction(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/conversation'),
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: Text(context.t.immoEcrire),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: () => context.push('/bien/${b.id}/visite'),
              child: Text(context.t.immoDemanderUneVisite),
            ),
          ),
        ],
      ),
    );
    if (grand) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: context.t.partager,
              onPressed: () => partager(context, b.titre),
              icon: const Icon(Icons.ios_share_rounded),
            ),
            BoutonFavori(id: b.id, couleur: LiveColors.nuit),
            const SizedBox(width: 12),
          ],
        ),
        body: DeuxColonnes(
          principale: [
            SizedBox(height: 380, child: PhotoBien(bien: b, favori: false)),
            const SizedBox(height: 16),
            ...principal,
            _Similaires(biens: similaires),
          ],
          secondaire: secondaire,
        ),
        bottomNavigationBar: actions,
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: LiveColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: BoutonVerre(
                icone: Icons.arrow_back_rounded,
                libelle: context.t.retour,
                onTap: () => context.pop(),
              ),
            ),
            actions: [
              BoutonVerre(
                icone: Icons.ios_share_rounded,
                libelle: context.t.partager,
                onTap: () => partager(context, b.titre),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BoutonFavori(id: b.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: PhotoBien(bien: b, rayon: 0, favori: false, haut: 64),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList.list(
              children: [
                ...principal,
                const SizedBox(height: 16),
                ...secondaire,
                _Similaires(biens: similaires),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: actions,
    );
  }
}

class _EnTeteBien extends StatelessWidget {
  const _EnTeteBien({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrixBien(bien: b, taille: 26),
        const SizedBox(height: 2),
        Text(
          context.t.immoTitreQuartier(b.titre, b.quartier),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.update_rounded,
              size: 16,
              color: LiveColors.succes,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                context.t.immoDisponibiliteConfirmee(b.confirmeIlYa),
                style: const TextStyle(color: LiveColors.succes, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Caractéristiques clés en tuiles de même taille.
class _TuilesSpecs extends StatelessWidget {
  const _TuilesSpecs({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    final tuiles = <(IconData, String, String)>[
      (
        b.type.icone,
        b.type.libelleDe(context.t).split(' ').first,
        context.t.immoType,
      ),
      if (b.chambres > 0)
        (Icons.bed_outlined, '${b.chambres}', context.t.immoChambres),
      if (b.douches > 0)
        (Icons.shower_outlined, '${b.douches}', context.t.immoDouches),
      if (b.surface > 0)
        (Icons.square_foot_rounded, '${b.surface} m²', context.t.immoSurface),
      (
        Icons.chair_outlined,
        b.meuble ? context.t.immoOui : context.t.immoNon,
        context.t.immoMeuble,
      ),
    ];
    return GrilleAdaptative(
      largeurMax: 110,
      espacement: 8,
      hauteur: 86,
      enfants: [
        for (final (icone, valeur, libelle) in tuiles)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: LiveColors.champ,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icone, size: 20, color: LiveColors.bleu),
                const SizedBox(height: 4),
                Text(
                  valeur,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  libelle,
                  style: const TextStyle(fontSize: 11, color: LiveColors.gris),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Coût d'entrée : barre proportionnelle et détail ligne par ligne.
class _CoutEntree extends StatelessWidget {
  const _CoutEntree({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    if (b.vente) {
      return Bloc(
        child: Column(
          children: [
            LigneMontant(context.t.immoPrixDeVente, b.loyer, gras: true),
            LigneMontant(
              context.t.immoFraisDeVisiteRemboursables,
              b.fraisVisite,
            ),
            const SizedBox(height: 6),
            Text(
              context.t.immoTitreFoncierVerifiePar,
              style: TextStyle(color: LiveColors.gris, fontSize: 13),
            ),
          ],
        ),
      );
    }
    final parts = [
      (context.t.immoAvanceMois(b.moisAvance), b.avance, LiveColors.bleu),
      (
        context.t.immoCautionMois(b.moisCaution),
        b.caution,
        const Color(0xFF4F7CAC),
      ),
      if (b.commission > 0)
        (context.t.immoCommission, b.commission, LiveColors.orange),
    ];
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.immoCoutDEntree,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              color: LiveColors.gris,
            ),
          ),
          Text(
            fcfa(b.coutEntree),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                for (final (_, montant, couleur) in parts)
                  Expanded(
                    flex: montant,
                    child: Container(height: 10, color: couleur),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final (libelle, montant, couleur) in parts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: couleur,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(libelle)),
                  Text(fcfa(montant)),
                ],
              ),
            ),
          const Divider(height: 20),
          LigneMontant(
            context.t.immoLoyerEnsuite,
            b.loyer,
            brut: context.t.parMois(fcfa(b.loyer)),
          ),
          LigneMontant(context.t.immoFraisDeVisite, b.fraisVisite),
          BoutonEcouter(context.t.immoPourEntrerDansCe),
        ],
      ),
    );
  }
}

class _Equipements extends StatelessWidget {
  const _Equipements({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    final items = <(IconData, String)>[
      (Icons.water_drop_outlined, context.t.immoEau(b.eau)),
      (Icons.bolt_outlined, context.t.immoElectricite(b.electricite)),
      if (b.parking) (Icons.local_parking_rounded, context.t.immoParking),
      for (final c in b.caracteristiques) (Icons.check_circle_outline, c),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.immoEquipements,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (icone, texte) in items)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: LiveColors.filet),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icone, size: 16, color: LiveColors.bleu),
                    const SizedBox(width: 6),
                    Text(texte, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
