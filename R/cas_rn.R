#' A Function
#'
#' This function allows you to webscrape NIST
#' @param file The file
#' @param db database
#' @param header TRUE
#' @param browser TRYE
#' @param chomever number
#' @param port random
#' @param extraCapabilities Later
#' @param verbose NOPE
#' @keywords cas_rn
#' @export
#' @examples
#' cas_rn("file.xlsx")


cas_rn <- function(datasource = "",
                   analyte_column = 1,
                   db = "NIST",
                   header = TRUE,
                   browser = "chrome",
                   chromever = "93.0.4577.63",
                   port = sample(1000:9999, 1),
                   extraCapabilities = list(chromeOptions = list(args = c('--headless', '--disable-gpu'))),
                   verbose = F){


  if (file == ""){
    stop("Please input the file path or  of your list of analytes.")
  }

  if(toupper(db) != "NIST"){
    stop("Only the NIST database is currently supported. Other databases will be implemented in future versions")
  }

  if (grepl("[.]csv", file)){
    df <- readr::read_csv(file, header = header)
  }else if(grepl("[.]xls", file)){
    df <- readxl::read_excel(file, col_names = header)
  }else if(is.data.frame(datasource)){
    df <- datasource
  }



  df$cas_rn <- NA

  analyte <- unlist(df[,analyte_column])

  if(toupper(db) == "NIST"){
    base_url <- "https://webbook.nist.gov/cgi/cbook.cgi?Name="
    db_analyte <- gsub(",", "%2C", analyte)
    urls <- paste0(base_url, db_analyte)
  } # this will be expanded later




  rD <- RSelenium::rsDriver(port = port, chromever = chromever, verbose = F, extraCapabilities = extraCapabilities)
  for (i in 1:nrow(df)){

    remDr <- rD$client
    x1 <<- remDr

    message(urls[i])

    remDr$navigate(urls[i])

    x2 <<- remDr

    webElems <- remDr$findElements(using = "css selector", "li")

    webElems <<- remDr


    resHeaders <- unlist(lapply(webElems, function(x) {x$getElementText()}))

    cas_string <- resHeaders[grepl("CAS Registry Number:", resHeaders)]

    message(cas_string)

    if(length(cas_string > 0)){
      cas_rn <- stringr::str_extract(cas_string, "(\\d{2,7})-(\\d{2})-(\\d{1})")
      df$cas_rn[i] <- cas_rn
    }

    message(cas_rn)

  }


  return(df)

}
