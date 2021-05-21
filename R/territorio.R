
# AR_MUN_2015/AR_MUN_2020's unit: km^2
#
#' Returns a \code{data.frame} with area by municipality (in \code{km^2})
#'
#' @param ano year of the information
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @seealso \url{http://www.ibge.gov.br/home/geociencias/cartografia/default_territ_area.shtm}
#' @examples
#' \dontrun{
#'   df <- area_municipios(ano = 2020, dir = "~/tmp")
#' }
#' @export
area_municipios <- function(ano = 2020, dir = ".") {
  path <- "https://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/areas_territoriais"
  url <- NA
  if(ano==2020) {
    url <- paste0(path, "/2020/AR_BR_RG_UF_RGINT_RGIM_MES_MIC_MUN_2020.xls")
  }
  else if(ano==2015) {
    url <- paste0(path, "/2015/AR_BR_RG_UF_MUN_2015.xls")
  }
  else {
    stop(paste("data not avaiable for year", ano))
  }
  file <- util.download(url, dir = dir)
  df <- readxl::read_excel(file)
  df[!is.na(df$CD_GCMUN),]
}

territorio.area.load <- area_municipios
