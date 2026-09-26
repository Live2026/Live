import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme.dart';
import 'plan_ville.dart';
import '../l10n/textes.dart';

/// Carte complète, sur le modèle de Google Maps : zoom et déplacement au
/// doigt, plan ou satellite, « ma position » (GPS), vue rue. Dans
/// l'application réelle, le fond vient de Google Maps (docs/21, section 5).
class CarteInteractive extends StatefulWidget {
  const CarteInteractive({
    super.key,
    required this.reperes,
    this.trajet = const [],
    this.maPosition,
    this.lieuVueRue,
    this.modeInitial = ModeCarte.plan,
    this.margeBas = 16,
  });
  final List<Repere> reperes;
  final List<Offset> trajet;
  final Offset? maPosition;

  /// Lieu ouvert en vue rue ; nul : pas de bouton vue rue.
  final String? lieuVueRue;
  final ModeCarte modeInitial;

  /// Place laissée en bas pour un panneau posé sur la carte.
  final double margeBas;

  @override
  State<CarteInteractive> createState() => _CarteInteractiveState();
}

class _CarteInteractiveState extends State<CarteInteractive> {
  late var _mode = widget.modeInitial;
  final _zoom = TransformationController();

  @override
  void dispose() {
    _zoom.dispose();
    super.dispose();
  }

  void _recentrer(Size taille) {
    final p = widget.maPosition;
    if (p == null) {
      _zoom.value = Matrix4.identity();
      return;
    }
    // Zoom ×2 centré sur la position GPS.
    const echelle = 2.0;
    final x = -(p.dx * taille.width * echelle - taille.width / 2);
    final y = -(p.dy * taille.height * echelle - taille.height / 2);
    _zoom.value = Matrix4.identity()
      ..translateByDouble(
        x.clamp(-taille.width * (echelle - 1), 0),
        y.clamp(-taille.height * (echelle - 1), 0),
        0,
        1,
      )
      ..scaleByDouble(echelle, echelle, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final taille = Size(c.maxWidth, c.maxHeight);
        return Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              transformationController: _zoom,
              maxScale: 4,
              child: SizedBox.fromSize(
                size: taille,
                child: PlanVille(
                  reperes: widget.reperes,
                  mode: _mode,
                  trajet: widget.trajet,
                  maPosition: widget.maPosition,
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: widget.margeBas,
              child: Column(
                children: [
                  _BoutonCarte(
                    icone: _mode == ModeCarte.plan
                        ? Icons.satellite_alt_rounded
                        : Icons.map_rounded,
                    libelle: _mode == ModeCarte.plan
                        ? context.t.vueSatellite
                        : context.t.vuePlan,
                    onTap: () => setState(
                      () => _mode = _mode == ModeCarte.plan
                          ? ModeCarte.satellite
                          : ModeCarte.plan,
                    ),
                  ),
                  if (widget.lieuVueRue != null) ...[
                    const SizedBox(height: 8),
                    _BoutonCarte(
                      icone: Icons.streetview_rounded,
                      libelle: context.t.vueRue,
                      onTap: () => context.push(
                        '/rue?lieu=${Uri.encodeComponent(widget.lieuVueRue!)}',
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _BoutonCarte(
                    icone: Icons.my_location_rounded,
                    libelle: context.t.maPosition,
                    couleur: const Color(0xFF1A73E8),
                    onTap: () => _recentrer(taille),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BoutonCarte extends StatelessWidget {
  const _BoutonCarte({
    required this.icone,
    required this.libelle,
    required this.onTap,
    this.couleur = LiveColors.encre,
  });
  final IconData icone;
  final String libelle;
  final VoidCallback onTap;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: libelle,
      child: Material(
        color: LiveColors.surface,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icone, color: couleur, semanticLabel: libelle),
          ),
        ),
      ),
    );
  }
}
