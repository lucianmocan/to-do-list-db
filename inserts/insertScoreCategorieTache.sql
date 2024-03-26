TRUNCATE TABLE Score_categorie_tache;

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('travail_non_termine', 'N', -50, 'Travail');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('DevMob_non_termine', 'N', -75, 'Développement Mobile');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('travail_termine', 'Y', 95, 'Travail');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('personnel_non_termine', 'N', -20, 'Personnel');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('personnel_termine', 'Y', 85, 'Personnel');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('etude_non_terminee', 'N', -70, 'Étude');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('etude_terminee', 'Y', 75, 'Étude');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('sante_non_terminee', 'N', -100, 'Santé');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('sante_terminee', 'Y', 100, 'Santé');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('loisirs_non_termine', 'N', -15, 'Loisirs');

INSERT INTO Score_categorie_tache (ref_score_categorie_tache, termine, score, nom_categorie)
VALUES 
    ('loisirs_terminee', 'Y', 75, 'Loisirs');
    
COMMIT;
