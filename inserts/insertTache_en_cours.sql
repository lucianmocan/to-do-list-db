TRUNCATE TABLE Tache_en_cours;

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (0, 'Développement de la fonction de recherche', 'Implémenter une fonction de recherche avancée dans l''application web.', 2, 'https://example.com/search-feature', TIMESTAMP '2024-02-15 12:00:00', 'En cours', 'Développement Web', 0, 0, TIMESTAMP '2024-02-13 12:00:00');

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (1, 'Analyse des performances marketing', 'Effectuer une analyse et recherche approfondie des performances marketing du dernier trimestre.', 1, 'https://example.com/marketing-analysis', TIMESTAMP '2024-02-20 14:30:00', 'En cours', 'Analyse Marketing', 1, 1, TIMESTAMP '2024-02-15 12:00:00');

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (2, 'Création d''une application mobile', 'Développer une nouvelle application mobile pour le département.', 3, 'https://example.com/mobile-app', TIMESTAMP '2024-02-18 10:00:00', 'En cours', 'Développement Mobile', 2, 2, NULL);

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (3, 'Optimisation des processus RH', 'Identifier et mettre en œuvre des améliorations pour optimiser les processus RH.', 2, 'https://example.com/hr-process-optimization', TIMESTAMP '2024-03-01 16:45:00', 'En cours', 'Ressources Humaines', 3, 3, NULL);

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (4, 'Analyse des données du Big Data', 'Effectuer une analyse et recherche approfondie des données du Big Data pour obtenir des insights.', 1, 'https://example.com/big-data-analysis', TIMESTAMP '2024-03-06 11:30:00', 'En cours', 'Analyse de Données', 4, 4, NULL);

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (5, 'Planification d''une activité de team building', 'Planifier et organiser une activité de team building pour renforcer l''esprit d''équipe.', 3, 'https://example.com/team-building', TIMESTAMP '2024-03-11 09:15:00', 'En cours', 'Événements', 0, 0, NULL);

INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (6, 'Développement d''une fonctionnalité IA', 'Implémenter une nouvelle fonctionnalité utilisant l''intelligence artificielle.', 2, 'https://example.com/ai-feature', TIMESTAMP '2024-03-16 13:00:00', 'En cours', 'Développement IA', 1, 1, NULL);


INSERT INTO Tache_en_cours (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (13, 'Développement d''un compilateur', 'Apprendre ce que c''est un compilateur', 2, 'https://example.com/ai-feature', TIMESTAMP '2024-03-16 13:00:00', 'En cours', 'Développement IA', 5, 1, NULL);

COMMIT;