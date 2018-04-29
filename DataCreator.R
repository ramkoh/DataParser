source('~/R_projects/PARSER/Parser.R', echo=FALSE)
library('RNeo4j')


create_data <- function() {
  command_data <- extractor()

  
  
  query1 = "CREATE (usecase:Command {command:{get_command}, site:'site_nmae', date_of_command:{date_of_command}})
  MERGE (t:Time {time:{time}}) 
  MERGE (t) <- [r1:EXECUTION_TIME] - (usecase)"
  
  
  graph <- startGraph("http://localhost:7474/db/data/")
  
  t <- newTransaction(graph)
 
  for (i in 1:nrow(command_data)) {
    get_command <- command_data[i,]$usecase
    #year_of_command <- command_data[i,]$year
    #month_of_command <- command_data[i,]$month
    date_of_command <- command_data[i,]$date_of_command
    time_of_command <- command_data[i,]$time_of_commands
    
    
    appendCypher(t, 
                 query1, 
                 get_command = get_command, 
                 #year_of_command = year_of_command, 
                 #month_of_command = month_of_command,
                 date_of_command = date_of_command,
                 time = time_of_command)
    
    print(paste("Itetation no. ", i))
  }
  
  commit(t)
}

