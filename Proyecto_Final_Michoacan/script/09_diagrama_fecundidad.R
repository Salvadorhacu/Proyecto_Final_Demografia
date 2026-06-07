# ============================================================
# 11_diagrama_fecundidad.R
# Diagrama de flujo para indicadores de fecundidad
# ============================================================

if (!exists("ruta_graficos")) {
  source("script/00_config.R")
}

library(ggplot2)
library(grid)

if (!dir.exists(ruta_graficos)) {
  dir.create(ruta_graficos, recursive = TRUE)
}

# ------------------------------------------------------------
# Nodos
# ------------------------------------------------------------

nodos <- data.frame(
  id = 1:10,
  x = c(1, 3, 5, 7, 9,
        9, 7, 5, 3, 1),
  y = c(2, 2, 2, 2, 2,
        1, 1, 1, 1, 1),
  texto = c(
    "Inicio",
    "Nacimientos\nINEGI",
    "Población femenina\n15 a 49 años",
    "Limpieza y\nagrupación por edad",
    "TEFE por grupo\nde edad",
    "TGF\n2010 y 2019",
    "TBR\nnacimientos femeninos",
    "TNR\ncon sobrevivencia",
    "Curvas TEFE\nMichoacán, México y país",
    "Fin"
  ),
  tipo = c(
    "terminal", "datos", "datos", "proceso", "calculo",
    "calculo", "calculo", "calculo", "salida", "terminal"
  )
)

# ------------------------------------------------------------
# Flechas
# ------------------------------------------------------------

flechas_sup <- data.frame(
  x = c(1.75, 3.75, 5.75, 7.75),
  y = rep(2, 4),
  xend = c(2.25, 4.25, 6.25, 8.25),
  yend = rep(2, 4)
)

flecha_baja <- data.frame(
  x = 9,
  y = 1.78,
  xend = 9,
  yend = 1.25
)

flechas_inf <- data.frame(
  x = c(8.25, 6.25, 4.25, 2.25),
  y = rep(1, 4),
  xend = c(7.75, 5.75, 3.75, 1.75),
  yend = rep(1, 4)
)

# ------------------------------------------------------------
# Colores
# ------------------------------------------------------------

colores_fill <- c(
  terminal = "#184E77",
  datos = "#2A6F97",
  proceso = "#E9D8A6",
  calculo = "#EE9B00",
  salida = "#9B2226"
)

colores_texto <- c(
  terminal = "white",
  datos = "white",
  proceso = "#1F2937",
  calculo = "#1F2937",
  salida = "white"
)

# ------------------------------------------------------------
# Diagrama
# ------------------------------------------------------------

diagrama_fecundidad <- ggplot() +
  geom_label(
    data = nodos,
    aes(
      x = x,
      y = y,
      label = texto,
      fill = tipo,
      color = tipo
    ),
    size = 4.1,
    fontface = "bold",
    label.size = 0.7,
    label.r = unit(0.18, "lines"),
    label.padding = unit(0.35, "lines"),
    lineheight = 0.9
  ) +
  geom_segment(
    data = flechas_sup,
    aes(x = x, y = y, xend = xend, yend = yend),
    arrow = arrow(length = unit(0.18, "cm")),
    linewidth = 0.6,
    color = "#333333"
  ) +
  geom_segment(
    data = flecha_baja,
    aes(x = x, y = y, xend = xend, yend = yend),
    arrow = arrow(length = unit(0.18, "cm")),
    linewidth = 0.6,
    color = "#333333"
  ) +
  geom_segment(
    data = flechas_inf,
    aes(x = x, y = y, xend = xend, yend = yend),
    arrow = arrow(length = unit(0.18, "cm")),
    linewidth = 0.6,
    color = "#333333"
  ) +
  annotate(
    "text",
    x = 5,
    y = 2.45,
    label = "Preparación de datos de fecundidad",
    size = 5,
    fontface = "bold",
    color = "#184E77"
  ) +
  annotate(
    "text",
    x = 5,
    y = 1.45,
    label = "Indicadores de reproducción y comparación",
    size = 5,
    fontface = "bold",
    color = "#9B2226"
  ) +
  scale_fill_manual(values = colores_fill) +
  scale_color_manual(values = colores_texto) +
  coord_cartesian(xlim = c(0.2, 9.8), ylim = c(0.55, 2.75), clip = "off") +
  theme_void() +
  theme(
    legend.position = "none",
    plot.margin = margin(10, 15, 10, 15)
  )

# ------------------------------------------------------------
# Guardar
# ------------------------------------------------------------

ggsave(
  filename = paste0(ruta_graficos, "diagrama_fecundidad.png"),
  plot = diagrama_fecundidad,
  width = 11,
  height = 4.5,
  dpi = 300
)

print("Diagrama guardado en output/diagrama_fecundidad.png")

