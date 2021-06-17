rm(list = ls())
Rfiles <- c("misc.R", "parameter.R", "conn-db.R", "read-original.R")
invisible(sapply(Rfiles, source))

khelseDB_t
db <- KHelse$new(khelseDB_t)
db$dbname
db$dbconn
df <- DBI::dbGetQuery(db$dbconn, "SELECT TOP 3 * FROM ORIGINALFILER")
df
db$db_close()
db$db_connect()

orgfileDB
orgdb <- KHelse$new(orgfileDB)
tblName <- "tbl_dode"
orgdb$dbconn
orgdb$db_write(tblName, dodeDT)
orgdb$db_close()
rm(orgdb)

## Test function
arg <- 'sep=";",skip=1'
dt <- read_org(befPath, arg = arg)




## SSB Befolkning
befFile <- "BEFOLKNING/ORG/2022/G1a2021.csv"
befPath <- file.path(osDrive, orgPath, befFile)
befDT <- fread(befPath)

## SSB Dode
dodeFile <- "DODE_SSB/ORG/2021/G42019_v3.csv"
dodePath <- file.path(osDrive, orgPath, dodeFile)
dodeDT <- fread(dodePath, encoding = "Latin-1", skip = 1)
dodeDT2 <- fread(dodePath, encoding = "Latin-1")

## OBS!! SSB Dode has code 99999999 which has no name
## in GRUNNKRETS downloaded with API

## Add geo levels
dt2 <- copy(dodeDT2)
dt <- copy(DT)

str(dt2)
str(dt)

dt[, code := as.integer(code)]

keepvar <- c("name", "validTo", "level", "grunnkr", "kommune", "fylke", "bydel")
dt2[dt, on = c(GRUNNKRETS = "code"), (keepvar) := mget(keepvar)]
setnames(dt2, grep("^Utdann", names(dt2), value = T), "utdanning")

## OBS!! SSB Dode has code 99999999 which has no name
## in GRUNNKRETS downloaded with API
dt2[GRUNNKRETS == 99999999, name := "Uoppgitt grunnkrets"]

dim(dt2)
dim(dodeDT)

dt2
dt2[, .(antall = sum(antall)), by = .(kommune, SIVILSTAND)]

dt2[, .N, by = utdanning]

sdt <- groupingsets(
  dt2[!is.na(fylke)],
  j = .(antall = sum(antall, na.rm = T)),
  by = c("fylke", "utdanning", "KJOENN", "landb"),
  sets = list(
    c("fylke", "utdanning", "KJOENN", "landb"),
    c("fylke", "utdanning", "KJOENN"),
    c("fylke", "utdanning", "landb"),
    c("fylke", "KJOENN", "landb"),
    c("fylke", "utdanning"),
    c("fylke", "KJOENN"),
    c("fylke", "landb"),
    c("fylke")
  )
)

sdt
setnames(sdt, "fylke", "GEO")
sdt[, aar := 2019]
setcolorder(sdt, "aar")

## total as 8888
for (x in seq_len(ncol(sdt))) {
  set(sdt, which(is.na(sdt[[x]])), j = x, value = 8888)
}

setkey(sdt, GEO)
fwrite(sdt, "pivot_dode.csv", sep = ";")

sdt[is.na(utdanning), utdanning := 8888] # total
sdt

## use it as dynamic vars
vars <- c("fylke", "KJOENN", "utdanning", "landb")
vars <- c("fylke", "utdanning")
sdt2 <- rollup(dt2[!is.na(fylke)], j = list(n = sum(antall, na.rm = T)), by = vars)
sdt2

sdt3 <- data.table::cube(dt2[!is.na(fylke)], j = list(n = sum(antall, na.rm = T)), by = vars)
sdt3


## Add total manually
dt2
dt3 <- dt2[!is.na(fylke), .(antall = sum(antall)), keyby = .(aar, fylke, KJOENN, utdanning, landb)]
dt3
dt_tot <- dt3[!is.na(fylke), .(antall = sum(antall, na.rm = T)), keyby = .(aar, fylke)]
dt_tot
dt_tot[, utdanning := 8888]
dt_tot[, KJOENN := 8888]
dt_tot[, landb := 8888]

dt4 <- rbindlist(list(dt3, dt_tot), use.names = TRUE)
setkey(dt4, fylke)
setnames(dt4, "fylke", "GEO")
dt4[1:60]
fwrite(dt4, "dode_fylke.csv", sep = ";")


## Split landbakgrunn
dodeDT2
dodeDT2[, landf := stringi::stri_extract(landb, regex = "\\D")]

landRecode <- list(
  land = c(NA, "B", "C"),
  to = 1:3
)
dodeDT2[landRecode, on = c(landf = "land"), landf := i.to]

dodeDT2[, landbak := stringi::stri_extract(landb, regex = "\\d")]

dodeDT2[, .N, by = landf]
dodeDT2[, .N, by = landb]

unlist(strsplit("1B", ""))[2]
unlist(strsplit("3B", "", fixed = TRUE))[1]

unlist(stringi::stri_split("4B", regex = "\\d"))[2]
grep("^\\d", "5B", value = TRUE)

stringi::stri_extract("4B", regex = "^\\d")
stringi::stri_extract("4B", regex = "\\D$")
