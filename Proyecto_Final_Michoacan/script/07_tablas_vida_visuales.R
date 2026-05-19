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
library(tidyr)

# ------------------------------------------------------------
# Carpeta de salida
# ------------------------------------------------------------

ruta_resultados <- "resultados_tablas_vida/"
ruta_resultados_png <- paste0(ruta_resultados, "png/")

if (!dir.exists(ruta_resultados)) {
  dir.create(ruta_resultados)
}

if (!dir.exists(ruta_resultados_png)) {
  dir.create(ruta_resultados_png)
}


# ------------------------------------------------------------
# Función para crear tabla visual mejorada
# ------------------------------------------------------------

crear_tabla_visual <- function(tabla, anio_sel, sexo_sel) {
  
  # Paleta según sexo
  if (sexo_sel == "Hombres") {
    color_principal <- "#1F4E79"
    color_suave <- "#EAF2F8"
    color_acento <- "#D6EAF8"
  } else {
    color_principal <- "#A93265"
    color_suave <- "#FDEDEC"
    color_acento <- "#FADBD8"
  }
  
  titulo_sexo <- ifelse(sexo_sel == "Hombres", "Hombres", "Mujeres")
  
  tabla_aux <- tabla[
    anio == anio_sel & sexo == sexo_sel,
    .(
      x = edad,
      n = n,
      nmx = mx,
      nax = ax,
      nqx = qx,
      npx = px,
      lx = lx,
      ndx = dx,
      nLx = Lx,
      Tx = Tx,
      ex = ex
    )
  ]
  
  tabla_gt <- tabla_aux %>%
    gt() %>%
    
    # Título
    tab_header(
      title = md(paste0("**Tabla de vida de Michoacán, ", anio_sel, "**")),
      subtitle = md(paste0("Sexo: **", titulo_sexo, "** &nbsp;&nbsp; | &nbsp;&nbsp; Raíz de la tabla: **100,000**"))
    ) %>%
    
    # Etiquetas de columnas
    cols_label(
      x = md("*x*"),
      n = md("*n*"),
      nmx = md("*n m_x*"),
      nax = md("*n a_x*"),
      nqx = md("*n q_x*"),
      npx = md("*n p_x*"),
      lx = md("*l_x*"),
      ndx = md("*n d_x*"),
      nLx = md("*n L_x*"),
      Tx = md("*T_x*"),
      ex = md("*e_x*")
    ) %>%
    
    # Formato numérico
    fmt_number(
      columns = c(nmx, nqx, npx),
      decimals = 6
    ) %>%
    fmt_number(
      columns = c(nax, ex),
      decimals = 2
    ) %>%
    fmt_number(
      columns = c(lx, ndx, nLx, Tx),
      decimals = 0,
      sep_mark = ","
    ) %>%
    
    # Alineación
    cols_align(
      align = "center",
      columns = everything()
    ) %>%
    
    # Ancho de columnas
    cols_width(
      x ~ px(55),
      n ~ px(55),
      nmx ~ px(90),
      nax ~ px(80),
      nqx ~ px(90),
      npx ~ px(90),
      lx ~ px(90),
      ndx ~ px(90),
      nLx ~ px(95),
      Tx ~ px(100),
      ex ~ px(70)
    ) %>%
    
    # Encabezados de columnas
    tab_style(
      style = list(
        cell_fill(color = color_principal),
        cell_text(color = "white", weight = "bold", size = px(12)),
        cell_borders(sides = "bottom", color = color_principal, weight = px(2))
      ),
      locations = cells_column_labels(everything())
    ) %>%
    
    # Título
    tab_style(
      style = list(
        cell_text(weight = "bold", color = color_principal, size = px(22))
      ),
      locations = cells_title(groups = "title")
    ) %>%
    
    # Subtítulo
    tab_style(
      style = list(
        cell_text(color = "#555555", size = px(14))
      ),
      locations = cells_title(groups = "subtitle")
    ) %>%
    
    # Resaltar columnas actuariales principales
    tab_style(
      style = list(
        cell_fill(color = color_suave),
        cell_text(weight = "bold", color = "#222222")
      ),
      locations = cells_body(columns = c(lx, ndx, ex))
    ) %>%
    
    # Resaltar esperanza de vida
    tab_style(
      style = list(
        cell_fill(color = color_acento),
        cell_text(weight = "bold", color = color_principal)
      ),
      locations = cells_body(columns = ex)
    ) %>%
    
    # Filas alternadas
    opt_row_striping(row_striping = TRUE) %>%
    
    # Nota al pie
    tab_source_note(
      source_note = md("Fuente: elaboración propia con datos de población y defunciones del INEGI.")
    ) %>%
    
    # Opciones generales
    tab_options(
      table.font.names = "Arial",
      table.font.size = px(11),
      table.background.color = "white",
      heading.background.color = "white",
      heading.align = "center",
      column_labels.background.color = color_principal,
      table.border.top.color = color_principal,
      table.border.top.width = px(4),
      table.border.bottom.color = color_principal,
      table.border.bottom.width = px(4),
      row.striping.background_color = "#F7F7F7",
      data_row.padding = px(5),
      source_notes.font.size = px(10)
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
      ruta_resultados_png,
      "tabla_vida_visual_",
      a,
      "_",
      nombre_sexo,
      ".png"
    )
    
    gtsave(
      tabla_gt,
      filename = archivo_png,
      vwidth = 1400,
      vheight = 1800,
      zoom = 2
    )
  }
}



# ============================================================
# Tabla visual de esperanza de vida
# ============================================================



crear_tabla_esperanza_visual <- function(esperanza_vida) {
  
  color_principal <- "#6C3483"
  color_suave <- "#F4ECF7"
  color_acento <- "#E8DAEF"
  
  tabla_aux <- copy(esperanza_vida)
  
  tabla_aux[, esperanza_vida_nacer := round(esperanza_vida_nacer, 2)]
  
  tabla_wide <- tabla_aux |>
    dplyr::select(anio, sexo, esperanza_vida_nacer) |>
    tidyr::pivot_wider(
      names_from = sexo,
      values_from = esperanza_vida_nacer
    ) |>
    dplyr::arrange(anio)
  
  tabla_gt <- tabla_wide |>
    gt() |>
    
    tab_header(
      title = md("**Esperanza de vida al nacer en Michoacán**"),
      subtitle = md("Comparación por año y sexo")
    ) |>
    
    cols_label(
      anio = "Año",
      Hombres = "Hombres",
      Mujeres = "Mujeres"
    ) |>
    
    fmt_number(
      columns = c(Hombres, Mujeres),
      decimals = 2
    ) |>
    
    cols_align(
      align = "center",
      columns = everything()
    ) |>
    
    cols_width(
      anio ~ px(110),
      Hombres ~ px(160),
      Mujeres ~ px(160)
    ) |>
    
    # Encabezado de columnas
    tab_style(
      style = list(
        cell_fill(color = color_principal),
        cell_text(color = "white", weight = "bold", size = px(13)),
        cell_borders(sides = "bottom", color = color_principal, weight = px(2))
      ),
      locations = cells_column_labels(everything())
    ) |>
    
    # Título
    tab_style(
      style = list(
        cell_text(weight = "bold", color = color_principal, size = px(22))
      ),
      locations = cells_title(groups = "title")
    ) |>
    
    # Subtítulo
    tab_style(
      style = list(
        cell_text(color = "#555555", size = px(14))
      ),
      locations = cells_title(groups = "subtitle")
    ) |>
    
    # Resaltar columna de años
    tab_style(
      style = list(
        cell_fill(color = color_suave),
        cell_text(weight = "bold", color = "#222222")
      ),
      locations = cells_body(columns = anio)
    ) |>
    
    # Resaltar datos de esperanza de vida
    tab_style(
      style = list(
        cell_fill(color = color_acento),
        cell_text(weight = "bold", color = color_principal, size = px(14))
      ),
      locations = cells_body(columns = c(Hombres, Mujeres))
    ) |>
    
    # Filas alternadas
    opt_row_striping(row_striping = TRUE) |>
    
    # Nota fuente
    tab_source_note(
      source_note = md("Fuente: elaboración con base en las tablas de vida calculadas para Michoacán.")
    ) |>
    
    # Estilo de la fuente
    tab_style(
      style = list(
        cell_text(color = "#666666", size = px(10))
      ),
      locations = cells_source_notes()
    ) |>
    
    tab_options(
      table.font.names = "Arial",
      table.font.size = px(12),
      table.background.color = "white",
      heading.background.color = "white",
      heading.align = "center",
      column_labels.background.color = color_principal,
      table.border.top.color = color_principal,
      table.border.top.width = px(4),
      table.border.bottom.color = color_principal,
      table.border.bottom.width = px(4),
      row.striping.background_color = "#F7F7F7",
      data_row.padding = px(8),
      source_notes.font.size = px(10)
    )
  
  return(tabla_gt)
}


# Crear tabla visual
tabla_esperanza_gt <- crear_tabla_esperanza_visual(esperanza_vida)

# Guardar como PNG
gtsave(
  tabla_esperanza_gt,
  filename = paste0(ruta_resultados_png, "tabla_esperanza_vida_michoacan.png"),
  vwidth = 900,
  vheight = 600,
  zoom = 2
)

