--T1
select * from ang;
create table ang as select * from angajati;

-- dirty write - uncommitted data is overwritten

--T1
select salariu from ang where ID_ANGAJAT = 1024;
-- RASPUNS: 13000

update ang
set salariu = salariu + 1000
where id_angajat = 1024;

--T2
update ang
set salariu = salariu + 3000
where id_angajat = 1024;

--T1
rollback;   -- se face pana la ultimul commit

--T2
select salariu from ang where id_angajat = 1024;
-- 13000 + 3000 = 16000
commit;

--T1
select salariu from ang where id_angajat = 1024;
-- 16000   la fel a ramas asa, nu se inregistreaza 17000

--LOST UPDATE:

select salariu from ang where id_angajat = 1024;
-- 16000 

update ang
set salariu = salariu + 1000
where id_angajat = 1024;

--T2
update ang
set salariu = salariu + 3000
where id_angajat = 1024;

--T1
commit;

--T2
select salariu from ang where id_angajat = 1024;

commit;
-- se inregistreaza 20000, nu 19000

--T1
select salariu from ang where id_angajat = 1024;
--inca este 20000

--DIRTY READ FENOMEN , adica o tranzactie citeste datele care nu au fost committed
select salariu, id_echipa from ang where id_angajat = 1023;
--12 000, Code Crusaders

update ang
set id_echipa = 'Shadow Strikers'
where id_angajat = 1023;

--T2

update ang
set salariu = 20000
where id_angajat = 1023;

select salariu, id_echipa from ang where id_angajat = 1023;
--20000 , Shadow Strikers

--T1
rollback;


--T2
select salariu, id_echipa from ang where id_angajat = 1023;
commit;

--T1
-- non-repeatable reads possible
select salariu, id_echipa from ang where id_angajat = 1023;
--12 000, Code Crusaders

update ang 
set salariu = 15000
where id_angajat = 1023;


--T2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

select salariu, id_echipa from ang where id_angajat = 1023;

--t1
COMMIT;

update ang
set salariu = salariu + 1000
where id_angajat = 1023;

select salariu, id_echipa from ang where id_angajat = 1023;

--16000	Code Crusaders

rollback;

--non-repeatable reads not possible
select salariu, id_echipa from ang where id_angajat = 1023;

--16000	Code Crusaders

update ang 
set salariu  = 20000
where id_angajat = 1023;

--T2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

select salariu, id_echipa from ang where id_angajat = 1023;

--T1
commit;

--T2
--can't serialize access for transaction

update ang 
set salariu = salariu + 1000
where id_angajat = 1023;

select salariu, id_echipa from ang where id_angajat = 1023;

--16000	Code Crusaders
commit;

--T2
-- phantom possible fenomen
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
select avg(salariu) from ang;

--12942.42307

--T1
INSERT INTO ANG(ID_ANGAJAT, NUME, PRENUME, EMAIL, NUMAR_TELEFON,SALARIU, ID_LOCATIE, ID_ECHIPA, ID_JOB, DATA_ANGAJARII)
VALUES (1050, 'Gheorgh', 'Andra', 'andra.a@gmail.com', 0756123456,50000, 22, 'Innovation Wizards', 'Programator', TO_DATE('2023-05-16', 'YYYY-MM-DD'));

commit;

--T2
select avg(salariu) from ang;
-- 14314.9259
commit;

--T2
--PHANTOM POSSIBLE fenomen
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

select avg(salariu) from ang;
-- 14314.9259


--T2
INSERT INTO ANG(ID_ANGAJAT, NUME, PRENUME, EMAIL, NUMAR_TELEFON,SALARIU, ID_LOCATIE, ID_ECHIPA, ID_JOB, DATA_ANGAJARII)
VALUES (1051, 'Gheorgh', 'Andra', 'andra.a@gmail.com', 0756123456,60000, 22, 'Innovation Wizards', 'Programator', TO_DATE('2023-05-16', 'YYYY-MM-DD'));
 
select avg(salariu) from ang;
--15946.5357
commit; 

--T2
select avg(salariu) from ang;
-- 14314.9259

--EX19
--A

/*
Se creează un index numit "ang_nume_asc" pe coloana "prenume" a tabelului "angajati" în ordine crescătoare. Apoi, se selectează prenumele din tabelul "angajati". 
Se realizează o interogare pentru a selecta prenumele care încep cu "AL" din tabelul "angajati" folosind indexul creat anterior.
La final, indexul "ang_nume_asc" este eliminat din baza de date.
*/
CREATE INDEX ang_nume_asc ON angajati(prenume ASC);
select prenume from angajati;       --  putem sa le vedem in ordine ASC

SELECT PRENUME  FROM ANGAJATI       -- timp de propagare 0.006 s
WHERE UPPER(PRENUME) LIKE 'AL%';

drop index ang_nume_asc;

--B
/*
Această interogare creează un index numit "ECHIPA_PERF_DESC" pe coloana "PERFORMANTA" a tabelului "ECHIPA" în ordine descrescătoare. 
Apoi, se selectează numele, prenumele și ID-ul jobului angajațilorcare fac parte dintr-o echipă cu o performanță mai mare decât 9.15, 
utilizând indexul creat anterior pentru a optimiza procesul de interogare.
*/
CREATE INDEX ECHIPA_PERF_DESC ON ECHIPA(PERFORMANTA DESC);


SELECT A.NUME, A.PRENUME, A.ID_JOB
FROM ANGAJATI A
JOIN ECHIPA E ON A.ID_ECHIPA = E.ID_ECHIPA
WHERE E.PERFORMANTA IN ( SELECT PERFORMANTA FROM ECHIPA
                    WHERE PERFORMANTA > 9.15);


DROP INDEX ECHIPA_PERF_DESC;