source('~/R_projects/PARSER/Parser.R', echo=FALSE)
library('RNeo4j')


create_data <- function() {
  command_data <- data_extractor_for_get_commands()
 
  query = "CREATE (usecase:Command {command:{get_command}})
  MERGE (s:Site {site:'434'})
  MERGE (d: Date {date:{date_of_command}})
  MERGE (s) - [r:EXECUTION {month: {month_of_command}}] -  (d) 
  MERGE (d)- [r1:EXECUTION_TIME {time: {time_of_command}}] -> (usecase)"
  
  graph <- startGraph("http://localhost:7474/db/data/")
  
  t <- newTransaction(graph)
 
  for (i in 1:nrow(command_data)) {
    get_command <- command_data[i,]$usecase
    year_of_command <- command_data[i,]$year
    month_of_command <- command_data[i,]$month
    date_of_command <- command_data[i,]$date
    time_of_command <- command_data[i,]$time_of_commands
    
    print(paste("Year is", year_of_command))
    
    appendCypher(t, 
                 query, 
                 get_command = get_command, 
                 year_of_command = year_of_command, 
                 month_of_command = month_of_command,
                 date_of_command = date_of_command,
                 time_of_command = time_of_command)
    
    print(paste("Itetation no. ", i))
  }
  
  commit(t)
}

