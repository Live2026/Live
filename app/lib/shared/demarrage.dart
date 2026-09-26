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

/// Courbe d'arrivée des éléments du démarrage.
const courbeSortie = Curves.easeOutCubic;

/// Étapes de l'inscription, pour la barre de progression.
const etapesInscription = [
  'Numéro',
  'Code',
  'Profil',
  'Code secret',
  'Intérêts',
];

/// En-tête d'une étape du démarrage : barre de progression en segments,
/// grande icône sur un dégradé, titre et explication.
class EnTeteDemarrage extends StatelessWidget {
  const EnTeteDemarrage({
    super.key,
    required this.icone,
    required this.couleurs,
    required this.titre,
    required this.texte,
    this.etape,
  });
  final IconData icone;

  /// Deux couleurs du dégradé de l'icône (chaque étape a les siennes).
  final List<Color> couleurs;
  final String titre;
  final String texte;

  /// Rang dans [etapesInscription] ; nul hors inscription (connexion).
  final int? etape;

  @override
  Widget build(BuildContext context) {
    // Dans la carte d'ordinateur : titre et texte centrés, rien d'autre.
    if (DansCarte.de(context)) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 26),
        child: Column(
          children: [
            Text(
              titre,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
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
    final reduit = MediaQuery.disableAnimationsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (etape != null) ...[
          Semantics(
            label:
                'Étape ${etape! + 1} sur ${etapesInscription.length} : '
                '${etapesInscription[etape!]}',
            excludeSemantics: true,
            child: Row(
              children: [
                for (var i = 0; i < etapesInscription.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: i <= etape! ? 1 : 0),
                        duration: reduit
                            ? Duration.zero
                            : Duration(milliseconds: 400 + 120 * i),
                        curve: courbeSortie,
                        builder: (_, v, _) => LinearProgressIndicator(
                          value: v,
                          minHeight: 5,
                          color: couleurs.last,
                          backgroundColor: const Color(0xFFE6EBF2),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Étape ${etape! + 1} sur ${etapesInscription.length} · '
            '${etapesInscription[etape!]}',
            style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
          const SizedBox(height: 18),
        ],
        TweenAnimationBuilder<double>(
          tween: Tween(begin: reduit ? 1 : 0.6, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          builder: (_, e, enfant) => Transform.scale(
            scale: e,
            alignment: Alignment.centerLeft,
            child: enfant,
          ),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: couleurs,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: couleurs.last.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icone, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          titre,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          texte,
          style: const TextStyle(color: LiveColors.gris, height: 1.4),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
