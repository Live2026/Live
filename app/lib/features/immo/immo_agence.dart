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
        title: Text(context.t.immoEspaceAgence),
        actions: [
          IconButton(
            tooltip: context.t.immoPublierUnBien,
            onPressed: () => context.push('/publier/bien'),
            icon: const Icon(Icons.add_home_outlined),
          ),
          const BoutonNotifications(),
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
                    BadgeVerifie(context.t.immoAgenceVerifieeAgrement0231),
                    Text(
                      context.t.immoAgentsNote(
                        agentsPalmiers.length,
                        note(palmiers.note),
                        compact(palmiers.abonnes),
                      ),
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
                libelle: context.t.immoVisitesAujourdHui,
                valeur: '${aujourdhui.length}',
                icone: Icons.event_available_rounded,
                detail: context.t.immoProchaineA1030,
              ),
              TuileChiffre(
                libelle: context.t.immoNouvellesDemandes,
                valeur: '${nouvelles.length}',
                icone: Icons.mark_email_unread_outlined,
                detail: context.t.immoAAttribuer,
                couleur: LiveColors.orangeVif,
              ),
              TuileChiffre(
                libelle: context.t.immoBiensEnLigne,
                valeur: '${mesBiens.length}',
                icone: Icons.home_work_outlined,
                detail: context.t.immoN1AReconfirmer,
              ),
              TuileChiffre(
                libelle: context.t.immoEncaisseCeMois,
                valeur: '186 000',
                icone: Icons.payments_outlined,
                detail: context.t.immoFcfaFraisDeVisite,
                couleur: LiveColors.succes,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (i, nom) in [
                  context.t.immoOngletAujourdhui(aujourdhui.length),
                  context.t.immoOngletDemandes(nouvelles.length),
                  context.t.immoOngletBiens(mesBiens.length),
                  context.t.immoOngletEquipe(agentsPalmiers.length),
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(nom),
                      selected: _onglet == i,
                      onSelected: (_) => setState(() => _onglet = i),
                    ),
                  ),
              ],
            ),
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
                      ? context.t.immoGestionnaire12VisitesCe
                      : context.t.immoAgentVisites(8 - i * 2),
                  onTap: () => context.push('/espace/equipe'),
                ),
              TextButton.icon(
                onPressed: () => context.push('/espace/equipe'),
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: Text(context.t.immoAjouterUnMembre),
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
                        context.t.immoTitreQuartier(b.titre, b.quartier),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        context.t.immoVisiteurAgent(d.visiteur, d.agent),
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Etiquette(
                  d.statut == 'Nouvelle'
                      ? context.t.immoNouvelle
                      : context.t.immoFraisPayes,
                  fond: d.statut == 'Nouvelle'
                      ? LiveColors.teinteOrange
                      : LiveColors.teinteVerte,
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
                    child: Text(context.t.immoEcrire),
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
                            SnackBar(
                              content: Text(
                                context.t.immoVisiteAttribueeAChristian,
                              ),
                            ),
                          )
                        : () => context.push('/agence/visite/${d.id}'),
                    child: Text(
                      attribuer ? context.t.immoAttribuer : context.t.valider,
                    ),
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
                    context.t.immoTitreQuartier(b.titre, b.quartier),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    context.t.immoStatsBien(
                      fcfaCourt(b.loyer),
                      b.photos * 37,
                      b.photos ~/ 3,
                    ),
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            aConfirmer
                ? TextButton(
                    onPressed: () => informer(
                      context,
                      context.t.immoDisponibiliteReconfirmeeLAnnonce,
                    ),
                    child: Text(context.t.immoReconfirmer),
                  )
                : Etiquette(
                    context.t.immoEnLigne,
                    fond: LiveColors.teinteVerte,
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
      appBar: AppBar(title: Text(context.t.immoValiderLaVisite)),
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
                      Text(context.t.immoTitreQuartier(b.titre, b.quartier)),
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
              context.t.immoVisiteValidee(fcfa(b.fraisVisite)),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.t.immoOffreEnvoyeeA(d.visiteur)),
                ),
              ),
              child: Text(context.t.immoEnvoyerUneOffreDe),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(context.t.immoRetourAuTableauDe),
            ),
          ] else ...[
            Text(context.t.immoSurPlaceDemandezAu, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final ok = await simulerScan(
                  context,
                  quoi: context.t.immoDuVisiteur,
                );
                if (ok) setState(() => _validee = true);
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(context.t.immoScannerLeQrDu),
            ),
            TextButton(
              onPressed: () async {
                final code = await saisirCode(
                  context,
                  titre: context.t.immoCodeDuVisiteur,
                );
                if (code != null) setState(() => _validee = true);
              },
              child: Text(context.t.immoSaisirLeCodeLv),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                if (await confirmer(
                  context,
                  titre: context.t.immoVisiteurAbsent,
                  texte: context.t.immoAbsenceTexte(fcfa(b.fraisVisite)),
                  action: context.t.immoDeclarerLAbsence,
                )) {
                  if (context.mounted) {
                    informer(
                      context,
                      context.t.immoAbsenceEnregistreeFraisVerses,
                    );
                  }
                }
              },
              child: Text(context.t.immoLeVisiteurNeS),
            ),
          ],
        ],
      ),
    );
  }
}
