
#library(dplyr)
#library(tidyr)

#' Download a given file
#'
#' @param url file's url to download
#' @param dir directory for temporary (cache) files
#' @param file name for the local file
#' @param alwaysDownload if true, ignores local cache
#' @return a file path
#' @export
util.download <- function(url, dir=NULL, file=NULL, alwaysDownload=F) {
  #ext <- tail( unlist( stringr::str_split(filename, "\\.") ), n=1)
  #filename_extract <- paste0("file",".",ext)
  if(!is.null(file)) {
    filename <- file
  }
  else {
    filename <- utils::tail( unlist( stringr::str_split(url, "/") ), n=1 )
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

#' Download and unzip a given file by its URL
#'
#' @param url file's url to download
#' @param dir directory for temporary (cache) files
#' @param file name for the local file
#' @param alwaysDownload if true, ignores local cache
#' @return a file path
#' @export
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
#
#' Unzips a file
#'
#' @param src the file to unzip
#' @param exdir directory to extract file
#' @param unzip unzip strategy
#' @seealso \url{https://github.com/hadley/devtools/commit/1b1732cc2305a1880e3a788a1160fe85de37b06e}
#' @export
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

#' Downloads a given series by its code
#'
#' @param codigo the series code
#' @param dir directory for temporary (cache) files
#' @param xtraurl extra parameter to include in the request URL
#' @seealso \url{http://seriesestatisticas.ibge.gov.br/}
#' @return a file path
#' @examples
#' \dontrun{
#'   filename <- util.downloadSeries("CD99_BR_ABS")
#' }
#' @export
util.downloadSeries <- function(codigo, dir = ".", xtraurl = "") {
  baseurl <- "http://seriesestatisticas.ibge.gov.br/exportador.aspx?arquivo="
  filef <- paste0(codigo, ".csv")
  if(xtraurl != "" && !is.null(xtraurl)) {
    filef <- paste0(filef, "&", xtraurl)
  }
  util.download( paste0(baseurl, filef), file = filef, dir = dir )
}

#' Returns a \code{data.frame} with a given series.
#'
#' @param codigo the series code
#' @param dir directory for temporary (cache) files
#' @param xtraurl extra parameter to include in the request URL
#' @param transpose transpose the \code{data.frame}
#' @seealso \url{http://seriesestatisticas.ibge.gov.br/}
#' @return a \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- series_estatisticas_carrega("CD99_BR_ABS", transpose=T)
#' }
#' @export
series_estatisticas_carrega <- function(codigo, dir = ".", xtraurl = "", transpose = FALSE) {
  file <- util.downloadSeries(codigo, dir = dir, xtraurl = xtraurl)

  loc <- readr::locale(decimal_mark = ",")
  df <- readr::read_tsv(file, locale = loc)
  if(transpose) {
    #tidyr::gather(df)
    tt <- t(df)
    tt <- cbind(rownames(tt), tt)
    return( dplyr::as_data_frame(tt) )
  }
  df
}

# http://stackoverflow.com/a/25989828/616413
#
#' Vectorized \code{switch}
#'
#' @param expr the expression to evaluate
#' @param ... extra parameters for \code{switch}
#' @seealso \code{\link{switch}} & \url{http://stackoverflow.com/a/25989828/616413}
#' @export
vswitch <- function(expr, ...) {
  lookup <- list(...)
  vec <- as.character(expr)
  vec[is.na(vec)] <- "NA"
  unname(do.call(c, lookup[vec]))
}
