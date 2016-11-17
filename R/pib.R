
#' @export
pib.load <- function(ano = NA, dir = ".") {
  if(!is.na(ano) && (ano < 1999 || ano > 2013)) {
    stop(paste("data not avaiable for year",ano))
  }

  url <- "ftp://ftp.ibge.gov.br/Pib_Municipios/2012/base/base_1999_2012_xlsx.zip"
  colnames <- c("ano", "codigo_uf", "nome_uf", "cod_municipio", "nome_munic",
                "nome_metro", "codigo_meso", "nome_meso", "codigo_micro", "nome_micro",
                "vab_agropecuaria", "vab_industria", "vab_servicos", "vab_adm_publica", "impostos",
                "pib_total", "populacao", "pib_per_capita")
  #if(is.na(ano)) {}
  #else
  if(is.na(ano) || ano >= 2010) {
    url <- "ftp://ftp.ibge.gov.br/Pib_Municipios/2010_2013/base/base_xls.zip"
    colnames <- c("ano", "codigo_uf", "nome_uf", "cod_municipio", "nome_munic",
                  "nome_metro", "codigo_meso", "nome_meso", "codigo_micro", "nome_micro",
                  "vab_agropecuaria", "vab_industria", "vab_servicos_exclusivo", "vab_adm_publica", "vab_total",
                  "impostos", "pib_total", "populacao", "pib_per_capita")
  }
  file <- util.downloadAndUnzip(url, dir=dir)

  df <- readxl::read_excel(file)
  #desc <- df[1,]
  #print(desc)
  colnames(df) <- colnames;
  if(is.na(ano)) {
    return(df)
  }

  df[df$ano==ano,]
}
