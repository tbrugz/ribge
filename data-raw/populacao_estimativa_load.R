
library(readr)
library(tidyr)

# loads censo-2010-munic-habitantes.csv and writes censo-2010-munic-habitantes.RData

loc<-locale(encoding = "ISO-8859-1")
df<-read_csv("data-raw/censo-2010-munic-habitantes.csv", col_names = c("munic", "populacao"), locale = loc)
df2<-separate(df, munic, c("codigo_munic_full", "nome_munic", "uf"), sep=" - ")

censo2010MunicHabitantes <- separate(df2, codigo_munic_full, c("codigo_uf", "codigo_munic"), sep=c(2))
censo2010MunicHabitantes <- censo2010MunicHabitantes[,c(4,1,2,3,5)]
censo2010MunicHabitantes$codigo_uf <- as.integer(censo2010MunicHabitantes$codigo_uf)
# order by codigo_munic or nome_munic?
#save(habitantes2010, file = "data/censo-2010-munic-habitantes.RData")
usethis::use_data(censo2010MunicHabitantes, overwrite = TRUE)
