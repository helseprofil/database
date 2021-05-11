rm(list = ls())
Rfiles <- c("install-packages.R", "parameter.R", "conn-db.R", "read-original.R")
invisible(sapply(Rfiles, source))

## Path
OS <- Sys.info()["sysname"]
osDrive <- switch(OS,
                  Linux = "/mnt/F",
                  Windows = "F:"
                  )
orgPath <- "Forskningsprosjekter/PDB 2455 - Helseprofiler og til_/PRODUKSJON/ORGDATA/SSB"
dbPath <- "Forskningsprosjekter/PDB 2455 - Helseprofiler og til_/PRODUKSJON/STYRING"

dbFile <- "KHELSA.mdb"

khelseDB <- file.path(dbPath, dbFile)
db <- KHelse$new(khelseDB)
db$dbname


## SSB Befolkning
befFile <- "BEFOLKNING/ORG/2022/G1a2021.csv"
befPath <- file.path(osDrive, orgPath, befFile)

library(data.table)

befDT <- fread(befPath)

## SSB Dode
dodeFile <- "DODE_SSB/ORG/2021/G42019_v3.csv"
dodePath <- file.path(osDrive, orgPath, dodeFile)
dodeDT <- fread(dodePath, encoding = "Latin-1")
