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
    titre: 'Vérification requise',
    raison:
        '« Publier une opportunité » est un super-pouvoir. Il se débloque '
        'quand Live a vérifié votre identité : c’est ce qui protège les '
        'candidats des fausses offres.',
    route: '/verifier',
    action: 'Vérifier mon identité',
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
      appBar: AppBar(
        title: const Text('Opportunités'),
        actions: [
          IconButton(
            tooltip: 'Rechercher',
            onPressed: () => context.push('/recherche'),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Mes candidatures',
            onPressed: () => context.push('/mes-candidatures'),
            icon: const Icon(Icons.work_history_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => publierOpportunite(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Publier'),
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
                    label: Text('Toutes (${opportunites.length})'),
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
              fond: const Color(0xFFE7F4EC),
              padding: 12,
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: LiveColors.succes),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Postuler sur Live est toujours gratuit. Les frais '
                      'officiels éventuels sont affichés avant de postuler.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              _type == null ? 'À ne pas manquer' : _type!.libelle,
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
            child: const EnTeteSection('Préparer sa candidature'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: Column(
              children: [
                LigneMenu(
                  icone: Icons.description_outlined,
                  titre: 'Faire mon CV avec Live IA',
                  detail: 'Prêt en 1 minute, au format des recruteurs',
                  onTap: () => context.push('/ia/service/cv'),
                ),
                LigneMenu(
                  icone: Icons.quiz_outlined,
                  titre: 'S’entraîner aux concours',
                  detail: '1 200 QCM corrigés et chronométrés',
                  onTap: () => context.push('/contenu/n6'),
                ),
                LigneMenu(
                  icone: Icons.notifications_active_outlined,
                  titre: 'Créer une alerte',
                  detail: 'Être prévenu des nouvelles bourses et stages',
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
