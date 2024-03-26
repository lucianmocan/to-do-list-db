
/*
1. Les listes de tâches ayant au moins 5 tâches et appartenant à des utilisateurs habitant en France.
*/

CREATE INDEX idx_utilisateur_pays ON Utilisateur(pays);
SELECT
    l.ref_liste,
    l.nom_categorie,
    l.ref_utilisateur
FROM
    Liste_tache l
    INNER JOIN Tache_appartenant_a_liste t ON l.ref_liste = t.ref_liste
    INNER JOIN Utilisateur               u ON l.ref_utilisateur = u.ref_utilisateur
WHERE
    u.pays = 'France'
GROUP BY
    l.ref_liste,
    l.nom_categorie,
    l.ref_utilisateur
HAVING
    COUNT(t.ref_tache) >= 5;

DROP INDEX idx_utilisateur_pays;

/*
2. Les programmes de tâche ayant le plus de points positifs (somme des points) associés aux tâches terminées.
*/
CREATE INDEX idx_sct_termine ON Score_categorie_tache(termine);
CREATE INDEX idx_tf_nom_categorie ON Tache_fini(nom_categorie);

SELECT 
    c.nom_programme, 
    sum(sct.score) as points_positifs_total
FROM 
    Comporte c
    JOIN Score_categorie_tache sct
    ON c.ref_score_categorie_tache = sct.ref_score_categorie_tache
    JOIN Tache_fini tf ON sct.nom_categorie = tf.nom_categorie
WHERE 
    sct.termine = 'Y'
GROUP BY 
    c.nom_programme
ORDER BY 
    points_positifs_total DESC;
    
DROP INDEX idx_sct_termine;
DROP INDEX idx_tf_nom_categorie;

/*
3. Pour chaque utilisateur, son login, son nom, son prénom, son adresse, son nombre
de tâches total (périodique et non-périodique) et son nombre de tâches périodiques total.
*/

SELECT 
    u.login, 
    u.nom, 
    u.prenom, 
    u.adresse, 
    count(DISTINCT t.ref_tache) as nombre_de_taches_total,
    count(DISTINCT CASE WHEN p.periode IS NOT NULL THEN t.ref_tache END) 
    AS nombre_total_de_taches_periodiques
FROM
    Utilisateur u
    LEFT JOIN Est_assigne ea ON u.ref_utilisateur = ea.ref_utilisateur
    LEFT JOIN Tache t ON ea.ref_tache = t.ref_tache
    LEFT JOIN Tache_en_cours tec ON t.ref_tache = tec.ref_tache
    LEFT JOIN Tache_fini tf ON t.ref_tache = tf.ref_tache
    LEFT JOIN Periodicite p ON tec.ref_periodicite = p.ref_periodicite 
                            OR tf.ref_periodicite = p.ref_periodicite
GROUP BY 
    u.login, 
    u.nom, 
    u.prenom, 
    u.adresse;
    
/*
4. Pour chaque tâche, le nombre de dépendances à effectuer avant que la tâche puisse être réalisée.
*/

SELECT
    t.ref_tache, 
    count(dd.ref_tache_2) as nombre_de_dependences
FROM
    Tache t
    LEFT JOIN Depend_de dd ON t.ref_tache = dd.ref_tache_1
GROUP BY
    t.ref_tache;
    
/*
5. Les 10 utilisateurs ayant gagné le plus de points sur leur score au cours de la semaine courante.
*/

CREATE INDEX idx_tf_nom_categorie ON Tache_fini(nom_categorie);
CREATE INDEX idx_tache_fini_date_realisation ON Tache_fini(Date_Realisation);

SELECT
    u.nom, 
    u.prenom,
    sum(sct.score) as points_gagnes
FROM 
    Utilisateur u
    JOIN Est_assigne ea ON u.ref_utilisateur = ea.ref_utilisateur
    JOIN Tache t ON ea.ref_tache = t.ref_tache
    JOIN Tache_fini tf ON t.ref_tache = tf.ref_tache
    JOIN Score_categorie_tache sct ON sct.nom_categorie = tf.nom_categorie
WHERE tf.Date_Realisation 
    BETWEEN NEXT_DAY(TRUNC(sysdate - 7), 'MONDAY') -- à mettre à la place de sysdate : TO_DATE('24-03-2024', 'DD-MM-YYYY')
    AND TRUNC(sysdate + 1) -- pour tester mettre TO_DATE('24-03-2024', 'DD-MM-YYYY') à la place de sysdate
GROUP BY
    u.nom, 
    u.prenom
ORDER BY points_gagnes DESC
FETCH FIRST 10 ROWS ONLY;

DROP INDEX idx_tf_nom_categorie;
DROP INDEX idx_tache_fini_date_realisation;
