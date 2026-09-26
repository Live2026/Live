part of 'ia_screens.dart';

/// E-IA-01 — Accueil Live IA.
class EcranIa extends ConsumerWidget {
  const EcranIa({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final familles = <String>[];
    for (final s in servicesIa(context.t)) {
      if (!familles.contains(s.famille)) familles.add(s.famille);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live IA'),
        actions: const [BoutonNotifications(), BoutonMessages()],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: context.grandEcran ? 24 : 16,
          vertical: 8,
        ),
        children: [
          Apparition(
            child: Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [LiveColors.orangeVif, Color(0xFFDB2777)],
                  ),
                ),
                child: InkWell(
                  onTap: () => context.push('/ia/assistant'),
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Icon(
                          Icons.record_voice_over_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.iaAssistantLive,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                context.t.iaIlChercheReservePaie,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Carte « Mes crédits » : dégradé bleu, façon carte de portefeuille.
          Apparition(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [LiveColors.bleu, LiveColors.nuit],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33041936),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 16,
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.iaMesCreditsLive,
                        style: TextStyle(color: Color(0xCCFFFFFF)),
                      ),
                      const SizedBox(height: 4),
                      Credits(
                        etat.credits,
                        taille: 34,
                        couleur: Colors.white,
                        couleurIcone: LiveColors.orange,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.t.iaN1Credit10Fcfa,
                        style: TextStyle(
                          color: Color(0x99FFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: LiveColors.surface,
                      foregroundColor: LiveColors.bleu,
                    ),
                    onPressed: () => context.push('/ia/credits'),
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(context.t.iaAcheterDesCredits),
                  ),
                ],
              ),
            ),
          ),
          for (final f in familles) ...[
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 8),
              child: Text(
                f.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: LiveColors.gris,
                ),
              ),
            ),
            GrilleAdaptative(
              largeurMax: 380,
              hauteur: 84,
              enfants: [
                for (final s in servicesIa(
                  context.t,
                ).where((s) => s.famille == f))
                  _CarteService(service: s),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(context.t.iaMesDocuments),
              trailing: Text('${etat.documents.length}'),
              onTap: () => context.push('/ia/documents'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CarteService extends StatelessWidget {
  const _CarteService({required this.service});
  final ServiceIa service;

  @override
  Widget build(BuildContext context) {
    final s = service;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!s.disponible) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  s.famille == context.t.iaBientot
                      ? context.t.iaBientotDispo(s.titre)
                      : context.t.iaNonInclus(s.titre),
                ),
              ),
            );
            return;
          }
          context.push(s.route ?? '/ia/service/${s.id}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: LiveColors.fondProtection,
                child: Icon(s.icone, color: LiveColors.bleu),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.titre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      s.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
              ),
              Credits(
                s.prix,
                suffixe: s.unite,
                couleur: s.disponible ? null : LiveColors.gris,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-IA-02 — Acheter des crédits.
class EcranCredits extends ConsumerStatefulWidget {
  const EcranCredits({super.key});

  @override
  ConsumerState<EcranCredits> createState() => _EcranCreditsState();
}

class _EcranCreditsState extends ConsumerState<EcranCredits> {
  var _pack = packs.first;

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final bouton = FilledButton(
      onPressed: () {
        ref
            .read(liveProvider.notifier)
            .preparerPaiement(
              PaiementEnCours(
                type: TypePaiement.credits,
                montant: _pack.prix,
                libelle: context.t.iaNCreditsLive(_pack.credits),
                beneficiaire: 'Live',
                cibleId: _pack.id,
              ),
            );
        context.push('/payer');
      },
      child: Text(context.t.iaPayerMontant(fcfa(_pack.prix))),
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.t.iaAcheterDesCredits)),
      body: DeuxColonnes(
        principale: [
          Row(
            children: [Text(context.t.iaVotreSoldeDeux), Credits(etat.credits)],
          ),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 320,
            enfants: [
              for (final p in packs)
                _CartePack(
                  pack: p,
                  selectionne: _pack == p,
                  onTap: () => setState(() => _pack = p),
                ),
            ],
          ),
        ],
        secondaire: [
          Text(
            context.t.iaExemples,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(context.t.iaN1Cv20Credits),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.t.iaOffrirDesCreditsNon)),
            ),
            icon: const Icon(Icons.card_giftcard),
            label: Text(context.t.iaOffrirDesCreditsA),
          ),
          const SizedBox(height: 12),
          Text(
            context.t.iaCreditsValables12Mois,
            style: TextStyle(color: LiveColors.gris),
          ),
          if (context.grandEcran) ...[const SizedBox(height: 16), bouton],
        ],
      ),
      bottomNavigationBar: context.grandEcran
          ? null
          : BarreAction(child: bouton),
    );
  }
}

/// Un pack de crédits : nombre de crédits en grand, prix et bonus dessous.
class _CartePack extends StatelessWidget {
  const _CartePack({
    required this.pack,
    required this.selectionne,
    required this.onTap,
  });
  final Pack pack;
  final bool selectionne;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selectionne,
      label: context.t.iaCreditsPour(pack.credits, fcfa(pack.prix)),
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: courbeDouce,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selectionne ? LiveColors.voile : LiveColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectionne ? LiveColors.bleu : LiveColors.brume,
              width: selectionne ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Credits(pack.credits, taille: 22),
                    ),
                  ),
                  if (selectionne)
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: LiveColors.bleu,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                fcfa(pack.prix),
                style: const TextStyle(color: LiveColors.gris),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: pack.bonus == null
                      ? Colors.transparent
                      : LiveColors.succes.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pack.bonus == null
                      ? context.t.iaPackDeBase
                      : context.t.iaBonus('${pack.bonus}'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: pack.bonus == null
                        ? LiveColors.gris
                        : LiveColors.succes,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-IA-03 — Confirmation du prix avant la génération. Renvoie vrai si les crédits ont été débités.
Future<bool> confirmerPrix(
  BuildContext context,
  WidgetRef ref,
  String titre,
  int prix,
) async {
  final solde = ref.read(liveProvider).credits;
  final suffisant = solde >= prix;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titre),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Ligne(context.t.iaCeServiceCoute, prix),
          _Ligne(context.t.iaVotreSolde, solde),
          if (suffisant) _Ligne(context.t.iaApres, solde - prix),
          const SizedBox(height: 12),
          Text(
            suffisant
                ? context.t.iaUneRevisionGratuiteIncluse
                : context.t.iaSoldeInsuffisant(prix - solde),
            style: TextStyle(
              color: suffisant ? LiveColors.gris : LiveColors.erreur,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(context.t.annuler),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(140, 44)),
          onPressed: () {
            Navigator.pop(ctx, suffisant);
            if (!suffisant) context.push('/ia/credits');
          },
          child: Text(
            suffisant ? context.t.iaGenerer : context.t.iaAcheterDesCredits,
          ),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  return ref.read(liveProvider.notifier).depenserCredits(prix);
}

class _Ligne extends StatelessWidget {
  const _Ligne(this.libelle, this.n);
  final String libelle;
  final int n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(libelle)),
          Credits(n, couleur: LiveColors.encre),
        ],
      ),
    );
  }
}
