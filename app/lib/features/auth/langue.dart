part of 'auth_screens.dart';

/// E-AUTH-01b — Choix de la langue, comme au premier lancement de WhatsApp :
/// la liste des langues, chacune écrite dans sa langue, puis « Suivant ».
class EcranLangue extends ConsumerWidget {
  const EcranLangue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actuelle = ref.watch(liveProvider.select((e) => e.langue));
    return Scaffold(
      appBar: const BarreDemarrage(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const EnTeteDemarrage(
            titre: 'Choisissez votre langue',
            texte: 'Vous pourrez la changer à tout moment dans Paramètres.',
          ),
          RadioGroup<String>(
            groupValue: actuelle,
            onChanged: (code) {
              if (code != null) {
                ref.read(liveProvider.notifier).choisirLangue(code);
              }
            },
            child: Column(
              children: [
                for (final (code, nom, francais) in languesLive)
                  RadioListTile<String>(
                    value: code,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      nom,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: nom == francais ? null : Text(francais),
                  ),
              ],
            ),
          ),
          if (actuelle != 'fr')
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Live s’affiche en français pour le moment ; votre langue '
                'sert déjà aux sous-titres et à Live IA.',
                textAlign: TextAlign.center,
                style: TextStyle(color: LiveColors.gris, fontSize: 13),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.push('/telephone'),
          child: const Text('Suivant'),
        ),
      ),
    );
  }
}
