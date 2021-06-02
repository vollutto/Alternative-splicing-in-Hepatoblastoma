library(Gviz)
library(GenomicRanges)
library(biomaRt)
library(BSgenome.Hsapiens.UCSC.hg19)

gen <- "hg19"; chr <- "chr5"

# Ideogram track
itrack <- IdeogramTrack(genome = gen, chromosome = chr)

# Genomic coordinates track
gtrack <- GenomeAxisTrack()

# BioMart track
bm <- useMart(host = "grch37.ensembl.org", 
              biomart = "ENSEMBL_MART_ENSEMBL",
              dataset = "hsapiens_gene_ensembl")
biomTrack <- BiomartGeneRegionTrack(genome = gen,
                                    symbol = "NSD1",
                                    name = "ENSEMBL", biomart = bm)

# Sequence track
strack <- SequenceTrack(Hsapiens, chromosome = chr)

# Plot
plotTracks(list(itrack, gtrack, biomTrack, strack), 
    from = 176560601, to = 176560635, cex = 0.8,
    transcriptAnnotation = "transcript", just.group = "above")
