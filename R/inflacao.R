
# PC41	INPC - índice geral e grupos de produtos e serviços (% no mês)	Mensal	1991/jan-1999/jul
# PC40	INPC - índice geral e grupos de produtos e serviços (% no mês)	Mensal	1999/ago-2006/jun
# PC49	INPC - índice geral e grupos de produtos e serviços (% no mês)	Mensal	2006/jul-2011/dez
# PC52	INPC - índice geral e grupos de produtos e serviços (% no mês)	Mensal	2012/jan-2016/jul
# http://seriesestatisticas.ibge.gov.br/exportador.aspx?arquivo=PC52_BR_PERC.csv
#
#' Returns a \code{data.frame} with montly INPC index for the requested year
#'
#' @param ano year (1991+) of requested data
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- precos_inpc(2015)
#' }
#' @export
precos_inpc <- function(ano, dir=NULL) {
  if(ano<1991) {
    stop(paste("data not avaiable for year",ano))
  }
  resource <- ifelse(ano<=1999, "PC41_BR_PERC",
              ifelse(ano<=2006, "PC40_BR_PERC",
              ifelse(ano<=2011, "PC49_BR_PERC",
              #ifelse(ano<=2016, "PC52_BR_PERC",
              "PC52_BR_PERC")))
  # FIXME: what about boundary years (1999 & 2006)? (2011/2012 is not a problem...)
  file <- util.downloadSeries(resource, dir = dir)

  loc <- readr::locale(decimal_mark = ",")
  df <- readr::read_tsv(file, locale = loc)
  df <- inflacao.transform.df(df)
  df[df$ano==ano,]
}

inflacao.load.inpc <- precos_inpc

#' @import tidyr
inflacao.transform.df.data <- function(df) {
  df <- separate(df, data, c("mes_str", "ano"))
  df$ano <- ifelse(as.integer(df$ano)>50 , as.integer(df$ano)+1900 , as.integer(df$ano)+2000 )
  df$mes <- vswitch(df$mes_str, jan=1, fev=2, mar=3, abr=4, mai=5, jun=6,
                    jul=7, ago=8, set=9, out=10, nov=11, dez=12, -1)
  df
}

#' @import tidyr
#' @import dplyr
inflacao.transform.df <- function(df) {
  df$OPCAO[1] <- "0,Indice geral"
  df <- separate(df, OPCAO, c("categoria", "categoria_str"), sep = ",")
  df <- select(df, -Brasil) %>%
    gather(data, valor, -categoria, -categoria_str)

  df <- inflacao.transform.df.data(df)

  df$categoria <- as.integer(df$categoria)
  #df[df$ano==ano,c(4,6,1,2,5)]
  df[,c(4,6,1,2,5)]
}

#IA47	IPCA - índice geral e grupos de produtos e serviços (% no mês)	Mensal	1991/jan - 1999/jul
#IA48	IPCA - índice geral e grupos de produtos e serviços (% no mês)	Mensal	1999/ago-2006/jun
#IA55	IPCA - índice geral e grupos de produtos e serviços (% no mês)	Mensal	2006/jul-2011/dez
#IA59	IPCA - índice geral e grupos de produtos e serviços (% no mês)	Mensal	2012/jan-2016/jul
#describeIn precos_inpc Returns a \code{data.frame} with montly IPCA index for the requested year
#
#' Returns a \code{data.frame} with montly IPCA index for the requested year
#'
#' @param ano year (1991+) of requested data
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- precos_ipca(2015)
#' }
#' @export
precos_ipca <- function(ano, dir=NULL) {
  if(ano<1991) {
    stop(paste("data not avaiable for year",ano))
  }
  resource <- ifelse(ano<=1999, "IA47_BR_PERC",
              ifelse(ano<=2006, "IA48_BR_PERC",
              ifelse(ano<=2011, "IA55_BR_PERC",
              "IA59_BR_PERC")))
  # FIXME: what about boundary years (1999 & 2006)? (2011/2012 is not a problem...)
  file <- util.downloadSeries(resource, dir = dir)

  loc <- readr::locale(decimal_mark = ",")
  df <- readr::read_tsv(file, locale = loc)
  #return(df)
  df <- inflacao.transform.df(df)
  df[df$ano==ano,]
}

inflacao.load.ipca <- precos_ipca

# SI7_BR_PERC - índice de preços » índices da construção civil » Custo médio m² em moeda corrente - variação (% no mês)
#
#' Returns a \code{data.frame} with montly SINAPI index for the requested year
#'
#' @param ano year (1986+) of requested data
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- precos_sinapi(2015)
#' }
#' @import tidyr
#' @export
precos_sinapi <- function(ano, dir=NULL) {
  if(ano<1986) {
    stop(paste("data not avaiable for year",ano))
  }
  resource <- "SI7_BR_PERC"
  file <- util.downloadSeries(resource, dir = dir)

  loc <- readr::locale(decimal_mark = ",")
  df <- readr::read_tsv(file, locale = loc)

  # transform
  df <- select(df, -Brasil) %>%
    gather(data, valor)
  df <- inflacao.transform.df.data(df)

  # return
  df[df$ano==ano,c(2,4,3)]
}

inflacao.load.sinapi <- precos_sinapi

# http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=41&no=12
# SCN54	Deflator do Produto Interno Bruto	Anual	1948-2014
#
#' Returns a \code{data.frame} with yearly GDP deflator (year 1948+)
#'
#' @param dir directory for temporary files
#' @return the \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- precos_deflatorpib()
#' }
#' @import tidyr
#' @export
precos_deflatorpib <- function(dir=".") {
  resource <- "SCN54_BR_PERC"
  file <- util.downloadSeries(resource, dir = dir)
  loc <- readr::locale(decimal_mark = ",")
  df <- readr::read_tsv(file, locale = loc)
  df <- select(df, -Brasil) %>% gather(ano_str, valor)
  df$ano <- as.integer(stringr::str_extract(df$ano_str, "([\\d\\.]+)"))
  df[,c(3,1,2)]
}

inflacao.load.deflatorpib <- precos_deflatorpib
