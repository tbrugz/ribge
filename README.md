
ribge R package
-----

[R](https://www.r-project.org/) package for (down)loading data from [IBGE](http://www.ibge.gov.br/) (Instituto Brasileiro de Geografia e Estatística)

For now, only (down)loads yearly population estimation for municipalities. See:
[Estimativas de População - 2015 - DOU](http://www.ibge.gov.br/home/estatistica/populacao/estimativa2015/estimativa_dou.shtm) &
[estatísticas/Estimativas de Populacao](http://downloads.ibge.gov.br/downloads_estatisticas.htm?caminho=/Estimativas_de_Populacao/) (or ftp://ftp.ibge.gov.br/Estimativas_de_Populacao/)

2007 data comes from [Contegem da população](https://pt.wikipedia.org/wiki/Contagem_de_popula%C3%A7%C3%A3o): see http://www.ibge.gov.br/home/estatistica/populacao/contagem2007/

2010 [Census data](https://pt.wikipedia.org/wiki/Censo_demogr%C3%A1fico) gathered from: http://www.sidra.ibge.gov.br/bda/tabela/listabl.asp?z=t&o=25&i=P&c=1378

install
-----

```
# install.packages("devtools")
devtools::install_github("tbrugz/ribge")
```

usage examples
-----

main usage:

```
df2000 <- ibge.load.populacao(2000)
# ...
df2007 <- ibge.load.populacao(2007)
df2008 <- ibge.load.populacao(2008)
df2009 <- ibge.load.populacao(2009)
df2010 <- ibge.load.populacao(2010)
df2011 <- ibge.load.populacao(2011, dir="/tmp")
# ...
df2016 <- ibge.load.populacao(2016)

```

old way:

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
