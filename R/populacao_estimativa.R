
#library(dplyr)
#library(stringr)
#library(readxl)

# http://www.ibge.gov.br/home/estatistica/populacao/estimativa2014/estimativa_dou.shtm
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2014/estimativa_dou_2014_xls.zip
# ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/Estimativas_2013/estimativa_2013_dou_xls.zip

anos <- c(2008,2009,2010,2011,2012,2013,2014,2015)
links_dou <- c(
  '/Estimativas_2008/UF_Municipio.zip',
  '/Estimativas_2009/UF_Municipio.zip',
  '', # ??
  '/Estimativas_2011/POP2011_DOU.zip',
  '/Estimativas_2012/estimativa_2012_DOU_28_08_2012_xls.zip',
  '/Estimativas_2013/estimativa_2013_dou_xls.zip',
  '/Estimativas_2014/estimativa_dou_2014_xls.zip',
  '/Estimativas_2015/estimativa_dou_2015_20150915.xls'
)
#skip_dou <- c(4,4,NA,NA,NA,NA,NA,NA)
df.links <- dplyr::data_frame(anos, links_dou)
link_prepend <- 'ftp://ftp.ibge.gov.br/Estimativas_de_Populacao'

# ...
ibge.download.populacao.estimativa <- function(ano, dir="") {
  url<- df.links[anos==ano,]$links_dou
  filename<- unlist( stringr::str_split(url, "/") )[3]
  filename_download<- paste0(dir, filename)
  download.file(paste0(link_prepend, url), filename_download)
  return(filename_download)
}

# ...
ibge.load.df <- function(filename, skip=2) {
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
  return(df[!is.na(df$codigo_uf),])
  #return(read_excel(filename, sheet=2, skip=2))
}

# f2008 <- ibge.download.populacao.estimativa(2008)
# df2008 <- ibge.load.df(f2008, 4)

# f2009 <- ibge.download.populacao.estimativa(2009)
# df2009 <- ibge.load.df(f2009, 4)

# f2011 <- ibge.download.populacao.estimativa(2011)
# df2011 <- ibge.load.df(f2011)

# f2012 <- ibge.download.populacao.estimativa(2012)
# df2012 <- ibge.load.df(f2012)

# f2013 <- ibge.download.populacao.estimativa(2013)
# df2013 <- ibge.load.df(f2013)

# f2014 <- ibge.download.populacao.estimativa(2014)
# df2014 <- ibge.load.df(f2014)

# f2015 <- ibge.download.populacao.estimativa(2015)
# df2015 <- ibge.load.df(f2015)
### df2015 <- read_excel(f2015, sheet=2, skip=2)

# http://www.cidades.ibge.gov.br/xtras/home.php
# http://www.cidades.ibge.gov.br/xtras/perfil.php?lang=&codmun=431490
