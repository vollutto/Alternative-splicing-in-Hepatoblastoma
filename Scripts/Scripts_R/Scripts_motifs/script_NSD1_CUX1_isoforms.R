#################################################################NSD1_casos########################################################################
a = 0.1 #Creamos una variable 

#Alternativa
nsd1_001_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CASOS/NSD1_casos-001.txt", header = TRUE, sep = "\t")
nsd1_001 <- as.data.frame(nsd1_001_1[, 4])
nsd1_001_up = as.data.frame(colSums(nsd1_001 > a, na.rm = TRUE, dims = 1)) 
nsd1_001_down = as.data.frame(colSums(nsd1_001 <= a, na.rm = TRUE, dims = 1))

nsd1_c <- cbind(nsd1_001_up, nsd1_001_down)


#Principal
nsd1_004_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CASOS/NSD1_casos-004.txt", header = TRUE, sep = "\t")
nsd1_004 <- as.data.frame(nsd1_004_1[, 4])
nsd1_004_up = as.data.frame(colSums(nsd1_004 > a, na.rm = TRUE, dims = 1))
nsd1_004_down = as.data.frame(colSums(nsd1_004 <= a, na.rm = TRUE, dims = 1))

nsd1_c <- cbind(nsd1_c, nsd1_004_up, nsd1_004_down)

colnames(nsd1_c) <- c("NSD1-001_up", "NSD1-001_down", "NSD1-004_up", "NSD1-004_down"); rownames(nsd1_c) <- "NSD1-004-001" #Cambiar los nombres a las columnas

#Calcular pvaloe con el fisher test
fila1 = nsd1_c[, c(1,3)]; names(fila1) <- c("NSD1-001", "NSD1-004")
fila2 = nsd1_c[, c(2,4)]; names(fila2) <- c("NSD1-001", "NSD1-004")
ft = rbind(fila1, fila2)
p.value = fisher.test(ft, alternative = "less")$p.value
nsd1_c <- cbind(nsd1_c, p.value)
View(nsd1_c)

##################################################################NSD1_controles####################################################################
#Alternativa
nsd1_001_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CONTROLES/NSD1_controles-001.txt", header = TRUE, sep = "\t")
nsd1_001 <- as.data.frame(nsd1_001_1[, 4])
nsd1_001_up = as.data.frame(colSums(nsd1_001 > a, na.rm = TRUE, dims = 1)) 
nsd1_001_down = as.data.frame(colSums(nsd1_001 <= a, na.rm = TRUE, dims = 1))

nsd1_ct <- cbind(nsd1_001_up, nsd1_001_down)


#Principal
nsd1_004_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CONTROLES/NSD1_controles-004.txt", header = TRUE, sep = "\t")
nsd1_004 <- as.data.frame(nsd1_004_1[, 4])
nsd1_004_up = as.data.frame(colSums(nsd1_004 > a, na.rm = TRUE, dims = 1))
nsd1_004_down = as.data.frame(colSums(nsd1_004 <= a, na.rm = TRUE, dims = 1))

nsd1_ct <- cbind(nsd1_ct, nsd1_004_up, nsd1_004_down)

colnames(nsd1_ct) <- c("NSD1-001_up", "NSD1-001_down", "NSD1-004_up", "NSD1-004_down"); rownames(nsd1_ct) <- "NSD1-004-001" #Cambiar los nombres a las columnas

#Calcular pvaloe con el fisher test
fila1 = nsd1_ct[, c(1,3)]; names(fila1) <- c("NSD1-001", "NSD1-004")
fila2 = nsd1_ct[, c(2,4)]; names(fila2) <- c("NSD1-001", "NSD1-004")
ft = rbind(fila1, fila2)
p.value = fisher.test(ft, alternative = "less")$p.value
nsd1_ct <- cbind(nsd1_ct, p.value)
View(nsd1_ct)
##################################################################CUX1_casos########################################################################
#Principal
cux1_020_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CASOS/CUX1_casos-020.txt", header = TRUE, sep = "\t")
cux1_020 <- as.data.frame(cux1_020_1[, 4])
cux1_020_up = as.data.frame(colSums(cux1_020 > a, na.rm = TRUE, dims = 1)) 
cux1_020_down = as.data.frame(colSums(cux1_020 <= a, na.rm = TRUE, dims = 1))

cux1_c <- cbind(cux1_020_up, cux1_020_down)


#Principal
cux1_004_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CASOS/CUX1_casos-004.txt", header = TRUE, sep = "\t")
cux1_004 <- as.data.frame(cux1_004_1[, 4])
cux1_004_up = as.data.frame(colSums(cux1_004 > a, na.rm = TRUE, dims = 1))
cux1_004_down = as.data.frame(colSums(cux1_004 <= a, na.rm = TRUE, dims = 1))

cux1_c <- cbind(cux1_c, cux1_004_up, cux1_004_down)

colnames(cux1_c) <- c("CUX1-020_up", "CUX1-020_down", "CUX1-004_up", "CUX1-004_down"); rownames(cux1_c) <- "CUX1-020-004" #Cambiar los nombres a las columnas

#Calcular pvaloe con el fisher test
fila1 = cux1_c[, c(3,1)]; names(fila1) <- c("CUX1-004", "CUX1-020")
fila2 = cux1_c[, c(4,2)]; names(fila2) <- c("CUX1-004", "CUX1-020")
ft = rbind(fila1, fila2)
p.value = fisher.test(ft, alternative = "less")$p.value
cux1_c <- cbind(cux1_c, p.value)
View(cux1_c)

#################################################################CUX1_controles###########################################################################
#Alternativa
cux1_020_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CONTROLES/CUX1_controles-020.txt", header = TRUE, sep = "\t")
cux1_020 <- as.data.frame(cux1_020_1[, 4])
cux1_020_up = as.data.frame(colSums(cux1_020 > a, na.rm = TRUE, dims = 1)) 
cux1_020_down = as.data.frame(colSums(cux1_020 <= a, na.rm = TRUE, dims = 1))

cux1_ct <- cbind(cux1_020_up, cux1_020_down)


#Principal
cux1_004_1 <- read.delim("~/Desktop/MN4/Resultados/Resultados/Isoforms/CUX1_NSD1/CONTROLES/CUX1_controles-004.txt", header = TRUE, sep = "\t")
cux1_004 <- as.data.frame(cux1_004_1[, 4])
cux1_004_up = as.data.frame(colSums(cux1_004 > a, na.rm = TRUE, dims = 1))
cux1_004_down = as.data.frame(colSums(cux1_004 <= a, na.rm = TRUE, dims = 1))

cux1_ct <- cbind(cux1_ct, cux1_004_up, cux1_004_down)

colnames(cux1_ct) <- c("CUX1-020_up", "CUX1-020_down", "CUX1-004_up", "CUX1-004_down"); rownames(cux1_ct) <- "CUX1-020-004" #Cambiar los nombres a las columnas

#Calcular pvaloe con el fisher test
fila1 = cux1_ct[, c(3,1)]; names(fila1) <- c("CUX1-004", "CUX1-020")
fila2 = cux1_ct[, c(4,2)]; names(fila2) <- c("CUX1-004", "CUX1-020")
ft = rbind(fila1, fila2)
p.value = fisher.test(ft, alternative = "less")$p.value
cux1_ct <- cbind(cux1_ct, p.value)
View(cux1_ct)