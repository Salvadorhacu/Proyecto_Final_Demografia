# ============================================================
# 07_tablas_vida_visuales.R
# Crear versiones visuales de las tablas de vida
# ============================================================

if (!exists("tabla_mortalidad")) {
  source("script/00_config.R")
  source("script/01_poblacion.R")
  source("script/02_defunciones.R")
  source("script/03_apv.R")
  source("script/04_tablas_vida.R")
}

library(gt)
library(data.table)
library(dplyr)

# ------------------------------------------------------------
# Carpeta de salida
# ------------------------------------------------------------

ruta_resultados <- "resultados_tablas_vida/"

if (!dir.exists(ruta_resultados)) {
  dir.create(ruta_resultados)
}

# ------------------------------------------------------------
# Función para crear tabla visual
# ------------------------------------------------------------

crear_tabla_visual <- function(tabla, anio_sel, sexo_sel) {
  
  # Colores según sexo
  color_encabezado <- ifelse(
    sexo_sel == "Hombres",
    "#1F4E79",   # azul oscuro
    "#B03A6B"    # rosa oscuro
  )
  
  titulo_sexo <- ifelse(sexo_sel == "Hombres", "Hombres", "Mujeres")
  
  tabla_aux <- tabla[
    anio == anio_sel & sexo == sexo_sel,
    .(
      x = edad,
      n = n,
      nmx = round(mx, 6),
      nax = round(ax, 3),
      nqx = round(qx, 6),
      npx = round(px, 6),
      lx = round(lx, 0),
      ndx = round(dx, 0),
      nLx = round(Lx, 0),
      Tx = round(Tx, 0),
      ex = round(ex, 2)
    )
  ]
  
  tabla_gt <- tabla_aux %>%
    gt() %>%
    tab_header(
      title = paste0("Tabla de vida - Michoacán ", anio_sel),
      subtitle = paste0(titulo_sexo, " | Raíz de la tabla: 100,000")
    ) %>%
    cols_label(
      x = "x",
      n = "n",
      nmx = "nmx",
      nax = "nax",
      nqx = "nqx",
      npx = "npx",
      lx = "lx",
      ndx = "ndx",
      nLx = "nLx",
      Tx = "Tx",
      ex = "ex"
    ) %>%
    tab_style(
      style = list(
        cell_fill(color = color_encabezado),
        cell_text(color = "white", weight = "bold")
      ),
      locations = cells_column_labels(everything())
    ) %>%
    tab_style(
      style = list(
        cell_text(weight = "bold", color = "#333333", size = px(20))
      ),
      locations = cells_title(groups = "title")
    ) %>%
    tab_style(
      style = list(
        cell_text(color = "#555555", size = px(14))
      ),
      locations = cells_title(groups = "subtitle")
    ) %>%
    tab_options(
      table.font.names = "Arial",
      table.font.size = px(12),
      table.background.color = "white",
      heading.background.color = "white",
      column_labels.background.color = color_encabezado,
      table.border.top.color = color_encabezado,
      table.border.top.width = px(3),
      table.border.bottom.color = color_encabezado,
      table.border.bottom.width = px(3),
      data_row.padding = px(4)
    )
  
  return(tabla_gt)
}

# ------------------------------------------------------------
# Crear y guardar las 6 tablas visuales
# ------------------------------------------------------------

for (a in c(2010, 2019, 2021)) {
  for (s in c("Hombres", "Mujeres")) {
    
    tabla_gt <- crear_tabla_visual(
      tabla = tabla_mortalidad,
      anio_sel = a,
      sexo_sel = s
    )
    
    nombre_sexo <- ifelse(s == "Hombres", "hombres", "mujeres")
    
    archivo_png <- paste0(
      ruta_resultados,
      "tabla_vida_visual_",
      a,
      "_",
      nombre_sexo,
      ".png"
    )
    
    archivo_html <- paste0(
      ruta_resultados,
      "tabla_vida_visual_",
      a,
      "_",
      nombre_sexo,
      ".html"
    )
    
    # Guardar HTML
    gtsave(tabla_gt, archivo_html)
    
    # Guardar PNG
    gtsave(tabla_gt, archivo_png)
  }
}

print("Tablas visuales guardadas en resultados_tablas_vida/:")
print(list.files(ruta_resultados, pattern = "visual"))

