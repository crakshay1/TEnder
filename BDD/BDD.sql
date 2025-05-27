-- Pour notre table Chromosome
CREATE TABLE IF NOT EXISTS Chromosome (
    numero VARCHAR(2) PRIMARY KEY,
    genome TEXT NOT NULL,
    taille INT NOT NULL
);

-- Pour notre table Gene
CREATE TABLE IF NOT EXISTS Gene (
    accession VARCHAR(20) PRIMARY KEY,
    fonction TEXT NOT NULL,
    taille INT NOT NULL
);

-- Pour notre table Se_trouve_gene 
CREATE TABLE IF NOT EXISTS Se_trouve_gene (
    accession_gene VARCHAR(20) NOT NULL,
    numero_chromosome VARCHAR(2) NOT NULL,
    debut INT NOT NULL,
    fin INT NOT NULL,
    orientation VARCHAR(2) NOT NULL,
    CONSTRAINT pk_se_trouve_gene PRIMARY KEY (accession_gene, numero_chromosome),
    CONSTRAINT fk_stg_gene FOREIGN KEY (accession_gene) REFERENCES Gene(accession),
    CONSTRAINT fk_stg_chr FOREIGN KEY (numero_chromosome) REFERENCES Chromosome(numero)
);

-- Pour notre table Copies
CREATE TABLE IF NOT EXISTS Copie (
    accession VARCHAR(20) PRIMARY KEY,
    fonctionnelle BOOLEAN NOT NULL,
    taille INT NOT NULL,
    reference TEXT
);

-- Pour notre table Se_trouve_copie
CREATE TABLE IF NOT EXISTS Se_trouve_copie (
    accession_copie VARCHAR(20) NOT NULL,
    numero_chromosome VARCHAR(2) NOT NULL,
    debut INT NOT NULL,
    fin INT NOT NULL,
    orientation VARCHAR(2) NOT NULL,
    CONSTRAINT pk_se_trouve_copie PRIMARY KEY (accession_copie, numero_chromosome),
    CONSTRAINT fk_stc_copie FOREIGN KEY (accession_copie) REFERENCES Copie(accession),
    CONSTRAINT fk_stc_chr FOREIGN KEY (numero_chromosome) REFERENCES Chromosome(numero)
);

-- Pour notre table Famille_ET
CREATE TABLE IF NOT EXISTS Famille_ET (
    nom VARCHAR(50) PRIMARY KEY,
    nombre_et INT NOT NULL,
    classe VARCHAR(50) NOT NULL
);

-- Pour notre table Appartient
CREATE TABLE IF NOT EXISTS Appartient (
    accession_copie VARCHAR(20) PRIMARY KEY,
    nom_famille VARCHAR(50) NOT NULL,
    CONSTRAINT fk_appartient_copie FOREIGN KEY (accession_copie) REFERENCES Copie(accession),
    CONSTRAINT fk_appartient_famille FOREIGN KEY (nom_famille) REFERENCES Famille_ET(nom)
);

-- Pour notre table Analyse_Blast
CREATE TABLE IF NOT EXISTS Analyse_Blast (
    id SERIAL PRIMARY KEY,
    accession_copie VARCHAR(20) NOT NULL,
    pourcentage_id FLOAT NOT NULL,
    nombre_hits INT NOT NULL,
    taille_analyse INT NOT NULL,
    CONSTRAINT fk_blast_copie FOREIGN KEY (accession_copie) REFERENCES Copie(accession)
);


