create database devoir;
use devoir;

CREATE TABLE college(
	code_college int primary key, 
	nom varchar(50),
	adresse varchar(50)
	);

CREATE TABLE personne(
	no_pers int primary key,
	nom varchar(50),
	prenom varchar(50),
	tel varchar(50),
	mail varchar(50)
	);

CREATE TABLE enseignant(
	idEns int primary key,
	date_fonc date,
	indice varchar(50),
	no_pers int foreign key references personne(no_pers)
	);

CREATE TABLE departement(
	code_dprmt int primary key,
	nom varchar(50),
	chef_id int foreign key references enseignant(idEns)
	);
CREATE TABLE etudiant(
	idEtu int primary key,
	first_an date,
	no_pers int foreign key references personne(no_pers)
	);

CREATE TABLE salle(
	no_salle int primary key,
	nom varchar(50),
	capacite int
	);

CREATE TABLE cours(
	no_co int primary key,
	libelle varchar(50),
	no_salle int foreign key references salle(no_salle)
	);

CREATE TABLE note(
	no_note int primary key,
	note float,
	no_co int foreign key references cours(no_co),
	idEtu int foreign key references etudiant(idEtu)
	);

ALTER TABLE enseignant add code_dprmt int foreign key references departement(code_dprmt);
ALTER TABLE etudiant add dnaiss date;
