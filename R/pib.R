
#' Returns a \code{data.frame} with the gross domestic product (GDP/PIB) by municipality
#'
#' @param ano year of requested data (if not supplied, most current information will be returned)
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- pib_municipios(2013)
#' }
#' @export
pib_municipios <- function(ano = NA, dir = ".") {
  if(!is.na(ano) && (ano < 1999 || ano > 2020)) {
    stop(paste("data not avaiable for year",ano))
  }

  # 1999-2009
  url <- "https://ftp.ibge.gov.br/Pib_Municipios/2012/base/base_1999_2012_xlsx.zip"
  colnames <- c("ano", "codigo_uf", "nome_uf", "cod_municipio", "nome_munic",
                "nome_metro", "codigo_meso", "nome_meso", "codigo_micro", "nome_micro",
                "vab_agropecuaria", "vab_industria", "vab_servicos", "vab_adm_publica", "impostos",
                "pib_total", "populacao", "pib_per_capita")
  if(is.na(ano) || ano >= 2010) {
    # 2010-2020
    url <- "https://ftp.ibge.gov.br/Pib_Municipios/2020/base/base_de_dados_2010_2020_xls.zip"
    colnames <- c("ano", "codigo_regiao", "nome_regiao",
                  "codigo_uf", "sigla_uf", "nome_uf",
                  "cod_municipio", "nome_munic", "nome_metro",
                  "codigo_meso", "nome_meso", "codigo_micro", "nome_micro",
                  "codigo_reg_geo_imediata", "nome_reg_geo_imediata", "mun_reg_geo_imediata",
                  "codigo_reg_geo_intermediaria", "nome_reg_geo_intermediaria", "mun_reg_geo_intermediaria",
                  "codigo_concentracao_urbana", "nome_concentracao_urbana", "tipo_concentracao_urbana",
                  "codigo_arranjo_populacional", "nome_arranjo_populacional",
                  "hierarquia_urbana", "hierarquia_urbana_principais",
                  "codigo_regiao_rural", "nome_regiao_rural", "regiao_rural_classificacao",
                  "amazonia_legal", "semiarido", "cidade_de_sao_paulo",
                  "vab_agropecuaria", "vab_industria", "vab_servicos_exclusivo", "vab_adm_publica", "vab_total",
                  "impostos", "pib_total", #"populacao",
                  "pib_per_capita",
                  "atividade_vab1", "atividade_vab2", "atividade_vab3")
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

pib.load <- pib_municipios
