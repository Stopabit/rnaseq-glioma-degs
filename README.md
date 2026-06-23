# RNA-seq Differential Expression Analysis of Glioma Subtypes (LGr3 vs LGr4)

**Differential gene expression and functional enrichment analysis of TCGA lower-grade glioma RNA-seq data using DESeq2 and clusterProfiler.**

## Biological Background

Diffuse gliomas are the most common primary brain tumours in adults. Ceccarelli et al. (Cell, 2016) defined pan-glioma RNA expression clusters across the TCGA cohort. Two of these clusters capture the molecular axis from indolent to aggressive disease:

| Cluster | Molecular profile | Clinical behaviour |
|---------|------------------|--------------------|
| **LGr3** | *IDH*-mutant, 1p/19q non-codeleted | Lower-grade, better prognosis |
| **LGr4** | *IDH*-wild-type, GBM-like transcriptome | Aggressive, poor prognosis |

Comparing LGr3 and LGr4 reveals the transcriptional programmes that distinguish indolent IDH-mutant gliomas from tumours that behave like glioblastoma — making it a molecular proxy for the low-grade to high-grade progression axis.

## Key Findings

- **~3 500 differentially expressed genes** (padj < 0.05, |log2FC| > 1), with a bias toward upregulation in LGr4
- **LGr4 (aggressive):** extracellular-matrix remodelling, angiogenesis, immune/inflammatory response, ciliary and microtubule motility — the hallmark mesenchymal/invasive programme of high-grade glioma
- **LGr3 (indolent):** axon development, synaptic signalling, CNS neuron differentiation — retention of neuronal identity
- Both ORA and GSEA converge on the same biological story, consistent with Ceccarelli et al.

## Pipeline Overview

```
TCGA LGG raw counts (SummarizedExperiment)
        │
        ▼
  Pre-filtering (≥10 reads in ≥n samples)
        │
        ▼
  DESeq2: size-factor normalisation → dispersion estimation → Wald test
        │
        ├──► Volcano plot, MA plot
        ├──► PCA (VST-normalised)
        ├──► Heatmap (top 50 DEGs, z-scored)
        │
        ▼
  Functional enrichment (clusterProfiler)
        ├──► GO Biological Process — ORA (up in LGr3 / up in LGr4)
        └──► GO Biological Process — GSEA (full ranked list)
```

## Repository Structure

```
.
├── Arseniy-Pavlov.Rmd          # Full reproducible analysis (R Markdown)
├── Arseniy-Pavlov.RData        # Pre-built SummarizedExperiment (Git LFS)
├── data/
│   └── download_data.R         # Script to re-download data from TCGA via TCGAbiolinks
├── .gitattributes              # Git LFS tracking for large data files
├── .gitignore
├── LICENSE
└── README.md
```

Running the `.Rmd` produces a `lgg_results/` directory with all plots and tables:

| Output | Description |
|--------|-------------|
| `DEG_LGr4_vs_LGr3.csv` | Full differential expression results |
| `01_volcano.png` | Volcano plot with top gene labels |
| `02_pca.png` | PCA of VST-normalised counts |
| `03_heatmap_top50.png` | Heatmap of top 50 DEGs (z-scored) |
| `04a/b_GO_BP_*.png` | GO BP dotplots (ORA, each direction) |
| `05_GSEA_GO_BP.png` | GSEA dotplot split by direction |
| `06_GSEA_ridgeplot.png` | GSEA ridgeplot |
| `07_MA_plot.png` | MA plot |

## Reproducing the Analysis

### Prerequisites

- **R ≥ 4.3** with Bioconductor ≥ 3.18
- A LaTeX distribution (or `tinytex` — installed automatically by the notebook)

### Option A — Use the bundled data

The repository includes the pre-built `SummarizedExperiment` object as an `.RData` file (tracked via Git LFS). Clone, then knit:

```bash
git clone https://github.com/Stopabit/rnaseq-glioma-degs.git
cd rnaseq-glioma-degs

# Make sure Git LFS pulls the data file
git lfs pull

# Render the report (installs missing R packages automatically)
Rscript -e "rmarkdown::render('Arseniy-Pavlov.Rmd')"
```

### Option B — Re-download from TCGA

If you prefer to fetch the data fresh from the GDC:

```bash
Rscript data/download_data.R
Rscript -e "rmarkdown::render('Arseniy-Pavlov.Rmd')"
```

This downloads ~1.5 GB of raw data, so it takes a while on the first run.

## Methods

| Step | Tool | Details |
|------|------|---------|
| Data retrieval | TCGAbiolinks | GDCquery → GDCdownload → GDCprepare; TCGA-LGG, HTSeq raw counts |
| Pre-filtering | Base R | Keep genes with ≥ 10 counts in ≥ n samples (n = smaller group size) |
| Differential expression | DESeq2 | Negative-binomial GLM, Wald test, BH-adjusted p-values |
| Visualisation | ggplot2 / pheatmap | Volcano, MA, PCA (on VST counts), heatmap (z-scored VST) |
| Over-representation | clusterProfiler `enrichGO` | GO BP, universe = tested genes, BH correction |
| Gene-set enrichment | clusterProfiler `gseGO` | GO BP, genes ranked by Wald statistic |

## Technologies

R | Bioconductor | DESeq2 | clusterProfiler | SummarizedExperiment | ggplot2 | pheatmap | TCGAbiolinks

## References

1. Ceccarelli, M. et al. Molecular profiling reveals biologically discrete subsets and pathways of progression in diffuse glioma. *Cell* **164**, 550–563 (2016). [DOI:10.1016/j.cell.2015.12.028](https://doi.org/10.1016/j.cell.2015.12.028)
2. Love, M. I., Huber, W. & Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology* **15**, 550 (2014). [DOI:10.1186/s13059-014-0550-8](https://doi.org/10.1186/s13059-014-0550-8)
3. Wu, T. et al. clusterProfiler 4.0: A universal enrichment tool for interpreting omics data. *The Innovation* **2**, 100141 (2021). [DOI:10.1016/j.xinn.2021.100141](https://doi.org/10.1016/j.xinn.2021.100141)

## License

MIT
