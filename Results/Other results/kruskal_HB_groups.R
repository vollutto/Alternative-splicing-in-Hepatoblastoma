library(plyr)
library(ggpubr)
install.packages("ggpubr")
library(rstatix)
install.packages("rstatix")

tab <- read.table("~/Desktop/MN4/Resultados/Resultados/Subtype_tumours.txt",sep='\t',header=T,stringsAsFactors=F)

# Compute Kruskal-Wallis test for each splicing event

L <- sapply(1:dim(tab)[1], function(x){
	
	df <- data.frame()
	for(lab in c("_C1","_C2","_C2B")){
		df <- rbind(df,data.frame(lab,"psi"=unname(unlist(tab[x,grep(lab,colnames(tab))]))))
	}

	c1 <- df[df$lab=="_C1",]$psi
	c2 <- df[df$lab=="_C2",]$psi
	c2b <- df[df$lab=="_C2B",]$psi

	df <- data.frame(
		"group"=c(rep("c1",length(c1)),rep("c2",length(c2)),rep("c2b",length(c2b))),
		"psi"=c(c1,c2,c2b),
		"event"=rownames(tab)[x])
	
	kruskal_pval <- kruskal.test(psi ~ group, data=df)$p.value
	return(list(data.frame("event"=rownames(tab)[x],"kruskal_pval"=kruskal_pval)))

})

df <- ldply(L, data.frame)
write.table(df, file="kruskal_pval.tsv", row.names=FALSE, col.names=TRUE, quote=FALSE)

# Boxplot only events with significant (p-value<0.01) differences between the treatment groups
# (significance of Dunn test are reported for pairwise comparisons between groups)

comparisons <- list( c("c1", "c2"), c("c2", "c2b"), c("c1", "c2b") )

events <- unique(df[df$kruskal_pval<0.01,]$event)

for(i in events){

	x <- which(rownames(tab)==i)

	df <- data.frame()
	for(lab in c("_C1","_C2","_C2B")){
		df <- rbind(df,data.frame(lab,"psi"=unname(unlist(tab[x,grep(lab,colnames(tab))]))))
	}

	c1 <- df[df$lab=="_C1",]$psi
	c2 <- df[df$lab=="_C2",]$psi
	c2b <- df[df$lab=="_C2B",]$psi

	df <- data.frame(
		"group"=c(rep("c1",length(c1)),rep("c2",length(c2)),rep("c2b",length(c2b))),
		"psi"=c(c1,c2,c2b),
		"event"=rownames(tab)[x])

	res.kruskal <- df %>% kruskal_test(psi ~ group)
	pwc <- df %>% dunn_test(psi ~ group, p.adjust.method = "bonferroni")

	pwc <- pwc %>% add_xy_position(x = "group")
	ggboxplot(df, x = "group", y = "psi", color = "group", palette = "jco", outlier.shape = NA) +
		stat_pvalue_manual(pwc, y.position=1.1, step.increase=0.1) +
		labs(
			title = i,
			subtitle = get_test_label(res.kruskal, detailed = TRUE),
			caption = get_pwc_label(pwc)) +
		geom_jitter(shape=16, position=position_jitter(0.2)) +
		theme(plot.title = element_text(size=10))

	ggsave(paste0("~/Desktop/MN4/Resultados/Resultados/Boxplots/",i,".png"))
}