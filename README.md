
ribge R package
-----

[R](https://www.r-project.org/) package for (down)loading data from [IBGE](http://www.ibge.gov.br/) (Instituto Brasileiro de Geografia e Estatística)

For now, only (down)loads yearly population estimation for municipalities. See:
[Estimativas de População - 2015 - DOU](http://www.ibge.gov.br/home/estatistica/populacao/estimativa2015/estimativa_dou.shtm),
[estatísticas/Estimativas de Populacao](http://downloads.ibge.gov.br/downloads_estatisticas.htm?caminho=/Estimativas_de_Populacao/),


usage examples
-----

```
f2008 <- ibge.download.populacao.estimativa(2008)
df2008 <- ibge.load.df(f2008, 4)

f2009 <- ibge.download.populacao.estimativa(2009)
df2009 <- ibge.load.df(f2009, 4)

f2011 <- ibge.download.populacao.estimativa(2011)
df2011 <- ibge.load.df(f2011)

f2012 <- ibge.download.populacao.estimativa(2012)
df2012 <- ibge.load.df(f2012)

f2013 <- ibge.download.populacao.estimativa(2013)
df2013 <- ibge.load.df(f2013)

f2014 <- ibge.download.populacao.estimativa(2014)
df2014 <- ibge.load.df(f2014)

f2015 <- ibge.download.populacao.estimativa(2015)
df2015 <- ibge.load.df(f2015)
```


end notes
-------

license: [GPL-3](http://www.gnu.org/licenses/gpl-3.0.en.html)
