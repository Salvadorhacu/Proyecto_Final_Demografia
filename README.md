# 🦋 Proyecto final 9219: Michoacán, una exploración demográfica

<p align="center">

<em>Construcción y análisis de tablas de vida para Michoacán de Ocampo</em>

</p>

<p align="center">

<strong>Universidad Nacional Autónoma de México</strong><br> Facultad de Ciencias<br> Curso: Demografía 9219

</p>

------------------------------------------------------------------------

## 🌎 Descripción general

Este repositorio contiene el proyecto final del curso de **Demografía 9219**, enfocado en el análisis de la mortalidad en **Michoacán de Ocampo** mediante la construcción de tablas de vida abreviadas.

El trabajo analiza los años **2010, 2019 y 2021**, separados por sexo, con el objetivo de comparar la evolución de la mortalidad antes y durante el periodo asociado a la pandemia de COVID-19.

A partir de los datos de población y defunciones, se calcularon indicadores demográficos como:

-   tasas centrales de mortalidad;
-   probabilidades de muerte;
-   función de sobrevivientes;
-   años persona vividos;
-   esperanza de vida al nacer.

El proyecto combina limpieza de datos, programación en R, visualización de resultados y elaboración de un informe final en Quarto.

------------------------------------------------------------------------

## 👥 Integrantes

-   Salvador Halave Cubillo
-   Angel Gabriel Camacho Cruz

------------------------------------------------------------------------

## 🎯 Objetivo del proyecto

Construir tablas de vida para Michoacán de Ocampo en los años **2010, 2019 y 2021**, diferenciando entre hombres y mujeres, para analizar los cambios en la mortalidad y en la esperanza de vida al nacer.

De manera particular, se busca identificar el efecto que tuvo el año **2021** en los indicadores de mortalidad, considerando el contexto de la pandemia de COVID-19.

------------------------------------------------------------------------

## 📊 Resultados principales

El proyecto genera seis tablas de vida:

``` text
2010 - Hombres
2010 - Mujeres
2019 - Hombres
2019 - Mujeres
2021 - Hombres
2021 - Mujeres
```

La esperanza de vida al nacer estimada fue:

| Año  | Hombres | Mujeres |
|------|--------:|--------:|
| 2010 |   73.51 |   79.32 |
| 2019 |   73.28 |   80.49 |
| 2021 |   69.02 |   77.26 |

Estos resultados muestran una caída importante en 2021, especialmente en hombres. En comparación con 2019, la esperanza de vida masculina disminuyó aproximadamente **4.26 años**, mientras que la femenina disminuyó cerca de **3.23 años**.

------------------------------------------------------------------------

## 📁 Estructura del repositorio

``` text
Repositorio/
├── README.md
└── Proyecto_Final_Michoacan/
    ├── Proyecto_Final_Demografia.qmd
    ├── Proyecto_Final_Demografia.pdf
    ├── data/
    │   ├── poblacion_2010.xlsx
    │   ├── poblacion_2020.xlsx
    │   ├── defunciones_inegi.xlsx
    │   └── Graficos/
    │       └── portada_michoacan.png
    ├── script/
    │   ├── 00_config.R
    │   ├── 01_poblacion.R
    │   ├── 02_defunciones.R
    │   ├── 03_apv.R
    │   ├── 04_tablas_vida.R
    │   ├── 05_graficas.R
    │   ├── 06_exportar_tablas_vida.R
    │   ├── 07_tablas_vida_visuales.R
    │   └── 08_diagrama_flujo.R
    ├── output/
    └── resultados_tablas_vida/
        ├── csv/
        └── png/
```

------------------------------------------------------------------------

## 📂 Carpetas principales

### `Proyecto_Final_Michoacan/data/`

Contiene las bases utilizadas para el análisis:

-   población censal 2010;
-   población censal 2020;
-   defunciones registradas;
-   archivos gráficos auxiliares, como la portada del informe.

### `Proyecto_Final_Michoacan/script/`

Contiene los códigos en R organizados por etapa del proyecto.

| Script | Descripción |
|------------------------------------|------------------------------------|
| `00_config.R` | Define rutas, paquetes, años de análisis y parámetros generales. |
| `01_poblacion.R` | Limpia y organiza la población censal. |
| `02_defunciones.R` | Limpia y agrupa las defunciones registradas. |
| `03_apv.R` | Estima los años persona vividos. |
| `04_tablas_vida.R` | Construye las tablas de vida. |
| `05_graficas.R` | Genera las gráficas principales del informe. |
| `06_exportar_tablas_vida.R` | Exporta resultados finales en archivos `.csv`. |
| `07_tablas_vida_visuales.R` | Crea versiones visuales de las tablas de vida. |
| `08_diagrama_flujo.R` | Genera el diagrama de flujo del proceso. |

### `Proyecto_Final_Michoacan/output/`

Contiene las gráficas generadas para el informe, entre ellas:

-   tasas centrales de mortalidad;
-   probabilidades de muerte;
-   función de sobrevivientes;
-   esperanza de vida al nacer.

### `Proyecto_Final_Michoacan/resultados_tablas_vida/`

Contiene los resultados finales del proyecto:

-   tablas de vida en formato `.csv`;
-   tablas visuales en formato `.png`;
-   resumen de esperanza de vida.

------------------------------------------------------------------------

## 🧾 Informe final

El informe completo puede consultarse aquí:

[📄 Ver informe final en PDF](Proyecto_Final_Michoacan/Proyecto_Final_Demografia.pdf)

El archivo editable en Quarto se encuentra aquí:

[📝 Ver archivo Quarto](Proyecto_Final_Michoacan/Proyecto_Final_Demografia.qmd)

El documento incluye:

-   contexto de Michoacán;
-   diagrama de flujo del proceso;
-   fórmulas utilizadas;
-   código empleado para los cálculos;
-   esperanza de vida al nacer por sexo y año;
-   gráficas principales;
-   tablas de vida;
-   análisis de resultados.

------------------------------------------------------------------------

## 📌 Fuentes de información

Los datos utilizados provienen de **INEGI**.

Se emplearon datos de:

-   Censo de Población y Vivienda 2010;
-   Censo de Población y Vivienda 2020;
-   Estadísticas de Defunciones Registradas.

Las defunciones se trabajaron considerando año de ocurrencia, edad, sexo y entidad de residencia habitual.

------------------------------------------------------------------------

## 🛠️ Herramientas utilizadas

Para el desarrollo del proyecto se utilizaron:

-   📦 **R**
-   🧠 **RStudio**
-   📄 **Quarto**
-   📊 **Excel**
-   🗺️ **Datos de INEGI**

Paquetes principales de R:

``` r
data.table
dplyr
tidyr
ggplot2
readxl
stringr
knitr
gt
webshot2
```

------------------------------------------------------------------------

## ▶️ Cómo reproducir el proyecto

Para reproducir los resultados, se recomienda abrir el proyecto en RStudio y ejecutar los scripts en el siguiente orden:

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

Después, se puede renderizar el archivo Quarto:

``` text
Proyecto_Final_Demografia.qmd
```

para generar el PDF final del informe.

> Nota: los scripts están pensados para ejecutarse desde la carpeta `Proyecto_Final_Michoacan/`.

------------------------------------------------------------------------

## 📈 Gráficas principales

Algunas de las gráficas generadas por el proyecto son:

-   [📉 Tasas centrales de mortalidad](Proyecto_Final_Michoacan/output/mx_michoacan_formal.png)
-   [📉 Probabilidades de muerte](Proyecto_Final_Michoacan/output/qx_michoacan_formal.png)
-   [📈 Sobrevivientes de la cohorte hipotética](Proyecto_Final_Michoacan/output/lx_michoacan_formal.png)
-   [📊 Esperanza de vida al nacer](Proyecto_Final_Michoacan/output/esperanza_vida_barras_michoacan_formal.png)

Estas gráficas permiten observar el comportamiento de la mortalidad por edad, sexo y año, así como el cambio en la esperanza de vida al nacer.

------------------------------------------------------------------------

## 📋 Tablas generadas

Las tablas de vida finales se encuentran en:

[📁 Ver tablas de vida](Proyecto_Final_Michoacan/resultados_tablas_vida/)

También se generan versiones visuales en:

[🖼️ Ver tablas visuales](Proyecto_Final_Michoacan/resultados_tablas_vida/png/)

Algunas tablas visuales importantes son:

-   [Tabla de vida 2021 - Hombres](Proyecto_Final_Michoacan/resultados_tablas_vida/png/tabla_vida_visual_2021_hombres.png)
-   [Tabla de vida 2021 - Mujeres](Proyecto_Final_Michoacan/resultados_tablas_vida/png/tabla_vida_visual_2021_mujeres.png)
-   [Tabla de esperanza de vida](Proyecto_Final_Michoacan/resultados_tablas_vida/png/tabla_esperanza_vida_michoacan.png)

------------------------------------------------------------------------

## 🖼️ Vista rápida de resultados

### Esperanza de vida al nacer

<p align="center">

<img src="Proyecto_Final_Michoacan/output/esperanza_vida_barras_michoacan_formal.png" width="700"/>

</p>

### Tasas centrales de mortalidad

<p align="center">

<img src="Proyecto_Final_Michoacan/output/mx_michoacan_formal.png" width="700"/>

</p>

### Probabilidades de muerte

<p align="center">

<img src="Proyecto_Final_Michoacan/output/qx_michoacan_formal.png" width="700"/>

</p>

### Sobrevivientes

<p align="center">

<img src="Proyecto_Final_Michoacan/output/lx_michoacan_formal.png" width="700"/>

</p>

------------------------------------------------------------------------

## 🧠 Comentario final

Este proyecto permitió observar cómo las tablas de vida resumen de manera clara el comportamiento de la mortalidad en una población. Para Michoacán, los resultados muestran diferencias persistentes entre hombres y mujeres, así como una caída notable en la esperanza de vida durante 2021.

La organización del repositorio busca que el trabajo sea fácil de revisar: los datos se encuentran en `data/`, el código en `script/`, las gráficas en `output/` y los resultados finales en `resultados_tablas_vida/`.

------------------------------------------------------------------------

<p align="center">

🦋 Michoacán, una exploración demográfica 🦋

</p>
