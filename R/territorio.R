
# http://www.ibge.gov.br/home/geociencias/cartografia/default_territ_area.shtm
# AR_MUN_2015's unit: km^2
#' @export
area_municipios <- function(dir = ".") {
  url <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/areas_territoriais/2015/AR_BR_RG_UF_MUN_2015.xls"
  file <- util.download(url, dir = dir)
  df <- readxl::read_excel(file)
  df[!is.na(df$CD_GCMUN),]
}

territorio.area.load <- area_municipios
