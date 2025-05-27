-- Pour chaque table, on crée une table temporaire sans contraintes (structure identique)
CREATE TEMP TABLE tmp_chromosome AS SELECT * FROM Chromosome WITH NO DATA;
CREATE TEMP TABLE tmp_gene AS SELECT * FROM Gene WITH NO DATA;
CREATE TEMP TABLE tmp_stg AS SELECT * FROM Se_trouve_gene WITH NO DATA;
CREATE TEMP TABLE tmp_copie AS SELECT * FROM Copie WITH NO DATA;
CREATE TEMP TABLE tmp_stc AS SELECT * FROM Se_trouve_copie WITH NO DATA;
CREATE TEMP TABLE tmp_famille AS SELECT * FROM Famille_ET WITH NO DATA;
CREATE TEMP TABLE tmp_appartient AS SELECT * FROM Appartient WITH NO DATA;

-- Puis on importe les TSV dans ces tables temporaires
\copy tmp_chromosome FROM 'Projet Bio-Info/BDD/TSV/chromosome.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
\copy tmp_gene FROM 'Projet Bio-Info/BDD/TSV/gene.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
\copy tmp_stg FROM 'Projet Bio-Info/BDD/TSV/stg.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
\copy tmp_copie FROM 'Projet Bio-Info/BDD/TSV/copie.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
\copy tmp_stc FROM 'Projet Bio-Info/BDD/TSV/stc.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
\copy tmp_famille FROM 'Projet Bio-Info/BDD/TSV/famille.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
\copy tmp_appartient FROM 'Projet Bio-Info/BDD/TSV/appartient.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);

-- Ensuite on insère dans les vraies tables avec gestion des doublons via ON CONFLICT DO NOTHING

INSERT INTO Chromosome (numero, genome, taille)
SELECT numero, genome, taille FROM tmp_chromosome
ON CONFLICT (numero) DO NOTHING;

INSERT INTO Gene (accession, fonction, taille)
SELECT accession, fonction, taille FROM tmp_gene
ON CONFLICT (accession) DO NOTHING;

INSERT INTO Se_trouve_gene (accession_gene, numero_chromosome, debut, fin, orientation)
SELECT accession_gene, numero_chromosome, debut, fin, orientation FROM tmp_stg
ON CONFLICT (accession_gene, numero_chromosome) DO NOTHING;

INSERT INTO Copie (accession, fonctionnelle, taille, reference)
SELECT accession, fonctionnelle, taille, reference FROM tmp_copie
ON CONFLICT (accession) DO NOTHING;

INSERT INTO Se_trouve_copie (accession_copie, numero_chromosome, debut, fin, orientation)
SELECT accession_copie, numero_chromosome, debut, fin, orientation FROM tmp_stc
ON CONFLICT (accession_copie, numero_chromosome) DO NOTHING;

INSERT INTO Famille_ET (nom, nombre_et, classe)
SELECT nom, nombre_et, classe FROM tmp_famille
ON CONFLICT (nom) DO NOTHING;

INSERT INTO Appartient (accession_copie, nom_famille)
SELECT accession_copie, nom_famille FROM tmp_appartient
ON CONFLICT (accession_copie) DO NOTHING;

\copy Analyse_Blast(accession_copie, pourcentage_id, nombre_hits, taille_analyse) FROM 'Projet Bio-Info/BDD/TSV/analyse_blast.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER true);
