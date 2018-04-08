library('RNeo4j')
library(igraph)

fetch_highest_command_rate <- function() {
  graph <- startGraph("http://localhost:7474/db/data/")
  
  query <- "MATCH (a)-[r:TIME]->(b)
  RETURN b.time as tm,
  collect(a) as queries,
  COUNT(r) as execution_rate ORDER BY execution_rate DESC LIMIT 10"
  data <- cypher(graph, query)
  return(data)
  #ig = graph.data.frame(data, directed=F)
  #plot(ig)
}

fetch_all_times<- function() {
  graph <- startGraph("http://localhost:7474/db/data/")
  
  query <- "MATCH (a)-[r:TIME]->(b)
  RETURN b.time as execution_time
  ORDER BY execution_time DESC LIMIT 1000"
  data <- cypher(graph, query)
  return(data)
  #ig = graph.data.frame(data, directed=F)
  #plot(ig)
}
