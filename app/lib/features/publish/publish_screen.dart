import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';

/// E-PUB-01 — Que voulez-vous publier ?
class EcranPublier extends StatelessWidget {
  const EcranPublier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publier')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Option(
            icone: Icons.sell,
            titre: 'Vendre un produit',
            sous: 'Téléphone, mode, maison…',
            onTap: () => context.push('/vendre'),
          ),
          _Option(
            icone: Icons.home_work,
            titre: 'Louer ou vendre un bien',
            sous: 'Appartement, maison, local…',
            onTap: () => _bientot(context),
          ),
          _Option(
            icone: Icons.handyman,
            titre: 'Proposer un service',
            sous: 'Artisan, beauté, événement…',
            onTap: () => _bientot(context),
          ),
          _Option(
            icone: Icons.videocam,
            titre: 'Vidéo ou photo',
            sous: 'Partager dans le fil',
            onTap: () => _bientot(context),
          ),
        ],
      ),
    );
  }

  void _bientot(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Non inclus dans ce prototype : testez « Vendre un produit ».',
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icone,
    required this.titre,
    required this.sous,
    required this.onTap,
  });
  final IconData icone;
  final String titre;
  final String sous;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: LiveColors.fondProtection,
          child: Icon(icone, color: LiveColors.bleu, size: 28),
        ),
        title: Text(
          titre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(sous),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
