part of 'admin_screens.dart';

/// E-ADM-01 — Tableau de bord des indicateurs (docs/05, section 6).
class _TableauDeBord extends StatelessWidget {
  const _TableauDeBord();

  @override
  Widget build(BuildContext context) {
    const valeurs = [
      3.1,
      3.4,
      2.9,
      3.8,
      4.2,
      4.0,
      4.6,
      5.1,
      4.8,
      5.6,
      6.0,
      5.7,
      6.4,
      7.1,
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GrilleAdaptative(
          largeurMax: 240,
          espacement: 12,
          enfants: const [
            TuileChiffre(
              libelle: 'Volume du jour',
              valeur: '7,1 M',
              icone: Icons.trending_up_rounded,
              detail: 'FCFA · +11 % vs hier',
              couleur: LiveColors.succes,
            ),
            TuileChiffre(
              libelle: 'Transactions',
              valeur: '1 284',
              icone: Icons.receipt_long_outlined,
              detail: '97,6 % réussies',
            ),
            TuileChiffre(
              libelle: 'En séquestre',
              valeur: '18,4 M',
              icone: Icons.lock_outline_rounded,
              detail: 'FCFA · 612 commandes',
            ),
            TuileChiffre(
              libelle: 'Actifs aujourd’hui',
              valeur: '23 410',
              icone: Icons.people_outline,
              detail: '+1 902 inscrits',
            ),
            TuileChiffre(
              libelle: 'Litiges ouverts',
              valeur: '14',
              icone: Icons.gavel_rounded,
              detail: '0,4 % des commandes',
              couleur: LiveColors.orangeVif,
            ),
            TuileChiffre(
              libelle: 'KYC en attente',
              valeur: '37',
              icone: Icons.badge_outlined,
              detail: 'délai moyen 11 min',
              couleur: LiveColors.cuivre,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Bloc(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Volume payé par jour (millions de FCFA)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final (i, v) in valeurs.indexed)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (i == valeurs.length - 1)
                                Text(
                                  v.toString().replaceAll('.', ','),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              Container(
                                height: 140 * v / 7.1,
                                decoration: BoxDecoration(
                                  color: i == valeurs.length - 1
                                      ? LiveColors.orange
                                      : LiveColors.bleu.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Text(
                    '12 sept.',
                    style: TextStyle(fontSize: 11, color: LiveColors.gris),
                  ),
                  Spacer(),
                  Text(
                    '25 sept.',
                    style: TextStyle(fontSize: 11, color: LiveColors.gris),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GrilleAdaptative(
          largeurMax: 420,
          espacement: 12,
          enfants: [
            Bloc(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Files de travail',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  LigneMenu(
                    icone: Icons.badge_outlined,
                    titre: 'Vérifications d’identité',
                    valeur: '37',
                    onTap: () => context.go('/admin/kyc'),
                  ),
                  LigneMenu(
                    icone: Icons.shield_outlined,
                    titre: 'Modération',
                    valeur: '52',
                    onTap: () => context.go('/admin/moderation'),
                  ),
                  LigneMenu(
                    icone: Icons.gavel_rounded,
                    titre: 'Litiges',
                    valeur: '14',
                    onTap: () => context.go('/admin/litiges'),
                  ),
                  LigneMenu(
                    icone: Icons.report_gmailerrorred_rounded,
                    titre: 'Retraits suspects',
                    valeur: '3',
                    couleur: LiveColors.erreur,
                    onTap: () => context.go('/admin/finance'),
                  ),
                ],
              ),
            ),
            const Bloc(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Santé des paiements',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  LigneMenu(
                    icone: Icons.phone_android,
                    titre: 'MTN MoMo',
                    detail: 'Taux de succès 98,1 % · 3,2 s',
                    valeur: 'Normal',
                  ),
                  LigneMenu(
                    icone: Icons.phone_android,
                    titre: 'Airtel Money',
                    detail: 'Taux de succès 96,4 % · 4,8 s',
                    valeur: 'Normal',
                  ),
                  LigneMenu(
                    icone: Icons.credit_card,
                    titre: 'Visa',
                    detail: 'Taux de succès 91,0 %',
                    valeur: 'Surveillé',
                    couleur: LiveColors.cuivre,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
