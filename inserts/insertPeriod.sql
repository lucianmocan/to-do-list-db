TRUNCATE TABLE Periodicite;

INSERT INTO Periodicite (ref_periodicite, date_debut, date_fin, periode)
VALUES 
    (0, TO_DATE('01-10-2022', 'DD-MM-YYYY'), TO_DATE('01-10-2022', 'DD-MM-YYYY') + INTERVAL '60' DAY, INTERVAL '60' DAY);
    
INSERT INTO Periodicite (ref_periodicite, date_debut, date_fin, periode)
VALUES 
    (1, TO_DATE('01-01-2022', 'DD-MM-YYYY'), TO_DATE('08-01-2022', 'DD-MM-YYYY'), INTERVAL '7' DAY);

INSERT INTO Periodicite (ref_periodicite, date_debut, date_fin, periode)
VALUES 
    (2, TO_DATE('01-03-2022', 'DD-MM-YYYY'), TO_DATE('31-03-2022', 'DD-MM-YYYY'), INTERVAL '30' DAY);

INSERT INTO Periodicite (ref_periodicite, date_debut, date_fin, periode)
VALUES 
    (3, TO_DATE('01-05-2022', 'DD-MM-YYYY'), TO_DATE('01-05-2022', 'DD-MM-YYYY') + INTERVAL '90' DAY, INTERVAL '90' DAY);

INSERT INTO Periodicite (ref_periodicite, date_debut, date_fin, periode)
VALUES 
    (4, TO_DATE('01-07-2022', 'DD-MM-YYYY'), TO_DATE('02-07-2022', 'DD-MM-YYYY'), INTERVAL '1' DAY);
    
INSERT INTO Periodicite (ref_periodicite, date_debut, date_fin, periode)
VALUES 
    (5, TO_DATE('01-07-2023', 'DD-MM-YYYY'), NULL, NULL);
    
COMMIT;