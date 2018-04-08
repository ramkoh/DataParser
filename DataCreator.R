source('~/R_projects/Downloader.R', echo=FALSE)
library('RNeo4j')


create_data <- function() {
  command_data <- data_extractor_for_get_commands()
  query = "CREATE (usecase:Command {command:{get_command}})
  MERGE (d:Date {date:{date_of_command}})
  MERGE (t:Time{time:{time_of_command}})
  CREATE (t) <- [:TIME] - (usecase)"
  #CREATE (t) <- [:TIME] -(d) <- [:DATE] - (usecase)"
  
  graph <- startGraph("http://localhost:7474/db/data/")
  t <- newTransaction(graph)
  
  for (i in 1:nrow(command_data)) {
    get_command <- command_data[i,]$usecase
    date_of_command <- command_data[i,]$dt
    time_of_command <- command_data[i,]$tm
    
    appendCypher(t, 
                 query, 
                 get_command = get_command, 
                 date_of_command = date_of_command, 
                 time_of_command = time_of_command)
    
    print(paste("Itetation no. ", i))
  }
  
  commit(t)
}

