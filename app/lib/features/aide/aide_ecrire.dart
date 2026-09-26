part of 'aide_screens.dart';

/// Sujets d'une demande au support.
const _sujets = [
  'Paiement',
  'Commande',
  'Logement',
  'Service',
  'Compte',
  'Live IA',
  'Arnaque',
  'Autre',
];

/// E-AIDE-02 — Écrire au support : sujet, message, capture ; un agent répond
/// dans « Mes demandes ».
class EcranEcrireSupport extends ConsumerStatefulWidget {
  const EcranEcrireSupport({super.key, this.sujet});
  final String? sujet;

  @override
  ConsumerState<EcranEcrireSupport> createState() => _EcranEcrireState();
}

class _EcranEcrireState extends ConsumerState<EcranEcrireSupport> {
  late var _sujet = widget.sujet;
  final _message = TextEditingController();
  var _capture = false;

  @override
  void initState() {
    super.initState();
    _message.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pret = _sujet != null && _message.text.trim().length >= 10;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.aideEcrireAuSupport)),
      body: Etroit(
        largeur: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            Text(
              context.t.aideSujet,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in _sujets)
                  ChoiceChip(
                    label: Text(_sujetAffiche(context.t, s)),
                    selected: _sujet == s,
                    onSelected: (_) => setState(() => _sujet = s),
                  ),
              ],
            ),
            if (_sujet == 'Arnaque') ...[
              const SizedBox(height: 12),
              Bloc(
                fond: LiveColors.teinteRouge,
                child: Text(context.t.aideNePayezRienEt),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _message,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: context.t.aideQueSePasseT,
                hintText: context.t.aideNumeroDeCommandeDate,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => setState(() => _capture = !_capture),
              icon: Icon(
                _capture ? Icons.check_circle_rounded : Icons.image_outlined,
              ),
              label: Text(
                _capture
                    ? context.t.aideCaptureJointe
                    : context.t.aideJoindreUneCaptureD,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.t.aideUnAgentVousRepond,
              style: TextStyle(color: LiveColors.gris),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: pret
              ? () {
                  final id = ref
                      .read(liveProvider.notifier)
                      .ecrireSupport(_sujet!, _message.text.trim());
                  informer(context, context.t.aideDemandeEnvoyee(id));
                  context.pushReplacement('/aide/demandes');
                }
              : null,
          child: Text(context.t.aideEnvoyerAuSupport),
        ),
      ),
    );
  }
}

/// E-AIDE-03 — Mes demandes au support, avec leur état.
class EcranDemandesSupport extends ConsumerWidget {
  const EcranDemandesSupport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demandes = ref.watch(liveProvider.select((e) => e.demandesSupport));
    return Scaffold(
      appBar: AppBar(title: Text(context.t.aideMesDemandes)),
      body: Etroit(
        largeur: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            for (final (id, sujet, message) in demandes)
              _CarteDemande(
                id: id,
                sujet: sujet,
                message: message,
                etat: context.t.aideRecueUnAgentVous,
                resolue: false,
              ),
            _CarteDemande(
              id: 'SP-10388',
              sujet: 'Paiement',
              message: context.t.aidePaiementMomoDebiteMais,
              etat: context.t.aideResoluePaiementConfirmePar,
              resolue: true,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push('/aide/ecrire'),
              icon: const Icon(Icons.add_rounded),
              label: Text(context.t.aideNouvelleDemande),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarteDemande extends StatelessWidget {
  const _CarteDemande({
    required this.id,
    required this.sujet,
    required this.message,
    required this.etat,
    required this.resolue,
  });
  final String id;
  final String sujet;
  final String message;
  final String etat;
  final bool resolue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Bloc(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_sujetAffiche(context.t, sujet)} · $id',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Etiquette(
                  resolue ? context.t.aideResolue : context.t.aideEnCours,
                  fond: resolue
                      ? LiveColors.teinteVerte
                      : LiveColors.teinteAmbre,
                  couleur: resolue ? LiveColors.succes : LiveColors.cuivre,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(message, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text(etat, style: const TextStyle(color: LiveColors.gris)),
          ],
        ),
      ),
    );
  }
}
