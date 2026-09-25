"""Génère la galerie HTML des maquettes à partir des captures du test de bout en bout.

Usage : python3 tools/galerie.py app/test_e2e/captures app/test_e2e/captures1280 sortie.html
Les captures sont nommées NNN_nom.png ; chaque nom est rangé dans une section.
"""
import base64, glob, html, io, os, sys
from PIL import Image

SECTIONS = [
    ('demarrage', 'Démarrage', 'Premier lancement : accueil, numéro MoMo, code SMS, profil, code secret, centres d’intérêt.', {
        'bienvenue': ('Accueil de l’application', 'Commencer, découvrir sans compte ou se connecter'),
        'inscription_telephone': ('Numéro de téléphone', 'Opérateur détecté, consentements explicites'),
        'code_sms_vide': ('Code reçu par SMS', '6 chiffres, renvoi après 45 s'),
        'inscription_profil': ('Profil', 'Prénom, ville, 18 ans ou plus'),
        'code_secret': ('Code secret Live', 'Protège le compte'),
        'interets': ('Centres d’intérêt', 'Un fil utile dès la première ouverture'),
        'connexion': ('Connexion', 'Retour d’un utilisateur'),
    }),
    ('fil', 'Fil vidéo', 'Le fil façon TikTok : chaque vidéo porte son annonce et son bouton d’achat.', {
        'fil': ('Fil « Pour toi »', 'Actions à droite, auteur, son, progression'),
        'fil_annonce': ('Annonce depuis la vidéo', 'Acheter sans quitter le fil'),
        'fil_retour': ('Fil, après les parcours', ''),
        'fil_commentaires': ('Commentaires', 'Réponse du vendeur mise en avant'),
        'fil_partage': ('Partager', 'WhatsApp, Facebook, SMS, lien avec aperçu'),
        'fil_options': ('Options', 'Enregistrer, masquer, signaler'),
    }),
    ('explorer', 'Explorer et recherche', 'Les 4 espaces, les meilleures annonces, la recherche et les alertes.', {
        'explorer': ('Explorer', 'Market, Immo, Services, Live IA'),
        'explorer_retour': ('Explorer', 'Cartes de même taille dans chaque rangée'),
        'recherche_suggestions': ('Recherche', 'Récentes, tendances, catégories'),
        'alertes': ('Mes alertes', 'Recherches sauvegardées et notifiées'),
        'notifications': ('Notifications', 'Paiements, visites, devis, alertes'),
        'notifications_preferences': ('Préférences', 'Les paiements ne se coupent pas'),
    }),
    ('market', 'Live Market', 'Acheter protégé : l’argent est bloqué par Live jusqu’à la remise, confirmée par QR.', {
        'market_accueil': ('Accueil Market', 'Carrousel, catégories, recommandés'),
        'market_bas_de_page': ('Accueil Market, suite', 'Commandes, vendre, paiements, aide'),
        'market_liste': ('Liste d’une catégorie', 'Tri par pertinence, nouveautés, prix'),
        'produit_a_la_remise': ('Objet à voir avant d’acheter', 'Payé à la remise, jamais d’avance'),
        'commande_a_la_remise': ('Voir avant de payer', 'Lieu public, paiement MoMo au rendez-vous'),
        'mes_commandes': ('Mes commandes', 'État de chaque achat'),
        'guide_paiements': ('Ce qui se paie dans Live', 'Dans Live, à la remise, en direct'),
        'fiche_produit': ('Fiche produit', 'Photo plein cadre, vendeur, protection'),
        'produit_alimentation': ('Fiche produit', 'Produit à prix fixe'),
        'produit_offre': ('Négocier', 'Offre de prix envoyée au vendeur'),
        'boutique': ('Page boutique', 'Abonnés, ventes, note, produits'),
        'commande': ('Commande', 'Remise en main propre ou livraison'),
        'paiement': ('Paiement', 'MTN MoMo, Airtel Money ou Visa'),
        'attente_momo': ('Validation MoMo', 'Live ne demande jamais le code MoMo'),
        'paiement_reussi': ('Paiement réussi', 'Argent bloqué jusqu’à réception'),
        'suivi_qr': ('Suivi de commande', 'Frise et QR de confirmation'),
        'reception_confirmee': ('Réception confirmée', 'Le vendeur est payé'),
        'recu': ('Reçu', 'Référence opérateur, séquestre'),
    }),
    ('vendre', 'Vendre', 'Publier en une minute, accepter, remettre en scannant le QR de l’acheteur, être payé.', {
        'publier': ('Publier', 'Chaque option dit si le super-pouvoir est actif'),
        'vendre_categorie': ('Vendre · 1/6', 'Que vendez-vous ?'),
        'vendre_photos': ('Vendre · 2/6', 'Photos, couverture, vidéo 60 s'),
        'vendre': ('Vendre · 3/6', 'Titre, attributs, état, rédaction Live IA'),
        'vendre_prix': ('Vendre · 4/6', 'Prix, négociable, promotion, stock, gain'),
        'vendre_remise': ('Vendre · 5/6', 'Quartier, remise, paiement'),
        'vendre_apercu': ('Vendre · 6/6', 'Aperçu de l’annonce, certification'),
        'annonce_publiee': ('Félicitations', 'Annonce en ligne, partage'),
        'mes_ventes': ('Mes ventes', 'Nouvelle commande à accepter sous 24 h'),
        'remise_vendeur': ('Remise', 'Scanner le QR de l’acheteur'),
        'scan': ('Scan du QR', 'QR reconnu'),
        'remise_confirmee': ('Remise confirmée', 'Gains crédités'),
        'qr_paiement_vendeur': ('Encaisser à la remise', 'QR de paiement du vendeur'),
        'mes_ventes_bilan': ('Mes ventes', 'Revenus, vues, contacts, conversion, graphique'),
        'mes_ventes_outils': ('Outils du vendeur', 'Menu latéral : annonces, QR, gains, stats'),
        'mes_ventes_detail': ('Fiche de commande', 'Acheteur, suivi, commission, net'),
        'mes_ventes_refus': ('Refuser une commande', 'Motif obligatoire, remboursement immédiat'),
        'publier_video': ('Nouvelle vidéo', 'Plein écran : outils, 60 s, galerie'),
        'publier_video_galerie': ('Galerie', '10 photos et 1 vidéo au plus'),
        'publier_video_legende': ('Légende et lien', 'Bouton « Acheter » sur la vidéo'),
        'publier_envois': ('Envois en cours', 'Reprise après coupure réseau'),
    }),
    ('immo', 'Live Immo', 'Logements vérifiés, coût d’entrée affiché, visite payée puis confirmée par QR, réservation protégée.', {
        'immo_liste': ('Accueil Immo', 'Louer ou acheter, catégories, à la une'),
        'immo_filtres': ('Filtres', 'Budget et équipements'),
        'fiche_logement': ('Fiche logement', 'Caractéristiques en tuiles, coût d’entrée'),
        'bien_a_vendre': ('Bien à vendre', 'Villa avec titre foncier'),
        'bien_reglement': ('Comment ça se paie', 'Visite dans Live, loyers en direct'),
        'bien_signaler': ('Signaler une annonce', 'Déjà loué ou fausse'),
        'creneau': ('Demander une visite', 'Jour, heure, frais remboursables'),
        'visite_qr': ('Visite réservée', 'Adresse exacte et QR de visite'),
        'visite_confirmee': ('Visite effectuée', 'L’agence peut proposer une réservation'),
        'offre_reservation': ('Offre de réservation', 'Acompte bloqué jusqu’aux clés'),
        'logement_reserve': ('Logement réservé', ''),
        'agence_page': ('Page de l’agence', 'Biens, vidéos, avis'),
        'agence_tableau': ('Espace agence', 'Visites du jour, demandes, biens, équipe'),
        'agence_valider_visite': ('Valider une visite', 'L’agent scanne le QR du visiteur'),
        'publier_bien': ('Publier un bien', 'Assistant en 5 étapes'),
    }),
    ('services', 'Live Services', 'Décrire son besoin, comparer des devis, payer un acompte protégé ; et le côté du prestataire.', {
        'services_accueil': ('Accueil Services', 'Métiers, prix fixes, pros disponibles'),
        'demande_devis': ('Demande de devis', 'Métier, problème, photos, date'),
        'devis_recus': ('Devis reçus', '3 devis comparés'),
        'detail_devis': ('Détail du devis', 'Acompte et garantie 72 h'),
        'prestation_qr': ('Prestation', 'QR pour démarrer les travaux'),
        'prestation_terminee': ('Travaux terminés', 'Reste à payer à la fin'),
        'profil_prestataire': ('Profil du prestataire', 'Note, interventions, services, réalisations'),
        'service_prix_fixe': ('Réserver à prix fixe', 'Créneau et adresse'),
        'pro_interventions': ('Mes interventions (pro)', 'Demandes à chiffrer, agenda'),
        'pro_creer_devis': ('Créer un devis (pro)', 'Lignes, acompte, créneau'),
        'publier_service': ('Proposer un service', 'Métier, tarif, zones, réalisations'),
    }),
    ('confiance', 'Messages et confiance', 'Messagerie façon WhatsApp, protégée contre les arnaques ; avis vérifiés, réclamations suivies.', {
        'messages': ('Messages', 'Non lus, coches, annonce liée'),
        'conversation': ('Conversation', 'Vocal, offre, alerte anti-arnaque'),
        'conversation_lieu': ('Lieu de rendez-vous', 'Lieux publics recommandés'),
        'messages_demandes': ('Demandes de messages', 'Inconnus à part, arnaque signalée'),
        'messages_archives': ('Archivées', ''),
        'messages_reglages': ('Réglages des messages', 'Qui peut écrire, lecture, Wi-Fi'),
        'avis': ('Laisser un avis', 'Seuls les clients ayant payé notent'),
        'probleme': ('Signaler un problème', 'Argent bloqué pendant l’examen'),
        'reclamation': ('Suivi de réclamation', 'Réponse du vendeur, décision Live'),
    }),
    ('gains', 'Gains et super-pouvoirs', 'Tout le monde est utilisateur ; chacun débloque des super-pouvoirs pour gagner de l’argent.', {
        'retrait_verrouille': ('Retrait verrouillé', 'Retirer est un super-pouvoir'),
        'verifier_piece': ('Vérifier mon identité · 1/3', 'Pièce d’identité'),
        'verifier_selfie': ('Vérifier mon identité · 2/3', 'Selfie'),
        'verifier_momo': ('Vérifier mon identité · 3/3', 'Nom Mobile Money identique'),
        'identite_verifiee': ('Identité vérifiée', 'Nouveaux super-pouvoirs débloqués'),
        'retrait': ('Retirer', 'Montant et compte MoMo'),
        'retrait_ok': ('Retrait envoyé', ''),
        'gains': ('Mes gains', 'Disponible, en attente, historique'),
        'moi': ('Moi', 'Profil social, super-pouvoirs, raccourcis'),
        'moi_menu': ('Menu du profil', 'Compte, mon espace, espaces pro, aide'),
        'moi_suite': ('Moi', ''),
        'pouvoirs': ('Mes super-pouvoirs', 'À débloquer et actifs, N1 → N3 → Pro'),
        'live_pro': ('Live Pro', 'Statistiques, boosts −30 %'),
        'espace_creer': ('Créer un espace', 'Boutique, agence, prestataire, chaîne'),
        'espace_equipe': ('Équipe', 'Rôles internes, journal'),
        'profil_public': ('Profil public', 'Couverture, avatar, vidéos'),
        'abonnes': ('Abonnés et abonnements', 'Filtres par type de compte'),
        'suivis_activite': ('Activité des abonnements', 'Nouveautés des comptes suivis'),
        'enregistres': ('Enregistrés', 'Annonces sauvegardées'),
        'parametres': ('Paramètres', 'Compte, sécurité, préférences'),
        'donnees': ('Économie de données', 'Vidéos en 360p sur réseau mobile'),
        'interets_retour': ('Centres d’intérêt', ''),
    }),
    ('ia', 'Live IA', 'Les produits propres à Live, payés en Crédits Live (1 crédit = 10 FCFA).', {
        'ia_accueil': ('Live IA', 'Solde et services par besoin'),
        'ia_credits': ('Acheter des crédits', 'Packs de 500 à 5 000 FCFA'),
        'ia_solde': ('Crédits ajoutés', ''),
        'ia_cv_formulaire': ('CV complet', 'Pré-rempli depuis le profil'),
        'ia_confirmation': ('Confirmation du prix', 'Solde avant et après'),
        'ia_cv_resultat': ('CV généré', 'PDF, Word, révision gratuite'),
        'ia_exercice': ('Exercice par photo', 'Niveau et mode apprentissage'),
        'ia_etape': ('Mode apprentissage', 'L’élève répond, l’IA explique'),
        'ia_exercice_fin': ('Récapitulatif', 'Solution justifiée'),
        'ia_mes_documents': ('Mes documents', ''),
        'ia_business_plan': ('Business plan', 'Assistant en 6 étapes, prévisionnel'),
        'ia_tuteur': ('Tuteur vocal', 'Conversation orale, 5 crédits / min'),
    }),
    ('apercus', 'Aperçus des phases suivantes', 'Hors MVP, étiquetés : Live Savoir et Live Emploi (phase 3), groupes et canaux (phase 2).', {
        'explorer_bientot': ('Bientôt sur Live', 'Accès aux aperçus depuis Explorer'),
        'savoir_accueil': ('Live Savoir', 'Cours, PDF, vidéos, QCM, coaching'),
        'savoir_fiche': ('Fiche d’un cours', 'Aperçu gratuit, programme, avis'),
        'savoir_panier': ('Panier', 'Contenus numériques payés dans Live'),
        'savoir_mes_achats': ('Mes achats', 'Téléchargement pour le hors connexion'),
        'savoir_lecteur': ('Lecteur', 'Leçons, hors connexion'),
        'savoir_vendre': ('Vendre un contenu', 'Assistant en 6 étapes'),
        'savoir_boutique': ('Ma boutique de savoirs', 'Revenus, répartition, solde'),
        'emploi_accueil': ('Live Emploi', 'Bourses, concours, stages, emplois'),
        'emploi_fiche': ('Fiche d’un concours', 'Coûts et frais transparents'),
        'emploi_postuler': ('Postuler', 'Gratuit, pièces, motivation'),
        'emploi_candidatures': ('Mes candidatures', 'Envoyée, vue, présélection'),
        'emploi_publier': ('Publier une opportunité', 'Assistant en 4 étapes'),
        'groupe': ('Groupe', 'Message épinglé, PDF, réactions'),
        'canal': ('Canal', 'Seuls les administrateurs publient'),
    }),
    ('admin', 'Back-office', 'L’outil interne des équipes Live : vérifications, modération, litiges, finance.', {
        'admin_tableau': ('Tableau de bord', 'Volume, séquestre, santé des paiements'),
        'admin_kyc': ('Vérifications KYC', 'File par niveau de risque'),
        'admin_dossier_kyc': ('Dossier KYC', 'Pièces, selfie, contrôles, décision'),
        'admin_moderation': ('Modération', 'Contenus signalés ou détectés'),
        'admin_litiges': ('Litiges', ''),
        'admin_litige': ('Dossier de litige', 'Frise, preuves, décision tracée'),
        'admin_finance': ('Finance', 'Réconciliation, retraits suspects'),
        'admin_utilisateurs': ('Utilisateurs', ''),
        'admin_fiche_utilisateur': ('Fiche utilisateur', 'Capacités, journal d’audit'),
        'admin_configuration': ('Configuration', 'Commissions, plafonds, boosts'),
        'scenarios_test': ('Scénarios du test terrain', 'Pour l’animateur'),
    }),
]

def jpeg(chemin, largeur, qualite=78):
    im = Image.open(chemin).convert('RGB')
    if im.width > largeur:
        im = im.resize((largeur, round(im.height * largeur / im.width)), Image.LANCZOS)
    b = io.BytesIO()
    im.save(b, 'JPEG', quality=qualite, optimize=True)
    return 'data:image/jpeg;base64,' + base64.b64encode(b.getvalue()).decode()

def figures(dossier, noms, largeur, deja):
    fichiers = sorted(glob.glob(os.path.join(dossier, '*.png')))
    out = []
    for f in fichiers:
        nom = os.path.basename(f)[4:-4]
        if nom in noms and nom != 'ECHEC':
            if (nom, dossier) in deja and nom != 'ia_etape':
                continue
            deja.add((nom, dossier))
            out.append((nom, f))
    return out

def main(tel, ordi, sortie):
    tete = open(os.path.join(os.path.dirname(__file__), 'galerie_tete.html')).read()
    nav, corps, total, deja = [], [], 0, set()
    for sid, titre, desc, noms in SECTIONS:
        nav.append(f'<a href="#{sid}">{html.escape(titre)}</a>')
        figs = []
        for nom, f in figures(tel, noms, 640, deja):
            total += 1
            t, s = noms[nom]
            figs.append(f'<figure><button class="shot" type="button" aria-label="Agrandir : {html.escape(t)}"><img loading="lazy" src="{jpeg(f, 640, 70)}" alt="{html.escape(t)}" width="360" height="760"></button><figcaption><span class="n">{total:03d}</span><b>{html.escape(t)}</b>{("<small>" + html.escape(s) + "</small>") if s else ""}</figcaption></figure>')
        corps.append(f'<section id="{sid}"><header class="sh"><h2>{html.escape(titre)}</h2><p>{html.escape(desc)}</p></header><div class="grid">{"".join(figs)}</div></section>')
    # Ordinateur : une sélection d'écrans.
    choix = ['fil', 'explorer', 'market_accueil', 'fiche_produit', 'immo_liste', 'fiche_logement', 'agence_tableau', 'services_accueil', 'conversation', 'moi', 'pouvoirs', 'ia_accueil', 'admin_tableau', 'admin_finance']
    figs = []
    fichiers = {os.path.basename(f)[4:-4]: f for f in sorted(glob.glob(os.path.join(ordi, '*.png')))}
    for nom in choix:
        if nom in fichiers:
            titre = next((n[nom][0] for _, _, _, n in SECTIONS if nom in n), nom)
            figs.append(f'<figure class="wide"><button class="shot" type="button" aria-label="Agrandir : {html.escape(titre)}"><img loading="lazy" src="{jpeg(fichiers[nom], 1280, 74)}" alt="{html.escape(titre)}" width="1280" height="760"></button><figcaption><b>{html.escape(titre)}</b></figcaption></figure>')
    if figs:
      nav.append('<a href="#ordinateur">Sur ordinateur</a>')
      corps.append(f'<section id="ordinateur"><header class="sh"><h2>Sur ordinateur</h2><p>La même application en pleine largeur : barre latérale, grilles, deux colonnes.</p></header><div class="gridw">{"".join(figs)}</div></section>')
    page = tete.replace('{{TOTAL}}', str(total)).replace('{{NAV}}', ''.join(nav)).replace('{{CORPS}}', ''.join(corps))
    open(sortie, 'w').write(page)
    print(f'{total} écrans téléphone, {len(figs)} sur ordinateur, {os.path.getsize(sortie) // 1024} Ko')

if __name__ == '__main__':
    main(*sys.argv[1:4])
