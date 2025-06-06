#' Run a SQL query
#'
#' `sql()` runs an arbitrary SQL query and returns a data.frame the query results
#'
#' @param sql A SQL string
#' @param conn An optional connection, defaults to built-in default
#' @return A data frame with the query result
#' @noRd
#' @examples
#' print(duckdb::sql("SELECT 42"))

sql <- function(sql, conn = default_connection()) {
  stopifnot(dbIsValid(conn))
  dbGetQuery(conn, sql)
}

the <- new.env(parent = emptyenv())

#' Get the default connection
#'
#' `default_connection()` returns a default, built-in connection
#'
#' @return A DuckDB connection object
#' @noRd
#' @examples
#' conn <- default_connection()
#' print(duckdb::sql("SELECT 42", conn=conn))
default_connection <- function() {
  if(!exists("con", the)) {
    con <- DBI::dbConnect(duckdb::duckdb())

    the$con <- con
  }
  the$con
}
