create database ipsling22022;
use ipsling22022;

create table personne(
	cin int primary key,
	nom varchar(50),
	prenom varchar(50),
	sexe varchar(10) constraint ck_ville CHECK (sexe IN ('M','F')),
	adresse varchar(50)
);


create table professeur(
	matricule int primary key,
	specialite varchar(50),
	grade varchar(25) constraint ck_grade CHECK (grade IN ('Doctor','Doctorant','Professeur')),
	cin int foreign key references personne(cin)
);

create table departement(
	codeDepartement int primary key,
	nomdepartement varchar(50)
);
 
create table filiere(
	codeFiliere int primary key,
	nomfiliere varchar(50),
	optionfiliere varchar(50),
	codeDepartement int foreign key references departement(codeDepartement)
);

create table classe(
	codeClasse int primary key,
	nomClasse varchar(50),
	niveauClasse varchar(50),
	codeFiliere int foreign key references filiere(codeFiliere)
);

create table etudiant(
	codeEtudiant int primary key,
	cin int foreign key references personne(cin),
	codeClasse int foreign key references classe(codeClasse)
);

create table matiere(
	codeMatiere int primary key,
	nommatiere varchar(50),
	matricule int foreign key references professeur(matricule),
	codeClasse int foreign key references classe(codeClasse)
);

create table evaluation(
	idEvaluation int primary key,
	codeMatiere int foreign key references matiere(codeMatiere),
	dateEvaluation date,
	heureEvaluation time constraint ck_evalheure CHECK (heureEvaluation<='18:00:00'),
	duree int constraint ck_evalduree CHECK (duree<5)
);
create table note(
	idNote int primary key,
	idEvaluation int foreign key references evaluation(idEvaluation),
	codeEtudiant int foreign key references etudiant(codeEtudiant),
	appreciation varchar(50),
	note float constraint ck_note CHECK(note<=20 AND note>0)
);

select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS;

/* Insertion de valeurs dans les tables */
INSERT INTO personne VALUES (1,'Diop','Abdoul','M', 'Saly Carrefour');
INSERT INTO personne VALUES (2,'Diouf','Edouard','M', 'Medine');
INSERT INTO personne VALUES (3,'Faye','Elisabeth','F', 'Grand Yoff');
INSERT INTO personne VALUES (4,'Sy','Rama','F', 'Grand Mbour');
INSERT INTO personne VALUES (5,'Samb','Aly','M', 'Saly Tefess');
INSERT INTO personne VALUES (6,'Ba','As','M', 'Mbao');
SELECT * FROM personne;

INSERT INTO professeur VALUES (1,'Mathematiques','Doctor',1);
INSERT INTO professeur VALUES (2,'Physique','Professeur',3);
INSERT INTO professeur VALUES (3,'Francais','Doctorant',6);
SELECT * FROM professeur;

INSERT INTO departement VALUES (1,'Sciences humaines');
INSERT INTO departement VALUES (2,'Sciences juridiques');
INSERT INTO departement VALUES (3,'Sciences technologiques');
INSERT INTO departement VALUES (4,'Informatique');
SELECT * FROM departement;

INSERT INTO filiere VALUES (1,'LEA','presentiel',1);
INSERT INTO filiere VALUES (2,'Physique-chimie','presentiel',3);
INSERT INTO filiere VALUES (3,'Droit-privé','en ligne',2);
SELECT * FROM filiere;

INSERT INTO classe VALUES (1,'BCI1','1ere année',2);
INSERT INTO classe VALUES (2,'CPI2','2eme année',1);
INSERT INTO classe VALUES (3,'MIT2','4eme annee',3);
SELECT * FROM classe;

INSERT INTO etudiant VALUES (1,2,2);
INSERT INTO etudiant VALUES (2,5,1);
INSERT INTO etudiant VALUES (3,4,3);
SELECT * FROM etudiant;

INSERT INTO matiere VALUES (1,'Litterature',3,2);
INSERT INTO matiere VALUES (2,'physique',2,1);
INSERT INTO matiere VALUES (3,'droit du travail',3,3);
SELECT * FROM matiere;

INSERT INTO evaluation VALUES (1,2,'2022-06-07','9:00:00', 2);
INSERT INTO evaluation VALUES (2,3,'2022-05-15','10:00:00', 3);
INSERT INTO evaluation VALUES (3,1,'2022-07-23','15:00:00', 2);
SELECT * FROM evaluation;

INSERT INTO note VALUES (1,2,3,'Assez-bien', 12);
INSERT INTO note VALUES (2,1,2,'Passable', 10);
INSERT INTO note VALUES (3,3,1,'Très-bien', 17);
INSERT INTO note VALUES (4,3,1,'Peu mieux faire', 7);
INSERT INTO note VALUES (5,3,1,'bien', 14);
SELECT * FROM note;

CREATE PROCEDURE ajoutFiliere(@pcode int,@pnom varchar(50),@poption varchar(50),@pcodedapart int) AS
begin 
INSERT INTO filiere(codeFiliere, nomfiliere,optionfiliere,codeDepartement) 
VALUES (@pcode,@pnom,@poption,@pcodedapart);
end;

execute ajoutFiliere
@pcode=4,
@pnom='Analyse de données',
@poption='presentiel',
@pcodedapart=4

SELECT * FROM filiere;

CREATE PROCEDURE ajoutEtudiant(@pcin int,@pnom varchar(50),@ppnom varchar(50),@psexe varchar(10),@padrr varchar(50),@pcodetu int,@pcodeCla int) AS
BEGIN
INSERT INTO personne(cin,nom,prenom,sexe,adresse)
VALUES (@pcin,@pnom,@ppnom,@psexe,@padrr);
INSERT INTO etudiant(codeEtudiant,cin,codeClasse)
VALUES (@pcodetu,@pcin,@pcodeCla);
end;

execute ajoutEtudiant
@pcin=7,@pnom='Sall',@ppnom='Faby',@psexe='F',@padrr='Ouakam',@pcodetu=4,@pcodeCla=1

SELECT * FROM personne;
SELECT * FROM etudiant;

CREATE PROCEDURE afficheNote(@prenom varchar(50),@nom varchar(50)) AS
BEGIN 
SELECT CONCAT(p.prenom,' ',p.nom ), n.note
FROM personne p, etudiant e, note n
WHERE p.cin = e.cin AND e.codeEtudiant = n.codeEtudiant AND p.prenom = @prenom AND p.nom = @nom;
end;
/* drop procedure afficheNote */
execute afficheNote
@prenom = 'Aly',
@nom = 'Samb'

CREATE PROCEDURE rechercheEtudiant(@lettre varchar(5)) AS
BEGIN 
SELECT CONCAT(prenom, ' ',nom ) as Prenom_Nom
FROM personne
WHERE  cin IN (SELECT cin FROM etudiant) AND nom LIKE '%'+@lettre+'%';
END;

/*DROP PROCEDURE rechercheEtudiant;*/

execute rechercheEtudiant
@lettre = 'B'
execute rechercheEtudiant
@lettre = 'S'

CREATE PROCEDURE nbEtuNote(@matiere varchar(50)) AS
BEGIN 
SELECT m.nommatiere as Nom_Matiere, COUNT(e.codeEtudiant) as Nombre_Etudiant
FROM etudiant e, note n, evaluation ev, matiere m 
WHERE e.codeEtudiant=n.codeEtudiant AND ev.idEvaluation=n.idEvaluation AND m.codeMatiere=ev.codeMatiere AND UPPER(m.nommatiere)=UPPER(@matiere) AND n.note>=10
GROUP BY m.nommatiere;
END;


execute nbEtuNote
@matiere='Litterature'
execute nbEtuNote
@matiere='droit du travail'
execute nbEtuNote
@matiere='physique'

SELECT * FROM evaluation;

CREATE PROCEDURE meilleurNote(@matiere varchar(50), @dateeval date) AS
BEGIN

SELECT e.codeEtudiant as code_Etudiant, CONCAT(p.prenom, ' ', p.nom) as prenom_nom, n.note
FROM etudiant e, note n, evaluation ev, matiere m, personne p
WHERE p.cin=e.cin AND e.codeEtudiant=n.codeEtudiant AND ev.idEvaluation=n.idEvaluation AND m.codeMatiere=ev.codeMatiere AND UPPER(m.nommatiere)=UPPER(@matiere) AND ev.dateEvaluation=@dateeval
AND n.note = (SELECT MAX(n.note)
			FROM note n, evaluation e, matiere m
			WHERE e.idEvaluation=n.idEvaluation AND m.codeMatiere=e.codeMatiere AND UPPER(m.nommatiere)=UPPER(@matiere) AND e.dateEvaluation=@dateeval );
END;

execute meilleurNote
@matiere='Litterature',
@dateeval = '2022-07-23'

execute meilleurNote
@matiere='physique',
@dateeval = '2022-06-07'

CREATE PROCEDURE bestNote(@matiere varchar(50), @dateeval date, @valMax float out) AS
BEGIN
SELECT @valMax=MAX(n.note)
FROM note n, evaluation e, matiere m
WHERE e.idEvaluation=n.idEvaluation AND m.codeMatiere=e.codeMatiere AND UPPER(m.nommatiere)=UPPER(@matiere) AND e.dateEvaluation=@dateeval; 

SELECT e.codeEtudiant as code_Etudiant, CONCAT(p.prenom, ' ', p.nom) as prenom_nom, n.note
FROM etudiant e, note n, evaluation ev, matiere m, personne p
WHERE p.cin=e.cin AND e.codeEtudiant=n.codeEtudiant AND ev.idEvaluation=n.idEvaluation AND m.codeMatiere=ev.codeMatiere AND UPPER(m.nommatiere)=UPPER(@matiere) AND ev.dateEvaluation=@dateeval
AND n.note = @valMax;
END;

go
declare @matiere varchar(50) = 'Litterature';
declare @dateeval date = '2022-07-23';
declare @valMax float;
execute bestNote
@matiere,
@dateeval,
@valMax OUTPUT

CREATE FUNCTION etudiantClasse(@fclasse varchar(50)) returns table AS
return(
SELECT CONCAT(p.prenom, ' ', p.nom) as prenom_nom
FROM etudiant e, classe c, personne p
WHERE c.codeClasse=e.codeClasse AND p.cin=e.cin AND c.nomClasse=@fclasse
);
go
declare @fclasse varchar(50);
set @fclasse = 'BCI1';
select * from etudiantClasse(@fclasse);

CREATE FUNCTION rechEtu(@idetu int) returns table AS
return(
SELECT CONCAT(p.prenom, ' ', p.nom) as prenom_nom, c.nomClasse
FROM etudiant e, classe c, personne p
WHERE c.codeClasse=e.codeClasse AND p.cin=e.cin  AND e.codeEtudiant=@idetu
);
go
declare @idEtu int;
set @idEtu = 2;
select * from rechEtu(@idEtu);

CREATE FUNCTION numEtuCla(@fcla varchar(50)) returns INT AS
begin
return(
SELECT COUNT(e.codeEtudiant) as nombreEtudiants
FROM etudiant e, classe c
WHERE c.codeClasse=e.codeClasse AND c.nomClasse=@fcla
);
END;

DROP FUNCTION numEtuCla;
go
declare @fcla varchar(50);
set @fcla = 'BCI1';
select dbo.numEtuCla(@fcla);
DROP VIEW ListEtudep;
CREATE VIEW ListEtudepSc as 
SELECT e.codeEtudiant, CONCAT(p.prenom,' ',p.nom) as Prenom_Nom, p.sexe, p.adresse, c.nomClasse
FROM personne p, etudiant e, classe c, filiere f, departement d
WHERE p.cin=e.cin AND c.codeClasse=e.codeClasse AND f.codeFiliere=c.codeFiliere AND d.codeDepartement=f.codeDepartement AND d.nomdepartement='Sciences juridiques';

select * from ListEtudepSc;
select Prenom_Nom from ListEtudepSc;


/*------------------------------------TRIGGER---------------------------------*/
CREATE TABLE journalNote
(
	idjournal int primary key identity,
	nomTable varchar(50) default 'note',
	typeAction varchar(50) default '',
	nomUtilisateur varchar(50) default SUSER_SNAME(),
	dateOperation datetime2

);

CREATE TRIGGER noteAction
ON note
AFTER DELETE, INSERT, UPDATE
AS
BEGIN 
	INSERT INTO journalNote(dateOperation) VALUES(GETDATE());
END;
GO


CREATE TRIGGER contrainteMatiere
ON matiere 
AFTER INSERT, UPDATE
AS
BEGIN
declare @nomMat varchar(50)
SELECT @nomMat = nommatiere
FROM inserted
if(SELECT COUNT(*) FROM matiere WHERE nommatiere=@nomMat)>1
ROLLBACK;
END;

INSERT INTO matiere VALUES (4,'Anglais',2,2);
INSERT INTO matiere VALUES (5,'Litterature',2,2);
SELECT * FROM matiere;

CREATE TRIGGER contreNoteEtu
ON note 
AFTER INSERT, UPDATE
AS
BEGIN
declare @ideval int;
declare @idetu int;
SELECT @ideval = idEvaluation, @idetu=codeEtudiant
FROM inserted
if(SELECT COUNT(*) FROM note WHERE idEvaluation=@ideval AND codeEtudiant=@idetu)>1
ROLLBACK;
END;

INSERT INTO note VALUES (6,2,3,'Assez-bien', 12);
INSERT INTO note VALUES (7,3,2,'Passable', 10);
SELECT * FROM note;

/*----------------------------------------------------------------------------*/


CREATE TABLE chambre
(
	numero varchar(50) primary key,
	codelocation varchar(50) default 'LC',
	typeChambre varchar(50) default 'classique',
	typeLit varchar(50) default 'argente',
	prixChambre money default 85.95,
	disponibilite bit default 1
);
CREATE TABLE journalisationChambre
(
	idjournal int primary key identity,
	typeObjet varchar(20),
	nomObjet varchar(40),
	nomutilisateur varchar(50),
	actionEffec varchar(50),
	dateOperation datetime2
);
SELECT * FROM chambre;
SELECT * FROM journalisationChambre;

CREATE TRIGGER recordChambre
ON chambre 
AFTER INSERT 
AS
BEGIN
	INSERT INTO journalisationChambre
	VALUES ('Table','chambre',SUSER_SNAME(), 'Nouvel enrigistrement', GETDATE());
END;
GO
INSERT INTO chambre(numero)  VALUES(1);
SELECT * FROM chambre;
SELECT * FROM journalisationChambre;

CREATE TRIGGER modifyChambre
ON chambre 
AFTER UPDATE 
AS
BEGIN
	INSERT INTO journalisationChambre
	VALUES ('Table','chambre',SUSER_SNAME(), 'Modification enrigistrement', GETDATE());
END;
GO

UPDATE chambre SET  typeLit='bois' WHERE typeLit='argente';
SELECT * FROM chambre;
SELECT * FROM journalisationChambre;

CREATE TRIGGER deleteChambre
ON chambre 
AFTER DELETE 
AS
BEGIN
	INSERT INTO journalisationChambre
	VALUES ('Table','chambre',SUSER_SNAME(), 'Suppression enrigistrement', GETDATE());
END;
GO
DELETE chambre WHERE typeLit='bois';
SELECT * FROM chambre;
SELECT * FROM journalisationChambre;