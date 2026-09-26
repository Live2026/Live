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
        title: Text(context.t.payMonArgentLive),
        actions: [
          IconButton(
            tooltip: _masque
                ? context.t.payAfficherLesMontants
                : context.t.payMasquerLesMontants,
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
          EnTeteSection(context.t.payMesDepensesDeSeptembre),
          _Depenses(masque: _masque),
          EnTeteSection(context.t.payArgentBloquePourMes),
          if (bloques.isEmpty)
            Text(
              context.t.payAucunAchatEnCours,
              style: TextStyle(color: LiveColors.gris),
            )
          else
            for (final a in bloques)
              LigneMenu(
                icone: Icons.lock_clock_rounded,
                titre: a.produit.titre,
                detail: context.t.payVerseAuVendeur(
                  _masque ? '•••' : fcfa(a.total),
                ),
                onTap: () => context.push('/suivi/${a.id}'),
              ),
        ],
        secondaire: [
          EnTeteSection(context.t.payMesMoyensDePaiement),
          LigneMenu(
            icone: Icons.phone_android_rounded,
            titre: context.t.payOperateurTel(
              etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money',
              etat.telephone,
            ),
            detail: context.t.payPrincipalRetraitsVersCe,
            couleur: LiveColors.succes,
          ),
          LigneMenu(
            icone: Icons.add_circle_outline_rounded,
            titre: etat.operateur == 'MTN'
                ? context.t.payAjouterAirtelMoney
                : context.t.payAjouterMtnMomo,
            detail: context.t.payUnSecondNumeroA,
            onTap: () =>
                informer(context, context.t.payCodeDeVerificationEnvoye),
          ),
          LigneMenu(
            icone: Icons.credit_card_rounded,
            titre: context.t.payCarteVisa,
            detail: context.t.paySaisieSurLaPage,
          ),
          EnTeteSection(context.t.payHistorique),
          for (final m in etat.historique) _LigneMouvement(m, masque: _masque),
          const SizedBox(height: 12),
          Bloc(
            fond: LiveColors.voile,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: LiveColors.bleu),
                SizedBox(width: 10),
                Expanded(child: Text(context.t.payVotreSoldeSeRemplit)),
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
              Expanded(
                child: Text(
                  context.t.paySoldeDisponible,
                  style: TextStyle(color: LiveColors.brumeClaire),
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
                  context.t.payEnAttente,
                  m(etat.enAttente > 0 ? etat.enAttente : 96000),
                  context.t.payVentesNonConfirmees,
                ),
              ),
              Expanded(
                child: _Montant(
                  context.t.payBloque,
                  m(totalBloque),
                  context.t.payPourMesAchats,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            context.t.payNomNiveau(etat.prenom, etat.niveau),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            etat.identiteVerifiee
                ? context.t.payRetraitVersVotreNumero
                : context.t.payRetraitApresVerificationDe,
            style: const TextStyle(color: LiveColors.brumeClaire, fontSize: 12),
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
        Text(titre, style: const TextStyle(color: LiveColors.brumeClaire)),
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
    final actions = [
      (Icons.north_east_rounded, context.t.payRetirer, '/retirer'),
      (Icons.public_rounded, context.t.payRecevoir, '/transfert?sens=recevoir'),
      (Icons.storefront_rounded, context.t.payMesGains, '/gains'),
      (Icons.receipt_long_rounded, context.t.payFactures, '/factures'),
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
                        backgroundColor: LiveColors.voile,
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

  static List<(String, int, Color)> _postes(Textes t) => [
    ('Live Market', 64500, LiveColors.orangeVif),
    (t.payLogementEtVisites, 5000, Color(0xFF0369A1)),
    (t.payServices, 25000, Color(0xFF15803D)),
    (t.payFacturesEtCredit, 18450, Color(0xFFCA8A04)),
    ('Live IA', 1000, Color(0xFF7C3AED)),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _postes(context.t).fold(0, (s, p) => s + p.$2);
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.payDepenses(masque ? '••• FCFA' : fcfa(total)),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                for (final (_, v, c) in _postes(context.t))
                  Expanded(
                    flex: v,
                    child: Container(height: 12, color: c),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final (nom, v, c) in _postes(context.t))
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
        backgroundColor: entree ? LiveColors.teinteVerte : LiveColors.champ,
        child: Icon(
          entree ? Icons.south_west : Icons.north_east,
          color: entree ? LiveColors.succes : LiveColors.encre,
          size: 20,
        ),
      ),
      title: Text(m.libelle),
      subtitle: Text(
        m.enAttente ? context.t.payQuandEnAttente(m.quand) : m.quand,
      ),
      trailing: Text(
        masque ? '•••' : '${entree ? '+' : ''}${fcfa(m.montant)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: entree ? LiveColors.succes : LiveColors.encre,
        ),
      ),
    );
  }
}
