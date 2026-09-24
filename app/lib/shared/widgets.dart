import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/format.dart';
import '../core/theme.dart';

/// Zone colorée qui remplace une photo ou une vidéo dans le prototype.
class Vignette extends StatelessWidget {
  const Vignette({
    super.key,
    required this.couleur,
    required this.icone,
    this.hauteur = 180,
    this.largeur,
    this.video = false,
    this.rayon = 12,
  });
  final Color couleur;
  final IconData icone;
  final double hauteur;
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
            child: Icon(
              icone,
              color: Colors.white.withValues(alpha: 0.85),
              size: hauteur * 0.35,
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

/// Bandeau « Protégé par Live » (composant 5.3 des maquettes).
class BandeauProtection extends StatelessWidget {
  const BandeauProtection(this.texte, {super.key});
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user, color: LiveColors.bleu, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Protégé par Live. ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: LiveColors.bleu,
                    ),
                  ),
                  TextSpan(text: texte),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

/// Carte QR de confirmation (composant 5.6) : remplace les codes à dicter.
class CarteQr extends StatelessWidget {
  const CarteQr({
    super.key,
    required this.titre,
    required this.donnee,
    required this.codeSecours,
    required this.consigne,
  });
  final String titre;
  final String donnee;
  final String codeSecours;
  final String consigne;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E8EE)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F041936),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            titre.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: LiveColors.bleu,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: QrImageView(data: donnee, size: 170),
          ),
          const SizedBox(height: 10),
          Text(
            'Code de secours : $codeSecours',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(consigne, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          const Text(
            "Ce n'est pas votre code MoMo.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: LiveColors.erreur,
            ),
          ),
        ],
      ),
    );
  }
}

/// Option sélectionnable (remplace les boutons radio).
class Choix extends StatelessWidget {
  const Choix({
    super.key,
    required this.titre,
    this.sousTitre,
    required this.selectionne,
    required this.onTap,
    this.icone,
    this.trailing,
  });
  final String titre;
  final String? sousTitre;
  final bool selectionne;
  final VoidCallback onTap;
  final IconData? icone;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selectionne ? LiveColors.fondProtection : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selectionne ? LiveColors.bleu : Colors.grey.shade300,
            width: selectionne ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  selectionne
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selectionne ? LiveColors.bleu : LiveColors.gris,
                ),
                const SizedBox(width: 10),
                if (icone != null) ...[Icon(icone), const SizedBox(width: 10)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (sousTitre != null)
                        Text(
                          sousTitre!,
                          style: const TextStyle(color: LiveColors.gris),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) Text(trailing!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Clavier de code secret : affiche des points, jamais les chiffres.
class ClavierPin extends StatefulWidget {
  const ClavierPin({super.key, required this.onComplet, this.longueur = 4});
  final ValueChanged<String> onComplet;
  final int longueur;

  @override
  State<ClavierPin> createState() => _ClavierPinState();
}

const _effacer = 'effacer';

class _ClavierPinState extends State<ClavierPin> {
  var _saisie = '';

  void _touche(String t) {
    setState(() {
      if (t == _effacer) {
        if (_saisie.isNotEmpty) {
          _saisie = _saisie.substring(0, _saisie.length - 1);
        }
      } else if (_saisie.length < widget.longueur) {
        _saisie += t;
      }
    });
    if (_saisie.length == widget.longueur) {
      final code = _saisie;
      Future<void>.delayed(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => _saisie = '');
        widget.onComplet(code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.longueur; i++)
              Container(
                margin: const EdgeInsets.all(8),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _saisie.length
                      ? LiveColors.bleu
                      : Colors.grey.shade300,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (final ligne in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', _effacer],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final t in ligne)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(
                    width: 72,
                    height: 56,
                    child: t.isEmpty
                        ? null
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(72, 56),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => _touche(t),
                            child: t == _effacer
                                ? const Icon(
                                    Icons.backspace_outlined,
                                    semanticLabel: 'Effacer',
                                  )
                                : Text(t, style: const TextStyle(fontSize: 22)),
                          ),
                  ),
                ),
            ],
          ),
      ],
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

/// Badge de vérification (icône + texte).
class BadgeVerifie extends StatelessWidget {
  const BadgeVerifie(this.texte, {super.key});
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified, color: LiveColors.bleu, size: 16),
        const SizedBox(width: 4),
        Text(
          texte,
          style: const TextStyle(
            color: LiveColors.bleu,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// Barre du bas contenant le bouton principal de l'écran (principe 2).
class BarreAction extends StatelessWidget {
  const BarreAction({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        // Sur grand écran, les actions restent compactes et alignées à droite
        // au lieu de s'étirer sur toute la largeur.
        child: MediaQuery.sizeOf(context).width >= 840
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
    );
  }
}

/// Simule le scan d'un QR : écran « caméra » puis succès après un court délai.
Future<bool> simulerScan(BuildContext context, {required String quoi}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _DialogueScan(quoi: quoi),
  );
  return ok ?? false;
}

class _DialogueScan extends StatefulWidget {
  const _DialogueScan({required this.quoi});
  final String quoi;

  @override
  State<_DialogueScan> createState() => _DialogueScanState();
}

class _DialogueScanState extends State<_DialogueScan> {
  var _scanne = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _scanne = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_scanne ? 'QR reconnu' : 'Scanner le QR ${widget.quoi}'),
      content: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: _scanne
              ? const Icon(
                  Icons.check_circle,
                  color: LiveColors.ambre,
                  size: 90,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Caméra simulée…',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(120, 44)),
          onPressed: _scanne ? () => Navigator.pop(context, true) : null,
          child: const Text('Continuer'),
        ),
      ],
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

/// Étape d'une frise chronologique (commande, visite, prestation).
class EtapeFrise {
  const EtapeFrise(this.titre, this.detail, this.faite);
  final String titre;
  final String detail;
  final bool faite;
}

/// Frise verticale : pastilles reliées par un trait, l'étape en cours soulignée.
class Frise extends StatelessWidget {
  const Frise({super.key, required this.etapes});
  final List<EtapeFrise> etapes;

  @override
  Widget build(BuildContext context) {
    final encours = etapes.indexWhere((e) => !e.faite);
    return Column(
      children: [
        for (final (i, e) in etapes.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: e.faite ? LiveColors.bleu : Colors.white,
                          border: Border.all(
                            color: e.faite || i == encours
                                ? LiveColors.bleu
                                : const Color(0xFFC3CAD4),
                            width: 2,
                          ),
                        ),
                        child: e.faite
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      if (i < etapes.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            color: e.faite
                                ? LiveColors.bleu
                                : const Color(0xFFE4E8EE),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.titre,
                          style: TextStyle(
                            fontWeight: i == encours || e.faite
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: e.faite || i == encours
                                ? LiveColors.nuit
                                : LiveColors.gris,
                          ),
                        ),
                        Text(
                          e.detail,
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
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
        side: const BorderSide(color: Color(0xFFE4E8EE)),
        backgroundColor: const Color(0xFFF7F8FA),
      ),
      onPressed: onTap,
      icon: const Icon(Icons.science_outlined, size: 18),
      label: Text(texte),
    );
  }
}
