## remotes::install_github("helseprofil/norgeo")
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

## Higher granularity downloaded with API
## NB! If specfied year for arg 'from' has empty data then step down one year
## til the nrow!=0

find_correspond <- function(type, correspond, from) {
  ## type: Higher granularity eg. fylker
  ## correspond: Lower granularity eg. kommuner
  nei <- 0
  while (nei < 1) {
    dt <- norgeo::get_correspond(type, correspond, from)
    nei <- nrow(dt)
    from <- from - 1
  }
  return(dt)
}

grunn_bydel <- find_correspond("bydel", cor = "grunnkrets", from = 2021)
grunn_komm <- find_correspond("komm", cor = "grunnkrets", from = 2021)
fylke_komm <- find_correspond("fylke", cor = "kommune", from = 2021)

grby <- grunn_bydel[, .(sourceCode, code = targetCode)]
grkom <- grunn_komm[, .(sourceCode, code = targetCode)]
fykom <- fylke_komm[, .(sourceCode, code = targetCode)]

## Add granularity code to DT
DT[grkom, on = "code", kommune := sourceCode]
DT[grby, on = "code", bydel := sourceCode]
DT[fykom, on = c(kommune = "code"), fylke := sourceCode]


## Merge geo code
## Add higher granularity that aren't available via correspond API
DT[
  level == "bydel", kommune := gsub("\\d{2}$", "", code)
][
  level == "bydel", fylke := gsub("\\d{4}$", "", code)
][
  level == "bydel", bydel := code
]

DT[
  level == "kommune", fylke := gsub("\\d{2}$", "", code)
][
  level == "kommune", kommune := code
]

## Only run this after adding lower granularity
DT[level == "grunnkrets", grunnkrets := code]
DT[level == "fylke", fylke := code]

## Add granularity fylke to kommune
## DT[level == "kommune" & kommune != 9999, fylke := DT[fykom, sourceCode, on = "code"]]
## DT[level == "kommune" & kommune == 9999, fylke := 99]


setcolorder(DT, c(
  "code", "name", "validTo", "level",
  "grunnkrets", "kommune", "fylke", "bydel"
))


Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
invisible(sapply(Rfiles, source))
orgPath <- "N:/Helseprofiler/DB_helseprofil"
geoFile <- "geo-level.accdb"
geoDB <- file.path(orgPath, geoFile)

gdt <- KHelse$new(geoDB)
gdt$dbname

gdt$db_write("geo", DT)
