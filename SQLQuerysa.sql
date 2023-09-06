alter login sa disable; /* enlever l'autorisation de connection à un utilisateur */
alter login sa enable;	/* donner l'autorisation de connection à un utilisateur */
alter login sa with password='passer'; /* changer le mot de passe d'un utilisateur */

create login ipslING2 with password='passer' must_change, check_expiration=On;
create login michel with password='flexzone' must_change, check_expiration=On;
begin transaction;
/* ----------    ------------*/
commit
rollback
