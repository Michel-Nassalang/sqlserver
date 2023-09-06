create database ipslbd;

begin transaction;

use ipslbd;

Create table Personne(
matricule int primary key,
nom varchar(255),
prenom varchar (255),
telephone varchar (255),
passe varchar (255)
);

Create table Marque(
nom_marque varchar(255) primary key 
);

Create table Ville(
code_ville int primary key ,
nom_ville varchar(255)
);

Create table Voiture(
code_voiture int primary key ,
capacite int,
datea_chat date,
consommation int,
nom_marque varchar(255)  foreign key references Marque(nom_marque)
);

Create table Ligne(
code_ligne int primary key ,
distance int,
code_ville_depart int  foreign key references Ville(code_ville),
code_ville_arrive int foreign key references Ville(code_ville)
);

select * from Ville
select * from Ligne where Ligne.code_ligne='1'

select Ligne.code_ligne,Ligne.distance,Ville.nom_ville as villedepart,
(select Ville.nom_ville as villedarrive from Ligne,Ville
where Ligne.code_ville_arrive=Ville.code_ville and Ligne.code_ligne='1') from Ligne,Ville
where Ligne.code_ville_depart=Ville.code_ville and Ligne.code_ligne='1';

Create table Calendrier(
code_calendrier int primary key,
jour_voyage int,
heure_voyage datetime,
heure_arrive datetime,
code_ligne int  foreign key references Ligne(code_ligne)
);

Create table Voyage(
code_voyage int primary key identity,
depart_voyage datetime,
arrive_voyage datetime,
place int,
compteur_depart int,
compteur_arrive int ,
matricule int foreign key references Personne(matricule),
code_voiture int foreign key references Voiture(code_voiture),
code_calendrier int foreign key references Calendrier (code_calendrier)
);


insert into Marque values('4*4');
insert into Marque values('dacia');
insert into Marque values('toyota');

select * from Voiture;

insert into Ville values(1,'Dakar');
insert into Ville values(2,'Saint Louis');
insert into Ville values(3,'Thies');
insert into Ville values(4,'Mbour');
insert into Ville values(5,'Kaolack');

insert into Ligne values(1,220,1,2);
insert into Ligne values(2,100,3,2);
insert into Ligne values(3,100,5,1);
insert into Ligne values(4,100,3,1);
insert into Ligne values(5,100,4,2);


insert into  Calendrier values (1,1,'10:00:15','20:00:00',1);
insert into  Calendrier values (2,1,'20:05:15','06:20:00',2);
insert into  Calendrier values (3,2,'15:05:20','17:00:00',3);
insert into  Calendrier values (4,2,'18:05:15','23:20:00',4);

insert into  Voiture values (1,30,'10/12/2015',100,'4*4');
insert into  Voiture values (2,30,'15/05/2012',50,'dacia');
insert into  Voiture values (3,30,'22/02/2011',75,'toyota');


insert into  Personne values (1,'Diop','Samour','771111111','1');
insert into  Personne values (2,'Dieng','Aida','77888888','2');
insert into  Personne values (3,'Ndiaye','Fallou','7655555','3');
insert into  Personne values (5,'Aidara','Mouhamed','555','5');

insert into  Voyage values ('11/12/2015 01:19:00','12/12/2015 05:10:00',1,5,250,1,4,1);
insert into  Voyage values ('10/12/2015 01:19:00','10/12/2015 05:10:00',1,5,250,1,1,1);
insert into  Voyage values ('10/12/2015 01:19:00','10/12/2015 05:10:00',2,5,250,2,2,2);
insert into  Voyage values ('10/12/2015 01:19:00','10/12/2015 05:10:00',2,5,250,2,2,2);
insert into  Voyage values ('10/12/2015 01:19:00','10/12/2015 05:10:00',3,5,250,3,2,3);
insert into  Voyage values ('10/12/2015 01:19:00','10/12/2015 05:10:00',3,5,250,3,3,4);
insert into  Voyage values ('10/12/2015 01:19:00','10/12/2015 05:10:00',3,5,250,3,3,4);

select p.prenom, p.nom, v.depart_voyage, v.arrive_voyage 
from personne p, voyage v
where v.matricule=p.matricule and p.prenom='Fallou' and  p.nom='Ndiaye';

select  v.code_voiture, v.nom_marque
from voiture v, voyage vo
where vo.code_voiture=v.code_voiture and v.code_voiture IN (select code_voiture from voyage)
group by v.code_voiture, v.nom_marque;

select CONCAT(p.prenom, ' ', p.nom) , v.code_voiture, v.nom_marque, vo.depart_voyage
from personne p, voiture v, voyage vo
where p.matricule=vo.matricule and v.code_voiture=vo.code_voiture and vo.depart_voyage = '10/12/2015 01:19:00' and p.prenom='Fallou' and p.nom = 'Ndiaye'
group by p.prenom, p.nom, v.code_voiture, v.nom_marque, vo.depart_voyage;


SELECT l.code_ligne, l.distance, v.nom_ville as depart, vi.nom_ville as arrivee
FROM ligne l, ville v, ville vi
WHERE v.code_ville=l.code_ville_arrive and  vi.code_ville=l.code_ville_depart and code_ligne=2;

select Ligne.code_ligne,Ligne.distance,Ville.nom_ville as villedepart,
(select Ville.nom_ville as villedarrive from Ligne,Ville
where Ligne.code_ville_arrive=Ville.code_ville and Ligne.code_ligne='1') from Ligne, Ville
where Ligne.code_ville_depart=Ville.code_ville and Ligne.code_ligne='1';

SELECT CONCAT(p.prenom, ' ', p.nom) as PrenomNom, count(v.code_voyage) as NombreVoyage
FROM Personne p, Voyage v
WHERE p.matricule=v.matricule and CONCAT(p.prenom, ' ', p.nom) = 'Fallou Ndiaye'
GROUP BY CONCAT(p.prenom, ' ', p.nom);


alter table calendrier add constraint jourCK CHECK ([jour_voyage]>=7);
update Calendrier  set jour_voyage=5 where code_calendrier=1; /* verification */
update Voyage set depart_voyage = '10/12/2015 05:10:00' where arrive_voyage='10/12/2015 05:10:00';/* verification */
alter table ligne add constraint code_ville CHECK ([code_ville_depart]!=[code_ville_arrive]);
alter table voiture add constraint capVoiture CHECK ([capacite]>=4);
update Calendrier set heure_arrive = '22:20:00' where heure_arrive='06:20:00';
alter table Calendrier add constraint calHeure CHECK ([heure_voyage] < [heure_arrive]);
commit;
select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS;