# ============================================================
# 08_diagrama_flujo.R
# Diagrama de flujo corregido para el informe final
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
# Nodos del diagrama
# ------------------------------------------------------------

nodos <- data.frame(
  id = 1:12,
  x = c(1, 3, 5, 7, 9, 11,
        11, 9, 7, 5, 3, 1),
  y = c(2, 2, 2, 2, 2, 2,
        1, 1, 1, 1, 1, 1),
  texto = c(
    "Inicio",
    "Datos\nINEGI",
    "Limpieza de\npoblación",
    "Limpieza de\ndefunciones",
    "Prorrateos",
    "Datos\nlimpios",
    "Cálculo de\nAPV",
    "Tasas\nnmx",
    "Tablas de vida\n2010, 2019 y 2021",
    "Causa eliminada\nhomicidios 2019",
    "Gráficas y\nanálisis",
    "Fin"
  ),
  tipo = c(
    "terminal", "datos", "proceso", "proceso", "proceso", "proceso",
    "calculo", "calculo", "tabla", "tabla", "salida", "terminal"
  )
)

# ------------------------------------------------------------
# Flechas
# ------------------------------------------------------------

flechas_sup <- data.frame(
  x = c(1.75, 3.75, 5.75, 7.75, 9.75),
  y = rep(2, 5),
  xend = c(2.25, 4.25, 6.25, 8.25, 10.25),
  yend = rep(2, 5)
)

flecha_baja <- data.frame(
  x = 11,
  y = 1.78,
  xend = 11,
  yend = 1.25
)

flechas_inf <- data.frame(
  x = c(10.25, 8.25, 6.25, 4.25, 2.25),
  y = rep(1, 5),
  xend = c(9.75, 7.75, 5.75, 3.75, 1.75),
  yend = rep(1, 5)
)

# ------------------------------------------------------------
# Colores
# ------------------------------------------------------------

colores_fill <- c(
  terminal = "#184E77",
  datos = "#1E6091",
  proceso = "#EAF4F4",
  calculo = "#FFD6A5",
  tabla = "#9F1239",
  salida = "#2D6A4F"
)

colores_texto <- c(
  terminal = "white",
  datos = "white",
  proceso = "#1F2937",
  calculo = "#1F2937",
  tabla = "white",
  salida = "white"
)

# ------------------------------------------------------------
# Construir diagrama
# ------------------------------------------------------------

diagrama_flujo <- ggplot() +
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
    x = 6,
    y = 2.55,
    label = "Preparación de datos",
    size = 5,
    fontface = "bold",
    color = "#184E77"
  ) +
  annotate(
    "text",
    x = 6,
    y = 1.45,
    label = "Construcción de tablas de vida y resultados",
    size = 5,
    fontface = "bold",
    color = "#9F1239"
  ) +
  scale_fill_manual(values = colores_fill) +
  scale_color_manual(values = colores_texto) +
  coord_cartesian(xlim = c(0.2, 11.8), ylim = c(0.55, 2.75), clip = "off") +
  theme_void() +
  theme(
    legend.position = "none",
    plot.margin = margin(10, 15, 10, 15)
  )

# ------------------------------------------------------------
# Guardar imagen
# ------------------------------------------------------------

ggsave(
  filename = paste0(ruta_graficos, "diagrama_flujo.png"),
  plot = diagrama_flujo,
  width = 12,
  height = 4.5,
  dpi = 300
)

print("Diagrama guardado en output/diagrama_flujo.png")

