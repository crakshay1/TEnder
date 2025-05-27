#!/bin/bash
		# Pour remplir le TSV Blast
		
echo -e "accession_copie\tpourcentage_id\tnombre_hits\ttaille_analyse" > BDD/TSV/analyse_blast.tsv
for file in BDD/Resultats/*.txt; do
    awk '!/^#/ {print $2 "\t" $3 "\t1\t" $4}' "$file" >> BDD/TSV/analyse_blast.tsv
done

		# Pour remplir le TSV se_trouve_copie
# accession_copie	numero_chromosome	debut	fin	orientation
grep ">" TAIR10_TE.fas > BDD/TSV/temp1.txt
sed 's/^>//' BDD/TSV/temp1.txt > BDD/TSV/temp.txt
awk -F'|' '{print $1 "\t" substr($1,3,1) "\t" $3 "\t" $4 "\t" $2}' BDD/TSV/temp.txt >> BDD/TSV/stc.tsv


		# Pour remplir le TSV copie
# accession	fonctionnelle	taille	reference
awk -F'|' '{print $1 "\tFALSE\t" $7 "\t" "." }' BDD/TSV/temp.txt >> BDD/TSV/copie.tsv


		# Pour remplir le TSV Gene
# accession	fonction	taille
# Idendifiant_prot	Identifiant_gene	taille_prot	Chromosome	debut	fin	orientation	info_gene	description
awk 'NR > 1 {print $2 "\t" $9 "\t" ($6 - $5)}' TAIR10_genes_positions.txt >> BDD/TSV/gene.tsv

		# Pour remplir le TSV se_trouve_gene
# accession_gene	numero_chromosome	debut	fin	orientation
# Idendifiant_prot	Identifiant_gene	taille_prot	Chromosome	debut	fin	orientation	info_gene	description
awk 'NR > 1 {print $2 "\t" $4 "\t" $5 "\t" $6 "\t" $7}' TAIR10_genes_positions.txt >> BDD/TSV/stg.tsv

		# Pour remplir le TSV famille
# nom	nombre_et	classe
awk 'NR > 1 {print "\t" $5 "\t" $6}' TAIR10_Transposable_Elements.txt | sort | uniq -c > test.txt
awk '{print $2 "\t" $1 "\t" $3}' test.txt >> BDD/TSV/famille.tsv

		# Pour remplir le TSV appartient.tsv
# accession_copie	nom_famille
# AT5TE18460|-|5111364|5111593|BRODYAGA2|DNA/MuDR|230 bp
awk -F'|' '{print $1 "\t" $5}' BDD/TSV/temp.txt >> BDD/TSV/appartient.tsv


		# Pour remplir le TSV chromosome.tsv
# Légèrement casse-tête, je vais voir sur GBOT hihi
# numero 	genome	taille
awk '{print $1 "\tArabidopsis Thaliana\t" $2}' BDD/TSV/loubard.txt >> BDD/TSV/chromosome.tsv



