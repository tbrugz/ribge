
## setup data

anos <- c(2000,
          2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,
          2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,
          2021,2022)
links_dou <- c(
  '/Estimativas_2000/UF_Municipio.zip',
  '/Estimativas_2001/UF_Municipio.zip',
  '/Estimativas_2002/UF_Municipio.zip',
  '/Estimativas_2003/UF_Municipio.zip',
  '/Estimativas_2004/UF_Municipio.zip',
  '/Estimativas_2005/UF_Municipio.zip',
  '/Estimativas_2006/UF_Municipio.zip',
  'https://www.ibge.gov.br/home/estatistica/populacao/contagem2007/popmunic2007layoutTCU14112007.xls', # contagem 2007
  '/Estimativas_2008/UF_Municipio.zip',
  '/Estimativas_2009/UF_Municipio.zip',
  '', # 2010 census
  '/Estimativas_2011/POP2011_DOU.zip',
  '/Estimativas_2012/estimativa_2012_DOU_28_08_2012_xls.zip',
  '/Estimativas_2013/estimativa_2013_dou_xls.zip',
  '/Estimativas_2014/estimativa_dou_2014_xls.zip',
  '/Estimativas_2015/estimativa_dou_2015_20150915.xls',
  '/Estimativas_2016/estimativa_dou_2016_20160913.xlsx',
  '/Estimativas_2017/estimativa_dou_2017.xls',
  '/Estimativas_2018/estimativa_dou_2018_20181019.xls',
  '/Estimativas_2019/estimativa_dou_2019.xls',
  '/Estimativas_2020/estimativa_dou_2020.xls',
  '/Estimativas_2021/estimativa_dou_2021.xls',
  'https://ftp.ibge.gov.br/Censos/Censo_Demografico_2022/Previa_da_Populacao/POP2022_Municipios.xls'
)
link_prepend <- 'https://ftp.ibge.gov.br/Estimativas_de_Populacao'
links_dou <- ifelse(grepl("^http", links_dou), links_dou, paste0(link_prepend, links_dou))
# skip_dou: NA == 2
skip_dou <- c(NA,
              4,4,4,4,4,4,3,4,4,NA,
              NA,NA,NA,NA,NA,NA,1,1,1,1,
              1,1)
# pop_origem: NA == Estimativa
pop_origem <- c(NA,
                NA,NA,NA,NA,NA,NA,"Contagem",NA,NA,"Censo",
                NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,
                NA,"Censo")
ibge.populacao.sources <- dplyr::tibble(ano=anos, links_dou, skip_dou, pop_origem)
#rm(anos, links_dou, skip_dou, pop_origem, link_prepend)

## update data

##save(ibge.populacao.sources, file = "data/populacao-sources.RData")
##usethis::use_data(ibge.populacao.sources)
usethis::use_data(ibge.populacao.sources, overwrite = TRUE)
readr::write_csv(ibge.populacao.sources, "doc/populacao_sources.csv")
