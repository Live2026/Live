// Test de bout en bout des 5 parcours du prototype (inscription, achat, vente,
// visite de logement, devis, retrait) dans Chromium, au format téléphone.
// Usage : voir test_e2e/README.md.
const { chromium } = require('playwright');
const LARGEUR = +(process.env.LARGEUR || 360);
const BASE = process.env.BASE || 'http://localhost:8765/';
const DOSSIER = process.env.CAPTURES || 'captures';
const CHROMIUM = process.env.CHROMIUM || undefined;
require('fs').mkdirSync(DOSSIER, { recursive: true });
let p, n = 0, etape = '';
const erreurs = [];

async function ecran(nom) { n++; await p.waitForTimeout(500); await p.screenshot({ path: `${DOSSIER}/${String(n).padStart(2, '0')}_${nom}.png` }); }
async function sem() { await p.evaluate(() => { const e = document.querySelector('flt-semantics-placeholder'); if (e) e.click(); }); await p.waitForTimeout(400); }
async function bouton(nom, { exact = false } = {}) {
  etape = nom;
  // Tous les éléments tapables possibles : bouton, case, puce, carte (texte).
  const candidats = [
    p.getByRole('button', { name: nom, exact }),
    p.getByRole('checkbox', { name: nom, exact }),
    p.getByRole('radio', { name: nom, exact }),
    p.getByLabel(nom, { exact }),
    p.getByText(nom, { exact }),
  ];
  const debut = Date.now();
  while (Date.now() - debut < 10000) {
    for (const c of candidats) {
      const l = c.filter({ visible: true }).first();
      if (await l.count()) {
        let boite = await l.boundingBox();
        // Hors de l'écran : on fait défiler comme avec le doigt, puis on remesure.
        for (let i = 0; boite && boite.y + boite.height > 700 && i < 6; i++) {
          await p.mouse.move(180, 400);
          await p.mouse.wheel(0, 300);
          await p.waitForTimeout(400);
          boite = await l.boundingBox();
        }
        if (boite) {
          await p.mouse.click(boite.x + boite.width / 2, boite.y + boite.height / 2);
          await p.waitForTimeout(800);
          return;
        }
      }
    }
    await p.waitForTimeout(300);
  }
  throw new Error('élément introuvable');
}
async function texte(nom) {
  // Vérifie qu'un texte propre au résultat attendu est affiché (texte ou étiquette d'accessibilité).
  etape = 'texte ' + nom;
  await p.getByText(nom).or(p.getByLabel(nom)).first().waitFor({ timeout: 8000 });
}
async function saisir(cible, valeur) {
  // cible : libellé du champ (texte) ou rang parmi les champs visibles (nombre).
  etape = 'saisie ' + valeur;
  const champs = p.getByRole('textbox').filter({ visible: true });
  const l = typeof cible === 'number' ? champs.nth(cible) : p.getByRole('textbox', { name: cible }).filter({ visible: true }).first();
  await l.waitFor({ timeout: 8000 });
  const boite = await l.boundingBox();
  await p.mouse.click(boite.x + boite.width / 2, boite.y + boite.height / 2);
  await p.waitForTimeout(300);
  await p.keyboard.press('Control+A');
  await p.keyboard.type(valeur, { delay: 20 });
  await p.waitForTimeout(500);
}
async function pin() { for (const c of ['1', '2', '3', '4']) await bouton(c, { exact: true }); }
async function onglet(nom) { await bouton(nom, { exact: true }); }

(async () => {
  const b = await chromium.launch({ executablePath: CHROMIUM });
  p = await b.newPage({ viewport: { width: LARGEUR, height: 760 }, deviceScaleFactor: 2 });
  p.on('pageerror', e => erreurs.push('JS ' + e.message));
  p.on('console', m => { if (m.type() === 'error') erreurs.push(m.text()); });
  p.on('requestfailed', r => erreurs.push('Échec réseau : ' + r.url()));
  try {
    await p.goto(BASE, { waitUntil: 'networkidle' });
    await p.waitForTimeout(2500); await sem();

    // 0. Inscription
    await bouton('Commencer'); await sem();
    await saisir(0, '06 123 45 67');
    for (const c of await p.getByRole('checkbox').all()) await c.click();
    await ecran('inscription_telephone');
    await bouton('Recevoir le code par SMS');
    await saisir(0, '123456'); await p.waitForTimeout(800);
    await saisir('Prénom', 'Grâce'); await ecran('inscription_profil');
    await bouton('Continuer');
    await pin(); await p.waitForTimeout(1200); await ecran('fil');

    // 1. Acheter (depuis la pastille du fil puis la fiche)
    if (LARGEUR < 600) await bouton('Acheter ›'); await ecran('fil_annonce');
    await onglet('Explorer'); await ecran('explorer');
    await bouton('iPhone 11 64 Go'); await ecran('fiche_produit');
    await bouton('Acheter', { exact: true }); await ecran('commande');
    await bouton('Continuer'); await ecran('paiement');
    await pin(); await ecran('attente_momo');
    await p.waitForTimeout(4500); await ecran('paiement_reussi');
    await bouton('Suivre ma commande'); await ecran('suivi_qr');
    await bouton('Simuler : le vendeur scanne votre QR'); await ecran('reception_confirmee');
    await texte('Le vendeur est payé');

    // 2. Vendre
    await p.goto(BASE + '#/publier'); await p.waitForTimeout(1500); await sem();
    await bouton('Vendre un produit');
    await bouton('Ajouter une photo');
    await saisir('Titre', 'Samsung A10'); await saisir('Prix', '30000'); await ecran('vendre');
    await bouton('Publier', { exact: true }); await ecran('annonce_publiee');
    await bouton('Voir mes ventes'); await bouton('Accepter', { exact: true }); await ecran('mes_ventes');
    await bouton('Remettre le produit'); await ecran('remise_vendeur');
    await bouton("Scanner le QR de l'acheteur"); await p.waitForTimeout(2000); await ecran('scan');
    await bouton('Continuer'); await ecran('remise_confirmee');
    await texte('ajoutés à vos gains');

    // 3. Visiter un logement
    await p.goto(BASE + '#/immo'); await p.waitForTimeout(1500); await sem(); await ecran('immo_liste');
    await bouton('Appartement 2 chambres · Moungali'); await ecran('fiche_logement');
    await bouton('Demander une visite'); await bouton('10:30'); await ecran('creneau');
    await bouton('Payer'); await pin(); await p.waitForTimeout(4500);
    await bouton('Voir ma visite'); await ecran('visite_qr');
    await bouton("Simuler : l'agent scanne votre QR"); await texte('Visite effectuée'); await ecran('visite_confirmee');

    // 4. Demander un devis
    await p.goto(BASE + '#/services'); await p.waitForTimeout(1500); await sem();
    await bouton('Demander des devis'); await ecran('demande_devis');
    await bouton('Envoyer à des pros vérifiés'); await bouton('Voir les devis'); await ecran('devis_recus');
    await bouton('Serge'); await ecran('detail_devis');
    await bouton('Accepter et payer'); await pin(); await p.waitForTimeout(4500);
    await bouton('Suivre la prestation'); await ecran('prestation_qr');
    await bouton('Serge scanne votre QR'); await bouton('Serge déclare la fin'); await ecran('prestation_terminee');
    await texte('Reste à payer');

    // 5. Retirer ses gains
    await p.goto(BASE + '#/retirer'); await p.waitForTimeout(1500); await sem();
    await saisir('Montant', '50000'); await ecran('retrait');
    await bouton('Retirer 50'); await pin(); await ecran('retrait_ok');
    await texte('FCFA envoyés');
    // 6. Live IA : achat de crédits, CV, exercice en mode apprentissage
    await p.goto(BASE + '#/ia'); await p.waitForTimeout(1500); await sem(); await ecran('ia_accueil');
    await bouton('Acheter des crédits'); await ecran('ia_credits');
    await bouton('Payer 500'); await pin(); await p.waitForTimeout(4500);
    await bouton('Utiliser mes crédits'); await texte('70'); await ecran('ia_solde');
    await bouton('CV complet'); await bouton('Remplir avec mon profil Live'); await ecran('ia_cv_formulaire');
    await bouton('Générer · 20'); await ecran('ia_confirmation');
    await bouton('Générer', { exact: true }); await p.waitForTimeout(3500);
    await texte('Document prêt'); await ecran('ia_cv_resultat');
    await p.goto(BASE + '#/ia/exercice'); await p.waitForTimeout(1500); await sem();
    await bouton('Prendre la photo'); await ecran('ia_exercice');
    await bouton('Envoyer · 5'); await bouton('Générer', { exact: true });
    for (const r of ['Le soustraire des deux côtés', 'Diviser les deux côtés par 2', '11']) {
      await bouton(r, { exact: true }); await ecran('ia_etape');
      await bouton('Étape suivante').catch(() => bouton('Voir le récapitulatif'));
    }
    await texte('Solution : x = 4'); await ecran('ia_exercice_fin');
    console.log('RÉSULTAT : les 6 parcours ont abouti.');
    process.exitCode = 0;
  } catch (e) {
    console.log('ÉCHEC à l\'étape « ' + etape + ' » : ' + e.message.split('\n')[0]);
    await ecran('ECHEC');
    process.exitCode = 1;
  }
  console.log('Erreurs navigateur :', erreurs.length ? erreurs : 'aucune');
  await b.close();
})();
