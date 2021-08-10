
#' Returns a \code{data.frame} with municipalities from TSE (Tribunal Superior Eleitoral)
#'
#' @return the \code{data.frame}
#' @examples
#' \dontrun{
#'   df <- tse_municipios()
#' }
#' @export
tse_municipios <- function() {
  force(tseMunicipios)
}

#-- export
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
