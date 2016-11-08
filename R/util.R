
util.download <- function(url, dir=NULL, file=NULL, alwaysDownload=F) {
  #ext <- tail( unlist( stringr::str_split(filename, "\\.") ), n=1)
  #filename_extract <- paste0("file",".",ext)
  if(!is.null(file)) {
    filename <- file
  }
  else {
    filename <- tail( unlist( stringr::str_split(url, "/") ), n=1 )
  }
  if( (!is.null(dir) && !(dir=='')) )  {
    dir <- paste0(dir, "/")
  }

  filename_download <- paste0(dir, filename)
  if( alwaysDownload || (!file.exists(filename_download)) ) {
    download.file(url, filename_download)
  }
  return(filename_download)
}

util.downloadAndUnzip <- function(url, dir=NULL, file=NULL, alwaysDownload=F) {
  filename <- util.download(url, dir, file, alwaysDownload)
  if(stringr::str_detect(filename, "zip$")) {
    #filename <- unzip(filename, exdir = ifelse(is.null(dir), ".", dir) )
    filename <- util.unzip(filename, exdir = ifelse(is.null(dir), ".", dir) )
  }
  return(filename)
}

# filenames with non-ascii char problem...
# see: https://github.com/hadley/devtools/commit/1b1732cc2305a1880e3a788a1160fe85de37b06e
util.unzip <- function(src, exdir, unzip = getOption("unzip")) {
  if (unzip == "internal") {
    return(unzip(src, exdir = exdir))
  }

  args <- paste(
    "-o", shQuote(src),
    "-d", shQuote(exdir)
  )

  files <- system2(unzip, stdout = T, args)
  files<-files[-1]
  trimws(gsub("inflating:", "", files))
}

util.downloadSeries <- function(file, dir = ".") {
  baseurl <- "http://seriesestatisticas.ibge.gov.br/exportador.aspx?arquivo="
  filef <- paste0(file, ".csv")
  util.download( paste0(baseurl, filef), file = filef, dir = dir )
}

# http://stackoverflow.com/a/25989828/616413
vswitch <- function(expr, ...) {
  lookup <- list(...)
  vec <- as.character(expr)
  vec[is.na(vec)] <- "NA"
  unname(do.call(c, lookup[vec]))
}
