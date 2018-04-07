library('data.table')
library('stringr')
library('stringi')
library('RNeo4j')


create_data <- function() {
  command_data <- data_extractor_for_get_commands()
  query = "CREATE (usecase:Command {command:{get_command}})
  MERGE (d:Date {date:{date_of_command}})
  MERGE (t:Time{time:{time_of_command}})
  CREATE (t) <- [:TIME] -(d) <- [:DATE] - (usecase)"
  
  graph <- startGraph("http://localhost:7474/db/data/")
  t <- newTransaction(graph)
  
  for (i in 1:nrow(command_data)) {
    get_command <- command_data[i,]$usecase
    date_of_command <- command_data[i,]$dt
    time_of_command <- command_data[i,]$tm
    
    appendCypher(
      t,
      query,
      get_command <- get_command,
      date_of_command <- date_of_command,
      time_of_command <- time_of_command
    )
    
    print(paste("Itetation no. ", i))
  }
  
  commit(t)
}

data_extractor_for_get_commands <- function() {
  # Extract all entries where cmedit get appears
  logs_for_cmedit_commands <-
    fread(
      "sed -n '1p;/cmedit get/p'  ~/R_projects/01_complete.csv",
      sep = "\t",
      fill = TRUE
    )
  # Extract commands and related data
  cmedit_commands <-
    c(stri_extract_all_regex(logs_for_cmedit_commands, '(?<=cmedit).*?(?=STARTED)'))
  date_of_commands <-
    c(stri_extract_all_regex(logs_for_cmedit_commands, '\\d{4}-\\d{2}-\\d{2}'))
  time_of_commands <-
    c(stri_extract_all_regex(logs_for_cmedit_commands, '\\d{2}:\\d{2}:\\d{2}'))
  # Create data frame
  command_data <-
    data.frame(cmedit_commands,  date_of_commands, time_of_commands)
  colnames(command_data) <- c("usecase", "dt", "tm")
  return (command_data)
}
