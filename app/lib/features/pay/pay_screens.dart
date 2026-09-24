import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

enum Moyen { mtn, airtel, visa }

extension on Moyen {
  String get nom => switch (this) {
    Moyen.mtn => 'MTN Mobile Money',
    Moyen.airtel => 'Airtel Money',
    Moyen.visa => 'Carte Visa',
  };
}

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
            ],
          ),
        ),
      ),
    );
  }
}

/// E-PAY-04 — Mes gains.
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
          const Text(
            'Disponible',
            textAlign: TextAlign.center,
            style: TextStyle(color: LiveColors.gris),
          ),
          Center(
            child: ChiffreAnime(
              valeur: etat.disponible,
              format: fcfa,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.push('/retirer'),
            child: const Text('Retirer'),
          ),
          const SizedBox(height: 16),
          const LigneMontant('En attente (ventes non confirmées)', 96000),
          const Divider(height: 28),
          const Text(
            'Historique',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          for (final m in etat.historique)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                m.montant >= 0 ? Icons.south_west : Icons.north_east,
                color: m.montant >= 0 ? LiveColors.bleu : LiveColors.erreur,
              ),
              title: Text(m.libelle),
              subtitle: Text(m.quand),
              trailing: Text(
                '${m.montant >= 0 ? '+' : ''}${fcfa(m.montant)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: m.montant >= 0 ? LiveColors.bleu : Colors.black,
                ),
              ),
            ),
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
    if (_etape == 2) {
      return Scaffold(
        body: SafeArea(
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
