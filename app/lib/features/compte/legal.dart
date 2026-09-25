part of 'compte_screens.dart';

/// Section d'un texte légal : titre et paragraphes.
typedef _Article = (String, List<String>);

/// E-LEG-01 — Conditions d'utilisation.
const _cgu = <_Article>[
  (
    '1. Objet',
    [
      'Live est une place de marché sociale : acheter, vendre, louer, réserver '
          'un service, apprendre et publier. Ces conditions s’appliquent à tout '
          'utilisateur, particulier ou professionnel.',
    ],
  ),
  (
    '2. Compte et vérification',
    [
      'Un compte par numéro de téléphone, confirmé par code. Certaines fonctions '
          '(retirer ses gains, vendre au-delà des plafonds, ouvrir une agence) '
          'demandent une vérification d’identité ou professionnelle.',
      'Vous gardez secrets vos codes : Live ne vous les demandera jamais.',
    ],
  ),
  (
    '3. Paiements et protection',
    [
      'Les sommes payées « dans Live » sont conservées sur un compte de '
          'séquestre, tenu avec un établissement agréé, jusqu’à votre '
          'confirmation (QR, « J’ai reçu », fin du service). Sans confirmation '
          'ni litige, elles sont versées au vendeur après le délai affiché.',
      'Live prélève une commission affichée avant chaque publication et chaque '
          'paiement. Live n’émet pas de monnaie.',
    ],
  ),
  (
    '4. Ce qui se paie en dehors de Live',
    [
      'Loyers, caution, prix d’un bien immobilier et frais officiels se paient '
          'en direct, contre reçu. Live ne les garantit pas et l’indique sur '
          'chaque annonce.',
    ],
  ),
  (
    '5. Engagements des vendeurs et prestataires',
    [
      'Décrire honnêtement, livrer ce qui est annoncé, respecter les rendez-vous '
          'et les délais. Les annonces non confirmées depuis 30 jours sont '
          'masquées.',
    ],
  ),
  (
    '6. Contenus et produits interdits',
    [
      'Armes, médicaments, faux documents, contenus violents ou haineux, '
          'arnaques. Tout contenu peut être signalé ; la modération répond '
          'sous 24 heures.',
    ],
  ),
  (
    '7. Litiges et remboursements',
    [
      'En cas de problème, ouvrez une réclamation pendant le délai de '
          'confirmation : l’argent reste bloqué pendant l’examen. La décision '
          'de Live est motivée et inscrite au journal d’audit.',
    ],
  ),
  (
    '8. Live IA et crédits',
    [
      'Les crédits servent uniquement aux services Live IA. Ils ne sont ni '
          'remboursables en argent ni transférables. Le prix est annoncé avant '
          'chaque service ; un échec est recrédité.',
    ],
  ),
  (
    '9. Suspension',
    [
      'Live peut suspendre une fonction ou un compte en cas de fraude ou de '
          'non-respect de ces conditions, avec un motif et un recours.',
    ],
  ),
  (
    '10. Droit applicable',
    [
      'Droit de la République du Congo et règles de la CEMAC pour les '
          'paiements. Contact : support dans l’application ou '
          'legal@live.africa.',
    ],
  ),
];

/// E-LEG-02 — Politique de confidentialité (NF-07).
const _confidentialite = <_Article>[
  (
    'Ce que nous collectons',
    [
      'Numéro de téléphone, prénom et nom, ville ; vos annonces, messages et '
          'transactions ; pour la vérification, la pièce d’identité et un '
          'selfie ; la position seulement quand vous l’autorisez (carte, '
          'livraison).',
    ],
  ),
  (
    'Pourquoi',
    [
      'Faire fonctionner Live, protéger les paiements, lutter contre la fraude, '
          'respecter nos obligations légales. Jamais de revente de vos données.',
    ],
  ),
  (
    'Qui les reçoit',
    [
      'Les opérateurs Mobile Money et la banque pour vos paiements ; nos '
          'prestataires techniques (hébergement, SMS, vidéo, cartes) sous '
          'contrat ; l’autre partie d’une transaction, pour le strict '
          'nécessaire (prénom, quartier, rendez-vous).',
    ],
  ),
  (
    'Combien de temps',
    [
      'Tant que le compte existe ; les traces financières le temps imposé par '
          'la loi ; les pièces d’identité refusées sont effacées sous 30 jours.',
    ],
  ),
  (
    'Vos droits',
    [
      'Accéder à vos données, les corriger, les télécharger, supprimer votre '
          'compte : Moi › Paramètres › Données. Réponse sous 30 jours.',
    ],
  ),
  (
    'Sécurité',
    [
      'Chiffrement des échanges et des pièces d’identité, accès limités aux '
          'agents habilités, chaque consultation inscrite au journal d’audit.',
    ],
  ),
  (
    'Mineurs',
    [
      'Acheter, vendre et payer sont réservés aux 18 ans et plus. Les plus '
          'jeunes utilisent Live Savoir et Live IA avec des crédits offerts '
          'par un parent.',
    ],
  ),
];

/// Conditions d'utilisation ou politique de confidentialité.
class EcranLegal extends StatelessWidget {
  const EcranLegal({super.key, required this.type});

  /// `cgu` ou `confidentialite`.
  final String type;

  @override
  Widget build(BuildContext context) {
    final cgu = type != 'confidentialite';
    final articles = cgu ? _cgu : _confidentialite;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cgu ? 'Conditions d’utilisation' : 'Politique de confidentialité',
        ),
      ),
      body: Etroit(
        largeur: 760,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const Text(
              'Version 1 · 25 septembre 2026',
              style: TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 10),
            const Bloc(
              fond: LiveColors.fondAlerte,
              child: Text(
                'Version de travail du prototype, à valider par l’avocat '
                'avant le lancement (décision D-16).',
              ),
            ),
            for (final (titre, paragraphes) in articles) ...[
              const SizedBox(height: 18),
              Text(
                titre,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              for (final p in paragraphes)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(p, style: const TextStyle(height: 1.45)),
                ),
            ],
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => context.push(
                cgu ? '/legal/confidentialite' : '/legal/cgu',
              ),
              icon: const Icon(Icons.description_outlined),
              label: Text(
                cgu
                    ? 'Lire la politique de confidentialité'
                    : 'Lire les conditions d’utilisation',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
