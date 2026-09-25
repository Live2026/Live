part of 'pay_screens.dart';

/// E-PAY-04 — Mes gains : solde disponible, en attente, historique.
class EcranGains extends ConsumerWidget {
  const EcranGains({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mes gains')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [LiveColors.bleu, LiveColors.nuit],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Disponible',
                  style: TextStyle(color: Color(0xFFD7DCE4)),
                ),
                ChiffreAnime(
                  valeur: etat.disponible,
                  format: fcfa,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'En attente : 96 000 FCFA (ventes non confirmées)',
                  style: TextStyle(color: Color(0xFFD7DCE4), fontSize: 13),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: LiveColors.nuit,
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: () => context.push('/retirer'),
                  icon: Icon(
                    etat.identiteVerifiee
                        ? Icons.north_east_rounded
                        : Icons.lock_outline_rounded,
                    size: 18,
                  ),
                  label: const Text('Retirer'),
                ),
              ],
            ),
          ),
          if (!etat.identiteVerifiee) ...[
            const SizedBox(height: 12),
            Bloc(
              fond: const Color(0xFFFFF7EA),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: LiveColors.orangeVif),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Pour retirer, débloquez le super-pouvoir « Retirer ses gains » '
                      'en vérifiant votre identité (2 minutes).',
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/verifier'),
                    child: const Text('Vérifier'),
                  ),
                ],
              ),
            ),
          ],
          const EnTeteSection('Historique'),
          for (final m in etat.historique) _LigneMouvement(m),
        ],
      ),
    );
  }
}

/// E-PAY-05 — Retirer.
class EcranRetrait extends ConsumerStatefulWidget {
  const EcranRetrait({super.key});

  @override
  ConsumerState<EcranRetrait> createState() => _EcranRetraitState();
}

class _EcranRetraitState extends ConsumerState<EcranRetrait> {
  final _montant = TextEditingController();
  var _etape = 0; // 0 saisie, 1 code, 2 fait

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final montant = int.tryParse(_montant.text.replaceAll(' ', '')) ?? 0;
    final valide = montant >= 1000 && montant <= etat.disponible;
    if (!etat.identiteVerifiee) {
      return Scaffold(
        appBar: AppBar(title: const Text('Retirer mes gains')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            const EtatVide(
              icone: Icons.lock_outline_rounded,
              texte:
                  'Retirer ses gains est un super-pouvoir. Il se débloque '
                  'quand Live a vérifié votre identité : la loi l’exige pour '
                  'protéger votre argent.',
            ),
            Text(
              'Disponible : ${fcfa(etat.disponible)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        bottomNavigationBar: BarreAction(
          child: FilledButton(
            onPressed: () => context.push('/verifier'),
            child: const Text('Vérifier mon identité'),
          ),
        ),
      );
    }
    if (_etape == 2) {
      return Scaffold(
        body: SafeArea(
          child: Etroit(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  const CocheAnimee(taille: 96),
                  Text(
                    '${fcfa(montant)} envoyés',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'sur ${etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money'} ${etat.telephone}',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vous allez recevoir un SMS de votre opérateur.',
                    style: TextStyle(color: LiveColors.gris),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => context.go('/gains'),
                    child: const Text('Retour à mes gains'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Retirer mes gains')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Disponible : ${fcfa(etat.disponible)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (_etape == 0) ...[
            TextField(
              controller: _montant,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Montant',
                suffixText: 'FCFA',
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextButton(
              onPressed: () =>
                  setState(() => _montant.text = '${etat.disponible}'),
              child: const Text('Tout retirer'),
            ),
            const SizedBox(height: 8),
            Choix(
              titre:
                  '${etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money'} · ${etat.telephone}',
              sousTitre: '${etat.prenom} (identité vérifiée)',
              icone: Icons.phone_android,
              selectionne: true,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            LigneMontant('Frais de retrait', 0),
            LigneMontant('Vous recevez', montant, gras: true),
            if (montant > etat.disponible)
              const Text(
                'Montant supérieur à vos gains disponibles.',
                style: TextStyle(color: LiveColors.erreur),
              ),
            if (montant > 0 && montant < 1000)
              const Text(
                'Minimum : 1 000 FCFA.',
                style: TextStyle(color: LiveColors.erreur),
              ),
          ] else ...[
            Text(
              'Retirer ${fcfa(montant)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Code secret de paiement', textAlign: TextAlign.center),
            ClavierPin(
              onComplet: (_) {
                if (ref.read(liveProvider.notifier).retirer(montant)) {
                  setState(() => _etape = 2);
                }
              },
            ),
          ],
        ],
      ),
      bottomNavigationBar: _etape == 0
          ? BarreAction(
              child: FilledButton(
                onPressed: valide ? () => setState(() => _etape = 1) : null,
                child: Text(valide ? 'Retirer ${fcfa(montant)}' : 'Retirer'),
              ),
            )
          : null,
    );
  }
}
