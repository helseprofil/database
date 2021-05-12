## Read raw data
read_org <- function(file, arguments) {
  orgfile <- substitute(file)
  argsTxt <- paste0("data.table::fread(", orgfile, ",", arguments, ",", "encoding = 'Latin-1'",")")
  DT <- eval(parse(text = argsTxt))
}


default_cols_names <- c("GEO", "AAR", "ALDER", "KJONN", "UTDANN", "LANDBAK", "SIVST")
