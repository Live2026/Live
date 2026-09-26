import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';
import '../../l10n/textes.dart';

part 'opportunite_fiche.dart';
part 'postuler.dart';
part 'publier_opportunite.dart';

/// Ouvre l'assistant de publication, ou explique le super-pouvoir manquant.
void publierOpportunite(BuildContext context, WidgetRef ref) {
  if (ref.read(liveProvider).identiteVerifiee) {
    context.push('/publier/opportunite');
    return;
  }
  pouvoirRequis(
    context,
    titre: context.t.opportunitesVerificationRequise,
    raison: context.t.opportunitesPublierUneOpportuniteEst,
    route: '/verifier',
    action: context.t.opportunitesVerifierMonIdentite,
  );
}

/// E-OPP-01 — Opportunités : bourses, concours, stages, emplois et
/// formations d'organisations vérifiées. Postuler est toujours gratuit.
class EcranOpportunites extends ConsumerStatefulWidget {
  const EcranOpportunites({super.key});

  @override
  ConsumerState<EcranOpportunites> createState() => _EcranOpportunitesState();
}

class _EcranOpportunitesState extends ConsumerState<EcranOpportunites> {
  TypeOpportunite? _type;

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final liste = opportunites
        .where((o) => _type == null || o.type == _type)
        .toList();
    return Scaffold(
      appBar: EnTeteRecherche(
        titre: Text(context.t.opportunitesOpportunites),
        indice: context.t.opportunitesRechercherUneBourseUn,
        onSubmitted: (q) => context.push('/recherche', extra: q),
        actions: [
          IconButton(
            tooltip: context.t.opportunitesMesCandidatures,
            onPressed: () => context.push('/mes-candidatures'),
            icon: const Icon(Icons.work_history_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => publierOpportunite(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.t.opportunitesPublier),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      context.t.opportunitesToutesN(opportunites.length),
                    ),
                    selected: _type == null,
                    onSelected: (_) => setState(() => _type = null),
                  ),
                ),
                for (final t in TypeOpportunite.values.where(
                  (t) => opportunites.any((o) => o.type == t),
                ))
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(t.icone, size: 18),
                      label: Text(t.libelle),
                      selected: _type == t,
                      onSelected: (_) =>
                          setState(() => _type = _type == t ? null : t),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
            child: Bloc(
              fond: LiveColors.teinteVerte,
              padding: 12,
              child: Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: LiveColors.succes),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(context.t.opportunitesPostulerSurLiveEst),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              _type == null
                  ? context.t.opportunitesANePasManquer
                  : _type!.libelle,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 460,
              espacement: 12,
              hauteur: 168,
              enfants: [
                for (final (i, o) in liste.indexed)
                  Apparition(
                    rang: i,
                    child: CarteOpportunite(opportunite: o),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(context.t.opportunitesPreparerSaCandidature),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: Column(
              children: [
                LigneMenu(
                  icone: Icons.description_outlined,
                  titre: context.t.opportunitesFaireMonCvAvec,
                  detail: context.t.opportunitesPretEn1Minute,
                  onTap: () => context.push('/ia/service/cv'),
                ),
                LigneMenu(
                  icone: Icons.quiz_outlined,
                  titre: context.t.opportunitesSEntrainerAuxConcours,
                  detail: context.t.opportunitesN1200QcmCorriges,
                  onTap: () => context.push('/contenu/n6'),
                ),
                LigneMenu(
                  icone: Icons.notifications_active_outlined,
                  titre: context.t.opportunitesCreerUneAlerte,
                  detail: context.t.opportunitesEtrePrevenuDesNouvelles,
                  onTap: () => context.push('/alertes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
