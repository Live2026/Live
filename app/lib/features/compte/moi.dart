part of 'compte_screens.dart';

/// E-MOI-01 — Moi : profil social, super-pouvoirs, raccourcis et réglages.
class EcranMoi extends ConsumerWidget {
  const EcranMoi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final actifs = pouvoirs.where((p) => p.actifPour(etat)).length;
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      endDrawer: const _MenuProfil(),
      appBar: AppBar(
        title: const Text('Moi'),
        actions: [
          IconButton(
            tooltip: context.t.compteNotifications,
            onPressed: () => context.push('/notifications'),
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          const BoutonMessages(),
          Builder(
            builder: (ctx) => IconButton(
              tooltip: context.t.compteMenuDuProfil,
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          Row(
            children: [
              Avatar(
                nom: '${etat.prenom} Mabiala',
                couleur: LiveColors.bleu,
                taille: 72,
                verifie: etat.identiteVerifiee,
                anneau: true,
                photo: etat.photoProfil,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${etat.prenom} Mabiala',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '@${etat.prenom.toLowerCase()}.mabiala',
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                    const SizedBox(height: 4),
                    Etiquette(
                      'N${etat.niveau} · ${libelleNiveau(context.t, etat.niveau)}',
                      icone: Icons.verified_user_outlined,
                      fond: LiveColors.voile,
                      couleur: LiveColors.bleu,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat('128', context.t.compteAbonnes, route: '/abonnes/moi'),
              _Stat(
                '${etat.suivis.length}',
                context.t.compteAbonnements,
                route: '/abonnes/moi?onglet=1',
              ),
              _Stat('4,8', context.t.compteNote),
              _Stat('12', context.t.compteTransactions),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/parametres'),
                  child: Text(context.t.modifier),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/profil/moi'),
                  child: Text(context.t.compteProfilPublic),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CarteArgent(etat: etat),
          const SizedBox(height: 12),
          _CartePouvoirs(actifs: actifs, total: pouvoirs.length),
          const SizedBox(height: 16),
          GrilleAdaptative(
            largeurMax: 180,
            espacement: 10,
            hauteur: 96,
            enfants: [
              _Raccourci(
                Icons.auto_awesome_outlined,
                context.t.compteCreditsLive,
                context.t.moiNCredits(etat.credits),
                '/ia/credits',
              ),
              _Raccourci(
                Icons.storefront_outlined,
                context.t.compteMesVentes,
                context.t.moiNVentes(etat.ventes.length),
                '/mes-ventes',
              ),
              _Raccourci(
                Icons.shopping_bag_outlined,
                context.t.compteMesAchats,
                context.t.moiNEnCours(etat.achats.length),
                '/commandes',
              ),
              _Raccourci(
                Icons.home_outlined,
                context.t.compteMesVisites,
                context.t.moiNVisites(etat.visites.length),
                etat.visites.isEmpty
                    ? '/immo'
                    : '/visite/${etat.visites.first.id}',
              ),
              _Raccourci(
                Icons.handyman_outlined,
                context.t.comptePrestations,
                context.t.moiNEnCours(etat.prestations.length),
                etat.prestations.isEmpty
                    ? '/services'
                    : '/prestation/${etat.prestations.first.id}',
              ),
              _Raccourci(
                Icons.bookmark_border_rounded,
                context.t.compteEnregistres,
                context.t.moiNFavoris(etat.favoris.length),
                '/enregistres',
              ),
            ],
          ),
          EnTeteSection(context.t.compteMesEspaces),
          LigneMenu(
            icone: Icons.apartment_rounded,
            titre: 'Agence Les Palmiers',
            detail: context.t.compteEspaceAgenceDeDemonstration,
            onTap: () => context.push('/agence'),
          ),
          LigneMenu(
            icone: Icons.handyman_rounded,
            titre: context.t.compteMesInterventions,
            detail: context.t.compteEspacePrestataireDeDemonstration,
            onTap: () => context.push('/pro/interventions'),
          ),
          for (final e in etat.espaces)
            LigneMenu(
              icone: Icons.storefront_rounded,
              titre: e.nom,
              detail: context.t.compteMonEspaceVerifie,
              onTap: () => context.push('/boutique/grace'),
            ),
          LigneMenu(
            icone: Icons.add_business_outlined,
            titre: context.t.compteCreerUnEspace,
            detail: context.t.compteBoutiqueAgencePrestataireOu,
            onTap: () => context.push('/espace/nouveau'),
          ),
          EnTeteSection(context.t.compteMonArgentAuQuotidien),
          LigneMenu(
            icone: Icons.diversity_3_rounded,
            titre: context.t.compteMesTontines,
            detail: context.t.compteN2TontinesProchaineCotisation,
            onTap: () => context.push('/tontines'),
          ),
          LigneMenu(
            icone: Icons.receipt_long_rounded,
            titre: context.t.compteFacturesEtCredit,
            detail: context.t.compteElectriciteEauTelevisionRecharge,
            onTap: () => context.push('/factures'),
          ),
          LigneMenu(
            icone: Icons.flight_land_rounded,
            titre: context.t.compteDiasporaEtTransferts,
            detail: context.t.comptePayerPourUnProche,
            onTap: () => context.push('/diaspora'),
          ),
          LigneMenu(
            icone: Icons.currency_exchange_rounded,
            titre: context.t.compteRecevoirDeLEtranger,
            detail: context.t.compteEuroDollarLivreRecus,
            onTap: () => context.push('/transfert?sens=recevoir'),
          ),
          LigneMenu(
            icone: Icons.pin_drop_rounded,
            titre: context.t.compteMonAdresseLive,
            detail: 'MNG-4821 · Moungali',
            onTap: () => context.push('/adresse'),
          ),
          EnTeteSection(context.t.compteCreerEtGagner),
          LigneMenu(
            icone: Icons.insights_rounded,
            titre: context.t.compteStudioCreateur,
            detail: context.t.compteVuesCadeauxFansEt,
            onTap: () => context.push('/studio'),
          ),
          LigneMenu(
            icone: Icons.podcasts_rounded,
            titre: context.t.compteLancerUnDirect,
            detail: context.t.compteVendreEnDirectRecevoir,
            onTap: () => context.push('/direct/lancer'),
          ),
          LigneMenu(
            icone: Icons.bolt_rounded,
            titre: 'Live Plus',
            detail: etat.formulePlus == null
                ? context.t.compteCreditsLiveIaChaque
                : context.t.moiFormuleActive(
                    etat.formulePlus == 'pro' ? 'Pro' : context.t.moiEleve,
                  ),
            onTap: () => context.push('/live-plus'),
          ),
          LigneMenu(
            icone: Icons.campaign_outlined,
            titre: context.t.comptePublicite,
            detail: context.t.compteFaireVoirUneVideo,
            onTap: () => context.push('/publicite'),
          ),
          LigneMenu(
            icone: Icons.account_balance_outlined,
            titre: context.t.compteServicesFinanciers,
            detail: context.t.comptePayerEn3Fois,
            onTap: () => context.push('/finance'),
          ),
          EnTeteSection(context.t.compteActivite),
          LigneMenu(
            icone: Icons.payments_outlined,
            titre: context.t.compteCeQuiSePaie,
            detail: context.t.compteDansLiveSurPlace,
            onTap: () => context.push('/paiements'),
          ),
          LigneMenu(
            icone: Icons.gavel_rounded,
            titre: context.t.compteMesReclamations,
            valeur: '${etat.reclamations.length}',
            onTap: () => etat.reclamations.isEmpty
                ? ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.t.compteAucuneReclamationEnCours),
                    ),
                  )
                : context.push('/reclamation/${etat.reclamations.first.id}'),
          ),
          LigneMenu(
            icone: Icons.notifications_active_outlined,
            titre: context.t.compteMesAlertesDeRecherche,
            valeur: '${etat.alertes.length}',
            onTap: () => context.push('/alertes'),
          ),
          LigneMenu(
            icone: Icons.bookmark_border_rounded,
            titre: context.t.compteEnregistres,
            valeur: '${etat.favoris.length}',
            onTap: () => context.push('/enregistres'),
          ),
          LigneMenu(
            icone: Icons.card_giftcard_rounded,
            titre: context.t.compteInviterDesAmis,
            detail: context.t.compteN1000FcfaDe,
            onTap: () =>
                partager(context, 'Rejoins-moi sur Live · code GRACE26'),
          ),
          LigneMenu(
            icone: Icons.data_saver_on_rounded,
            titre: context.t.compteDonneesUtiliseesCeMois,
            valeur: '312 Mo',
            onTap: () => context.push('/donnees'),
          ),
          LigneMenu(
            icone: Icons.science_outlined,
            titre: context.t.compteScenariosDeTest,
            couleur: LiveColors.gris,
            onTap: () => context.push('/scenarios'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.valeur, this.libelle, {this.route});
  final String valeur;
  final String libelle;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: route == null ? null : () => context.push(route!),
        child: Column(
          children: [
            Text(
              valeur,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              libelle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte « Mes super-pouvoirs » : progression et accès au catalogue.
class _CartePouvoirs extends StatelessWidget {
  const _CartePouvoirs({required this.actifs, required this.total});
  final int actifs;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.t.moiPouvoirsSemantique(actifs, total),
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/pouvoirs'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [LiveColors.bleu, LiveColors.nuit],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: actifs / total),
                      duration: const Duration(milliseconds: 900),
                      curve: courbeDouce,
                      builder: (_, v, _) => CircularProgressIndicator(
                        value: v,
                        strokeWidth: 5,
                        backgroundColor: Colors.white24,
                        color: LiveColors.orange,
                        constraints: const BoxConstraints.expand(),
                      ),
                    ),
                    const Icon(
                      Icons.bolt_rounded,
                      color: LiveColors.orange,
                      size: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.compteMesSuperPouvoirs,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      context.t.moiPouvoirsActifs(actifs, total),
                      style: const TextStyle(
                        color: LiveColors.brumeClaire,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Raccourci de même taille que ses voisins (grille de la page Moi).
class _Raccourci extends StatelessWidget {
  const _Raccourci(this.icone, this.titre, this.valeur, this.route);
  final IconData icone;
  final String titre;
  final String valeur;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$titre, $valeur',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push(route),
        child: Bloc(
          padding: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, color: LiveColors.bleu),
              const Spacer(),
              Text(titre, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                valeur,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
