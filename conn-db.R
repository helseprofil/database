## Connect to database
## Ensure connection will be closed during garbage collection with finalize

KHelse <- R6::R6Class(
  classname = "KHelse",
  class = FALSE,
  cloneable = FALSE,
  public = list(
    dbname = NULL,
    dbconn = NULL,
    initialize = function(dbname = NULL) {
      if (is.null(dbname)) {
        return(message(">>> DB name is missing!"))
      } else {
        self$dbname <- dbname
        cs <- paste0(private$..drv, self$dbname)
        self$dbconn <- DBI::dbConnect(odbc::odbc(),
                                      .connection_string = cs,
                                      encoding = "latin1"
                                      )
      }
    },
    db_reconnect = function(){
      stopifnot(!is.null(self$dbname))
      cs <- paste0(private$..drv, self$dbname)
      self$dbconn <- DBI::dbConnect(odbc::odbc(),
                                    .connection_string = cs,
                                    encoding = "latin1")
    },
    db_close = function() {
      DBI::dbDisconnect(self$dbconn)
    }
  ),
  private = list(
    ..drv = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=",
    finalize = function() {
      DBI::dbDisconnect(self$dbconn)
    }
  )
)
