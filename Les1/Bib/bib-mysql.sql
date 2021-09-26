-- Als er reeds een database met de naam "bib" bestaat op je MySQL-server,
-- dan zal dit script normaal gezien falen. Dat is voor de veiligheid,
-- zodat je niet per ongeluk een bestaande databank wist.

-- Weet je zeker dat je de bestaande "bib"-database wilt wissen
-- en vervangen door een nieuwe? Haal dan de "-- " weg in het begin van
-- de "DROP DATABASE"-lijn hieronder, en voer het script uit.
-- (De "-- " zorgt ervoor dat een commando niet uitgevoerd wordt.)

-- DROP DATABASE bib;

CREATE DATABASE bib;
USE bib;
CREATE TABLE auteur (
  id DECIMAL(4,0) NOT NULL,
  naam VARCHAR(20) NOT NULL,
  PRIMARY KEY (id)
);
INSERT INTO auteur
(id,naam)
VALUES
(1,'Elsschot'),
(2,'Boon'),
(3,'Claus'),
(4,'Lanoye'),
(5,'Zinzen'),
(6,'Tuchman'),
(7,'Christie'),
(8,'Bilzen'),
(9,'Pauwels'),
(10,'Konrad'),
(11,'Breemeersch'),
(12,'Jennings'),
(13,'Meyer'),
(14,'Jordan'),
(15,'Swan'),
(16,'Herman Brusselman');

CREATE TABLE categorie (
  cat_id DECIMAL(4,0) NOT NULL,
  categorie VARCHAR(20) NOT NULL,
  PRIMARY KEY (cat_id)
);
INSERT INTO categorie
(cat_id,categorie)
VALUES
(1,'non-fictie'),
(2,'fictie'),
(3,'wetenschappelijk');

CREATE TABLE uitgever (
  uitg_id DECIMAL(4,0) NOT NULL,
  uitgever VARCHAR(20) NOT NULL,
  PRIMARY KEY (uitg_id)
);
INSERT INTO uitgever
(uitg_id,uitgever)
VALUES
(1,'Hadewijch'),
(4,'Querido'),
(5,'Arbeiderspers'),
(6,'De Bezige Bij'),
(7,'Prometheus'),
(8,'QUE'),
(9,'Academic');

CREATE TABLE uitleen (
  uitlnr DECIMAL(6,0) NOT NULL,
  boek_id DECIMAL(5,0) NOT NULL,
  datum DATE NOT NULL,
  klant_id DECIMAL(4,0) NOT NULL,
  PRIMARY KEY (uitlnr)
);
INSERT INTO uitleen
(uitlnr,boek_id,datum,klant_id)
VALUES
(1,3,'2013-5-1',3),
(2,2,'2015-5-1',3),
(3,8,'2015-5-3',1),
(4,4,'2015-5-3',1),
(5,7,'2015-5-6',2),
(6,14,'2015-9-1',9),
(7,15,'2015-9-1',9),
(8,18,'2015-9-5',10),
(9,12,'2015-9-12',7),
(10,20,'2015-9-9',8),
(44,16,'2017-5-2',9);

CREATE TABLE boeken (
  id DECIMAL(5,0) NOT NULL,
  auteur_id DECIMAL(5,0),
  publ_jaar DECIMAL(4,0),
  titel VARCHAR(50) NOT NULL,
  cat_id DECIMAL(4,0),
  uitg_id DECIMAL(4,0),
  PRIMARY KEY (id)
);
INSERT INTO boeken
(id,auteur_id,publ_jaar,titel,cat_id,uitg_id)
VALUES
(1,1,1953,'Kaas',2,4),
(2,2,1962,'Jan De Lichte',2,5),
(3,2,1964,'Geuzenboek',2,5),
(4,3,1983,'Het verdriet van België',2,6),
(5,3,1996,'De geruchten',1,6),
(6,3,1970,'De koele minnaar',2,6),
(7,4,1993,'Kartonnen dozen',2,7),
(8,5,1995,'Afrika Bezoeken',1,1),
(9,15,1995,'Programmeren met Turbo Pascal',3,9),
(10,15,1996,'Programmeren met C++',3,9),
(11,15,1995,'Programmeren met LISP',3,9),
(12,14,NULL,'Gestructureerde Analyse',3,9),
(13,14,1992,'OO software ontwerp',3,9),
(14,12,1997,'Compleet handboek Access 97',3,8),
(15,12,1999,'Compleet handboek Access 2000',3,8),
(16,12,1995,'Compleet handboek Access 95',3,8),
(17,11,1999,'Tuinieren voor beginners',1,7),
(18,11,1999,'Tuinieren voor gevorderden',1,6),
(19,11,1998,'Japanse tuinen',1,6),
(20,11,2000,'Afrikaanse tuinen',1,6);

CREATE TABLE klant (
  klant_id DECIMAL(4,0) NOT NULL,
  klantnaam VARCHAR(30) NOT NULL,
  plaats VARCHAR(30),
  PRIMARY KEY (klant_id)
);
INSERT INTO klant
(klant_id,klantnaam,plaats)
VALUES
(1,'Maertens','Brugge'),
(2,'Deblaere','Gent'),
(3,'Vanzever','Brugge'),
(4,'Vermander','Brugge'),
(5,'Willems','Gent'),
(6,'Peeters','Brugge'),
(7,'Peeters','Oostende'),
(8,'Holvoet','Oostende'),
(9,'De Coninck','Brugge'),
(10,'Arnolds','Blankenberge');
