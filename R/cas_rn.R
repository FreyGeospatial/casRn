#' A Function
#'
#' This function allows you to webscrape NIST
#' @param datasource A dataframe containing the analyte names
#' @param db Character. The online database from which CAS RNs are scraped from. Defaults to "NIST"
#' @param header TRUE
#' @param browser Character. Defaults to chrome.
#' @param chomever Character. The browser version running on your machine.
#' @param port Integer. Randomly generated integer containing 4 digits between 1000 and 9999.
#' @param extraCapabilities Contains a vector of character arguments. Currently allows for headless browsing. Defaults to `list(chromeOptions = list(args = c('--headless', '--disable-gpu')))`
#' @param verbose Logical. Defaults to FALSE.
#' @keywords cas_rn
#' @export
#' @examples
#' cas_rn("file.xlsx")


cas_rn <- function(datasource,
                   analyte_column = 1,
                   db = "NIST",
                   header = TRUE,
                   browser = "chrome",
                   chromever = "93.0.4577.63",
                   port = sample(1000:9999, 1),
                   extraCapabilities = list(chromeOptions = list(args = c('--headless', '--disable-gpu'))),
                   verbose = F){



  if(toupper(db) != "NIST"){
    stop("Only the NIST database is currently supported. Other databases will be implemented in future versions")
  }

  if (!is.data.frame(datasource)){
    stop("Only dataframes are currently supported.")
  }else{
    df <- datasource
  }



  if ("cas_rn" %in% colnames(df)){
    count <- 1
    while(paste0("cas_rn", count) %in% colnames(df)){
      count <- count + 1
    }
    df[,paste0(cas_rn, count)] <- NA
  }else{
    df$cas_rn <- NA
  }


  analyte <- unlist(df[,analyte_column])


  if(toupper(db) == "NIST"){
    base_url <- "https://webbook.nist.gov/cgi/cbook.cgi?Name="
    db_analyte <- gsub(",", "%2C", analyte)
    urls <- paste0(base_url, db_analyte)
  } # this will be expanded later



  # x <<- try(RSelenium::rsDriver(port = port, chromever = chromever, verbose = F, extraCapabilities = extraCapabilities))
  x <- try(RSelenium::rsDriver(port = port, chromever = chromever, verbose = F, extraCapabilities = extraCapabilities))
  if(grepl("version requested doesnt match versions available", x)){
    message("Trying to automatically detect available chrome version...")
    chromever <- x %>% str_split("= ", simplify=T) %>%
      str_split(., ",", simplify = T) %>%
      str_split(., "\n", simplify = T) %>%
      as.vector() %>% as.data.frame() %>%
      rename(V1 = ".") %>%
      filter(V1 != "")

    chromever <- chromever$V1[grepl("\\d", chromever$V1)][1]

    message(paste0("using chrome version ", chromever))
  }

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

    #message(cas_string)

    if(length(cas_string > 0)){
      cas_rn <- stringr::str_extract(cas_string, "(\\d{2,7})-(\\d{2})-(\\d{1})")
      df$cas_rn[i] <- cas_rn
    }

    #message(cas_rn)

  }


  return(df)

}
