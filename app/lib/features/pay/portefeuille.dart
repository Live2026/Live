part of 'pay_screens.dart';

/// E-PAY-06 — Mon argent Live : tout ce que l'utilisateur a dans Live, en un
/// écran. Solde disponible (gains, remboursements, transferts reçus), argent
/// bloqué au séquestre pour ses achats, ventes en attente, dépenses du mois,
/// moyens de paiement et historique.
///
/// Pas de dépôt libre (décision D-15, docs/06 §1) : le solde se remplit par
/// les ventes, les remboursements et les transferts reçus, et se vide par
/// les paiements dans Live et les retraits vers MTN ou Airtel.
class EcranPortefeuille extends ConsumerStatefulWidget {
  const EcranPortefeuille({super.key});

  @override
  ConsumerState<EcranPortefeuille> createState() => _EcranPortefeuilleState();
}

class _EcranPortefeuilleState extends ConsumerState<EcranPortefeuille> {
  var _masque = false;

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final bloques = [
      for (final a in etat.achats)
        if (a.mode == ModePaiement.avance &&
            a.statut != StatutCommande.terminee)
          a,
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon argent Live'),
        actions: [
          IconButton(
            tooltip: _masque ? 'Afficher les montants' : 'Masquer les montants',
            onPressed: () => setState(() => _masque = !_masque),
            icon: Icon(
              _masque
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ],
      ),
      body: DeuxColonnes(
        principale: [
          _CarteSolde(etat: etat, masque: _masque, bloque: bloques),
          const SizedBox(height: 14),
          const _ActionsArgent(),
          const EnTeteSection('Mes dépenses de septembre'),
          _Depenses(masque: _masque),
          const EnTeteSection('Argent bloqué pour mes achats'),
          if (bloques.isEmpty)
            const Text(
              'Aucun achat en cours. Quand vous payez dans Live, l’argent '
              'reste bloqué jusqu’à ce que vous confirmiez la réception.',
              style: TextStyle(color: LiveColors.gris),
            )
          else
            for (final a in bloques)
              LigneMenu(
                icone: Icons.lock_clock_rounded,
                titre: a.produit.titre,
                detail:
                    '${_masque ? '•••' : fcfa(a.total)} · versé au vendeur '
                    'quand vous confirmez la réception',
                onTap: () => context.push('/suivi/${a.id}'),
              ),
        ],
        secondaire: [
          const EnTeteSection('Mes moyens de paiement'),
          LigneMenu(
            icone: Icons.phone_android_rounded,
            titre:
                '${etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money'}'
                ' · ${etat.telephone}',
            detail: 'Principal · retraits vers ce numéro, à votre nom',
            couleur: LiveColors.succes,
          ),
          LigneMenu(
            icone: Icons.add_circle_outline_rounded,
            titre: etat.operateur == 'MTN'
                ? 'Ajouter Airtel Money'
                : 'Ajouter MTN MoMo',
            detail: 'Un second numéro à votre nom',
            onTap: () => informer(
              context,
              'Code de vérification envoyé au nouveau numéro.',
            ),
          ),
          const LigneMenu(
            icone: Icons.credit_card_rounded,
            titre: 'Carte Visa',
            detail:
                'Saisie sur la page sécurisée de la banque à chaque paiement : '
                'Live n’enregistre aucune carte',
          ),
          const EnTeteSection('Historique'),
          for (final m in etat.historique) _LigneMouvement(m, masque: _masque),
          const SizedBox(height: 12),
          const Bloc(
            fond: Color(0xFFE6EBF2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: LiveColors.bleu),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Votre solde se remplit par vos ventes, vos remboursements '
                    'et l’argent reçu de l’étranger. Il sert à payer dans Live '
                    'ou se retire sans frais vers votre numéro. Les dépôts '
                    'libres arriveront avec notre partenaire agréé.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// La carte du solde : disponible, en attente, bloqué, niveau et plafond.
class _CarteSolde extends StatelessWidget {
  const _CarteSolde({
    required this.etat,
    required this.masque,
    required this.bloque,
  });
  final LiveState etat;
  final bool masque;
  final List<Commande> bloque;

  @override
  Widget build(BuildContext context) {
    final totalBloque = bloque.fold(0, (s, a) => s + a.total);
    String m(int v) => masque ? '••• FCFA' : fcfa(v);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), LiveColors.nuit],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331D4ED8),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Solde disponible',
                  style: TextStyle(color: Color(0xFFD7DCE4)),
                ),
              ),
              const LogoLive(taille: 22, couleur: Colors.white),
            ],
          ),
          const SizedBox(height: 4),
          if (masque)
            const Text(
              '••• ••• FCFA',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            )
          else
            ChiffreAnime(
              valeur: etat.disponible,
              format: fcfa,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Montant(
                  'En attente',
                  m(etat.enAttente > 0 ? etat.enAttente : 96000),
                  'ventes non confirmées',
                ),
              ),
              Expanded(
                child: _Montant('Bloqué', m(totalBloque), 'pour mes achats'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${etat.prenom} Mabiala · N${etat.niveau}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            etat.identiteVerifiee
                ? 'Retrait vers votre numéro jusqu’à 2 M FCFA par mois'
                : 'Retrait après vérification de votre identité',
            style: const TextStyle(color: Color(0xFFD7DCE4), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Montant extends StatelessWidget {
  const _Montant(this.titre, this.valeur, this.detail);
  final String titre;
  final String valeur;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre, style: const TextStyle(color: Color(0xFFD7DCE4))),
        Text(
          valeur,
          style: const TextStyle(
            color: LiveColors.ambre,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          detail,
          style: const TextStyle(color: Color(0xFFB8C0CC), fontSize: 11.5),
        ),
      ],
    );
  }
}

/// Raccourcis de l'argent : retirer, recevoir, gains, reçus.
class _ActionsArgent extends StatelessWidget {
  const _ActionsArgent();

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.north_east_rounded, 'Retirer', '/retirer'),
      (Icons.public_rounded, 'Recevoir', '/transfert?sens=recevoir'),
      (Icons.storefront_rounded, 'Mes gains', '/gains'),
      (Icons.receipt_long_rounded, 'Factures', '/factures'),
    ];
    return Row(
      children: [
        for (final (icone, titre, route) in actions)
          Expanded(
            child: Semantics(
              button: true,
              container: true,
              label: titre,
              excludeSemantics: true,
              onTap: () => context.push(route),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push(route),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE6EBF2),
                        child: Icon(icone, color: LiveColors.bleu),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        titre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Où va l'argent ce mois-ci, par espace de Live.
class _Depenses extends StatelessWidget {
  const _Depenses({required this.masque});
  final bool masque;

  static const _postes = [
    ('Live Market', 64500, LiveColors.orangeVif),
    ('Logement et visites', 5000, Color(0xFF0369A1)),
    ('Services', 25000, Color(0xFF15803D)),
    ('Factures et crédit', 18450, Color(0xFFCA8A04)),
    ('Live IA', 1000, Color(0xFF7C3AED)),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _postes.fold(0, (s, p) => s + p.$2);
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            masque ? '••• FCFA dépensés' : '${fcfa(total)} dépensés',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                for (final (_, v, c) in _postes)
                  Expanded(
                    flex: v,
                    child: Container(height: 12, color: c),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final (nom, v, c) in _postes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(nom)),
                  Text(
                    masque ? '•••' : fcfa(v),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Une ligne d'historique : entrée en vert, sortie en noir, reçu au toucher.
class _LigneMouvement extends StatelessWidget {
  const _LigneMouvement(this.m, {this.masque = false});
  final Mouvement m;
  final bool masque;

  @override
  Widget build(BuildContext context) {
    final entree = m.montant >= 0;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => context.push('/recu/${m.libelle.hashCode.abs()}'),
      leading: CircleAvatar(
        backgroundColor: entree
            ? const Color(0xFFE7F4EC)
            : const Color(0xFFF3F5F8),
        child: Icon(
          entree ? Icons.south_west : Icons.north_east,
          color: entree ? LiveColors.succes : LiveColors.nuit,
          size: 20,
        ),
      ),
      title: Text(m.libelle),
      subtitle: Text(m.enAttente ? '${m.quand} · en attente' : m.quand),
      trailing: Text(
        masque ? '•••' : '${entree ? '+' : ''}${fcfa(m.montant)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: entree ? LiveColors.succes : LiveColors.nuit,
        ),
      ),
    );
  }
}
