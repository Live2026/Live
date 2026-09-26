part of 'pay_screens.dart';

/// E-PAY-01 — Choisir le moyen de paiement et saisir le code de paiement.
class EcranPaiement extends ConsumerStatefulWidget {
  const EcranPaiement({super.key});

  @override
  ConsumerState<EcranPaiement> createState() => _EcranPaiementState();
}

class _EcranPaiementState extends ConsumerState<EcranPaiement> {
  String? _moyen;

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final p = etat.paiement;
    if (p == null) {
      return Scaffold(
        body: Center(child: Text(context.t.payAucunPaiementEnCours)),
      );
    }
    final operateurs = villeLive(etat.pays).operateurs;
    _moyen ??= operateurs.firstWhere(
      (o) => o.startsWith(etat.operateur),
      orElse: () => operateurs.first,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.t.payPaiement)),
      body: DeuxColonnes(
        principale: [
          Text(
            '${p.libelle} · ${p.beneficiaire}',
            style: const TextStyle(color: LiveColors.gris),
          ),
          LigneMontant(context.t.payTotalAPayer, p.montant, gras: true),
          const SizedBox(height: 16),
          Text(
            context.t.payPayerAvec,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (etat.disponible >= p.montant)
            Choix(
              titre: moyenAffiche(context.t, Moyen.solde.nom),
              sousTitre: context.t.payDisponible(fcfa(etat.disponible)),
              icone: Icons.account_balance_wallet_rounded,
              selectionne: _moyen == Moyen.solde.nom,
              onTap: () => setState(() => _moyen = Moyen.solde.nom),
            ),
          // Opérateurs Mobile Money du pays choisi (Paramètres › Pays).
          for (final o in operateurs)
            Choix(
              titre: o,
              sousTitre: o.startsWith(etat.operateur)
                  ? etat.telephone
                  : context.t.payDemandeEnvoyeeSurVotre,
              icone: Icons.phone_android,
              selectionne: _moyen == o,
              onTap: () => setState(() => _moyen = o),
            ),
          Choix(
            titre: moyenAffiche(context.t, Moyen.visa.nom),
            sousTitre: context.t.payPageSecurisee3D,
            icone: Icons.credit_card,
            selectionne: _moyen == Moyen.visa.nom,
            onTap: () => setState(() => _moyen = Moyen.visa.nom),
          ),
        ],
        secondaire: [
          const SizedBox(height: 8),
          BandeauProtection(switch (p.type) {
            TypePaiement.credits => context.t.payCreditsAjoutesDesLa,
            _ when p.modeCommande == ModePaiement.remise =>
              context.t.payPaiementDeLaCommande,
            _ => context.t.payBloquesJusqua(fcfa(p.montant)),
          }),
          const SizedBox(height: 20),
          Text(
            context.t.payCodeSecretDePaiement,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            context.t.payPrototype4ChiffresAu,
            textAlign: TextAlign.center,
            style: TextStyle(color: LiveColors.gris, fontSize: 12),
          ),
          ClavierPin(
            onComplet: (_) {
              // L'argent exige le réseau : pas de file d'envoi (docs/26 §4).
              if (horsConnexion.value) {
                informer(context, context.t.payPasDeReseauLe);
                return;
              }
              context.push('/payer/attente', extra: _moyen!);
            },
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
    final paiement = ref.read(liveProvider).paiement!;
    final type = paiement.type;
    if (widget.moyen == Moyen.solde.nom) {
      ref
          .read(liveProvider.notifier)
          .debiterSolde(paiement.montant, paiement.libelle);
    }
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
    final solde = widget.moyen == Moyen.solde.nom;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    solde
                        ? context.t.payPaiementAvecVotreSolde
                        : visa
                        ? context.t.payPageDePaiementSecurisee
                        : context.t.payValidezSurVotreTelephone,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (p != null)
                    Text(
                      '${fcfa(p.montant)} · ${moyenAffiche(context.t, widget.moyen)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  if (!visa && !solde) Text(etat.telephone),
                  const SizedBox(height: 20),
                  if (solde)
                    Text(
                      context.t.payLeMontantEstPreleve,
                      textAlign: TextAlign.center,
                    )
                  else if (!visa) ...[
                    Text(
                      context.t.payOuvrezDemande(
                        moyenAffiche(context.t, widget.moyen),
                      ),
                    ),
                    Text(context.t.payN2TapezVotreCode),
                  ] else
                    Text(
                      context.t.paySaisieDeLaCarte,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(
                    '${_secondes ~/ 60}:${(_secondes % 60).toString().padLeft(2, '0')}',
                  ),
                  BoutonEcouter(context.t.payVotreTelephoneVaAfficher),
                  const SizedBox(height: 8),
                  Text(
                    context.t.payLiveNeVousDemandera,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: LiveColors.erreur,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => _rienRecu(context),
                    child: Text(context.t.payJeNAiRien),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(context.t.annuler),
                  ),
                ],
              ),
            ),
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
        context.t.payLArgentEstBloque,
        context.t.paySuivreMaCommande,
        '/suivi/$id',
      ),
      TypePaiement.visite => (
        context.t.payLesFraisSontBloques,
        context.t.payVoirMaVisite,
        '/visite/$id',
      ),
      TypePaiement.acompte => (
        context.t.payLAcompteEstBloque,
        context.t.paySuivreLaPrestation,
        '/prestation/$id',
      ),
      TypePaiement.credits => (
        context.t.payVosCreditsLiveSont,
        context.t.payUtiliserMesCredits,
        '/ia',
      ),
      TypePaiement.reservation => (
        context.t.payLAcompteEstBloque2,
        context.t.payVoirMaReservation,
        '/visite/$id',
      ),
      TypePaiement.service => (
        context.t.payLePrestataireEstPrevenu,
        context.t.paySuivreLaPrestation,
        '/prestation/$id',
      ),
      TypePaiement.abonnement => (
        context.t.payLiveProEstActif,
        context.t.payVoirMesSuperPouvoirs,
        '/pouvoirs',
      ),
      TypePaiement.numerique => (
        context.t.payVosContenusSontDans,
        context.t.payOuvrirMesAchats,
        '/mes-achats',
      ),
      TypePaiement.fan => (
        context.t.payVousEtesFanBadge,
        context.t.payVoirLeCreateur,
        '/fans/$id',
      ),
      TypePaiement.sejour => (
        context.t.paySejourReserveLePaiement,
        context.t.payVoirMaReservation,
        '/sejours',
      ),
      TypePaiement.publicite => (
        context.t.payCampagneEnVerificationElle,
        context.t.payVoirMesCampagnes,
        '/publicite',
      ),
      TypePaiement.livePlus => (
        context.t.payLivePlusEstActif,
        context.t.payUtiliserMesCredits,
        '/ia',
      ),
      TypePaiement.cotisation => (
        context.t.payCotisationRecueLiveLa,
        context.t.payVoirLaTontine,
        '/tontine/t1',
      ),
      TypePaiement.achatGroupe => (
        context.t.payVousParticipezSiL,
        context.t.payVoirLesAchatsGroupes,
        '/achats-groupes',
      ),
      TypePaiement.facture => (
        context.t.payFactureRegleeLeRecu,
        context.t.payMesFactures,
        '/factures',
      ),
      TypePaiement.recharge => (
        context.t.payCreditEnvoyeSurLe,
        context.t.payMesFactures,
        '/factures',
      ),
      TypePaiement.pourUnProche => (
        context.t.payVotreProcheEstPrevenu,
        context.t.payMesEnvois,
        '/diaspora',
      ),
      TypePaiement.transfert => (
        context.t.payTransfertEnvoyeVotreProche,
        context.t.payMesEnvois,
        '/diaspora',
      ),
      TypePaiement.boost => (
        context.t.payVotreAnnoncePasseEn,
        context.t.payVoirMesVentes,
        '/mes-ventes',
      ),
    };
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  const CocheAnimee(taille: 96),
                  Text(
                    context.t.payPaiementReussi,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.t.payReference(
                      moyenAffiche(context.t, moyen),
                      'LV-P-2026-${id.hashCode.abs() % 100000}',
                    ),
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
                    child: Text(context.t.payVoirLeRecu),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// F-PAY-10 — « Je n'ai rien reçu » : l'opérateur n'a pas encore confirmé.
/// On peut renvoyer la demande ou changer de moyen, sans double débit.
void _rienRecu(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.payEnAttenteDeL,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(context.t.payLaDemandePeutMettre),
            const SizedBox(height: 10),
            BandeauProtection(context.t.payAucunDoubleDebitUne),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  informer(context, context.t.payNouvelleDemandeEnvoyeeA);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.t.payRenvoyerLaDemande),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pop();
                },
                child: Text(context.t.payChangerDeMoyenDe),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
