library('data.table')
library('stringr')
library('stringi')

source('~/R_projects/PARSER/Reader.R', echo=FALSE)


data_extractor_for_get_commands <- function(files) {

  logs_for_cmedit_commands <- reader()
  # Extract commands and related data
  cmedit_commands <-
    stri_extract_all_regex(logs_for_cmedit_commands, '(?<=cmedit).*?(?=STARTED)')
  
  date_of_commands <-
    data.frame(col1 = c(
      stri_extract_all_regex(logs_for_cmedit_commands, '\\d{4}-\\d{2}-\\d{2}')
    ))
  names(date_of_commands) <- "col1"
  date_of_commands[c('col1.year', 'col1.month', 'col1.date')] <-
    colsplit(date_of_commands$col1, '-', c('year', 'month', 'date'))
  
  
  time_of_commands <-
    data.frame(stri_extract_all_regex(logs_for_cmedit_commands, '\\d{2}:\\d{2}:\\d{2}'))
  
  # Create data frame
  command_data <-
    data.frame(
      cmedit_commands,
      date_of_commands$col1.year,
      date_of_commands$col1.month,
      date_of_commands$col1.date,
      time_of_commands
    )
  setnames(command_data,
           c("usecase", "year", "month", "date", "time_of_commands"))
  
  return (command_data)
}
