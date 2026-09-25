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
      backgroundColor: Colors.white,
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
              subtitle: Text('N${etat.niveau} · ${libelleNiveau(etat.niveau)}'),
              trailing: IconButton(
                tooltip: 'Fermer le menu',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            const Divider(height: 1),
            section('Compte'),
            ligne(
              Icons.settings_outlined,
              'Paramètres et confidentialité',
              '/parametres',
            ),
            if (!etat.identiteVerifiee)
              ligne(Icons.badge_outlined, 'Vérifier mon identité', '/verifier'),
            ligne(
              Icons.notifications_none_rounded,
              'Notifications',
              '/notifications/preferences',
            ),
            ligne(
              Icons.data_saver_on_rounded,
              'Économie de données',
              '/donnees',
            ),
            ligne(Icons.bolt_rounded, 'Mes super-pouvoirs', '/pouvoirs'),
            section('Mon espace'),
            ligne(
              Icons.account_balance_wallet_outlined,
              'Mon argent Live',
              '/portefeuille',
              valeur: fcfaCourt(etat.disponible),
            ),
            ligne(
              Icons.shopping_bag_outlined,
              'Mes commandes',
              '/commandes',
              valeur: '${etat.achats.length}',
            ),
            ligne(Icons.storefront_outlined, 'Mes ventes', '/mes-ventes'),
            ligne(
              Icons.favorite_border_rounded,
              'Enregistrés',
              '/enregistres',
              valeur: '${etat.favoris.length}',
            ),
            ligne(
              Icons.notifications_active_outlined,
              'Mes alertes',
              '/alertes',
            ),
            ligne(
              Icons.people_outline_rounded,
              'Abonnés et abonnements',
              '/abonnes/moi',
            ),
            ligne(
              Icons.auto_awesome_outlined,
              'Crédits Live IA',
              '/ia/credits',
              valeur: '${etat.credits}',
            ),
            ligne(
              Icons.description_outlined,
              'Mes documents IA',
              '/ia/documents',
            ),
            section('Espaces professionnels'),
            ligne(Icons.apartment_rounded, 'Agence Les Palmiers', '/agence'),
            ligne(
              Icons.handyman_rounded,
              'Mes interventions',
              '/pro/interventions',
            ),
            ligne(
              Icons.add_business_outlined,
              'Créer un espace',
              '/espace/nouveau',
            ),
            ligne(Icons.insights_outlined, 'Live Pro', '/live-pro'),
            section('Créateur'),
            ligne(Icons.insights_rounded, 'Studio créateur', '/studio'),
            ligne(Icons.podcasts_rounded, 'Lancer un direct', '/direct/lancer'),
            ligne(
              Icons.volunteer_activism_outlined,
              'Fonds Créateurs',
              '/fonds-createurs',
            ),
            section('Développer mon activité'),
            ligne(Icons.bolt_rounded, 'Live Plus', '/live-plus'),
            ligne(Icons.campaign_outlined, 'Publicité', '/publicite'),
            ligne(
              Icons.workspace_premium_outlined,
              'Offres Pro',
              '/live-pro/offres',
            ),
            ligne(
              Icons.account_balance_outlined,
              'Services financiers',
              '/finance',
            ),
            ligne(Icons.hub_outlined, 'API partenaires', '/partenaires'),
            section('Aide et confiance'),
            ligne(
              Icons.payments_outlined,
              'Ce qui se paie dans Live',
              '/paiements',
            ),
            ligne(
              Icons.gavel_rounded,
              'Mes réclamations',
              '/reclamation/RC-00001',
            ),
            ligne(
              Icons.report_problem_outlined,
              'Signaler un problème',
              '/probleme/commande/LV-00482',
            ),
            const Divider(height: 24),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: LiveColors.erreur,
              ),
              title: const Text(
                'Se déconnecter',
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
