-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 20 mars 2025 à 15:59
-- Version du serveur : 11.6.2-MariaDB
-- Version de PHP : 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `bibliotheque`
--

-- --------------------------------------------------------

--
-- Structure de la table `adherents`
--

DROP TABLE IF EXISTS `adherents`;
CREATE TABLE IF NOT EXISTS `adherents` (
  `id_adherent` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `date_inscription` date DEFAULT curdate(),
  `a_surveiller` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id_adherent`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `adherents`
--

INSERT INTO `adherents` (`id_adherent`, `nom`, `adresse`, `date_inscription`, `a_surveiller`) VALUES
(1, 'Jane AUSTEN', '12 rue du port', '2025-03-20', 0),
(2, 'Charles DICKENS', '64 boulevard du limier', '2025-03-20', 0),
(3, 'Jules VERNE', '1 impasse Jean VALJEAN', '2025-03-20', 0);

-- --------------------------------------------------------

--
-- Structure de la table `emprunts`
--

DROP TABLE IF EXISTS `emprunts`;
CREATE TABLE IF NOT EXISTS `emprunts` (
  `id_adherent` int(11) NOT NULL,
  `isbn` int(11) NOT NULL,
  `date_emprunt` date DEFAULT curdate(),
  `date_retour` date DEFAULT NULL,
  PRIMARY KEY (`id_adherent`,`isbn`),
  KEY `isbn` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `emprunts`
--

INSERT INTO `emprunts` (`id_adherent`, `isbn`, `date_emprunt`, `date_retour`) VALUES
(1, 1, '2025-03-20', NULL),
(1, 2, '2025-01-15', '2025-01-28'),
(1, 3, '2025-02-17', '2025-02-20'),
(1, 4, '2025-03-01', '2025-03-19'),
(2, 1, '2025-03-01', '2025-03-19'),
(2, 2, '2025-03-20', NULL),
(2, 3, '2025-01-15', '2025-01-28'),
(2, 4, '2025-02-17', '2025-02-20'),
(3, 1, '2025-02-17', '2025-02-20'),
(3, 2, '2025-03-01', '2025-03-19'),
(3, 3, '2025-03-20', NULL),
(3, 4, '2025-01-15', '2025-01-28');

-- --------------------------------------------------------

--
-- Structure de la table `livres`
--

DROP TABLE IF EXISTS `livres`;
CREATE TABLE IF NOT EXISTS `livres` (
  `isbn` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `auteur` varchar(255) NOT NULL,
  `annee_publication` int(11) NOT NULL,
  `disponible` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `livres`
--

INSERT INTO `livres` (`isbn`, `titre`, `auteur`, `annee_publication`, `disponible`) VALUES
(1, 'Orgueil et Préjugés', 'Jane Austen', 1813, 1),
(2, 'David Copperfield', 'Charles Dickens', 1850, 1),
(3, 'Vingt mille lieues sous les mers', 'Jules Verne', 1870, 1),
(4, 'Frankenstein', 'Mary Shelley', 1818, 1);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `retards`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `retards`;
CREATE TABLE IF NOT EXISTS `retards` (
`nom` varchar(255)
,`titre` varchar(255)
,`DATEDIFF(emprunts.date_emprunt, CURRENT_DATE)` int(8)
);

-- --------------------------------------------------------

--
-- Structure de la vue `retards`
--
DROP TABLE IF EXISTS `retards`;

DROP VIEW IF EXISTS `retards`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `retards`  AS SELECT `adherents`.`nom` AS `nom`, `livres`.`titre` AS `titre`, to_days(`emprunts`.`date_emprunt`) - to_days(curdate()) AS `DATEDIFF(emprunts.date_emprunt, CURRENT_DATE)` FROM ((`adherents` join `emprunts` on(`adherents`.`id_adherent` = `emprunts`.`id_adherent`)) join `livres` on(`emprunts`.`isbn` = `livres`.`isbn`)) WHERE to_days(`emprunts`.`date_emprunt`) - to_days(curdate()) > 30 ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `emprunts`
--
ALTER TABLE `emprunts`
  ADD CONSTRAINT `emprunts_ibfk_1` FOREIGN KEY (`id_adherent`) REFERENCES `adherents` (`id_adherent`),
  ADD CONSTRAINT `emprunts_ibfk_2` FOREIGN KEY (`isbn`) REFERENCES `livres` (`isbn`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
