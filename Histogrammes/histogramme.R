pdf("HistoPB.pdf")

# grep ">" TAIR10_TE.fas |cut -d "|" -f 1,5,7 > donnees_histo.txt
database <- read.delim("/home/crakshay/Projet Bio-Info/donnees_histo.txt", sep = "|", header = FALSE)
attach(database)

endo <- database[V2 == "ENDOVIR1",]
nb_endo <- endo[,3]
new_endo <- gsub("bp","",unlist(nb_endo))
nb_endo_numeric <- as.numeric(unlist(new_endo))
hist(nb_endo_numeric, ylab = "Nb Copies ENDOVIR1", xlab = "Taille de la copie (PB)",
     main = "Distribution de la taille des copies ENDOVIR1")

at1 <- database[V2 == "ATLINE1_3A",]
nb_at1 <- at1[,3]
new_at1 <- gsub("bp","",unlist(nb_at1))
nb_at1_numeric <- as.numeric(unlist(new_at1))
hist(nb_at1_numeric,, ylab = "Nb Copies ATLINE1_3A", xlab = "Taille de la copie (PB)",
     main = "Distribution de la taille des copies ATLINE1_3A")

vandal <- database[V2 == "VANDAL11",]
nb_vandal <- vandal[,3]
new_vandal <- gsub("bp","",unlist(nb_vandal))
nb_vandal_numeric <- as.numeric(unlist(new_vandal))
hist(nb_vandal_numeric, ylab = "Nb Copies VANDAL11", xlab = "Taille de la copie (PB)",
     main = "Distribution de la taille des copies VANDAL11")

at3 <- database[V2 == "ATLINEIII",]
nb_at3 <- at3[,3]
new_at3 <- gsub("bp","",unlist(nb_at3))
nb_at3_numeric <- as.numeric(unlist(new_at3))
hist(nb_at3_numeric, ylab = "Nb Copies ATLINEIII", xlab = "Taille de la copie (PB)",
     main = "Distribution de la taille des copies ATLINEIII")

simple <- database[V2 == "SIMPLEGUY1",]
nb_simple <- simple[,3]
new_simple <- gsub("bp","",unlist(nb_at1))
nb_simple_numeric <- as.numeric(unlist(new_simple))
hist(nb_simple_numeric, ylab = "Nb Copies SIMPLEGUY1", xlab = "Taille de la copie (PB)",
     main = "Distribution de la taille des copies SIMPLEGUY1")

meta <- database[V2 == "META1",]
nb_meta <- meta[,3]
new_meta <- gsub("bp","",unlist(nb_meta))
nb_meta_numeric <- as.numeric(unlist(new_meta))
hist(nb_meta_numeric, ylab = "Nb Copies META1", xlab = "Taille de la copie (PB)",
     main = "Distribution de la taille des copies META1")

dev.off()