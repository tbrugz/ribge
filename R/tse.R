
tse.load.municipios <- function(dir=NULL) {
  url <- "http://www.tse.jus.br/arquivos/tse-lista-de-municipios-do-cadastro-da-justica-eleitoral/at_download/file"
  file <- util.downloadAndUnzip(url, dir=dir, file="lista_municipios.zip")
  loc <- readr::locale(encoding = "ISO-8859-1")
  #print(file)
  df <- readr::read_csv2(file, locale = loc)
  names(df) <- c("codigo_munic_tse", "uf", "nome")
  df
}

id4join <- function(nomejoin) {
  nomejoin <- stri_trans_general(toupper(nomejoin), "Latin-ASCII")
  nomejoin <- gsub(" DOS "," DO ", nomejoin)
  #nomejoin <- gsub("D[E|O] ","D", nomejoin)
  nomejoin <- gsub("[ -]D[E |OS |O |']","", nomejoin)
  nomejoin <- gsub("'|[ ]+|-","", nomejoin)
  nomejoin <- gsub("O+","O", nomejoin)
  nomejoin <- gsub("L+","L", nomejoin)
  nomejoin <- gsub("Z","S", nomejoin)
}
