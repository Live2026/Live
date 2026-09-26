part of 'services_screens.dart';

/// E-SRV-02 — Profil d'un prestataire : note, zone, services à prix fixe,
/// réalisations et avis.
class EcranProfilPrestataire extends ConsumerWidget {
  const EcranProfilPrestataire({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = prestataireParId(id);
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(p.id)),
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: context.t.partager,
            onPressed: () => partager(context, '${p.nom} · ${p.metier}'),
            icon: const Icon(Icons.ios_share_rounded),
          ),
          IconButton(
            tooltip: context.t.servicesSignaler,
            onPressed: () => signaler(context, context.t.servicesCePrestataire),
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: DeuxColonnes(
        principale: [
          Row(
            children: [
              Avatar(
                nom: p.nom,
                couleur: p.couleur,
                taille: 76,
                verifie: true,
                anneau: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.nom,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(p.metier, style: const TextStyle(fontSize: 16)),
                    BadgeVerifie(context.t.servicesIdentiteVerifiee),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Chiffre(
                note(p.note).replaceAll('/5', ''),
                context.t.servicesNAvis(p.avis),
              ),
              _Chiffre('${p.interventions}', context.t.servicesInterventions),
              _Chiffre('98 %', context.t.servicesALHeure),
              _Chiffre('15 min', context.t.servicesRepondEn),
            ],
          ),
          const SizedBox(height: 14),
          if (p.bio.isNotEmpty) Text(p.bio),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: LiveColors.gris,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  p.zone,
                  style: const TextStyle(color: LiveColors.gris),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: suivi
                    ? OutlinedButton(
                        onPressed: () =>
                            ref.read(liveProvider.notifier).basculerSuivi(p.id),
                        child: Text(context.t.servicesAbonne),
                      )
                    : OutlinedButton(
                        onPressed: () =>
                            ref.read(liveProvider.notifier).basculerSuivi(p.id),
                        child: Text(context.t.servicesSuivre),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/conversation'),
                  child: Text(context.t.servicesEcrire),
                ),
              ),
              const SizedBox(width: 8),
              // Appel par Live : le numéro du pro n'est jamais montré.
              IconButton.outlined(
                tooltip: context.t.appelsAppelAudio,
                onPressed: () => context.push(routeAppel(avec: p.nom)),
                icon: const Icon(Icons.call_outlined),
              ),
              IconButton.outlined(
                tooltip: context.t.appelsAppelVideo,
                onPressed: () =>
                    context.push(routeAppel(avec: p.nom, video: true)),
                icon: const Icon(Icons.videocam_outlined),
              ),
            ],
          ),
          if (p.services.isNotEmpty) ...[
            EnTeteSection(context.t.servicesServicesAPrixFixe),
            for (final s in p.services)
              LigneMenu(
                icone: Icons.bolt_rounded,
                titre: s.titre,
                detail: context.t.servicesEnviron(s.duree),
                valeur: fcfa(s.prix),
                onTap: () => context.push('/pro/${p.id}/reserver/${s.id}'),
              ),
          ],
          EnTeteSection(context.t.servicesRealisations),
          GrilleAdaptative(
            largeurMax: 140,
            espacement: 6,
            enfants: [
              for (var i = 0; i < 6; i++)
                AspectRatio(
                  aspectRatio: 1,
                  child: Vignette(
                    couleur: Color.lerp(p.couleur, Colors.black, i * 0.07)!,
                    icone: i.isEven
                        ? Icons.play_arrow_rounded
                        : Icons.photo_outlined,
                    rayon: 8,
                  ),
                ),
            ],
          ),
        ],
        secondaire: [
          EnTeteSection(context.t.servicesAvisVerifies),
          for (final (nom, n, texte) in const [
            ('Grâce M.', 5.0, 'Fuite réparée en 30 minutes, très propre.'),
            ('Rodrigue O.', 5.0, 'Ponctuel et prix respecté.'),
            ('Estelle N.', 4.0, 'Bon travail, un peu de retard.'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Bloc(
                padding: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nom,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Etoiles(n, taille: 14),
                      ],
                    ),
                    Text(texte),
                  ],
                ),
              ),
            ),
          BandeauProtection(context.t.servicesAcompteBloqueParLive),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.push('/services/demande'),
          child: Text(context.t.servicesDemanderDevisA(p.nom)),
        ),
      ),
    );
  }
}

class _Chiffre extends StatelessWidget {
  const _Chiffre(this.valeur, this.libelle);
  final String valeur;
  final String libelle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valeur,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          Text(
            libelle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: LiveColors.gris, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// E-SRV-06 — Réserver un service à prix fixe : créneau puis paiement.
class EcranServiceFixe extends ConsumerStatefulWidget {
  const EcranServiceFixe({
    super.key,
    required this.proId,
    required this.serviceId,
  });
  final String proId;
  final String serviceId;

  @override
  ConsumerState<EcranServiceFixe> createState() => _EcranServiceFixeState();
}

class _EcranServiceFixeState extends ConsumerState<EcranServiceFixe> {
  var _jour = 'Demain';
  String? _heure;
  var _adresse = 'Moungali, derrière le marché Total';

  @override
  Widget build(BuildContext context) {
    final p = prestataireParId(widget.proId);
    final s = p.services.firstWhere(
      (x) => x.id == widget.serviceId,
      orElse: () => p.services.first,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.t.servicesReserver)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Row(
              children: [
                Avatar(nom: p.nom, couleur: p.couleur, verifie: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.titre,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        context.t.servicesProMetierDuree(
                          p.nom,
                          p.metier,
                          s.duree,
                        ),
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                    ],
                  ),
                ),
                Text(
                  fcfa(s.prix),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            context.t.servicesQuand,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final j in const ["Aujourd'hui", 'Demain', 'Samedi'])
                ChoiceChip(
                  label: Text(switch (j) {
                    'Demain' => context.t.servicesJourDemain,
                    'Samedi' => context.t.servicesJourSamedi,
                    _ => context.t.servicesJourAujourdhui,
                  }),
                  selected: _jour == j,
                  onSelected: (_) => setState(() => _jour = j),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final h in const [
                '08:00',
                '10:00',
                '13:00',
                '15:00',
                '17:00',
              ])
                ChoiceChip(
                  label: Text(h),
                  selected: _heure == h,
                  onSelected: (_) => setState(() => _heure = h),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            context.t.servicesOu,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _adresse,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              labelText: context.t.servicesAdresse,
            ),
            onChanged: (v) => _adresse = v,
          ),
          const SizedBox(height: 18),
          LigneMontant(context.t.servicesPrixDuService, s.prix),
          LigneMontant(context.t.servicesDeplacement, 0),
          LigneMontant(context.t.servicesTotal, s.prix, gras: true),
          const SizedBox(height: 8),
          BandeauProtection(context.t.servicesPayeMaintenantVerseAu),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _heure == null
              ? null
              : () {
                  ref
                      .read(liveProvider.notifier)
                      .preparerPaiement(
                        PaiementEnCours(
                          type: TypePaiement.service,
                          montant: s.prix,
                          libelle: s.titre,
                          beneficiaire: p.nom,
                          cibleId: '${p.id}|${s.id}',
                          creneau: '$_jour $_heure',
                        ),
                      );
                  context.push('/payer');
                },
          child: Text(
            _heure == null
                ? context.t.servicesChoisissezUneHeure
                : context.t.servicesReserverMontant(fcfa(s.prix)),
          ),
        ),
      ),
    );
  }
}
