getwd()
## Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
Rfiles <- c("misc.R", "conn-db.R")
invisible(sapply(Rfiles, source))

## Seperate envir. for general objects for multiple use
coEnv <- new.env()
## coEnv$conn <- KHelse$new("N:/Helseprofiler/DB_helseprofil/kilde/org-innlesing_BE.accdb")
coEnv$conn <- KHelse$new("N:/Helseprofiler/DB_helseprofil/org-innlesing.accdb")
coEnv$orgPath <- file.path(osDrive, orgPath) # from misc.R

## coEnv$conn$db_close()

## Create a list to feed all the standard object that will be used for further
## analysis eg. DEFAAR, AGGREGERE, manual input etc




filgruppe <- "BEFOLKNING"
LesOrg <- function(filgruppe = NULL) {
  dd <- get_spec(filgruppe)

  listDT <- vector(mode = "list", length = nrow(dd))

  for (i in seq_len(nrow(dd))) {
    orgFile <- data.table::fread(file.path(coEnv$orgPath, dd[i]$FILNAVN))
    orgFile <- rename_col(data = orgFile, spec = dd[i])

    orgFile[, c("landb", "landf") := data.table::tstrsplit(LANDBAK, "", fixed = TRUE)]

    listDT[[i]] <- orgFile
  }

  return(listDT)
}


install.packages(c("Rcpp", "readxl"))
tools::file_ext("files.xlsx")

xl <- readxl::read_excel(
  "F:/Forskningsprosjekter/PDB 2455 - Helseprofiler og til_/PRODUKSJON/ORGDATA/SSB/DODE_SSB/ORG/2021/G42018_v3.xlsx",
  sheet = "Ark1"
)


read_file <- function(file = NULL) {
  ## file : File name to be read

  fileExt <- tools::file_ext(file)
}

file_csv <- function(file = NULL) {

}

file_excel <- function(file = NULL) {
  dt <- readxl::read_excel(file)
}





get_aggrigate <- function(filgruppe = NULL) {
  qs <- sprintf("SELECT AGGREGERE FROM tbl_Filgruppe
                 WHERE FILGRUPPE = '%s'", filgruppe)
  dt <- DBI::dbGetQuery(coEnv$conn$dbconn, qs)
  dt$AGGREGERE
}

get_aggrigate("BEFOLKNING")


get_file_year <- function(id = NULL) {
  ## id : FILID from output of get_spec() function
  qs <- sprintf("SELECT DEFAAR FROM tbl_Orgfile
                WHERE FILID = %d", id)
  dt <- DBI::dbGetQuery(coEnv$conn$dbconn, qs)
  dt$DEFAAR
}

get_file_year(dd$FILID)

class(dd$FILID)


## Get all valid rows in tbl_Innlesing with valid file from tbl_Orgfile
get_spec <- function(filgruppe = NULL) {
  qs <- sprintf("SELECT KOBLID, tbl_Koble.FILID, tbl_Koble.FILGRUPPE, FILNAVN, IBRUKTIL, tbl_Innlesing.*
FROM tbl_Innlesing
INNER JOIN (tbl_Koble
            INNER JOIN tbl_Orgfile
            ON tbl_Koble.FILID = tbl_Orgfile.FILID)
ON (tbl_Innlesing.LESID = tbl_Koble.LESID)
WHERE tbl_Koble.FILGRUPPE = '%s'
AND tbl_Orgfile.IBRUKTIL = #9999-01-01#
", filgruppe)

  dt <- DBI::dbGetQuery(coEnv$conn$dbconn, qs)
  data.table::setDT(dt)
}

## Looping the rows
tt <- get_spec("Dode")
for (i in seq_len(nrow(tt))) {
  ...
}

dd <- get_spec("BEFOLKNING")
dd
tic()
orgFile <- data.table::fread(file.path(coEnv$orgPath, dd$FILNAVN))
toc()

library(tictoc)
library(future)
plan(multisession)
ff <- future({
  orgFile <- data.table::fread(file.path(coEnv$orgPath, dd$FILNAVN))
})
ff2 <- value(ff)
ff2
rm(ff2)

tic()
ff3 %<-% data.table::fread(file.path(coEnv$orgPath, dd$FILNAVN))
ff3
toc()

## Manheader

names(orgFile)
dd

## column that will be inserted manually will start with dollar sign $
## for instance AAR with $Y will get the value from DEFAAR
get_manual_col <- function(pattern, x) {
  ## pattern : pattern to grep
  ## x       : data specification from Access to grep
  yy <- grepl(pattern = pattern, x = x)
  names(x)[yy]
}

get_manual_col("^\\$", dd)


rename_col <- function(data = NULL, spec = NULL) {
  ## data : Input data
  ## spec : specification from Access tbl_Innlesing

  ## Manual input converted to NA for easier column renaming
  ## with just !is.na()
  mancol <- get_manual_col("^\\$", spec)
  if (length(mancol) > 0) {
    spec[, (mancol) := NA]
  }

  ## If both standard columns exists and MANHEADER,
  ## use MANHEADER
  stdNameAll <- c("GEO", "AAR", "KJONN", "ALDER", "UTDANN", "LANDBAK", "VAL")
  stdOldAll <- with(spec, c(GEO, AAR, KJONN, ALDER, UTDANN, LANDBAK, VAL))

  stdName <- stdNameAll[!is.na(stdOldAll)]
  stdOld <- stdOldAll[!is.na(stdOldAll)]

  data.table::setnames(data, stdOld, stdName)

  if (!is.na(spec$MANHEADER)) {
    ds <- unlist(strsplit(spec$MANHEADER, "="))
    oldName <- names(data)[as.integer(unlist(strsplit(ds[1], ",")))]
    newName <- unlist(strsplit(ds[2], ","))
    data.table::setnames(data, oldName, newName)
  }

  return(data)
}

dt <- rename_col(data = orgFile, spec = dd)
dt

## Split LANDBAK
dt[, c("landb", "landf") := data.table::tstrsplit(LANDBAK, "", fixed = TRUE)]
dt

## Aggregere
dd$AGGRIGERE

## aggrCols <- c("KJONN", "ALDER", "UTDANN", "SIVILSTAND", "landb", "landf")

dt <- LesOrg("Dode")
dt <- LesOrg("BEFOLKNING")
aggCols <- setdiff(names(dt), c("GEO", "LANDBAK", "VAL"))
names(dt)

## When lowest geo codes are grunnkrets, else should check what codes are in the rawdata
geoDT <- DBI::dbGetQuery(coEnv$conn$dbconn, "SELECT * FROM tbl_Geo WHERE level = 'grunnkrets'")
head(geoDT)
setDT(geoDT)
str(geoDT)
geoDT[, code := as.integer(code)]
delVar <- c("code", "level")
keepVar <- setdiff(names(geoDT), delVar)
keepVar
dt
dt[geoDT, on = c(GEO = "code"), (keepVar) := mget(keepVar)]

aggr <- "kommune"

DT <- data.table::groupingsets(
  dt[!is.na(get(aggr))],
  j = .(VAL = sum(VAL, na.rm = TRUE)),
  by = c(aggr, aggCols),
  sets = list(
    c(aggr, aggCols),
    c(aggr, "landb"),
    c(aggr, "landf")
  )
)


CJ(aggCols, aggCols)


dtsam <- sample(1:nrow(dt), 10)
dtmin <- dt[dtsam]
dtmin
dtmin[1:5, VAL := 2]
dtmin
aggCols <- c("fylke", "KJONN", "SIVILSTAND", "UTDANN")
aggCols2 <- c("KJONN", "SIVILSTAND", "UTDANN")
DTT <- data.table::cube(dtmin, j = list(antall = sum(VAL, na.rm = T)), by = aggCols)
DTT[!is.na(fylke)]


groupingsets(
  dtmin,
  j = .(antall = sum(VAL, na.rm = T)),
  by = aggCols,
  sets = list(
    aggCols,
    c("fylke", "KJONN", "SIVILSTAND"),
    c("fylke", "KJONN", "UTDANN"),
    c("fylke", "KJONN"),
    c("fylke", "SIVILSTAND")
  )
)
