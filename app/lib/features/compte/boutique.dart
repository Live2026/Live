part of 'compte_screens.dart';

/// E-MKT-06 — Page boutique ou agence : vitrine publique d'un espace vérifié.
class EcranBoutique extends StatelessWidget {
  const EcranBoutique({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final v = vendeurParId(id);
    final prods = produitsDe(v);
    final lesBiens = biensDe(v);
    final savoirs = contenus.where((c) => c.auteur.id == v.id).toList();
    final offres = opportunites
        .where((o) => o.organisation.id == v.id)
        .toList();
    return _PageProfil(
      nom: v.nom,
      pseudo: '@${v.id}',
      couleur: v.couleur,
      badge: v.badge,
      bio: v.bio,
      stats: [
        (compact(v.abonnes), 'Abonnés'),
        ('${v.ventes}', lesBiens.isEmpty ? 'Ventes' : 'Locations'),
        (note(v.note).replaceAll('/5', ''), 'Note'),
        (v.reponse, 'Répond en'),
      ],
      idSuivi: v.id,
      onglets: [
        if (savoirs.isNotEmpty)
          (
            'Contenus',
            GrilleAdaptative(
              largeurMax: 260,
              espacement: 12,
              enfants: [for (final c in savoirs) CarteContenu(contenu: c)],
            ),
          )
        else if (offres.isNotEmpty)
          (
            'Opportunités',
            GrilleAdaptative(
              largeurMax: 420,
              espacement: 12,
              enfants: [
                for (final o in offres) CarteOpportunite(opportunite: o),
              ],
            ),
          )
        else
          (
            lesBiens.isEmpty ? 'Produits' : 'Biens',
            lesBiens.isEmpty
                ? GrilleAdaptative(
                    largeurMax: 200,
                    espacement: 12,
                    enfants: [for (final p in prods) CarteProduit(produit: p)],
                  )
                : GrilleAdaptative(
                    largeurMax: 220,
                    espacement: 12,
                    enfants: [for (final b in lesBiens) CarteBien(bien: b)],
                  ),
          ),
        ('Vidéos', _GrilleVideos(couleur: v.couleur)),
        ('Avis', const _ListeAvis()),
      ],
      infos: [
        (Icons.location_on_outlined, '${v.quartier}, Brazzaville'),
        (Icons.calendar_month_outlined, 'Sur Live depuis ${v.depuis}'),
        (Icons.local_shipping_outlined, 'Livraison ou remise en main propre'),
      ],
    );
  }
}
