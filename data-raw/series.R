
library(rvest)

#url <- 'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=1'
urls <- c(
  'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=1&nome=brasil',
  'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=2&nome=uf',
  'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=3&nome=grandes-regioes',
  'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=4&nome=regioes-metropolitanas',
  'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=5&nome=capitais',
  'http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=1&no=6&nome=municipios'
)

read_tt <- function (url) {
  message(paste0("downloading: ", url))
  series <- read_html(url)

  t <- series %>%
    html_nodes("table") %>%
    html_table()

  return( t[[1]] )
}

#df1 <- read_tt(url)
bigdf <- data_frame()
#dflist <- list()

for (u in urls) {
  df <- read_tt(u)
  #bigdf <- union(bigdf, df)
  bigdf <- bind_rows(bigdf, df)
  #dflist <- c(dflist, df)
}

#Código, Séries Cadastradas, Periodicidade, Período
colnames(bigdf) <- c("codigo", "descricao", "periodicidade", "periodo")
#bigdf[big]
seriesEstatisticas <- filter(bigdf, codigo != "Código") %>% arrange(codigo) %>% distinct()

#devtools::use_data(seriesEstatisticas)
