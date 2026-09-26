part of 'messages_screens.dart';

/// Panneaux de la conversation : options (boutique, archiver, bloquer,
/// signaler) et pièces jointes (photo, lieu de rendez-vous).
extension _ActionsConversation on _EcranConversationState {
  /// Options de la conversation (F-CHAT-06) : profil, archiver, bloquer,
  /// signaler.
  void _options(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: Text(context.t.messagesVoirLaBoutique),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/boutique/grace');
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: Text(context.t.messagesArchiverLaConversation),
              onTap: () {
                Navigator.pop(ctx);
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.block_rounded,
                color: LiveColors.erreur,
              ),
              title: Text(
                context.t.messagesBloquer,
                style: TextStyle(color: LiveColors.erreur),
              ),
              subtitle: Text(context.t.messagesIlNePourraPlus),
              onTap: () {
                Navigator.pop(ctx);
                ProviderScope.containerOf(context)
                    .read(liveProvider.notifier)
                    .bloquer('grace');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.t.messagesGraceModeEstBloque)),
                );
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.flag_outlined,
                color: LiveColors.erreur,
              ),
              title: Text(
                context.t.messagesSignaler,
                style: TextStyle(color: LiveColors.erreur),
              ),
              onTap: () {
                Navigator.pop(ctx);
                signaler(context, context.t.messagesCetteConversation);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Pièces jointes, dont E-CHAT-03 « Proposer un lieu de rendez-vous ».
  void _joindre(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.messagesProposerUnLieuDe,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              Text(
                context.t.messagesLieuxPublicsEtFrequentes,
                style: TextStyle(color: LiveColors.gris),
              ),
              const SizedBox(height: 8),
              for (final (lieu, detail) in [
                (
                  'Station Total Moungali',
                  context.t.messagesEclaireeGardienneeA600,
                ),
                ('Marché Total', context.t.messagesEntreePrincipaleA1),
                (
                  'Centre commercial Plateau',
                  context.t.messagesParkingSurveilleA3,
                ),
                (
                  'Commissariat de Moungali',
                  context.t.messagesPointDeRemiseSur,
                ),
              ])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: LiveColors.teinteVerte,
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: LiveColors.succes,
                    ),
                  ),
                  title: Text(lieu),
                  subtitle: Text(detail),
                  onTap: () {
                    Navigator.pop(ctx);
                    _envoyer(_Lieu(lieu, 'maintenant'));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
