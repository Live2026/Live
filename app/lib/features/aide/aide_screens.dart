import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

part 'aide_ecrire.dart';

/// Thèmes du centre d'aide, avec leur icône.
const _themes = [
  (Icons.payments_rounded, 'Paiements'),
  (Icons.local_shipping_rounded, 'Commandes'),
  (Icons.home_work_rounded, 'Logement'),
  (Icons.handyman_rounded, 'Services'),
  (Icons.verified_user_rounded, 'Compte'),
  (Icons.auto_awesome_rounded, 'Live IA'),
];

/// Questions fréquentes : (thème, question, réponse).
const _faq = [
  (
    'Paiements',
    'Mon argent est-il protégé ?',
    'Oui. Ce qui se paie « dans Live » reste bloqué jusqu’à votre '
        'confirmation (QR, « J’ai reçu », fin du service). Sans confirmation, '
        'vous êtes remboursé.',
  ),
  (
    'Paiements',
    'On me demande mon code MoMo',
    'C’est une arnaque. Live ne demande jamais votre code secret Mobile '
        'Money, ni par message ni par appel. Signalez le message.',
  ),
  (
    'Paiements',
    'J’ai payé mais rien ne s’affiche',
    'L’opérateur peut mettre jusqu’à 3 minutes à confirmer. Vous n’êtes '
        'jamais débité deux fois ; sans confirmation, l’argent revient seul.',
  ),
  (
    'Paiements',
    'Comment retirer mes gains ?',
    'Vérifiez votre identité une fois, puis Moi › Mon argent › Retirer, vers '
        'votre numéro Mobile Money, sans frais.',
  ),
  (
    'Commandes',
    'Le produit reçu n’est pas conforme',
    'Ne confirmez pas la réception. Ouvrez « Signaler un problème » sur la '
        'commande : l’argent reste bloqué pendant l’examen.',
  ),
  (
    'Commandes',
    'Le vendeur ne répond pas',
    'Sans acceptation sous 24 heures, la commande est annulée et vous êtes '
        'remboursé automatiquement.',
  ),
  (
    'Logement',
    'Que se paie en dehors de Live ?',
    'Loyers, caution et prix d’un bien se paient en direct, contre reçu. '
        'Les frais de visite et l’acompte de réservation passent par Live.',
  ),
  (
    'Logement',
    'L’agent n’est pas venu à la visite',
    'Signalez l’absence depuis la visite : vos frais sont remboursés en '
        'totalité.',
  ),
  (
    'Services',
    'Le travail n’est pas terminé',
    'Ne validez pas la fin des travaux. Signalez le problème : la part '
        'restante reste bloquée.',
  ),
  (
    'Compte',
    'J’ai changé de numéro',
    'Paramètres › Numéro de téléphone : un code est envoyé au nouveau '
        'numéro, puis l’ancien est désactivé.',
  ),
  (
    'Compte',
    'Mon compte est suspendu',
    'Le motif est dans vos notifications. Répondez depuis « Écrire au '
        'support » : un agent réexamine sous 24 heures.',
  ),
  (
    'Live IA',
    'Mes crédits ont été débités sans résultat',
    'Un échec est recrédité automatiquement. Sinon, écrivez au support avec '
        'le nom du service.',
  ),
];

/// E-AIDE-01 — Centre d'aide : recherche, thèmes, questions fréquentes,
/// écrire au support, suivi des demandes.
class EcranAide extends ConsumerStatefulWidget {
  const EcranAide({super.key});

  @override
  ConsumerState<EcranAide> createState() => _EcranAideState();
}

class _EcranAideState extends ConsumerState<EcranAide> {
  final _recherche = TextEditingController();
  String? _theme;

  @override
  void dispose() {
    _recherche.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demandes = ref.watch(liveProvider.select((e) => e.demandesSupport));
    final q = _recherche.text.trim().toLowerCase();
    final questions = [
      for (final f in _faq)
        if ((_theme == null || f.$1 == _theme) &&
            (q.isEmpty ||
                f.$2.toLowerCase().contains(q) ||
                f.$3.toLowerCase().contains(q)))
          f,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Centre d’aide')),
      body: Etroit(
        largeur: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            TextField(
              controller: _recherche,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Rechercher : remboursement, retrait, visite…',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            Bloc(
              fond: LiveColors.teinteRouge,
              child: Row(
                children: [
                  const Icon(
                    Icons.report_gmailerrorred_rounded,
                    color: LiveColors.erreur,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'On vous demande votre code MoMo ou de payer hors de '
                      'Live ? C’est une arnaque.',
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/aide/ecrire?sujet=Arnaque'),
                    child: const Text('Signaler'),
                  ),
                ],
              ),
            ),
            const EnTeteSection('Thèmes'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (icone, nom) in _themes)
                  FilterChip(
                    avatar: Icon(icone, size: 18),
                    label: Text(nom),
                    selected: _theme == nom,
                    onSelected: (v) => setState(() => _theme = v ? nom : null),
                  ),
              ],
            ),
            const EnTeteSection('Questions fréquentes'),
            if (questions.isEmpty)
              const Text(
                'Aucune réponse trouvée : écrivez-nous, un agent vous répond.',
                style: TextStyle(color: LiveColors.gris),
              ),
            for (final (_, question, reponse) in questions)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  question,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(reponse, style: const TextStyle(height: 1.4)),
                    ),
                  ),
                ],
              ),
            const EnTeteSection('Besoin d’un agent ?'),
            Bloc(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.support_agent_rounded, color: LiveColors.bleu),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Réponse en moins de 2 heures, 7 jours sur 7, de 7 h '
                          'à 22 h. En français, lingala ou kituba.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.push('/aide/ecrire'),
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Écrire au support'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/aide/demandes'),
                    icon: const Icon(Icons.inbox_rounded),
                    label: Text('Mes demandes (${demandes.length + 1})'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            LigneMenu(
              icone: Icons.payments_outlined,
              titre: 'Ce qui se paie dans Live',
              detail: 'Payé dans Live, à la remise ou en direct',
              onTap: () => context.push('/paiements'),
            ),
            LigneMenu(
              icone: Icons.description_outlined,
              titre: 'Conditions d’utilisation',
              onTap: () => context.push('/legal/cgu'),
            ),
            LigneMenu(
              icone: Icons.policy_outlined,
              titre: 'Politique de confidentialité',
              onTap: () => context.push('/legal/confidentialite'),
            ),
          ],
        ),
      ),
    );
  }
}
