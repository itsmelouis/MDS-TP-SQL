DROP TABLE IF EXISTS Utilisateur;
CREATE TABLE Utilisateur (
    id_utilisateur INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nom_utilisateur VARCHAR(100),
    prenom_utilisateur VARCHAR(100),
    email_utilisateur VARCHAR(255),
    mdp_utilisateur VARCHAR(255)
);

DROP TABLE IF EXISTS Realisateur;
CREATE TABLE Realisateur (
    id_realisateur INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nom_realisateur VARCHAR(100),
    prenom_realisateur VARCHAR(100)
);

DROP TABLE IF EXISTS Film;
CREATE TABLE Film (
    id_film INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    titre_film VARCHAR(100),
    duree_film TIME,
    annee_sortie_film YEAR,
    id_realisateur INT(11),
    FOREIGN KEY (id_realisateur) REFERENCES Realisateur(id_realisateur)
);

DROP TABLE IF EXISTS Acteur;
CREATE TABLE Acteur (
    id_acteur INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nom_acteur VARCHAR(100),
    prenom_acteur VARCHAR(100),
    date_de_naissance DATE
);

DROP TABLE IF EXISTS Role;
CREATE TABLE Role (
    id_role INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nom_role VARCHAR(100),
    prenom_role VARCHAR(100),
    surnom_role VARCHAR(100),
    id_acteur INT(11),
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id_acteur)
);

DROP TABLE IF EXISTS Casting;
CREATE TABLE Casting (
    id_film INT(11) NOT NULL,
    id_role INT(11) NOT NULL,
    PRIMARY KEY (id_film, id_role),
    FOREIGN KEY (id_film) REFERENCES Film(id_film),
    FOREIGN KEY (id_role) REFERENCES Role(id_role)
);

DROP TABLE IF EXISTS FilmsFavoris;
CREATE TABLE FilmsFavoris (
    id_film INT(11) AUTO_INCREMENT NOT NULL,
    id_utilisateur INT(11) NOT NULL,
    PRIMARY KEY (id_film),
    FOREIGN KEY (id_film) REFERENCES Film(id_film),
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
);

DROP TABLE IF EXISTS ActeursFavoris;
CREATE TABLE ActeursFavoris (
    id_acteur INT(11) AUTO_INCREMENT NOT NULL,
    id_utilisateur INT(11) NOT NULL,
    PRIMARY KEY (id_acteur, id_utilisateur),
    FOREIGN KEY (id_acteur) REFERENCES Acteur(id_acteur),
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
);

-- On peuple ces tables avec un peu de données utiles pour les requêtes demandées

-- Acteurs/Actrices
INSERT INTO Acteur (nom_acteur, prenom_acteur, date_de_naissance)
VALUES ('Doe', 'John', '1995-05-15');

INSERT INTO Acteur (nom_acteur, prenom_acteur, date_de_naissance)
VALUES ('Smith', 'Alice', '1990-02-28');

INSERT INTO Acteur (nom_acteur, prenom_acteur, date_de_naissance)
VALUES ('Jones', 'Michael', '1985-10-10');

INSERT INTO Acteur (nom_acteur, prenom_acteur, date_de_naissance)
VALUES ('Taylor', 'Emma', '1980-07-22');


-- Rôles
INSERT INTO Role (nom_role, prenom_role, surnom_role, id_acteur)
VALUES ('Detective', 'Sarah', 'Sassy', 1);

INSERT INTO Role (nom_role, prenom_role, surnom_role, id_acteur)
VALUES ('Hero', 'Bob', 'Brave', 2);

INSERT INTO Role (nom_role, prenom_role, surnom_role, id_acteur)
VALUES ('Villain', 'Eva', 'Evil', 3);

INSERT INTO Role (nom_role, prenom_role, surnom_role, id_acteur)
VALUES ('Sidekick', 'James', 'Jester', 4);

-- Réalisateur
INSERT INTO Realisateur (nom_realisateur, prenom_realisateur)
VALUES ('Nolan', 'Christopher');

-- Film
INSERT INTO Film (titre_film, duree_film, annee_sortie_film, id_realisateur)
VALUES ('Inception', '02:28:00', 2010, 1);

-- Casting
INSERT INTO Casting (id_film, id_role)
VALUES (1, 1);

INSERT INTO Casting (id_film, id_role)
VALUES (1, 2);

INSERT INTO Casting (id_film, id_role)
VALUES (1, 3);

INSERT INTO Casting (id_film, id_role)
VALUES (1, 4);

-- 1) Les titres et dates de sortie des films du plus récent au plus ancien
SELECT titre_film, annee_sortie_film
FROM Film
ORDER BY annee_sortie_film DESC;

-- 2) Les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique
SELECT nom_acteur, prenom_acteur, YEAR(NOW()) - YEAR(date_de_naissance) AS age_acteur
FROM Acteur
WHERE YEAR(NOW()) - YEAR(date_de_naissance) > 30
ORDER BY nom_acteur, prenom_acteur;

-- 3) La liste des acteurs/actrices principaux pour un film donné
SELECT Acteur.nom_acteur, Acteur.prenom_acteur
FROM Casting
JOIN Role ON Casting.id_role = Role.id_role
JOIN Acteur ON Role.id_acteur = Acteur.id_acteur
JOIN Film ON Casting.id_film = Film.id_film
WHERE Film.titre_film = 'Inception';

-- 4) La liste des films pour un acteur/actrice donné
SELECT Film.titre_film, Film.annee_sortie_film
FROM Casting
JOIN Role ON Casting.id_role = Role.id_role
JOIN Acteur ON Role.id_acteur = Acteur.id_acteur
JOIN Film ON Casting.id_film = Film.id_film
WHERE Acteur.nom_acteur = 'Doe' AND Acteur.prenom_acteur = 'John';

-- 5) Ajouter un film
INSERT INTO Film (titre_film, duree_film, annee_sortie_film, id_realisateur)
VALUES ('Interstellare', '02:49:00', 2014, 1);

-- 6) Ajouter un acteur/actrice
INSERT INTO Acteur (nom_acteur, prenom_acteur, date_de_naissance)
VALUES ('FLOQUET', 'Louis', '2003-04-15');

-- 7) Modifier un film
UPDATE Film
SET titre_film = 'Interstellar'
WHERE titre_film = 'Interstellare';

-- OU

UPDATE Film
SET titre_film = 'Interstellar'
WHERE id_film=2;

-- 8) Supprimer un acteur/actrice
DELETE FROM Acteur
WHERE nom_acteur = 'FLOQUET' AND prenom_acteur = 'Louis';

-- OU

DELETE FROM Acteur
WHERE id_acteur = 5;

-- 9) Afficher les 3 derniers acteurs/actrices ajouté(e)s
SELECT * FROM Acteur
ORDER BY id_acteur DESC
LIMIT 3;

-- 10) Afficher le film le plus ancien
SELECT * FROM Film
ORDER BY annee_sortie_film ASC
LIMIT 1;

-- 11) Afficher l’acteur le plus jeune
SELECT * FROM Acteur
ORDER BY date_de_naissance DESC
LIMIT 1;

-- 12) Compter le nombre de films réalisés en 1990
SELECT COUNT(*) AS nombre_films_1990
FROM Film
WHERE annee_sortie_film = 1990;

-- 13) Faire la somme de tous les acteurs ayant joué dans un film
SELECT COUNT(DISTINCT Acteur.id_acteur) AS nombre_acteurs
FROM Casting
JOIN Role ON Casting.id_role = Role.id_role
JOIN Acteur ON Role.id_acteur = Acteur.id_acteur;

