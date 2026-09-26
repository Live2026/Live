import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';
import '../../l10n/textes.dart';

part 'aide_ecrire.dart';

/// Thèmes du centre d'aide, avec leur icône.
List<(IconData, String)> _themes(Textes t) => [
  (Icons.payments_rounded, t.aidePaiements),
  (Icons.local_shipping_rounded, t.aideCommandes),
  (Icons.home_work_rounded, t.aideLogement),
  (Icons.handyman_rounded, t.aideServices),
  (Icons.verified_user_rounded, t.aideCompte),
  (Icons.auto_awesome_rounded, 'Live IA'),
];

/// Questions fréquentes : (thème, question, réponse).
List<(String, String, String)> _faq(Textes t) => [
  (t.aidePaiements, t.aideMonArgentEstIl, t.aideOuiCeQuiSe),
  (t.aidePaiements, t.aideOnMeDemandeMon, t.aideCEstUneArnaque),
  (t.aidePaiements, t.aideJAiPayeMais, t.aideLOperateurPeutMettre),
  (
    t.aidePaiements,
    t.aideCommentRetirerMesGains,
    t.aideVerifiezVotreIdentiteUne,
  ),
  (t.aideCommandes, t.aideLeProduitRecuN, t.aideNeConfirmezPasLa),
  (t.aideCommandes, t.aideLeVendeurNeRepond, t.aideSansAcceptationSous24),
  (t.aideLogement, t.aideQueSePaieEn, t.aideLoyersCautionEtPrix),
  (t.aideLogement, t.aideLAgentNEst, t.aideSignalezLAbsenceDepuis),
  (t.aideServices, t.aideLeTravailNEst, t.aideNeValidezPasLa),
  (t.aideCompte, t.aideJAiChangeDe, t.aideParametresNumeroDeTelephone),
  (t.aideCompte, t.aideMonCompteEstSuspendu, t.aideLeMotifEstDans),
  ('Live IA', t.aideMesCreditsOntEte, t.aideUnEchecEstRecredite),
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
      for (final f in _faq(context.t))
        if ((_theme == null || f.$1 == _theme) &&
            (q.isEmpty ||
                f.$2.toLowerCase().contains(q) ||
                f.$3.toLowerCase().contains(q)))
          f,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(context.t.aideCentreDAide)),
      body: Etroit(
        largeur: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            TextField(
              controller: _recherche,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: context.t.aideRechercherRemboursementRetraitVisite,
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
                  Expanded(child: Text(context.t.aideOnVousDemandeVotre)),
                  TextButton(
                    onPressed: () => context.push('/aide/ecrire?sujet=Arnaque'),
                    child: Text(context.t.aideSignaler),
                  ),
                ],
              ),
            ),
            EnTeteSection(context.t.aideThemes),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (icone, nom) in _themes(context.t))
                  FilterChip(
                    avatar: Icon(icone, size: 18),
                    label: Text(nom),
                    selected: _theme == nom,
                    onSelected: (v) => setState(() => _theme = v ? nom : null),
                  ),
              ],
            ),
            EnTeteSection(context.t.aideQuestionsFrequentes),
            if (questions.isEmpty)
              Text(
                context.t.aideAucuneReponseTrouveeEcrivez,
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
            EnTeteSection(context.t.aideBesoinDUnAgent),
            Bloc(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.support_agent_rounded, color: LiveColors.bleu),
                      SizedBox(width: 10),
                      Expanded(child: Text(context.t.aideReponseEnMoinsDe)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.push('/aide/ecrire'),
                    icon: const Icon(Icons.edit_rounded),
                    label: Text(context.t.aideEcrireAuSupport),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/aide/demandes'),
                    icon: const Icon(Icons.inbox_rounded),
                    label: Text(
                      context.t.aideMesDemandesN(demandes.length + 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            LigneMenu(
              icone: Icons.payments_outlined,
              titre: context.t.aideCeQuiSePaie,
              detail: context.t.aidePayeDansLiveA,
              onTap: () => context.push('/paiements'),
            ),
            LigneMenu(
              icone: Icons.description_outlined,
              titre: context.t.aideConditionsDUtilisation,
              onTap: () => context.push('/legal/cgu'),
            ),
            LigneMenu(
              icone: Icons.policy_outlined,
              titre: context.t.aidePolitiqueDeConfidentialite,
              onTap: () => context.push('/legal/confidentialite'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sujet d'une demande au support dans la langue choisie (la valeur
/// enregistrée reste en français).
String _sujetAffiche(Textes t, String sujet) => switch (sujet) {
  'Paiement' => t.aideSujetPaiement,
  'Commande' => t.aideSujetCommande,
  'Logement' => t.aideSujetLogement,
  'Service' => t.aideSujetService,
  'Compte' => t.aideSujetCompte,
  'Arnaque' => t.aideSujetArnaque,
  'Autre' => t.aideSujetAutre,
  _ => sujet,
};
