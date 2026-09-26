part of 'compte_screens.dart';

/// Actions des lignes de « Paramètres » : chacune ouvre un panneau ou une
/// confirmation, jamais un bouton mort.
class _ActionsParametres {
  const _ActionsParametres(this.context, this.ref);
  final BuildContext context;
  final WidgetRef ref;

  LiveState get _etat => ref.read(liveProvider);

  Future<void> numero() async {
    if (await confirmer(
      context,
      titre: context.t.compteChangerDeNumero,
      texte: context.t.compteUnCodeSmsSera,
      action: context.t.continuer,
    )) {
      if (context.mounted) {
        informer(context, context.t.compteCodeEnvoyeAuNouveau);
      }
    }
  }

  Future<void> comptesRetrait() async {
    final choix = await choisir<String>(
      context,
      titre: context.t.compteCompteDeRetrait,
      actuel: _etat.operateur,
      options: [
        (
          'MTN',
          context.t.compteMomoTelephone(_etat.telephone),
          context.t.compteAuNomDe(_etat.prenom),
        ),
        (
          'Airtel',
          context.t.compteAjouterUnNumeroAirtel,
          context.t.compteIlDoitEtreA,
        ),
      ],
    );
    if (choix == 'Airtel' && context.mounted) {
      informer(context, context.t.compteUnCodeSmsVerifiera);
    }
  }

  Future<void> code(String titre) async {
    if (await changerCode(context, titre: titre) && context.mounted) {
      informer(context, context.t.compteModifie(titre));
    }
  }

  void appareils() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.phone_android_rounded,
                color: LiveColors.bleu,
              ),
              title: Text(context.t.compteCeTelephoneTecnoSpark),
              subtitle: Text(context.t.compteBrazzavilleActifMaintenant),
            ),
            ListTile(
              leading: const Icon(Icons.laptop_rounded),
              title: Text(context.t.compteChromeSurOrdinateur),
              subtitle: Text(context.t.comptePointeNoireIlY),
              trailing: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  informer(context, context.t.compteAppareilDeconnecte);
                },
                child: Text(context.t.compteDeconnecter),
              ),
            ),
            // Connexion sur ordinateur par code QR (E-AUTH-09).
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  if (await simulerScan(
                        context,
                        quoi: context.t.compteLeCodeAfficheSur,
                      ) &&
                      context.mounted) {
                    informer(context, context.t.compteOrdinateurConnecteAVotre);
                  }
                },
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(context.t.compteConnecterUnAppareil),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> langue() async {
    final choix = await choisir<String>(
      context,
      titre: context.t.compteLangue,
      actuel: _etat.langue,
      options: [
        for (final (code, nom, francais) in languesLive)
          (code, nom, nom == francais ? null : francais),
      ],
    );
    if (choix != null && context.mounted) {
      ref.read(liveProvider.notifier).choisirLangue(choix);
      informer(context, context.t.compteLangueEnregistree);
    }
  }

  /// Mode clair ou sombre ; « Comme le téléphone » suit le réglage du système.
  Future<void> apparence() async {
    final choix = await choisir<String>(
      context,
      titre: context.t.compteApparence,
      actuel: _etat.apparence,
      options: [
        (
          'systeme',
          context.t.compteCommeLeTelephone,
          context.t.compteClairLeJourSombre,
        ),
        ('clair', context.t.compteClair, null),
        ('sombre', context.t.compteSombre, context.t.compteReposeLesYeuxLa),
      ],
    );
    if (choix != null && context.mounted) {
      ref.read(liveProvider.notifier).choisirApparence(choix);
    }
  }

  /// Extension CEMAC : même monnaie (FCFA), annonces du pays choisi.
  Future<void> pays() async {
    final choix = await choisir<String>(
      context,
      titre: context.t.comptePaysEtVille,
      actuel: _etat.pays,
      options: [
        for (final v in villesLive)
          (v.ville, v.libelle, v.operateurs.join(', ')),
      ],
    );
    if (choix != null && context.mounted) {
      ref.read(liveProvider.notifier).choisirPays(choix);
      informer(context, context.t.compteAnnoncesPrixDe(choix));
    }
  }

  Future<void> donnees() async {
    final choix = await choisir<int>(
      context,
      titre: context.t.compteMesDonneesPersonnelles,
      options: [
        (
          0,
          context.t.compteTelechargerMesDonnees,
          context.t.compteArchiveEnvoyeeParSms,
        ),
        (
          1,
          context.t.compteVoirCeQueLive,
          context.t.compteProfilAnnoncesTransactionsMessages,
        ),
      ],
    );
    if (choix == 0 && context.mounted) {
      informer(context, context.t.compteDemandeEnregistreeLienDe);
    }
  }

  /// F-CPT-10 : suppression du compte, après retrait des gains.
  Future<void> supprimer() async {
    if (_etat.disponible > 0) {
      final retirer = await confirmer(
        context,
        titre: context.t.compteRetirezDAbordVos,
        texte: context.t.compteRetirezGainsTexte(fcfa(_etat.disponible)),
        action: context.t.compteRetirerMesGains,
      );
      if (retirer && context.mounted) context.push('/retirer');
      return;
    }
    if (await confirmer(
      context,
      titre: context.t.compteSupprimerMonCompte,
      texte: context.t.compteVosAnnoncesEtVotre,
      action: context.t.supprimer,
      danger: true,
    )) {
      if (context.mounted) context.go('/bienvenue');
    }
  }
}
