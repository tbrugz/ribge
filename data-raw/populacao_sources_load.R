
anos <- c(2000,
          2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,
          2011,2012,2013,2014,2015,2016)
links_dou <- c(
  '/Estimativas_2000/UF_Municipio.zip',
  '/Estimativas_2001/UF_Municipio.zip',
  '/Estimativas_2002/UF_Municipio.zip',
  '/Estimativas_2003/UF_Municipio.zip',
  '/Estimativas_2004/UF_Municipio.zip',
  '/Estimativas_2005/UF_Municipio.zip',
  '/Estimativas_2006/UF_Municipio.zip',
  'http://www.ibge.gov.br/home/estatistica/populacao/contagem2007/popmunic2007layoutTCU14112007.xls', # contagem 2007
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
link_prepend <- 'ftp://ftp.ibge.gov.br/Estimativas_de_Populacao'
links_dou <- ifelse(grepl("^http|ftp", links_dou), links_dou, paste0(link_prepend, links_dou))
# skip_dou: NA == 2
skip_dou <- c(NA,
              4,4,4,4,4,4,3,4,4,NA,
              NA,NA,NA,NA,NA,NA)
# pop_origem: NA == Estimativa
pop_origem <- c(NA,
                NA,NA,NA,NA,NA,NA,"Contagem",NA,NA,"Censo",
                NA,NA,NA,NA,NA,NA)
ibge.populacao.sources <- dplyr::data_frame(ano=anos, links_dou, skip_dou, pop_origem)
#rm(anos, links_dou, skip_dou, pop_origem, link_prepend)
#save(ibge.populacao.sources, file = "data/populacao-sources.RData")

devtools::use_data(ibge.populacao.sources)
