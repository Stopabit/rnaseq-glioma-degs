#!/usr/bin/env Rscript
# Re-download the TCGA-LGG SummarizedExperiment from the GDC.
# Output: Arseniy-Pavlov.RData (SummarizedExperiment object named `se`)
#
# This takes ~20-30 min on the first run (downloads ~1.5 GB of raw counts).

options(repos = c(CRAN = "https://cloud.r-project.org"))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) BiocManager::install("TCGAbiolinks", update = FALSE, ask = FALSE)

library(TCGAbiolinks)
library(SummarizedExperiment)

query <- GDCquery(
  project   = "TCGA-LGG",
  data.category = "Transcriptome Profiling",
  data.type     = "Gene Expression Quantification",
  workflow.type = "STAR - Counts"
)

GDCdownload(query)
se <- GDCprepare(query)

save(se, file = "Arseniy-Pavlov.RData")
message("Done. Saved SummarizedExperiment to Arseniy-Pavlov.RData")
