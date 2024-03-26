TRUNCATE TABLE Comporte;

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Informatique', 'travail_non_termine');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Informatique', 'etude_terminee');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Marketing', 'personnel_termine');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Finance', 'sante_terminee');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Finance', 'DevMob_non_termine');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Ressources Humaines', 'travail_termine');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Ressources Humaines', 'etude_non_terminee');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Ventes', 'loisirs_non_termine');

INSERT INTO Comporte (nom_programme, ref_score_categorie_tache)
VALUES 
    ('Dep. Informatique', 'loisirs_terminee');

COMMIT;