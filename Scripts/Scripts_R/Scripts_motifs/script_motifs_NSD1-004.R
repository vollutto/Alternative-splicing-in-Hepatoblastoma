large1 <- as.data.frame(read.csv("~/Desktop/MN4/Resultados/Resultados/NSD1/NSD1_large.csv", header = F, sep = ","))
View(large1)
colnames(large1) <- c("gene_name", "gene_id", "organism", "motif", "lenght", "experiment", "pubmed", "domain", "goterms", "offset", "exon250", "CDS", "intron")
#m2 <- large1[large1$motif=="UUGGG", ] #Motivo de ESRP2 al cual se une. ESRP2 controla un programa de empalme en adultos en hepatocitos

#Creamos una nueva tabla con el offset separado o duplicando las filas con el ";"
library(tidyr)
library(plyr)
large1["offset"] <- data.frame(lapply(large1["offset"], as.character), stringsAsFactors = FALSE)
large <- separate_rows(large1, offset, convert = TRUE)

#Bucle para poner una nueva columna con el end de cada motivo 
i <- NULL; e <- NULL; ends <- NULL
for (i in 1:dim(large)[1]){
  star = large[i, 10]
  lenght = large[i, 5]
  e = star + lenght
  ends <- c(ends, e)
}

ends <- ldply(ends, data.frame); colnames(ends) <- c("id", "ends"); ends <- ends[, -1]
large <- cbind(large, ends)
View(large)

#Otra forma de hacer el bucle para hacer crear la columna de ends
#tab <- matrix(c("SP1","FOX3",5,4,"13","75;79;17"),2)
#colnames(tab) <- c("protein","length","offset")


#plot(1,1,xlim=c(0,80),ylim=c(0,4),type="n")

#for(i in 1:nrow(large1)){
  
 # protein <- large1[i,1]
  #length <- large1[i,5]
  #offset <- large1[i,10]
  
  #for(j in strsplit(offset,";")[[1]]){
    
   # start <- as.numeric(j)
    #end <- start+as.numeric(length)
    
    #lines(c(start,end),c(i,i), lwd=3)
    #text(start+(end-start)/2, i+0.2, protein, cex=0.4)
  #}	
#}

plot(x = 0:84, y = rep(1,85), main = "Motifs matching the secuence 5'UTR NSD1-004", type = "l", xlim = c(0,85), ylim = c(0,120), lwd = 7, 
     xlab = "Sequence of interest in nucleotides", ylab = "Motifs", axes = FALSE)
lines(x = 25:59, y = rep(1, 35), col = "red", lwd = 7)
rect(xleft = 24.9, ybottom = 1.4, xright = 59.1, ytop = 120, density = NULL, col = colors()[19], border = colors()[36])
#lines(x = 28:31, y = rep(1.5, 4), lwd = 3); text("ERI1", x = 29.5, y = 1.7, font = 2, cex = 0.75)

for(i in 1:nrow((large))){
  start <- as.numeric(large[i, 10])
  end <- as.numeric(large[i, 14])
  gene <- large[i,1]
  
  if (gene == "HNRNPK" | gene == "SRSF3" | gene == "TIA1" | gene == "PCBP2" | gene == "NXF1" | gene == "YBX1" | gene == "SUPV3L1" | gene == "ERI1") {
    lines(c(start, end), c(i+2,i+2), lwd = 3, col = "blue")
    text(end, i + 2,  labels = gene, pos = 4, cex = 0.5, col = "blue")
  }else{
    lines(c(start, end), c(i+2,i+2), lwd = 3)
    text(end, i + 2,  labels = gene, pos = 4, cex = 0.5)
    }
}
  
#lines(c(start, end), c(i+2,i+2), lwd = 3)
#text(end, i + 2,  labels = gene, pos = 4, cex = 0.5)
############################################################ANALYSE MOTIFS OF INTEREST#####################################################

#boxplot(ERI1$TPM ~ ERI1$Type,  main = "TPM Values for the ERI1 Gene in Tumor and Non-tumor Samples", 
 #       xlab = "Sample type", ylab = "TPM values", col = rainbow(1:length(levels(ERI1$Type))))  
#stripchart(ERI1$TPM ~ ERI1$Type, vertical = TRUE, method = "jitter", pch = 19, add = TRUE, col = 1:length(levels(ERI1$Type)))  

#BUCLE PARA SACAR LOS BOXPLOTS
library(ggplot2)
library(viridisLite)
library(viridis)

genes = character(0)
for (fnam in dir("~/Desktop/MN4/Resultados/Resultados/Isoforms/")){
  gen = strsplit(fnam, "_")[[1]][1]
  genes = c(gen, genes)
}
genes = unique(genes)
for (fnam in genes){
  casos = read.table(file.path("~/Desktop/MN4/Resultados/Resultados/Isoforms/", paste(fnam, "_casos.txt", sep = "")))
  controles = read.table(file.path("~/Desktop/MN4/Resultados/Resultados/Isoforms/", paste(fnam, "_controles.txt", sep = "")))
  Type <- rep("Tumor", 34); casos <- cbind(casos, Type); names(casos) <- c("Name", "Lenght", "EffectiveLenght", "TPM", "NumReads", "Type")
  Type <- rep("NonTumor", 32); controles <- cbind(controles, Type); names(controles) <- c("Name", "Lenght", "EffectiveLenght", "TPM", "NumReads", "Type")
  
  png(file=paste("~/Desktop/MN4/Resultados/Resultados/Boxplot_isoform/", fnam, ".png"), width = 800, height = 600)
  id <- rbind(casos, controles)
  res <- t.test(TPM ~ Type, data = id)
  
  p <- ggplot(id, aes(y = TPM, x = Type, fill = Type)) +
    geom_boxplot() +
    scale_fill_brewer(palette = "Dark2") +
    geom_jitter(color = colors()[556], size = 0.9, alpha = 0.9) +
    xlab("Sample Type") +
    ylab("TPM values") +
    ggtitle(paste0("TPM Values for the ", fnam, " Gene in Tumor and Non-Tumor Samples"))+
    geom_text(data = NULL, x = Inf, y = Inf, vjust = 1.1, hjust = 1, label = paste("P-value from Welch's test: ", res$p.value), size = 5, family = "Times New Roman", fontface = 4) + 
    theme_classic()
  print(p)
  dev.off()
}

#list.files("~/PATH/, pattern = "REGULAR EXPRESSION") Esta función hace lo mismo que el ls en BASH. 

#PCBP2


# PCBP2_1 <- as.data.frame(read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/PCBP2_casos.txt", header = FALSE, sep = "\t"))
# PCBP2_2 <-as.data.frame(read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/PCBP2_controles.txt", header = FALSE, sep = "\t"))
# Type <- rep("Tumor", 34); PCBP2_1 <- cbind(PCBP2_1, Type); names(PCBP2_1) <- c("Name", "Lenght", "EffectiveLenght", "TPM", "NumReads", "Type")
# Type <- rep("NonTumor", 32); PCBP2_2 <- cbind(PCBP2_2, Type); names(PCBP2_2) <- c("Name", "Lenght", "EffectiveLenght", "TPM", "NumReads", "Type")
# PCBP2 <- rbind(PCBP2_1, PCBP2_2); View(PCBP2)
# 
# ymax = max(PCBP2$TPM)
# 
# ggplot(PCBP2, aes(y = TPM, x = Type, fill = Type)) +
#   geom_boxplot() +
#   scale_fill_brewer(palette = "Dark2") +
#   geom_jitter(color = colors()[556], size = 0.9, alpha = 0.9) +
#   xlab("Sample Type") +
#   ylab("TPM values") +
#   ggtitle("TPM Values for the PCBP2 Gene in Tumor and Non-Tumor Samples") +
#   geom_text(data = NULL, x = Inf, y = Inf, vjust = 1.1, hjust = 1, label = paste("P-value from Welch's test: ", res$p.value), size = 5, family = "Times New Roman", fontface = 4) + 
#   #annotate(geom = 'text', label = paste("P-value from Welch's test: ", res$p.value), x = Inf, y = Inf, vjust = 1, hjust = 0) +
#   theme_classic()   

#######################################################MOTIFS FULL SEQUENCE###############################################################

full1 <- as.data.frame(read.csv("~/Desktop/MN4/Resultados/Resultados/NSD1/NSD1.csv", header = F, sep = ","))
View(full1)
colnames(full1) <- c("gene_name", "gene_id", "organism", "motif", "lenght", "experiment", "pubmed", "domain", "goterms", "offset", "exon250", "CDS", "intron")

#Creamos una nueva tabla con el offset separado o duplicando las filas con el ";"
library(tidyr)
library(plyr)
full1["offset"] <- data.frame(lapply(full1["offset"], as.character), stringsAsFactors = FALSE)
full <- separate_rows(full1, offset, convert = TRUE)

#Bucle para poner una nueva columna con el end de cada motivo 
i <- NULL; e <- NULL; ends <- NULL
for (i in 1:dim(full)[1]){
  star = full[i, 10]
  lenght = full[i, 5]
  e = star + lenght
  ends <- c(ends, e)
}

ends <- ldply(ends, data.frame); colnames(ends) <- c("id", "ends"); ends <- ends[, -1]
full <- cbind(full, ends)
View(full)

plot.new()
plot(x = 0:634, y = rep(1,635), main = "Motifs matching the secuence", type = "l", xlim = c(0,634), ylim = c(0,1200), lwd = 7, 
     xlab = "Sequence of interest in nucleotides", ylab = "Motifs", axes = FALSE)
lines(x = 300:334, y = rep(1, 35), col = "red", lwd = 7)
lines(x = 498:634, y = rep(1,137), col = colors()[93], lwd = 7)
rect(xleft = 299.9, ybottom = 7, xright = 334.1, ytop = 1200, density = NULL, col = colors()[19], border = colors()[36])
rect(xleft = 497.9, ybottom = 7, xright = 635.1, ytop = 1200, density = NULL, col = colors()[19], border = colors()[36])


for(i in 1:nrow((full))){
  
  start <- as.numeric(full[i, 10])
  end <- as.numeric(full[i, 14])
  gene <- full[i,1]
  
  if (gene == "HNRNPK" | gene == "SRSF3" | gene == "TIA1" | gene == "PCBP2" | gene == "NXF1" | gene == "YBX1") {
    lines(c(start, end), c(i+2,i+2), lwd = 3, col = "blue")
    text(end, i + 2,  labels = gene, pos = 4, cex = 0.5, col = "blue")
  }#else{
  # lines(c(start, end), c(i+2,i+2), lwd = 3)
  # text(end, i + 2,  labels = gene, pos = 4, cex = 0.5)
  # }
}
