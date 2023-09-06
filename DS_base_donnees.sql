
/* Devoir Base de données */

/* 1 */

create login ugb with password='passer' must_change, check_expiration=On;
grant all to ugb;

/* 2 */

create database VenteVoiture;
use VenteVoiture;

/* 3 */

create table model(
	idModel int not null,
	marque varchar(50),
	denomination varchar(50)
	);

create table voiture(
	numseri int not null, 
	couleur varchar(50)
	);

create table client(
	idClient int not null,
	prenom varchar(50),
	nom varchar(50),
	tel int,
	fonction varchar(50),
	adresse varchar(50)
	);

create table vente(
	idVente int not null,
	dateVente date
	);

create table arrivee(
	idArr int not null, 
	dateArr date
	);

create table magasin(
	idMag int not null,
	nom varchar(50),
	lieu varchar(50)
	);

create table vendeur(
	idVendeur int not null,
	prenom varchar(50),
	nom varchar(50)
	);

alter table voiture add prix money not null;
alter table vente add prixAchat money not null;
alter table vendeur add salaire money not null;

/* 4 */

alter table model add constraint pk_m primary key(idModel);
alter table voiture add constraint pk_v primary key(numseri);
alter table client add constraint pk_c primary key(idClient);
alter table arrivee add constraint pk_a primary key(idArr);
alter table vente add constraint pk_vente primary key(idVente);
alter table magasin add constraint pk_mag primary key(idMag);
alter table vendeur add constraint pk_vendeur primary key(idVendeur);

alter table voiture add idModel int foreign key references model(idModel);
alter table voiture add idArr int foreign key references arrivee(idArr);
alter table vente add idClient int foreign key references client(idClient);
alter table vente add idVendeur int foreign key references vendeur(idVendeur);
alter table vente add numseri int foreign key references voiture(numseri);
alter table vendeur add idMag int foreign key references magasin(idMag);
alter table arrivee add idMag int foreign key references magasin(idMag);


INSERT INTO model(idModel, marque, denomination) VALUES (1, 'BMW', 'Rapidité');
INSERT INTO model(idModel, marque, denomination) VALUES (2, 'Yupon', 'endurance');
INSERT INTO model(idModel, marque, denomination) VALUES (3, 'Honda', 'Resistance');

INSERT INTO client(idClient, prenom, nom, tel, fonction, adresse) VALUES (1, 'Michel', 'faye',771112233, 'Etudiant', 'Mbour');
INSERT INTO client(idClient, prenom, nom, tel, fonction, adresse) VALUES (2, 'agathe', 'Diop',789463245, 'Enseignant', 'Fatick');
INSERT INTO client(idClient, prenom, nom, tel, fonction, adresse) VALUES (3, 'Aliou', 'Gueye',771534566, 'Embassadeur', 'Saint Louis');

INSERT INTO magasin(idMag, nom, lieu) VALUES (1, 'Vwax', 'Mbour');
INSERT INTO magasin(idMag, nom, lieu) VALUES (2, 'Galagos', 'Nord-Foire');
INSERT INTO magasin(idMag, nom, lieu) VALUES (3, 'Pantacle', 'Pikine');

INSERT INTO vendeur(idVendeur, prenom, nom, salaire, idMag) VALUES (1, 'Moustapha', 'Ndiaye', 250000, 1);
INSERT INTO vendeur(idVendeur, prenom, nom, salaire, idMag) VALUES (2, 'Lamine', 'Gaye', 300000, 2);
INSERT INTO vendeur(idVendeur, prenom, nom, salaire, idMag) VALUES (3, 'Albert', 'Ndione', 280000, 3);

INSERT INTO arrivee(idArr, dateArr, idMag) VALUES (1, '2008-08-28', 1);
INSERT INTO arrivee(idArr, dateArr, idMag) VALUES (2, '2015-07-17', 3);
INSERT INTO arrivee(idArr, dateArr, idMag) VALUES (3, '2020-04-8', 2);

INSERT INTO voiture(numseri, couleur, prix, idModel, idArr) VALUES (1, 'rouge', 40000000, 3, 1);
INSERT INTO voiture(numseri, couleur, prix, idModel, idArr) VALUES (2, 'noir', 12000000, 2, 3);
INSERT INTO voiture(numseri, couleur, prix, idModel, idArr) VALUES (3, 'bleu', 7000000, 1, 2);

INSERT INTO vente(idVente, dateVente, prixAchat, idClient, idVendeur, numseri) VALUES (1, '2016-05-06',45000000, 3,1, 2);
INSERT INTO vente(idVente, dateVente, prixAchat, idClient, idVendeur, numseri) VALUES (2, '2018-03-25',6700000, 1,3, 3);
INSERT INTO vente(idVente, dateVente, prixAchat, idClient, idVendeur, numseri) VALUES (3, '2016-05-13',7500000, 2,2, 1);

/* 5 */

CREATE PROCEDURE ajoutMagasin(@pidMag int, @pnom varchar(50), @plieu varchar(50)) AS
begin 
INSERT INTO magasin(idMag, nom, lieu) 
VALUES (@pidMag, @pnom, @plieu);
end;
execute ajoutMagasin
@pidMag=4,
@pnom='galop',
@plieu='Saint Louis'

CREATE PROCEDURE ajoutVendeur(@pidvendeur int, @ppre varchar(50), @pnom varchar(50), @psal money, @pidMag int) AS
begin 
INSERT INTO vendeur(idVendeur, prenom, nom, salaire, idMag) 
VALUES (@pidvendeur, @ppre, @pnom, @psal, @pidMag);
end;
execute ajoutVendeur
@pidvendeur=4, 
@ppre='Amalek', 
@pnom='Sall', 
@psal=350000, 
@pidMag=2

CREATE PROCEDURE ajoutVoiture(@pnum int, @pcouleur varchar(50), @pprix money,  @pidmodel int, @pmarque varchar(50), @pdenom varchar(50),
							@idarr int, @pdatearr date, @idmagasin int) AS
begin 
INSERT INTO model(idModel, marque, denomination) 
VALUES (@pidmodel, @pmarque, @pdenom);
INSERT INTO arrivee(idArr, dateArr, idMag) 
VALUES (@idarr, @pdatearr, @idmagasin);
INSERT INTO voiture(numseri, couleur, prix, idModel, idArr)
VALUES (@pnum, @pcouleur, @pprix, @pidmodel, @idarr);
end;

execute ajoutVoiture
@pnum=5, @pcouleur='Rouge', 
@pprix=13000000,  
@pidmodel=5, 
@pmarque='mercedes', 
@pdenom='Resistance',
@idarr=5, @pdatearr='2021-07-15', 
@idmagasin=2

/* 6 */

CREATE PROCEDURE venteVoiture(@pidVente int, @pdateVente date, @pprixAchat money, @pidClient int, @pidVendeur int, @pnumseri int) AS
begin 
INSERT INTO vente(idVente, dateVente, prixAchat, idClient, idVendeur, numseri) 
VALUES (@pidVente, @pdateVente, @pprixAchat, @pidClient, @pidVendeur, @pnumseri);
end;
execute VenteVoiture
@pidVente=5, 
@pdateVente='2008', 
@pprixAchat=3400000, 
@pidClient=3, 
@pidVendeur=2,
@pnumseri = 3

/* 7 */ 
CREATE FUNCTION calculVente(@fannee int) returns INT AS
begin
RETURN(
SELECT count(idVente)
FROM vente
WHERE dateVente<CONCAT(@fannee+1,'-01-01')  AND dateVente>=CONCAT(@fannee,'-01-01')
);
END;
go
declare @fannee int;
set @fannee = 2008;
select * from calculVente(@fannee);

/* 10 */

CREATE TRIGGER suppVoiture
ON vente
AFTER INSERT
AS
BEGIN 
	DELETE FROM voiture WHERE numseri = (SELECT MAX(idVente) FROM vente);
END;
GO

/* 14 */ 
/* c */
select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS;



