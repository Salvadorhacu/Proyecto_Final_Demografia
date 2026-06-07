# ============================================================
# 00_config.R
# Configuración general del proyecto
# Proyecto: Tablas de vida para Michoacán, 2010, 2019 y 2021
# ============================================================

# Limpiar entorno
rm(list = ls())

# ------------------------------------------------------------
# Instalar y cargar paquetes necesarios
# ------------------------------------------------------------

paquetes <- c(
  "data.table",
  "dplyr",
  "tidyr",
  "ggplot2",
  "readr",
  "stringr",
  "knitr",
  "gt",
  "webshot2"
)

paquetes_faltantes <- paquetes[!paquetes %in% installed.packages()[, "Package"]]

if (length(paquetes_faltantes) > 0) {
  install.packages(paquetes_faltantes, dependencies = TRUE)
}

invisible(lapply(paquetes, library, character.only = TRUE))

# ------------------------------------------------------------
# Parámetros generales
# ------------------------------------------------------------

# Entidad federativa de análisis
entidad_objetivo <- "Michoacán de Ocampo"

# Años requeridos por el proyecto
anios_objetivo <- c(2010, 2019, 2021)

# Años necesarios para construir defunciones promedio
anios_defunciones <- c(2009, 2010, 2011,
                       2018, 2019,
                       2020, 2021, 2022)

# Raíz de la tabla de vida
l0 <- 100000

# ------------------------------------------------------------
# Rutas del proyecto
# ------------------------------------------------------------

ruta_data <- "data/"
ruta_scripts <- "script/"
ruta_graficos <- "output/"

# Archivos de entrada
archivo_poblacion_2010 <- paste0(ruta_data, "poblacion_2010.xlsx")
archivo_poblacion_2020 <- paste0(ruta_data, "poblacion_2020.xlsx")
archivo_defunciones <- paste0(ruta_data, "defunciones_inegi.xlsx")

# ------------------------------------------------------------
# Opciones generales
# ------------------------------------------------------------

options(scipen = 999)

