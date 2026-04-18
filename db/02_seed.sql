-- ─────────────────────────────────────────────────────────────────
-- Données de test — 8 patients, 12 séjours
-- Couvre tous les cas de mapping : valeurs NULL, formats variés,
-- tous les types de séjour, tous les modes entrée/sortie
-- ─────────────────────────────────────────────────────────────────

-- ─── Patients ─────────────────────────────────────────────────────

INSERT INTO patient
  (ipp, ins_nir, nom_naissance, prenom_usuel, date_naissance, sexe,
   numero_voie, libelle_voie, code_postal, commune, pays,
   telephone, email, statut)
VALUES
  -- 1. Patient standard avec toutes les données
  ('IPP-0001', '1650312075123', 'DUPONT', 'JEAN PIERRE', '1965-03-12', 'M',
   '12', 'RUE DE LA PAIX', '75001', 'PARIS', 'FRA',
   '0612345678', 'jean.dupont@exemple.fr', 'ACTIF'),

  -- 2. Patiente avec prénom composé
  ('IPP-0002', '2780724069004', 'MARTIN', 'MARIE ANNE', '1978-07-24', 'F',
   '5', 'AVENUE VICTOR HUGO', '69001', 'LYON', 'FRA',
   '0687654321', NULL, 'ACTIF'),

  -- 3. Patient sans adresse (urgence non identifiée)
  ('IPP-0003', NULL, 'INCONNU', 'PATIENT', '1980-01-01', 'U',
   NULL, NULL, NULL, NULL, 'FRA',
   NULL, NULL, 'ACTIF'),

  -- 4. Patient belge (pays non FRA)
  ('IPP-0004', NULL, 'VAN DEN BERG', 'PIETER', '1955-11-30', 'M',
   '8', 'RUE DU MARCHÉ', '67000', 'STRASBOURG', 'BEL',
   '+3247123456', 'p.vandenberg@mail.be', 'ACTIF'),

  -- 5. Patiente décédée
  ('IPP-0005', '2420908031089', 'BERNARD', 'HÉLÈNE', '1942-09-08', 'F',
   '22', 'BOULEVARD GAMBETTA', '13001', 'MARSEILLE', 'FRA',
   NULL, NULL, 'DECEDE'),

  -- 6. Patient sexe inconnu (I = autre/intersexe)
  ('IPP-0006', '3991231099999', 'DUBOIS', 'ALEX', '1999-12-31', 'I',
   '3', 'IMPASSE DES LILAS', '31000', 'TOULOUSE', 'FRA',
   '0655443322', 'alex.dubois@mail.com', 'ACTIF'),

  -- 7. Patiente inactive
  ('IPP-0007', '2890615044012', 'LECLERC', 'SOPHIE', '1989-06-15', 'F',
   '17', 'RUE DES FLEURS', '44000', 'NANTES', 'FRA',
   NULL, NULL, 'INACTIF'),

  -- 8. Nourrisson (sans NIR propre, prénom très court)
  ('IPP-0008', NULL, 'PETIT', 'LÉO', '2024-02-10', 'M',
   '45', 'CHEMIN DU MOULIN', '33000', 'BORDEAUX', 'FRA',
   NULL, NULL, 'ACTIF');

-- ─── Séjours ──────────────────────────────────────────────────────

INSERT INTO sejour
  (id_patient, numero_sejour, date_entree, date_sortie,
   mode_entree, libelle_mode_entree, mode_sortie, libelle_mode_sortie,
   uf_code, uf_libelle, type_sejour, dp_cim, dp_libelle, statut)
VALUES
  -- Séjour 1 : MCO terminé — DUPONT (IPP-0001), entrée domicile, sortie domicile
  (1, 'NDA-2024-00001', '2024-03-10 08:30:00', '2024-03-15 11:00:00',
   '8', 'Domicile', '8', 'Retour à domicile',
   'UF-CHIR-DIG', 'Chirurgie digestive', 'MCO', 'K35.8', 'Appendicite aiguë sans précision', 'TERMINE'),

  -- Séjour 2 : MCO terminé — DUPONT (IPP-0001), second séjour
  (1, 'NDA-2024-00042', '2024-09-02 14:00:00', '2024-09-05 09:00:00',
   '8', 'Domicile', '8', 'Retour à domicile',
   'UF-CARDIO', 'Cardiologie', 'MCO', 'I20.0', 'Angor instable', 'TERMINE'),

  -- Séjour 3 : MCO en cours — MARTIN (IPP-0002)
  (2, 'NDA-2025-00103', '2025-11-20 10:15:00', NULL,
   '7', 'Transfert', NULL, NULL,
   'UF-NEURO', 'Neurologie', 'MCO', 'G35', 'Sclérose en plaques', 'EN_COURS'),

  -- Séjour 4 : SSR — MARTIN (IPP-0002), après rééducation
  (2, 'NDA-2024-00087', '2024-06-01 09:00:00', '2024-07-31 14:00:00',
   '6', 'Mutation (même établissement)', '8', 'Retour à domicile',
   'UF-SSR-01', 'Soins de Suite et Rééducation', 'SSR', 'Z96.6', 'Présence prothèse membre inférieur', 'TERMINE'),

  -- Séjour 5 : Urgences sans adresse — INCONNU (IPP-0003)
  (3, 'NDA-2025-00201', '2025-01-15 02:45:00', '2025-01-17 16:30:00',
   '7', 'Transfert SAMU', '6', 'Mutation vers réanimation',
   'UF-URG', 'Service des urgences', 'MCO', 'S06.0', 'Commotion cérébrale', 'TERMINE'),

  -- Séjour 6 : MCO terminé — VAN DEN BERG (IPP-0004), patient belge
  (4, 'NDA-2024-00156', '2024-11-05 11:00:00', '2024-11-12 10:00:00',
   '8', 'Domicile', '8', 'Retour à domicile',
   'UF-ORTHO', 'Orthopédie', 'MCO', 'M16.1', 'Coxarthrose primaire unilatérale', 'TERMINE'),

  -- Séjour 7 : Dernier séjour avant décès — BERNARD (IPP-0005)
  (5, 'NDA-2023-00778', '2023-12-10 09:00:00', '2023-12-28 15:00:00',
   '8', 'Domicile', '7', 'Décès',
   'UF-ONCOL', 'Oncologie', 'MCO', 'C34.1', 'Tumeur maligne du lobe supérieur', 'TERMINE'),

  -- Séjour 8 : PSY — DUBOIS (IPP-0006)
  (6, 'NDA-2025-00315', '2025-02-01 14:00:00', '2025-03-15 11:00:00',
   '8', 'Domicile', '8', 'Retour à domicile',
   'UF-PSY-ADULTE', 'Psychiatrie adulte', 'PSY', 'F32.1', 'Épisode dépressif majeur', 'TERMINE'),

  -- Séjour 9 : MCO annulé (erreur de saisie)
  (7, 'NDA-2024-00999', '2024-04-01 08:00:00', NULL,
   '8', 'Domicile', NULL, NULL,
   'UF-CHIR-ORTHO', 'Chirurgie orthopédique', 'MCO', NULL, NULL, 'ANNULE'),

  -- Séjour 10 : HAD — LECLERC (IPP-0007)
  (7, 'NDA-2024-00422', '2024-08-15 00:00:00', '2024-09-30 00:00:00',
   '6', 'Mutation', '8', 'Retour à domicile',
   'UF-HAD', 'Hospitalisation À Domicile', 'HAD', 'Z51.5', 'Soins palliatifs', 'TERMINE'),

  -- Séjour 11 : MCO nourrisson — PETIT (IPP-0008), naissance + hospitalisation
  (8, 'NDA-2024-00512', '2024-02-10 03:20:00', '2024-02-17 10:00:00',
   '0', 'Naissance', '8', 'Retour à domicile',
   'UF-NEONAT', 'Néonatologie', 'MCO', 'Z38.0', 'Enfant unique né à l''hôpital', 'TERMINE'),

  -- Séjour 12 : MCO en cours — PETIT (IPP-0008), ré-admission récente
  (8, 'NDA-2025-00401', '2025-03-01 16:00:00', NULL,
   '8', 'Domicile', NULL, NULL,
   'UF-PEDIATRIE', 'Pédiatrie générale', 'MCO', 'J18.9', 'Pneumonie non précisée', 'EN_COURS');
