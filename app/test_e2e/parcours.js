// Test de bout en bout des 6 parcours du prototype (inscription, achat, vente,
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

async function ecran(nom) { n++; await p.mouse.move(LARGEUR - 2, 2); await p.waitForTimeout(500); await p.screenshot({ path: `${DOSSIER}/${String(n).padStart(3, '0')}_${nom}.png` }); }
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
    await ecran('bienvenue');
    await bouton('Commencer'); await sem();
    await saisir(0, '06 123 45 67');
    for (const c of await p.getByRole('checkbox').all()) await c.click();
    await ecran('inscription_telephone');
    await bouton('Recevoir le code par SMS');
    await ecran('code_sms_vide');
    await saisir(0, '123456'); await p.waitForTimeout(800);
    await saisir('Prénom', 'Grâce'); await ecran('inscription_profil');
    await bouton('Continuer'); await ecran('code_secret');
    await pin(); await p.waitForTimeout(1200); await ecran('interets');
    await bouton('Continuer'); await p.waitForTimeout(1200); await ecran('fil');

    // 1. Acheter (depuis la pastille du fil puis la fiche)
    if (LARGEUR < 600) await bouton('Acheter ›'); await ecran('fil_annonce');
    await onglet('Explorer'); await ecran('explorer');
    await p.goto(BASE + '#/market/liste?categorie=T%C3%A9l%C3%A9phones'); await p.waitForTimeout(1500); await sem();
    await bouton('Galaxy A14 128 Go'); await ecran('fiche_produit');
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
    await bouton('Appartement 2 chambres'); await ecran('fiche_logement');
    await bouton('Demander une visite'); await bouton('10:30'); await ecran('creneau');
    await bouton('Payer'); await pin(); await p.waitForTimeout(4500);
    await bouton('Voir ma visite'); await ecran('visite_qr');
    await bouton("Simuler : l'agent scanne votre QR"); await texte('Visite effectuée'); await ecran('visite_confirmee');
    await bouton("Voir l'offre de réservation"); await ecran('offre_reservation');
    await bouton('Réserver'); await pin(); await p.waitForTimeout(4500);
    await bouton('Voir ma réservation'); await texte('Logement réservé'); await ecran('logement_reserve');

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
    // Retirer est un super-pouvoir : il faut d'abord vérifier son identité (N2).
    await texte('super-pouvoir'); await ecran('retrait_verrouille');
    await bouton('Vérifier mon identité');
    await bouton('Photo du recto'); await bouton('Photo du verso'); await ecran('verifier_piece');
    await bouton('Continuer'); await bouton('Prendre le selfie'); await ecran('verifier_selfie');
    await bouton('Continuer'); await ecran('verifier_momo');
    await bouton('Envoyer pour vérification'); await p.waitForTimeout(3000);
    await texte('Identité vérifiée'); await ecran('identite_verifiee');
    await bouton('Continuer'); await p.waitForTimeout(1200);
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

    // 7. Tour de tous les autres écrans (maquettes), avec les panneaux du bas.
    const defiler = async (n) => { await p.mouse.move(LARGEUR / 2, 400); for (let i = 0; i < n; i++) { await p.mouse.wheel(0, 350); await p.waitForTimeout(250); } await sem(); };
    const fermer = async () => { await p.keyboard.press('Escape'); await p.waitForTimeout(700); };
    const TOUR = [
      ['connexion', 'connexion'],
      ['accueil', 'fil_retour'],
      ['accueil', 'fil_commentaires', async () => { await bouton('84', { exact: true }); }],
      ['accueil', 'fil_partage', async () => { await fermer(); await bouton('210', { exact: true }); }],
      ['accueil', 'fil_options', async () => { await fermer(); await bouton('Plus', { exact: true }); }],
      ['explorer', 'explorer_retour'],
      ['recherche', 'recherche_suggestions'],
      ['alertes', 'alertes'],
      ['notifications', 'notifications'],
      ['market', 'market_accueil'],
      ['market', 'market_bas_de_page', async () => { await defiler(40); }],
      ['market/liste?categorie=T%C3%A9l%C3%A9phones', 'market_liste'],
      ['commandes', 'mes_commandes'],
      ['produit/p1', 'produit_a_la_remise'],
      ['commande/p1', 'commande_a_la_remise'],
      ['paiements', 'guide_paiements'],
      ['produit/p9', 'produit_alimentation'],
      ['produit/p1', 'produit_offre', async () => { await bouton('Négocier'); }],
      ['boutique/grace', 'boutique'],
      ['vente/LV-00466/qr', 'qr_paiement_vendeur'],
      ['immo', 'immo_filtres', async () => { await bouton('Filtres'); }],
      ['bien/b9', 'bien_a_vendre'],
      ['bien/b1', 'bien_reglement', async () => { await defiler(7); }],
      ['bien/b1', 'bien_signaler', async () => { await defiler(12); await bouton('Déjà loué ou annonce fausse ?'); }],
      ['boutique/palmiers', 'agence_page'],
      ['agence', 'agence_tableau'],
      ['agence/visite/dv1', 'agence_valider_visite'],
      ['services', 'services_accueil'],
      ['pro/s1', 'profil_prestataire'],
      ['pro/s5/reserver/sf7', 'service_prix_fixe'],
      ['pro/interventions', 'pro_interventions'],
      ['pro/devis/nouveau', 'pro_creer_devis'],
      ['publier', 'publier'],
      ['publier/media', 'publier_video'],
      ['publier/envois', 'publier_envois'],
      ['publier/bien', 'publier_bien'],
      ['publier/service', 'publier_service'],
      ['messages', 'messages'],
      ['conversation', 'conversation'],
      ['conversation', 'conversation_lieu', async () => { await bouton('Joindre'); }],
      ['messages/demandes', 'messages_demandes'],
      ['messages/archives', 'messages_archives'],
      ['messages/parametres', 'messages_reglages'],
      ['abonnes/moi', 'abonnes'],
      ['suivis', 'suivis_activite'],
      ['enregistres', 'enregistres'],
      ['avis/commande/LV-00482', 'avis'],
      ['probleme/commande/LV-00482', 'probleme'],
      ['reclamation/RC-00001', 'reclamation'],
      ['recu/LV-00482', 'recu'],
      ['gains', 'gains'],
      ['mes-ventes', 'mes_ventes_bilan'],
      ['ia/documents', 'ia_mes_documents'],
      ['ia/business-plan', 'ia_business_plan'],
      ['ia/tuteur', 'ia_tuteur'],
      ['moi', 'moi'],
      ['pouvoirs', 'pouvoirs'],
      ['live-pro', 'live_pro'],
      ['espace/nouveau', 'espace_creer'],
      ['espace/equipe', 'espace_equipe'],
      ['profil/moi', 'profil_public'],
      ['parametres', 'parametres'],
      ['notifications/preferences', 'notifications_preferences'],
      ['donnees', 'donnees'],
      ['interets', 'interets_retour'],
      ['admin', 'admin_tableau'],
      ['admin/kyc', 'admin_kyc'],
      ['admin/kyc/k1', 'admin_dossier_kyc'],
      ['admin/moderation', 'admin_moderation'],
      ['admin/litiges', 'admin_litiges'],
      ['admin/litiges/l1', 'admin_litige'],
      ['admin/finance', 'admin_finance'],
      ['admin/utilisateurs', 'admin_utilisateurs'],
      ['admin/utilisateurs/u2', 'admin_fiche_utilisateur'],
      ['admin/configuration', 'admin_configuration'],
      ['scenarios', 'scenarios_test'],
      ['explorer', 'explorer_bientot', async () => { await defiler(2); }],
      ['apprendre', 'savoir_accueil'],
      ['contenu/n1', 'savoir_fiche'],
      ['panier', 'savoir_panier', async () => { await p.goto(BASE + '#/contenu/n5'); await p.waitForTimeout(1500); await sem(); await bouton('Au panier'); await bouton('Voir le panier'); }],
      ['mes-achats', 'savoir_mes_achats'],
      ['lecteur/n1', 'savoir_lecteur'],
      ['apprendre/vendre', 'savoir_vendre'],
      ['apprendre/boutique', 'savoir_boutique'],
      ['opportunites', 'emploi_accueil'],
      ['opportunite/o2', 'emploi_fiche'],
      ['opportunite/o1/postuler', 'emploi_postuler'],
      ['mes-candidatures', 'emploi_candidatures'],
      ['publier/opportunite', 'emploi_publier'],
      ['groupe/g1', 'groupe'],
      ['groupe/g2', 'canal'],
    ];
    for (const [route, nom, action] of TOUR) {
      etape = 'écran ' + nom;
      const actuel = await p.evaluate(() => location.hash);
      if (actuel !== '#/' + route) { await p.goto(BASE + '#/' + route); await p.waitForTimeout(1500); await sem(); }
      if (action) { await action(); await p.waitForTimeout(900); }
      await ecran(nom);
    }
    await fermer();
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
