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
        (compact(v.abonnes), context.t.compteAbonnes),
        (
          '${v.ventes}',
          lesBiens.isEmpty ? context.t.compteVentes : context.t.compteLocations,
        ),
        (note(v.note).replaceAll('/5', ''), context.t.compteNote),
        (v.reponse, context.t.compteRepondEn),
      ],
      idSuivi: v.id,
      onglets: [
        if (savoirs.isNotEmpty)
          (
            context.t.compteContenus,
            GrilleAdaptative(
              largeurMax: 260,
              espacement: 12,
              enfants: [for (final c in savoirs) CarteContenu(contenu: c)],
            ),
          )
        else if (offres.isNotEmpty)
          (
            context.t.compteOpportunites,
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
            lesBiens.isEmpty ? context.t.compteProduits : context.t.compteBiens,
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
        (context.t.compteVideos, _GrilleVideos(couleur: v.couleur)),
        (context.t.compteAvis, const _ListeAvis()),
      ],
      infos: [
        (Icons.location_on_outlined, context.t.compteQuartierVille(v.quartier)),
        (
          Icons.calendar_month_outlined,
          context.t.compteSurLiveDepuis(v.depuis),
        ),
        (Icons.local_shipping_outlined, context.t.compteLivraisonOuRemiseEn),
      ],
    );
  }
}
