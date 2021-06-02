##############################################################CASOS Y CONTROLES MERGED###################################################################

#Crear una variable threshold
a = 0.95

#CASOS

casos_merge <- read.delim("~/Desktop/MN4/Resultados/Resultados/PSI/casos_merge_events.psi", header = TRUE, sep = "\t", row.names = 1)
head(casos)
dim(casos)

casos_up = as.data.frame(rowSums(casos_merge > a, na.rm = TRUE)) #Contar cuantas muestras están por encima de 0.85 en cada evento
casos_down = as.data.frame(rowSums(casos_merge < a, na.rm = TRUE)) #Contar cuantas muestras están por debajo de 0.85 en cada evento
casos_nan = as.data.frame(rowSums(casos_merge == "NaN")) #Contar cuantos nan y na hay por cada evento

psimerge <- cbind(casos_up, casos_down, casos_nan) #Guardar los datos en una nueva tabla 

#CONTROLES

controles_merge <- read.delim("~/Desktop/MN4/Resultados/Resultados/PSI/controles_merge_events.psi", header = TRUE, sep = "\t", row.names = 1)
head(controles)
dim(controles)

controles_up = as.data.frame(rowSums(controles_merge > a, na.rm = TRUE)) #Contar cuantas muestras están por encima de 0.85 en cada evento
controles_down = as.data.frame(rowSums(controles_merge < a, na.rm = TRUE)) #Contar cuantas muestras están por debajo de 0.85 en cada evento
controles_nan = as.data.frame(rowSums(controles_merge == "NaN")) #Contar cuantos nan y na hay por cada evento

psimerge  <- cbind(psimerge, controles_up, controles_down, controles_nan) #Guardar las tres nuevas columnas en la tabla de los casos

#Extraer del data frame los índices de las filas y quedarse solamente con el tipo de evento, unirlo en una columna nueva al daata frame y ordenar las columnas
eventid <- sub(".*;", "", rownames(psimerge)) #; psitable$gene <- sub(";.*", "", rownames(psitable)) En este caso si queremos crear una columna con los id de los genes
psimerge$event <- sub(":.*", "", eventid)
psimerge <- psimerge[ , c(7, 1, 2, 3, 4, 5, 6)] #Ordenamos las columnas para que el evento esté en la segunda columna

colnames(psimerge) <- c("Event", "casos_up", "casos_down", "casos=nan", "controles_up", "controles_down", "controles=nan") #Cambiar los nombres a las columnas

#Calcular el p-valor para cada fila sin tener en cuenta los "NaN"

i <- NULL; p.value <- NULL
for(i in 1:dim(psimerge)[1]) 
{
  fila1 = psimerge[i, c(2,5)]
  fila2 = psimerge[i, c(3,6)]
  names(fila1) <- c("casos", "controles")
  names(fila2) <- c("casos", "controles")
  ha = rbind(fila1, fila2)
  r = fisher.test(ha)$p.value
  p.value <- c(p.value, r)
}
p.value

psimerge <- cbind(psimerge, p.value) #Guardar el vector p.value de cada evento como una columna nueva del dataframe psitable

#Ajustar el pvalor

psimerge$pval.adjust <- p.adjust(psimerge$p.value, method="BH")

#Visualizar la tabla

View(psimerge)

#Visualizar los pvalores ajustados menor que 0.05

se <- psimerge[psimerge$pval.adjust < 0.05, ] #Guardar los eventos significativos con un threshold de 0.95 en una variable 
View(se) #Visualizar la tabla con solo los eventos significativos 

#Guardar la tabla en un fichero

write.table(psimerge, file = "~/Desktop/MN4/Resultados/Resultados/casos_vs_controles_vs_na_0.95_merge.txt", sep = "\t", col.names = TRUE, row.names = TRUE)

#########################################################HIPERGEOMETRÍA##################################################################

m <- NULL #Variable para todo el número de casos con un PSI mayor del threshold para todos los eventos 
N <- NULL #Variable para todo el número de casos y controles para todos los eventos 
e <- NULL 
ev_names = c("SE", "MX", "A5", "A3", "RI", "AF", "AL") #Concatenamos todas los eventos en una variable para utilizarlo en los bucles

m <- colSums(psimerge[, 2, drop = FALSE]) #Guardamos en una variable todo los casos con el PSI mayor del treshold de nuestra tabla
N <- as.data.frame(colSums(psimerge[, c(2, 3, 5, 6), drop = FALSE])) #Lo mismo pero con los controles
N <- colSums(N[, 1, drop = FALSE])
n <- N-m #Guardamos en una variable la resta del numero total de casos y controles los casos que tienen un PSI mayor del threshold para todos los eventos

#En un bucle obtenemos la suma de todos los casos con el PSI mayor del threshold para cada evento
for (e in ev_names){
  q <- colSums(psimerge[psimerge$Event==e, 2, drop = FALSE]) #Guardamos en la variable q la suma de los casos con el PSI mayor del threshold para cada evento 
  name1 = paste("q", e, sep = "") #En una variable le asignamos a cada evento el nombre "q" por evento: "SE"..., obteniendo "qSE"..
  assign(name1, q) #Le asignamos a cada evento ("qSE"...) el valor de "q", es decir, de la suma de los casos...
}

#En un bucle obtenemos la suma numérica de cada columna de los casos y controles por encima y debajo del threshold para cada evento
for (e in ev_names){
  k <- as.data.frame(colSums(psimerge[psimerge$Event==e, c(2, 3, 5, 6), drop = FALSE]))
  k <- colSums(k[, 1, drop = FALSE]) #Guardamos en la variable k la suma total de las 4 columnas para cada evento 
  name2 = paste("k", e, sep = "") #En una variable le asignammos a cada evento el nombre "k" por evento: "SE"..., obteniendo "kSE", "kMX"...
  assign(name2, k) #Le asignamos a cada evento ("kSE"...) el valor de su "k", es decir, de la suma total de las 4 columnas por cada evento...
}

#Crear una tabla (data frame) para el método phyper con todas las variables 
phymerge <- data.frame(
  "event" = ev_names, 
  "m" = rep(m, 7), 
  "n" = rep(n, 7),
  "k" = c(kSE, kMX, kA5, kA3, kRI, kAF, kAL),
  "q" = c(qSE, qMX, qA5, qA3, qRI, qAF, qAL)
)

rownames(phymerge) <- NULL #Le quitamos el índice de las filas

View(phymerge) #Visualizar la tabla phy

#Realizar el test de phyper para cada evento en un bucle 
o <- NULL; pval <- NULL

for (o in 1:dim(phymerge)[1]) {
  k = phymerge[o, 4]
  q = phymerge[o, 5]
  t <-  phyper(q, m, n, k, lower.tail = FALSE, log.p = FALSE)
  pval <- c(pval, t)
}

phymerge <- cbind(phymerge, pval) #Añadir el resultado del test en la tabla 
phymerge$pval.adjust <- p.adjust(phymerge$pval, method="BH")
View(phymerge)
sigphymerge <- phymerge[phymerge$pval.adjust < 0.05, ]
write.table(phymerge, file = "~/Desktop/MN4/Resultados/Resultados/enrichment_merge_events.txt", sep = "\t", col.names = TRUE, row.names = TRUE)

#######################################################GROUP BOXPLOT Y VENNDIAGRAM#########################################################

#Vamos a contar por evento cuantos controles_up y casos_up hay
ev_names = c("SE", "MX", "A5", "A3", "RI", "AF", "AL"); e <- NULL 

#Casos  y controles por encima del threshold 
for (e in ev_names){
  c_up <- colSums(psimerge[psimerge$Event == e, 2, drop = FALSE])
  n1 = paste("c_up", e, sep = "")
  assign(n1, c_up)
}
for (e in ev_names){
  ct_up <- colSums(psimerge[psimerge$Event == e, 5, drop = FALSE])
  n2 = paste("ct_up", e, sep = "")
  assign(n2, ct_up)
}
c_ct_merge <- data.frame(
  "Event" = rep(ev_names, 2),
  "N_PSI" = c(c_upSE, c_upMX, c_upA5, c_upA3, c_upRI, c_upAF, c_upAL, ct_upSE, ct_upMX, ct_upA5, ct_upA3, ct_upRI, ct_upAF, ct_upAL),
  "Type" = rep(c("casos", "controles"), each = 7)
)

#Visualizar la tabla 
View(c_ct_merge)

#Vamos a hacer un Group Barplot
library(ggplot2)
library(viridisLite)
library(viridis)

p <- ggplot(c_ct_merge, aes(fill = Type, y = N_PSI, x = Type)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_viridis(discrete = T, option = "E") +
  facet_wrap(~Event) +
  xlab("Type of Eevent") +
  ylab("Number of the total cases and controls") +
  ggtitle("Number of cases and controls with a PSI above the Threshold (merged)") +
  theme(legend.position = "top") +
  theme_bw()
p

#Casos  y controles por encima del threshold que han dado significativos con p.valor ajustado < 0.05 y crear la tabla 
for (e in ev_names){
  c_up <- colSums(se[se$Event == e, 2, drop = FALSE])
  n1 = paste("c_up", e, sep = "")
  assign(n1, c_up)
}
for (e in ev_names){
  ct_up <- colSums(se[se$Event == e, 5, drop = FALSE])
  n2 = paste("ct_up", e, sep = "")
  assign(n2, ct_up)
}
c_ct_signi_merge<- data.frame(
  "Event" = rep(ev_names, 2),
  "N_PSI" = c(c_upSE, c_upMX, c_upA5, c_upA3, c_upRI, c_upAF, c_upAL, ct_upSE, ct_upMX, ct_upA5, ct_upA3, ct_upRI, ct_upAF, ct_upAL),
  "Type" = rep(c("casos", "controles"), each = 7)
)

#Un barplot por cada evento
library(ggplot2)
library(viridisLite)
library(viridis)

p1 <- ggplot(c_ct_signi_merge, aes(fill = Type, y = N_PSI, x = Type)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_viridis(discrete = T, option = "E") +
  facet_wrap(~Event) +
  xlab("Type of Eevent") +
  ylab("Number of total cases and controls") +
  ggtitle("Number of cases and controls with a PSI above the Threshold, just the pval.adjust < 0.05 (merged)") +
  theme(legend.position = "top") +
  theme_bw()
p1

#Paquete LIMMA
library(limma)

#Hacer una tabla  para cada evento: en los rows con el tipo de evento, y columnas: casos y controles por encima del threshold; además incluimos la funcion de vennCounts para cada caso
for (e in ev_names){
  ct_up <- psimerge[psimerge$Event == e, c(2,5)]
  vd <- vennCounts(ct_up)
  n2 = paste("vd", e, sep = "")
  assign(e, ct_up)
  assign(n2, vd)
}

#Plotteamos los 7 VennDiagramas; uno para cada evento 

vennDiagram(vdSE); vennDiagram(vdSE, names = c("Casos SE", "Controles SE"), circle.col = c("green3", "yellow"))
vennDiagram(vdMX); vennDiagram(vdMX, names = c("Casos MX", "Controles MX"), circle.col = c("green3", "yellow"))
vennDiagram(vdA5); vennDiagram(vdA5, names = c("Casos A5", "Controles A5"), circle.col = c("green3", "yellow"))
vennDiagram(vdA3); vennDiagram(vdA3, names = c("Casos A3", "Controles A3"), circle.col = c("green3", "yellow"))
vennDiagram(vdRI); vennDiagram(vdRI, names = c("Casos RI", "Controles RI"), circle.col = c("green3", "yellow"))
vennDiagram(vdAF); vennDiagram(vdAF, names = c("Casos AF", "Controles AF"), circle.col = c("green3", "yellow"))
vennDiagram(vdAL); vennDiagram(vdAL, names = c("Casos AL", "Controles AL"), circle.col = c("green3", "yellow"))

#VennDiagram con los genes
library(limma)
library(plyr)

psi <- psimerge
rownames(psi) <- psi$Event_ID
psi <- psi[, c("casos_up", "controles_up")]
psi <- psi[rowSums(psi) > 0, ] #Solo cogemos las filas que sean mayor que 0 en total 
psi$genes <- sub(";.*", "", rownames(psi)); psi <- psi[, c(3,1,2)] #En dicha tabla creamos una columna nueva con el id del Gen, a parte ordenamos las columnas
psi$genes <- gsub("_and_", ";", psi$genes)
colnames(psi) <- c("genes", "cases", "controls") #Le cambiamos el nombre a las columnas 
split_psi <- split(psi,psi$genes) #Con la funcion split lo que hacemos es agrupar en una lista en funcion de la columna genes (los que son los mismos genes se agrupan juntos)
summed_psi <- lapply(split_psi, function(x) { x$genes <- NULL; rbind(colSums(x))}) #Con la función lapply lo que hacemos es eliminar los duplicados
psi <- ldply(summed_psi, data.frame) #Con la función ldply transformamos la lista que tenemos en un data frame
psi$cases[psi$cases > 0] <- 1; psi$controls[psi$controls > 0] <- 1 #Le asignamos el valor de 1 a aquellos valores que sean mayor que 0 en casos y controles 
psi1 <- psi; psi1$.id <- NULL #Eliminamos la columna .id para poder hacer el VennDiagram 
p <- vennCounts(psi1)
vennDiagram(p, names = c("Casos Genes", "Controles Genes"), circle.col = c("green3", "yellow"))

#########################################################GO TERM ENRICHMENT/G PROFILE R##############################################################

install.packages("gProfileR")
library(gProfileR)
library(plyr)

psi <- psimerge; rownames(psi) <- psi$Event_ID; psi <- psi[, c("casos_up", "controles_up")]; psi <- psi[rowSums(psi) > 0, ] 
psi$genes <- sub(";.*", "", rownames(psi)); psi <- psi[, c(3,1,2)] ; psi$genes <- gsub("_and_", ";", psi$genes)
colnames(psi) <- c("genes", "cases", "controls"); summed_psi <- lapply(split_psi, function(x) { x$genes <- NULL; rbind(colSums(x))}) 
psi <- ldply(summed_psi, data.frame); psi$cases[psi$cases > 0] <- 1; psi$controls[psi$controls > 0] <- 1 
gene_set_merge <- psi[psi$cases == 1 & psi$controls == 0, ]; gene_fisher_merge<- list(gene_set_merge$.id)
gene_diff_merge <- list(diff_sig_merge$gene)
write.table(gene_fisher_merge1, "~/Desktop/Gene_fisher_merge.txt", quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")
write.table(gene_diff_merge1, "~/Desktop/Gene_diff_merge.txt", quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")

#Enrichment GProfilerR

go <- gprofiler(gene_diff_merge, organism = "hsapiens", sort_by_structure = T, ordered_query = F, exclude_iea = F,
                evcodes = F, region_query = F, max_p_value = 1, min_set_size = 0, max_set_size = 0, min_isect_size = 0, 
                correction_method = "fdr", hier_filtering = "none", domain_size = "annotated", custom_bg = "", numeric_ns = "",
                src_filter = c("GO", "KEGG", "REAC", "TF", "MI", "CORUM", "HPA", "OMIM", "HP"))

go2 <- gprofiler(gene_fisher_merge, organism = "hsapiens", sort_by_structure = T, ordered_query = F, exclude_iea = F,
                 evcodes = F, region_query = F, max_p_value = 1, min_set_size = 0, max_set_size = 0, min_isect_size = 0, 
                 correction_method = "fdr", hier_filtering = "none", domain_size = "annotated", custom_bg = "", numeric_ns = "",
                 src_filter = c("GO", "KEGG", "REAC", "TF", "MI", "CORUM", "HPA", "OMIM", "HP"))

write.table(data.frame(go), "~/Desktop/MN4/Resultados/Resultados/Enriquecimiento_diff_merge.txt", col.names = TRUE, row.names = TRUE, quote = FALSE, sep = "\t")
write.table(data.frame(go2), "~/Desktop/MN4/Resultados/Resultados/Enriquecimiento_fisher_merge.txt", col.names = TRUE, row.names = TRUE, quote = FALSE, sep = "\t")

#gProfiler2

install.packages("gprofiler2")
library(gprofiler2)

#Solo una query tanto para fisher como para diff
gostres <- gost(query = gene_diff_merge, organism = "hsapiens", ordered_query = FALSE, multi_query = FALSE, significant = TRUE,
                exclude_iea = FALSE, evcodes = TRUE, measure_underrepresentation = FALSE, user_threshold = 0.05,
                correction_method = "fdr", domain_scope = "annotated", custom_bg = NULL, numeric_ns = "", sources = NULL, 
                as_short_link = FALSE)

p <- gostplot(gostres, capped = FALSE, interactive = FALSE)
p

head(gostres$result)

#Solo una para fisher test
gostres1 <- gost(query = gene_fisher_merge, organism = "hsapiens", ordered_query = FALSE, multi_query = FALSE, significant = TRUE,
                exclude_iea = FALSE, evcodes = TRUE, measure_underrepresentation = FALSE, user_threshold = 0.05,
                correction_method = "fdr", domain_scope = "annotated", custom_bg = NULL, numeric_ns = "", sources = NULL, 
                as_short_link = FALSE)

x <- gostplot(gostres1, capped = FALSE, interactive = FALSE)
x
head(gostres1$result)

#Multiquery
multi_gostres <-  gost(query = c("DiffSPlice" = gene_diff_merge, "FisherTest" = gene_fisher_merge), organism = "hsapiens", ordered_query = FALSE, 
                       multi_query = FALSE, significant = TRUE,
                       exclude_iea = TRUE, evcodes = TRUE, measure_underrepresentation = FALSE, user_threshold = 0.05,
                       correction_method = "fdr", domain_scope = "annotated", custom_bg = NULL, numeric_ns = "", sources = NULL, 
                       as_short_link = FALSE)

p1 <- gostplot(multi_gostres, capped = FALSE, interactive = TRUE)
p1

enr <- multi_gostres$result; enr <- apply(enr, 2, as.character)
write.table(enr, "~/Desktop/MN4/Resultados/Resultados/Enrichment/Enriquecimiento_diff_fisher_merge.txt", col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t")

#########################################################CHANGING IDs ENSMBL TO GENE SYMBOL###########################################################

BiocManager::install("biomaRt")
library(biomaRt)
Gene_fisher_merge <- read.delim("~/Desktop/Gene_fisher_merge.txt", header = FALSE)
mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
G_list <- getBM(filters = "ensembl_gene_id", attributes = c("ensembl_gene_id", "hgnc_symbol"), values = Gene_fisher_merge, mart = mart)
write.table(G_list, file = "~/Desktop/MN4/Resultados/Resultados/GSymbol_fisher_merge.txt", sep = "\n", quote = FALSE)

GSymbol_diff_merge <- read.delim("~/Desktop/GSymbol_diff_merge.txt", header = TRUE)
GSymbol_diff_merge <- GSymbol_diff_merge[which(!GSymbol_diff_merge$hgnc_symbol == ""), ]
gs <- as.data.frame(GSymbol_diff_merge[, 3])
write.table(data.frame(gs), "~/Desktop/MN4/Resultados/Resultados/GSymbol_diff_merge.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)

GSymbol_fisher_merge <- read.delim("~/Desktop/GSymbol_fisher_merge.txt", header = TRUE)
GSymbol_fisher_merge <- GSymbol_fisher_merge[which(!GSymbol_fisher_merge$hgnc_symbol == ""),]
gf <- as.data.frame(GSymbol_fisher_merge[, 3])
write.table(gf, "~/Desktop/MN4/Resultados/Resultados/GSymbol_fisher_merge.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)

##############################################################MERGE OF BOTH DF#########################################################################

type_merge <- merge( x = diff_sig_merge, y = casos_merge, by = "row.names", all.x = TRUE) #Unimos el df de los 38 genes significativos del DiffSplice y con la los casos en un mismo evento
View(type_merge)
row.names(type_merge) <- type_merge$Row.names; type_merge <- type_merge[, -1]

st_merge <- data.frame(
  "Sample" = c("RNA10", "RNA14", "RNA18", "RNA20", "RNA24", "RNA26", "RNA28", "RNA30", "RNA34", "RNA38", "RNA39", "RNA50", "RNA53", "RNA6",
               "RNA79", "RNA22", "RNA2", "RNA42", "RNA44", "RNA46", "RNA48", "RNA56", "RNA59", "RNA68", "RNA71", "RNA74", "RNA76", 
               "RNA12", "RNA32", "RNA36", "RNA4", "RNA62", "RNA65", "RNA8"),
  "Subtype" = c(rep("C1", 15), rep("C2", 12), rep("C2B", 7))
)

for (n in 1:nrow(st_merge)){
  for (c in 1:ncol(type_merge)){
    if(st_merge[n, 1] == colnames(type_merge)[c]){
      new_name = paste(st_merge[n, 1], st_merge[n, 2], sep = "_")
      names(type_merge)[c] <- new_name
    }
  }
}

type_merge1 <- type_merge[, c(-1, -2, -3, -4)]
type_merge1 <- type_merge1[, c(1,3,4,5,7,8,9,11,13,15,16,22,23,29,33,6,10,17,18,19,20,24,25,28,30,31,32,2,12,14,21,26,27,34)]
c1_merge <- type_merge1[, 1:15]; c2_merge <- type_merge1[, 16:27]; c2b_merge <- type_merge1[, 28:34]

b = 0.85
nc1_merge = as.data.frame(rowSums(c1_merge > b)) #Cuantos samples hay con valor PSI por encima de 0 para el subtipo C1
nc2_merge = as.data.frame(rowSums(c2_merge > b)) #Cuantos samples hay con valor PSI por encima de O para el subtipo C2
nc2b_merge = as.data.frame(rowSums(c2b_merge > b)) #Cuantos samples hay con valor PSI por encima de 0 para el subtipo C2b

subtype_merge <- cbind(nc1_merge, nc2_merge, nc2b_merge); colnames(subtype_merge) <- c("C1_15", "C2_12", "C2B_7") #Unir los tres subtipos

View(subtype_merge)

write.table(type_merge, "~/Desktop/MN4/Resultados/Resultados/Subtype_tumours_merge.txt", col.names = TRUE, row.names = TRUE, sep = "\t")
write.table(subtype_merge, "~/Desktop/MN4/Resultados/Resultados/Subtype_merge.txt", col.names = TRUE, row.names = TRUE, sep = "\t")

#################################################################RADAR CHART#######################################################################################

install.packages("fmsb")
library(fmsb)

subtype_merge <- rbind(c(15,12,7), rep(0, 3), subtype_merge)
sm <- subtype_merge[1:2, ]
i <- NULL
for (i in 3:dim(subtype_merge)[1])
{
  fila = subtype_merge[i, c(1, 2, 3)]
  png(file=paste0("~/Desktop/Radarchart/Merge/", rownames(ss[3, ]), ".png"), width = 800, height = 600)
  ss <- rbind(sm, fila)
  radarchart(ss, axistype=1 , 
             
             #custom polygon
             pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
             
             #custom the grid
             cglcol="grey", cglty=1, axislabcol="grey" , cglwd=0.8,
             
             #custom labels
             vlcex=0.8,
             
             #custums the names
             vlabels = c( "C1", "C2", "C2B")
             
             #tittle
             #title = rownames(ss[3, ])
            )
  mtext(side = 3, line = 2.5, at = 0, cex = 0.75, rownames(ss[3, ]), font = 2)
  dev.off()
}

#Vamos a ver los que son significativos por ser diferentes en al menos 2 ángulos y nos quedamos con esos triángulos

i <- NULL; fila_c1c2 <- NULL; fila_c1c2b <- NULL; fila_c2c2b <- NULL; h1 <- NULL; h2 <- NULL; h3 <- NULL; res <- NULL; res1 <- NULL; res2 <- NULL; pval_c1vsc2 <- NULL; pval_c1vsc2b <- NULL; pval_c2vsc2b <- NULL
for (i in 1:dim(subtype_merge[1]))
{
  fila1 = c(15, 12); fila_c1c2 = subtype_merge[i, c(1,2)]
  fila2 = c(15, 7); fila_c1c2b = subtype_merge[i, c(1,3)]
  fila3 = c(12, 7); fila_c2c2b = subtype_merge[i, c(2,3)]
  names(fila1) <- c("C1", "C2"); names(fila_c1c2) <- c("C1", "C2")
  names(fila2) <- c("C1", "C2B"); names(fila_c1c2b) <- c("C1", "C2B")
  names(fila3) <- c("C2", "C2B"); names(fila_c2c2b) <- c("C2", "C2B")
  h1 = rbind(fila1, fila_c1c2); h2 = rbind(fila2, fila_c1c2b); h3 = rbind(fila3, fila_c2c2b)
  res = fisher.test(h1)$p.value; res1 = fisher.test(h2)$p.value; res2 = fisher.test(h3)$p.value
  pval_c1vsc2 <- c(pval_c1vsc2, res)
  pval_c1vsc2b <- c(pval_c1vsc2b, res1)
  pval_c2vsc2b <- c(pval_c2vsc2b, res2)
}

subtype_merge <- cbind(subtype_merge, pval_c1vsc2, pval_c1vsc2b, pval_c2vsc2b)

sig <- subtype_merge[subtype_merge$pval_c1vsc2 < 0.05 & subtype_merge$pval_c1vsc2b < 0.05 | subtype_merge$pval_c1vsc2 & subtype_merge$pval_c2vsc2b < 0.05 | subtype_merge$pval_c1vsc2b < 0.05 & subtype_merge$pval_c2vsc2b < 0.05, ]
View(sig)

install.packages("fmsb")
library(fmsb)

sig <- sig[, c(-4,-5,-6, -7, -8, -9)]
sig <- rbind(c(15,12,7), rep(0, 3), sig)

radarchart(sig, axistype = 1,
           #custom polygon
           pcol= c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9)) , pfcol= c(rgb(0.2,0.5,0.5,0.5), rgb(0.8,0.2,0.5,0.4)) , plwd=4 , 
           
           #custom the grid
           cglcol= "grey", cglty=1, axislabcol = "grey", cglwd=0.8,
                                                              
           #custom labels
           vlcex=0.8,
                                                              
           #custums the names
           vlabels = c( "C1", "C2", "C2B")
          )

mtext(side = 3, line = 2.5, at = 0, cex = 0.75, paste(rownames(sig[3, ]), rownames(sig[4, ]), sep = "\n"), font = 2)


write.table(subtype_merge, "~/Desktop/Subtype_pvalues_merge.txt", col.names = TRUE, row.names = TRUE, sep = "\t")
