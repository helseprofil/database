library(data.table)
dt <- fread("H:/FHI/fhi_fullfort_24a_kommune_2013_2019.csv")

names(dt)
dt

osl <- dt[komm_nr == "0301"]
osl
osl[landb == "Tot"]
osl[, .N, by = landb]

## Create raw data without total
str(osl)
osl2 <- osl[landb != "Tot"]
osl2
osl2 <- osl2[ant_elev != 2939]
osl2 <- osl2[kjonn != 0][sosbak_fhi != 0]
View(osl2)

## --- USE this to aggregate ---
keycols <- c("komm_nr", "kjonn", "sosbak_fhi", "landb")
rr <- cube(osl2, j = list(antall = sum(ant_elev, na.rm = T)), by = keycols)
rr2 <- rr[!is.na(komm_nr)]
rr2
## -----------------------------

rr2[antall == 4366]
osl[ant_elev == 4366]

rr2[antall == 1 & landb == "4C"]
osl[ant_elev == 1 & landb == "4C"]

ot <- groupingsets(
  osl2,
  j = .(antall = sum(ant_elev, na.rm = T)),
  by = c("komm_nr", "kjonn", "sosbak_fhi", "landb"),
  sets = list(
    c("komm_nr", "kjonn", "sosbak_fhi", "landb"),
    ## c("komm_nr", "kjonn","sosbak_fhi"),
    ## c("komm_nr", "kjonn", "landb"),
    c("komm_nr", "sosbak_fhi", "landb"),
    ## c("komm_nr", "kjonn"),
    c("komm_nr", "landb"),
    c("komm_nr", "sosbak_fhi"),
    c("komm_nr")
  )
)

ot[is.na(landb), landb := "Tot"]
keycols <- c("komm_nr", "kjonn", "sosbak_fhi", "landb")
setkeyv(ot, keycols)
ot
osl2

osl2[, .N, by = komm_nr]
ot[landb == "Tot"]
ot[is.na(kjonn) & is.na(sosbak_fhi) & landb == "Tot"]

## Sum landb only
## c("komm_nr", "landb")
osl2[kjonn == 0 & sosbak_fhi == 0]
ot[is.na(kjonn) & is.na(sosbak_fhi)]

## c("komm_nr", "sosbak_fhi")
osl2[kjonn == 0 & sosbak_fhi == 1]
ot[is.na(kjonn) & sosbak_fhi == 1]
ot[antall == 499]

osl2[kjonn == 1 & sosbak_fhi == 1]
osl2[kjonn == 2 & landb == "0"]

osl2[kjonn == 0 & sosbak_fhi == 0 & landb == 0]
ot[is.na(kjonn) & is.na(sosbak_fhi) & landb == 0]

## Totall
osl2[kjonn == 0 & sosbak_fhi == 0 & landb == "Tot"]
ot[is.na(kjonn) & is.na(sosbak_fhi) & is.na(landb)]


DT <- dt[landb != "Tot"][komm_nr != "Tot"]
DT[1:30]

rollup(DT, j = list(n = sum(ant_elev, na.rm = T)), by = c("komm_nr", "landb"))
DT[is.na(komm_nr), .N]

DT[, .N, by = komm_nr]

DT[komm_nr == "Tot"]

dd <- groupingsets(
  DT,
  j = .(ant_elev = sum(ant_elev, na.rm = T)),
  by = c("komm_nr", "kjonn", "sosbak_fhi", "landb"),
  sets = list(
    c("komm_nr", "kjonn", "sosbak_fhi", "landb"),
    c("komm_nr", "sosbak_fhi", "landb"),
    c("komm_nr", "landb"),
    c("komm_nr")
  )
)

keycols <- c("komm_nr", "kjonn", "sosbak_fhi", "landb")
setkeyv(dd, keycols)
dd
