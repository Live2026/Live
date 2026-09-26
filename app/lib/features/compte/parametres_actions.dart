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
                        quoi: 'le code affiché sur l’ordinateur',
                      ) &&
                      context.mounted) {
                    informer(context, 'Ordinateur connecté à votre compte.');
                  }
                },
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: const Text('Connecter un appareil'),
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
      titre: 'Langue',
      actuel: _etat.langue,
      options: [
        for (final (code, nom, francais) in languesLive)
          (code, nom, nom == francais ? null : francais),
      ],
    );
    if (choix != null && context.mounted) {
      ref.read(liveProvider.notifier).choisirLangue(choix);
      informer(context, 'Langue enregistrée.');
    }
  }

  /// Extension CEMAC : même monnaie (FCFA), annonces du pays choisi.
  Future<void> pays() async {
    final choix = await choisir<String>(
      context,
      titre: 'Pays et ville',
      actuel: _etat.pays,
      options: [
        for (final v in villesLive)
          (v.ville, v.libelle, v.operateurs.join(', ')),
      ],
    );
    if (choix != null && context.mounted) {
      ref.read(liveProvider.notifier).choisirPays(choix);
      informer(context, 'Annonces et prix de $choix, toujours en FCFA.');
    }
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
