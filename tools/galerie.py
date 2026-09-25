"""Génère la galerie HTML de toute l'application à partir des captures du test de bout en bout.

Usage : python3 tools/galerie.py app/test_e2e/captures app/test_e2e/captures1280 dossier_sortie
Les captures sont nommées NNN_nom.png ; chaque nom est rangé dans l'espace de l'application
auquel il appartient. La galerie a deux parties : Mobile (360 px) et Ordinateur (1280 px).
Les images sont écrites dans des fichiers data/<appareil>_<espace>.js, chargés à la demande.
"""
import base64, glob, html, io, json, os, sys
from PIL import Image

SECTIONS = [
    ('demarrage', 'Démarrage', 'Premier lancement : accueil, numéro MoMo, code SMS, profil, code secret, centres d’intérêt.', {
        'splash': ('Ouverture', 'Logo animé, puis la bienvenue'),
        'bienvenue': ('Accueil de l’application', 'Commencer, découvrir sans compte ou se connecter'),
        'inscription_telephone': ('Numéro de téléphone', 'Opérateur détecté, consentements explicites'),
        'code_sms_vide': ('Code reçu par SMS', '6 chiffres, renvoi après 45 s'),
        'code_aide': ('Code non reçu ?', 'Conseils, modifier le numéro, assistance'),
        'inscription_profil': ('Profil', 'Prénom, ville, 18 ans ou plus'),
        'code_secret': ('Code secret Live', 'Protège le compte'),
        'code_secret_confirmer': ('Confirmer le code secret', 'Deux saisies identiques, empreinte en option'),
        'interets': ('Centres d’intérêt', 'Un fil utile dès la première ouverture'),
        'connexion': ('Connexion', 'Retour d’un utilisateur'),
    }),
    ('fil', 'Accueil · fil vidéo', 'Le fil façon TikTok : chaque vidéo porte son annonce, et les directs sont à un geste.', {
        'fil': ('Fil « Pour toi »', 'Actions à droite, auteur, son, progression'),
        'fil_annonce': ('Annonce depuis la vidéo', 'Acheter sans quitter le fil'),
        'fil_retour': ('Fil, après les parcours', ''),
        'fil_commentaires': ('Commentaires', 'Réponse du vendeur mise en avant'),
        'fil_partage': ('Partager', 'WhatsApp, Facebook, SMS, lien avec aperçu'),
        'fil_options': ('Options', 'Enregistrer, masquer, signaler'),
    }),
    ('explorer', 'Explorer et recherche', 'Tous les espaces de Live, le meilleur de chacun, la recherche, la carte et les alertes.', {
        'explorer': ('Explorer', 'Les 8 espaces de Live'),
        'explorer_directs': ('Explorer · directs', 'En direct maintenant, bonnes affaires'),
        'explorer_savoir': ('Explorer · savoir et emploi', 'Cours et opportunités à saisir'),
        'explorer_outils': ('Outils et services Live', 'Groupes, livraison, studio, Live Plus, finance'),
        'explorer_retour': ('Explorer', 'Cartes de même taille dans chaque rangée'),
        'explorer_loupe': ('Recherche dans l’en-tête', 'La loupe déploie le champ'),
        'recherche_suggestions': ('Recherche', 'Récentes, tendances, catégories'),
        'alertes': ('Mes alertes', 'Recherches sauvegardées et notifiées'),
        'recherche_corrigee': ('Recherche corrigée', '« climatiser » → climatiseur'),
        'carte_logements': ('Carte des logements', 'Plan de Brazzaville, prix, fiches'),
        'carte_pros': ('Carte des prestataires', 'Métier et quartier'),
        'carte_satellite': ('Vue satellite', 'Zoom, ma position, vue rue'),
        'vue_rue': ('Vue rue', 'Glisser pour regarder autour, avancer'),
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
        'juste_prix': ('Le juste prix', 'Fourchette du marché, verdict de Live IA'),
        'produit_alimentation': ('Fiche produit', 'Produit à prix fixe'),
        'produit_offre': ('Négocier', 'Offre de prix envoyée au vendeur'),
        'variantes': ('Taille et quantité', 'Stock restant affiché'),
        'boutique': ('Page boutique', 'Abonnés, ventes, note, produits'),
        'commande': ('Commande', 'Remise en main propre ou livraison'),
        'paiement': ('Paiement', 'MTN MoMo, Airtel Money ou Visa'),
        'attente_momo': ('Validation MoMo', 'Live ne demande jamais le code MoMo'),
        'paiement_reussi': ('Paiement réussi', 'Argent bloqué jusqu’à réception'),
        'suivi_qr': ('Suivi de commande', 'Frise et QR de confirmation'),
        'reception_confirmee': ('Réception confirmée', 'Le vendeur est payé'),
        'recu': ('Reçu', 'Référence opérateur, séquestre'),
        'livraison': ('Live Livraison', 'Livreur suivi sur le plan, code de remise'),
    }),
    ('vendre', 'Vendre et publier', 'Publier en une minute, accepter, remettre en scannant le QR de l’acheteur, être payé.', {
        'publier': ('Publier', 'Chaque option dit si le super-pouvoir est actif'),
        'vendre_categorie': ('Vendre · 1/6', 'Que vendez-vous ?'),
        'vendre_photo_ia': ('Une photo, et c’est prêt', 'Live IA reconnaît l’objet et remplit l’annonce'),
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
        'coach_vendeur': ('Conseils de Live IA', 'Prix, photo, heure de publication'),
        'mes_ventes_outils': ('Outils du vendeur', 'Menu latéral : annonces, QR, gains, stats'),
        'mes_ventes_detail': ('Fiche de commande', 'Acheteur, suivi, commission, net'),
        'mes_ventes_refus': ('Refuser une commande', 'Motif obligatoire, remboursement immédiat'),
        'publier_video': ('Nouvelle vidéo', 'Plein écran : outils, 60 s, galerie'),
        'publier_video_galerie': ('Galerie', '10 photos et 1 vidéo au plus'),
        'publier_video_legende': ('Légende et lien', 'Bouton « Acheter » sur la vidéo'),
        'publier_envois': ('Envois en cours', 'Reprise après coupure réseau'),
    }),
    ('immo', 'Live Immo et séjours', 'Logements vérifiés, visite payée puis confirmée par QR, réservation protégée ; séjours meublés à la nuit.', {
        'immo_liste': ('Accueil Immo', 'Louer ou acheter, catégories, à la une'),
        'immo_sejours': ('Accueil Immo, suite', 'Séjours meublés, visites en direct'),
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
        'sejours': ('Séjours meublés', 'Location de courte durée'),
        'sejour': ('Réserver un séjour', 'Nuits, voyageurs, payé dans Live'),
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
    ('directs', 'Directs et créateurs', 'Vendre et visiter en direct, cadeaux, fans, studio, et le Fonds Créateurs financé par la publicité.', {
        'directs': ('Live Direct', 'En direct, à venir avec rappel'),
        'direct': ('Direct', 'Commentaires, cœurs, produit épinglé'),
        'direct_cadeaux': ('Cadeaux', '75 % pour le créateur'),
        'direct_visite': ('Visite en direct', 'Bien immobilier présenté en live'),
        'direct_lancer': ('Lancer un direct', 'Produits épinglés, réglages'),
        'studio': ('Studio créateur', 'Statistiques, outils, 500 abonnés'),
        'fans': ('Devenir fan', 'Fan, Super fan, contenus réservés'),
        'fonds_createurs': ('Fonds Créateurs', 'Financé par la publicité'),
    }),
    ('savoir', 'Live Savoir', 'Cours, PDF, vidéos et QCM ; payés dans Live, lisibles hors connexion ; et vendre son savoir.', {
        'savoir_accueil': ('Live Savoir', 'Cours, PDF, vidéos, QCM, coaching'),
        'savoir_fiche': ('Fiche d’un cours', 'Aperçu gratuit, programme, avis'),
        'savoir_panier': ('Panier', 'Contenus numériques payés dans Live'),
        'savoir_mes_achats': ('Mes achats', 'Téléchargement pour le hors connexion'),
        'savoir_lecteur': ('Lecteur', 'Leçons, hors connexion'),
        'savoir_vendre': ('Vendre un contenu', 'Assistant en 6 étapes'),
        'savoir_boutique': ('Ma boutique de savoirs', 'Revenus, répartition, solde'),
    }),
    ('emploi', 'Live Emploi', 'Bourses, concours, stages et emplois : postuler est gratuit, les frais officiels sont affichés.', {
        'emploi_accueil': ('Live Emploi', 'Bourses, concours, stages, emplois'),
        'emploi_fiche': ('Fiche d’un concours', 'Coûts et frais transparents'),
        'emploi_postuler': ('Postuler', 'Gratuit, pièces, motivation'),
        'emploi_candidatures': ('Mes candidatures', 'Envoyée, vue, présélection'),
        'emploi_publier': ('Publier une opportunité', 'Assistant en 4 étapes'),
    }),
    ('ia', 'Live IA et Live Plus', 'Les produits propres à Live, payés en Crédits Live (1 crédit = 10 FCFA), ou chaque mois avec Live Plus.', {
        'ia_accueil': ('Live IA', 'Solde et services par besoin'),
        'ia_assistant': ('Assistant Live', 'Écrit ou voix : français, lingala, kituba'),
        'ia_assistant_reponse': ('L’assistant agit', 'Réserver la visite, créer l’alerte'),
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
        'live_plus': ('Live Plus', 'Crédits IA chaque mois'),
    }),
    ('quotidien', 'Argent et quotidien', 'Tontines, achats groupés, diaspora et transferts, factures et crédit, Adresse Live, points relais.', {
        'tontines': ('Mes tontines', 'Cotisations gardées par Live, créer une tontine'),
        'tontine': ('Une tontine', 'Cagnotte, ordre des tours, cotiser'),
        'achats_groupes': ('Achats groupés', 'Prix de gros à l’objectif, sinon remboursé'),
        'diaspora': ('Diaspora', 'Payer pour un proche, preuve de remise'),
        'transfert': ('Live Transfert', 'Taux fixe euro, retrait MoMo sans frais'),
        'factures': ('Factures et crédit', 'Électricité, eau, télévision, recharge'),
        'adresse_live': ('Adresse Live', 'Un code, une position, un repère'),
        'points_relais': ('Points relais', 'Colis et espèces vers Mobile Money'),
    }),
    ('messages', 'Messages, groupes et confiance', 'Messagerie protégée contre les arnaques, groupes et canaux ; avis vérifiés, réclamations suivies.', {
        'messages': ('Messages', 'Non lus, coches, annonce liée'),
        'messages_loupe': ('Rechercher une conversation', 'Loupe dans l’en-tête, filtre immédiat'),
        'conversation': ('Conversation', 'Vocal, offre, alerte anti-arnaque'),
        'conversation_lieu': ('Lieu de rendez-vous', 'Lieux publics recommandés'),
        'messages_demandes': ('Demandes de messages', 'Inconnus à part, arnaque signalée'),
        'messages_archives': ('Archivées', ''),
        'messages_reglages': ('Réglages des messages', 'Qui peut écrire, lecture, Wi-Fi'),
        'avis': ('Laisser un avis', 'Seuls les clients ayant payé notent'),
        'probleme': ('Signaler un problème', 'Argent bloqué pendant l’examen'),
        'reclamation': ('Suivi de réclamation', 'Réponse du vendeur, décision Live'),
        'groupe': ('Groupe', 'Message épinglé, PDF, réactions'),
        'canal': ('Canal', 'Seuls les administrateurs publient'),
    }),
    ('moi', 'Moi, gains et outils', 'Tout le monde est utilisateur et débloque des super-pouvoirs ; outils pour vendre, créer et grandir.', {
        'retrait_verrouille': ('Retrait verrouillé', 'Retirer est un super-pouvoir'),
        'verifier_piece': ('Vérifier mon identité · 1/3', 'Pièce d’identité'),
        'verifier_selfie': ('Vérifier mon identité · 2/3', 'Selfie'),
        'verifier_momo': ('Vérifier mon identité · 3/3', 'Nom Mobile Money identique'),
        'identite_verifiee': ('Identité vérifiée', 'Nouveaux super-pouvoirs débloqués'),
        'retrait': ('Retirer', 'Montant et compte MoMo'),
        'retrait_ok': ('Retrait envoyé', ''),
        'gains': ('Mes gains', 'Disponible, en attente, historique'),
        'moi': ('Moi', 'Profil social, super-pouvoirs, raccourcis'),
        'moi_menu': ('Menu du profil', 'Compte, mon espace, créateur, activité'),
        'barre_repliee': ('Barre latérale repliée', 'Plus de place pour le contenu'),
        'barre_depliee': ('Barre latérale dépliée', 'Logo, libellés, bouton Replier'),
        'moi_createur': ('Moi · créer et gagner', 'Studio, direct, Live Plus, publicité, finance'),
        'moi_suite': ('Moi', ''),
        'pouvoirs': ('Mes super-pouvoirs', 'À débloquer et actifs, N1 → N3 → Pro'),
        'live_pro': ('Live Pro', 'Statistiques, boosts −30 %'),
        'espace_creer': ('Créer un espace', 'Boutique, agence, prestataire, chaîne'),
        'espace_equipe': ('Équipe', 'Rôles internes, journal'),
        'profil_public': ('Profil public', 'Couverture, avatar, vidéos'),
        'abonnes': ('Mes relations · abonnés', 'Recherche, tri, filtres, Suivre en retour'),
        'abonnements': ('Mes relations · abonnements', 'Vous suit, cloche des publications'),
        'suggestions': ('Suggestions', 'Suivi par…, inviter ses contacts'),
        'relations_menu': ('Options d’un compte', 'Retirer, sourdine, bloquer, signaler'),
        'bloques': ('Comptes bloqués', 'Débloquer à tout moment'),
        'suivis_activite': ('Activité des abonnements', 'Nouveautés des comptes suivis'),
        'enregistres': ('Enregistrés', 'Annonces sauvegardées'),
        'parametres': ('Paramètres', 'Compte, sécurité, préférences'),
        'donnees': ('Économie de données', 'Vidéos en 360p sur réseau mobile'),
        'interets_retour': ('Centres d’intérêt', ''),
        'parametres_pays': ('Pays et ville', 'Toute la zone CEMAC, en FCFA'),
        'offres_pro': ('Offres Pro', 'Vendeur, Agence, Prestataire, Entreprise'),
        'publicite': ('Publicité', 'Ciblage, budget, portée'),
        'finance': ('Services financiers', '3 fois, tirelire, micro-crédit'),
        'partenaires': ('API partenaires', 'Catalogue, commandes, Live Pay, livraison'),
    }),
    ('admin', 'Back-office', 'L’outil interne des équipes Live, pensé pour l’ordinateur : vérifications, modération, litiges, finance.', {
        'admin_replie': ('Menu replié', 'Icônes seules, une touche pour déplier'),
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
        'admin_validations': ('Double validation', 'Quatre yeux : l’auteur ne valide pas sa demande'),
        'admin_journal': ('Journal d’audit', 'Filtrable, exportable, inaltérable'),
        'admin_equipe': ('Équipe Live', 'Super administrateur, délégués, permissions'),
        'admin_inviter': ('Inviter un administrateur', 'Fonction et permissions'),
        'admin_connexion': ('Connexion d’un agent', 'E-mail professionnel, mot de passe'),
        'admin_2fa': ('Double authentification', 'Code de l’application d’authentification'),
        'scenarios_test': ('Scénarios du test terrain', 'Pour l’animateur'),
    }),
]

# Écrans pensés pour un seul appareil.
ORDINATEUR_SEULEMENT = {'admin'}


def webp(chemin, largeur, qualite):
    im = Image.open(chemin).convert('RGB')
    if im.width > largeur:
        im = im.resize((largeur, round(im.height * largeur / im.width)), Image.LANCZOS)
    b = io.BytesIO()
    im.save(b, 'WEBP', quality=qualite, method=6)
    return 'data:image/webp;base64,' + base64.b64encode(b.getvalue()).decode(), im.size


def captures(dossier):
    """Dernière capture de chaque nom (le tour repasse parfois sur un écran)."""
    out = {}
    for f in sorted(glob.glob(os.path.join(dossier, '*.png'))):
        nom = os.path.basename(f)[4:-4]
        if nom != 'ECHEC':
            out.setdefault(nom, f)
    return out


def partie(appareil, dossier, largeur, qualite, sortie):
    fichiers = captures(dossier)
    code = appareil[0]
    nav, corps, total = [], [], 0
    for sid, titre, desc, noms in SECTIONS:
        if appareil == 'mobile' and sid in ORDINATEUR_SEULEMENT:
            continue
        images, figs = {}, []
        for nom, (t, s) in noms.items():
            if nom not in fichiers:
                continue
            total += 1
            cle = f'{code}{total}'
            images[cle], (w, h) = webp(fichiers[nom], largeur, qualite)
            figs.append(
                f'<figure><button class="shot" type="button" aria-label="Agrandir : {html.escape(t)}">'
                f'<img data-k="{cle}" alt="{html.escape(t)}" width="{w}" height="{h}"></button>'
                f'<figcaption><span class="n">{total:03d}</span><b>{html.escape(t)}</b>'
                f'{("<small>" + html.escape(s) + "</small>") if s else ""}</figcaption></figure>')
        if not figs:
            continue
        donnees = f'{code}_{sid}.js'
        with open(os.path.join(sortie, 'data', donnees), 'w') as f:
            f.write('charger(' + json.dumps(images) + ');')
        nav.append(f'<a href="#{code}-{sid}">{html.escape(titre)} <span>{len(figs)}</span></a>')
        classe = 'grid' if appareil == 'mobile' else 'gridw'
        corps.append(
            f'<section id="{code}-{sid}" data-src="data/{donnees}"><header class="sh"><h2>{html.escape(titre)}</h2>'
            f'<p>{html.escape(desc)}</p></header><div class="{classe}">{"".join(figs)}</div></section>')
    return total, ''.join(nav), ''.join(corps)


def main(tel, ordi, sortie):
    os.makedirs(os.path.join(sortie, 'data'), exist_ok=True)
    for f in glob.glob(os.path.join(sortie, 'data', '*.js')):
        os.remove(f)
    tete = open(os.path.join(os.path.dirname(__file__), 'galerie_tete.html')).read()
    nm, navm, corpsm = partie('mobile', tel, 540, 74, sortie)
    no, navo, corpso = partie('ordinateur', ordi, 1280, 72, sortie)
    logo = Image.open(os.path.join(os.path.dirname(__file__), '..', 'app', 'assets', 'images', 'logo.png'))
    b = io.BytesIO()
    logo.resize((80, 80), Image.LANCZOS).save(b, 'PNG')
    tete = tete.replace('{{LOGO}}', 'data:image/png;base64,' + base64.b64encode(b.getvalue()).decode())
    page = (tete.replace('{{NM}}', str(nm)).replace('{{NO}}', str(no))
            .replace('{{NAVM}}', navm).replace('{{NAVO}}', navo)
            .replace('{{CORPSM}}', corpsm).replace('{{CORPSO}}', corpso))
    open(os.path.join(sortie, 'index.html'), 'w').write(page)
    poids = sum(os.path.getsize(f) for f in glob.glob(os.path.join(sortie, 'data', '*.js')))
    plus_gros = max(os.path.getsize(f) for f in glob.glob(os.path.join(sortie, 'data', '*.js')))
    print(f'{nm} écrans mobile, {no} écrans ordinateur, données {poids // 1024} Ko '
          f'(plus gros fichier {plus_gros // 1024} Ko)')


if __name__ == '__main__':
    main(*sys.argv[1:4])
