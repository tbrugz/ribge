
# AR_MUN_2015's unit: km^2
#
#' Returns a \code{data.frame} with area by municipality (in \code{km^2})
#'
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @seealso \url{http://www.ibge.gov.br/home/geociencias/cartografia/default_territ_area.shtm}
#' @examples
#' \dontrun{
#'   df <- area_municipios("~/tmp")
#' }
#' @export
area_municipios <- function(dir = ".") {
  url <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/areas_territoriais/2015/AR_BR_RG_UF_MUN_2015.xls"
  file <- util.download(url, dir = dir)
  df <- readxl::read_excel(file)
  df[!is.na(df$CD_GCMUN),]
}

territorio.area.load <- area_municipios
