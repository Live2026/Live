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
      appBar: AppBar(title: const Text('Demandes de messages')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 8),
            child: const Text(
              'Messages de personnes que vous ne suivez pas. Elles ne savent '
              'pas si vous les avez lus tant que vous n’acceptez pas.',
              style: TextStyle(color: LiveColors.gris),
            ),
          ),
          if (liste.isEmpty)
            const EtatVide(
              icone: Icons.mark_email_read_outlined,
              texte: 'Aucune demande en attente.',
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
                      const Etiquette(
                        'Arnaque probable : demande d’argent',
                        icone: Icons.warning_amber_rounded,
                        fond: Color(0xFFFDECEC),
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
                              d.id == 'd3' ? 'Signaler' : 'Supprimer',
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
                            child: const Text('Accepter'),
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
      appBar: AppBar(title: const Text('Archivées')),
      body: ListView(
        children: [
          for (final c in conversationsArchivees)
            _LigneConversation(c: c, marge: marge),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Une conversation archivée revient dans la liste dès qu’un '
              'nouveau message arrive.',
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
      appBar: AppBar(title: const Text('Réglages des messages')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          const EnTeteSection('Qui peut m’écrire'),
          for (final (i, (titre, detail)) in const [
            ('Tout le monde', 'Les inconnus arrivent dans « Demandes »'),
            ('Mes abonnements et mes clients', 'Recommandé'),
            ('Personne', 'Sauf les conversations en cours'),
          ].indexed)
            Choix(
              titre: titre,
              sousTitre: detail,
              selectionne: _qui == i,
              onTap: () => setState(() => _qui = i),
            ),
          const EnTeteSection('Confidentialité'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _lecture,
            onChanged: (v) => setState(() => _lecture = v),
            title: const Text('Confirmations de lecture'),
            subtitle: const Text('Les coches bleues'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _enLigne,
            onChanged: (v) => setState(() => _enLigne = v),
            title: const Text('Montrer quand je suis en ligne'),
          ),
          const EnTeteSection('Données'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _wifi,
            onChanged: (v) => setState(() => _wifi = v),
            title: const Text(
              'Télécharger photos, vidéos et PDF en Wi-Fi seulement',
            ),
            subtitle: const Text('Économise votre forfait'),
          ),
          const EnTeteSection('Protection'),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.shield_rounded, color: LiveColors.succes),
            title: Text('Alerte anti-arnaque'),
            subtitle: Text(
              'Toujours active : Live vous prévient quand un message demande '
              'de payer hors de l’application.',
            ),
            trailing: Icon(Icons.lock_rounded, color: LiveColors.gris),
          ),
          LigneMenu(
            icone: Icons.block_rounded,
            titre: 'Comptes bloqués',
            valeur: '2',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
