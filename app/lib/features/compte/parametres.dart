part of 'compte_screens.dart';

/// E-MOI-06 — Paramètres du compte.
class EcranParametres extends ConsumerWidget {
  const EcranParametres({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final a = _ActionsParametres(context, ref);
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const EnTeteSection('Compte'),
          LigneMenu(
            icone: Icons.person_outline,
            titre: 'Profil',
            detail: '${etat.prenom} Mabiala · Moungali',
            onTap: () => context.push('/profil/moi'),
          ),
          LigneMenu(
            icone: Icons.phone_android,
            titre: 'Numéro de téléphone',
            valeur: etat.telephone,
            onTap: a.numero,
          ),
          LigneMenu(
            icone: Icons.verified_user_outlined,
            titre: 'Vérification',
            valeur: 'N${etat.niveau}',
            onTap: () =>
                context.push(etat.identiteVerifiee ? '/pouvoirs' : '/verifier'),
          ),
          LigneMenu(
            icone: Icons.account_balance_wallet_outlined,
            titre: 'Comptes de retrait',
            detail: 'MTN MoMo · ${etat.telephone}',
            onTap: a.comptesRetrait,
          ),
          const EnTeteSection('Sécurité'),
          LigneMenu(
            icone: Icons.pin_outlined,
            titre: 'Code secret de l’application',
            onTap: () => a.code('Code secret de l’application'),
          ),
          LigneMenu(
            icone: Icons.password_rounded,
            titre: 'Code secret de paiement',
            detail: 'Distinct du code de l’application',
            onTap: () => a.code('Code secret de paiement'),
          ),
          LigneMenu(
            icone: Icons.devices_outlined,
            titre: 'Appareils connectés',
            valeur: '1',
            onTap: a.appareils,
          ),
          const EnTeteSection('Préférences'),
          LigneMenu(
            icone: Icons.notifications_outlined,
            titre: 'Notifications',
            onTap: () => context.push('/notifications/preferences'),
          ),
          LigneMenu(
            icone: Icons.data_saver_on_rounded,
            titre: 'Économie de données',
            valeur: etat.economieDonnees ? 'Activée' : 'Désactivée',
            onTap: () => context.push('/donnees'),
          ),
          LigneMenu(
            icone: Icons.translate_rounded,
            titre: 'Langue',
            valeur: 'Français',
            onTap: a.langue,
          ),
          LigneMenu(
            icone: Icons.public_rounded,
            titre: 'Pays et ville',
            valeur: etat.pays,
            onTap: a.pays,
          ),
          LigneMenu(
            icone: Icons.interests_outlined,
            titre: 'Centres d’intérêt',
            onTap: () => context.push('/interets'),
          ),
          const EnTeteSection('Aide et confidentialité'),
          LigneMenu(
            icone: Icons.help_outline_rounded,
            titre: 'Centre d’aide',
            detail: 'Questions fréquentes, écrire au support, mes demandes',
            onTap: () => context.push('/aide'),
          ),
          LigneMenu(
            icone: Icons.privacy_tip_outlined,
            titre: 'Mes données personnelles',
            detail: 'Télécharger ou supprimer',
            onTap: a.donnees,
          ),
          LigneMenu(
            icone: Icons.description_outlined,
            titre: 'Conditions d’utilisation',
            onTap: () => context.push('/legal/cgu'),
          ),
          LigneMenu(
            icone: Icons.policy_outlined,
            titre: 'Politique de confidentialité',
            onTap: () => context.push('/legal/confidentialite'),
          ),
          LigneMenu(
            icone: Icons.logout_rounded,
            titre: 'Se déconnecter',
            couleur: LiveColors.erreur,
            onTap: () => context.go('/bienvenue'),
          ),
          LigneMenu(
            icone: Icons.delete_outline_rounded,
            titre: 'Supprimer mon compte',
            couleur: LiveColors.erreur,
            detail: 'Vos gains doivent d’abord être retirés',
            onTap: a.supprimer,
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Live 1.0 (prototype)',
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
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Préférences',
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
                color: n.nouvelle ? const Color(0xFFF1F5FA) : Colors.white,
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
                          backgroundColor: const Color(0xFFE6EBF2),
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
  final _actives = {
    'Paiements',
    'Messages',
    'Commandes et visites',
    'Alertes de recherche',
  };
  static const _types = [
    ('Paiements', 'Toujours envoyé aussi par SMS', true),
    ('Messages', 'Nouveaux messages et offres', false),
    ('Commandes et visites', 'Acceptation, remise, rappel de visite', false),
    ('Alertes de recherche', 'Nouveaux résultats', false),
    ('Comptes suivis', 'Nouvelles vidéos et directs', false),
    ('Offres de Live', 'Promotions, crédits offerts', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Préférences')),
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Les notifications de paiement ne peuvent pas être coupées : elles protègent votre argent.',
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
      appBar: AppBar(title: const Text('Économie de données')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ce mois-ci',
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
                const Text(
                  'Vidéos 71 % · photos 22 % · messages 7 %',
                  style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Économie de données',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text(
              'Vidéos en 360p, lecture au toucher sur réseau mobile. Environ 3 fois moins de données.',
            ),
            value: active,
            onChanged: (_) =>
                ref.read(liveProvider.notifier).basculerEconomieDonnees(),
          ),
          const Divider(),
          const LigneMenu(
            icone: Icons.wifi_rounded,
            titre: 'En Wi-Fi',
            detail: 'Vidéos en haute qualité, préchargement',
          ),
          const LigneMenu(
            icone: Icons.signal_cellular_alt_rounded,
            titre: 'En 3G / 4G',
            detail: 'Qualité réduite, pas de préchargement',
          ),
          const LigneMenu(
            icone: Icons.download_for_offline_outlined,
            titre: 'Téléchargements',
            detail: 'Uniquement en Wi-Fi',
          ),
          const Divider(),
          ValueListenableBuilder<bool>(
            valueListenable: horsConnexion,
            builder: (_, coupe, _) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Simuler une coupure du réseau',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text(
                'Prototype : affiche le bandeau « Hors connexion » sur toutes '
                'les pages. Les brouillons restent, les envois attendent.',
              ),
              value: coupe,
              onChanged: (v) => horsConnexion.value = v,
            ),
          ),
        ],
      ),
    );
  }
}
