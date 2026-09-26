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
            tooltip: 'Partager',
            onPressed: () => partager(context, '${p.nom} · ${p.metier}'),
            icon: const Icon(Icons.ios_share_rounded),
          ),
          IconButton(
            tooltip: 'Signaler',
            onPressed: () => signaler(context, 'ce prestataire'),
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
                    const BadgeVerifie('Identité vérifiée'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Chiffre(note(p.note).replaceAll('/5', ''), '${p.avis} avis'),
              _Chiffre('${p.interventions}', 'interventions'),
              const _Chiffre('98 %', 'à l’heure'),
              const _Chiffre('15 min', 'répond en'),
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
                        child: const Text('Abonné'),
                      )
                    : OutlinedButton(
                        onPressed: () =>
                            ref.read(liveProvider.notifier).basculerSuivi(p.id),
                        child: const Text('Suivre'),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/conversation'),
                  child: const Text('Écrire'),
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
            const EnTeteSection('Services à prix fixe'),
            for (final s in p.services)
              LigneMenu(
                icone: Icons.bolt_rounded,
                titre: s.titre,
                detail: 'Environ ${s.duree}',
                valeur: fcfa(s.prix),
                onTap: () => context.push('/pro/${p.id}/reserver/${s.id}'),
              ),
          ],
          const EnTeteSection('Réalisations'),
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
          const EnTeteSection('Avis vérifiés'),
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
          const BandeauProtection(
            'Acompte bloqué par Live, garantie 72 h après les travaux.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.push('/services/demande'),
          child: Text('Demander un devis à ${p.nom}'),
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
      appBar: AppBar(title: const Text('Réserver')),
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
                        '${p.nom} · ${p.metier} · environ ${s.duree}',
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
          const Text('Quand ?', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final j in const ["Aujourd'hui", 'Demain', 'Samedi'])
                ChoiceChip(
                  label: Text(j),
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
          const Text('Où ?', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _adresse,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              labelText: 'Adresse',
            ),
            onChanged: (v) => _adresse = v,
          ),
          const SizedBox(height: 18),
          LigneMontant('Prix du service', s.prix),
          const LigneMontant('Déplacement', 0),
          LigneMontant('Total', s.prix, gras: true),
          const SizedBox(height: 8),
          const BandeauProtection(
            'Payé maintenant, versé au prestataire quand vous confirmez la fin du service.',
          ),
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
                ? 'Choisissez une heure'
                : 'Réserver · ${fcfa(s.prix)}',
          ),
        ),
      ),
    );
  }
}
