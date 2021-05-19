library(norgeo)
library(data.table)

## Get the data with API
grunnkr <- get_list("grunnkrets", year = 2021)
grunnkr[, level := "grunnkrets"]
bydel <- get_list("bydel", year = 2021)
bydel[, level := "bydel"]
kommune <- get_list("kommune", year = 2021)
kommune[, level := "kommune"]
fylke <- get_list("fylke", year = 2021)
fylke[, level := "fylke"]

grunn_bydel <- get_correspond("bydel", cor = "grunnkrets", from = 2020)
grunn_komm <- get_correspond("komm", cor = "grunnkrets", from = 2020)
fylke_komm <- get_correspond("fylke", cor = "kommune", from = 2020)

## Add higher granularity codes
DT <- rbindlist(list(fylke, kommune, bydel, grunnkr))
## dt <- copy(DT)
## DT <- copy(dt)

grby <- grunn_bydel[, .(sourceCode, code = targetCode)]
grkom <- grunn_komm[, .(sourceCode, code = targetCode)]
fykom <- fylke_komm[, .(sourceCode, code = targetCode)]

DT[grkom, on = "code", kommune := sourceCode]
DT[fykom, on = c(kommune = "code"), fylke := sourceCode]
DT[grby, on = (grunnkr <- "code"), bydel := sourceCode]


## Merge geo code
## Run after adding granularity, else will be duplicated
DT[level == "grunnkrets", grunnkr := code]
DT[level == "fylke", fylke := code]
DT[level == "kommune", kommune := code]
DT[level == "bydel", bydel := code]

## Add granularity

setcolorder(DT, c(
  "code", "name", "validTo", "level",
  "grunnkr", "kommune", "fylke", "bydel"
))


Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
invisible(sapply(Rfiles, source))
orgPath <- "N:/Helseprofiler/DB_helseprofil"
geoFile <- "geo-level.accdb"
geoDB <- file.path(orgPath, geoFile)

gdt <- KHelse$new(geoDB)
gdt$dbname

gdt$db_write("geo", DT)
