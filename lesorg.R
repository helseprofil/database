getwd()
Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
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
orgFile <- data.table::fread(file.path(coEnv$orgPath, dd$FILNAVN))

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


## Split LANDBK
dt[, c("landb", "landf") := data.table::tstrsplit(LANDBK, "", fixed = TRUE)]


dd$AGGRIGERE
