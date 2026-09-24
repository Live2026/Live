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

/// E-IMMO-01 + E-IMMO-02 — Accueil Immo : filtres rapides et grille de logements.
class EcranImmo extends StatefulWidget {
  const EcranImmo({super.key});

  @override
  State<EcranImmo> createState() => _EcranImmoState();
}

class _EcranImmoState extends State<EcranImmo> {
  static const _budgets = [
    (null, 'Tous les prix'),
    (50000, '< 50 000'),
    (100000, '< 100 000'),
    (200000, '< 200 000'),
  ];
  int? _loyerMax;
  String? _quartier;

  @override
  Widget build(BuildContext context) {
    final quartiers = {for (final b in biens) b.quartier}.toList()..sort();
    final liste = biens
        .where(
          (b) =>
              (_loyerMax == null || b.loyer <= _loyerMax!) &&
              (_quartier == null || b.quartier == _quartier),
        )
        .toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Immo'),
        actions: [
          IconButton(
            tooltip: 'Créer une alerte',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const BoutonMessages(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: marge, vertical: 8),
                children: [
                  for (final (valeur, libelle) in _budgets)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(libelle),
                        selected: _loyerMax == valeur,
                        onSelected: (_) => setState(() => _loyerMax = valeur),
                      ),
                    ),
                  const SizedBox(width: 8),
                  for (final q in quartiers)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(q),
                        selected: _quartier == q,
                        onSelected: (v) =>
                            setState(() => _quartier = v ? q : null),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${liste.length} logements vérifiés · Brazzaville',
                style: const TextStyle(color: LiveColors.gris),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(marge, 0, marge, 24),
            // 2 colonnes sur téléphone, 3 sur tablette, 4 et plus sur ordinateur ;
            // chaque rangée prend la hauteur réelle de ses cartes (pas de vide).
            sliver: SliverToBoxAdapter(
              child: GrilleAdaptative(
                largeurMax: context.grandEcran ? 280 : 200,
                espacement: 14,
                enfants: [
                  for (final (i, b) in liste.indexed)
                    Apparition(
                      rang: i,
                      child: CarteBien(bien: b),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte de logement : photo en 4:3 avec prix et badge, puis l'essentiel.
class CarteBien extends StatelessWidget {
  const CarteBien({super.key, required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    return Pressable(
      onTap: () => context.push('/bien/${b.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'bien-${b.id}',
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Vignette(
                    couleur: b.couleur,
                    icone: Icons.home_rounded,
                    hauteur: 200,
                    video: true,
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _Etiquette(
                      icone: Icons.verified,
                      texte: b.annonceur.badge.startsWith('Agence')
                          ? 'Agence vérifiée'
                          : 'Vérifié',
                    ),
                  ),
                  const Positioned(
                    right: 6,
                    top: 6,
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${b.titre} · ${b.quartier}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, height: 1.25),
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: fcfa(b.loyer),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const TextSpan(
                  text: ' /mois',
                  style: TextStyle(color: LiveColors.gris),
                ),
              ],
            ),
          ),
          Text(
            'Entrée ${fcfa(b.coutEntree)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: LiveColors.bleu, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _Etiquette extends StatelessWidget {
  const _Etiquette({required this.icone, required this.texte});
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 13, color: LiveColors.bleu),
          const SizedBox(width: 3),
          Text(
            texte,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: LiveColors.nuit,
            ),
          ),
        ],
      ),
    );
  }
}

/// E-IMMO-03 — Fiche logement.
class EcranBien extends StatelessWidget {
  const EcranBien({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final b = bienParId(id);
    return Scaffold(
      appBar: AppBar(),
      body: DeuxColonnes(
        principale: [
          Hero(
            tag: 'bien-${b.id}',
            child: Vignette(
              couleur: b.couleur,
              icone: Icons.home_rounded,
              hauteur: context.grandEcran ? 360 : 240,
              video: true,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${b.titre} · ${b.quartier}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Disponibilité confirmée il y a ${b.confirmeIlYa} jours',
            style: const TextStyle(color: LiveColors.gris),
          ),
          const Divider(height: 24),
          LigneMontant('Loyer', b.loyer, brut: '${fcfa(b.loyer)} / mois'),
          LigneMontant('Avance (${b.moisAvance} mois)', b.avance),
          LigneMontant('Caution (${b.moisCaution} mois)', b.caution),
          LigneMontant('Commission', b.commission),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: LiveColors.fondProtection,
              borderRadius: BorderRadius.circular(8),
            ),
            child: LigneMontant(
              "COÛT D'ENTRÉE TOTAL",
              b.coutEntree,
              gras: true,
            ),
          ),
          LigneMontant('Frais de visite', b.fraisVisite),
        ],
        secondaire: [
          const Divider(height: 24),
          for (final c in b.caracteristiques)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $c'),
            ),
          Text('• Repère : ${b.repere}'),
          const Text(
            'Adresse exacte après réservation de la visite.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const Divider(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.apartment)),
            title: Text(
              b.annonceur.nom,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BadgeVerifie(b.annonceur.badge),
                Text(
                  '${note(b.annonceur.note)} · ${b.annonceur.ventes} logements loués via Live',
                ),
              ],
            ),
          ),
          const BandeauProtection(
            "Ne payez jamais de frais ou d'avance hors de Live.",
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/conversation'),
                child: const Text('Écrire'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => context.push('/bien/${b.id}/visite'),
                child: const Text('Demander une visite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// E-IMMO-04 — Choisir un créneau et payer la visite.
class EcranReserverVisite extends ConsumerStatefulWidget {
  const EcranReserverVisite({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranReserverVisite> createState() =>
      _EcranReserverVisiteState();
}

class _EcranReserverVisiteState extends ConsumerState<EcranReserverVisite> {
  var _jour = 'Mar 30';
  String? _heure;

  @override
  Widget build(BuildContext context) {
    final b = bienParId(widget.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Demander une visite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${b.titre} · ${b.quartier}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Choisissez un jour'),
          Wrap(
            spacing: 8,
            children: [
              for (final j in const ['Lun 29', 'Mar 30', 'Mer 1', 'Jeu 2'])
                ChoiceChip(
                  label: Text(j),
                  selected: _jour == j,
                  onSelected: (_) => setState(() => _jour = j),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Choisissez une heure'),
          Wrap(
            spacing: 8,
            children: [
              for (final h in const [
                '09:00',
                '10:30',
                '14:00',
                '15:30',
                '17:00',
              ])
                ChoiceChip(
                  label: Text(h),
                  selected: _heure == h,
                  onSelected: (_) => setState(() => _heure = h),
                ),
            ],
          ),
          const Divider(height: 32),
          LigneMontant('Frais de visite', b.fraisVisite, gras: true),
          const SizedBox(height: 8),
          const Text(
            "• L'annonceur ne vient pas ou le bien n'est plus libre : vous êtes remboursé.\n• Vous ne venez pas : les frais sont versés à l'annonceur.",
          ),
          const BoutonEcouter(
            "Vous payez les frais de visite maintenant, mais Live les garde. L'annonceur ne les reçoit qu'après la visite, quand il scanne votre QR. S'il ne vient pas, ou si le logement n'est plus libre, vous êtes remboursé. Si c'est vous qui ne venez pas, les frais lui sont versés.",
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
                          type: TypePaiement.visite,
                          montant: b.fraisVisite,
                          libelle: 'Visite ${b.titre}',
                          beneficiaire: b.annonceur.nom,
                          cibleId: b.id,
                          creneau: '$_jour · $_heure',
                        ),
                      );
                  context.push('/payer');
                },
          child: Text(
            _heure == null
                ? 'Choisissez un créneau'
                : 'Payer ${fcfa(b.fraisVisite)}',
          ),
        ),
      ),
    );
  }
}

/// E-IMMO-05 — Ma visite (chercheur).
class EcranVisite extends ConsumerWidget {
  const EcranVisite({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(liveProvider).visites.firstWhere((v) => v.id == id);
    final confirmee = v.statut == StatutVisite.confirmee;
    return Scaffold(
      appBar: AppBar(
        title: Text('Visite · ${v.creneau}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${v.bien.titre} · ${v.bien.quartier}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            confirmee ? 'Visite effectuée' : 'Statut : réservée et payée',
            style: const TextStyle(color: LiveColors.bleu),
          ),
          const Divider(height: 24),
          const Text(
            'Adresse exacte',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '12, rue Mbochis, ${v.bien.quartier}\nRepère : ${v.bien.repere}',
          ),
          const SizedBox(height: 8),
          const Text(
            'Votre contact',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Christian · ${v.bien.annonceur.nom} · 06 555 44 33'),
          const SizedBox(height: 16),
          if (confirmee) ...[
            const CocheAnimee(taille: 64),
            const Text(
              "Visite confirmée. Si le logement vous plaît, l'agence peut vous envoyer une offre de réservation.",
              textAlign: TextAlign.center,
            ),
          ] else ...[
            CarteQr(
              titre: 'Confirmer la visite',
              donnee: 'live://visite/${v.id}',
              codeSecours: 'LV-V3915',
              consigne: "Montrez-le à l'agent sur place.",
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Le bien ne correspond pas'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Annuler la visite'),
            ),
            const SizedBox(height: 12),
            BoutonSimulation(
              texte: "Simuler : l'agent scanne votre QR",
              onTap: () =>
                  ref.read(liveProvider.notifier).confirmerVisite(v.id),
            ),
          ],
        ],
      ),
    );
  }
}
