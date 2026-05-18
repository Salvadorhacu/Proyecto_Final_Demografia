# ============================================================
# 08_diagrama_flujo.R
# Diagrama de flujo compacto para el informe
# ============================================================

if (!exists("ruta_graficos")) {
  source("script/00_config.R")
}

library(ggplot2)
library(grid)

if (!dir.exists(ruta_graficos)) {
  dir.create(ruta_graficos)
}

# ------------------------------------------------------------
# Cajas del diagrama
# ------------------------------------------------------------

cajas <- data.frame(
  id = 1:10,
  x = c(1, 3, 5, 7, 9,
        9, 7, 5, 3, 1),
  y = c(2, 2, 2, 2, 2,
        1, 1, 1, 1, 1),
  texto = c(
    "Datos\nINEGI",
    "Limpieza de\npoblación",
    "Limpieza de\ndefunciones",
    "Prorrateos",
    "Datos\nlimpios",
    "Cálculo de\nAPV",
    "Tasas\nnmx",
    "Tabla de vida\nnqx, lx, Lx",
    "Esperanza\nde vida",
    "Gráficas y\nresultados"
  )
)

# Flechas horizontales superiores
flechas_sup <- data.frame(
  x = c(1.65, 3.65, 5.65, 7.65),
  y = c(2, 2, 2, 2),
  xend = c(2.35, 4.35, 6.35, 8.35),
  yend = c(2, 2, 2, 2)
)

# Flecha de bajada
flecha_baja <- data.frame(
  x = 9,
  y = 1.78,
  xend = 9,
  yend = 1.25
)

# Flechas horizontales inferiores
flechas_inf <- data.frame(
  x = c(8.35, 6.35, 4.35, 2.35),
  y = c(1, 1, 1, 1),
  xend = c(7.65, 5.65, 3.65, 1.65),
  yend = c(1, 1, 1, 1)
)

# ------------------------------------------------------------
# Construir diagrama
# ------------------------------------------------------------

diagrama_flujo <- ggplot() +
  geom_rect(
    data = cajas,
    aes(
      xmin = x - 0.75,
      xmax = x + 0.75,
      ymin = y - 0.22,
      ymax = y + 0.22
    ),
    fill = "#E9E7FA",
    color = "#7E6BC4",
    linewidth = 0.8
  ) +
  geom_text(
    data = cajas,
    aes(x = x, y = y, label = texto),
    size = 4.2,
    fontface = "bold",
    color = "#333333",
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
    label = "Preparación de datos",
    size = 5,
    fontface = "bold",
    color = "#4A3F8F"
  ) +
  annotate(
    "text",
    x = 5,
    y = 1.45,
    label = "Construcción de tablas de vida y resultados",
    size = 5,
    fontface = "bold",
    color = "#4A3F8F"
  ) +
  xlim(0, 10) +
  ylim(0.55, 2.7) +
  theme_void()

# ------------------------------------------------------------
# Guardar imagen
# ------------------------------------------------------------

ggsave(
  filename = paste0(ruta_graficos, "diagrama_flujo.png"),
  plot = diagrama_flujo,
  width = 11,
  height = 4.2,
  dpi = 300
)

print("Diagrama guardado en output/diagrama_flujo.png")

