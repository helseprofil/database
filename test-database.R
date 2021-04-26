## Create database from Befolknings file
OS <- Sys.info()["sysname"]

osDrive <- switch(OS, Linux="/mnt/F", Windows="F:")
orgPath <- "Forskningsprosjekter/PDB 2455 - Helseprofiler og til_/PRODUKSJON/ORGDATA/SSB"

## SSB Befolkning
befFile <- "BEFOLKNING/ORG/2022/G1a2021.csv"
befPath <- file.path(osDrive, orgPath, befFile)

library(data.table)

befDT <- fread(befPath)

## SSB Dode
dodeFile <- "DODE_SSB/ORG/2021/G42019_v3.csv"
dodePath <- file.path(osDrive, orgPath, dodeFile)
dodeDT <- fread(dodePath, encoding = "Latin-1")

## Core columns
## These are columns that are mandatory in the database


## Specification from Access
## Innlessing ID 1153
## sep=";", skip=1,header=FALSE,brukfread=FALSE,FjernTommeRader=TRUE
## DELID G_uEDmLB_v4
