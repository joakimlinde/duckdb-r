# array errors with more than one dimention

    Code
      dbGetQuery(con, "FROM tbl")
    Condition
      Error in `duckdb_result()`:
      ! Nested arrays cannot be returned to R as column data.

# array errors with convert option array = 'none'

    Code
      dbGetQuery(con, "FROM tbl")
    Condition
      Error in `duckdb_result()`:
      ! Use `dbConnect(array = "matrix")` to enable arrays to be returned to R.

# array errors with default convert option array

    Code
      dbGetQuery(con, "FROM tbl")
    Condition
      Error in `duckdb_result()`:
      ! Use `dbConnect(array = "matrix")` to enable arrays to be returned to R.

# array errors when writing matrix of complex numbers

    Code
      dbWriteTable(con, "tbl", df)
    Condition
      Error in `.local()`:
      ! rapi_execute: Can't convert R type to logical type
      Error in `.local()`:
      ! rapi_register_df: Failed to register data frame: std::exception

