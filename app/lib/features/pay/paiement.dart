part of 'pay_screens.dart';

/// E-PAY-01 — Choisir le moyen de paiement et saisir le code de paiement.
class EcranPaiement extends ConsumerStatefulWidget {
  const EcranPaiement({super.key});

  @override
  ConsumerState<EcranPaiement> createState() => _EcranPaiementState();
}

class _EcranPaiementState extends ConsumerState<EcranPaiement> {
  Moyen? _moyen;

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final p = etat.paiement;
    if (p == null) {
      return const Scaffold(
        body: Center(child: Text('Aucun paiement en cours.')),
      );
    }
    _moyen ??= etat.operateur == 'Airtel' ? Moyen.airtel : Moyen.mtn;
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: DeuxColonnes(
        principale: [
          Text(
            '${p.libelle} · ${p.beneficiaire}',
            style: const TextStyle(color: LiveColors.gris),
          ),
          LigneMontant('Total à payer', p.montant, gras: true),
          const SizedBox(height: 16),
          const Text(
            'Payer avec',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Choix(
            titre: Moyen.mtn.nom,
            sousTitre: etat.operateur == 'MTN' ? etat.telephone : null,
            icone: Icons.phone_android,
            selectionne: _moyen == Moyen.mtn,
            onTap: () => setState(() => _moyen = Moyen.mtn),
          ),
          Choix(
            titre: Moyen.airtel.nom,
            sousTitre: etat.operateur == 'Airtel' ? etat.telephone : null,
            icone: Icons.phone_android,
            selectionne: _moyen == Moyen.airtel,
            onTap: () => setState(() => _moyen = Moyen.airtel),
          ),
          Choix(
            titre: Moyen.visa.nom,
            sousTitre: 'Page sécurisée 3-D Secure',
            icone: Icons.credit_card,
            selectionne: _moyen == Moyen.visa,
            onTap: () => setState(() => _moyen = Moyen.visa),
          ),
        ],
        secondaire: [
          const SizedBox(height: 8),
          BandeauProtection(switch (p.type) {
            TypePaiement.credits =>
              'Crédits ajoutés dès la confirmation du paiement.',
            _ when p.modeCommande == ModePaiement.remise =>
              'Paiement de la commande que vous avez en main.',
            _ =>
              "${fcfa(p.montant)} bloqués jusqu'à votre confirmation. Remboursés sinon.",
          }),
          const SizedBox(height: 20),
          const Text(
            'Code secret de paiement',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            '(prototype : 4 chiffres au choix)',
            textAlign: TextAlign.center,
            style: TextStyle(color: LiveColors.gris, fontSize: 12),
          ),
          ClavierPin(
            onComplet: (_) =>
                context.push('/payer/attente', extra: _moyen!.nom),
          ),
        ],
      ),
    );
  }
}

/// E-PAY-02 — Attente de la validation sur le téléphone.
class EcranAttente extends ConsumerStatefulWidget {
  const EcranAttente({super.key, required this.moyen});
  final String moyen;

  @override
  ConsumerState<EcranAttente> createState() => _EcranAttenteState();
}

class _EcranAttenteState extends ConsumerState<EcranAttente> {
  var _secondes = 180;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _secondes--),
    );
    // Le prototype simule la validation par le client au bout de 4 secondes.
    Future<void>.delayed(const Duration(seconds: 4), _valide);
  }

  void _valide() {
    if (!mounted) return;
    final type = ref.read(liveProvider).paiement!.type;
    final id = ref.read(liveProvider.notifier).paiementReussi();
    context.go('/payer/ok', extra: (type, id, widget.moyen));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final p = etat.paiement;
    final visa = widget.moyen.contains('Visa');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                visa
                    ? 'Page de paiement sécurisée'
                    : 'Validez sur votre téléphone',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (p != null)
                Text(
                  '${fcfa(p.montant)} · ${widget.moyen}',
                  style: const TextStyle(fontSize: 18),
                ),
              if (!visa) Text(etat.telephone),
              const SizedBox(height: 20),
              if (!visa) ...[
                const Text('1. Ouvrez la demande MoMo ou Airtel'),
                const Text('2. Tapez votre code secret Mobile Money'),
              ] else
                const Text(
                  'Saisie de la carte chez le prestataire de paiement.\nLive ne voit jamais votre carte.',
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                '${_secondes ~/ 60}:${(_secondes % 60).toString().padLeft(2, '0')}',
              ),
              const BoutonEcouter(
                "Votre téléphone va afficher une demande de paiement de votre opérateur. Tapez votre code secret Mobile Money sur cette demande, pas dans Live. Live ne vous demandera jamais ce code.",
              ),
              const SizedBox(height: 8),
              const Text(
                'Live ne vous demandera JAMAIS votre code secret MoMo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: LiveColors.erreur,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {},
                child: const Text("Je n'ai rien reçu"),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-PAY-03 — Paiement réussi.
class EcranPaiementReussi extends StatelessWidget {
  const EcranPaiementReussi({
    super.key,
    required this.type,
    required this.id,
    required this.moyen,
  });
  final TypePaiement type;
  final String id;
  final String moyen;

  @override
  Widget build(BuildContext context) {
    final (message, bouton, route) = switch (type) {
      TypePaiement.commande => (
        "L'argent est bloqué par Live jusqu'à ce que vous confirmiez la réception.",
        'Suivre ma commande',
        '/suivi/$id',
      ),
      TypePaiement.visite => (
        "Les frais sont bloqués jusqu'à la visite. L'adresse exacte est maintenant visible.",
        'Voir ma visite',
        '/visite/$id',
      ),
      TypePaiement.acompte => (
        "L'acompte est bloqué. La part matériel sera versée au démarrage des travaux.",
        'Suivre la prestation',
        '/prestation/$id',
      ),
      TypePaiement.credits => (
        'Vos Crédits Live sont disponibles immédiatement.',
        'Utiliser mes crédits',
        '/ia',
      ),
      TypePaiement.reservation => (
        "L'acompte est bloqué par Live jusqu'à la signature du bail et la remise des clés.",
        'Voir ma réservation',
        '/visite/$id',
      ),
      TypePaiement.service => (
        'Le prestataire est prévenu. Il est payé quand vous confirmez la fin du service.',
        'Suivre la prestation',
        '/prestation/$id',
      ),
      TypePaiement.abonnement => (
        'Live Pro est actif : statistiques détaillées et boosts à −30 %.',
        'Voir mes super-pouvoirs',
        '/pouvoirs',
      ),
    };
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CocheAnimee(taille: 96),
              const Text(
                'Paiement réussi',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$moyen · Réf. LV-P-2026-${id.hashCode.abs() % 100000}',
                style: const TextStyle(color: LiveColors.gris),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(route),
                child: Text(bouton),
              ),
              TextButton(
                onPressed: () => context.push('/recu/$id'),
                child: const Text('Voir le reçu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
