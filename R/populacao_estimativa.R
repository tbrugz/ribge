
# http://www.ibge.gov.br/home/estatistica/populacao/estimativa2014/estimativa_dou.shtm
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2014/estimativa_dou_2014_xls.zip
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2013/estimativa_2013_dou_xls.zip

#
#' Returns a file path of the population estimate file for a given year
#'
#' @param ano year (2000+) of the requested data file
#' @param dir directory for temporary files
#' @return a file path
#' @examples
#' \dontrun{
#'   filename <- populacao_municipios_download(2012)
#' }
#' @export
#' @importFrom utils download.file
populacao_municipios_download <- ibge.download.populacao.estimativa <- function(ano, dir=".") {
  url<- ribge::ibge.populacao.sources[ribge::ibge.populacao.sources$ano==ano,]$links_dou
  filename<- utils::tail( unlist( stringr::str_split(url, "/") ), n=1 )
  ext <- unlist( stringr::str_split(filename, "\\.") )[2]
  filename_extract <- paste0("pop_estimativa_",ano,".",ext)
  if( (!is.null(dir) && !(dir=='')) )  {
    dir <- paste0(dir, "/")
  }
  filename_download <- paste0(dir, filename_extract)
  #download_url <- url
  #if(!grepl("^http|ftp", download_url)) {
  #  download_url <- paste0(link_prepend, download_url)
  #}
  download.file(url, filename_download)
  return(filename_download)
}

ibge.download.populacao.estimativa <- populacao_municipios_download

#
#' Reads a file path with the population estimate file and returns a \code{data.frame}
#'
#' @param filename the file path
#' @param dir directory for temporary files
#' @param skip number of header lines to skip
#' @return a \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- populacao_municipios_carrega(filename)
#' }
#' @export
populacao_municipios_carrega <- function(filename, dir=".", skip=2) {
  if(stringr::str_detect(filename, "zip$")) {
    filename <- utils::unzip(filename, exdir=dir)
  }
  sheet <- readxl::excel_sheets(filename)
  if(length(sheet)>1) {
    sheet <- stringr::str_extract(sheet, ".*(Munic|MUNIC).*")
    sheet <- sheet[!is.na(sheet)]
  }
  df <- tryCatch({
    d <- readxl::read_excel(filename, sheet=sheet,
                           col_names = c("uf","codigo_uf","codigo_munic","nome_munic","populacao_str"),
                           col_types = c("text", "numeric", "text", "text", "text"),
                           skip=skip+1)
    d
  }, error = function(e) {
    # years in which error occurs: 2000, 2001, 2009, 2012, 2013, 2014, 2016
    warning(paste0("Error reading file '", filename, "'; using fallback strategy"));
    d <- readxl::read_excel(filename, sheet=sheet,
                       skip=skip)
    names(d)<-c("uf","codigo_uf","codigo_munic","nome_munic","populacao_str")
    d[,c(1,2,3,4,5)]
  })

  df$populacao <- as.numeric(stringr::str_extract(df$populacao_str, "([\\d\\.]+)"))
  df$populacao <- ifelse(df$populacao %% 1 > 0, df$populacao*1000, df$populacao)
  return(df[!is.na(df$codigo_uf),])
}

ibge.load.populacao.estimativa <- populacao_municipios_carrega

#' @import dplyr
ibge.populacao.postproc <- function(df, ano) {
  cod_munic_int <- as.integer(df$codigo_munic)
  # XXXdone: codigo_munic without last/verification digit for year <= 2006
  if(ano<=2006) {
    cod_munic4 <- cod_munic_int
  }
  else {
    cod_munic4 <- cod_munic_int %/% 10
  }
  df$cod_munic6 <- as.integer( paste0(as.integer(df$codigo_uf), stringr::str_pad(as.integer(cod_munic4), 4, pad = "0")) )
  if(ano<=2006) {
    ibge.cod6cod7map <- mutate_(ribge::municipioIbgeTseMap, cod_munic6 = ~ as.integer(cod_municipio) %/% 10) %>%
      select_("cod_munic6", "cod_municipio")
    df <- left_join(df, ibge.cod6cod7map, by = "cod_munic6")
  }
  else {
    df$cod_municipio <- paste0(as.integer(df$codigo_uf), stringr::str_pad(as.integer(df$codigo_munic), 5, pad = "0"))
  }
  df
}

#
#' Returns a \code{data.frame} with population estimates for all municipalities for the requested year.
#'
#' This function internally uses both \code{populacao_municipios_download} & \code{populacao_municipios_carrega}
#' functions.
#'
#' @param ano year of the requested data file
#' @param dir directory for temporary files
#' @return a \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- populacao_municipios(2014)
#' }
#' @export
populacao_municipios <- function(ano, dir=".") {
  if(!ano %in% ribge::ibge.populacao.sources$ano) {
    stop(paste("data not avaiable for year",ano))
  }

  # census data
  if(ano==2010) {
    df <- ribge::habitantes2010
    df$populacao_str <- df$populacao
    #return(df)
    #df$cod_munic_int <- as.integer(df$codigo_munic)
    #df$cod_municipio <- paste0(df$codigo_uf, df$codigo_munic)
    df <- ibge.populacao.postproc(df[,c(1,2,3,4,6,5)], ano)
    return(df)
    #return(df[,c(1,2,3,4,6,5,7)])
  }

  if(ribge::ibge.populacao.sources[ribge::ibge.populacao.sources$ano==ano,]$links_dou == '') {
    stop(paste("invalid url for year",ano))
  }

  # estimated data
  filename_download_zip <-paste0(dir, "/pop_estimativa_", ano, ".zip");
  filename_download_xls <-paste0(dir, "/pop_estimativa_", ano, ".xls");
  filename_download_xlsx <-paste0(dir, "/pop_estimativa_", ano, ".xlsx");
  if(file.exists(filename_download_zip)) {
    f<-filename_download_zip
  }
  else if(file.exists(filename_download_xls)) {
    f<-filename_download_xls
  }
  else if(file.exists(filename_download_xlsx)) {
    f<-filename_download_xlsx
  }
  else {
    f<-ibge.download.populacao.estimativa(ano, dir=dir)
  }

  skip <- ribge::ibge.populacao.sources[ribge::ibge.populacao.sources$ano==ano,]$skip_dou
  if(is.na(skip)) { skip <- 2 }

  df <- ibge.load.populacao.estimativa(f, dir=dir, skip=skip)
  df <- ibge.populacao.postproc(df, ano)
  return(df)
}

ibge.load.populacao <- populacao_municipios

### df2015 <- read_excel(f2015, sheet=2, skip=2)

# http://www.cidades.ibge.gov.br/xtras/home.php
# http://www.cidades.ibge.gov.br/xtras/perfil.php?lang=&codmun=431490
