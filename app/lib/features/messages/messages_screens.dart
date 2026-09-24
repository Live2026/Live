import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../shared/widgets.dart';

/// E-CHAT-01 — Conversations.
class EcranMessages extends StatelessWidget {
  const EcranMessages({super.key});

  @override
  Widget build(BuildContext context) {
    const conversations = [
      ('Grâce Mode', 'iPhone 11 · Contre-offre 80 000', '10:42', true),
      (
        'Agence Les Palmiers',
        '2 ch. Moungali · Visite mardi 10:30',
        'hier',
        false,
      ),
      ('Serge · Plombier', 'Devis 25 000 FCFA', 'hier', false),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView(
        children: [
          for (final (nom, dernier, quand, action) in conversations)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                nom,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(dernier),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(quand, style: const TextStyle(fontSize: 12)),
                  if (action)
                    const Icon(Icons.circle, color: LiveColors.bleu, size: 12),
                ],
              ),
              onTap: () => context.push('/conversation'),
            ),
        ],
      ),
    );
  }
}

/// E-CHAT-02 — Conversation liée à une annonce, avec négociation et alerte anti-arnaque.
class EcranConversation extends StatefulWidget {
  const EcranConversation({super.key});

  @override
  State<EcranConversation> createState() => _EcranConversationState();
}

class _EcranConversationState extends State<EcranConversation> {
  final _saisie = TextEditingController();
  var _offreAcceptee = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grâce Mode')),
      body: Column(
        children: [
          ListTile(
            tileColor: Colors.grey.shade100,
            leading: const Vignette(
              couleur: Color(0xFF334155),
              icone: Icons.phone_iphone,
              hauteur: 44,
              largeur: 44,
              rayon: 6,
            ),
            title: const Text('iPhone 11 64 Go · 85 000 FCFA'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/produit/p1'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const _Bulle('Bonjour, toujours disponible ?', moi: true),
                const _Bulle('Oui ! Il est comme sur les photos.'),
                const _Carte(
                  titre: 'OFFRE · Vous proposez 75 000',
                  texte: 'Refusée par Grâce',
                ),
                const _Bulle(
                  'Envoie 80 000 directement sur mon MoMo 06 999 88 77, ça ira plus vite.',
                ),
                const _AlerteArnaque(),
                _Carte(
                  titre: 'CONTRE-OFFRE · Grâce : 80 000',
                  texte: _offreAcceptee
                      ? 'Offre acceptée'
                      : "Valable jusqu'à demain 10:30",
                  action: _offreAcceptee
                      ? FilledButton(
                          onPressed: () => context.push('/commande/p1'),
                          child: const Text('Payer 80 000 FCFA dans Live'),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Refuser'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () =>
                                    setState(() => _offreAcceptee = true),
                                child: const Text('Accepter'),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: BandeauProtection('Payez uniquement avec le bouton Payer.'),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _saisie,
                      decoration: const InputDecoration(
                        hintText: 'Écrire un message…',
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                  IconButton(
                    onPressed: () => _saisie.clear(),
                    icon: const Icon(Icons.send, color: LiveColors.bleu),
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

class _Bulle extends StatelessWidget {
  const _Bulle(this.texte, {this.moi = false});
  final String texte;
  final bool moi;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: moi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: moi ? LiveColors.fondProtection : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(texte),
      ),
    );
  }
}

class _Carte extends StatelessWidget {
  const _Carte({required this.titre, required this.texte, this.action});
  final String titre;
  final String texte;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(texte),
            if (action != null) ...[const SizedBox(height: 8), action!],
          ],
        ),
      ),
    );
  }
}

class _AlerteArnaque extends StatelessWidget {
  const _AlerteArnaque();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LiveColors.fondAlerte,
        border: Border.all(color: LiveColors.ambre),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber, color: LiveColors.cuivre),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Attention : ce message propose un paiement en dehors de Live. Si vous payez hors de l\'application, vous n\'êtes PAS protégé et ne pourrez pas être remboursé.',
            ),
          ),
        ],
      ),
    );
  }
}
