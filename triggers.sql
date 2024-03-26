-- Trigger sur la table Utilisateur
DROP SEQUENCE utilisateur_seq;
CREATE SEQUENCE utilisateur_seq
    START WITH 0
    MINVALUE 0
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
    
CREATE OR REPLACE TRIGGER utilisateur_before_insert_trigger
BEFORE INSERT ON Utilisateur
FOR EACH ROW
DECLARE
    generated_login VARCHAR2(10);
    generated_password VARCHAR2(255);
    login_exists NUMBER;
BEGIN
    SELECT utilisateur_seq.NEXTVAL INTO :NEW.ref_utilisateur FROM DUAL;

    :NEW.date_d_inscription := CURRENT_TIMESTAMP;

    IF :NEW.date_de_naissance > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Date of birth cannot be in the future.');
    END IF;

    generated_login := LOWER(SUBSTR(:NEW.prenom, 1, 1) || SUBSTR(:NEW.nom, 1, 7) || LPAD(DBMS_RANDOM.VALUE(10, 99), 2, '0'));
    
    SELECT COUNT(*) INTO login_exists
    FROM Utilisateur
    WHERE login = generated_login;
    
    WHILE login_exists > 0 LOOP
        generated_login := LOWER(SUBSTR(:NEW.prenom, 1, 1) || SUBSTR(:NEW.nom, 1, 7) || LPAD(DBMS_RANDOM.VALUE(10, 99), 2, '0'));
        SELECT COUNT(*) INTO login_exists
        FROM Utilisateur
        WHERE login = generated_login;
    END LOOP;

    :NEW.login := generated_login;

    generated_password := DBMS_RANDOM.STRING('A', 5) || DBMS_RANDOM.STRING('X', 5);
    
    :NEW.mot_de_passe := REGEXP_REPLACE(generated_password, '[^a-zA-Z0-9_]', '_');
END;
/

DROP TYPE ScoreIncrementList;
CREATE TYPE ScoreIncrementList AS TABLE OF NUMBER;
/
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER tache_fini_after_insert_trigger
AFTER INSERT ON Tache_fini
FOR EACH ROW
DECLARE
    v_assigned_user INT;
    v_score_category VARCHAR2(255);
    v_score_increment NUMBER;
    v_score_increment2 ScoreIncrementList;
    v_nom_programme VARCHAR2(255);
    v_score INT;
    v_game_level INT;
BEGIN
    SELECT ref_utilisateur INTO v_assigned_user
    FROM Est_assigne
    WHERE ref_tache = :NEW.ref_tache;

    v_score_category := :NEW.nom_categorie;
    SELECT nom_programme
    INTO v_nom_programme
    FROM Utilisateur
    WHERE ref_utilisateur = v_assigned_user;

    -- si l'utilisateur n'a pas de programme
    IF v_nom_programme IS NULL THEN
        SELECT CASE 
                    WHEN :NEW.statut = 'Terminé' AND sct.termine = 'Y' THEN sct.score
                    WHEN :NEW.statut = 'Expiré' AND sct.termine = 'N' THEN sct.score
                END
        BULK COLLECT INTO v_score_increment2
        FROM Score_categorie_tache sct
        WHERE nom_categorie = v_score_category;
    ELSE -- si programme alors faut passer par Comporte
        SELECT CASE 
                    WHEN :NEW.statut = 'Terminé' AND sct.termine = 'Y' THEN sct.score
                    WHEN :NEW.statut = 'Expiré' AND sct.termine = 'N' THEN sct.score
                END
        BULK COLLECT INTO v_score_increment2
        FROM Comporte c
        JOIN Score_categorie_tache sct ON sct.ref_score_categorie_tache = c.ref_score_categorie_tache
        WHERE c.nom_programme = v_nom_programme;
    END IF;
    
    FOR k IN v_score_increment2.FIRST .. v_score_increment2.LAST
    LOOP
        IF v_score_increment2(k) IS NOT NULL THEN
            v_score_increment := v_score_increment2(k);
        END IF;
    END LOOP;
    UPDATE Utilisateur
    SET score = score + v_score_increment
    WHERE ref_utilisateur = v_assigned_user;
   

    -- verifier si l'utilisateur a atteint un nouveau niveau
    SELECT score, game_level 
    INTO v_score, v_game_level
    FROM Utilisateur 
    WHERE ref_utilisateur = v_assigned_user;
    IF  v_score >= (100 * POWER(2, v_game_level - 1)) THEN
        UPDATE Utilisateur
        SET game_level = v_game_level + 1
        WHERE ref_utilisateur = v_assigned_user;
    END IF;
END;
/

-- DROP TRIGGER tache_fini_after_insert_trigger;


COMMIT;
