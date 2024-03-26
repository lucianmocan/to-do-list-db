CREATE TABLE Utilisateur (
  PRIMARY KEY (ref_utilisateur),
  ref_utilisateur    INT NOT NULL,
  login              VARCHAR(10),
  mot_de_passe       VARCHAR(255),
  score              INT DEFAULT 0,
  nom                VARCHAR(255),
  prenom             VARCHAR(255),
  adresse            VARCHAR(511),
  pays               VARCHAR(100),
  date_de_naissance  DATE,
  date_d_inscription DATE,
  nom_programme      VARCHAR(255) NULL,
  game_level         INT DEFAULT 0,
  UNIQUE (login),
  CONSTRAINT check_fname_lname_format CHECK (
        REGEXP_LIKE(nom, '^[A-Za-zÀ-ÿ ]+$') AND REGEXP_LIKE(prenom, '^[A-Za-zÀ-ÿ ]+$'))
);

CREATE TABLE Travaille (
  PRIMARY KEY (nom_projet, ref_utilisateur),
  nom_projet      VARCHAR(255) NOT NULL,
  ref_utilisateur INT NOT NULL,
  CONSTRAINT FK_TRAVAILLE_REFUTILISATEUR FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur (ref_utilisateur)
);

CREATE TABLE Periodicite (
  PRIMARY KEY (ref_periodicite),
  ref_periodicite INT,
  date_debut TIMESTAMP NOT NULL,
  date_fin   TIMESTAMP,
  periode    INTERVAL DAY TO SECOND
);

CREATE TABLE Score_categorie_tache (
  PRIMARY KEY (ref_score_categorie_tache),
  ref_score_categorie_tache VARCHAR(255) NOT NULL,
  termine                   VARCHAR(1),
  score                     INT,
  nom_categorie             VARCHAR(255) NOT NULL
);

CREATE TABLE Comporte (
  PRIMARY KEY (nom_programme, ref_score_categorie_tache),
  nom_programme             VARCHAR(255) NOT NULL,
  ref_score_categorie_tache VARCHAR(255) NOT NULL,
  CONSTRAINT FK_COMPORTE_REFSCORE_CATEGORIE FOREIGN KEY (ref_score_categorie_tache) REFERENCES Score_categorie_tache (ref_score_categorie_tache)
);

CREATE TABLE Liste_tache (
  PRIMARY KEY (ref_liste),
  ref_liste       INT NOT NULL,
  nom_categorie   VARCHAR(255) NOT NULL,
  ref_utilisateur INT NOT NULL,
  CONSTRAINT FK_LISTETACHE_REFUTILISATEUR FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur (ref_utilisateur)
);

CREATE TABLE Contient (
  PRIMARY KEY (nom_projet, ref_liste),
  nom_projet VARCHAR(255) NOT NULL,
  ref_liste  INT NOT NULL,
  CONSTRAINT FK_CONTIENT_REFLISTE FOREIGN KEY (ref_liste) REFERENCES Liste_tache (ref_liste)
);

CREATE TABLE Tache (
  PRIMARY KEY (ref_tache),
  ref_tache        INT NOT NULL
);


CREATE TABLE Tache_appartenant_a_liste (
  PRIMARY KEY (ref_liste, ref_tache),
  ref_liste INT NOT NULL,
  ref_tache INT NOT NULL,
  CONSTRAINT FK_TACHELISTE_REFTACHE FOREIGN KEY (ref_tache) REFERENCES Tache (ref_tache),
  CONSTRAINT FK_TACHELISTE_REFLISTE FOREIGN KEY (ref_liste) REFERENCES Liste_tache (ref_liste)
);

CREATE TABLE Depend_de (
  PRIMARY KEY (ref_tache_1, ref_tache_2),
  ref_tache_1 INT NOT NULL,
  ref_tache_2 INT NOT NULL,
  CONSTRAINT FK_DEPEND_RETACHE1 FOREIGN KEY (ref_tache_2) REFERENCES Tache (ref_tache),
  CONSTRAINT FK_DEPEND_RETACHE2 FOREIGN KEY (ref_tache_1) REFERENCES Tache (ref_tache)
);

CREATE TABLE Est_assigne (
  PRIMARY KEY (ref_utilisateur, ref_tache),
  ref_utilisateur INT NOT NULL,
  ref_tache       INT NOT NULL,
  CONSTRAINT FK_EST_ASSIGNE_REFTACHE FOREIGN KEY (ref_tache) REFERENCES Tache (ref_tache),
  CONSTRAINT FK_EST_ASSIGNE_REFUTILISATEUR FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur (ref_utilisateur)
);


CREATE TABLE Tache_en_cours (
  PRIMARY KEY (ref_tache),
  ref_tache        INT NOT NULL,
  intitule         VARCHAR(255),
  description      VARCHAR(4000),
  priorite         SMALLINT,
  url              VARCHAR(2000),
  date_d_echeance  TIMESTAMP,
  statut           VARCHAR(8),
  nom_categorie    VARCHAR(255) NOT NULL,
  ref_periodicite  INTEGER NOT NULL,
  ref_utilisateur  INT NOT NULL,
  date_realisation TIMESTAMP NULL,
  CONSTRAINT FK_TACHE_EN_COURS_REF FOREIGN KEY (ref_tache) REFERENCES Tache (ref_tache),
  CONSTRAINT FK_TACHE_EN_COURS_REFUTILISATEUR FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur (ref_utilisateur),
  CONSTRAINT FK_TACHE_EN_COURS_REFPERIODICITE FOREIGN KEY (ref_periodicite) REFERENCES Periodicite (ref_periodicite)
);

CREATE TABLE Tache_fini (
  PRIMARY KEY (ref_tache),
  ref_tache        INT NOT NULL,
  intitule         VARCHAR(255),
  description      VARCHAR(4000),
  priorite         SMALLINT,
  url              VARCHAR(2000),
  date_d_echeance  TIMESTAMP,
  statut           VARCHAR(8),
  nom_categorie    VARCHAR(255) NOT NULL,
  ref_periodicite  INTEGER NOT NULL,
  ref_utilisateur  INT NOT NULL,
  date_realisation TIMESTAMP NULL,
  CONSTRAINT FK_TACHE_FINI_REF FOREIGN KEY (ref_tache) REFERENCES Tache (ref_tache),
  CONSTRAINT FK_TACHE_FINI_REF_REFUTILISATEUR FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur (ref_utilisateur),
  CONSTRAINT FK_TACHE_FINI_REFPERIODICITE FOREIGN KEY (ref_periodicite) REFERENCES Periodicite (ref_periodicite)
);



CREATE VIEW Taches AS
  SELECT * FROM Tache_fini
    UNION
  SELECT * FROM Tache_en_cours;


COMMIT;