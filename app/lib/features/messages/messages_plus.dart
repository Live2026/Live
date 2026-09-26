part of 'messages_screens.dart';

/// Rangée « Demandes » ou « Archivées » en haut de la liste des messages.
class _RangeeDossier extends StatelessWidget {
  const _RangeeDossier({
    required this.icone,
    required this.titre,
    required this.nombre,
    required this.route,
    required this.marge,
  });
  final IconData icone;
  final String titre;
  final int nombre;
  final String route;
  final double marge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(route),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: marge, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Icon(icone, color: LiveColors.bleu, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                titre,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '$nombre',
              style: const TextStyle(
                color: LiveColors.bleu,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// E-CHAT-05 — Demandes de messages : personnes que l'on ne suit pas.
class EcranDemandes extends StatefulWidget {
  const EcranDemandes({super.key});

  @override
  State<EcranDemandes> createState() => _EcranDemandesState();
}

class _EcranDemandesState extends State<EcranDemandes> {
  final _traitees = <String>{};

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final liste = demandesMessages
        .where((d) => !_traitees.contains(d.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(context.t.messagesDemandesDeMessages)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 8),
            child: Text(
              context.t.messagesMessagesDePersonnesQue,
              style: TextStyle(color: LiveColors.gris),
            ),
          ),
          if (liste.isEmpty)
            EtatVide(
              icone: Icons.mark_email_read_outlined,
              texte: context.t.messagesAucuneDemandeEnAttente,
            ),
          for (final d in liste)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge, vertical: 6),
              child: Bloc(
                padding: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar(nom: d.nom, couleur: d.couleur, taille: 44),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.nom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                d.dernier,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (d.id == 'd3') ...[
                      const SizedBox(height: 8),
                      Etiquette(
                        context.t.messagesArnaqueProbableDemandeD,
                        icone: Icons.warning_amber_rounded,
                        fond: LiveColors.teinteRouge,
                        couleur: LiveColors.erreur,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                setState(() => _traitees.add(d.id)),
                            child: Text(
                              d.id == 'd3'
                                  ? context.t.messagesSignaler
                                  : context.t.supprimer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: d.id == 'd3'
                                ? null
                                : () {
                                    setState(() => _traitees.add(d.id));
                                    context.push('/conversation');
                                  },
                            child: Text(context.t.messagesAccepter),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// E-CHAT-06 — Conversations archivées.
class EcranArchives extends StatelessWidget {
  const EcranArchives({super.key});

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.messagesArchivees)),
      body: ListView(
        children: [
          for (final c in conversationsArchivees)
            _LigneConversation(c: c, marge: marge),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              context.t.messagesUneConversationArchiveeRevient,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

/// E-CHAT-07 — Réglages des messages : qui peut écrire, confirmations de
/// lecture, téléchargement des médias, protection anti-arnaque.
class EcranReglagesMessages extends StatefulWidget {
  const EcranReglagesMessages({super.key});

  @override
  State<EcranReglagesMessages> createState() => _EcranReglagesMessagesState();
}

class _EcranReglagesMessagesState extends State<EcranReglagesMessages> {
  var _qui = 1;
  var _lecture = true;
  var _enLigne = true;
  var _wifi = true;

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.messagesReglagesDesMessages)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          EnTeteSection(context.t.messagesQuiPeutMEcrire),
          for (final (i, (titre, detail)) in [
            (
              context.t.messagesToutLeMonde,
              context.t.messagesLesInconnusArriventDans,
            ),
            (
              context.t.messagesMesAbonnementsEtMes,
              context.t.messagesRecommande,
            ),
            (
              context.t.messagesPersonne,
              context.t.messagesSaufLesConversationsEn,
            ),
          ].indexed)
            Choix(
              titre: titre,
              sousTitre: detail,
              selectionne: _qui == i,
              onTap: () => setState(() => _qui = i),
            ),
          EnTeteSection(context.t.messagesConfidentialite),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _lecture,
            onChanged: (v) => setState(() => _lecture = v),
            title: Text(context.t.messagesConfirmationsDeLecture),
            subtitle: Text(context.t.messagesLesCochesBleues),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _enLigne,
            onChanged: (v) => setState(() => _enLigne = v),
            title: Text(context.t.messagesMontrerQuandJeSuis),
          ),
          EnTeteSection(context.t.messagesDonnees),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _wifi,
            onChanged: (v) => setState(() => _wifi = v),
            title: Text(context.t.messagesTelechargerPhotosVideosEt),
            subtitle: Text(context.t.messagesEconomiseVotreForfait),
          ),
          EnTeteSection(context.t.messagesProtection),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.shield_rounded, color: LiveColors.succes),
            title: Text(context.t.messagesAlerteAntiArnaque),
            subtitle: Text(context.t.messagesToujoursActiveLiveVous),
            trailing: Icon(Icons.lock_rounded, color: LiveColors.gris),
          ),
          LigneMenu(
            icone: Icons.block_rounded,
            titre: context.t.messagesComptesBloques,
            onTap: () => context.push('/bloques'),
          ),
        ],
      ),
    );
  }
}

/// Nouveau message : choisir un compte suivi ou une boutique.
void _nouveauMessage(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            context.t.messagesNouveauMessage,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: context.t.messagesRechercherUnNom,
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: LiveColors.voile,
              child: Icon(Icons.group_add_rounded, color: LiveColors.bleu),
            ),
            title: Text(context.t.messagesNouveauGroupe),
            subtitle: Text(context.t.messagesQuartierClassePassion),
            onTap: () {
              Navigator.pop(ctx);
              context.push('/groupe/g1');
            },
          ),
          for (final c in comptes.take(6))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Avatar(
                nom: c.nom,
                couleur: c.couleur,
                taille: 40,
                verifie: c.verifie,
              ),
              title: Text(c.nom),
              subtitle: Text(
                c.bio,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/conversation');
              },
            ),
        ],
      ),
    ),
  );
}
