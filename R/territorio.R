
# http://www.ibge.gov.br/home/geociencias/cartografia/default_territ_area.shtm
# AR_MUN_2015's unit: km^2
territorio.area.load <- function(dir = ".") {
  url <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/areas_territoriais/2015/AR_BR_RG_UF_MUN_2015.xls"
  file <- util.download(url)
  df <- readxl::read_excel(file)
  df[!is.na(df$CD_GCMUN),]
}
