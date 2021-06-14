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

## Add geo levels
dt2 <- copy(dodeDT2)
dt <- copy(DT)

str(dt2)
str(dt)

dt[, code := as.integer(code)]

keepvar <- c("name", "validTo", "level", "grunnkr", "kommune", "fylke", "bydel")
dt2[dt, on = c(GRUNNKRETS = "code"), (keepvar) := mget(keepvar)]
setnames(dt2, grep("^Utdann", names(dt2), value = T), "utdanning")

dim(dt2)
dim(dodeDT)

dt2
dt2[, .(antall = sum(antall)), by = .(kommune, SIVILSTAND)]

dt2[, .N, by = utdanning]

sdt <- groupingsets(
  dt2[!is.na(fylke)],
  j = .(antall = sum(antall, na.rm = T)),
  by = c("fylke", "utdanning"),
  sets = list(
    c("fylke", "utdanning"),
    c("fylke"),
    character(0)
  )
)

sdt[is.na(fylke), fylke := 0]
sdt[is.na(utdanning), utdanning := 8888] # total
sdt

## use it as dynamic vars
vars <- c("fylke", "utdanning")
sdt2 <- rollup(dt2[!is.na(fylke)], j = list(n = sum(antall, na.rm = T)), by = vars)
sdt2
