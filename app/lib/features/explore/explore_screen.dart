import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

/// E-EXP-01 — Explorer : les verticales, Live IA et les sélections du moment.
class EcranExplorer extends StatelessWidget {
  const EcranExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          readOnly: true,
          onTap: () => context.push('/recherche'),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Rechercher sur Live…',
          ),
        ),
        actions: const [BoutonMessages()],
      ),
      body: ListView(
        padding: EdgeInsets.all(marge),
        children: [
          GrilleAdaptative(
            largeurMax: 260,
            enfants: [
              _Tuile(
                titre: 'Market',
                sous: 'Acheter et vendre',
                icone: Icons.shopping_bag,
                onTap: () => context.push('/recherche'),
              ),
              _Tuile(
                titre: 'Immo',
                sous: 'Louer, acheter',
                icone: Icons.home_work,
                onTap: () => context.push('/immo'),
              ),
              _Tuile(
                titre: 'Services',
                sous: 'Trouver un pro',
                icone: Icons.handyman,
                onTap: () => context.push('/services'),
              ),
              _Tuile(
                titre: 'Live IA',
                sous: 'CV, exercices, business plan',
                icone: Icons.auto_awesome,
                onTap: () => context.go('/ia'),
              ),
            ],
          ),
          const _Titre('Bonnes affaires près de vous'),
          GrilleAdaptative(
            largeurMax: 220,
            espacement: 14,
            enfants: [
              for (final (i, p) in produits.indexed)
                Apparition(
                  rang: i,
                  child: CarteProduitGrille(produit: p),
                ),
            ],
          ),
          const _Titre('Nouveaux logements vérifiés'),
          GrilleAdaptative(
            largeurMax: 460,
            enfants: [
              for (final b in biens)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Vignette(
                    couleur: b.couleur,
                    icone: Icons.home,
                    hauteur: 50,
                    largeur: 60,
                    rayon: 8,
                  ),
                  title: Text('${b.titre} · ${b.quartier}'),
                  subtitle: Text(
                    '${fcfa(b.loyer)}/mois · entrée ${fcfa(b.coutEntree)}',
                  ),
                  onTap: () => context.push('/bien/${b.id}'),
                ),
            ],
          ),
          const _Titre("Pros disponibles aujourd'hui"),
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
                  subtitle: Text('${note(s.note)} · ${s.zone}'),
                  onTap: () => context.push('/services'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tuile extends StatelessWidget {
  const _Tuile({
    required this.titre,
    required this.sous,
    required this.icone,
    required this.onTap,
  });
  final String titre;
  final String sous;
  final IconData icone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 112),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EBF2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icone, color: LiveColors.bleu),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    sous,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        texte,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// E-EXP-03 — Résultats de recherche Market.
class EcranRecherche extends StatefulWidget {
  const EcranRecherche({super.key});

  @override
  State<EcranRecherche> createState() => _EcranRechercheState();
}

class _EcranRechercheState extends State<EcranRecherche> {
  var _texte = '';

  @override
  Widget build(BuildContext context) {
    final resultats = produits
        .where((p) => p.titre.toLowerCase().contains(_texte.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Ex. climatiseur, iPhone…',
          ),
          onChanged: (v) => setState(() => _texte = v),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(context.grandEcran ? 24 : 16),
        children: [
          Text(
            '${resultats.length} résultats · Brazzaville',
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          GrilleAdaptative(
            largeurMax: 220,
            espacement: 14,
            enfants: [
              for (final (i, p) in resultats.indexed)
                Apparition(
                  rang: i,
                  child: CarteProduitGrille(produit: p),
                ),
            ],
          ),
          if (resultats.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Aucun résultat. Créez une alerte : nous vous préviendrons.',
              ),
            ),
        ],
      ),
    );
  }
}

/// Carte d'annonce produit (composant 5.2).
class CarteProduit extends StatelessWidget {
  const CarteProduit({super.key, required this.produit});
  final Produit produit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/produit/${produit.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Vignette(
              couleur: produit.couleur,
              icone: produit.icone,
              hauteur: 90,
              largeur: 100,
              video: true,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produit.titre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    fcfa(produit.prix),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${produit.quartier} · ${produit.etat}',
                    style: const TextStyle(color: LiveColors.gris),
                  ),
                  Text(
                    '${produit.vendeur.nom} · ${note(produit.vendeur.note)}',
                    style: const TextStyle(color: LiveColors.bleu),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte produit en grille : image carrée (animée vers la fiche), titre, prix.
class CarteProduitGrille extends StatelessWidget {
  const CarteProduitGrille({super.key, required this.produit});
  final Produit produit;

  @override
  Widget build(BuildContext context) {
    final p = produit;
    return Pressable(
      onTap: () => context.push('/produit/${p.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'produit-${p.id}',
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Vignette(couleur: p.couleur, icone: p.icone, hauteur: 200),
                  const Positioned(
                    right: 6,
                    top: 6,
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),
                  if (p.etat == 'Neuf')
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Neuf',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: LiveColors.nuit,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.titre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500, height: 1.25),
          ),
          const SizedBox(height: 2),
          Text(
            fcfa(p.prix),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          Text(
            '${p.quartier} · ${note(p.vendeur.note)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
