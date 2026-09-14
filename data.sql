INSERT INTO gebruiker (id, naam, email, password_hash, rol, created_at, updated_at) VALUES
    (1, 'Alice Jansen', 'alice@student.hu.nl', '$2y$10$Q7f8vM6o0g1kLh1M8mJ7weQ7V8j0LQb9Q6p8n7V9U0w9y6q0YvQeK', 'student', '2026-01-15 09:30:00', '2026-01-15 09:30:00'),
    (2, 'Bram de Vries', 'bram@student.hu.nl', '$2y$10$eN8fO8k7mM9pA1VvP6l6X.Cx0sH2fQjU3x2I8r8B9m0o8uM6m3C2', 'student', '2026-02-02 11:15:00', '2026-02-02 11:15:00'),
    (3, 'Nina Beheer', 'nina@hu.nl', '$2y$10$kP4sC6u6kY1nR2r5M3q7Ye3M7oV2mU4aI3wJ0iH7O2C7lF8dDgX2', 'beheerder', '2026-01-01 08:00:00', '2026-01-01 08:00:00'),
    (4, 'Daan Visser', 'daan@student.hu.nl', '$2y$10$J1mW7o5vM8aK4uC9N3x8uO2hF0qN1dG9mP6sX4cV8lL2vT4pR2i', 'student', '2026-03-10 14:20:00', '2026-03-10 14:20:00');

INSERT INTO boek (id, titel, auteur, conditie, prijs, categorie, locatie, eigenaar_id, created_at, updated_at) VALUES
    (1, 'Clean Code', 'Robert C. Martin', 'goed', 18.50, 'Informatica', 'Utrecht', 1, '2026-03-12 10:00:00', '2026-03-12 10:00:00'),
    (2, 'Java voor Studenten', 'J. Smits', 'nieuw', 24.99, 'Programmeren', 'Amsterdam', 2, '2026-03-14 13:45:00', '2026-03-14 13:45:00'),
    (3, 'Algoritmen en Datastructuren', 'A. Koster', 'gebruikt', 16.00, 'Wiskunde', 'Rotterdam', 1, '2026-04-02 09:10:00', '2026-04-02 09:10:00'),
    (4, 'Natuurkunde Basis', 'M. Vermeer', 'goed', 12.75, 'Natuurkunde', 'Eindhoven', 4, '2026-04-05 16:05:00', '2026-04-05 16:05:00');

INSERT INTO advertentie (id, status, boek_id, gebruiker_id, created_at, updated_at) VALUES
    (1, 'verkocht', 1, 1, '2026-03-12 10:05:00', '2026-03-12 10:05:00'),
    (2, 'actief', 2, 2, '2026-03-14 13:50:00', '2026-03-14 13:50:00'),
    (3, 'actief', 3, 1, '2026-04-02 09:15:00', '2026-04-02 09:15:00'),
    (4, 'verwijderd', 4, 4, '2026-04-05 16:10:00', '2026-04-05 16:10:00');

INSERT INTO transactie (id, status, koper_id, verkoper_id, advertentie_id, aangemaakt_op, afgerond_op) VALUES
    (1, 'voltooid', 2, 1, 1, '2026-03-15 12:00:00', '2026-03-16 18:30:00'),
    (2, 'in behandeling', 4, 2, 2, '2026-03-20 08:15:00', NULL),
    (3, 'geannuleerd', 1, 4, 4, '2026-04-06 09:00:00', NULL);

INSERT INTO bericht (id, inhoud, verzender_id, ontvanger_id, aangemaakt_op) VALUES
    (1, 'Hoi Alice, is Clean Code nog beschikbaar?', 2, 1, '2026-03-15 09:20:00'),
    (2, 'Ja, ik kan het vandaag nog afgeven.', 1, 2, '2026-03-15 09:22:00'),
    (3, 'Ik wil graag meer info over Java voor Studenten.', 4, 2, '2026-03-20 08:30:00');

INSERT INTO beoordeling (id, score, recensie, beoordelaar_id, beoordeelde_id, aangemaakt_op) VALUES
    (1, 5, 'Zeer vriendelijke verkoper en boek in goede staat.', 2, 1, '2026-03-17 19:00:00'),
    (2, 4, 'Goede communicatie en snelle levering.', 4, 2, '2026-03-21 11:00:00'),
    (3, 5, 'Nett en duidelijk boek, perfect voor mijn opleiding.', 1, 4, '2026-04-08 10:30:00');

INSERT INTO notificatie (id, bericht, gelezen, gebruiker_id, aangemaakt_op) VALUES
    (1, 'Je advertentie "Clean Code" is verkocht.', TRUE, 1, '2026-03-16 18:45:00'),
    (2, 'Nieuw bericht ontvangen van Bram de Vries.', FALSE, 1, '2026-03-15 09:23:00'),
    (3, 'Er is een nieuwe transactie in behandeling.', FALSE, 3, '2026-03-20 08:20:00');

COMMIT;
