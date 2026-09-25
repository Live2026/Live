import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';

part 'conversation.dart';
part 'bulles.dart';
part 'groupe.dart';
part 'messages_plus.dart';

/// E-CHAT-01 — Conversations, façon WhatsApp : recherche, filtres, non lus,
/// coches de lecture et annonce liée.
class EcranMessages extends StatefulWidget {
  const EcranMessages({super.key});

  @override
  State<EcranMessages> createState() => _EcranMessagesState();
}

class _EcranMessagesState extends State<EcranMessages> {
  var _filtre = 'Tous';
  var _q = '';

  /// Conversation ouverte à droite, sur ordinateur (façon WhatsApp Web).
  Conversation _ouverte = conversations.first;

  @override
  Widget build(BuildContext context) {
    final liste = conversations
        .where((c) {
          return switch (_filtre) {
            'Non lus' => c.nonLus > 0,
            'Groupes' => c.type == TypeConversation.groupe,
            'Canaux' => c.type == TypeConversation.canal,
            _ => true,
          };
        })
        .where((c) {
          final q = _q.trim().toLowerCase();
          return q.isEmpty ||
              c.nom.toLowerCase().contains(q) ||
              c.dernier.toLowerCase().contains(q);
        })
        .toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    final deuxPanneaux = context.taille == Taille.etendue;
    final listeConversations = Scaffold(
      appBar: EnTeteRecherche(
        titre: const Text('Messages'),
        indice: 'Rechercher une conversation',
        onChanged: (v) => setState(() => _q = v),
        actions: [
          IconButton(
            tooltip: 'Nouveau message',
            onPressed: () => _nouveauMessage(context),
            icon: const Icon(Icons.edit_square),
          ),
          IconButton(
            tooltip: 'Réglages des messages',
            onPressed: () => context.push('/messages/parametres'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge),
              children: [
                for (final f in const ['Tous', 'Non lus', 'Groupes', 'Canaux'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: _filtre == f,
                      onSelected: (_) => setState(() => _filtre = f),
                    ),
                  ),
              ],
            ),
          ),
          if (_filtre == 'Tous') ...[
            _RangeeDossier(
              icone: Icons.mark_email_unread_outlined,
              titre: 'Demandes de messages',
              nombre: demandesMessages.length,
              route: '/messages/demandes',
              marge: marge,
            ),
            _RangeeDossier(
              icone: Icons.archive_outlined,
              titre: 'Archivées',
              nombre: conversationsArchivees.length,
              route: '/messages/archives',
              marge: marge,
            ),
          ],
          for (final (i, c) in liste.indexed)
            Apparition(
              rang: i,
              child: _LigneConversation(
                c: c,
                marge: marge,
                selectionnee: deuxPanneaux && c.id == _ouverte.id,
                onOuvrir: deuxPanneaux
                    ? () => setState(() => _ouverte = c)
                    : null,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: LiveColors.gris,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Vos messages sont chiffrés. Live ne vous demandera jamais votre code MoMo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: LiveColors.gris, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!deuxPanneaux) return listeConversations;
    final c = _ouverte;
    return Row(
      children: [
        SizedBox(width: 400, child: listeConversations),
        const VerticalDivider(width: 1),
        // Navigateur propre au panneau : la conversation n'a pas de flèche
        // retour, et ses panneaux du bas s'ouvrent dans le panneau.
        Expanded(
          child: Navigator(
            key: ValueKey(c.id),
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => c.type == TypeConversation.privee
                  ? const EcranConversation()
                  : EcranGroupe(id: c.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _LigneConversation extends StatelessWidget {
  const _LigneConversation({
    required this.c,
    required this.marge,
    this.selectionnee = false,
    this.onOuvrir,
  });
  final Conversation c;
  final double marge;
  final bool selectionnee;

  /// Sur ordinateur : ouvre la conversation dans le panneau de droite.
  final VoidCallback? onOuvrir;

  @override
  Widget build(BuildContext context) {
    final nonLu = c.nonLus > 0;
    final deMoi = c.dernier.startsWith('Vous :');
    final groupe = c.type != TypeConversation.privee;
    return Material(
      color: selectionnee ? const Color(0xFFE6EBF2) : Colors.transparent,
      child: InkWell(
        onTap:
            onOuvrir ??
            () => context.push(groupe ? '/groupe/${c.id}' : '/conversation'),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: marge, vertical: 10),
          child: Row(
            children: [
              Avatar(
                nom: c.nom,
                couleur: c.couleur,
                taille: 52,
                enLigne: c.enLigne,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (groupe) ...[
                          Icon(
                            c.type == TypeConversation.canal
                                ? Icons.campaign_rounded
                                : Icons.groups_rounded,
                            size: 17,
                            color: LiveColors.gris,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            c.nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                        Text(
                          c.quand,
                          style: TextStyle(
                            fontSize: 12,
                            color: nonLu ? LiveColors.bleu : LiveColors.gris,
                            fontWeight: nonLu
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (deMoi) ...[
                          Icon(
                            Icons.done_all_rounded,
                            size: 16,
                            color: c.lu
                                ? const Color(0xFF3B82F6)
                                : LiveColors.gris,
                          ),
                          const SizedBox(width: 3),
                        ],
                        Expanded(
                          child: Text(
                            c.dernier.replaceFirst('Vous : ', ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: nonLu ? LiveColors.nuit : LiveColors.gris,
                              fontWeight: nonLu
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (nonLu)
                          Container(
                            constraints: const BoxConstraints(minWidth: 20),
                            height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: LiveColors.bleu,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              '${c.nonLus}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (c.annonce != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.sell_outlined,
                            size: 13,
                            color: LiveColors.gris,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              c.annonce!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: LiveColors.gris,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
