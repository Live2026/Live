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
      titre: 'Changer de numéro',
      texte:
          'Un code SMS sera envoyé au nouveau numéro. Pour votre sécurité, '
          'les retraits sont suspendus 24 h après le changement.',
      action: 'Continuer',
    )) {
      if (context.mounted) informer(context, 'Code envoyé au nouveau numéro.');
    }
  }

  Future<void> comptesRetrait() async {
    final choix = await choisir<String>(
      context,
      titre: 'Compte de retrait',
      actuel: _etat.operateur,
      options: [
        (
          'MTN',
          'MTN MoMo · ${_etat.telephone}',
          'Au nom de ${_etat.prenom} Mabiala',
        ),
        (
          'Airtel',
          'Ajouter un numéro Airtel Money',
          'Il doit être à votre nom (vérifié)',
        ),
      ],
    );
    if (choix == 'Airtel' && context.mounted) {
      informer(context, 'Un code SMS vérifiera le numéro Airtel Money.');
    }
  }

  Future<void> code(String titre) async {
    if (await changerCode(context, titre: titre) && context.mounted) {
      informer(context, '$titre modifié.');
    }
  }

  void appareils() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(
                Icons.phone_android_rounded,
                color: LiveColors.bleu,
              ),
              title: Text('Ce téléphone · Tecno Spark 10'),
              subtitle: Text('Brazzaville · actif maintenant'),
            ),
            ListTile(
              leading: const Icon(Icons.laptop_rounded),
              title: const Text('Chrome sur ordinateur'),
              subtitle: const Text('Pointe-Noire · il y a 2 jours'),
              trailing: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  informer(context, 'Appareil déconnecté.');
                },
                child: const Text('Déconnecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> langue() async {
    await choisir<String>(
      context,
      titre: 'Langue',
      actuel: 'fr',
      actives: {'fr'},
      options: const [
        ('fr', 'Français', null),
        ('ln', 'Lingala', 'Arrive en phase 2'),
        ('kt', 'Kituba', 'Arrive en phase 2'),
      ],
    );
  }

  void aide() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Text(
              'Centre d’aide',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            for (final (q, r) in const [
              (
                'Mon argent est-il protégé ?',
                'Oui : Live garde l’argent jusqu’à votre confirmation (QR ou « J’ai reçu »). Sinon, vous êtes remboursé.',
              ),
              (
                'Que se paie hors de Live ?',
                'Loyers, caution et prix d’un bien se paient en direct, contre reçu. Tout le reste passe par Live.',
              ),
              (
                'On me demande mon code MoMo',
                'C’est une arnaque. Live ne le demande jamais. Signalez le message.',
              ),
              (
                'Comment retirer mes gains ?',
                'Vérifiez votre identité une fois, puis retirez sur votre MoMo ou Airtel Money, sans frais.',
              ),
            ])
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  q,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(r),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/conversation');
              },
              icon: const Icon(Icons.support_agent_rounded),
              label: const Text('Écrire au support Live'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> donnees() async {
    final choix = await choisir<int>(
      context,
      titre: 'Mes données personnelles',
      options: const [
        (0, 'Télécharger mes données', 'Archive envoyée par SMS sous 48 h'),
        (
          1,
          'Voir ce que Live conserve',
          'Profil, annonces, transactions, messages',
        ),
      ],
    );
    if (choix == 0 && context.mounted) {
      informer(
        context,
        'Demande enregistrée : lien de téléchargement sous 48 h.',
      );
    }
  }

  void conditions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Text(
            'Conditions d’utilisation (résumé)\n\n'
            '• Un compte par personne et par numéro de téléphone.\n'
            '• Les paiements marqués « Payé dans Live » ne se font jamais ailleurs.\n'
            '• Les objets interdits (armes, médicaments, faux documents…) sont retirés.\n'
            '• Les avis ne sont possibles qu’après une transaction payée.\n'
            '• Vos données restent au Congo et ne sont jamais vendues.',
            style: TextStyle(height: 1.5),
          ),
        ),
      ),
    );
  }

  /// F-CPT-10 : suppression du compte, après retrait des gains.
  Future<void> supprimer() async {
    if (_etat.disponible > 0) {
      final retirer = await confirmer(
        context,
        titre: 'Retirez d’abord vos gains',
        texte:
            'Il vous reste ${fcfa(_etat.disponible)}. Retirez-les sur votre '
            'Mobile Money avant de supprimer votre compte.',
        action: 'Retirer mes gains',
      );
      if (retirer && context.mounted) context.push('/retirer');
      return;
    }
    if (await confirmer(
      context,
      titre: 'Supprimer mon compte',
      texte:
          'Vos annonces et votre profil disparaissent. Les reçus de paiement '
          'sont conservés 10 ans, comme la loi l’exige.',
      action: 'Supprimer',
      danger: true,
    )) {
      if (context.mounted) context.go('/bienvenue');
    }
  }
}
