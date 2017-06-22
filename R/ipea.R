
#' Returns a \code{data.frame} with a given series from IPEA
#' (Instituto de Pesquisa Econômica Aplicada) by its code
#'
#' @param codigo the series code
#' @param dir directory for temporary (cache) files
#' @param alwaysDownload if true, ignores local cache
#' @seealso \url{http://www.ipeadata.gov.br}
#' @return a \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- ipea_serie_carrega(37667)
#' }
#' @export
#'
#' @import httr
ipea_serie_carrega <- function(codigo, dir=".", alwaysDownload=F) {
  ipea_url <- paste0('http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=',
                     codigo,
                    '&module=M')
  filename <- paste0(dir, "/ipea_", codigo, ".csv")

  POST(ipea_url,
     body = list(bar_oper="oper_exibeseries", oper="exportCSVUS"),
     encode = "form", write_disk(filename, overwrite = T))
  df <- readr::read_csv(filename)

  df
}
