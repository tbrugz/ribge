
id4join <- function(nomejoin) {
  nomejoin <- stringi::stri_trans_general(toupper(nomejoin), "Latin-ASCII")
  nomejoin <- gsub(" DOS "," DO ", nomejoin)
  #nomejoin <- gsub("D[E|O] ","D", nomejoin)
  nomejoin <- gsub("[ -]D[E |OS |O |']","", nomejoin)
  nomejoin <- gsub("'|[ ]+|-","", nomejoin)
  nomejoin <- gsub("O+","O", nomejoin)
  nomejoin <- gsub("L+","L", nomejoin)
  nomejoin <- gsub("Z","S", nomejoin)

  nomejoin <- gsub("Y","I", nomejoin)
  nomejoin <- gsub("ASSU","ACU", nomejoin)
  nomejoin <- gsub("AGUABRANCAAMAPARI","PEDRABRANCAAMAPARI", nomejoin)
  nomejoin <- gsub("QUIN","QUI", nomejoin)
  nomejoin <- gsub("SANTAREM","JOCACLAUDINO", nomejoin)
  nomejoin <- gsub("MINGOSPOMBAL","MINGOS", nomejoin)
  nomejoin <- gsub("MORAIS","MORAES", nomejoin)
  nomejoin <- gsub("PAGE","PAJE", nomejoin)
  nomejoin <- gsub("FLORINEA","FLORINIA", nomejoin)
  nomejoin <- gsub("SAOVALERIODANATIVIDADE","SAOVALERIO", nomejoin)
  nomejoin <- gsub("JANUARIOCICCO","BOASAUDE", nomejoin)
  nomejoin <- gsub("AUGUSTOSEVERO","CAMPOGRANDE", nomejoin)
}

f <- tse.load.municipios()
#f$nomejoin <- stri_trans_general(f$nome, "Latin-ASCII")
#f$nomejoin <- gsub("D[E|O] ","D", f$nomejoin)
#f$nomejoin <- gsub("'|[ ]+|-","", f$nomejoin)
#f$nomejoin <- gsub("O+","O", f$nomejoin)
f$nomejoin <- id4join(f$nome_municipio)

df2016 <- ibge.load.populacao(2016)
#df2016$nomejoin <- stri_trans_general(toupper(df2016$nome_munic), "Latin-ASCII")
#df2016$nomejoin <- gsub("D[E|O] ","D", df2016$nomejoin)
#df2016$nomejoin <- gsub("'|[ ]+|-","", df2016$nomejoin)
#df2016$nomejoin <- gsub("O+","O", df2016$nomejoin)
df2016$nomejoin <- id4join(df2016$nome_munic)

f$z1<-paste0(f$uf, f$nomejoin)
f$z2<-paste0(f$uf, f$nome_municipio)
df2016$z1<-paste0(df2016$uf, df2016$nomejoin)
df2016$z2<-paste0(df2016$uf, df2016$nome_munic)
#length(unique( f$nome ))
#length(unique( f$nomejoin ))
length(unique( f$z1 ))
length(unique( f$z2 ))
length(unique( df2016$z1 ))
length(unique( df2016$z2 ))
df.len <- 5570
if(length(unique( f$z1 )) != df.len) {
  warning(paste0("f: tse: unique uf+nomejoin should be == ", df.len," but is ",length(unique( f$z1 ))))
}
if(length(unique( df2016$z1 )) != df.len) {
  warning(paste0("df2016: ibge: unique uf+nomejoin should be == ",df.len," but is ",length(unique( df2016$z1 ))))
}

#$f %>% group_by(z1) %>% count(sum = mean(Sepal.Length))
count(f, z1) %>% arrange(desc(n))

#
merged <- full_join(df2016, f, by = c("uf", "nomejoin"))
#
z1 <- merged[is.na(merged$cod_municipio_tse),]
z2 <- merged[is.na(merged$cod_municipio),]
z3 <- rbind(z1, z2) %>% arrange(nomejoin)
print( paste("z3 nrow:", nrow(z3)) )

#
# full_join errors (after upper()):
# 49+, 49+
#
# after removing accents:
# 35+, 35+
#
# after "d[e|o] "->"d" ; "d'" -> "d" ; "'" -> "" ; "[ ]+" -> "" ; "-" -> "":
# 18+, 18+
#
# after L+, Z->S, ...
# 12+, 12-

municipioIbgeTseMap <- select(merged, uf, cod_municipio, cod_municipio_tse)


###
# create 'doc/ibge-tse-map.csv'
###

library(dplyr)
library(readr)
pop2016 <- populacao_municipios(2016) %>% select(nome_munic, cod_municipio)
colnames(pop2016)[1] <- "nome_municipio_ibge"
ibgeTseMap <- inner_join(municipioIbgeTseMap, pop2016, by="cod_municipio")
colnames(ibgeTseMap)[2] <- "cod_municipio_ibge"

# add TSE municipality name
tsemun <- tse_municipios() %>% select(cod_municipio_tse, nome_municipio)
colnames(tsemun)[2] <- "nome_municipio_tse"
ibgeTseMap <- inner_join(ibgeTseMap, tsemun, by="cod_municipio_tse")

write_csv(ibgeTseMap, path = "doc/ibge-tse-map.csv")
