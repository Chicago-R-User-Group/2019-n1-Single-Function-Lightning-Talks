library(odbc)

# Launch postgres db in a docker container and expose port
system("docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=pg postgres")

# set environment variables to connect
{
  Sys.setenv(PG_USER = "postgres")
  Sys.setenv(PG_PASSWORD = "pg")
  Sys.setenv(PG_HOST = "0.0.0.0")
  Sys.setenv(PG_PORT = 5432)
}

# establish a connection to the db
con <- dbConnect(
  RPostgres::Postgres(),
  host = Sys.getenv("PG_HOST"),
  user = Sys.getenv("PG_USER"),
  password = Sys.getenv("PG_PASSWORD"),
  port = Sys.getenv("PG_PORT")
)

# generate fake data
random_data <- data.frame(
  id = seq_len(1e7),
  letter = sample(letters, 1e7, replace = TRUE),
  stringsAsFactors = FALSE
)

# make some fake tables
query_tables <- c("employees", "computers", "population", "currencies", "countries", "companies",
                  "stars", "cities", "rivers", "foods", "stocks", "sports")


# create tables
create_tables <- function(new_table) {
  print(paste("building table", new_table))
  dbWriteTable(con, new_table, random_data, append = TRUE, row.names = FALSE)
}

lapply(query_tables, create_tables)

dbDisconnect(con)
