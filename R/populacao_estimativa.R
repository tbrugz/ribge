
#library(dplyr)
#library(stringr)
#library(readxl)

# http://www.ibge.gov.br/home/estatistica/populacao/estimativa2014/estimativa_dou.shtm
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2014/estimativa_dou_2014_xls.zip
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2013/estimativa_2013_dou_xls.zip

anos <- c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016)
links_dou <- c(
  '/Estimativas_2000/UF_Municipio.zip',
  '/Estimativas_2001/UF_Municipio.zip',
  '/Estimativas_2002/UF_Municipio.zip',
  '/Estimativas_2003/UF_Municipio.zip',
  '/Estimativas_2004/UF_Municipio.zip',
  '/Estimativas_2005/UF_Municipio.zip',
  '/Estimativas_2006/UF_Municipio.zip',
  '', # 2007 ?
  '/Estimativas_2008/UF_Municipio.zip',
  '/Estimativas_2009/UF_Municipio.zip',
  '', # 2010 census
  '/Estimativas_2011/POP2011_DOU.zip',
  '/Estimativas_2012/estimativa_2012_DOU_28_08_2012_xls.zip',
  '/Estimativas_2013/estimativa_2013_dou_xls.zip',
  '/Estimativas_2014/estimativa_dou_2014_xls.zip',
  '/Estimativas_2015/estimativa_dou_2015_20150915.xls',
  '/Estimativas_2016/estimativa_dou_2016_20160913.xlsx'
)
#skip_dou <- c(4,4,NA,NA,NA,NA,NA,NA)
df.links <- dplyr::data_frame(anos, links_dou)
link_prepend <- 'ftp://ftp.ibge.gov.br/Estimativas_de_Populacao'

# ...
ibge.download.populacao.estimativa <- function(ano, dir=NULL) {
  url<- df.links[anos==ano,]$links_dou
  filename<- unlist( stringr::str_split(url, "/") )[3]
  ext <- unlist( stringr::str_split(filename, "\\.") )[2]
  filename_extract <- paste0("pop_estimativa_",ano,".",ext)
  if( (!is.null(dir) && !(dir=='')) )  {
    dir <- paste0(dir, "/")
  }
  filename_download <- paste0(dir, filename_extract);
  download.file(paste0(link_prepend, url), filename_download)
  return(filename_download)
}

# ...
ibge.load.populacao.estimativa <- function(filename, skip=2) {
  if(stringr::str_detect(filename, "zip$")) {
    filename<-unzip(filename)
  }
  sheet <- readxl::excel_sheets(filename)
  if(length(sheet)>1) {
    sheet <- stringr::str_extract(sheet, ".*(Munic|MUNIC).*")
    sheet <- sheet[!is.na(sheet)]
  }
  df <- readxl::read_excel(filename, sheet=sheet, skip=skip)
  names(df)<-c("uf","codigo_uf","codigo_munic","nome_munic","populacao")
  return( df[!is.na(df$codigo_uf), c(1,2,3,4,5)] )
}

# ...
ibge.load.populacao <- function(ano, dir=NULL) {
  if(!ano %in% anos) {
    stop(paste("data not avaiable for year",ano))
  }

  # census data
  if(ano==2010) {
    return(habitantes2010)
  }

  if(df.links[anos==ano,]$links_dou == '') {
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

  skip <- 2
  if(ano > 2000 && ano < 2010) {
    skip <- 4
  }
  df <- ibge.load.populacao.estimativa(f, skip=skip)
  return(df)
}

### df2015 <- read_excel(f2015, sheet=2, skip=2)

# http://www.cidades.ibge.gov.br/xtras/home.php
# http://www.cidades.ibge.gov.br/xtras/perfil.php?lang=&codmun=431490
