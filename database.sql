CREATE DATABASE IF NOT EXISTS boekenplatform
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE boekenplatform;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS notificatie;
DROP TABLE IF EXISTS beoordeling;
DROP TABLE IF EXISTS bericht;
DROP TABLE IF EXISTS transactie;
DROP TABLE IF EXISTS advertentie;
DROP TABLE IF EXISTS boek;
DROP TABLE IF EXISTS gebruiker;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- GEBRUIKER
-- =========================================================
CREATE TABLE gebruiker (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    naam VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol ENUM('student', 'beheerder') NOT NULL DEFAULT 'student',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_gebruiker_email (email)
) ENGINE=InnoDB;

-- =========================================================
-- BOEK
-- =========================================================
CREATE TABLE boek (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    titel VARCHAR(255) NOT NULL,
    auteur VARCHAR(255) NOT NULL,
    conditie ENUM('nieuw', 'goed', 'gebruikt') NOT NULL,
    prijs DECIMAL(10,2) NOT NULL,
    categorie VARCHAR(100) NOT NULL,
    locatie VARCHAR(100) NULL,
    eigenaar_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    KEY idx_boek_eigenaar (eigenaar_id),
    KEY idx_boek_categorie (categorie),
    KEY idx_boek_locatie (locatie),

    CONSTRAINT chk_boek_prijs CHECK (prijs >= 0),

    CONSTRAINT fk_boek_eigenaar
        FOREIGN KEY (eigenaar_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- ADVERTENTIE
-- =========================================================
CREATE TABLE advertentie (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    status ENUM('actief', 'verwijderd', 'verkocht') NOT NULL DEFAULT 'actief',
    boek_id INT UNSIGNED NOT NULL,
    gebruiker_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_advertentie_boek (boek_id),
    KEY idx_advertentie_gebruiker (gebruiker_id),
    KEY idx_advertentie_status (status),

    CONSTRAINT fk_advertentie_boek
        FOREIGN KEY (boek_id)
        REFERENCES boek(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_advertentie_gebruiker
        FOREIGN KEY (gebruiker_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- TRANSACTIE
-- =========================================================
CREATE TABLE transactie (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    status ENUM('in behandeling', 'voltooid', 'geannuleerd')
        NOT NULL DEFAULT 'in behandeling',
    koper_id INT UNSIGNED NOT NULL,
    verkoper_id INT UNSIGNED NOT NULL,
    advertentie_id INT UNSIGNED NOT NULL,
    aangemaakt_op TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    afgerond_op TIMESTAMP NULL,

    PRIMARY KEY (id),
    KEY idx_transactie_koper (koper_id),
    KEY idx_transactie_verkoper (verkoper_id),
    KEY idx_transactie_advertentie (advertentie_id),
    KEY idx_transactie_status (status),

    CONSTRAINT fk_transactie_koper
        FOREIGN KEY (koper_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_transactie_verkoper
        FOREIGN KEY (verkoper_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_transactie_advertentie
        FOREIGN KEY (advertentie_id)
        REFERENCES advertentie(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_transactie_geen_zelfkoop
        CHECK (koper_id <> verkoper_id),

    CONSTRAINT chk_transactie_afgerond_op
        CHECK (
            (status = 'voltooid' AND afgerond_op IS NOT NULL)
            OR
            (status <> 'voltooid')
        )
) ENGINE=InnoDB;

-- =========================================================
-- BERICHT
-- =========================================================
CREATE TABLE bericht (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    inhoud TEXT NOT NULL,
    verzender_id INT UNSIGNED NOT NULL,
    ontvanger_id INT UNSIGNED NOT NULL,
    aangemaakt_op TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    KEY idx_bericht_verzender (verzender_id),
    KEY idx_bericht_ontvanger (ontvanger_id),
    KEY idx_bericht_datum (aangemaakt_op),

    CONSTRAINT fk_bericht_verzender
        FOREIGN KEY (verzender_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_bericht_ontvanger
        FOREIGN KEY (ontvanger_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_bericht_geen_zelfbericht
        CHECK (verzender_id <> ontvanger_id)
) ENGINE=InnoDB;

-- =========================================================
-- BEOORDELING
-- =========================================================
CREATE TABLE beoordeling (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    score TINYINT UNSIGNED NOT NULL,
    recensie TEXT NULL,
    beoordelaar_id INT UNSIGNED NOT NULL,
    beoordeelde_id INT UNSIGNED NOT NULL,
    aangemaakt_op TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    KEY idx_beoordeling_beoordelaar (beoordelaar_id),
    KEY idx_beoordeling_beoordeelde (beoordeelde_id),

    CONSTRAINT chk_beoordeling_score
        CHECK (score BETWEEN 1 AND 5),

    CONSTRAINT chk_beoordeling_geen_zelfbeoordeling
        CHECK (beoordelaar_id <> beoordeelde_id),

    CONSTRAINT fk_beoordeling_beoordelaar
        FOREIGN KEY (beoordelaar_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_beoordeling_beoordeelde
        FOREIGN KEY (beoordeelde_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- NOTIFICATIE
-- =========================================================
CREATE TABLE notificatie (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bericht VARCHAR(255) NOT NULL,
    gelezen BOOLEAN NOT NULL DEFAULT FALSE,
    gebruiker_id INT UNSIGNED NOT NULL,
    aangemaakt_op TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    KEY idx_notificatie_gebruiker (gebruiker_id),
    KEY idx_notificatie_gelezen (gelezen),

    CONSTRAINT fk_notificatie_gebruiker
        FOREIGN KEY (gebruiker_id)
        REFERENCES gebruiker(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- DUMMY DATA
-- =========================================================

