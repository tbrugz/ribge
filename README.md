
ribge R package
======

[R](https://www.r-project.org/) package for (down)loading data from [IBGE](https://www.ibge.gov.br/) (Instituto Brasileiro de Geografia e Estatística)


data: population
----

Yearly population for municipalities. See:
[Estimativas de População](https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html) &
[estatísticas/Estimativas de Populacao](https://downloads.ibge.gov.br/downloads_estatisticas.htm?caminho=/Estimativas_de_Populacao/) (or ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/)

2007 data comes from [Contegem da população](https://pt.wikipedia.org/wiki/Contagem_de_popula%C3%A7%C3%A3o): see https://www.ibge.gov.br/estatisticas/sociais/populacao/9065-contagem-da-populacao.html

2010 [Census data](https://pt.wikipedia.org/wiki/Censo_demogr%C3%A1fico) gathered from: http://www.sidra.ibge.gov.br/bda/tabela/listabl.asp?z=t&o=25&i=P&c=1378

years avaiable: 2000-2020

see [doc/populacao_sources.csv](doc/populacao_sources.csv)


data: GDP (gross domestic product) / PIB (produto interno bruto)
----

Municipalities GDP. See: [Produto Interno Bruto dos Municípios](https://www.ibge.gov.br/estatisticas/economicas/contas-nacionais/9088-produto-interno-bruto-dos-municipios.html)

years avaiable: 1999-2018


data: cartography/territory
----

Municipalities area. See: [Geociências » Organização do território » Estrutura territorial » Áreas Territoriais](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/estrutura-territorial/15761-areas-dos-municipios.html)

years avaiable: 2015, 2020


data: price indexes & GDP deflator
----

INPC index. See: [Índice de preços » INPC - Índice Nacional de Preços ao Consumidor](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=53&no=11)

years avaiable: 1991+

IPCA index. See: [Índice de preços » IPCA - Índice Nacional de Preços ao Consumidor Amplo](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=52&no=11)

years avaiable: 1991+

SINAPI construction price index. See: [Sistema Nacional de Pesquisa de Custos e Índices da Construção Civil](https://www.ibge.gov.br/estatisticas/economicas/precos-e-custos/9270-sistema-nacional-de-pesquisa-de-custos-e-indices-da-construcao-civil.html) & [índice de preços » índices da construção civil](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=39&no=11)

years avaiable: 1986+

GDP deflator. See: [sistema de contas nacionais » contas nacionais](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=41&no=12)

years avaiable: 1948+


statistical series API (series estatísticas)
-----

Generic functions to gather data from [Séries Históricas e Estatísticas](http://seriesestatisticas.ibge.gov.br/) website.

See avaiable series codes on [doc/seriesEstatisticas.md](doc/seriesEstatisticas.md).


municipalities codes: ibge/tse mapping
-----

Mapping between IBGE's & TSE's municipalities names and codes.

Also avaiable as CSV file: [IBGE vs TSE municipalities mapping](doc/ibge-tse-map.csv).

See also [TSE's municipalities csv file](doc/tse-municipios.csv) and [TSE's municipalities with zones csv file](doc/tse-zonas-eleitorais.csv)


IPEA's & BCB's series (non-IBGE)
-----

Function to gather data from [Ipeadata](http://www.ipeadata.gov.br/)

Function to gather data from [BCB](http://www.bcb.gov.br/)'s [Time Series Management System](https://www.bcb.gov.br/?SGS)


install & load
-----

```
# install.packages("devtools")
devtools::install_github("tbrugz/ribge")
library(ribge)
```

build from sources & load
-----

```
# install.packages("devtools")
devtools::install_deps(".")
devtools::install(".")
library(ribge)
```


usage examples
-----

population, main usage:

```
pop2000 <- populacao_municipios(2000)
# ...
pop2007 <- populacao_municipios(2007)
pop2008 <- populacao_municipios(2008)
pop2009 <- populacao_municipios(2009)
pop2010 <- populacao_municipios(2010)
pop2011 <- populacao_municipios(2011, dir="/tmp")
# ...
pop2020 <- populacao_municipios(2020)

```

GDP (PIB) example:

```
# 18 variables
pib1999 <- pib_municipios(1999)
# ...
pib2009 <- pib_municipios(2009)

# 43 variables
pib2010 <- pib_municipios(2010)
# ...
pib2018 <- pib_municipios(2018)
```

inflation & GDP deflator:

```
inpc2015 <- precos_inpc(2015)
ipca2015 <- precos_ipca(2015)
sinapi2015 <- precos_sinapi(2015)
deflatorpib <- precos_deflatorpib()
```

municipalities area:

```
munArea <- area_municipios()              # defaults to 2020
munArea <- area_municipios(ano = 2015)
```

Gathering data from "séries estatísticas" (statistical series website):

```
# Efetivo dos rebanhos por tipo de rebanho
df <- series_estatisticas_carrega("PPM01_BR_ABS")
# Docentes com curso superior no ensino médio, rede pública e privada
df <- series_estatisticas_carrega("SEE10_BR_PERC", transpose = T)
# Taxa de desocupação das pessoas de 10 anos ou mais de idade, por sexo - todas localidades
df <- series_estatisticas_carrega_todas_localidades("PE62_RM_PERC", transpose = T)

# Ver `seriesEstatisticas` para prefixos de códigos:
seriesEstatisticas
View(seriesEstatisticas)
```

TSE municipalities:

```
tsemun <- tse_municipios()
# mapping between ibge & tse municipalities codes
data("municipioIbgeTseMap")
```

Ipeadata series:

```
# series 37667: real minimum wage / salário mínimo real
df <- ipea_serie_carrega(37667)
```

Brazil's central bank (BCB) series:

```
# series 193: Fipe IPC price index / Índice de Preços ao Consumidor da Fipe
df <- bcb_serie_carrega(193)
```


end notes
-------

license: [GPL-3](http://www.gnu.org/licenses/gpl-3.0.en.html)
