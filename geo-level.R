library(norgeo)
library(data.table)

## Get the data with API
grunnkr <- get_code("grunnkrets", from = 2021)
grunnkr[, level := "grunnkrets"]
bydel <- get_code("bydel", from = 2021)
bydel[, level := "bydel"]
kommune <- get_code("kommune", from = 2021)
kommune[, level := "kommune"]
fylke <- get_code("fylke", from = 2021)
fylke[, level := "fylke"]

## Add higher granularity codes
DT <- rbindlist(list(fylke, kommune, bydel, grunnkr))
## dt <- copy(DT)
## DT <- copy(dt)

## If specfied year for arg 'from' has empty data then step down one year
## til the nrow!=0
grunn_bydel <- get_correspond("bydel", cor = "grunnkrets", from = 2020)
grunn_komm <- get_correspond("komm", cor = "grunnkrets", from = 2020)
fylke_komm <- get_correspond("fylke", cor = "kommune", from = 2020)

grby <- grunn_bydel[, .(sourceCode, code = targetCode)]
grkom <- grunn_komm[, .(sourceCode, code = targetCode)]
fykom <- fylke_komm[, .(sourceCode, code = targetCode)]

## Add granularity code to DT
DT[grkom, on = "code", kommune := sourceCode]
DT[fykom, on = c(kommune = "code"), fylke := sourceCode]
DT[grby, on = (grunnkr <- "code"), bydel := sourceCode]


## Merge geo code
## Add granularity
DT[level == "bydel", kommune := gsub("\\d{2}$", "", code)][
  level == "bydel", fylke := gsub("\\d{4}$", "", code)
][
  level == "bydel", bydel := code
]

DT[level == "kommune", fylke := gsub("\\d{2}$", "", code)][
  level == "kommune", kommune := code
]


## Run after adding granularity, else will be duplicated
DT[level == "grunnkrets", grunnkr := code]
DT[level == "fylke", fylke := code]

## Add granularity fylke to kommune
## DT[level == "kommune" & kommune != 9999, fylke := DT[fykom, sourceCode, on = "code"]]
## DT[level == "kommune" & kommune == 9999, fylke := 99]


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
