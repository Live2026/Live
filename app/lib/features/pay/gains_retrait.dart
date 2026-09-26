part of 'pay_screens.dart';

/// E-PAY-04 — Mes gains : solde disponible, en attente, historique.
class EcranGains extends ConsumerWidget {
  const EcranGains({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.payMesGains)),
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
                Text(
                  context.t.payDisponible2,
                  style: TextStyle(color: LiveColors.brumeClaire),
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
                Text(
                  context.t.payEnAttente96000,
                  style: TextStyle(color: LiveColors.brumeClaire, fontSize: 13),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: LiveColors.surface,
                    foregroundColor: LiveColors.encre,
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: () => context.push('/retirer'),
                  icon: Icon(
                    etat.identiteVerifiee
                        ? Icons.north_east_rounded
                        : Icons.lock_outline_rounded,
                    size: 18,
                  ),
                  label: Text(context.t.payRetirer),
                ),
              ],
            ),
          ),
          if (!etat.identiteVerifiee) ...[
            const SizedBox(height: 12),
            Bloc(
              fond: LiveColors.teinteCreme,
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: LiveColors.orangeVif),
                  const SizedBox(width: 10),
                  Expanded(child: Text(context.t.payPourRetirerDebloquezLe)),
                  TextButton(
                    onPressed: () => context.push('/verifier'),
                    child: Text(context.t.payVerifier),
                  ),
                ],
              ),
            ),
          ],
          EnTeteSection(context.t.payHistorique),
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
        appBar: AppBar(title: Text(context.t.payRetirerMesGains)),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            EtatVide(
              icone: Icons.lock_outline_rounded,
              texte: context.t.payRetirerSesGainsEst,
            ),
            Text(
              context.t.payDisponible(fcfa(etat.disponible)),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        bottomNavigationBar: BarreAction(
          child: FilledButton(
            onPressed: () => context.push('/verifier'),
            child: Text(context.t.payVerifierMonIdentite),
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
                    context.t.payEnvoyes(fcfa(montant)),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    context.t.paySurNumero(
                      etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money',
                      etat.telephone,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.t.payVousAllezRecevoirUn,
                    style: TextStyle(color: LiveColors.gris),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => context.go('/gains'),
                    child: Text(context.t.payRetourAMesGains),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(context.t.payRetirerMesGains)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.payDisponible(fcfa(etat.disponible)),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (_etape == 0) ...[
            TextField(
              controller: _montant,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.t.payMontant,
                suffixText: 'FCFA',
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextButton(
              onPressed: () =>
                  setState(() => _montant.text = '${etat.disponible}'),
              child: Text(context.t.payToutRetirer),
            ),
            const SizedBox(height: 8),
            Choix(
              titre: context.t.payOperateurTel(
                etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money',
                etat.telephone,
              ),
              sousTitre: context.t.payIdentiteVerifieeDe(etat.prenom),
              icone: Icons.phone_android,
              selectionne: true,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            LigneMontant(context.t.payFraisDeRetrait, 0),
            LigneMontant(context.t.payVousRecevez, montant, gras: true),
            if (montant > etat.disponible)
              Text(
                context.t.payMontantSuperieurAVos,
                style: TextStyle(color: LiveColors.erreur),
              ),
            if (montant > 0 && montant < 1000)
              Text(
                context.t.payMinimum1000Fcfa,
                style: TextStyle(color: LiveColors.erreur),
              ),
          ] else ...[
            Text(
              context.t.payRetirerMontant(fcfa(montant)),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              context.t.payCodeSecretDePaiement,
              textAlign: TextAlign.center,
            ),
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
                child: Text(
                  valide
                      ? context.t.payRetirerMontant(fcfa(montant))
                      : context.t.payRetirer,
                ),
              ),
            )
          : null,
    );
  }
}
