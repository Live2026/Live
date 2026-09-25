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

/// E-MKT-02 — Fiche produit.
class EcranProduit extends StatelessWidget {
  const EcranProduit({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final p = produitParId(id);
    final entete = <Widget>[
      const SizedBox(height: 12),
      Text(
        p.titre,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          Text(
            fcfa(p.prix),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 10),
          if (p.negociable) const Chip(label: Text('négociable')),
        ],
      ),
      Text(
        '${p.quartier} · ${p.etat}',
        style: const TextStyle(color: LiveColors.gris),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: DeuxColonnes(
        principale: [
          Hero(
            tag: 'produit-${p.id}',
            child: Vignette(
              couleur: p.couleur,
              icone: p.icone,
              hauteur: context.grandEcran ? 380 : 260,
              video: true,
            ),
          ),
          if (!context.grandEcran) ...entete,
          const Divider(height: 28),
          for (final e in p.details.entries)
            LigneMontant(e.key, 0, brut: e.value),
          const SizedBox(height: 8),
          const Text('Remise', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('• En main propre (${p.quartier}) : gratuit'),
          if (p.livraison > 0)
            Text('• Livraison Brazzaville : ${fcfa(p.livraison)}'),
          const SizedBox(height: 8),
          Text(p.description),
        ],
        secondaire: [
          if (context.grandEcran) ...entete else const Divider(height: 28),
          if (context.grandEcran) const Divider(height: 28),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.store)),
            title: Text(
              p.vendeur.nom,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BadgeVerifie(p.vendeur.badge),
                Text(
                  '${note(p.vendeur.note)} · ${p.vendeur.ventes} ventes via Live',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const BandeauProtection(
            'Remboursé si vous ne recevez pas le produit.',
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
                onPressed: () => context.push('/commande/${p.id}'),
                child: const Text('Acheter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// E-MKT-04 — Récapitulatif de la commande.
class EcranCommande extends ConsumerStatefulWidget {
  const EcranCommande({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranCommande> createState() => _EcranCommandeState();
}

class _EcranCommandeState extends ConsumerState<EcranCommande> {
  var _livraison = false;
  var _mode = ModePaiement.avance;

  @override
  Widget build(BuildContext context) {
    final p = produitParId(widget.id);
    final total = p.prix + (_livraison ? p.livraison : 0);
    return Scaffold(
      appBar: AppBar(title: const Text('Votre commande')),
      body: DeuxColonnes(
        principale: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Vignette(
              couleur: p.couleur,
              icone: p.icone,
              hauteur: 50,
              largeur: 50,
              rayon: 8,
            ),
            title: Text(p.titre),
            trailing: Text(
              fcfa(p.prix),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Remise',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: 'En main propre · ${p.quartier}',
            icone: Icons.handshake,
            selectionne: !_livraison,
            onTap: () => setState(() => _livraison = false),
          ),
          if (p.livraison > 0)
            Choix(
              titre: 'Livraison',
              icone: Icons.delivery_dining,
              trailing: '+ ${fcfa(p.livraison)}',
              selectionne: _livraison,
              onTap: () => setState(() => _livraison = true),
            ),
          if (_livraison)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                decoration: InputDecoration(hintText: 'Adresse ou repère…'),
              ),
            ),
          const SizedBox(height: 8),
        ],
        secondaire: [
          const Text(
            'Paiement',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: 'Payer maintenant',
            sousTitre: "Argent bloqué jusqu'à réception.",
            icone: Icons.lock_clock,
            selectionne: _mode == ModePaiement.avance,
            onTap: () => setState(() => _mode = ModePaiement.avance),
          ),
          Choix(
            titre: 'Payer à la remise',
            sousTitre: 'MoMo ou Airtel, produit en main.',
            icone: Icons.phone_android,
            selectionne: _mode == ModePaiement.remise,
            onTap: () => setState(() => _mode = ModePaiement.remise),
          ),
          const BoutonEcouter(
            "Payer maintenant : vous payez tout de suite, mais Live garde l'argent. Le vendeur ne le reçoit que quand vous avez le produit en main. "
            "Payer à la remise : vous ne payez rien maintenant. Au moment où vous recevez le produit, vous validez le paiement MoMo ou Airtel sur votre téléphone.",
          ),
          const Divider(height: 24),
          LigneMontant('Total à payer', total, gras: true),
          const Text(
            'Aucun frais supplémentaire.',
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            final store = ref.read(liveProvider.notifier);
            if (_mode == ModePaiement.avance) {
              store.preparerPaiement(
                PaiementEnCours(
                  type: TypePaiement.commande,
                  montant: total,
                  libelle: p.titre,
                  beneficiaire: p.vendeur.nom,
                  cibleId: p.id,
                ),
              );
              context.push('/payer');
            } else {
              final id = store.reserverCommande(p, total);
              context.go('/suivi/$id');
            }
          },
          child: const Text('Continuer'),
        ),
      ),
    );
  }
}

/// E-MKT-05 — Suivi de commande (acheteur) : produit, frise, QR de confirmation.
class EcranSuiviCommande extends ConsumerWidget {
  const EcranSuiviCommande({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(liveProvider).achats.firstWhere((c) => c.id == id);
    final termine = c.statut == StatutCommande.terminee;
    final remise = c.mode == ModePaiement.remise;
    final etapes = <EtapeFrise>[
      EtapeFrise(
        remise ? 'Commande réservée' : 'Payée · argent bloqué par Live',
        "Aujourd'hui 10:21",
        true,
      ),
      const EtapeFrise('Acceptée par le vendeur', "Aujourd'hui 10:34", true),
      EtapeFrise(
        remise ? 'Payée à la remise' : 'Réception confirmée',
        termine ? "À l'instant" : 'En attente de la remise',
        termine,
      ),
    ];
    final entete = Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Hero(
              tag: 'produit-${c.produit.id}',
              child: Vignette(
                couleur: c.produit.couleur,
                icone: c.produit.icone,
                hauteur: 64,
                largeur: 64,
                rayon: 8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.produit.titre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    c.produit.vendeur.nom,
                    style: const TextStyle(color: LiveColors.gris),
                  ),
                ],
              ),
            ),
            Text(
              fcfa(c.total),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Commande ${c.id}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/conversation'),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Écrire'),
          ),
        ],
      ),
      body: DeuxColonnes(
        principale: [
          Apparition(child: entete),
          const SizedBox(height: 20),
          Apparition(rang: 1, child: Frise(etapes: etapes)),
          const SizedBox(height: 12),
          if (!termine && !remise)
            const Apparition(
              rang: 2,
              child: BandeauProtection(
                "Votre argent est bloqué jusqu'à votre confirmation.",
              ),
            ),
        ],
        secondaire: [
          if (termine) ...[
            const SizedBox(height: 8),
            const Center(child: CocheAnimee()),
            const SizedBox(height: 12),
            Text(
              remise
                  ? 'Paiement reçu. Merci !'
                  : 'Réception confirmée. Le vendeur est payé.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => _avis(context),
              child: const Text('Laisser un avis'),
            ),
          ] else if (!remise) ...[
            Apparition(
              rang: 2,
              child: CarteQr(
                titre: 'Confirmer la remise',
                donnee: 'live://remise/${c.id}',
                codeSecours: 'LV-K4827',
                consigne:
                    'Montrez-le au vendeur quand vous avez vérifié le produit.',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () =>
                  ref.read(liveProvider.notifier).confirmerReception(c.id),
              child: const Text("J'ai reçu le produit"),
            ),
            TextButton(
              onPressed: () => _probleme(context),
              child: const Text('Signaler un problème'),
            ),
            const SizedBox(height: 8),
            BoutonSimulation(
              texte: 'Simuler : le vendeur scanne votre QR',
              onTap: () =>
                  ref.read(liveProvider.notifier).confirmerReception(c.id),
            ),
          ] else ...[
            Text(
              'Vérifiez le produit, puis payez.',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              "Le vendeur vous enverra une demande MoMo ou Airtel. Elle n'arrive pas ? Payez vous-même :",
              style: TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                ref
                    .read(liveProvider.notifier)
                    .preparerPaiement(
                      PaiementEnCours(
                        type: TypePaiement.commande,
                        montant: c.total,
                        libelle: c.produit.titre,
                        beneficiaire: c.produit.vendeur.nom,
                        cibleId: c.id,
                        modeCommande: ModePaiement.remise,
                      ),
                    );
                context.push('/payer');
              },
              child: Text('Payer maintenant ${fcfa(c.total)}'),
            ),
          ],
        ],
      ),
    );
  }

  void _avis(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => const _FeuilleAvis(),
    );
  }

  void _probleme(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Un problème ?'),
        content: const Text(
          "Vous pourrez décrire le problème et joindre des photos. L'argent reste bloqué jusqu'à la solution.\n\n(Écran de réclamation non inclus dans ce prototype.)",
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

class _FeuilleAvis extends StatefulWidget {
  const _FeuilleAvis();

  @override
  State<_FeuilleAvis> createState() => _FeuilleAvisState();
}

class _FeuilleAvisState extends State<_FeuilleAvis> {
  var _note = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Votre avis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _note = i),
                  icon: Icon(
                    i <= _note ? Icons.star : Icons.star_border,
                    color: LiveColors.ambre,
                    size: 36,
                  ),
                ),
            ],
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Votre commentaire (facultatif)',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _note == 0 ? null : () => Navigator.pop(context),
            child: const Text("Publier l'avis"),
          ),
        ],
      ),
    );
  }
}

/// E-MKT-07 — Mes ventes (vendeur) : chiffres clés, onglets, commandes.
class EcranMesVentes extends ConsumerStatefulWidget {
  const EcranMesVentes({super.key});

  @override
  ConsumerState<EcranMesVentes> createState() => _EcranMesVentesState();
}

class _EcranMesVentesState extends ConsumerState<EcranMesVentes> {
  var _onglet = 0; // 0 à traiter, 1 en cours, 2 terminées

  static int _rang(StatutCommande s) => switch (s) {
    StatutCommande.payee || StatutCommande.reservee => 0,
    StatutCommande.acceptee || StatutCommande.remise => 1,
    StatutCommande.terminee => 2,
  };

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final ventes = etat.ventes;
    final nombre = [
      for (var i = 0; i < 3; i++)
        ventes.where((v) => _rang(v.statut) == i).length,
    ];
    final visibles = ventes.where((v) => _rang(v.statut) == _onglet).toList();
    final ceMois = ventes
        .where((v) => v.statut == StatutCommande.terminee)
        .fold(0, (s, v) => s + v.total);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes ventes'),
        actions: [
          IconButton(
            tooltip: 'Statistiques',
            onPressed: () {},
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          _BandeauChiffres(
            chiffres: [
              _Chiffre(
                libelle: 'Ce mois',
                valeur: ceMois,
                format: (n) => fcfa(n, devise: false),
                unite: 'FCFA',
                icone: Icons.trending_up,
              ),
              _Chiffre(
                libelle: 'En attente',
                valeur: 96000,
                format: (n) => fcfa(n, devise: false),
                unite: 'FCFA',
                icone: Icons.lock_clock_outlined,
              ),
              _Chiffre(
                libelle: 'Note clients',
                valeur: 48,
                format: (n) => (n / 10).toStringAsFixed(1).replaceAll('.', ','),
                unite: 'sur 5',
                icone: Icons.star_rounded,
                couleurIcone: LiveColors.cuivre,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                for (final (i, t) in const [
                  'À traiter',
                  'En cours',
                  'Terminées',
                ].indexed)
                  ButtonSegment(
                    value: i,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('$t · ${nombre[i]}', maxLines: 1),
                    ),
                  ),
              ],
              selected: {_onglet},
              onSelectionChanged: (s) => setState(() => _onglet = s.first),
            ),
          ),
          const SizedBox(height: 16),
          if (visibles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: LiveColors.gris,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _onglet == 0
                        ? 'Aucune commande à traiter.'
                        : 'Rien ici pour le moment.',
                    style: const TextStyle(color: LiveColors.gris),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => context.push('/vendre'),
                    icon: const Icon(Icons.add),
                    label: const Text('Publier une annonce'),
                  ),
                ],
              ),
            )
          else
            GrilleAdaptative(
              largeurMax: 560,
              enfants: [
                for (final (i, v) in visibles.indexed)
                  Apparition(
                    rang: i,
                    child: _CarteVente(
                      vente: v,
                      onAcceptee: () => setState(() => _onglet = 1),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Les chiffres clés du vendeur, en une seule bande à 3 colonnes.
class _BandeauChiffres extends StatelessWidget {
  const _BandeauChiffres({required this.chiffres});
  final List<_Chiffre> chiffres;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (final (i, c) in chiffres.indexed) ...[
              if (i > 0)
                const VerticalDivider(width: 1, color: LiveColors.brume),
              Expanded(child: c),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chiffre extends StatelessWidget {
  const _Chiffre({
    required this.libelle,
    required this.valeur,
    required this.format,
    required this.unite,
    required this.icone,
    this.couleurIcone = LiveColors.bleu,
  });
  final String libelle;
  final int valeur;
  final String Function(int) format;
  final String unite;
  final IconData icone;
  final Color couleurIcone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 16, color: couleurIcone),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  libelle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: ChiffreAnime(
              valeur: valeur,
              format: format,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            unite,
            style: const TextStyle(color: LiveColors.gris, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _CarteVente extends ConsumerWidget {
  const _CarteVente({required this.vente, this.onAcceptee});
  final Commande vente;

  /// Après l'acceptation, l'écran suit la commande dans l'onglet « En cours ».
  final VoidCallback? onAcceptee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vente;
    final net = v.total - commission(v.total, 0.06, minimum: 100);
    final (statut, couleur) = switch (v.statut) {
      StatutCommande.payee ||
      StatutCommande.reservee => ('Nouvelle', LiveColors.orangeVif),
      StatutCommande.acceptee ||
      StatutCommande.remise => ('À remettre', LiveColors.bleu),
      StatutCommande.terminee => ('Terminée', LiveColors.succes),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Vignette(
                  couleur: v.produit.couleur,
                  icone: v.produit.icone,
                  hauteur: 56,
                  largeur: 56,
                  rayon: 8,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: couleur.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statut,
                              style: TextStyle(
                                color: couleur == LiveColors.orangeVif
                                    ? LiveColors.cuivre
                                    : couleur,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            v.id,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v.produit.titre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${v.acheteur} (4,9/5) · Payée, argent bloqué',
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fcfa(v.total),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'net ${fcfa(net)}',
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (v.statut != StatutCommande.terminee) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (v.statut == StatutCommande.payee) ...[
                    TextButton(onPressed: () {}, child: const Text('Refuser')),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(120, 40),
                      ),
                      onPressed: () {
                        ref.read(liveProvider.notifier).accepterVente(v.id);
                        onAcceptee?.call();
                      },
                      child: const Text('Accepter'),
                    ),
                  ] else
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 40),
                      ),
                      onPressed: () => context.push('/vente/${v.id}'),
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('Remettre le produit'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// E-MKT-08 — Remettre la commande (vendeur).
class EcranRemise extends ConsumerWidget {
  const EcranRemise({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(liveProvider).ventes.firstWhere((v) => v.id == id);
    final net = v.total - commission(v.total, 0.06, minimum: 100);
    final termine = v.statut == StatutCommande.terminee;
    return Scaffold(
      appBar: AppBar(title: Text('Commande ${v.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${v.produit.titre} · ${fcfa(v.total)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Acheteur : ${v.acheteur}'),
          const SizedBox(height: 24),
          if (termine) ...[
            const CocheAnimee(taille: 72),
            Text(
              'Remise confirmée.\n${fcfa(net)} ajoutés à vos gains.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/gains'),
              child: const Text('Voir mes gains'),
            ),
          ] else ...[
            const Text(
              "Au moment de la remise, scannez le QR que l'acheteur vous montre.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                if (await simulerScan(context, quoi: "de l'acheteur")) {
                  ref.read(liveProvider.notifier).remettreVente(v.id);
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scanner le QR de l'acheteur"),
            ),
            TextButton(
              onPressed: () => _codeSecours(context, ref, v.id),
              child: const Text('Saisir le code LV- à la place'),
            ),
          ],
        ],
      ),
      bottomNavigationBar: termine
          ? null
          : BarreAction(
              child: Text(
                'Vous recevrez ${fcfa(net)}\n(${fcfa(v.total)} - 6 % de commission Live)',
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  void _codeSecours(BuildContext context, WidgetRef ref, String id) {
    final ctrl = TextEditingController(text: 'LV-');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Code de secours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Demandez à l'acheteur le code affiché sous son QR (ex. LV-K4827).",
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(liveProvider.notifier).remettreVente(id);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}

/// E-PUB-03 — Vendre un produit (formulaire unique).
class EcranVendre extends ConsumerStatefulWidget {
  const EcranVendre({super.key});

  @override
  ConsumerState<EcranVendre> createState() => _EcranVendreState();
}

class _EcranVendreState extends ConsumerState<EcranVendre> {
  final _titre = TextEditingController();
  final _prix = TextEditingController();
  var _photos = 0;
  var _etat = 'Très bon état';

  @override
  Widget build(BuildContext context) {
    final prix = int.tryParse(_prix.text.replaceAll(' ', '')) ?? 0;
    final valide = _titre.text.trim().isNotEmpty && prix > 0 && _photos > 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Vendre un produit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              for (var i = 0; i < _photos; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Vignette(
                    couleur: Colors.primaries[i * 3 % 18],
                    icone: Icons.image,
                    hauteur: 64,
                    largeur: 64,
                    rayon: 8,
                  ),
                ),
              Semantics(
                button: true,
                label: 'Ajouter une photo',
                child: InkWell(
                  onTap: () => setState(() => _photos++),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(color: LiveColors.bleu, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      color: LiveColors.bleu,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 12),
            child: Text(
              'Prototype : chaque appui ajoute une photo fictive.',
              style: TextStyle(color: LiveColors.gris, fontSize: 12),
            ),
          ),
          TextField(
            controller: _titre,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Ex. iPhone 11 64 Go',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prix,
            decoration: const InputDecoration(
              labelText: 'Prix',
              suffixText: 'FCFA',
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final e in const [
                'Neuf',
                'Très bon état',
                'Bon état',
                'À réparer',
              ])
                ChoiceChip(
                  label: Text(e),
                  selected: _etat == e,
                  onSelected: (_) => setState(() => _etat = e),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(labelText: 'Description (facultatif)'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          if (prix > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LiveColors.fondProtection,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Vous recevrez ${fcfa(prix)} par vente pendant votre offre de lancement (0 % de commission), '
                'puis ${fcfa(prix - commission(prix, 0.06, minimum: 100))} (6 % de commission Live).',
              ),
            ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: valide
              ? () {
                  ref
                      .read(liveProvider.notifier)
                      .publier(_titre.text.trim(), prix);
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Annonce publiée'),
                      content: const Text(
                        'Votre annonce est en ligne.\n\nPour le test : une acheteuse (Merveille) vient de la commander et de payer.',
                      ),
                      actions: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(160, 44),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.go('/mes-ventes');
                          },
                          child: const Text('Voir mes ventes'),
                        ),
                      ],
                    ),
                  );
                }
              : null,
          child: const Text('Publier'),
        ),
      ),
    );
  }
}
