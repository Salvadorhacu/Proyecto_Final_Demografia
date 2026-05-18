# Proyecto final 9219: Michoacán, una exploración demográfica

## Descripción

Este proyecto construye tablas de vida para Michoacán de Ocampo en los años 2010, 2019 y 2021, separadas por sexo. El objetivo es estimar la esperanza de vida al nacer y analizar la evolución de la mortalidad, con especial atención al impacto de la COVID-19 en 2021.

## Integrantes

-   Salvador Halave Cubillo
-   Angel Gabriel Camacho Cruz

## Estructura del repositorio

``` text
Proyecto_Final_Michoacan/
├── Proyecto_Final_Demografia.qmd
├── Proyecto_Final_Demografia.pdf
├── README.md
├── data/
├── script/
├── output/
└── resultados_tablas_vida/
```

## Carpetas

-   `data/`: contiene las bases de población y defunciones utilizadas.
-   `script/`: contiene el código para limpiar datos, calcular APV, construir tablas de vida, generar gráficas y exportar resultados.
-   `output/`: contiene las gráficas generadas para el informe.
-   `resultados_tablas_vida/`: contiene las seis tablas de vida finales en formato `.csv` y sus versiones visuales.

## Fuentes de datos

Los datos fueron obtenidos de INEGI.

-   **Población:** Censo de Población y Vivienda 2010 y 2020.
-   **Defunciones:** Estadísticas de Defunciones Registradas.

Las defunciones se trabajaron por año de ocurrencia, edad, sexo y entidad de residencia habitual.

## Metodología

El procedimiento general fue:

1.  Limpieza de población censal 2010 y 2020.
2.  Prorrateo de población con edad no especificada.
3.  Limpieza de defunciones registradas.
4.  Prorrateo de defunciones con sexo no especificado.
5.  Agrupación de defunciones por año de referencia.
6.  Cálculo de APV mediante crecimiento exponencial.
7.  Cálculo de tasas centrales de mortalidad.
8.  Construcción de tablas de vida.
9.  Cálculo de esperanza de vida al nacer.
10. Generación de gráficas y tablas finales.

Para suavizar fluctuaciones en las defunciones por edad y sexo, los años de referencia se construyeron así:

``` text
2010 = promedio de 2009, 2010 y 2011
2019 = promedio de 2018 y 2019
2021 = promedio de 2020, 2021 y 2022
```

## Cómo reproducir el proyecto

En RStudio, correr los scripts en este orden:

``` r
source("script/00_config.R")
source("script/01_poblacion.R")
source("script/02_defunciones.R")
source("script/03_apv.R")
source("script/04_tablas_vida.R")
source("script/05_graficas.R")
source("script/06_exportar_tablas_vida.R")
source("script/07_tablas_vida_visuales.R")
source("script/08_diagrama_flujo.R")
```

Después se puede renderizar el archivo:

``` text
Proyecto_Final_Demografia.qmd
```

para generar el PDF del informe.

## Resultados principales

El proyecto genera seis tablas de vida:

``` text
2010 Hombres
2010 Mujeres
2019 Hombres
2019 Mujeres
2021 Hombres
2021 Mujeres
```

Las tablas finales se encuentran en:

``` text
resultados_tablas_vida/
```

Las gráficas principales se encuentran en:

``` text
output/
```

## Gráficas principales

![Esperanza de vida al nacer](output/esperanza_vida_michoacan.png)

![Tasas centrales de mortalidad](output/mx_michoacan.png)

![Probabilidades de muerte](output/qx_michoacan.png)

![Sobrevivientes](output/lx_michoacan.png)

## Informe final

El informe final se encuentra en:

``` text
Proyecto_Final_Demografia.qmd
```

El PDF generado debe incluir:

-   contexto de Michoacán;
-   diagrama de flujo;
-   fórmulas utilizadas;
-   código usado para los cálculos;
-   cuadro de esperanza de vida al nacer;
-   gráficas;
-   análisis de resultados.

## Nota

El repositorio fue organizado para que el proyecto sea replicable. Los datos están en `data/`, el código en `script/`, las gráficas en `output/` y las tablas finales en `resultados_tablas_vida/`.
