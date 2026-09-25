import 'package:flutter/material.dart';

/// Zone colorée qui remplace une photo ou une vidéo dans le prototype.
class Vignette extends StatelessWidget {
  const Vignette({
    super.key,
    required this.couleur,
    required this.icone,
    this.hauteur,
    this.largeur,
    this.video = false,
    this.rayon = 12,
  });
  final Color couleur;
  final IconData icone;
  final double? hauteur;
  final double? largeur;
  final bool video;
  final double rayon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hauteur,
      width: largeur,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rayon),
        gradient: LinearGradient(
          colors: [couleur, Color.lerp(couleur, Colors.black, 0.45)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: LayoutBuilder(
              builder: (_, c) => Icon(
                icone,
                color: Colors.white.withValues(alpha: 0.85),
                size:
                    ((hauteur ?? (c.maxHeight.isFinite ? c.maxHeight : 180)) *
                            0.33)
                        .clamp(14, 110),
              ),
            ),
          ),
          if (video)
            const Positioned(
              right: 8,
              bottom: 8,
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
}
