import 'donnees_apprendre.dart';
import 'donnees_immo.dart';
import 'donnees_market.dart';
import 'donnees_opportunites.dart';
import 'donnees_services.dart';
import 'modeles.dart';

export 'donnees_apprendre.dart';
export 'donnees_comptes.dart';
export 'donnees_immo.dart';
export 'donnees_market.dart';
export 'donnees_opportunites.dart';
export 'donnees_piliers.dart';
export 'donnees_createurs.dart';
export 'donnees_devises.dart';
export 'donnees_pays.dart';
export 'donnees_services.dart';
export 'donnees_social.dart';
export 'modeles.dart';
export 'modeles_savoirs.dart';

/// Données fictives du prototype. Aucune donnée réelle, aucun appel réseau.

Produit produitParId(String id) =>
    produits.firstWhere((p) => p.id == id, orElse: () => produits.first);
Bien bienParId(String id) =>
    biens.firstWhere((b) => b.id == id, orElse: () => biens.first);
Prestataire prestataireParId(String id) => prestataires.firstWhere(
  (p) => p.id == id,
  orElse: () => prestataires.first,
);

/// Tous les vendeurs, agences et propriétaires, pour les pages publiques.
const tousLesVendeurs = [
  ...vendeurs,
  palmiers,
  congoHabitat,
  mbemba,
  ...auteursApprendre,
  fondationMbongui,
  brasseriePool,
  ecoleAdministration,
  cliniqueCardio,
  institutNumerique,
];

Vendeur vendeurParId(String id) => tousLesVendeurs.firstWhere(
  (v) => v.id == id,
  orElse: () => tousLesVendeurs.first,
);

List<Produit> produitsDe(Vendeur v) =>
    produits.where((p) => p.vendeur.id == v.id).toList();

List<Bien> biensDe(Vendeur v) =>
    biens.where((b) => b.annonceur.id == v.id).toList();
