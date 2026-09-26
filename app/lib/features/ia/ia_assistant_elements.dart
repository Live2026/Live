part of 'ia_screens.dart';

/// Un message : bulle à droite pour l'utilisateur (avec ses fichiers),
/// réponse pleine largeur pour Live (points, note, actions, outils).
class _VueMessage extends StatelessWidget {
  const _VueMessage({
    required this.message,
    required this.credits,
    required this.onLire,
    required this.onAnnuler,
    this.onRegenerer,
  });
  final _Message message;
  final int credits;
  final ValueChanged<_Fichier> onLire;
  final VoidCallback onAnnuler;
  final VoidCallback? onRegenerer;

  @override
  Widget build(BuildContext context) {
    final m = message;
    if (m.moi) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final f in m.fichiers)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _PuceFichier(fichier: f),
                ),
              if (m.texte.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: LiveColors.voile,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(m.texte),
                ),
            ],
          ),
        ),
      );
    }
    if (m.aConfirmer != null) {
      final f = m.aConfirmer!;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Bloc(
          fond: LiveColors.teinteCreme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PuceFichier(fichier: f),
              const SizedBox(height: 10),
              Text(
                'Lire et résumer ce fichier coûte ${f.cout} crédits '
                '(${f.pages} page${f.pages > 1 ? 's' : ''}). Il vous en '
                'restera ${credits - f.cout}.',
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: () => onLire(f),
                    child: Text('Lire pour ${f.cout} crédits'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: onAnnuler,
                    child: const Text('Annuler'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    final r = m.reponse!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: LiveColors.teinteOrange,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: LiveColors.orangeVif,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.texte,
                  style: const TextStyle(fontSize: 15.5, height: 1.4),
                ),
                for (final p in r.points)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7, right: 10),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: LiveColors.nuit,
                          ),
                        ),
                        Expanded(
                          child: Text(p, style: const TextStyle(height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                if (r.note != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      r.note!,
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (r.type != null) ...[
                  const SizedBox(height: 10),
                  _Actions(type: r.type!),
                ],
                _Outils(texte: r.texte, onRegenerer: onRegenerer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Copier, écouter, bien ou pas, régénérer.
class _Outils extends StatelessWidget {
  const _Outils({required this.texte, this.onRegenerer});
  final String texte;
  final VoidCallback? onRegenerer;

  @override
  Widget build(BuildContext context) {
    Widget outil(String libelle, IconData icone, VoidCallback onTap) =>
        IconButton(
          tooltip: libelle,
          visualDensity: VisualDensity.compact,
          iconSize: 18,
          color: LiveColors.gris,
          onPressed: onTap,
          icon: Icon(icone),
        );
    return Row(
      children: [
        outil('Copier', Icons.copy_rounded, () {
          informer(context, 'Réponse copiée.');
        }),
        outil('Écouter', Icons.volume_up_rounded, () {
          informer(context, 'Lecture à voix haute… (simulation)');
        }),
        outil('Bonne réponse', Icons.thumb_up_alt_outlined, () {
          informer(context, 'Merci, c’est noté.');
        }),
        outil('Mauvaise réponse', Icons.thumb_down_alt_outlined, () {
          informer(context, 'Merci : dites-moi ce qui ne va pas.');
        }),
        if (onRegenerer != null)
          outil('Régénérer', Icons.refresh_rounded, onRegenerer!),
      ],
    );
  }
}

/// Indicateur « Live réfléchit ».
class _Reflechit extends StatelessWidget {
  const _Reflechit();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text('Live réfléchit…', style: TextStyle(color: LiveColors.gris)),
        ],
      ),
    );
  }
}

/// Un fichier joint : icône de son type, nom, taille.
class _PuceFichier extends StatelessWidget {
  const _PuceFichier({required this.fichier, this.onRetirer});
  final _Fichier fichier;
  final VoidCallback? onRetirer;

  @override
  Widget build(BuildContext context) {
    final f = fichier;
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
      decoration: BoxDecoration(
        color: LiveColors.surface,
        border: Border.all(color: LiveColors.brume),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: f.couleur,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(f.icone, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  f.nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${f.extension.toUpperCase()} · ${f.taille}',
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ],
            ),
          ),
          if (onRetirer != null)
            IconButton(
              tooltip: 'Retirer ${f.nom}',
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              onPressed: onRetirer,
              icon: const Icon(Icons.close_rounded),
            )
          else
            const SizedBox(width: 6),
        ],
      ),
    );
  }
}

/// Ce que l'Assistant propose de faire, selon la réponse.
class _Actions extends StatelessWidget {
  const _Actions({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final actions = switch (type) {
      'pro' => [
        ('Réserver Serge demain 8 h', '/pro/s1', Icons.event_available_rounded),
        ('Voir d’autres plombiers', '/services', Icons.handyman_rounded),
      ],
      'produit' => [
        (
          'Voir les 2 iPhone',
          '/market/liste?categorie=T%C3%A9l%C3%A9phones',
          Icons.smartphone_rounded,
        ),
        (
          'M’alerter des nouveaux',
          '/alertes',
          Icons.notifications_active_rounded,
        ),
      ],
      'facture' => [('Payer 18 450 FCFA', '/factures', Icons.bolt_rounded)],
      'budget' => [
        (
          'En faire un business plan',
          '/ia/business-plan',
          Icons.insights_rounded,
        ),
        ('Ouvrir ma boutique', '/espace/nouveau', Icons.storefront_rounded),
      ],
      'cv' => [
        ('Améliorer mon CV (15 crédits)', '/ia/service/cv', Icons.badge),
        ('Voir les offres d’emploi', '/opportunites', Icons.work_rounded),
      ],
      'cours' => [
        ('M’entraîner par photo', '/ia/exercice', Icons.school_rounded),
        ('Parler au tuteur', '/ia/tuteur', Icons.record_voice_over_rounded),
      ],
      _ => [
        ('Réserver la visite de mardi', '/bien/b1/visite', Icons.event_rounded),
        ('Voir les 3 logements', '/immo', Icons.home_work_rounded),
        ('Créer l’alerte', '/alertes', Icons.notifications_active_rounded),
      ],
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (libelle, route, icone) in actions)
          ActionChip(
            avatar: Icon(icone, size: 18, color: LiveColors.bleu),
            label: Text(libelle),
            onPressed: () => context.push(route),
          ),
      ],
    );
  }
}
