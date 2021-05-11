## Connect to database
## Ensure connection will be closed during garbage collection with finalize
## Variables:
## dbname - Name of the database file
## dbconn - DB connection
## tblname - Name of DB table to write data to
## tblvalue - The data that will inserted to the tblname. Should be in a data.frame or data.table format
KHelse <- R6::R6Class(
         classname = "KHelse",
         class = FALSE,
         cloneable = FALSE,
         public = list(
           dbname = NULL,
           dbconn = NULL,
           tblname = NULL,
           tblvalue = NULL,
           initialize = function(dbname = NULL) {
             if (is.null(dbname)) {
               stop(message(" Woopss!! Database file is missing!"))
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
           db_write = function(name, value){
             self$tblname <- name
             self$tblvalue <- value
             DBI::dbWriteTable(self$dbconn,
                               self$tblname,
                               self$tblvalue,
                               batch_rows = 1,
                               overwrite = TRUE
                               )
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
