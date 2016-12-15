
#' @export
tse_municipios <- function(dir=NULL) {
  url <- "http://www.tse.jus.br/arquivos/tse-lista-de-municipios-do-cadastro-da-justica-eleitoral/at_download/file"
  file <- util.downloadAndUnzip(url, dir=dir, file="lista_municipios.zip")
  loc <- readr::locale(encoding = "ISO-8859-1")
  #print(file)
  df <- readr::read_csv2(file, locale = loc)
  names(df) <- c("cod_municipio_tse", "uf", "nome_municipio")
  df
}

tse.load.municipios <- tse_municipios

#' @export
id4join <- function(nomejoin) {
  nomejoin <- stringi::stri_trans_general(toupper(nomejoin), "Latin-ASCII")
  nomejoin <- gsub(" DOS "," DO ", nomejoin)
  #nomejoin <- gsub("D[E|O] ","D", nomejoin)
  nomejoin <- gsub("[ -]D[E |OS |O |']","", nomejoin)
  nomejoin <- gsub("'|[ ]+|-","", nomejoin)
  nomejoin <- gsub("O+","O", nomejoin)
  nomejoin <- gsub("L+","L", nomejoin)
  nomejoin <- gsub("Z","S", nomejoin)
}
