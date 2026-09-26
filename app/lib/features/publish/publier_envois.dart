part of 'publish_screen.dart';

/// E-PUB-06 — Envois en cours : compression, envoi, publication, reprise.
class EcranEnvois extends StatefulWidget {
  const EcranEnvois({super.key});

  @override
  State<EcranEnvois> createState() => _EcranEnvoisState();
}

class _EcranEnvoisState extends State<EcranEnvois> {
  var _wifi = false;
  var _repris = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.publishEnvoisEnCours)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Envoi(
            titre: context.t.publishNouvelArrivageLivraison24,
            etape: context.t.publishCompressionPourReseauMobile,
            progression: 0.62,
            couleur: Color(0xFFB45309),
          ),
          _Envoi(
            titre: context.t.publishRobeWaxLonguePhotos,
            etape: context.t.publishPublieIlYA,
            progression: 1,
            couleur: Color(0xFF9A3412),
          ),
          _Envoi(
            titre: context.t.publishVisiteDuStudio,
            etape: _repris
                ? context.t.publishRepriseDeLEnvoi
                : context.t.publishConnexionPerdueA48,
            progression: _repris ? 0.55 : 0.48,
            couleur: const Color(0xFF334155),
            erreur: !_repris,
            onReprendre: () => setState(() => _repris = true),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.t.publishEnvoyerSeulementEnWi),
            subtitle: Text(context.t.publishLesVideosAttendentUne),
            value: _wifi,
            onChanged: (v) => setState(() => _wifi = v),
          ),
          Text(
            context.t.publishLEnvoiReprendLa,
            style: TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Envoi extends StatelessWidget {
  const _Envoi({
    required this.titre,
    required this.etape,
    required this.progression,
    required this.couleur,
    this.erreur = false,
    this.onReprendre,
  });
  final String titre;
  final String etape;
  final double progression;
  final Color couleur;
  final bool erreur;
  final VoidCallback? onReprendre;

  @override
  Widget build(BuildContext context) {
    final fini = progression >= 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Bloc(
        padding: 12,
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 64,
              child: Vignette(
                couleur: couleur,
                icone: Icons.play_arrow_rounded,
                rayon: 8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    etape,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: erreur
                          ? LiveColors.erreur
                          : fini
                          ? LiveColors.succes
                          : LiveColors.gris,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: progression),
                    duration: const Duration(milliseconds: 900),
                    curve: courbeDouce,
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(3),
                      color: erreur
                          ? LiveColors.erreur
                          : fini
                          ? LiveColors.succes
                          : LiveColors.bleu,
                    ),
                  ),
                ],
              ),
            ),
            if (erreur)
              IconButton(
                tooltip: context.t.publishReprendre,
                onPressed: onReprendre,
                icon: const Icon(Icons.refresh_rounded),
              )
            else if (fini)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: LiveColors.succes,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
