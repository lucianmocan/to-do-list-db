
/*
1. Définir une fonction qui calcule le nombre de point gagné/perdu 
(pour les utilisateurs ayant un programme de score, en fonction du nombre de 
tâche terminée/non terminée) au cours de la semaine.
*/
CREATE OR REPLACE FUNCTION calculer_points_semaine
RETURN SYS_REFCURSOR
IS
    c_cursor SYS_REFCURSOR; -- définir un curseur faiblement typé
BEGIN
    OPEN c_cursor FOR
    SELECT
        u.ref_utilisateur,
        u.login,
        COALESCE(SUM(
            CASE 
                WHEN tf.statut = 'Terminé' AND sct.termine = 'Y' THEN sct.score 
                WHEN tf.statut = 'Expiré' AND sct.termine = 'N' THEN sct.score
            END
            ), 0) AS points_gagnes
    FROM
        Utilisateur u
        JOIN Est_assigne ea ON u.ref_utilisateur = ea.ref_utilisateur
        JOIN Tache t ON ea.ref_tache = t.ref_tache
        JOIN Tache_fini tf ON t.ref_tache = tf.ref_tache
        JOIN Score_categorie_tache sct ON sct.nom_categorie = tf.nom_categorie
    WHERE
            tf.Date_Realisation
            BETWEEN NEXT_DAY(TRUNC(sysdate - 7), 'MONDAY')
            AND TRUNC(sysdate)
        OR tf.Date_d_echeance
            BETWEEN NEXT_DAY(TRUNC(sysdate - 7), 'MONDAY')
            AND TRUNC(sysdate)
            AND tf.Date_Realisation IS NULL
    GROUP BY
        u.ref_utilisateur,
        u.login;
    
    RETURN c_cursor;
END;
/


/*
2. On supposera que la procédure est exécutée chaque semaine (le lundi, à 8h). 
Définir une procédure qui archive toutes les tâches passées.
*/

CREATE OR REPLACE PROCEDURE taches_en_cours_devient_tache_fini AS
BEGIN
    -- Les tâches passées sont soit expirées, soit terminées pendant la dernière semaine.
    
    -- Ici, on cherche à archiver les tâches 'terminées' pendant la semaine
    -- c'est-à-dire, les tâches qui ont obtenu une date de réalisation 
    -- pendant la semaine.
    INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, 
                            date_d_echeance, statut, nom_categorie, ref_periodicite, 
                            ref_utilisateur, date_realisation)
    SELECT
        tec.ref_tache,
        tec.intitule,
        tec.description,
        tec.priorite,
        tec.url,
        tec.date_d_echeance,
        'Terminé' AS statut,
        tec.nom_categorie,
        tec.ref_periodicite,
        tec.ref_utilisateur,
        tec.date_realisation
    FROM
        Tache_en_cours tec
    WHERE
        tec.date_realisation IS NOT NULL
        AND tec.date_realisation
            BETWEEN NEXT_DAY(TRUNC(sysdate - 8), 'MONDAY')
            AND TRUNC(sysdate - 1);

    -- Il faut aussi archiver les tâches qui n'ont pas été terminées mais 
    -- dont la date d'écheance est arrivée la semaine dernière.
    INSERT INTO Tache_fini (ref_tache, intitule, description, priorite, url, 
                            date_d_echeance, statut, nom_categorie, ref_periodicite, 
                            ref_utilisateur, date_realisation)
    SELECT
        tec.ref_tache,
        tec.intitule,
        tec.description,
        tec.priorite,
        tec.url,
        tec.date_d_echeance,
        'Expiré' AS statut,
        tec.nom_categorie,
        tec.ref_periodicite,
        tec.ref_utilisateur,
        tec.date_realisation
    FROM
        Tache_en_cours tec
    WHERE
        tec.date_d_echeance <= TRUNC(sysdate - 1) + INTERVAL '23:59:59' HOUR TO SECOND
        AND tec.Date_realisation IS NULL;

    -- Supprimer les tâches archivées de la table Tache_en_cours
    DELETE FROM Tache_en_cours
    WHERE
        ((date_realisation IS NOT NULL AND date_realisation 
        BETWEEN NEXT_DAY(TRUNC(sysdate - 8), 'MONDAY') AND TRUNC(sysdate - 1))
        OR (date_d_echeance <= TRUNC(sysdate - 1) + INTERVAL '23:59:59' HOUR TO SECOND AND date_realisation IS NULL));
END;
/


/*
3.Ecrire le code PL/SQL permettant de générer des suggestions pour un utilisateur, 
c’est dire N tâches qu’il pourrait ajouter à sa liste de tâche. Les tâches suggérées 
seront les N tâches apparaissant le plus grand nombre de fois dans les tâches des 
utilisateurs similaires. Les utilisateurs similaires sont les utilisateurs ayant 
au moins X tâches similaires avec l’utilisateur pour lequel effectuer les suggestions. 
Des tâches similaires sont des tâches ayant au moins Y mots communs (dans les mots communs, 
on ne compte pas les mots vides/stop words comme les articles ou les verbes peu significatifs type faire ou avoir). 
*/

-- Fonction qui prend un text en entrée et retourne le texte sans les mots vides.
CREATE OR REPLACE FUNCTION RemoveStopWords(raw_text VARCHAR2) RETURN VARCHAR2 IS
    TYPE StopWordList IS TABLE OF VARCHAR2(255);
    stop_words StopWordList; 
    clean_text VARCHAR2(4000);

BEGIN
    stop_words := StopWordList
        ('le', 'l', 'la', 'les', 'de', 'd', 'des', 'et', 'ou', 'a', 'avec', 'pour',
        'ce', 'c', 'est', 'sont', 'suis', 'un', 'une', 'est',
        'sur', 'dans', 'qui', 'que', 'ne', 'pas','faire', 'avoir', 'être', 'aller');  
    FOR word IN (
        SELECT regexp_substr(raw_text, '[[:alnum:]]+', 1, LEVEL) AS word
        FROM dual
        CONNECT BY LEVEL <= regexp_count(raw_text, '[^[:alnum:]]') + 1
    ) LOOP
        IF NOT word.word MEMBER OF stop_words THEN
            clean_text := clean_text || ' ' || lower(word.word);
        END IF;
    END LOOP;

    RETURN TRIM(clean_text);
END;
/
/* 
SET SERVEROUTPUT ON;
EXECUTE DBMS_OUTPUT.PUT_LINE('Original Text: ' || 'Apprendre ce que c''est un compilateur');
EXECUTE DBMS_OUTPUT.PUT_LINE('Result Text: ' || RemoveStopWords('Apprendre ce que c''est un compilateur'));
*/

CREATE OR REPLACE TYPE TaskWords AS OBJECT (
    ref_tache INT,
    words VARCHAR2(8000)
);
/

CREATE OR REPLACE TYPE TaskWordsList AS TABLE OF TaskWords;
/
-- DROP TYPE SentenceInfoList;

/*
Fonction qui retourne tout le ref_tache et le bon texte pour faire des comparaisons
pour déterminer la similarité - mais la fonction regarde les tâches créées par
l'utilisateur et non pas les tâches qu'il a à faire (qui lui sont assignées)
*/
CREATE OR REPLACE FUNCTION LoadUserTasksWords(p_ref_utilisateur IN NUMBER)
    RETURN TaskWordsList
IS
    p_array TaskWordsList := TaskWordsList();
    intitule_words VARCHAR2(4000);
    description_words VARCHAR2(4000);
    all_words VARCHAR2(8000);

BEGIN
    FOR t IN (
        SELECT ref_tache, intitule, description 
        FROM Tache_en_cours
        WHERE ref_utilisateur = p_ref_utilisateur

        UNION ALL

        SELECT ref_tache, intitule, description
        FROM Tache_fini
        WHERE ref_utilisateur = p_ref_utilisateur) 
    LOOP
        description_words := RemoveStopWords(t.description);
        intitule_words := RemoveStopWords(t.intitule);
        all_words := intitule_words || ' ' || description_words;
        p_array.EXTEND;
        p_array(p_array.LAST) := TaskWords(t.ref_tache, all_words);
    END LOOP;
    RETURN p_array;

END;
/

/*
SET SERVEROUTPUT ON;
DECLARE
    result SentenceInfoList;
BEGIN
    result := LoadUserSentences(4);
    FOR i IN 1..result.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(result(i).ref_tache || ' ' || result(i).sentences);
    END LOOP;
END;
/
*/


SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE generate_task_suggestions(
    user_id IN NUMBER,
    max_number_of_suggestions IN NUMBER,
    user_similarity_threshold IN NUMBER,
    task_similarity_threshold IN NUMBER
)
IS  
    TYPE RefUtilisateurArray IS TABLE OF Utilisateur.ref_utilisateur%TYPE;
    v_mainUserTasksWordsList TaskWordsList;
    v_UserTasksWordsList TaskWordsList;
    v_RefUtilisateursSimilaires RefUtilisateurArray := RefutilisateurArray();
    TYPE TaskSimilarityRecord IS RECORD (
        ref_tache INT,
        common_words_count NUMBER
    );
    TYPE TaskSimilarityArray IS TABLE OF TaskSimilarityRecord;
    v_TaskSimilarities TaskSimilarityArray;
    v_CommonWordsCount NUMBER := 0;
    v_CommonTasksCount NUMBER := 0;
    i NUMBER := 0;
    v_TaskTitle varchar2(255);
    v_TaskDescription varchar2(4000);
    v_UniqueTaskSimilarities TaskSimilarityArray;
    v_RefTacheExists BOOLEAN := FALSE;
BEGIN
    v_mainUserTasksWordsList := LoadUserTasksWords(user_id);
    v_TaskSimilarities := TaskSimilarityArray();
    IF v_mainUserTasksWordsList IS NOT NULL AND v_mainUserTasksWordsList.COUNT > 0 THEN
        IF v_mainUserTasksWordsList(v_mainUserTasksWordsList.FIRST).ref_tache IS NOT NULL THEN
            FOR user IN (
                SELECT DISTINCT ref_utilisateur
                FROM Utilisateur u
                WHERE ref_utilisateur != user_id) 
            LOOP
                v_UserTasksWordsList := LoadUserTasksWords(user.ref_utilisateur);
                IF v_UserTasksWordsList IS NOT NULL AND v_UserTasksWordsList.COUNT > 0 THEN
                    IF v_UserTasksWordsList(v_UserTasksWordsList.FIRST).ref_tache IS NOT NULL THEN  
                        FOR i IN v_mainUserTasksWordsList.FIRST..v_mainUserTasksWordsList.LAST
                        LOOP
                            FOR j in v_UserTasksWordsList.FIRST..v_UserTasksWordsList.LAST
                            LOOP    
                                    WITH string1_words AS (
                                    SELECT TRIM(REGEXP_SUBSTR(v_UserTasksWordsList(j).words, '[^ ]+', 1, LEVEL)) AS word
                                    FROM DUAL
                                    CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(v_UserTasksWordsList(j).words, '[^ ]')) + 1
                                    ),
                                    string2_words AS (
                                    SELECT TRIM(REGEXP_SUBSTR(v_mainUserTasksWordsList(i).words, '[^ ]+', 1, LEVEL)) AS word
                                    FROM DUAL
                                    CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(v_mainUserTasksWordsList(i).words, '[^ ]')) + 1
                                    )
                                    SELECT COUNT(DISTINCT sw.word)
                                    INTO v_CommonWordsCount
                                    FROM string1_words sw
                                    JOIN string2_words sw2 ON sw.word = sw2.word;
                                    IF v_CommonWordsCount >= task_similarity_threshold THEN 
                                            v_RefTacheExists := FALSE;
                                            -- verifier si la tache n'est pas deja presente dans le tableau
                                            -- pour eviter les doublons.
                                            IF v_TaskSimilarities IS NOT NULL AND v_TaskSimilarities.COUNT > 0 THEN
                                                FOR k IN v_TaskSimilarities.FIRST..v_TaskSimilarities.LAST
                                                LOOP
                                                    IF v_TaskSimilarities(k).ref_tache = v_UserTasksWordsList(j).ref_tache THEN
                                                        v_RefTacheExists := TRUE;
                                                        EXIT;
                                                    END IF;
                                                END LOOP;
                                            END IF;

                                        v_CommonTasksCount := v_CommonTasksCount + 1; 
                                        IF NOT v_RefTacheExists THEN
                                            v_TaskSimilarities.EXTEND;
                                            v_TaskSimilarities(v_TaskSimilarities.LAST).ref_tache := v_UserTasksWordsList(j).ref_tache;
                                            v_TaskSimilarities(v_TaskSimilarities.LAST).common_words_count := v_CommonWordsCount;
                                        END IF;
                                    END IF;
                            END LOOP;
                        END LOOP;
                        IF v_CommonTasksCount >= user_similarity_threshold THEN
                            v_RefUtilisateursSimilaires.EXTEND;
                            v_RefUtilisateursSimilaires(v_RefUtilisateursSimilaires.LAST) := user.ref_utilisateur;
                        END IF;
                    END IF;
                END IF;
            END LOOP;
            IF v_RefUtilisateursSimilaires IS NOT NULL AND v_RefUtilisateursSimilaires.COUNT > 0 THEN
                IF v_TaskSimilarities IS NOT NULL AND v_TaskSimilarities.COUNT > 0 THEN
                    -- trier le tableau en utilisant le nombre de mots communs trouver pour une tache
                    FOR i IN 1..v_TaskSimilarities.COUNT - 1
                    LOOP
                        FOR j IN i + 1..v_TaskSimilarities.COUNT
                        LOOP
                            IF v_TaskSimilarities(i).common_words_count < v_TaskSimilarities(j).common_words_count THEN
                                DECLARE
                                    temp TaskSimilarityRecord;
                                BEGIN
                                    temp := v_TaskSimilarities(i);
                                    v_TaskSimilarities(i) := v_TaskSimilarities(j);
                                    v_TaskSimilarities(j) := temp;
                                END;
                            END IF;
                        END LOOP;
                    END LOOP;
                    FOR idx IN v_TaskSimilarities.FIRST..v_TaskSimilarities.LAST
                    LOOP
                        IF v_TaskSimilarities(idx).ref_tache MEMBER OF v_RefUtilisateursSimilaires THEN
                            SELECT intitule, description
                                INTO v_TaskTitle, v_TaskDescription
                                FROM Tache_en_cours
                                WHERE ref_tache = v_TaskSimilarities(idx).ref_tache;
                            
                                IF v_TaskTitle IS NULL THEN
                                    SELECT intitule, description
                                    INTO v_TaskTitle, v_TaskDescription
                                    FROM Tache_fini
                                    WHERE ref_tache = v_TaskSimilarities(idx).ref_tache;
                                END IF;
                            
                                IF v_TaskTitle IS NOT NULL THEN
                                    DBMS_OUTPUT.PUT_LINE('Task: ref_tache=' || v_TaskSimilarities(idx).ref_tache ||
                                                         ', intitule=' || v_TaskTitle ||
                                                         ', description=' || v_TaskDescription);
                                END IF;
                                i := i+1;
                                
                                IF i >= max_number_of_suggestions THEN
                                    EXIT;
                                END IF;
                        END IF;
                    END LOOP;
                END IF;
            END IF;
        END IF;
    END IF;
    
END;
/

