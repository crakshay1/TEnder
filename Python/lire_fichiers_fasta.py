def lire_fasta(fichier: str) -> str:
    filein = open(fichier,"r")
    seq = ""
    for line in filein:
        if line[0]!=">":
            seq = seq+line[:-1]
    return seq
#[:-1] pour lire toute la ligne sauf le dernier caractère (le retour à la ligne)
