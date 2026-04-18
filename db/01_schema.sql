-- ─────────────────────────────────────────────────────────────────
-- Schéma de test DPI — base de données source pour Loom Engine
-- Simule une base hospitalière avec tables patient et sejour
-- ─────────────────────────────────────────────────────────────────

-- ─── TABLE patient ───────────────────────────────────────────────
-- Données démographiques du patient.
-- Cible FHIR : Patient (profil FR Core)

CREATE TABLE patient (
  id_patient      SERIAL          PRIMARY KEY,
  ipp             VARCHAR(20)     NOT NULL UNIQUE,        -- Identifiant Patient Permanent (local)
  ins_nir         VARCHAR(15),                            -- N° Sécurité Sociale (NIR)
  nom_naissance   VARCHAR(100)    NOT NULL,               -- Nom de naissance (majuscules)
  prenom_usuel    VARCHAR(100)    NOT NULL,               -- Prénom d'usage
  date_naissance  DATE            NOT NULL,
  sexe            CHAR(1)         NOT NULL DEFAULT 'U'
                    CHECK (sexe IN ('M', 'F', 'I', 'U')), -- M/F/I(autre)/U(inconnu)
  numero_voie     VARCHAR(10),
  libelle_voie    VARCHAR(200),
  code_postal     VARCHAR(10),
  commune         VARCHAR(100),
  pays            CHAR(3)         DEFAULT 'FRA',          -- ISO 3166-1 alpha-3
  telephone       VARCHAR(20),
  email           VARCHAR(200),
  statut          VARCHAR(10)     NOT NULL DEFAULT 'ACTIF'
                    CHECK (statut IN ('ACTIF', 'INACTIF', 'DECEDE')),
  date_creation   TIMESTAMP       NOT NULL DEFAULT NOW(),
  date_modif      TIMESTAMP       NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  patient               IS 'Données démographiques — cible FHIR : Patient (FR Core)';
COMMENT ON COLUMN patient.ipp           IS 'Identifiant Patient Permanent local (IPP)';
COMMENT ON COLUMN patient.ins_nir       IS 'Numéro d''Inscription au Répertoire (NIR) — INS-NIR';
COMMENT ON COLUMN patient.sexe          IS 'M=masculin F=féminin I=autre U=inconnu (mapping → FHIR gender)';
COMMENT ON COLUMN patient.pays          IS 'ISO 3166-1 alpha-3 (FRA, BEL, CHE…)';

-- ─── TABLE sejour ─────────────────────────────────────────────────
-- Épisode hospitalier (séjour MCO, SSR, PSY ou HAD).
-- Cible FHIR : Encounter

CREATE TABLE sejour (
  id_sejour             SERIAL          PRIMARY KEY,
  id_patient            INTEGER         NOT NULL REFERENCES patient(id_patient) ON DELETE CASCADE,
  numero_sejour         VARCHAR(30)     NOT NULL UNIQUE,  -- NDA (Numéro de Dossier Administratif)
  date_entree           TIMESTAMP       NOT NULL,
  date_sortie           TIMESTAMP,                        -- NULL si séjour en cours
  mode_entree           VARCHAR(5),                       -- code PMSI : 8=domicile 6=mutation 7=transfert
  libelle_mode_entree   VARCHAR(100),
  mode_sortie           VARCHAR(5),                       -- code PMSI : 8=domicile 6=mutation 7=décès 9=sortie autorisation
  libelle_mode_sortie   VARCHAR(100),
  uf_code               VARCHAR(30),                      -- Code Unité Fonctionnelle
  uf_libelle            VARCHAR(200),                     -- Libellé UF
  type_sejour           VARCHAR(5)      NOT NULL DEFAULT 'MCO'
                          CHECK (type_sejour IN ('MCO', 'SSR', 'PSY', 'HAD')),
  dp_cim                VARCHAR(10),                      -- Diagnostic Principal CIM-10
  dp_libelle            VARCHAR(300),                     -- Libellé du diagnostic
  statut                VARCHAR(10)     NOT NULL DEFAULT 'EN_COURS'
                          CHECK (statut IN ('EN_COURS', 'TERMINE', 'ANNULE')),
  date_creation         TIMESTAMP       NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  sejour               IS 'Épisodes hospitaliers — cible FHIR : Encounter';
COMMENT ON COLUMN sejour.numero_sejour IS 'Numéro de Dossier Administratif (NDA)';
COMMENT ON COLUMN sejour.mode_entree   IS 'Code PMSI mode d''entrée : 8=domicile 6=mutation 7=transfert 0=naissance';
COMMENT ON COLUMN sejour.mode_sortie   IS 'Code PMSI mode de sortie : 8=domicile 6=mutation 7=décès 9=HAD';
COMMENT ON COLUMN sejour.type_sejour   IS 'MCO=court séjour SSR=soins suite HAD=hospit domicile PSY=psychiatrie';
COMMENT ON COLUMN sejour.dp_cim        IS 'Diagnostic Principal codé en CIM-10';

-- ─── INDEX ────────────────────────────────────────────────────────

CREATE INDEX idx_patient_statut       ON patient (statut);
CREATE INDEX idx_sejour_id_patient    ON sejour (id_patient);
CREATE INDEX idx_sejour_statut        ON sejour (statut);
CREATE INDEX idx_sejour_date_entree   ON sejour (date_entree);
