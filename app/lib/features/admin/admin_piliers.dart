part of 'admin_screens.dart';

/// E-ADM-11 — Argent et quotidien : supervision des piliers (docs/21).
/// Transferts par devise et partenaire agréé, tontines, achats groupés,
/// factures et points relais.
class _ArgentQuotidien extends StatelessWidget {
  const _ArgentQuotidien();

  @override
  Widget build(BuildContext context) {
    const devises = [
      ('EUR · Euro', '312', '28,6 M', 'Taux fixe'),
      ('USD · Dollar', '84', '6,1 M', 'Bloqué 30 min'),
      ('CAD · Dollar canadien', '41', '2,7 M', 'Bloqué 30 min'),
      ('GBP · Livre', '19', '1,9 M', 'Bloqué 30 min'),
      ('XOF · Franc CFA BCEAO', '57', '3,4 M', 'Taux fixe'),
    ];
    const tontines = [
      ('Les Mamans de Moungali', '8 membres', '80 000', 'À jour'),
      ('Collègues E2C', '12 membres', '300 000', '1 retard'),
      ('Commerçantes Total', '20 membres', '400 000', 'À jour'),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GrilleAdaptative(
          largeurMax: 260,
          espacement: 12,
          enfants: const [
            TuileChiffre(
              libelle: 'Transferts reçus (mois)',
              valeur: '42,7 M',
              icone: Icons.currency_exchange_rounded,
              detail: 'FCFA · 513 envois, 10 devises',
              couleur: LiveColors.succes,
            ),
            TuileChiffre(
              libelle: 'Cagnottes de tontine gardées',
              valeur: '6,3 M',
              icone: Icons.diversity_3_rounded,
              detail: 'FCFA · 214 tontines actives',
            ),
            TuileChiffre(
              libelle: 'Factures payées (mois)',
              valeur: '3 918',
              icone: Icons.receipt_long_rounded,
              detail: 'E2C, LCDE, télévision',
            ),
            TuileChiffre(
              libelle: 'Achats groupés ouverts',
              valeur: '27',
              icone: Icons.groups_2_rounded,
              detail: '3 remboursés cette semaine',
              couleur: LiveColors.cuivre,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Bloc(
          fond: LiveColors.voile,
          child: const Row(
            children: [
              Icon(Icons.account_balance_rounded, color: LiveColors.bleu),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Partenaire de transfert agréé : à sélectionner (docs/26, §6). '
                  'Tant qu’il n’est pas signé, Live Transfert reste fermé en '
                  'production ; les chiffres ci-dessous sont ceux du pilote.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Transferts par devise',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _Tableau(
          colonnes: const [
            ('Devise', 3),
            ('Envois', 1),
            ('Reçu en FCFA', 2),
            ('Taux', 2),
          ],
          lignes: [
            for (final (d, n, v, t) in devises)
              [
                Text(d, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(n),
                Text(v),
                _etat(t == 'Taux fixe' ? 'Actif' : t),
              ],
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Tontines à surveiller',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _Tableau(
          colonnes: const [
            ('Tontine', 3),
            ('Membres', 2),
            ('Cagnotte', 2),
            ('État', 2),
          ],
          lignes: [
            for (final (nom, m, c, e) in tontines)
              [
                Text(nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(m),
                Text('$c FCFA'),
                _etat(e == 'À jour' ? 'Actif' : 'En attente'),
              ],
          ],
          onTap: (_) =>
              _decider(context, 'Relance envoyée au membre en retard.'),
        ),
        const SizedBox(height: 8),
        const Text(
          'Les cagnottes sont versées automatiquement le jour du tour ; un '
          'versement qui échoue passe dans la file des litiges.',
          style: TextStyle(color: LiveColors.gris, fontSize: 13),
        ),
      ],
    );
  }
}

/// E-ADM-12 — Live IA : coût réel par service, marge, limites, demandes
/// refusées (F-IA-11 ; alerte si le coût dépasse 35 % du prix, docs/20 §4.8).
class _LiveIaAdmin extends StatelessWidget {
  const _LiveIaAdmin();

  @override
  Widget build(BuildContext context) {
    const services = [
      ('CV complet', '20', '1 204', '31 FCFA', 16),
      ('Lettre de motivation', '10', '932', '18 FCFA', 18),
      ('Exercice par photo', '5', '4 870', '14 FCFA', 28),
      ('Résumé de document', '5 à 20', '1 516', '29 FCFA', 29),
      ('Business plan express', '50', '188', '192 FCFA', 38),
      ('Assistant Live (agir)', 'gratuit', '9 402', '3 FCFA', 0),
    ];
    const refusees = [
      ('Faux diplôme demandé', 'CV complet', 'Refusé, recrédité'),
      ('Devoir d’examen en cours', 'Exercice par photo', 'Mode apprentissage'),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GrilleAdaptative(
          largeurMax: 260,
          espacement: 12,
          enfants: const [
            TuileChiffre(
              libelle: 'Crédits vendus (mois)',
              valeur: '642 000',
              icone: Icons.auto_awesome_outlined,
              detail: 'FCFA · 1 284 packs',
              couleur: LiveColors.succes,
            ),
            TuileChiffre(
              libelle: 'Demandes aujourd’hui',
              valeur: '18 112',
              icone: Icons.bolt_rounded,
              detail: 'dont 9 402 à l’Assistant',
            ),
            TuileChiffre(
              libelle: 'Coût réel moyen',
              valeur: '21 %',
              icone: Icons.pie_chart_outline_rounded,
              detail: 'du prix · objectif < 35 %',
            ),
            TuileChiffre(
              libelle: 'Recrédits automatiques',
              valeur: '46',
              icone: Icons.replay_rounded,
              detail: 'générations échouées',
              couleur: LiveColors.cuivre,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Coût par service',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _Tableau(
          colonnes: const [
            ('Service', 3),
            ('Prix (crédits)', 2),
            ('Demandes', 2),
            ('Coût réel', 2),
            ('Part du prix', 2),
          ],
          lignes: [
            for (final (nom, prix, n, cout, part) in services)
              [
                Text(nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(prix),
                Text(n),
                Text(cout),
                _etat(
                  part > 35
                      ? 'Écart'
                      : part == 0
                      ? 'Actif'
                      : '$part %',
                ),
              ],
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Business plan express à 38 % : passer au modèle plus économe pour '
          'la rédaction des annexes, ou revoir le prix (double validation).',
          style: TextStyle(color: LiveColors.gris, fontSize: 13),
        ),
        const SizedBox(height: 16),
        const Text(
          'Demandes refusées par la modération',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _Tableau(
          colonnes: const [('Motif', 3), ('Service', 2), ('Décision', 3)],
          lignes: [
            for (final (motif, service, decision) in refusees)
              [Text(motif), Text(service), Text(decision)],
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => _decider(
                context,
                'Limite passée à 30 demandes par jour et par personne '
                '(journalisé).',
              ),
              icon: const Icon(Icons.speed_rounded),
              label: const Text('Limites d’usage'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => _decider(
                context,
                'Remboursement en crédits soumis à double validation.',
              ),
              icon: const Icon(Icons.redeem_rounded),
              label: const Text('Rembourser en crédits'),
            ),
          ],
        ),
      ],
    );
  }
}
