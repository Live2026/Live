part of 'services_screens.dart';

/// E-SRV-09 — Mes interventions (côté prestataire) : demandes à chiffrer,
/// interventions à venir, en cours et terminées.
class EcranInterventions extends StatefulWidget {
  const EcranInterventions({super.key});

  @override
  State<EcranInterventions> createState() => _EcranInterventionsState();
}

class _EcranInterventionsState extends State<EcranInterventions> {
  var _onglet = 'À venir';

  @override
  Widget build(BuildContext context) {
    final liste = interventions.where((i) => i.$5 == _onglet).toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes interventions')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            enfants: const [
              TuileChiffre(
                libelle: 'Cette semaine',
                valeur: '7',
                icone: Icons.event_note_outlined,
                detail: 'interventions',
              ),
              TuileChiffre(
                libelle: 'Encaissé ce mois',
                valeur: '312 000',
                icone: Icons.payments_outlined,
                detail: 'FCFA',
                couleur: LiveColors.succes,
              ),
              TuileChiffre(
                libelle: 'Note',
                valeur: '4,9',
                icone: Icons.star_rounded,
                detail: '71 avis',
                couleur: LiveColors.cuivre,
              ),
              TuileChiffre(
                libelle: 'Demandes près de vous',
                valeur: '4',
                icone: Icons.mark_email_unread_outlined,
                detail: 'à chiffrer',
                couleur: LiveColors.orangeVif,
              ),
            ],
          ),
          const EnTeteSection('Demandes à chiffrer'),
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.water_drop_outlined, color: LiveColors.bleu),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fuite d’eau cuisine',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Etiquette(
                      'Il y a 12 min',
                      fond: Color(0xFFFFF1E0),
                      couleur: LiveColors.cuivre,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '« Fuite sous l’évier de la cuisine, l’eau coule en continu. » · Moungali · dès que possible',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => informer(
                        context,
                        'Demande ignorée : le client est orienté vers d’autres pros.',
                      ),
                      child: const Text('Ignorer'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: () => context.push('/pro/devis/nouveau'),
                        child: const Text('Faire un devis'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'À venir', label: Text('À venir')),
              ButtonSegment(value: 'En cours', label: Text('En cours')),
              ButtonSegment(value: 'Terminée', label: Text('Terminées')),
            ],
            selected: {_onglet},
            onSelectionChanged: (s) => setState(() => _onglet = s.first),
          ),
          const SizedBox(height: 10),
          for (final (client, travail, quand, montant, statut) in liste)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Bloc(
                padding: 12,
                child: Row(
                  children: [
                    Avatar(
                      nom: client,
                      couleur: const Color(0xFF475569),
                      taille: 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            travail,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '$client · $quand',
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          fcfa(montant),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        if (statut == 'À venir')
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(0, 32),
                            ),
                            onPressed: () =>
                                simulerScan(context, quoi: 'du client'),
                            icon: const Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 16,
                            ),
                            label: const Text('Démarrer'),
                          )
                        else
                          Text(
                            statut == 'En cours' ? 'Matériel versé' : 'Payé',
                            style: const TextStyle(
                              color: LiveColors.succes,
                              fontSize: 12.5,
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

/// E-SRV-08 — Créer un devis (prestataire) : lignes, acompte, créneau.
class EcranCreerDevis extends StatefulWidget {
  const EcranCreerDevis({super.key});

  @override
  State<EcranCreerDevis> createState() => _EcranCreerDevisState();
}

class _EcranCreerDevisState extends State<EcranCreerDevis> {
  var _mainOeuvre = 17000;
  var _materiel = 8000;
  var _acompte = 40;
  var _quand = "Aujourd'hui 16:00";
  var _envoye = false;

  int get _total => _mainOeuvre + _materiel;

  @override
  Widget build(BuildContext context) {
    if (_envoye) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const CocheAnimee(taille: 96),
                const SizedBox(height: 12),
                const Text(
                  'Devis envoyé',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Grâce M. le reçoit comme une carte payable. Vous êtes prévenu dès qu’elle paie l’acompte de ${fcfa(_total * _acompte ~/ 100)}.',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Retour à mes interventions'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau devis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuite d’eau cuisine · Grâce M.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Moungali · dès que possible · 1 photo',
                  style: TextStyle(color: LiveColors.gris),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Montant(
            'Main-d’œuvre',
            _mainOeuvre,
            (v) => setState(() => _mainOeuvre = v),
          ),
          _Montant('Matériel', _materiel, (v) => setState(() => _materiel = v)),
          const Divider(height: 24),
          LigneMontant('Total du devis', _total, gras: true),
          const SizedBox(height: 16),
          Text(
            'Acompte demandé : $_acompte %',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Slider(
            value: _acompte.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: '$_acompte %',
            onChanged: (v) => setState(() => _acompte = v.round()),
          ),
          Text(
            'Acompte ${fcfa(_total * _acompte ~/ 100)} · la part matériel vous est versée au démarrage.',
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quand pouvez-vous venir ?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final q in const [
                "Aujourd'hui 16:00",
                'Demain 09:00',
                'Demain 14:00',
              ])
                ChoiceChip(
                  label: Text(q),
                  selected: _quand == q,
                  onSelected: (_) => setState(() => _quand = q),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Commission Live : 8 % prélevés à la fin des travaux (0 % pendant l’offre de lancement).',
            style: TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _total > 0 ? () => setState(() => _envoye = true) : null,
          child: Text('Envoyer le devis · ${fcfa(_total)}'),
        ),
      ),
    );
  }
}

/// Ligne de montant modifiable par paliers de 1 000 FCFA.
class _Montant extends StatelessWidget {
  const _Montant(this.libelle, this.valeur, this.onChange);
  final String libelle;
  final int valeur;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(libelle)),
          IconButton.outlined(
            tooltip: 'Moins 1 000',
            onPressed: valeur >= 1000 ? () => onChange(valeur - 1000) : null,
            icon: const Icon(Icons.remove_rounded, size: 18),
          ),
          SizedBox(
            width: 110,
            child: Text(
              fcfa(valeur),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton.outlined(
            tooltip: 'Plus 1 000',
            onPressed: () => onChange(valeur + 1000),
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
