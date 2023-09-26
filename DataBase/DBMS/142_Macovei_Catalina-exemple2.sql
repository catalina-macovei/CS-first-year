--14
/*
 Crearea unei vizualizări complexe. 
 Dați un exemplu de operație LMD permisă pe vizualizarea respectivă și un exemplu de operație LMD nepermisă.
*/

CREATE OR REPLACE VIEW SCRUM_MANAGEMENT 
(
ECHIPA,
PROIECT,
PRODUS,
PRET,
VERSIUNE,
CATEGORIA_PRODUS,
BACKLOG,
SARCINA,
CONCLUZIE,
RECOMANDARI
)
AS SELECT 

E.ID_ECHIPA,
P.ID_PROIECT , 
PR.ID_PRODUS ,
PR.PRICE,
R.VERSIUNE,
PR.ID_CATEGORIE,
SB.ID_BACKLOG, 
SR.ID_SARCINA,  
RET.CONCLUZIE, 
RET.RECOMANDARE


FROM ECHIPA E  

JOIN PROIECTE P ON P.ID_ECHIPA = E.ID_ECHIPA
JOIN PRODUSE PR ON PR.ID_PROIECT = P.ID_PROIECT
JOIN RELEASE R ON R.ID_PRODUS = PR.ID_PRODUS
 
JOIN SPRINT_PLANNING SP ON SP.ID_ECHIPA = E.ID_ECHIPA
JOIN SPRINT_BACKLOG SB ON SB.ID_BACKLOG = SP.ID_BACKLOG
JOIN SARCINI SR ON  SR.ID_BACKLOG = SB.ID_BACKLOG
JOIN SPRINT S ON S.ID_SPRINT = SP.ID_SPRINT
JOIN RETROSPECTIVA RET ON RET.ID_SPRINT = S.ID_SPRINT

WITH READ ONLY;


-- Operatie LMD SELECT - regasirea datelor
SELECT * FROM SCRUM_MANAGEMENT;

SELECT ECHIPA,
PROIECT,
PRODUS,
PRET,
VERSIUNE,
CATEGORIA_PRODUS
FROM SCRUM_MANAGEMENT 
WHERE CATEGORIA_PRODUS = 'AppDev';


-- Operatie nepermisa LMD UPDATE - MODIFICAREA VALORILOR COLOANELOR
-- eroare: An attempt was made to insert or update columns of a join view which    map to a non-key-preserved table.

UPDATE SCRUM_MANAGEMENT
SET PRET = 100
WHERE CATEGORIA_PRODUS = 'AppDev';



--15
-- OUTER JOIN  5 tabele left outer join si un join simplu
-- OBIECTIV: afiseaza angajatii a caror locatie nu e inregistrata si  au participat la realizarea unui produs care inca nu e lansat  

SELECT DISTINCT A.NUME, A.PRENUME, T.ID_TARA,E.ID_ECHIPA, PR.ID_PRODUS, R.ID_RELEASE FROM ANGAJATI A
LEFT OUTER JOIN LOCATII L ON L.ID_LOCATIE = A.ID_LOCATIE
LEFT OUTER JOIN TARI T ON T.ID_TARA = L.ID_TARA
JOIN ECHIPA E ON E.ID_ECHIPA = A.ID_ECHIPA
LEFT OUTER JOIN PROIECTE P ON P.ID_ECHIPA = E.ID_ECHIPA
LEFT OUTER JOIN PRODUSE PR ON PR.ID_PROIECT = P.ID_PROIECT
LEFT OUTER JOIN RELEASE R ON R.ID_PRODUS = PR.ID_PRODUS
WHERE A.ID_LOCATIE IS NULL AND  R.ID_PRODUS IS NULL;

--o cerere ce utilizează operația division
/* OBIECTIV:
operația de divizare este utilizată pentru a găsi echipele (ECHIPA) care au eliberări (RELEASE) pentru toate produsele (PRODUS) din cadrul unui proiect (PROIECT).
În mod specific, interogarea verifică existența echipei în tabelul PROIECTE și apoi verifică existența tuturor produselor asociate cu acel proiect în tabelul PRODUSE. 
În cele din urmă, se verifică dacă există eliberări asociate cu fiecare produs în tabelul RELEASE.
Dacă nu există diferențe sau lipsuri, înseamnă că echipa are eliberări pentru toate produsele din cadrul proiectului.
*/

SELECT E.ID_ECHIPA
FROM ECHIPA E
WHERE NOT EXISTS (
  SELECT P.ID_PROIECT
  FROM PROIECTE P
  WHERE P.ID_ECHIPA = E.ID_ECHIPA
  AND NOT EXISTS (
    SELECT PR.ID_PRODUS
    FROM PRODUSE PR
    WHERE PR.ID_PROIECT = P.ID_PROIECT
    AND NOT EXISTS (
      SELECT R.ID_PRODUS
      FROM RELEASE R
      WHERE R.ID_PRODUS = PR.ID_PRODUS
    )
  )
);



--analiza top-n:
SELECT ROWNUM AS RANKING, NUME, PRENUME, DATA_ANGAJARII, SALARIU
FROM (SELECT NUME, PRENUME, DATA_ANGAJARII, SALARIU
        FROM ANGAJATI
        ORDER BY SALARIU DESC NULLS LAST)
WHERE ROWNUM <=7;


--EX16

-- Aceste queries sunt semantic echivalente, pentru ca 
-- ambele afiseaza angajatii (num, prenume, job)
-- din echipele care au o performanta > 9

/*
Motorul de bază de date începe executarea interogării și stabilește o interogare de tip JOIN între tabelele "ANGAJATI" și "ECHIPA". Se va realiza o îmbinare între aceste tabele pe baza condiției "E.ID_ECHIPA = A.ID_ECHIPA".

Motorul de bază de date începe scanarea tabelului "ECHIPA" și filtrează rândurile în funcție de condiția "E.PERFORMANTA >= 9". Numai rândurile care îndeplinesc această condiție vor fi luate în considerare în procesul de îmbinare.

Motorul de bază de date continuă cu scanarea tabelului "ANGAJATI" și compară valorile "ID_ECHIPA" din acesta cu valorile corespunzătoare din tabelul "ECHIPA". Doar rândurile care au o valoare potrivită în ambele tabele vor fi selectate în rezultatul final.

Atunci când valorile "ID_ECHIPA" se potrivesc între cele două tabele, motorul de bază de date va recupera coloanele solicitate: "NUME," "PRENUME" și "ID_JOB" din tabelul "ANGAJATI".

Rândurile rezultate, care îndeplinesc condiția "E.PERFORMANTA >= 9" și se potrivesc pe baza valorilor "ID_ECHIPA" în cele două tabele, vor fi returnate ca rezultat final al interogării.

Acest plan de execuție utilizează o îmbinare între tabele și filtrează rândurile înainte de a realiza îmbinarea, ceea ce poate contribui la o performanță mai bună a interogării, deoarece numai rândurile relevante sunt luate în considerare.
*/
-- VARIANTA1 0.006 sec
SELECT NUME, PRENUME, ID_JOB
FROM ANGAJATI A 
JOIN ECHIPA E ON E.ID_ECHIPA = A.ID_ECHIPA
WHERE E.PERFORMANTA >= 9;   


-- VARIANTA2 0.012 - o.027 sec

/*
Rezultatele sunt filtrate pe baza unei condiții utilizând o subinterogare.

Iată planul de execuție pentru interogare:

Mai întâi, subinterogarea este executată. Aceasta selectează valorile "ID_ECHIPA" din tabela "ECHIPA" unde coloana "PERFORMANTA" este mai mare decât 9.

Rezultatul subinterogării este utilizat ca filtru în interogarea principală. Interogarea principală recuperează coloanele "NUME," "PRENUME" și "ID_JOB" din tabela "ANGAJATI" unde valoarea "ID_ECHIPA" se regăsește în rezultatul subinterogării.

Motorul de bază de date execută interogarea principală prin scanarea tabelului "ANGAJATI". Verifică valoarea "ID_ECHIPA" pentru fiecare rând în raport cu rezultatul subinterogării și recuperează valorile corespunzătoare "NUME," "PRENUME" și "ID_JOB" pentru rândurile care se potrivesc.

Rândurile rezultate, care îndeplinesc condiția, sunt returnate ca rezultat final al interogării.

Notă: Planul de execuție real poate varia în funcție de sistemul de gestionare a bazelor de date (DBMS) utilizat și de optimizatorul său de interogare. 
DBMS-ul poate utiliza diferite tehnici de optimizare, cum ar fi utilizarea de indexuri sau de cache, pentru a îmbunătăți performanța interogării.
*/
SELECT NUME, PRENUME, ID_JOB
FROM ANGAJATI 
WHERE ID_ECHIPA IN ( SELECT ID_ECHIPA FROM ECHIPA
                    WHERE PERFORMANTA > 9 );


-- CONCLUZIE:
/*
În ceea ce privește eficiența, prima interogare cu îmbinare este în general mai eficientă decât a doua interogare cu subinterogare în clauza WHERE.
De obicei, îmbinarea este optimizată de optimizatorul de interogări al bazei de date pentru a utiliza mai eficient resursele și a returna rezultatele mai rapid. 
În plus, planul de execuție al primei interogări poate beneficia de utilizarea indecșilor sau a altor tehnici de optimizare specifice îmbinărilor.
*/

