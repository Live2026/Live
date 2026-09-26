part of 'compte_screens.dart';

/// E-MOI-03 — Vérifier mon identité en 3 étapes (passage au niveau N2).
class EcranVerifier extends ConsumerStatefulWidget {
  const EcranVerifier({super.key});

  @override
  ConsumerState<EcranVerifier> createState() => _EcranVerifierState();
}

class _EcranVerifierState extends ConsumerState<EcranVerifier> {
  var _etape = 0; // 0 pièce, 1 selfie, 2 nom MoMo, 3 en cours, 4 validée
  var _piece = 'CNI';
  var _recto = false;
  var _verso = false;
  var _selfie = false;

  bool get _peutContinuer => switch (_etape) {
    0 => _recto && (_verso || _piece == 'Passeport'),
    1 => _selfie,
    _ => true,
  };

  void _suivant() {
    if (_etape == 2) {
      setState(() => _etape = 3);
      Future<void>.delayed(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        ref.read(liveProvider.notifier).verifierIdentite();
        setState(() => _etape = 4);
      });
    } else {
      setState(() => _etape++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    if (_etape >= 3) return _resultat(context);
    return Scaffold(
      appBar: AppBar(title: Text('Vérifier mon identité · ${_etape + 1}/3')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LinearProgressIndicator(
            value: (_etape + 1) / 3,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 20),
          ...switch (_etape) {
            0 => [
              const _Titre(
                'Votre pièce d’identité',
                'CNI congolaise ou passeport, en cours de validité.',
              ),
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 'CNI', label: Text('CNI')),
                  ButtonSegment(value: 'Passeport', label: Text('Passeport')),
                ],
                selected: {_piece},
                onSelectionChanged: (s) => setState(() => _piece = s.first),
              ),
              const SizedBox(height: 16),
              _Capture(
                libelle: _piece == 'CNI'
                    ? 'Photo du recto'
                    : 'Page avec la photo',
                faite: _recto,
                icone: Icons.badge_outlined,
                onTap: () => setState(() => _recto = true),
              ),
              if (_piece == 'CNI') ...[
                const SizedBox(height: 10),
                _Capture(
                  libelle: 'Photo du verso',
                  faite: _verso,
                  icone: Icons.flip_outlined,
                  onTap: () => setState(() => _verso = true),
                ),
              ],
            ],
            1 => [
              const _Titre(
                'Un selfie',
                'Pour vérifier que la pièce est bien la vôtre. Retirez lunettes et chapeau.',
              ),
              Center(
                child: Pressable(
                  onTap: () => setState(() => _selfie = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 200,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(100, 125),
                      ),
                      border: Border.all(
                        color: _selfie ? LiveColors.succes : LiveColors.surface,
                        width: 4,
                      ),
                    ),
                    child: Icon(
                      _selfie
                          ? Icons.check_rounded
                          : Icons.face_retouching_natural,
                      size: 72,
                      color: _selfie ? LiveColors.succes : Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _selfie = true),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(_selfie ? 'Selfie pris' : 'Prendre le selfie'),
                ),
              ),
            ],
            _ => [
              const _Titre(
                'Votre compte Mobile Money',
                'Le nom du titulaire doit être le même que sur votre pièce.',
              ),
              Bloc(
                child: Column(
                  children: [
                    LigneMenu(
                      icone: Icons.phone_android,
                      titre:
                          '${etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money'} · ${etat.telephone}',
                      detail:
                          'Nom chez l’opérateur : MABIALA ${etat.prenom.toUpperCase()}',
                    ),
                    const LigneMenu(
                      icone: Icons.badge_outlined,
                      titre: 'Nom sur la pièce',
                      detail: 'MABIALA GRÂCE',
                      couleur: LiveColors.succes,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const BandeauProtection(
                'Vos documents sont chiffrés et vus uniquement par l’équipe de vérification.',
              ),
            ],
          },
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _peutContinuer ? _suivant : null,
          child: Text(_etape == 2 ? 'Envoyer pour vérification' : 'Continuer'),
        ),
      ),
    );
  }

  Widget _resultat(BuildContext context) {
    final valide = _etape == 4;
    final debloques = pouvoirs.where((p) => p.condition == Condition.identite);
    return Scaffold(
      body: SafeArea(
        child: Etroit(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                if (valide)
                  const CocheAnimee(taille: 96)
                else
                  const SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(strokeWidth: 5),
                  ),
                const SizedBox(height: 16),
                Text(
                  valide ? 'Identité vérifiée' : 'Vérification en cours…',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  valide ? 'Nouveaux super-pouvoirs débloqués :' : 'En général moins de 10 minutes. Vous pouvez continuer à utiliser Live.',
                  textAlign: TextAlign.center,
                ),
                if (valide) ...[
                  const SizedBox(height: 12),
                  for (final p in debloques)
                    Apparition(
                      child: ListTile(
                        leading: Icon(p.icone, color: LiveColors.bleu),
                        title: Text(
                          p.titre,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(p.gain),
                      ),
                    ),
                ],
                const Spacer(),
                if (valide)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.pop(),
                      child: const Text('Continuer'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.titre, this.detail);
  final String titre;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(detail, style: const TextStyle(color: LiveColors.gris)),
        ],
      ),
    );
  }
}

/// Zone de prise de photo (simulée) d'un document.
class _Capture extends StatelessWidget {
  const _Capture({
    required this.libelle,
    required this.faite,
    required this.icone,
    required this.onTap,
  });
  final String libelle;
  final bool faite;
  final IconData icone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: libelle,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 120,
          decoration: BoxDecoration(
            color: faite ? LiveColors.teinteVerte : LiveColors.champ,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: faite ? LiveColors.succes : LiveColors.bord,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                faite ? Icons.check_circle_rounded : icone,
                size: 36,
                color: faite ? LiveColors.succes : LiveColors.bleu,
              ),
              const SizedBox(height: 6),
              Text(
                faite ? '$libelle : prise' : libelle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
