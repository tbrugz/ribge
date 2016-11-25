
ribge R package
======

[R](https://www.r-project.org/) package for (down)loading data from [IBGE](http://www.ibge.gov.br/) (Instituto Brasileiro de Geografia e Estatística)


data: population
----

Yearly population for municipalities. See:
[Estimativas de População - 2015 - DOU](http://www.ibge.gov.br/home/estatistica/populacao/estimativa2015/estimativa_dou.shtm) &
[estatísticas/Estimativas de Populacao](http://downloads.ibge.gov.br/downloads_estatisticas.htm?caminho=/Estimativas_de_Populacao/) (or ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/)

2007 data comes from [Contegem da população](https://pt.wikipedia.org/wiki/Contagem_de_popula%C3%A7%C3%A3o): see http://www.ibge.gov.br/home/estatistica/populacao/contagem2007/

2010 [Census data](https://pt.wikipedia.org/wiki/Censo_demogr%C3%A1fico) gathered from: http://www.sidra.ibge.gov.br/bda/tabela/listabl.asp?z=t&o=25&i=P&c=1378

years avaiable: 2000-2016


data: GNP (gross national product) / PIB (produto interno bruto)
----

Municipalities GNP. See: [Produto Interno Bruto dos Municípios](http://www.ibge.gov.br/home/estatistica/economia/pibmunicipios/) & [Produto Interno Bruto dos Municípios 2011](http://www.ibge.gov.br/home/estatistica/economia/pibmunicipios/2011/default_base.shtm)

years avaiable: 1999-2013


data: cartography/territory
----

Municipalities area. See: [Cartografia » Área Territorial Brasileira](http://www.ibge.gov.br/home/geociencias/cartografia/default_territ_area.shtm)


data: price indexes & GDP deflator
----

INPC index. See: [Índice de preços » INPC - Índice Nacional de Preços ao Consumidor](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=53&no=11)

years avaiable: 1991+

IPCA index. See: [Índice de preços » IPCA - Índice Nacional de Preços ao Consumidor Amplo](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=52&no=11)

years avaiable: 1991+

SINAPI construction price index. See: [Sistema Nacional de Pesquisa de Custos e Índices da Construção Civil](http://www.ibge.gov.br/home/estatistica/indicadores/precos/sinapi/) & [índice de preços » índices da construção civil](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=39&no=11)

years avaiable: 1986+

GDP deflator. See: [sistema de contas nacionais » contas nacionais](http://seriesestatisticas.ibge.gov.br/lista_tema.aspx?op=0&de=41&no=12)

years avaiable: 1948+


install & load
-----

```
# install.packages("devtools")
devtools::install_github("tbrugz/ribge")
library(ribge)
```


usage examples
-----

population, main usage:

```
pop2000 <- ibge.load.populacao(2000)
# ...
pop2007 <- ibge.load.populacao(2007)
pop2008 <- ibge.load.populacao(2008)
pop2009 <- ibge.load.populacao(2009)
pop2010 <- ibge.load.populacao(2010)
pop2011 <- ibge.load.populacao(2011, dir="/tmp")
# ...
pop2016 <- ibge.load.populacao(2016)

```

GNP (PIB) example:

```
pib2013 <- pib.load(2013)
```

inflation & GDP deflator:

```
inpc2015 <- inflacao.load.inpc(2015)
ipca2015 <- inflacao.load.ipca(2015)
sinapi2015 <- inflacao.load.sinapi(2015)
deflatorpib <- inflacao.load.deflatorpib()
```

municipalities area:

```
munArea <- territorio.area.load()
```

TSE municipalities:

```
tsemun <- tse.load.municipios()
# mapping between ibge & tse municipalities codes
data("municipioIbgeTseMap")
```

population, old way:

```
f2008 <- ibge.download.populacao.estimativa(2008)
df2008 <- ibge.load.populacao.estimativa(f2008, 4)

f2009 <- ibge.download.populacao.estimativa(2009)
df2009 <- ibge.load.populacao.estimativa(f2009, 4)

f2011 <- ibge.download.populacao.estimativa(2011)
df2011 <- ibge.load.populacao.estimativa(f2011)

f2012 <- ibge.download.populacao.estimativa(2012)
df2012 <- ibge.load.populacao.estimativa(f2012)

f2013 <- ibge.download.populacao.estimativa(2013)
df2013 <- ibge.load.populacao.estimativa(f2013)

f2014 <- ibge.download.populacao.estimativa(2014)
df2014 <- ibge.load.populacao.estimativa(f2014)

f2015 <- ibge.download.populacao.estimativa(2015)
df2015 <- ibge.load.populacao.estimativa(f2015)
```


end notes
-------

license: [GPL-3](http://www.gnu.org/licenses/gpl-3.0.en.html)
