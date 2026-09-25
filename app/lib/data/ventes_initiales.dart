import 'etat.dart';
import 'mock.dart';

/// Ventes déjà réalisées par le compte de démonstration (historique de « Mes ventes »).
List<Commande> ventesInitiales() => [
  Commande(
    id: 'LV-00479',
    produit: produitParId('p8'),
    total: 25000,
    mode: ModePaiement.avance,
    statut: StatutCommande.payee,
    acheteur: 'Prince B.',
  ),
  Commande(
    id: 'LV-00475',
    produit: produitParId('p2'),
    total: 17000,
    mode: ModePaiement.avance,
    statut: StatutCommande.acceptee,
    acheteur: 'Merveille K.',
  ),
  Commande(
    id: 'LV-00471',
    produit: produitParId('p6'),
    total: 18000,
    mode: ModePaiement.avance,
    statut: StatutCommande.terminee,
    acheteur: 'Jordy M.',
  ),
  Commande(
    id: 'LV-00466',
    produit: produitParId('p2'),
    total: 30000,
    mode: ModePaiement.remise,
    statut: StatutCommande.terminee,
    acheteur: 'Nadège L.',
  ),
];
