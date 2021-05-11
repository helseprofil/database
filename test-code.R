rm(list = ls())
Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
invisible(sapply(Rfiles, source))

khelseDB
db <- KHelse$new(khelseDB)
db$dbname
db$dbconn
DBI::dbGetQuery(db$dbconn, "SELECT TOP 3 * FROM ORIGINALFILER")
db$db_close()
db$db_reconnect()


## SSB Befolkning
befFile <- "BEFOLKNING/ORG/2022/G1a2021.csv"
befPath <- file.path(osDrive, orgPath, befFile)
befDT <- fread(befPath)

## SSB Dode
dodeFile <- "DODE_SSB/ORG/2021/G42019_v3.csv"
dodePath <- file.path(osDrive, orgPath, dodeFile)
dodeDT <- fread(dodePath, encoding = "Latin-1")
