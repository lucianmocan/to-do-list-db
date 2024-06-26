-- Drop view Taches
DROP VIEW Taches;

-- TABLE Travaille
ALTER TABLE Travaille DROP CONSTRAINT FK_TRAVAILLE_REFUTILISATEUR;
DROP TABLE Travaille;

-- TABLE Tache_appartenant_a_liste
ALTER TABLE Tache_appartenant_a_liste DROP CONSTRAINT FK_TACHELISTE_REFTACHE;
ALTER TABLE Tache_appartenant_a_liste DROP CONSTRAINT FK_TACHELISTE_REFLISTE;
DROP TABLE Tache_appartenant_a_liste;

-- Drop TABLE Comporte
ALTER TABLE Comporte DROP CONSTRAINT FK_COMPORTE_REFSCORE_CATEGORIE;
DROP TABLE Comporte;

-- Drop TABLE Contient
ALTER TABLE Contient DROP CONSTRAINT FK_CONTIENT_REFLISTE;
DROP TABLE Contient;

-- TABLE Depend_de
ALTER TABLE Depend_de DROP CONSTRAINT FK_DEPEND_RETACHE1;
ALTER TABLE Depend_de DROP CONSTRAINT FK_DEPEND_RETACHE2;
DROP TABLE Depend_de;

-- TABLE Est_assigne
ALTER TABLE Est_assigne DROP CONSTRAINT FK_EST_ASSIGNE_REFTACHE;
ALTER TABLE Est_assigne DROP CONSTRAINT FK_EST_ASSIGNE_REFUTILISATEUR;
DROP TABLE Est_assigne;

-- TABLE Liste_tache
ALTER TABLE Liste_tache DROP CONSTRAINT FK_LISTETACHE_REFUTILISATEUR;
DROP TABLE Liste_tache;

-- TABLE Score_categorie_tache
DROP TABLE Score_categorie_tache;

-- TABLE Tache_en_cours
ALTER TABLE Tache_en_cours DROP CONSTRAINT FK_TACHE_EN_COURS_REF;
ALTER TABLE Tache_en_cours DROP CONSTRAINT FK_TACHE_EN_COURS_REFUTILISATEUR;
ALTER TABLE Tache_en_cours DROP CONSTRAINT FK_TACHE_EN_COURS_REFPERIODICITE;
DROP TABLE Tache_en_cours;

-- TABLE Tache_fini
ALTER TABLE Tache_fini DROP CONSTRAINT FK_TACHE_FINI_REF;
ALTER TABLE Tache_fini DROP CONSTRAINT FK_TACHE_FINI_REF_REFUTILISATEUR;
ALTER TABLE Tache_fini DROP CONSTRAINT FK_TACHE_FINI_REFPERIODICITE;
DROP TABLE Tache_fini;

-- TABLE Tache
DROP TABLE Tache;

-- TABLE Periodicite
DROP TABLE Periodicite;

DROP TABLE Utilisateur;

COMMIT;