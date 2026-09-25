part of 'market_screens.dart';

/// Étapes 3 à 6 de « Vendre un produit » et l'écran « Félicitations ».
extension _EtapesVente on _EcranVendreState {
  Widget _etapeInfos() {
    final attributs = _attributs[_categorie] ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _rediger,
            icon: const Icon(Icons.auto_awesome, color: LiveColors.orange),
            label: const Text('Rédiger avec Live IA · gratuit'),
          ),
        ),
        TextField(
          controller: _titre,
          onChanged: (_) => _maj(() {}),
          decoration: const InputDecoration(
            labelText: 'Titre',
            hintText: 'Ex. iPhone 11 64 Go',
          ),
        ),
        for (final (nom, valeurs) in attributs) ...[
          const SizedBox(height: 14),
          Text(nom, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in valeurs)
                ChoiceChip(
                  label: Text(v),
                  selected: _choix[nom] == v,
                  onSelected: (_) => _maj(() => _choix[nom] = v),
                ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        const Text('État', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final e in const [
              'Neuf',
              'Très bon état',
              'Bon état',
              'À réparer',
            ])
              ChoiceChip(
                label: Text(e),
                selected: _etat == e,
                onSelected: (_) => _maj(() => _etat = e),
              ),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _description,
          onChanged: (_) => _maj(() {}),
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        if (_coordonnees)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Retirez le numéro de téléphone : les échanges se font dans la '
              'messagerie de Live, pour votre sécurité.',
              style: TextStyle(color: LiveColors.erreur),
            ),
          ),
      ],
    );
  }

  Widget _etapePrix() {
    final prix = _montant;
    final reduction = _promo && _ancien > prix && prix > 0
        ? ((1 - prix / _ancien) * 100).round()
        : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _prix,
          onChanged: (_) => _maj(() {}),
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          decoration: const InputDecoration(
            labelText: 'Prix',
            suffixText: 'FCFA',
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _negociable,
          onChanged: (v) => _maj(() => _negociable = v),
          title: const Text('Prix négociable'),
          subtitle: const Text('Les acheteurs peuvent faire une offre'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _promo,
          onChanged: (v) => _maj(() {
            _promo = v;
            if (v && _ancien == 0) _ancien = (prix * 1.25).round();
          }),
          title: const Text('Promotion'),
          subtitle: Text(
            reduction > 0
                ? 'Ancien prix ${fcfa(_ancien)} · −$reduction % affiché'
                : 'Afficher l’ancien prix barré',
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Quantité en stock',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton.outlined(
              tooltip: 'Moins',
              onPressed: _quantite > 1 ? () => _maj(() => _quantite--) : null,
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$_quantite',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton.outlined(
              tooltip: 'Plus',
              onPressed: () => _maj(() => _quantite++),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (prix > 0) _Gain(prix: prix),
      ],
    );
  }

  Widget _etapeRemise() {
    final occasion = _etat != 'Neuf';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quartier', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final q in const [
              'Moungali',
              'Poto-Poto',
              'Bacongo',
              'Ouenzé',
              'Talangaï',
            ])
              ChoiceChip(
                label: Text(q),
                selected: _quartier == q,
                onSelected: (_) => _maj(() => _quartier = q),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _mainPropre,
          onChanged: (v) => _maj(() => _mainPropre = v),
          title: const Text('Remise en main propre'),
          subtitle: const Text('Dans un lieu public, confirmée par QR'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _livraison,
          onChanged: (v) => _maj(() => _livraison = v),
          title: const Text('Livraison par vos soins'),
          subtitle: Text(
            _livraison
                ? '${fcfa(_fraisLivraison)} à Brazzaville'
                : 'Non proposée',
          ),
        ),
        if (_livraison)
          Wrap(
            spacing: 8,
            children: [
              for (final f in const [1000, 2000, 3000, 5000])
                ChoiceChip(
                  label: Text(fcfa(f)),
                  selected: _fraisLivraison == f,
                  onSelected: (_) => _maj(() => _fraisLivraison = f),
                ),
            ],
          ),
        const SizedBox(height: 16),
        const Text(
          'Paiement',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Choix(
          titre: 'D’avance ou à la remise',
          sousTitre: occasion
              ? 'Recommandé pour l’occasion : l’acheteur voit l’objet, puis paie par MoMo via Live.'
              : 'L’acheteur choisit. Vous êtes payé dans tous les cas via Live.',
          icone: Icons.handshake_outlined,
          selectionne: !_avanceSeulement,
          onTap: () => _maj(() => _avanceSeulement = false),
        ),
        Choix(
          titre: 'Exiger le paiement d’avance',
          sousTitre: 'Argent bloqué par Live jusqu’au QR de remise.',
          icone: Icons.lock_clock_outlined,
          selectionne: _avanceSeulement,
          onTap: () => _maj(() => _avanceSeulement = true),
        ),
      ],
    );
  }

  Widget _etapeApercu() {
    final apercu = Produit(
      id: 'apercu',
      titre: _titre.text.trim(),
      prix: _montant,
      quartier: _quartier,
      vendeur: Vendeur(ref.read(liveProvider).prenom),
      couleur: const Color(0xFF6D28D9),
      icone: categoriesMarket
          .firstWhere(
            (c) => c.$2 == _categorie,
            orElse: () => categoriesMarket.first,
          )
          .$1,
      categorie: _categorie ?? 'Divers',
      etat: _etat,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voici votre annonce dans le Market :',
          style: TextStyle(color: LiveColors.gris),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: IgnorePointer(
                child: CarteProduit(produit: apercu, hero: false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (k, v) in [
                    ('Catégorie', _categorie ?? ''),
                    ('Photos', '$_photos${_video ? ' + vidéo' : ''}'),
                    ('Stock', '$_quantite'),
                    (
                      'Remise',
                      [
                        if (_mainPropre) 'main propre',
                        if (_livraison) 'livraison',
                      ].join(', '),
                    ),
                    (
                      'Paiement',
                      _avanceSeulement ? 'd’avance' : 'd’avance ou à la remise',
                    ),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$k\n',
                              style: const TextStyle(
                                color: LiveColors.gris,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: v,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _certifie,
          onChanged: (v) => _maj(() => _certifie = v ?? false),
          title: const Text(
            'Je certifie que cet objet m’appartient et respecte les règles de Live.',
          ),
        ),
      ],
    );
  }
}
