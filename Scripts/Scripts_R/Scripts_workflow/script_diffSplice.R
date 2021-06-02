dm <- read.delim("~/Desktop/MN4/Resultados/Resultados/Diffsplicing/diff_merge.dpsi", header = TRUE, sep = "\t", row.names = 1)

#Extraer del data frame los índices de las filas y quedarse solamente con el tipo de evento, unirlo en una columna nueva al daata frame y ordenar las columnas 
id <- sub(".*;", "", rownames(dm)) 
dm$event <- sub(":.*", "", id)
dm$gene <- sub(";.*", "", rownames(dm))
dm$gene <- gsub("_and_", ";", dm$gene)
dm <- dm[ , c(4,3,1,2)] 
names(dm) <- c("gene", "event", "dpsi", "pval") #Cambiarle los nombres a las columnas
#diff$event <- sub(".*;", "", diff$Event_ID) #Guardar en otra columna el tipo de evento del gen
View(dm)

#Limpiar datos
dm <- dm[!is.nan(dm$dpsi), ] #Quitar tosos los "nan"
dm <- dm[!is.na(dm$dpsi), ] #Quitar todos los "na"
diff_sig_merge <- dm[dm$pval < 0.05, ] #Guardamos en una tabla los genes y eventos significativos
View(diff_sig_merge)
dm$padj <- p.adjust(dm$pval, method="BH") #Ajustar el p.valor c on el método Benjamini & Hochberg y guardarlo en una columna nueva  
diff_sigadj_merge <- dm[dm$padj < 0.05, ] #Guardar en una variable los eventos significativos 
View(diff_sigadj_merge)

write.table(dm, file = "~/Desktop/diffSplicing_T_vs_NT.txt", sep = "\t", col.names = TRUE, row.names = TRUE)
write.table(diff_sig_merge, file = "~/Desktop/diffSplicing_T_vs_NT.txt", sep = "\t", col.names = TRUE, row.names = TRUE)

#Tabla para los 46 significativos contando la Incidencia de los eventos y después crear un plot 
library(ggplot2)
library(viridisLite)
library(viridis)
library(RColorBrewer)

di <- as.data.frame(table(diff_sig_merge$event)); colnames(di) <- c("Event", "Incidencia") 
View(di)

bar1 <- barplot(di$Incidencia, border = FALSE, names.arg = di$Event, las = 2, 
               col = brewer.pal(n = 7, name = "Paired"),
               ylim = c(0, 30),
               xlab = "Type of Event",
               ylab = "Number of times the event occurs",
               main = "Frequency of significant events with DiffSplice"
)

text(bar1, di$Incidencia+0.8, paste("n: ", di$Incidencia, sep = ""), cex = 1)
text(bar1, x = 7, y = 29, label = "Total: 46", cex = 1.05)
legend("topleft", legend = c("A3", "A5", "AF", "AL", "MX", "RI", "SE"), col = brewer.pal(n = 7, name = "Paired"), bty = "n", pch=20 , pt.cex = 2, cex = 0.8, horiz = TRUE, 
       inset = c(0.05, 0.05))


All_Events <- rep("All Events", 7)
di <- cbind(di, All_Events)

TemaTitulo = element_text(family="Arial",
                          size=rel(1.5), #Tamaño relativo de la letra del título
                          vjust=1,
                          hjust =0.5, 
                          face="bold", #Letra negrilla. Otras posibilidades "plain", "italic", "bold" y "bold.italic"
                          color="black", #Color del texto
                          lineheight=1.5) #Separación entre líneas

p1 <-ggplot(di, aes(fill = Event, y = Incidencia, x = All_Events, border = FALSE)) +
  geom_bar(position = "stack", stat = "identity", width = 0.2) +
  ylab("Number of significant events") +
  xlab("Event") +
  ylim(0, 50) +
  ggtitle("Incidence of significant events merged with DiffSplice") +
  scale_fill_brewer(palette = "Paired")  +
  theme_bw() +
  theme(plot.title = TemaTitulo) +
  geom_text(aes(label= paste("n: ", Incidencia, sep="")), 
            position = position_stack(), size=2, vjust=1.4, hjust=0.5 ,col="black") +
  geom_text(x= 1, y = 50, label = "Total: 46", col="black") +
  theme(legend.position = "right", panel.border = element_blank(), 
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
p1

################################################ENRICHMENT GPROFILER2###########################################################

install.packages("gprofiler2")
library(gprofiler2)

gene_diff_merge <- list(diff_sig_merge$gene)
write.table(gene_diff_merge1, "~/Desktop/Gene_diff_merge.txt", quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")


#Solo una query para diff
gostres <- gost(query = gene_diff_merge, organism = "hsapiens", ordered_query = FALSE, multi_query = FALSE, significant = TRUE,
                exclude_iea = FALSE, evcodes = TRUE, measure_underrepresentation = FALSE, user_threshold = 0.05,
                correction_method = "fdr", domain_scope = "annotated", custom_bg = NULL, numeric_ns = "", sources = NULL, 
                as_short_link = FALSE)

p <- gostplot(gostres, capped = FALSE, interactive = FALSE)
p

head(gostres$result)