## Required packages
list.of.packages <- c("data.table", "R6", "DBI", "odbc")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if (length(new.packages)) install.packages(new.packages, repos = "https://cloud.r-project.org/")
sapply(list.of.packages, require, character.only = TRUE)


## Path and files
OS <- Sys.info()["sysname"]
osDrive <- switch(OS,
                  Linux = "/mnt/F",
                  Windows = "F:"
                  )
orgPath <- "Forskningsprosjekter/PDB 2455 - Helseprofiler og til_/PRODUKSJON/ORGDATA/SSB"
dbPath <- "Forskningsprosjekter/PDB 2455 - Helseprofiler og til_/PRODUKSJON/STYRING"

dbFile <- "KHELSA.mdb"
khelseDB <- file.path(osDrive, dbPath, dbFile)
