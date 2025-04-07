previous_edition = edition_get()
local_edition(3)

test_that("arrays can be read (INTEGER)", {
  skip_if_not_installed("vctrs")
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con, shutdown = TRUE))

  dbExecute(con, "CREATE TABLE tbl (a INTEGER, b INTEGER[3])")
  dbExecute(con, "INSERT INTO tbl VALUES (10, [1, 5, 9])")
  dbExecute(con, "INSERT INTO tbl VALUES (11, [2, 6, 10])")
  dbExecute(con, "INSERT INTO tbl VALUES (12, [3, 7, 11])")
  dbExecute(con, "INSERT INTO tbl VALUES (13, [4, 8, 12])")

  df1 <- dbGetQuery(con, "FROM tbl")

  df2 <- vctrs::data_frame(
    a = c(10, 11, 12, 13),
    b = matrix(1:12, nrow = 4, ncol = 3)
  )

  expect_equal(df1, df2)
})


test_that("arrays can be read (DOUBLE)", {
  skip_if_not_installed("vctrs")
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con, shutdown = TRUE))

  dbExecute(con, "CREATE TABLE tbl (a INTEGER, b DOUBLE[3])")
  dbExecute(con, "INSERT INTO tbl VALUES (10, [1, 5, 9])")
  dbExecute(con, "INSERT INTO tbl VALUES (11, [2, 6, 10])")
  dbExecute(con, "INSERT INTO tbl VALUES (12, [3, 7, 11])")
  dbExecute(con, "INSERT INTO tbl VALUES (13, [4, 8, 12])")

  df1 <- dbGetQuery(con, "FROM tbl")

  df2 <- vctrs::data_frame(
    a = c(10, 11, 12, 13),
    b = matrix(as.double(1:12), nrow = 4, ncol = 3)
  )

  expect_equal(df1, df2)
})


test_that("arrays can be read (BOOLEAN)", {
  skip_if_not_installed("vctrs")
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con, shutdown = TRUE))

  dbExecute(con, "CREATE TABLE tbl (a INTEGER, b BOOLEAN[3])")
  dbExecute(con, "INSERT INTO tbl VALUES (10, [true, false, true])")
  dbExecute(con, "INSERT INTO tbl VALUES (11, [false, true, true])")
  dbExecute(con, "INSERT INTO tbl VALUES (12, [true, true, false])")
  dbExecute(con, "INSERT INTO tbl VALUES (13, [false, false, false])")

  df1 <- dbGetQuery(con, "FROM tbl")

  df2 <- vctrs::data_frame(
    a = c(10, 11, 12, 13),
    b = matrix( c(T, F, T, F, F, T, T, F, T, T, F, F) , nrow = 4, ncol = 3 )
  )

  expect_equal(df1, df2)
})


test_that("array error with more than one dimention", {
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con, shutdown = TRUE))

  dbExecute(con, "CREATE TABLE tbl (a INTEGER, b INTEGER[3][3])")
  dbExecute(con, "INSERT INTO tbl VALUES (10, [[1,3,4], [4,5,6], [7,8,9]])")
  dbExecute(con, "INSERT INTO tbl VALUES (11, [[1,3,4], [4,5,6], [7,8,9]])")

  expect_snapshot( error = TRUE, {
    dbGetQuery(con, "FROM tbl")
  })
})

local_edition(previous_edition)
