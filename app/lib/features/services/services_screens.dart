import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

/// E-SRV-01 — Accueil Services.
class EcranServices extends ConsumerWidget {
  const EcranServices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envoyee = ref.watch(liveProvider).demandeEnvoyee;
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LiveColors.fondProtection,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Text(
                  'Décrivez votre besoin et recevez des devis de pros vérifiés.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.push('/services/demande'),
                  child: const Text('Demander des devis'),
                ),
              ],
            ),
          ),
          if (envoyee)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.mark_email_unread,
                  color: LiveColors.bleu,
                ),
                title: const Text("Fuite d'eau cuisine"),
                subtitle: const Text('3 devis reçus'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/services/devis'),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Métiers',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final m in const [
                'Plombier',
                'Électricien',
                'Clim / Froid',
                'Réparation tél.',
                'Mécanicien',
                'Coiffure',
                'Maquillage',
                'Traiteur',
                'Déco',
                'Photo / Vidéo',
              ])
                ActionChip(
                  label: Text(m),
                  onPressed: () => context.push('/services/demande'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Disponibles maintenant',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          GrilleAdaptative(
            largeurMax: 460,
            enfants: [
              for (final s in prestataires)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: s.couleur,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text('${s.nom} · ${s.metier}'),
                  subtitle: Text(
                    '${note(s.note)} (${s.avis} avis) · ${s.zone}',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// E-SRV-03 — Demande de devis.
class EcranDemandeDevis extends ConsumerStatefulWidget {
  const EcranDemandeDevis({super.key});

  @override
  ConsumerState<EcranDemandeDevis> createState() => _EcranDemandeDevisState();
}

class _EcranDemandeDevisState extends ConsumerState<EcranDemandeDevis> {
  final _description = TextEditingController(
    text: "Fuite sous l'évier de la cuisine, l'eau coule en continu.",
  );
  var _metier = 'Plomberie';
  var _photos = 1;
  var _urgent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demander des devis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _metier,
            decoration: const InputDecoration(labelText: 'Métier'),
            items: const [
              DropdownMenuItem(value: 'Plomberie', child: Text('Plomberie')),
              DropdownMenuItem(
                value: 'Électricité',
                child: Text('Électricité'),
              ),
              DropdownMenuItem(
                value: 'Climatisation',
                child: Text('Climatisation'),
              ),
            ],
            onChanged: (v) => setState(() => _metier = v ?? _metier),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Décrivez le problème',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Photos (recommandé)'),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < _photos; i++)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Vignette(
                    couleur: Color(0xFF0369A1),
                    icone: Icons.water_drop,
                    hauteur: 60,
                    largeur: 60,
                    rayon: 8,
                  ),
                ),
              IconButton.outlined(
                tooltip: 'Ajouter une photo',
                onPressed: () => setState(() => _photos++),
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Quartier',
              hintText: 'Moungali',
            ),
          ),
          const SizedBox(height: 12),
          Choix(
            titre: 'Dès que possible',
            selectionne: _urgent,
            onTap: () => setState(() => _urgent = true),
          ),
          Choix(
            titre: 'À une date précise',
            selectionne: !_urgent,
            onTap: () => setState(() => _urgent = false),
          ),
          const Text(
            "Votre adresse exacte n'est donnée qu'au prestataire que vous choisirez.",
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            ref.read(liveProvider.notifier).envoyerDemande();
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Demande envoyée'),
                content: const Text(
                  'Envoyée à 12 pros vérifiés de votre quartier.\n\nPour le test : 3 devis sont arrivés.',
                ),
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(150, 44),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.pushReplacement('/services/devis');
                    },
                    child: const Text('Voir les devis'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Envoyer à des pros vérifiés'),
        ),
      ),
    );
  }
}

/// E-SRV-04 — Comparer les devis.
class EcranDevisRecus extends StatelessWidget {
  const EcranDevisRecus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fuite d'eau cuisine")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '3 devis reçus · expire dans 61 h',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          GrilleAdaptative(
            largeurMax: 480,
            enfants: [
              for (final d in devisRecus)
                Card(
                  child: InkWell(
                    onTap: () =>
                        context.push('/services/devis/${d.prestataire.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: d.prestataire.couleur,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${d.prestataire.nom} · ${note(d.prestataire.note)} (${d.prestataire.avis})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(d.quand),
                                Text(
                                  d.acompte == 0
                                      ? 'Payer à la fin'
                                      : 'Acompte ${fcfa(d.acompte)}',
                                  style: const TextStyle(
                                    color: LiveColors.gris,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            fcfa(d.total),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// E-SRV-05 — Détail du devis et acceptation.
class EcranDetailDevis extends ConsumerWidget {
  const EcranDetailDevis({super.key, required this.prestataireId});
  final String prestataireId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = devisRecus.firstWhere((d) => d.prestataire.id == prestataireId);
    final finSeule = d.acompte == 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Devis de ${d.prestataire.nom} · ${note(d.prestataire.note)}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Réparation fuite évier cuisine',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('${d.quand} · environ 1 h 30'),
          const Divider(height: 24),
          LigneMontant("Main-d'œuvre", d.mainOeuvre),
          LigneMontant('Matériel', d.materiel),
          LigneMontant('TOTAL', d.total, gras: true),
          const Divider(height: 24),
          if (finSeule)
            const Text(
              'Rien à payer maintenant : vous payez à la fin, par MoMo ou Airtel.',
            )
          else ...[
            LigneMontant('Maintenant (acompte)', d.acompte),
            LigneMontant('Après les travaux', d.total - d.acompte),
          ],
          const SizedBox(height: 8),
          const Text('Garantie 72 h · annulation gratuite jusqu\'à 2 h avant.'),
          const BoutonEcouter(
            "L'acompte est gardé par Live. Au démarrage des travaux, vous montrez votre QR au plombier : il reçoit alors la part matériel. Le reste lui est versé à la fin. Si le travail est mal fait, vous avez 72 heures pour le signaler.",
          ),
          const BandeauProtection(
            'Matériel payé au démarrage, le reste à la fin.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            final store = ref.read(liveProvider.notifier);
            store.preparerPaiement(
              PaiementEnCours(
                type: TypePaiement.acompte,
                montant: d.acompte,
                libelle: 'Acompte devis',
                beneficiaire: d.prestataire.nom,
                cibleId: d.prestataire.id,
              ),
            );
            if (finSeule) {
              final id = store.paiementReussi();
              context.go('/prestation/$id');
            } else {
              context.push('/payer');
            }
          },
          child: Text(
            finSeule
                ? 'Accepter le devis'
                : 'Accepter et payer ${fcfa(d.acompte)}',
          ),
        ),
      ),
    );
  }
}

/// E-SRV-07 — Suivi de la prestation (client).
class EcranPrestation extends ConsumerWidget {
  const EcranPrestation({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(liveProvider).prestations.firstWhere((p) => p.id == id);
    final d = p.devis;
    final store = ref.read(liveProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text('Prestation · ${d.prestataire.nom}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Réparation fuite · ${d.quand}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _Etape(
            d.acompte == 0
                ? 'Devis accepté (payer à la fin)'
                : 'Acompte payé (${fcfa(d.acompte)} bloqués)',
            true,
          ),
          _Etape('Travaux démarrés', p.statut != StatutPrestation.acompte),
          _Etape('Travaux terminés', p.statut == StatutPrestation.terminee),
          const SizedBox(height: 16),
          switch (p.statut) {
            StatutPrestation.acompte => Column(
              children: [
                CarteQr(
                  titre: 'Démarrer les travaux',
                  donnee: 'live://demarrage/${p.id}',
                  codeSecours: 'LV-D6042',
                  consigne: d.materiel > 0
                      ? 'À montrer quand ${d.prestataire.nom} commence : il reçoit ${fcfa(d.materiel)} (matériel).'
                      : 'À montrer quand ${d.prestataire.nom} commence.',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_location),
                  label: const Text('Partager avec un proche'),
                ),
                const SizedBox(height: 12),
                BoutonSimulation(
                  texte: '${d.prestataire.nom} scanne votre QR',
                  onTap: () => store.avancerPrestation(p.id),
                ),
              ],
            ),
            StatutPrestation.demarree => Column(
              children: [
                const Text('Travaux en cours…', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                BoutonSimulation(
                  texte: '${d.prestataire.nom} déclare la fin (avec photos)',
                  onTap: () => store.avancerPrestation(p.id),
                ),
              ],
            ),
            StatutPrestation.terminee => Column(
              children: [
                const CocheAnimee(taille: 64),
                Text(
                  'Travaux terminés. Reste à payer : ${fcfa(d.total - d.acompte)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Garantie : 72 h pour signaler un problème.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _fin(context),
                  child: const Text('Travaux conformes'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Signaler un problème'),
                ),
              ],
            ),
          },
        ],
      ),
    );
  }

  void _fin(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Merci !'),
        content: const Text(
          "Dans l'application réelle : le solde est payé par MoMo ou Airtel, le prestataire est payé, puis vous pouvez laisser un avis.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _Etape extends StatelessWidget {
  const _Etape(this.texte, this.fait);
  final String texte;
  final bool fait;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            fait ? Icons.check_circle : Icons.radio_button_unchecked,
            color: fait ? LiveColors.bleu : LiveColors.gris,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texte,
              style: TextStyle(
                fontSize: 16,
                color: fait ? Colors.black : LiveColors.gris,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
