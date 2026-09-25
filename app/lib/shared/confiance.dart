import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/theme.dart';

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
