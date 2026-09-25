part of 'social_screens.dart';

/// Ligne d'un compte : avatar (anneau si nouveauté), nom, badges « Vous
/// suit » ou « Vous vous suivez », type et bio, bouton principal et menu.
class _LigneCompte extends ConsumerWidget {
  const _LigneCompte({
    required this.compte,
    required this.marge,
    required this.abonne,
    required this.ongletAbonnes,
  });
  final Compte compte;
  final double marge;

  /// Ce compte me suit.
  final bool abonne;
  final bool ongletAbonnes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = compte;
    final etat = ref.watch(liveProvider);
    final suivi = etat.suivis.contains(c.id);
    final sourdine = etat.sourdine.contains(c.id);
    final store = ref.read(liveProvider.notifier);
    return InkWell(
      onTap: c.route == null ? null : () => context.push(c.route!),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: marge, vertical: 8),
        child: Row(
          children: [
            Opacity(
              opacity: sourdine ? 0.5 : 1,
              child: Avatar(
                nom: c.nom,
                couleur: c.couleur,
                taille: 52,
                verifie: c.verifie,
                anneau: c.recent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          c.nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (sourdine) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.volume_off_rounded,
                          size: 14,
                          color: LiveColors.gris,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '${c.type.libelle} · ${compact(c.abonnes)} abonnés',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (abonne && suivi)
                    const Etiquette(
                      'Vous vous suivez',
                      icone: Icons.sync_alt_rounded,
                      fond: Color(0xFFE7F4EC),
                      couleur: LiveColors.succes,
                    )
                  else if (abonne && !ongletAbonnes)
                    const Etiquette(
                      'Vous suit',
                      fond: Color(0xFFE6EBF2),
                      couleur: LiveColors.bleu,
                    )
                  else
                    Text(
                      c.bio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 104,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: suivi
                    ? OutlinedButton(
                        key: const ValueKey('abonne'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => store.basculerSuivi(c.id),
                        child: const Text('Abonné'),
                      )
                    : FilledButton(
                        key: const ValueKey('suivre'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => store.basculerSuivi(c.id),
                        child: FittedBox(
                          child: Text(abonne ? 'Suivre en retour' : 'Suivre'),
                        ),
                      ),
              ),
            ),
            IconButton(
              tooltip: 'Plus d’options pour ${c.nom}',
              onPressed: () =>
                  _menuCompte(context, ref, c, ongletAbonnes: ongletAbonnes),
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu d'un compte (panneau du bas) : actions de relation et de sécurité.
void _menuCompte(
  BuildContext context,
  WidgetRef ref,
  Compte c, {
  required bool ongletAbonnes,
}) {
  final store = ref.read(liveProvider.notifier);
  final etat = ref.read(liveProvider);
  void message(String texte) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(texte)));
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      void action(VoidCallback f) {
        Navigator.pop(ctx);
        f();
      }

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Avatar(
                nom: c.nom,
                couleur: c.couleur,
                taille: 44,
                verifie: c.verifie,
              ),
              title: Text(
                c.nom,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                c.enCommun.isEmpty
                    ? c.bio
                    : 'Suivi par ${c.enCommun.first}${c.enCommun.length > 1 ? ' et ${c.enCommun.length - 1} autre${c.enCommun.length > 2 ? 's' : ''}' : ''}',
              ),
            ),
            const Divider(height: 8),
            if (c.route != null)
              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Voir le profil'),
                onTap: () => action(() => context.push(c.route!)),
              ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded),
              title: const Text('Envoyer un message'),
              onTap: () => action(() => context.push('/conversation')),
            ),
            if (ongletAbonnes)
              ListTile(
                leading: const Icon(Icons.person_remove_outlined),
                title: const Text('Retirer cet abonné'),
                subtitle: const Text('Il n’est pas prévenu'),
                onTap: () => action(() {
                  store.retirerAbonne(c.id);
                  message('${c.nom} ne vous suit plus.');
                }),
              ),
            if (etat.suivis.contains(c.id))
              ListTile(
                leading: Icon(
                  etat.cloches.contains(c.id)
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: LiveColors.orangeVif,
                ),
                title: Text(
                  etat.cloches.contains(c.id)
                      ? 'Ne plus être prévenu de ses publications'
                      : 'Être prévenu de chaque publication',
                ),
                onTap: () => action(() => store.basculerCloche(c.id)),
              ),
            ListTile(
              leading: Icon(
                etat.sourdine.contains(c.id)
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_outlined,
              ),
              title: Text(
                etat.sourdine.contains(c.id)
                    ? 'Réactiver'
                    : 'Mettre en sourdine',
              ),
              subtitle: const Text(
                'Ses publications n’apparaissent plus dans votre fil',
              ),
              onTap: () => action(() => store.basculerSourdine(c.id)),
            ),
            ListTile(
              leading: const Icon(
                Icons.block_rounded,
                color: LiveColors.erreur,
              ),
              title: const Text(
                'Bloquer',
                style: TextStyle(color: LiveColors.erreur),
              ),
              onTap: () => action(() {
                store.bloquer(c.id);
                message('${c.nom} est bloqué.');
              }),
            ),
            ListTile(
              leading: const Icon(
                Icons.flag_outlined,
                color: LiveColors.erreur,
              ),
              title: const Text(
                'Signaler',
                style: TextStyle(color: LiveColors.erreur),
              ),
              onTap: () => action(() => signaler(context, 'ce compte')),
            ),
          ],
        ),
      );
    },
  );
}

/// Carte de suggestion, comme Instagram : avatar, nom, raison, Suivre, écarter.
class _CarteSuggestion extends ConsumerWidget {
  const _CarteSuggestion({required this.compte, required this.onEcarter});
  final Compte compte;
  final VoidCallback onEcarter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = compte;
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(c.id)),
    );
    final raison = c.enCommun.isEmpty
        ? 'Populaire à Brazzaville'
        : 'Suivi par ${c.enCommun.first}${c.enCommun.length > 1 ? ' et ${c.enCommun.length - 1} autre${c.enCommun.length > 2 ? 's' : ''}' : ''}';
    return Pressable(
      onTap: c.route == null ? null : () => context.push(c.route!),
      child: Bloc(
        padding: 12,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 4),
                Avatar(
                  nom: c.nom,
                  couleur: c.couleur,
                  taille: 64,
                  verifie: c.verifie,
                  anneau: c.recent,
                ),
                const SizedBox(height: 8),
                Text(
                  c.nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  c.type.libelle,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  raison,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: LiveColors.gris),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: suivi
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                          ),
                          onPressed: () => ref
                              .read(liveProvider.notifier)
                              .basculerSuivi(c.id),
                          child: const Text('Abonné'),
                        )
                      : FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 36),
                          ),
                          onPressed: () => ref
                              .read(liveProvider.notifier)
                              .basculerSuivi(c.id),
                          child: const Text('Suivre'),
                        ),
                ),
              ],
            ),
            Positioned(
              right: -8,
              top: -8,
              child: IconButton(
                tooltip: 'Écarter ${c.nom}',
                onPressed: onEcarter,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: LiveColors.gris,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte « Inviter vos contacts » : parrainage, 1 000 FCFA de crédits chacun.
class _CarteInviter extends StatelessWidget {
  const _CarteInviter({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [LiveColors.bleu, LiveColors.nuit],
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              color: LiveColors.ambreClair,
              size: 32,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invitez vos contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '1 000 FCFA de crédits Live pour vous deux à leur inscription.',
                    style: TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Invitation : lien de parrainage partagé par WhatsApp, SMS ou lien.
void _inviter(BuildContext context) =>
    partager(context, 'Rejoins-moi sur Live · code GRACE26');
