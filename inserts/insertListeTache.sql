TRUNCATE TABLE Liste_tache;

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (0, 'Travail', 0);

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (1, 'Étude', 1);

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (2, 'Loisirs', 2);

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (3, 'Santé', 3);

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (4, 'Personnel', 4);

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (5, 'Loisirs', 0);

INSERT INTO Liste_tache (ref_liste, nom_categorie, ref_utilisateur)
VALUES 
    (6, 'Personnel', 1);

COMMIT;