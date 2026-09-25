part of 'market_screens.dart';

/// Blocs de « Mes ventes » : carte de commande, fiche détaillée (panneau du
/// bas), refus avec motif, menu latéral des outils, annonces à gérer.

(String, Color) _statutVente(StatutCommande s) => switch (s) {
  StatutCommande.payee ||
  StatutCommande.reservee => ('Nouvelle', LiveColors.cuivre),
  StatutCommande.acceptee ||
  StatutCommande.remise => ('À remettre', LiveColors.bleu),
  StatutCommande.terminee => ('Terminée', LiveColors.succes),
};

int _net(Commande v) => v.total - commission(v.total, 0.06, minimum: 100);

/// Carte d'une commande reçue : statut, produit, acheteur, brut et net,
/// actions compactes. Toucher la carte ouvre la fiche détaillée.
class _CarteVente extends ConsumerWidget {
  const _CarteVente({required this.vente, this.onAcceptee});
  final Commande vente;

  /// Après l'acceptation, l'écran suit la commande dans l'onglet « En cours ».
  final VoidCallback? onAcceptee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vente;
    final (statut, couleur) = _statutVente(v.statut);
    return Pressable(
      onTap: () => _ouvrirDetail(context, ref, v, onAcceptee),
      child: Bloc(
        padding: 14,
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
                          Etiquette(
                            statut,
                            fond: couleur.withValues(alpha: 0.12),
                            couleur: couleur,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              v.id,
                              maxLines: 1,
                              style: const TextStyle(
                                color: LiveColors.gris,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v.produit.titre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${v.acheteur} · ★ 4,9 · ${v.mode == ModePaiement.avance ? 'payée, argent bloqué' : 'à payer à la remise'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fcfa(v.total),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'net ${fcfa(_net(v))}',
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
              const Divider(height: 22),
              _ActionsVente(vente: v, onAcceptee: onAcceptee),
            ],
          ],
        ),
      ),
    );
  }
}

/// Refuser / Accepter, ou Remettre le produit.
class _ActionsVente extends ConsumerWidget {
  const _ActionsVente({required this.vente, this.onAcceptee, this.fermer});
  final Commande vente;
  final VoidCallback? onAcceptee;

  /// Ferme le panneau de détail avant d'agir, quand l'action vient de lui.
  final VoidCallback? fermer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vente;
    if (v.statut == StatutCommande.payee) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              fermer?.call();
              _refuser(context, ref, v);
            },
            child: const Text('Refuser'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(120, 40)),
            onPressed: () {
              fermer?.call();
              ref.read(liveProvider.notifier).accepterVente(v.id);
              onAcceptee?.call();
            },
            child: const Text('Accepter'),
          ),
        ],
      );
    }
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
        onPressed: () {
          fermer?.call();
          context.push('/vente/${v.id}');
        },
        icon: const Icon(Icons.qr_code_scanner, size: 18),
        label: const Text('Remettre le produit'),
      ),
    );
  }
}

/// Fiche détaillée d'une commande, en panneau du bas.
void _ouvrirDetail(
  BuildContext context,
  WidgetRef ref,
  Commande v,
  VoidCallback? onAcceptee,
) {
  final (statut, couleur) = _statutVente(v.statut);
  final etape = switch (v.statut) {
    StatutCommande.payee || StatutCommande.reservee => 0,
    StatutCommande.acceptee || StatutCommande.remise => 1,
    StatutCommande.terminee => 3,
  };
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, defilement) => ListView(
        controller: defilement,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Commande ${v.id}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Etiquette(
                statut,
                fond: couleur.withValues(alpha: 0.12),
                couleur: couleur,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Vignette(
              couleur: v.produit.couleur,
              icone: v.produit.icone,
              hauteur: 48,
              largeur: 48,
              rayon: 8,
            ),
            title: Text(v.produit.titre),
            subtitle: Text('Quantité 1 · ${v.produit.etat}'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Avatar(
              nom: v.acheteur ?? 'Client',
              couleur: LiveColors.bleu,
              taille: 44,
            ),
            title: Text(v.acheteur ?? 'Client'),
            subtitle: const Text('★ 4,9 · 12 achats · téléphone vérifié'),
            trailing: IconButton.outlined(
              tooltip: 'Écrire à l’acheteur',
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/conversation');
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
            ),
          ),
          const Divider(height: 20),
          const Text('Suivi', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (final (i, t) in const [
            'Payée · argent bloqué par Live',
            'Acceptée · remise à organiser',
            'Remise · QR de l’acheteur scanné',
            'Versée sur votre solde',
          ].indexed)
            Row(
              children: [
                Icon(
                  i <= etape
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: i <= etape ? LiveColors.succes : LiveColors.brume,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      t,
                      style: TextStyle(
                        color: i <= etape ? LiveColors.nuit : LiveColors.gris,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const Divider(height: 24),
          const LigneMenu(
            icone: Icons.handshake_outlined,
            titre: 'Remise en main propre',
            detail: 'Station Total Moungali · demain 10:00',
          ),
          LigneMontant('Montant payé par l’acheteur', v.total),
          LigneMontant(
            'Commission Live (6 %)',
            -commission(v.total, 0.06, minimum: 100),
          ),
          const Divider(),
          LigneMontant('Vous recevez', _net(v), gras: true),
          const SizedBox(height: 16),
          if (v.statut != StatutCommande.terminee)
            _ActionsVente(
              vente: v,
              onAcceptee: onAcceptee,
              fermer: () => Navigator.pop(ctx),
            ),
        ],
      ),
    ),
  );
}

/// Refus d'une commande : motif obligatoire, remboursement immédiat.
void _refuser(BuildContext context, WidgetRef ref, Commande v) {
  String? motif;
  showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, maj) => AlertDialog(
        title: const Text('Refuser la commande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${v.produit.titre} · ${v.acheteur}'),
            const SizedBox(height: 8),
            for (final m in const [
              'Rupture de stock',
              'Zone non desservie',
              'Autre raison',
            ])
              Choix(
                titre: m,
                selectionne: motif == m,
                onTap: () => maj(() => motif = m),
              ),
            const Text(
              'L’acheteur est remboursé immédiatement. Des refus répétés '
              'baissent votre visibilité.',
              style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: LiveColors.erreur),
            onPressed: motif == null
                ? null
                : () {
                    ref.read(liveProvider.notifier).refuserVente(v.id, motif!);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Commande refusée · ${v.acheteur} est remboursé.',
                        ),
                      ),
                    );
                  },
            child: const Text('Refuser'),
          ),
        ],
      ),
    ),
  );
}
