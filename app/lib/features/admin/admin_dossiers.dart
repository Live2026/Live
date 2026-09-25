part of 'admin_screens.dart';

const _kyc = [
  ('k1', 'Grâce Mabiala', 'N2 · Identité', 'il y a 4 min', 'Faible'),
  ('k2', 'Congo Habitat', 'N3 · Agence', 'il y a 18 min', 'Moyen'),
  ('k3', 'Jordy Mampouya', 'N2 · Identité', 'il y a 22 min', 'Faible'),
  ('k4', 'Boutique Élégance', 'N3 · Boutique', 'il y a 1 h', 'Urgent'),
  ('k5', 'Sandra Ngoma', 'N2 · Identité', 'il y a 2 h', 'Faible'),
];

/// E-ADM-02 — File de vérification d'identité.
class _FileKyc extends StatelessWidget {
  const _FileKyc();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '37 dossiers en attente · objectif : moins de 15 minutes',
          style: TextStyle(color: LiveColors.gris),
        ),
        const SizedBox(height: 12),
        _Tableau(
          colonnes: const [
            ('Demandeur', 3),
            ('Niveau', 2),
            ('Soumis', 2),
            ('Risque', 2),
          ],
          lignes: [
            for (final (_, nom, niveau, quand, risque) in _kyc)
              [
                Text(nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(niveau),
                Text(quand, style: const TextStyle(color: LiveColors.gris)),
                _etat(risque),
              ],
          ],
          onTap: (i) => context.push('/admin/kyc/${_kyc[i].$1}'),
        ),
      ],
    );
  }
}

/// E-ADM-03 — Dossier KYC : pièces, selfie, contrôles, décision.
class EcranDossierKyc extends StatelessWidget {
  const EcranDossierKyc({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final d = _kyc.firstWhere((k) => k.$1 == id, orElse: () => _kyc.first);
    return _CoqueAdmin(
      section: 1,
      titre: 'Dossier KYC · ${d.$2}',
      corps: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GrilleAdaptative(
            largeurMax: 260,
            espacement: 12,
            hauteur: 170,
            enfants: [
              for (final (icone, nom, couleur) in const [
                (Icons.badge_outlined, 'CNI · recto', Color(0xFF475569)),
                (Icons.flip_outlined, 'CNI · verso', Color(0xFF334155)),
                (Icons.face_outlined, 'Selfie', Color(0xFF1F2937)),
              ])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Vignette(
                        couleur: couleur,
                        icone: icone,
                        rayon: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nom,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contrôles automatiques',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                LigneMenu(
                  icone: Icons.check_circle_rounded,
                  couleur: LiveColors.succes,
                  titre: 'Visage identique à la pièce',
                  valeur: '97 %',
                ),
                LigneMenu(
                  icone: Icons.check_circle_rounded,
                  couleur: LiveColors.succes,
                  titre: 'Nom Mobile Money identique',
                  detail: 'MABIALA GRÂCE (MTN)',
                ),
                LigneMenu(
                  icone: Icons.check_circle_rounded,
                  couleur: LiveColors.succes,
                  titre: 'Pièce en cours de validité',
                  valeur: '2031',
                ),
                LigneMenu(
                  icone: Icons.info_outline_rounded,
                  couleur: LiveColors.cuivre,
                  titre: 'Numéro déjà vu sur un autre compte',
                  valeur: 'Non',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    _decider(context, 'Dossier validé : niveau N2 accordé.'),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Valider'),
              ),
              OutlinedButton.icon(
                onPressed: () => _decider(
                  context,
                  'Nouvelle photo demandée à l’utilisateur.',
                ),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Demander une nouvelle photo'),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: LiveColors.erreur,
                ),
                onPressed: () =>
                    _decider(context, 'Dossier rejeté, motif envoyé.'),
                icon: const Icon(Icons.close_rounded),
                label: const Text('Rejeter'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Chaque décision est inscrite au journal d’audit, non modifiable.',
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

void _decider(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// E-ADM-04 — File de modération : contenus signalés ou détectés.
class _FileModeration extends StatelessWidget {
  const _FileModeration();

  @override
  Widget build(BuildContext context) {
    const elements = [
      (
        'Vidéo · @vente.rapide',
        'Arnaque : paiement hors Live',
        'Signalé 6 fois',
        Color(0xFF7F1D1D),
      ),
      (
        'Annonce · Studio Poto-Poto',
        'Photos déjà utilisées ailleurs',
        'Détection automatique',
        Color(0xFF334155),
      ),
      (
        'Annonce · Médicaments',
        'Catégorie interdite',
        'Détection automatique',
        Color(0xFF9D174D),
      ),
      (
        'Commentaire · Prince B.',
        'Propos injurieux',
        'Signalé 2 fois',
        Color(0xFF475569),
      ),
      (
        'Profil · Jean K.',
        'Faux compte possible',
        'Signalé 3 fois',
        Color(0xFF1F2937),
      ),
      (
        'Annonce · Studio Plateau',
        'Déjà loué',
        'Signalé 4 fois',
        Color(0xFF7C2D12),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '52 éléments · les plus signalés en premier',
          style: TextStyle(color: LiveColors.gris),
        ),
        const SizedBox(height: 12),
        GrilleAdaptative(
          largeurMax: 380,
          espacement: 12,
          hauteur: 150,
          enfants: [
            for (final (titre, motif, source, couleur) in elements)
              Bloc(
                padding: 12,
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: Vignette(
                        couleur: couleur,
                        icone: Icons.image_outlined,
                        rayon: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            motif,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            source,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(0, 36),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () =>
                                      _decider(context, 'Contenu conservé.'),
                                  child: const Text('Garder'),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(0, 36),
                                    padding: EdgeInsets.zero,
                                    backgroundColor: LiveColors.erreur,
                                  ),
                                  onPressed: () => _decider(
                                    context,
                                    'Contenu retiré, auteur prévenu.',
                                  ),
                                  child: const Text('Retirer'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

const _litiges = [
  ('l1', 'LV-00491 · iPhone 11', 'Produit différent', 85000, 'Urgent'),
  ('l2', 'VI-00212 · Visite', 'Agent absent', 2000, 'En cours'),
  ('l3', 'PR-00118 · Plomberie', 'Travail non terminé', 25000, 'En cours'),
  ('l4', 'LV-00455 · Robe wax', 'Rien reçu', 15000, 'Résolu'),
];

/// Liste des litiges (E-ADM-05, vue file).
class _FileLitiges extends StatelessWidget {
  const _FileLitiges();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Tableau(
          colonnes: const [
            ('Transaction', 3),
            ('Motif', 3),
            ('Bloqué', 2),
            ('État', 2),
          ],
          lignes: [
            for (final (_, objet, motif, montant, etat) in _litiges)
              [
                Text(
                  objet,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(motif),
                Text(fcfa(montant)),
                _etat(etat),
              ],
          ],
          onTap: (i) => context.push('/admin/litiges/${_litiges[i].$1}'),
        ),
      ],
    );
  }
}

/// E-ADM-05 — Dossier de litige et décision tracée.
class EcranLitige extends StatelessWidget {
  const EcranLitige({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final l = _litiges.firstWhere(
      (x) => x.$1 == id,
      orElse: () => _litiges.first,
    );
    return _CoqueAdmin(
      section: 3,
      titre: 'Litige · ${l.$2}',
      corps: DeuxColonnes(
        principale: [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.$2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Motif : ${l.$3} · ${fcfa(l.$4)} bloqués',
                  style: const TextStyle(color: LiveColors.gris),
                ),
                const SizedBox(height: 16),
                const Frise(
                  etapes: [
                    EtapeFrise(
                      'Paiement séquestré',
                      '24 sept. 10:21 · MTN MoMo',
                      true,
                    ),
                    EtapeFrise(
                      'Réclamation de l’acheteuse',
                      '25 sept. 11:02 · 2 photos',
                      true,
                    ),
                    EtapeFrise(
                      'Réponse du vendeur',
                      '25 sept. 14:40 · propose une reprise',
                      true,
                    ),
                    EtapeFrise(
                      'Décision Live',
                      'En attente de votre décision',
                      false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 160,
            espacement: 8,
            hauteur: 110,
            enfants: [
              for (var i = 0; i < 3; i++)
                Vignette(
                  couleur: Color.lerp(
                    const Color(0xFF334155),
                    Colors.black,
                    i * 0.15,
                  )!,
                  icone: Icons.image_outlined,
                  rayon: 8,
                ),
            ],
          ),
        ],
        secondaire: [
          const Text(
            'Décision',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => _decider(
              context,
              'Remboursement total : double validation demandée à un 2e agent.',
            ),
            child: const Text('Rembourser en totalité'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () =>
                _decider(context, 'Remboursement partiel enregistré.'),
            child: const Text('Remboursement partiel'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _decider(context, 'Fonds libérés au vendeur.'),
            child: const Text('Libérer au vendeur'),
          ),
          const SizedBox(height: 12),
          const BandeauProtection(
            'Au-delà de 50 000 FCFA, un second agent doit confirmer la décision.',
          ),
        ],
      ),
    );
  }
}
