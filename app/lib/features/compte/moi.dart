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
      appBar: AppBar(
        title: const Text('Moi'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          IconButton(
            tooltip: 'Paramètres',
            onPressed: () => context.push('/parametres'),
            icon: const Icon(Icons.settings_outlined),
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
                      'N${etat.niveau} · ${libelleNiveau(etat.niveau)}',
                      icone: Icons.verified_user_outlined,
                      fond: const Color(0xFFE6EBF2),
                      couleur: LiveColors.bleu,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _Stat('128', 'Abonnés'),
              _Stat('${3 + 1}', 'Abonnements'),
              _Stat('4,8', 'Note'),
              _Stat('12', 'Transactions'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/parametres'),
                  child: const Text('Modifier'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/profil/moi'),
                  child: const Text('Profil public'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CartePouvoirs(actifs: actifs, total: pouvoirs.length),
          const SizedBox(height: 12),
          _CartePortefeuille(
            disponible: etat.disponible,
            enAttente: etat.enAttente,
          ),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 180,
            espacement: 10,
            hauteur: 96,
            enfants: [
              _Raccourci(
                Icons.auto_awesome_outlined,
                'Crédits Live',
                '${etat.credits} crédits',
                '/ia/historique',
              ),
              _Raccourci(
                Icons.storefront_outlined,
                'Mes ventes',
                '${etat.ventes.length} ventes',
                '/mes-ventes',
              ),
              _Raccourci(
                Icons.shopping_bag_outlined,
                'Mes achats',
                '${etat.achats.length} en cours',
                etat.achats.isEmpty
                    ? '/market'
                    : '/suivi/${etat.achats.first.id}',
              ),
              _Raccourci(
                Icons.home_outlined,
                'Mes visites',
                '${etat.visites.length} visite${etat.visites.length > 1 ? 's' : ''}',
                etat.visites.isEmpty
                    ? '/immo'
                    : '/visite/${etat.visites.first.id}',
              ),
              _Raccourci(
                Icons.handyman_outlined,
                'Prestations',
                '${etat.prestations.length} en cours',
                etat.prestations.isEmpty
                    ? '/services'
                    : '/prestation/${etat.prestations.first.id}',
              ),
            ],
          ),
          const EnTeteSection('Mes espaces'),
          LigneMenu(
            icone: Icons.apartment_rounded,
            titre: 'Agence Les Palmiers',
            detail: 'Espace agence de démonstration · 3 agents',
            onTap: () => context.push('/agence'),
          ),
          LigneMenu(
            icone: Icons.handyman_rounded,
            titre: 'Mes interventions',
            detail: 'Espace prestataire de démonstration (Serge)',
            onTap: () => context.push('/pro/interventions'),
          ),
          for (final e in etat.espaces)
            LigneMenu(
              icone: Icons.storefront_rounded,
              titre: e.nom,
              detail: 'Mon espace vérifié',
              onTap: () => context.push('/boutique/grace'),
            ),
          LigneMenu(
            icone: Icons.add_business_outlined,
            titre: 'Créer un espace',
            detail: 'Boutique, agence, prestataire ou chaîne',
            onTap: () => context.push('/espace/nouveau'),
          ),
          const EnTeteSection('Activité'),
          LigneMenu(
            icone: Icons.gavel_rounded,
            titre: 'Mes réclamations',
            valeur: '${etat.reclamations.length}',
            onTap: () => etat.reclamations.isEmpty
                ? ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Aucune réclamation en cours.'),
                    ),
                  )
                : context.push('/reclamation/${etat.reclamations.first.id}'),
          ),
          LigneMenu(
            icone: Icons.notifications_active_outlined,
            titre: 'Mes alertes de recherche',
            valeur: '${etat.alertes.length}',
            onTap: () => context.push('/alertes'),
          ),
          LigneMenu(
            icone: Icons.bookmark_border_rounded,
            titre: 'Enregistrés',
            valeur: '${etat.favoris.length}',
            onTap: () => context.push('/immo'),
          ),
          LigneMenu(
            icone: Icons.card_giftcard_rounded,
            titre: 'Inviter des amis',
            detail: '1 000 FCFA de crédits pour vous deux',
            onTap: () =>
                partager(context, 'Rejoins-moi sur Live · code GRACE26'),
          ),
          LigneMenu(
            icone: Icons.data_saver_on_rounded,
            titre: 'Données utilisées ce mois',
            valeur: '312 Mo',
            onTap: () => context.push('/donnees'),
          ),
          LigneMenu(
            icone: Icons.science_outlined,
            titre: 'Scénarios de test',
            couleur: LiveColors.gris,
            onTap: () => context.push('/scenarios'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.valeur, this.libelle);
  final String valeur;
  final String libelle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
      label: 'Mes super-pouvoirs, $actifs sur $total actifs',
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
                    const Text(
                      'Mes super-pouvoirs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$actifs sur $total actifs · gagnez de l’argent en débloquant les autres',
                      style: const TextStyle(
                        color: Color(0xFFD7DCE4),
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

/// « Mon portefeuille » : argent disponible et argent en attente (séquestre).
class _CartePortefeuille extends StatelessWidget {
  const _CartePortefeuille({required this.disponible, required this.enAttente});
  final int disponible;
  final int enAttente;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Mon portefeuille, ${fcfa(disponible)} disponibles, '
          '${fcfa(enAttente)} en attente',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/gains'),
        child: Bloc(
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: LiveColors.bleu,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Montant('Disponible', disponible, LiveColors.succes),
              ),
              Expanded(
                child: _Montant('En attente', enAttente, LiveColors.cuivre),
              ),
              const Icon(Icons.chevron_right_rounded, color: LiveColors.gris),
            ],
          ),
        ),
      ),
    );
  }
}

class _Montant extends StatelessWidget {
  const _Montant(this.libelle, this.montant, this.couleur);
  final String libelle;
  final int montant;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          libelle,
          style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            fcfa(montant),
            style: TextStyle(fontWeight: FontWeight.w800, color: couleur),
          ),
        ),
      ],
    );
  }
}
