
#' Returns a \code{data.frame} with a given series from BCB
#' (Brazil's Central Bank - Banco Central do Brasil) by its code
#'
#' @param codigo the series code
#' @param dir directory for temporary (cache) files
#' @param alwaysDownload if true, ignores local cache
#' @seealso \url{https://www.bcb.gov.br/?SGS}
#' @return a \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- bcb_serie_carrega(193)
#' }
#' @export
bcb_serie_carrega <- function(codigo, dir=".", alwaysDownload=F) {
  bcb_url <- paste0('http://api.bcb.gov.br/dados/serie/bcdata.sgs.', codigo, '/dados?formato=csv')
  filename <- paste0(dir, "/bcb_", codigo, ".csv")
  path <- util.download(bcb_url, dir=dir, file=filename, alwaysDownload=F)
  df <- readr::read_csv2(filename)

  #loc <- readr::locale(encoding = "ISO-8859-1")
  #df <- readr::read_csv2(filename, locale = loc)

  df
}
