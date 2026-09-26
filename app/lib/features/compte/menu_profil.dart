part of 'compte_screens.dart';

/// Menu du profil (tiroir de droite) : compte et réglages, mon espace,
/// espaces professionnels, aide. Tout est aussi accessible depuis « Moi ».
class _MenuProfil extends ConsumerWidget {
  const _MenuProfil();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    void aller(String route) {
      Navigator.pop(context);
      context.push(route);
    }

    Widget section(String titre) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
      child: Text(
        titre.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1,
          fontWeight: FontWeight.w700,
          color: LiveColors.gris,
        ),
      ),
    );

    Widget ligne(
      IconData icone,
      String titre,
      String route, {
      String? valeur,
    }) => ListTile(
      dense: true,
      leading: Icon(icone, color: LiveColors.bleu),
      title: Text(titre, style: const TextStyle(fontSize: 15)),
      trailing: valeur == null
          ? const Icon(Icons.chevron_right_rounded, color: LiveColors.gris)
          : Text(valeur, style: const TextStyle(color: LiveColors.gris)),
      onTap: () => aller(route),
    );

    return Drawer(
      backgroundColor: LiveColors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              leading: Avatar(
                nom: '${etat.prenom} Mabiala',
                couleur: LiveColors.bleu,
                taille: 48,
                verifie: etat.identiteVerifiee,
              ),
              title: Text(
                '${etat.prenom} Mabiala',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                'N${etat.niveau} · ${libelleNiveau(context.t, etat.niveau)}',
              ),
              trailing: IconButton(
                tooltip: context.t.compteFermerLeMenu,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            const Divider(height: 1),
            section(context.t.compteCompte),
            ligne(
              Icons.settings_outlined,
              context.t.compteParametresEtConfidentialite,
              '/parametres',
            ),
            if (!etat.identiteVerifiee)
              ligne(
                Icons.badge_outlined,
                context.t.compteVerifierMonIdentite,
                '/verifier',
              ),
            ligne(
              Icons.notifications_none_rounded,
              context.t.compteNotifications,
              '/notifications/preferences',
            ),
            ligne(
              Icons.data_saver_on_rounded,
              context.t.compteEconomieDeDonnees,
              '/donnees',
            ),
            ligne(
              Icons.bolt_rounded,
              context.t.compteMesSuperPouvoirs,
              '/pouvoirs',
            ),
            section(context.t.compteMonEspace),
            ligne(
              Icons.account_balance_wallet_outlined,
              context.t.compteMonArgentLive,
              '/portefeuille',
              valeur: fcfaCourt(etat.disponible),
            ),
            ligne(
              Icons.shopping_bag_outlined,
              context.t.compteMesCommandes,
              '/commandes',
              valeur: '${etat.achats.length}',
            ),
            ligne(
              Icons.storefront_outlined,
              context.t.compteMesVentes,
              '/mes-ventes',
            ),
            ligne(
              Icons.favorite_border_rounded,
              context.t.compteEnregistres,
              '/enregistres',
              valeur: '${etat.favoris.length}',
            ),
            ligne(
              Icons.notifications_active_outlined,
              context.t.compteMesAlertes,
              '/alertes',
            ),
            ligne(
              Icons.people_outline_rounded,
              context.t.compteAbonnesEtAbonnements,
              '/abonnes/moi',
            ),
            ligne(
              Icons.auto_awesome_outlined,
              context.t.compteCreditsLiveIa,
              '/ia/credits',
              valeur: '${etat.credits}',
            ),
            ligne(
              Icons.description_outlined,
              context.t.compteMesDocumentsIa,
              '/ia/documents',
            ),
            section(context.t.compteEspacesProfessionnels),
            ligne(Icons.apartment_rounded, 'Agence Les Palmiers', '/agence'),
            ligne(
              Icons.handyman_rounded,
              context.t.compteMesInterventions,
              '/pro/interventions',
            ),
            ligne(
              Icons.add_business_outlined,
              context.t.compteCreerUnEspace,
              '/espace/nouveau',
            ),
            ligne(Icons.insights_outlined, 'Live Pro', '/live-pro'),
            section(context.t.compteCreateur),
            ligne(
              Icons.insights_rounded,
              context.t.compteStudioCreateur,
              '/studio',
            ),
            ligne(
              Icons.podcasts_rounded,
              context.t.compteLancerUnDirect,
              '/direct/lancer',
            ),
            ligne(
              Icons.volunteer_activism_outlined,
              context.t.compteFondsCreateurs,
              '/fonds-createurs',
            ),
            section(context.t.compteDevelopperMonActivite),
            ligne(Icons.bolt_rounded, 'Live Plus', '/live-plus'),
            ligne(
              Icons.campaign_outlined,
              context.t.comptePublicite,
              '/publicite',
            ),
            ligne(
              Icons.workspace_premium_outlined,
              context.t.compteOffresPro,
              '/live-pro/offres',
            ),
            ligne(
              Icons.account_balance_outlined,
              context.t.compteServicesFinanciers,
              '/finance',
            ),
            ligne(
              Icons.hub_outlined,
              context.t.compteApiPartenaires,
              '/partenaires',
            ),
            section(context.t.compteAideEtConfiance),
            ligne(
              Icons.support_agent_rounded,
              context.t.compteCentreDAide,
              '/aide',
            ),
            ligne(
              Icons.payments_outlined,
              context.t.compteCeQuiSePaie,
              '/paiements',
            ),
            ligne(
              Icons.gavel_rounded,
              context.t.compteMesReclamations,
              '/reclamation/RC-00001',
            ),
            ligne(
              Icons.report_problem_outlined,
              context.t.compteSignalerUnProbleme,
              '/probleme/commande/LV-00482',
            ),
            const Divider(height: 24),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: LiveColors.erreur,
              ),
              title: Text(
                context.t.compteSeDeconnecter,
                style: TextStyle(color: LiveColors.erreur),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/bienvenue');
              },
            ),
          ],
        ),
      ),
    );
  }
}
