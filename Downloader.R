library('data.table')
library('stringr')
library('stringi')


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

