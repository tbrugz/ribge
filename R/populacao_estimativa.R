
# http://www.ibge.gov.br/home/estatistica/populacao/estimativa2014/estimativa_dou.shtm
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2014/estimativa_dou_2014_xls.zip
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2013/estimativa_2013_dou_xls.zip

# ...
#' @export
ibge.download.populacao.estimativa <- function(ano, dir=NULL) {
  url<- ibge.populacao.sources[ibge.populacao.sources$ano==ano,]$links_dou
  filename<- tail( unlist( stringr::str_split(url, "/") ), n=1 )
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

# ...
#' @export
ibge.load.populacao.estimativa <- function(filename, skip=2) {
  if(stringr::str_detect(filename, "zip$")) {
    filename<-unzip(filename)
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
  # XXX: codigo_munic without last/verification digit for year <= 2006
  #df$cod_munic_int <- as.integer(df$codigo_munic)
  df$cod_municipio <- paste0(as.integer(df$codigo_uf), stringr::str_pad(as.integer(df$codigo_munic), 5, pad = "0"))
  return(df[!is.na(df$codigo_uf),])
}

# ...
#' @export
ibge.load.populacao <- function(ano, dir=NULL) {
  if(!ano %in% ibge.populacao.sources$ano) {
    stop(paste("data not avaiable for year",ano))
  }

  # census data
  if(ano==2010) {
    df <- habitantes2010
    df$populacao_str <- df$populacao
    #return(df)
    #df$cod_munic_int <- as.integer(df$codigo_munic)
    df$cod_municipio <- paste0(df$codigo_uf, df$codigo_munic)
    return(df[,c(1,2,3,4,6,5,7)])
  }

  if(ibge.populacao.sources[ibge.populacao.sources$ano==ano,]$links_dou == '') {
    stop(paste("invalid url for year",ano))
  }

  # estimated data
  filename_download_zip <-paste0(dir, "pop_estimativa_", ano, ".zip");
  filename_download_xls <-paste0(dir, "pop_estimativa_", ano, ".xls");
  filename_download_xlsx <-paste0(dir, "pop_estimativa_", ano, ".xlsx");
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

  skip <- ibge.populacao.sources[ibge.populacao.sources$ano==ano,]$skip_dou
  if(is.na(skip)) { skip <- 2 }

  df <- ibge.load.populacao.estimativa(f, skip=skip)
  return(df)
}

### df2015 <- read_excel(f2015, sheet=2, skip=2)

# http://www.cidades.ibge.gov.br/xtras/home.php
# http://www.cidades.ibge.gov.br/xtras/perfil.php?lang=&codmun=431490
