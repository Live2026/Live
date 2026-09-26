part of 'compte_screens.dart';

/// E-MOI-06 — Paramètres du compte.
class EcranParametres extends ConsumerWidget {
  const EcranParametres({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final a = _ActionsParametres(context, ref);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteParametres)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          EnTeteSection(context.t.compteCompte),
          LigneMenu(
            icone: Icons.person_outline,
            titre: context.t.compteProfil,
            detail: context.t.compteNomQuartier(etat.prenom),
            onTap: () => context.push('/profil/moi'),
          ),
          LigneMenu(
            icone: Icons.phone_android,
            titre: context.t.compteNumeroDeTelephone,
            valeur: etat.telephone,
            onTap: a.numero,
          ),
          LigneMenu(
            icone: Icons.verified_user_outlined,
            titre: context.t.compteVerification,
            valeur: 'N${etat.niveau}',
            onTap: () =>
                context.push(etat.identiteVerifiee ? '/pouvoirs' : '/verifier'),
          ),
          LigneMenu(
            icone: Icons.account_balance_wallet_outlined,
            titre: context.t.compteComptesDeRetrait,
            detail: context.t.compteMomoTelephone(etat.telephone),
            onTap: a.comptesRetrait,
          ),
          EnTeteSection(context.t.compteSecurite),
          LigneMenu(
            icone: Icons.pin_outlined,
            titre: context.t.compteCodeSecretDeL,
            onTap: () => a.code(context.t.compteCodeSecretDeL),
          ),
          LigneMenu(
            icone: Icons.password_rounded,
            titre: context.t.compteCodeSecretDePaiement,
            detail: context.t.compteDistinctDuCodeDe,
            onTap: () => a.code(context.t.compteCodeSecretDePaiement),
          ),
          LigneMenu(
            icone: Icons.devices_outlined,
            titre: context.t.compteAppareilsConnectes,
            valeur: '1',
            onTap: a.appareils,
          ),
          EnTeteSection(context.t.comptePreferences),
          LigneMenu(
            icone: Icons.notifications_outlined,
            titre: context.t.compteNotifications,
            onTap: () => context.push('/notifications/preferences'),
          ),
          LigneMenu(
            icone: Icons.data_saver_on_rounded,
            titre: context.t.compteEconomieDeDonnees,
            valeur: etat.economieDonnees
                ? context.t.compteActivee
                : context.t.compteDesactivee,
            onTap: () => context.push('/donnees'),
          ),
          LigneMenu(
            icone: Icons.translate_rounded,
            titre: context.t.compteLangue,
            valeur: languesLive
                .firstWhere(
                  (l) => l.$1 == etat.langue,
                  orElse: () => languesLive.first,
                )
                .$2,
            onTap: a.langue,
          ),
          LigneMenu(
            icone: Icons.dark_mode_outlined,
            titre: context.t.compteApparence,
            valeur: switch (etat.apparence) {
              'clair' => context.t.compteClair,
              'sombre' => context.t.compteSombre,
              _ => context.t.compteCommeLeTelephone,
            },
            onTap: a.apparence,
          ),
          LigneMenu(
            icone: Icons.public_rounded,
            titre: context.t.comptePaysEtVille,
            valeur: etat.pays,
            onTap: a.pays,
          ),
          LigneMenu(
            icone: Icons.interests_outlined,
            titre: context.t.compteCentresDInteret,
            onTap: () => context.push('/interets'),
          ),
          EnTeteSection(context.t.compteAideEtConfidentialite),
          LigneMenu(
            icone: Icons.help_outline_rounded,
            titre: context.t.compteCentreDAide,
            detail: context.t.compteQuestionsFrequentesEcrireAu,
            onTap: () => context.push('/aide'),
          ),
          LigneMenu(
            icone: Icons.privacy_tip_outlined,
            titre: context.t.compteMesDonneesPersonnelles,
            detail: context.t.compteTelechargerOuSupprimer,
            onTap: a.donnees,
          ),
          LigneMenu(
            icone: Icons.description_outlined,
            titre: context.t.compteConditionsDUtilisation,
            onTap: () => context.push('/legal/cgu'),
          ),
          LigneMenu(
            icone: Icons.policy_outlined,
            titre: context.t.comptePolitiqueDeConfidentialite,
            onTap: () => context.push('/legal/confidentialite'),
          ),
          LigneMenu(
            icone: Icons.logout_rounded,
            titre: context.t.compteSeDeconnecter,
            couleur: LiveColors.erreur,
            onTap: () => context.go('/bienvenue'),
          ),
          LigneMenu(
            icone: Icons.delete_outline_rounded,
            titre: context.t.compteSupprimerMonCompte,
            couleur: LiveColors.erreur,
            detail: context.t.compteVosGainsDoiventD,
            onTap: a.supprimer,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              context.t.compteLive10Prototype,
              style: TextStyle(color: LiveColors.gris, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// E-NOTIF-01 — Centre de notifications.
class EcranNotifications extends StatelessWidget {
  const EcranNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.compteNotifications),
        actions: [
          IconButton(
            tooltip: context.t.comptePreferences,
            onPressed: () => context.push('/notifications/preferences'),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final (i, n) in notificationsDemo.indexed)
            Apparition(
              rang: i,
              child: Material(
                color: n.nouvelle ? LiveColors.champ : LiveColors.surface,
                child: InkWell(
                  onTap: () => context.push(n.route),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: LiveColors.voile,
                          child: Icon(
                            n.icone,
                            color: LiveColors.bleu,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.titre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(n.texte),
                              Text(
                                n.quand,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (n.nouvelle)
                          Container(
                            width: 9,
                            height: 9,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: LiveColors.orangeVif,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// E-NOTIF-02 — Préférences de notification par type.
class EcranPreferencesNotif extends StatefulWidget {
  const EcranPreferencesNotif({super.key});

  @override
  State<EcranPreferencesNotif> createState() => _EcranPreferencesNotifState();
}

class _EcranPreferencesNotifState extends State<EcranPreferencesNotif> {
  late final _actives = {for (final t in _types.take(4)) t.$1};
  late final _types = [
    (context.t.comptePaiements, context.t.compteToujoursEnvoyeAussiPar, true),
    (context.t.compteMessages, context.t.compteNouveauxMessagesEtOffres, false),
    (
      context.t.compteCommandesEtVisites,
      context.t.compteAcceptationRemiseRappelDe,
      false,
    ),
    (
      context.t.compteAlertesDeRecherche,
      context.t.compteNouveauxResultats,
      false,
    ),
    (
      context.t.compteComptesSuivis,
      context.t.compteNouvellesVideosEtDirects,
      false,
    ),
    (
      context.t.compteOffresDeLive,
      context.t.comptePromotionsCreditsOfferts,
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.comptePreferences)),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final (titre, detail, obligatoire) in _types)
            SwitchListTile(
              title: Text(titre),
              subtitle: Text(detail),
              value: obligatoire || _actives.contains(titre),
              onChanged: obligatoire
                  ? null
                  : (v) => setState(
                      () => v ? _actives.add(titre) : _actives.remove(titre),
                    ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              context.t.compteLesNotificationsDePaiement,
              style: TextStyle(color: LiveColors.gris),
            ),
          ),
        ],
      ),
    );
  }
}

/// E-AUTH-07 — Économie de données.
class EcranDonnees extends ConsumerWidget {
  const EcranDonnees({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(liveProvider.select((e) => e.economieDonnees));
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteEconomieDeDonnees)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.compteCeMoisCi,
                  style: TextStyle(color: LiveColors.gris),
                ),
                const Text(
                  '312 Mo',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.31,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.t.compteVideos71Photos22,
                  style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.t.compteEconomieDeDonnees,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(context.t.compteVideosEn360pLecture),
            value: active,
            onChanged: (_) =>
                ref.read(liveProvider.notifier).basculerEconomieDonnees(),
          ),
          const Divider(),
          LigneMenu(
            icone: Icons.wifi_rounded,
            titre: context.t.compteEnWiFi,
            detail: context.t.compteVideosEnHauteQualite,
          ),
          LigneMenu(
            icone: Icons.signal_cellular_alt_rounded,
            titre: context.t.compteEn3g4g,
            detail: context.t.compteQualiteReduitePasDe,
          ),
          LigneMenu(
            icone: Icons.download_for_offline_outlined,
            titre: context.t.compteTelechargements,
            detail: context.t.compteUniquementEnWiFi,
          ),
          const Divider(),
          ValueListenableBuilder<bool>(
            valueListenable: horsConnexion,
            builder: (_, coupe, _) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                context.t.compteSimulerUneCoupureDu,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(context.t.comptePrototypeAfficheLeBandeau),
              value: coupe,
              onChanged: (v) => horsConnexion.value = v,
            ),
          ),
        ],
      ),
    );
  }
}
