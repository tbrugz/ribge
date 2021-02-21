
library(dplyr)
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

urlnomes <- c(
  'BR', # brasil
  'UF', # unidades federativas
  'GR', # grandes-regioes
  'RM', # regioes-metropolitanas
  'CAP', # capitais
  'MUN' # municipios
)

links <- tibble(url= urls, nivel= urlnomes)

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

#for(i in 1:nrow(links)) {
#  u <- links[i,]
#  print(u$nivel)
#}

#for (u in links) {
for(i in 1:nrow(links)) {
  u <- links[i,]
  df <- read_tt(u$url)
  df$nivel <- u$nivel
  #bigdf <- union(bigdf, df)
  bigdf <- bind_rows(bigdf, df)
  #dflist <- c(dflist, df)
}

#Código, Séries Cadastradas, Periodicidade, Período
colnames(bigdf) <- c("codigo", "descricao", "periodicidade", "periodo", "nivel")
#bigdf[big]
#seriesEstatisticas1 <- filter(bigdf, codigo != "Código") %>% arrange(codigo, nivel) %>% distinct()

seriesEstatisticas <- filter(bigdf, codigo != "Código") %>% arrange(codigo, nivel) %>%
  group_by(codigo, descricao, periodicidade, periodo) %>%
  summarise(niveis = paste(nivel, collapse=",")) %>% arrange(codigo) %>% ungroup()

usethis::use_data(seriesEstatisticas, overwrite = TRUE)
