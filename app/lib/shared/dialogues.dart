import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'saisie.dart';
import '../l10n/textes.dart';

/// Fenêtres et panneaux courts réutilisés partout : confirmer, saisir un
/// code, choisir une option, informer.

/// Message bref en bas de l'écran.
void informer(BuildContext context, String texte) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));

/// Demande de confirmation ; vrai si l'utilisateur confirme.
Future<bool> confirmer(
  BuildContext context, {
  required String titre,
  required String texte,
  String? action,
  bool danger = false,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titre),
      content: Text(texte),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(context.t.annuler),
        ),
        FilledButton(
          style: danger
              ? FilledButton.styleFrom(backgroundColor: LiveColors.erreur)
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(action ?? context.t.confirmer),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Saisie d'un code de secours (`LV-` + lettre + 4 chiffres).
Future<String?> saisirCode(
  BuildContext context, {
  required String titre,
  String? consigne,
}) {
  final champ = TextEditingController(text: 'LV-');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titre),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            consigne ?? context.t.codeSousQr,
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: champ,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(fontSize: 22, letterSpacing: 3),
            decoration: const InputDecoration(hintText: 'LV-V3915'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(context.t.annuler),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            ctx,
            champ.text.trim().length >= 7 ? champ.text.trim() : 'LV-V3915',
          ),
          child: Text(context.t.valider),
        ),
      ],
    ),
  );
}

/// Choix d'une option dans un panneau du bas ; renvoie l'option choisie.
/// Une option sans description reste visible mais inactive si [actives]
/// l'exclut (fonction prévue plus tard).
Future<T?> choisir<T>(
  BuildContext context, {
  required String titre,
  required List<(T, String, String?)> options,
  T? actuel,
  Set<T>? actives,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titre,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            for (final (valeur, libelle, detail) in options)
              Opacity(
                opacity: actives == null || actives.contains(valeur) ? 1 : 0.5,
                child: Choix(
                  titre: libelle,
                  sousTitre: detail,
                  selectionne: valeur == actuel,
                  onTap: actives == null || actives.contains(valeur)
                      ? () => Navigator.pop(ctx, valeur)
                      : () {},
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Nouveau code secret à 4 chiffres, saisi deux fois ; vrai si changé.
Future<bool> changerCode(BuildContext context, {required String titre}) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titre,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            Text(
              context.t.choisissez4ChiffresQue,
              style: TextStyle(color: LiveColors.gris),
            ),
            ClavierPin(onComplet: (_) => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    ),
  );
  return ok ?? false;
}
