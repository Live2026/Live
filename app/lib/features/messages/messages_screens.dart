import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';

part 'conversation.dart';
part 'bulles.dart';

/// E-CHAT-01 — Conversations, façon WhatsApp : recherche, filtres, non lus,
/// coches de lecture et annonce liée.
class EcranMessages extends StatefulWidget {
  const EcranMessages({super.key});

  @override
  State<EcranMessages> createState() => _EcranMessagesState();
}

class _EcranMessagesState extends State<EcranMessages> {
  var _filtre = 'Tous';

  @override
  Widget build(BuildContext context) {
    final liste = conversations.where((c) {
      return switch (_filtre) {
        'Non lus' => c.nonLus > 0,
        'Immo' => c.nom.contains('Agence'),
        'Services' => c.nom.contains('Plombier'),
        _ => true,
      };
    }).toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            tooltip: 'Nouveau message',
            onPressed: () {},
            icon: const Icon(Icons.edit_square),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 8),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Rechercher une conversation',
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge),
              children: [
                for (final f in const ['Tous', 'Non lus', 'Immo', 'Services'])
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
          for (final (i, c) in liste.indexed)
            Apparition(
              rang: i,
              child: _LigneConversation(c: c, marge: marge),
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
  }
}

class _LigneConversation extends StatelessWidget {
  const _LigneConversation({required this.c, required this.marge});
  final Conversation c;
  final double marge;

  @override
  Widget build(BuildContext context) {
    final nonLu = c.nonLus > 0;
    final deMoi = c.dernier.startsWith('Vous :');
    return InkWell(
      onTap: () => context.push('/conversation'),
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
                          fontWeight: nonLu ? FontWeight.w700 : FontWeight.w400,
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
    );
  }
}
