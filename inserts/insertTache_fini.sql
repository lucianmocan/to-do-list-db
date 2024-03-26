TRUNCATE TABLE Tache_fini;


INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (7, 'Validation des tests unitaires', 'Effectuer la validation des tests unitaires pour garantir la qualité du code.', 2, 'https://example.com/unit-tests-validation', TIMESTAMP '2024-03-20 10:30:00', 'Terminé', 'Travail', 0, 0, TIMESTAMP '2024-03-18 15:45:00');

INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (8, 'Rapport financier trimestriel', 'Préparer et finaliser le rapport financier trimestriel pour la direction financière.', 1, 'https://example.com/financial-report', TIMESTAMP '2024-03-25 12:00:00', 'Terminé', 'Travail', 1, 2, TIMESTAMP '2024-03-24 17:30:00');


INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (9, 'Déploiement de la mise à jour', 'Effectuer le déploiement de la dernière mise à jour logicielle sur les serveurs de production.', 3, 'https://example.com/update-deployment', TIMESTAMP '2024-03-30 15:45:00', 'Terminé', 'Personnel', 2, 3, TIMESTAMP '2024-03-28 11:15:00');

INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (10, 'Formation des employés', 'Organiser et dispenser une formation pour les employés sur l''utilisation du nouveau logiciel.', 2, 'https://example.com/employee-training', TIMESTAMP '2024-04-05 09:30:00', 'Terminé', 'Santé', 1, 4, TIMESTAMP '2024-04-03 14:00:00');

INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (11, 'Analyse des retours clients', 'Analyser les retours clients pour identifier les améliorations nécessaires.', 1, 'https://example.com/customer-feedback-analysis', TIMESTAMP '2024-04-10 11:00:00', 'Terminé', 'Étude', 0, 0, TIMESTAMP '2024-04-08 16:45:00');


INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, date_d_echeance, statut, nom_categorie, ref_periodicite, ref_utilisateur, date_realisation)
VALUES 
    (14, 'Rédaction du rapport', 'Résumer les résultats de l''analyse des retours clients dans un rapport détaillé.', 2, 'https://example.com/report-writing', TIMESTAMP '2024-03-23 14:00:00', 'Expiré', 'Étude', 0, 0, NULL);

COMMIT;

