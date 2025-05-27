import re
import lire_fichiers_fasta
filein = open("META1-LTR_embl.txt","r")
seq = ""

### On récupère uniquement les lignes qui contiennent la séquence
for ligne in filein:
    if ligne[0:2]=="  ":
        seq += ligne.upper()

### On élimine les espaces et chiffres qui se trouveraient sur la ligne
seq = seq.replace(" ", "")
seq = re.sub("[0-9]*", "", seq)
seq = ">sp|\n" + seq
print(seq)
fileout = open("META1-LTR_fas.txt", "w")
fileout.write(seq)
fileout.close()

### Afficher la séquence sans format ni retour à la ligne :
fullseq = print("Séquence pure sans formatage :\n"+lire_fichiers_fasta.lire_fasta("META1-LTR_fas.txt"))