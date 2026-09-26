import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Posé par `CadreDemarrage` : la page s'affiche dans la carte du démarrage
/// sur ordinateur, en version simple et centrée (façon WhatsApp Web).
class DansCarte extends InheritedWidget {
  const DansCarte({super.key, required super.child});

  static bool de(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DansCarte>() != null;

  @override
  bool updateShouldNotify(DansCarte ancien) => false;
}

/// Barre du haut des pages du démarrage. Sur ordinateur (dans
/// `CadreDemarrage`), la flèche de retour est en haut à gauche de la page,
/// comme sur WhatsApp : la barre n'en affiche pas une seconde.
class BarreDemarrage extends StatelessWidget implements PreferredSizeWidget {
  const BarreDemarrage({super.key, this.actions});
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    automaticallyImplyLeading: !DansCarte.de(context),
    actions: actions,
  );
}

/// Fond du démarrage : dégradé nuit et halos de couleur qui respirent.
class FondDemarrage extends StatefulWidget {
  const FondDemarrage({super.key, required this.child});
  final Widget child;

  @override
  State<FondDemarrage> createState() => _FondDemarrageState();
}

class _FondDemarrageState extends State<FondDemarrage>
    with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _anim.stop();
    } else if (!_anim.isAnimating) {
      _anim.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, enfant) {
        final t = Curves.easeInOut.transform(_anim.value);
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B2A4A), LiveColors.nuit],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Halo(
                alignement: Alignment(-1.1 + 0.3 * t, -0.8),
                couleur: LiveColors.orange,
              ),
              _Halo(
                alignement: Alignment(1.2 - 0.3 * t, -0.1 + 0.2 * t),
                couleur: const Color(0xFF7C3AED),
              ),
              _Halo(
                alignement: Alignment(-0.6, 1.1 - 0.25 * t),
                couleur: const Color(0xFF0EA5E9),
              ),
              enfant!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.alignement, required this.couleur});
  final Alignment alignement;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignement,
      child: IgnorePointer(
        child: Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                couleur.withValues(alpha: 0.35),
                couleur.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Étapes de l'inscription, pour la barre de progression.
const etapesInscription = [
  'Numéro',
  'Code',
  'Profil',
  'Code secret',
  'Intérêts',
];

/// En-tête des pages du démarrage, comme WhatsApp : titre et texte centrés.
/// Pendant l'inscription, une petite mention « Étape 1 sur 5 » au-dessus.
class EnTeteDemarrage extends StatelessWidget {
  const EnTeteDemarrage({
    super.key,
    required this.titre,
    required this.texte,
    this.etape,
  });
  final String titre;
  final String texte;

  /// Rang dans [etapesInscription] ; nul hors inscription (connexion).
  final int? etape;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 26),
      child: Column(
        children: [
          if (etape != null) ...[
            Text(
              'Étape ${etape! + 1} sur ${etapesInscription.length}',
              style: const TextStyle(
                color: LiveColors.gris,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            titre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: LiveColors.bleu,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texte,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: LiveColors.gris,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
