# ============================================================
# 05_graficas.R
# Gráficas formales de las tablas de mortalidad
# ============================================================

if (!exists("tabla_mortalidad") | !exists("esperanza_vida")) {
  source("script/00_config.R")
  source("script/01_poblacion.R")
  source("script/02_defunciones.R")
  source("script/03_apv.R")
  source("script/04_tablas_vida.R")
}

library(data.table)
library(dplyr)
library(ggplot2)
library(scales)

# ------------------------------------------------------------
# Crear carpeta output si no existe
# ------------------------------------------------------------

if (!dir.exists(ruta_graficos)) {
  dir.create(ruta_graficos)
}

# ------------------------------------------------------------
# Preparar datos
# ------------------------------------------------------------

tabla_graf <- copy(tabla_mortalidad)

tabla_graf[, anio := factor(anio, levels = c(2010, 2019, 2021))]
tabla_graf[, sexo := factor(sexo, levels = c("Hombres", "Mujeres"))]

esperanza_graf <- copy(esperanza_vida)

esperanza_graf[, anio := factor(anio, levels = c(2010, 2019, 2021))]
esperanza_graf[, sexo := factor(sexo, levels = c("Hombres", "Mujeres"))]

# ------------------------------------------------------------
# Paleta formal
# ------------------------------------------------------------

colores_anios <- c(
  "2010" = "#264653",  # azul petróleo
  "2019" = "#8A5A44",  # café formal
  "2021" = "#9D0208"   # vino oscuro
)

colores_sexo <- c(
  "Hombres" = "#1D3557",  # azul sobrio
  "Mujeres" = "#7B2CBF"   # morado institucional
)

color_fondo <- "white"
color_texto <- "#222222"
color_gris <- "#6B6B6B"
color_grid <- "#DDDDDD"

# ------------------------------------------------------------
# Tema general para todas las gráficas
# ------------------------------------------------------------

tema_formal <- function() {
  theme_minimal(base_family = "Arial", base_size = 12) +
    theme(
      plot.background = element_rect(fill = color_fondo, color = NA),
      panel.background = element_rect(fill = color_fondo, color = NA),
      
      plot.title = element_text(
        face = "bold",
        size = 16,
        color = color_texto,
        hjust = 0
      ),
      plot.subtitle = element_text(
        size = 11,
        color = color_gris,
        hjust = 0,
        margin = margin(b = 12)
      ),
      plot.caption = element_text(
        size = 9,
        color = color_gris,
        hjust = 1,
        margin = margin(t = 10)
      ),
      
      axis.title = element_text(
        size = 11,
        color = color_texto,
        face = "bold"
      ),
      axis.text = element_text(
        size = 10,
        color = color_texto
      ),
      
      panel.grid.major = element_line(
        color = color_grid,
        linewidth = 0.35
      ),
      panel.grid.minor = element_blank(),
      
      strip.background = element_rect(
        fill = "#F2F2F2",
        color = "#CCCCCC",
        linewidth = 0.4
      ),
      strip.text = element_text(
        face = "bold",
        size = 11,
        color = color_texto
      ),
      
      legend.position = "bottom",
      legend.title = element_text(
        face = "bold",
        size = 10,
        color = color_texto
      ),
      legend.text = element_text(
        size = 10,
        color = color_texto
      ),
      legend.key = element_blank(),
      
      plot.margin = margin(15, 20, 15, 20)
    )
}

# ------------------------------------------------------------
# 1. Gráfica de mx
# ------------------------------------------------------------

grafica_mx <- ggplot(
  tabla_graf,
  aes(x = edad, y = mx, group = anio, color = anio)
) +
  geom_line(linewidth = 1.05, alpha = 0.95) +
  geom_point(size = 2.1, alpha = 0.95) +
  facet_wrap(~ sexo, nrow = 1) +
  scale_y_log10(
    labels = label_number(accuracy = 0.0001)
  ) +
  scale_x_continuous(
    breaks = seq(0, 85, by = 10)
  ) +
  scale_color_manual(values = colores_anios) +
  labs(
    title = "Tasas centrales de mortalidad por edad",
    subtitle = "Michoacán, comparación por sexo y año seleccionado",
    x = "Edad inicial del grupo",
    y = expression(n*m[x]~"(escala logarítmica)"),
    color = "Año",
    caption = "Fuente: elaboración propia con base en las tablas de vida calculadas."
  ) +
  tema_formal()

ggsave(
  filename = paste0(ruta_graficos, "mx_michoacan_formal.png"),
  plot = grafica_mx,
  width = 9.5,
  height = 5.7,
  dpi = 300,
  bg = "white"
)

# ------------------------------------------------------------
# 2. Gráfica de qx
# ------------------------------------------------------------

grafica_qx <- ggplot(
  tabla_graf,
  aes(x = edad, y = qx, group = anio, color = anio)
) +
  geom_line(linewidth = 1.05, alpha = 0.95) +
  geom_point(size = 2.1, alpha = 0.95) +
  facet_wrap(~ sexo, nrow = 1) +
  scale_y_log10(
    labels = label_number(accuracy = 0.0001)
  ) +
  scale_x_continuous(
    breaks = seq(0, 85, by = 10)
  ) +
  scale_color_manual(values = colores_anios) +
  labs(
    title = "Probabilidades de muerte por edad",
    subtitle = "Michoacán, comparación por sexo y año seleccionado",
    x = "Edad inicial del grupo",
    y = expression(n*q[x]~"(escala logarítmica)"),
    color = "Año",
    caption = "Fuente: elaboración propia con base en las tablas de vida calculadas."
  ) +
  tema_formal()

ggsave(
  filename = paste0(ruta_graficos, "qx_michoacan_formal.png"),
  plot = grafica_qx,
  width = 9.5,
  height = 5.7,
  dpi = 300,
  bg = "white"
)

# ------------------------------------------------------------
# 3. Gráfica de lx
# ------------------------------------------------------------

grafica_lx <- ggplot(
  tabla_graf,
  aes(x = edad, y = lx, group = anio, color = anio)
) +
  geom_line(linewidth = 1.15, alpha = 0.95) +
  geom_point(size = 1.8, alpha = 0.9) +
  facet_wrap(~ sexo, nrow = 1) +
  scale_y_continuous(
    labels = label_comma()
  ) +
  scale_x_continuous(
    breaks = seq(0, 85, by = 10)
  ) +
  scale_color_manual(values = colores_anios) +
  labs(
    title = "Sobrevivientes de la cohorte hipotética",
    subtitle = "Raíz de la tabla: 100,000 nacimientos",
    x = "Edad inicial del grupo",
    y = expression(l[x]),
    color = "Año",
    caption = "Fuente: elaboración propia con base en las tablas de vida calculadas."
  ) +
  tema_formal()

ggsave(
  filename = paste0(ruta_graficos, "lx_michoacan_formal.png"),
  plot = grafica_lx,
  width = 9.5,
  height = 5.7,
  dpi = 300,
  bg = "white"
)

# ------------------------------------------------------------
# 4. Esperanza de vida al nacer
# ------------------------------------------------------------

grafica_esperanza <- ggplot(
  esperanza_graf,
  aes(x = anio, y = esperanza_vida_nacer, group = sexo, color = sexo)
) +
  geom_line(linewidth = 1.25, alpha = 0.95) +
  geom_point(size = 3.4, alpha = 0.95) +
  geom_text(
    aes(label = round(esperanza_vida_nacer, 2)),
    vjust = -1.1,
    size = 3.5,
    fontface = "bold",
    show.legend = FALSE
  ) +
  scale_color_manual(values = colores_sexo) +
  scale_y_continuous(
    limits = c(
      floor(min(esperanza_graf$esperanza_vida_nacer, na.rm = TRUE)) - 1,
      ceiling(max(esperanza_graf$esperanza_vida_nacer, na.rm = TRUE)) + 1
    ),
    breaks = pretty_breaks(n = 6)
  ) +
  labs(
    title = "Esperanza de vida al nacer",
    subtitle = "Michoacán, 2010, 2019 y 2021",
    x = "Año",
    y = "Años de vida esperados al nacer",
    color = "Sexo",
    caption = "Fuente: elaboración propia con base en las tablas de vida calculadas."
  ) +
  tema_formal() +
  theme(
    panel.grid.minor = element_blank()
  )

ggsave(
  filename = paste0(ruta_graficos, "esperanza_vida_michoacan_formal.png"),
  plot = grafica_esperanza,
  width = 8.5,
  height = 5.3,
  dpi = 300,
  bg = "white"
)

# ------------------------------------------------------------
# 5. Esperanza de vida al nacer por sexo: barras + línea
# ------------------------------------------------------------

esperanza_graf_linea <- copy(esperanza_graf)

esperanza_graf_linea[, anio := factor(anio, levels = c(2010, 2019, 2021))]
esperanza_graf_linea[, sexo := factor(sexo, levels = c("Hombres", "Mujeres"))]

grafica_esperanza_barras <- ggplot(
  esperanza_graf_linea,
  aes(x = anio, y = esperanza_vida_nacer)
) +
  # Barras de fondo
  geom_col(
    aes(fill = anio),
    width = 0.58,
    alpha = 0.82,
    show.legend = TRUE
  ) +
  
  # Línea de evolución
  geom_line(
    aes(group = sexo, color = sexo),
    linewidth = 1.35,
    alpha = 0.95,
    show.legend = FALSE
  ) +
  
  # Puntos sobre la línea
  geom_point(
    aes(color = sexo),
    size = 4.2,
    alpha = 0.98,
    show.legend = FALSE
  ) +
  
  # Etiquetas
  geom_text(
    aes(label = round(esperanza_vida_nacer, 2)),
    vjust = -1.1,
    size = 3.6,
    fontface = "bold",
    color = color_texto,
    show.legend = FALSE
  ) +
  
  facet_wrap(~ sexo, nrow = 1) +
  scale_fill_manual(values = colores_anios) +
  scale_color_manual(values = colores_sexo) +
  
  # Usamos coord_cartesian para acercar la vista sin eliminar las barras
  coord_cartesian(
    ylim = c(
      floor(min(esperanza_graf_linea$esperanza_vida_nacer, na.rm = TRUE)) - 1,
      ceiling(max(esperanza_graf_linea$esperanza_vida_nacer, na.rm = TRUE)) + 1
    )
  ) +
  
  scale_y_continuous(
    breaks = seq(68, 82, by = 2),
    labels = label_number(accuracy = 1)
  ) +
  
  labs(
    title = "Evolución de la esperanza de vida al nacer",
    subtitle = "Michoacán, comparación por sexo entre 2010, 2019 y 2021",
    x = "Año",
    y = "Años de vida esperados al nacer",
    fill = "Año",
    caption = "Fuente: elaboración propia con base en las tablas de vida calculadas."
  ) +
  tema_formal() +
  theme(
    legend.position = "bottom",
    strip.background = element_rect(
      fill = "#F1F1F1",
      color = "#CFCFCF",
      linewidth = 0.4
    ),
    strip.text = element_text(
      face = "bold",
      size = 12,
      color = color_texto
    )
  )

ggsave(
  filename = paste0(ruta_graficos, "esperanza_vida_barras_michoacan_formal.png"),
  plot = grafica_esperanza_barras,
  width = 8.5,
  height = 5.3,
  dpi = 300,
  bg = "white"
)

