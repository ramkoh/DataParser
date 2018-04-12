library('data.table')
library('stringr')
library('stringi')


reader <- function(files) {
files1 <- list.files(path = "~/R_projects/data",
                     pattern = "\\.csv$",
                     full.names = TRUE)
getc <- data.frame(col1 =
                     character(),
                   stringsAsFactors = FALSE)
names(getc) <- "col1"


setc <- data.frame(col1 = character(), stringsAsFactors = FALSE)
names(setc) <- "col1"
for (fileName in files1) {
  get_df <-
    data.frame(lapply(
      paste("sed -n '1p;/cmedit get/p'", fileName),
      fread,
      fill = TRUE,
      sep = "\t"
    ))
  names(get_df) <- "col1"
  
  getc <- rbind(get_df, getc)
  set_df <-
    data.frame(lapply(
      paste("sed -n '1p;/cmedit set/p'", fileName),
      fread,
      fill = TRUE,
      sep = "\t"
    ))
  names(set_df) <- "col1"
  setc <- rbind(set_df, setc)
}

logs_for_cmedit_commands <- rbind(getc, setc)
return(logs_for_cmedit_commands)
}