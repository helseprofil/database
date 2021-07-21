getwd()
## Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
Rfiles <- "conn-db.R"
invisible(sapply(Rfiles, source))

coEnv <- new.env()
coEnv$conn <- KHelse$new("N:/Helseprofiler/DB_helseprofil/kilde/org-innlesing_BE.accdb")
coEnv$orgPath <- file.path(osDrive, orgPath) # from misc.R


LesOrg <- function(filgruppe = NULL) {
  dd <- get_raw(filgruppe)
  orgFile <- data.table::fread(file.path(coEnv$orgPath, dd$FILNAVN))
  orgFile <- rename_col(data = orgFile, spec = dd)

  orgFile[, c("landb", "landf") := data.table::tstrsplit(LANDBK, "", fixed = TRUE)]

  return(orgFile[])
}


## Get all valid rows in tbl_Innlesing with valid file from tbl_Orgfile
get_raw <- function(filgruppe = NULL) {
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

dd <- get_raw("BEFOLKNING")
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

rename_col <- function(data = NULL, spec = NULL) {
  ## data : Input data
  ## spec : specification from Access tbl_Innlesing

  ## If both standard columns exists and MANHEADER,
  ## use MANHEADER
  stdNameAll <- c("GEO", "AAR", "KJONN", "ALDER", "UTDANN", "LANDBK", "VAL")
  stdOldAll <- with(spec, c(GEO, AAR, KJONN, ALDER, UTDANN, LANDBK, VAL))
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

## Split LANDBK
dt[, c("landb", "landf") := data.table::tstrsplit(LANDBK, "", fixed = TRUE)]
dt

## Aggregere
dd$AGGRIGERE

## aggrCols <- c("KJONN", "ALDER", "UTDANN", "SIVILSTAND", "landb", "landf")

dt <- LesOrg("Dode")
dt <- LesOrg("BEFOLKNING")
aggCols <- setdiff(names(dt), c("GEO", "LANDBK", "VAL"))
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
