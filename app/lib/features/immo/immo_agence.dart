part of 'immo_screens.dart';

/// E-IMMO-07 — Tableau de bord de l'agence : visites du jour, demandes,
/// biens en ligne et équipe. Réservé aux espaces agence vérifiés (N3).
class EcranAgence extends StatefulWidget {
  const EcranAgence({super.key});

  @override
  State<EcranAgence> createState() => _EcranAgenceState();
}

class _EcranAgenceState extends State<EcranAgence> {
  var _onglet = 0;

  @override
  Widget build(BuildContext context) {
    final aujourdhui = demandesVisite
        .where((d) => d.creneau.startsWith('Auj'))
        .toList();
    final nouvelles = demandesVisite
        .where((d) => d.statut == 'Nouvelle')
        .toList();
    final mesBiens = biensDe(palmiers);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace agence'),
        actions: [
          IconButton(
            tooltip: 'Publier un bien',
            onPressed: () => context.push('/publier/bien'),
            icon: const Icon(Icons.add_home_outlined),
          ),
          const BoutonMessages(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          Row(
            children: [
              const Avatar(
                nom: 'Les Palmiers',
                couleur: Color(0xFF166534),
                taille: 56,
                verifie: true,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      palmiers.nom,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const BadgeVerifie('Agence vérifiée · agrément 0231'),
                    Text(
                      '${agentsPalmiers.length} agents · ${note(palmiers.note)} · ${compact(palmiers.abonnes)} abonnés',
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            enfants: [
              TuileChiffre(
                libelle: "Visites aujourd'hui",
                valeur: '${aujourdhui.length}',
                icone: Icons.event_available_rounded,
                detail: 'Prochaine à 10:30',
              ),
              TuileChiffre(
                libelle: 'Nouvelles demandes',
                valeur: '${nouvelles.length}',
                icone: Icons.mark_email_unread_outlined,
                detail: 'À attribuer',
                couleur: LiveColors.orangeVif,
              ),
              TuileChiffre(
                libelle: 'Biens en ligne',
                valeur: '${mesBiens.length}',
                icone: Icons.home_work_outlined,
                detail: '1 à reconfirmer',
              ),
              const TuileChiffre(
                libelle: 'Encaissé ce mois',
                valeur: '186 000',
                icone: Icons.payments_outlined,
                detail: 'FCFA · frais de visite',
                couleur: LiveColors.succes,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 0, label: Text("Aujourd'hui")),
              ButtonSegment(value: 1, label: Text('Demandes')),
              ButtonSegment(value: 2, label: Text('Biens')),
              ButtonSegment(value: 3, label: Text('Équipe')),
            ],
            selected: {_onglet},
            onSelectionChanged: (s) => setState(() => _onglet = s.first),
          ),
          const SizedBox(height: 12),
          ...switch (_onglet) {
            0 => [for (final d in aujourdhui) _CarteDemande(demande: d)],
            1 => [
              for (final d in nouvelles)
                _CarteDemande(demande: d, attribuer: true),
            ],
            2 => [for (final b in mesBiens) _LigneBienAgence(bien: b)],
            _ => [
              for (final (i, a) in agentsPalmiers.indexed)
                LigneMenu(
                  icone: Icons.badge_outlined,
                  titre: a,
                  detail: i == 0
                      ? 'Gestionnaire · 12 visites ce mois'
                      : 'Agent · ${8 - i * 2} visites ce mois',
                  onTap: () {},
                ),
              TextButton.icon(
                onPressed: () => context.push('/espace/equipe'),
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Ajouter un membre'),
              ),
            ],
          },
        ],
      ),
    );
  }
}

class _CarteDemande extends StatelessWidget {
  const _CarteDemande({required this.demande, this.attribuer = false});
  final DemandeVisite demande;
  final bool attribuer;

  @override
  Widget build(BuildContext context) {
    final d = demande;
    final b = bienParId(d.bienId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Bloc(
        padding: 12,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Vignette(
                    couleur: b.couleur,
                    icone: b.type.icone,
                    rayon: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.creneau,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${b.titre} · ${b.quartier}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${d.visiteur} · agent : ${d.agent}',
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Etiquette(
                  d.statut == 'Nouvelle' ? 'Nouvelle' : 'Frais payés',
                  fond: d.statut == 'Nouvelle'
                      ? const Color(0xFFFFF1E0)
                      : const Color(0xFFE7F4EC),
                  couleur: d.statut == 'Nouvelle'
                      ? LiveColors.cuivre
                      : LiveColors.succes,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                    ),
                    onPressed: () => context.push('/conversation'),
                    child: const Text('Écrire'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                    ),
                    onPressed: attribuer
                        ? () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Visite attribuée à Christian.'),
                            ),
                          )
                        : () => context.push('/agence/visite/${d.id}'),
                    child: Text(attribuer ? 'Attribuer' : 'Valider la visite'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LigneBienAgence extends StatelessWidget {
  const _LigneBienAgence({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    final aConfirmer = b.confirmeIlYa > 7;
    return InkWell(
      onTap: () => context.push('/bien/${b.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 52,
              child: Vignette(
                couleur: b.couleur,
                icone: b.type.icone,
                rayon: 8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${b.titre} · ${b.quartier}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${fcfaCourt(b.loyer)} · ${b.photos * 37} vues · ${b.photos ~/ 3} visites',
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            aConfirmer
                ? TextButton(onPressed: () {}, child: const Text('Reconfirmer'))
                : const Etiquette(
                    'En ligne',
                    fond: Color(0xFFE7F4EC),
                    couleur: LiveColors.succes,
                  ),
          ],
        ),
      ),
    );
  }
}

/// E-IMMO-08 — Valider une visite : l'agent scanne le QR du visiteur.
class EcranValiderVisite extends StatefulWidget {
  const EcranValiderVisite({super.key, required this.id});
  final String id;

  @override
  State<EcranValiderVisite> createState() => _EcranValiderVisiteState();
}

class _EcranValiderVisiteState extends State<EcranValiderVisite> {
  var _validee = false;

  @override
  Widget build(BuildContext context) {
    final d = demandesVisite.firstWhere(
      (x) => x.id == widget.id,
      orElse: () => demandesVisite.first,
    );
    final b = bienParId(d.bienId);
    return Scaffold(
      appBar: AppBar(title: const Text('Valider la visite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Row(
              children: [
                Avatar(
                  nom: d.visiteur,
                  couleur: const Color(0xFF7E22CE),
                  taille: 52,
                  verifie: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.visiteur,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('${b.titre} · ${b.quartier}'),
                      Text(
                        d.creneau,
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_validee) ...[
            const CocheAnimee(taille: 72),
            Text(
              'Visite validée. ${fcfa(b.fraisVisite)} seront versés sur le solde de l’agence.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Offre de réservation envoyée à ${d.visiteur}.',
                  ),
                ),
              ),
              child: const Text('Envoyer une offre de réservation'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Retour au tableau de bord'),
            ),
          ] else ...[
            const Text(
              'Sur place, demandez au visiteur d’ouvrir sa visite dans Live et scannez son QR. '
              'C’est ce qui déclenche le versement des frais de visite.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final ok = await simulerScan(context, quoi: 'du visiteur');
                if (ok) setState(() => _validee = true);
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scanner le QR du visiteur'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Saisir le code LV- à la place'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Le visiteur ne s’est pas présenté'),
            ),
          ],
        ],
      ),
    );
  }
}
