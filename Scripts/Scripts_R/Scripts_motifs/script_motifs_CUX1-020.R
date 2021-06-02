large1 <- as.data.frame(read.csv("~/Desktop/MN4/Resultados/Resultados/CUX1/CUX1-020_large.csv", header = F, sep = ","))
View(large1)
colnames(large1) <- c("gene_name", "gene_id", "organism", "motif", "lenght", "experiment", "pubmed", "domain", "goterms", "offset", "exon250", "CDS", "intron")

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

plot(x = 0:178, y = rep(1,179), main = "Motifs matching the secuence 5'UTR CUX1-020", type = "l", xlim = c(0,179), ylim = c(0,260), lwd = 7, 
     xlab = "Sequence of interest in nucleotides", ylab = "Motifs", axes = FALSE)
lines(x = 60:118, y = rep(1, 59), col = "red", lwd = 7)
rect(xleft = 59.9, ybottom = 2, xright = 118.1, ytop = 260, density = NULL, col = colors()[19], border = colors()[36])

for(i in 1:nrow((large))){
  start <- as.numeric(large[i, 10])
  end <- as.numeric(large[i, 14])
  gene <- large[i,1]
  
  if (gene == "TRA2B" | gene == "SRSF3" | gene == "SRSF10" | gene == "SAMD4A" | gene == "RBM6" | gene == "PHAX" | gene == "CMTR1") {
     lines(c(start, end), c(i+2,i+2), lwd = 3, col = "blue")
     text(end, i + 2,  labels = gene, pos = 4, cex = 0.5, col = "blue")
  }else{
     lines(c(start, end), c(i+2,i+2), lwd = 3)
     text(end, i + 2,  labels = gene, pos = 4, cex = 0.5)
  }
}