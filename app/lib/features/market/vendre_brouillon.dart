part of 'market_screens.dart';

/// Un seul brouillon de vente à la fois : on le reprend ou on le supprime.
const _idBrouillon = 'vente-produit';

/// Brouillon de l'assistant « Vendre un produit », gardé sur l'appareil par
/// la base locale (Drift, docs/26 §3 ; NF-03) : il survit à une coupure ou à
/// la fermeture de l'application.
extension _BrouillonVente on _EcranVendreState {
  Map<String, Object?> get _formulaire => {
    'etape': _etape,
    'categorie': _categorie,
    'photos': _photos,
    'video': _video,
    'titre': _titre.text,
    'description': _description.text,
    'choix': _choix,
    'etat': _etat,
    'prix': _prix.text,
    'negociable': _negociable,
    'quantite': _quantite,
    'quartier': _quartier,
  };

  Future<void> _enregistrerBrouillon({bool silencieux = false}) async {
    if (_categorie == null) return;
    final titre = _titre.text.trim();
    await ref
        .read(depotBrouillonsProvider)
        .enregistrer(
          BrouillonLocal(
            id: _idBrouillon,
            type: 'produit',
            titre: titre.isEmpty ? 'Annonce · $_categorie' : titre,
            contenu: jsonEncode(_formulaire),
            misAJour: DateTime.now(),
          ),
        );
    if (!silencieux && mounted) {
      informer(context, 'Brouillon enregistré sur ce téléphone.');
    }
  }

  void _chercherBrouillon() {
    ref.read(depotBrouillonsProvider).observer().first.then((liste) {
      final b = liste.where((x) => x.id == _idBrouillon).firstOrNull;
      if (b != null && mounted) _maj(() => _aReprendre = b);
    });
  }

  void _reprendre(BrouillonLocal b) {
    final f = jsonDecode(b.contenu) as Map<String, dynamic>;
    _maj(() {
      _aReprendre = null;
      _etape = f['etape'] as int? ?? 0;
      _categorie = f['categorie'] as String?;
      _photos = f['photos'] as int? ?? 0;
      _video = f['video'] as bool? ?? false;
      _titre.text = f['titre'] as String? ?? '';
      _description.text = f['description'] as String? ?? '';
      _choix
        ..clear()
        ..addAll((f['choix'] as Map? ?? {}).cast<String, String>());
      _etat = f['etat'] as String? ?? _etat;
      _prix.text = f['prix'] as String? ?? '';
      _negociable = f['negociable'] as bool? ?? true;
      _quantite = f['quantite'] as int? ?? 1;
      _quartier = f['quartier'] as String? ?? _quartier;
    });
  }

  Future<void> _oublierBrouillon() async {
    _maj(() => _aReprendre = null);
    await ref.read(depotBrouillonsProvider).supprimer(_idBrouillon);
  }

  /// Bandeau « Reprendre votre brouillon », en tête de l'assistant.
  Widget _bandeauBrouillon(BrouillonLocal b) {
    final h = b.misAJour;
    final quand =
        '${h.day}/${h.month} à ${h.hour} h ${h.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Bloc(
        fond: LiveColors.fondAlerte,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brouillon du $quand',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Text('« ${b.titre} »'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: () => _reprendre(b),
                  child: const Text('Reprendre le brouillon'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: _oublierBrouillon,
                  child: const Text('Recommencer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
