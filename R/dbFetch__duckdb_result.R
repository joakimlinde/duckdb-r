#' @rdname duckdb_result-class
#' @inheritParams DBI::dbFetch
#' @importFrom utils head
#' @usage NULL
dbFetch__duckdb_result <- function(res, n = -1, ...) {
  if (!res@env$open) {
    stop("result set was closed")
  }

  if (res@arrow) {
    if (n != -1) {
      stop("Cannot dbFetch() an Arrow result unless n = -1")
    }
    return(as.data.frame(duckdb_fetch_arrow(res)))
  }

  if (is.null(res@env$resultset)) {
    stop("Need to call `dbBind()` before `dbFetch()`")
  }
  if (res@stmt_lst$type == "EXPLAIN") {
    df <- res@env$resultset
    attr(df, "query") <- res@stmt_lst$str
    class(df) <- c("duckdb_explain", class(df))
    return(df)
  }
  if (length(n) != 1) {
    stop("need exactly one value in n")
  }
  if (is.infinite(n) || is.na(n)) {
    n <- -1
  }
  if (n < -1) {
    stop("cannot fetch negative n other than -1")
  }
  if (!is_wholenumber(n)) {
    stop("n needs to be not a whole number")
  }
  if (res@stmt_lst$type != "SELECT" && res@stmt_lst$type != "RELATION" && res@stmt_lst$return_type != "QUERY_RESULT") {
    warning("Should not call dbFetch() on results that do not come from SELECT, got ", res@stmt_lst$type)
    return(data.frame())
  }

  if (res@env$rows_fetched < 0) {
    res@env$rows_fetched <- 0
  }

  n_remaining <- nrow(res@env$resultset) - res@env$rows_fetched

  if (n == -1) {
    n <- n_remaining
  } else {
    n <- min(n, n_remaining)
  }

  if (res@env$rows_fetched == 0 && n == n_remaining) {
    # Shortcut for performance
    df <- res@env$resultset
  } else if (n > 0) {
    df <- res@env$resultset[seq.int(res@env$rows_fetched + 1, res@env$rows_fetched + n), , drop = FALSE]
    attr(df, "row.names") <- c(NA_integer_, as.integer(-n))
  } else {
    df <- res@env$resultset[integer(), , drop = FALSE]
  }

  res@env$rows_fetched <- res@env$rows_fetched + n

  df
}

#' @rdname duckdb_result-class
#' @export
setMethod("dbFetch", "duckdb_result", dbFetch__duckdb_result)
