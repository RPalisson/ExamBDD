--1

CREATE DATABASE IF NOT EXISTS `bibliothèque`
USE `bibliothèque`;

CREATE TABLE IF NOT EXISTS `adherents` (
	`id_adherent` int NOT NULL AUTO_INCREMENT,
	`nom` varchar(255) NOT NULL,
	`adresse` varchar(255) NOT NULL,
	`date_inscription` date DEFAULT (CURRENT_DATE),
	`a_surveiller` boolean DEFAULT false,
	PRIMARY KEY (`id_adherent`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `livres` (
	`isbn` int NOT NULL,
	`titre` varchar(255) NOT NULL,
	`auteur` varchar(255) NOT NULL,
	`annee_publication` int NOT NULL,
	`disponible` boolean DEFAULT true,
	PRIMARY KEY (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `emprunts` (
	`id_adherent` int NOT NULL,
	`isbn` int NOT NULL,
	`date_emprunt` date DEFAULT (CURRENT_DATE),
	`date_retour` date DEFAULT NULL,
	PRIMARY KEY (id_adherent, isbn),
    FOREIGN KEY (id_adherent) REFERENCES adherents(id_adherent),
    FOREIGN KEY (isbn) REFERENCES livres(isbn)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--2

CREATE USER bibliothequaire@localhost IDENTIFIED BY 'secret';
GRANT ALL, GRANT ON `bibliothèque` TO 'bibliothequaire'@'localhost';


--3

INSERT INTO `adherents` (`id_adherent`, `nom`, `adresse`) VALUES
	('1', 'Jane AUSTEN', '12 rue du port'),
	('2', 'Charles DICKENS', '89 boulevard St-Bernard'),
	('3', 'Jules VERNE', '1 impasse Jean VALJEAN'),
	('4', 'Mary SHELLEY', '4 allée du Dr FLEMMING');

INSERT INTO `livres` (`isbn`, `titre`, `auteur`, `annee_publication`) VALUES
	('1', 'Orgueil et Préjugés', 'Jane Austen', '1813'),
	('2', 'David Copperfield', 'Charles Dickens', '1850'),
	('3', 'Vingt mille lieues sous les mers', 'Jules Verne', '1870'),
	('4', 'Frankenstein', 'Mary Shelley', '1818');

INSERT INTO `emprunts` (`id_adherent`, `isbn`, `date_emprunt`, `date_retour`) VALUES
	('1', '2', '2025-01-15', '2025-01-28'),
	('1', '3', '2025-02-17', '2025-02-20'),
	('1', '4', '2025-03-01', '2025-03-19'),
	('2', '3', '2025-01-15', '2025-01-28'),
	('2', '4', '2025-02-17', '2025-02-20'),
	('2', '1', '2025-03-01', '2025-03-19'),
	('3', '4', '2025-01-15', '2025-01-28'),
	('3', '1', '2025-02-17', '2025-02-20'),
	('3', '2', '2025-03-01', '2025-03-19'),
	('4', '1', '2025-01-15', '2025-01-28'),
	('4', '2', '2025-02-17', '2025-02-20'),
	('4', '3', '2025-03-01', '2025-03-19');

INSERT INTO `emprunts` (`id_adherent`, `isbn`, `date_emprunt`) VALUES
	('1', '1', '2025-03-20'),
	('2', '2', '2025-03-20'),
	('3', '3', '2025-03-20'),
	('4', '4', '2025-03-20');

--4

UPDATE adherents
SET adresse='64 boulevard du limier'
WHERE id=2;

--5

CREATE VIEW retards AS
SELECT nom, livres.titre, DATEDIFF(emprunts.date_emprunt, CURRENT_DATE)
FROM adherents
JOIN emprunts ON adherents.id_adherent=emprunts.id_adherent
JOIN livres ON emprunts.isbn=livres.isbn
WHERE DATEDIFF(emprunts.date_emprunt, CURRENT_DATE)>30; 

--6

DELIMITER //

FOR EACH ROW IF (emprunts.date_retour IS NOT NULL) THEN
    UPDATE livres 
    SET livres.disponible=true 
    WHERE emprunts.isbn=livres.isbn;
END IF

DELIMITER ;

--8

DELETE FROM emprunts
WHERE id_adherent=4;

DELETE FROM adherents
WHERE id_adherent=4;

--Un DELETE ON CASCADE à la création de la table simplifierai la procedure en ne demandant que la 2nde requete


--9

--L'index devrait être mis sur les livres en tant que genre de livres car dans une vrai bibliothèque, il y aurait énormement de livre et un index permetrait de pouvoir recherche qu'une portion par genre ou auteur par exemple