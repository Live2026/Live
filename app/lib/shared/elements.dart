import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../core/theme.dart';
import 'demarrage.dart';

/// Bouton « Écouter l'explication » (principe 11). Le prototype affiche le texte lu.
class BoutonEcouter extends StatelessWidget {
  const BoutonEcouter(this.explication, {super.key});
  final String explication;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.volume_up, color: LiveColors.bleu),
                  SizedBox(width: 8),
                  Text(
                    'Lecture audio (simulée)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                explication,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 12),
              const Text(
                "Dans l'application réelle, ce texte est lu à voix haute en français, puis en lingala et en kituba.",
                style: TextStyle(color: LiveColors.gris),
              ),
            ],
          ),
        ),
      ),
      icon: const Icon(Icons.play_circle_outline),
      label: const Text("Écouter l'explication"),
    );
  }
}

/// Ligne « libellé ........ montant ».
class LigneMontant extends StatelessWidget {
  const LigneMontant(
    this.libelle,
    this.montant, {
    super.key,
    this.gras = false,
    this.brut,
  });
  final String libelle;
  final int montant;
  final bool gras;
  final String? brut;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: gras ? 18 : 15,
      fontWeight: gras ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(libelle, style: style)),
          Text(brut ?? fcfa(montant), style: style),
        ],
      ),
    );
  }
}

/// Barre du bas contenant le bouton principal de l'écran (principe 2).
class BarreAction extends StatelessWidget {
  const BarreAction({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Dans la carte du démarrage sur ordinateur : un bouton compact centré,
    // sans filet ni fond (façon WhatsApp Web).
    if (DansCarte.de(context)) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Center(
          heightFactor: 1,
          child: SizedBox(width: 260, child: child),
        ),
      );
    }
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: LiveColors.surface,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        // Sur une surface large, les actions restent compactes et alignées à
        // droite au lieu de s'étirer ; dans une carte étroite (démarrage sur
        // ordinateur), elles prennent toute la largeur de la carte.
        child: LayoutBuilder(
          builder: (context, c) => c.maxWidth >= 808
              ? Align(
                  alignment: Alignment.centerRight,
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: child,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

/// Icône « Messages » des barres du haut (la messagerie n'est plus un onglet).
class BoutonMessages extends StatelessWidget {
  const BoutonMessages({super.key, this.couleur});
  final Color? couleur;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Messages',
      onPressed: () => context.push('/messages'),
      icon: Badge(
        label: const Text('1'),
        child: Icon(Icons.chat_bubble_outline, color: couleur),
      ),
    );
  }
}

/// Bouton de test : simule l'action de l'autre personne. Discret et étiqueté,
/// il n'existe pas dans l'application réelle.
class BoutonSimulation extends StatelessWidget {
  const BoutonSimulation({super.key, required this.texte, required this.onTap});
  final String texte;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: LiveColors.gris,
        side: const BorderSide(color: LiveColors.filet),
        backgroundColor: LiveColors.champ,
      ),
      onPressed: onTap,
      icon: const Icon(Icons.science_outlined, size: 18),
      label: Text(texte),
    );
  }
}

/// Bouton rond « verre dépoli » posé sur une photo ou une vidéo (style iOS).
class BoutonVerre extends StatelessWidget {
  const BoutonVerre({
    super.key,
    required this.icone,
    required this.onTap,
    required this.libelle,
    this.clair = false,
  });
  final IconData icone;
  final VoidCallback onTap;
  final String libelle;

  /// Verre clair (sur fond sombre) ou sombre (sur photo claire).
  final bool clair;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: libelle,
      excludeSemantics: true,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: clair
                ? Colors.white.withValues(alpha: 0.72)
                : Colors.black.withValues(alpha: 0.28),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  icone,
                  size: 21,
                  color: clair ? LiveColors.encre : LiveColors.surface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ligne de réglage ou de menu : icône, titre, détail, chevron.
class LigneMenu extends StatelessWidget {
  const LigneMenu({
    super.key,
    required this.icone,
    required this.titre,
    this.detail,
    this.valeur,
    this.onTap,
    this.couleur = LiveColors.bleu,
    this.trailing,
  });
  final IconData icone;
  final String titre;
  final String? detail;
  final String? valeur;
  final VoidCallback? onTap;
  final Color couleur;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, size: 20, color: couleur),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (detail != null)
                    Text(
                      detail!,
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12.5,
                      ),
                    ),
                ],
              ),
            ),
            if (valeur != null)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 170),
                child: Text(
                  valeur!,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 13),
                ),
              ),
            trailing ??
                (onTap == null
                    ? const SizedBox.shrink()
                    : const Icon(
                        Icons.chevron_right_rounded,
                        color: LiveColors.gris,
                      )),
          ],
        ),
      ),
    );
  }
}

/// Carte blanche à bord fin : le conteneur standard des blocs d'information.
class Bloc extends StatelessWidget {
  const Bloc({super.key, required this.child, this.padding = 16, this.fond});
  final Widget child;
  final double padding;
  final Color? fond;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: fond ?? LiveColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LiveColors.filet),
      ),
      child: child,
    );
  }
}
