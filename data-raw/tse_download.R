
# municipalities source:
# https://cdn.tse.jus.br/estatistica/sead/odsele/detalhe_votacao_munzona/detalhe_votacao_munzona_2020.zip
# size: 1,4mb
# extract detalhe_votacao_munzona_2020_BRASIL.csv - 3,7mb

# municipalities alternative source:
# https://cdn.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_ATUAL.zip
# size: 34,9mb
# extract perfil_eleitorado_ATUAL.csv - 640mb

###

library(dplyr)
library(httr)

loc <- readr::locale(encoding = "ISO-8859-1")
user_agent <- "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36";
#options(HTTPUserAgent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36")
#options(timeout = 900)

#https://cdn.tse.jus.br/estatistica/sead/odsele/detalhe_votacao_munzona/detalhe_votacao_munzona_2024.zip
#https://cdn.tse.jus.br/estatistica/sead/odsele/detalhe_votacao_secao/detalhe_votacao_secao_2024.zip

#download.file("https://cdn.tse.jus.br/estatistica/sead/odsele/detalhe_votacao_munzona/detalhe_votacao_munzona_2020.zip", "detalhe_votacao_munzona_2020.zip", method = "libcurl", extra = "-L -A 'Mozilla/5.0'");
GET(url = "https://cdn.tse.jus.br/estatistica/sead/odsele/detalhe_votacao_munzona/detalhe_votacao_munzona_2022.zip",
    write_disk("detalhe_votacao_munzona_2022.zip", overwrite = TRUE),
    user_agent(user_agent),
    config(ssl_verifypeer = FALSE)
    )

df <- readr::read_csv2(
  unz(description = "detalhe_votacao_munzona_2022.zip", filename = "detalhe_votacao_munzona_2022_BRASIL.csv"),
  locale = loc)

# SG_UF,SG_UE,NM_UE,CD_MUNICIPIO,NM_MUNICIPIO,NR_ZONA

zonas <- df %>%
  select("SG_UF","SG_UE","NM_UE","CD_MUNICIPIO","NM_MUNICIPIO","NR_ZONA") %>%
  distinct()

#mun0 <- df %>% select("SG_UF","SG_UE","NM_UE","CD_MUNICIPIO","NM_MUNICIPIO") %>% distinct()
tseMunicipios <- df %>%
  select("SG_UF","CD_MUNICIPIO","NM_MUNICIPIO") %>%
  distinct()

# add: Brasilia
# add: Fernando de Noronha
# https://noticias.uol.com.br/eleicoes/2020/11/13/fernando-de-noronha-nao-tem-eleicao-para-prefeito.htm
#tseMunicipios2020 <- tseMunicipios2020 %>%
#  add_row(SG_UF="DF",CD_MUNICIPIO="97012",NM_MUNICIPIO="BRASÍLIA") %>%
#  add_row(SG_UF="PE",CD_MUNICIPIO="30015",NM_MUNICIPIO="FERNANDO DE NORONHA")

tseMunicipios <- tseMunicipios %>%
  arrange(CD_MUNICIPIO)

names(tseMunicipios) <- c("uf", "cod_municipio_tse", "nome_municipio_tse")

print( paste("num municipios BR =", count(filter(tseMunicipios, uf != 'ZZ'))) )

##readr::write_csv(tseMunicipios, file = "doc/tse-municipios.csv")

##usethis::use_data(tseMunicipios, overwrite = TRUE)

####

#download.file("https://cdn.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_ATUAL.zip", "perfil_eleitorado_ATUAL.zip");
GET(url = "https://cdn.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_ATUAL.zip",
    write_disk("perfil_eleitorado_ATUAL.zip", overwrite = TRUE),
    user_agent(user_agent),
    config(ssl_verifypeer = FALSE)
)

zonas <- readr::read_csv2(
  unz(description = "perfil_eleitorado_ATUAL.zip", filename = "perfil_eleitorado_ATUAL.csv"),
  #"perfil_eleitorado_ATUAL.head.csv",
  locale = loc) %>%
  select("SG_UF","CD_MUNICIPIO","NM_MUNICIPIO","NR_ZONA") %>%
  distinct()

# SG_UF,CD_MUNICIPIO,NM_MUNICIPIO,NR_ZONA
# "DT_GERACAO";"HH_GERACAO";"ANO_ELEICAO";"SG_UF";"CD_MUNICIPIO";"NM_MUNICIPIO";"CD_MUN_SIT_BIOMETRIA";"DS_MUN_SIT_BIOMETRIA";"NR_ZONA";"CD_GENERO";"DS_GENERO";"CD_ESTADO_CIVIL";"DS_ESTADO_CIVIL";"CD_FAIXA_ETARIA";"DS_FAIXA_ETARIA";"CD_GRAU_ESCOLARIDADE";"DS_GRAU_ESCOLARIDADE";"QT_ELEITORES_PERFIL";"QT_ELEITORES_BIOMETRIA";"QT_ELEITORES_DEFICIENCIA";"QT_ELEITORES_INC_NM_SOCIAL"

names(zonas) <- c("uf", "cod_municipio_tse", "nome_municipio_tse", "nr_zona")

zonas$cod_municipio_tse <- stringr::str_pad(zonas$cod_municipio_tse, 5, pad="0")

zonas <- zonas %>%
  arrange(cod_municipio_tse, nr_zona)

tseMunicipios <- zonas %>%
  #filter(uf != "ZZ") %>%
  select(uf, cod_municipio_tse, nome_municipio_tse) %>%
  distinct() %>%
  arrange(cod_municipio_tse)

#View(filter(zonas, uf == "ZZ"))

#readr::write_csv(tseMunicipios, file = "doc/tse-municipios.csv")
#usethis::use_data(tseMunicipios, overwrite = TRUE)

#readr::write_csv(zonas, file = "doc/tse-zonas-eleitorais.csv")
