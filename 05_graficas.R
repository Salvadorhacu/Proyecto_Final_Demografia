# ============================================================
# 05_graficas.R
# Gráficas principales de las tablas de mortalidad
# ============================================================

if (!exists("tabla_mortalidad") | !exists("esperanza_vida")) {
  source("script/00_config.R")
  source("script/01_poblacion.R")
  source("script/02_defunciones.R")
  source("script/03_apv.R")
  source("script/04_tablas_vida.R")
}

# Crear carpeta output si no existe
if (!dir.exists(ruta_graficos)) {
  dir.create(ruta_graficos)
}

# ------------------------------------------------------------
# Preparar datos
# ------------------------------------------------------------

tabla_graf <- copy(tabla_mortalidad)

tabla_graf[, anio := factor(anio)]
tabla_graf[, sexo := factor(sexo, levels = c("Hombres", "Mujeres"))]

esperanza_graf <- copy(esperanza_vida)
esperanza_graf[, anio := factor(anio)]
esperanza_graf[, sexo := factor(sexo, levels = c("Hombres", "Mujeres"))]

# ------------------------------------------------------------
# Colores
# ------------------------------------------------------------

colores_anios <- c(
  "2010" = "#1B9E77",
  "2019" = "#D95F02",
  "2021" = "#7570B3"
)

colores_sexo <- c(
  "Hombres" = "#2C7FB8",
  "Mujeres" = "#E78AC3"
)

# ------------------------------------------------------------
# 1. Gráfica de mx
# ------------------------------------------------------------

grafica_mx <- ggplot(
  tabla_graf,
  aes(x = edad, y = mx, group = anio, color = anio)
) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1.4) +
  facet_wrap(~ sexo) +
  scale_y_log10() +
  scale_color_manual(values = colores_anios) +
  labs(
    title = "Tasas centrales de mortalidad por edad, sexo y año",
    subtitle = "Michoacán, 2010, 2019 y 2021",
    x = "Edad inicial del grupo",
    y = expression(n*m[x]~"(escala logarítmica)"),
    color = "Año"
  ) +
  theme_minimal()

ggsave(
  filename = paste0(ruta_graficos, "mx_michoacan.png"),
  plot = grafica_mx,
  width = 9,
  height = 5.5,
  dpi = 300
)

# ------------------------------------------------------------
# 2. Gráfica de qx
# ------------------------------------------------------------

grafica_qx <- ggplot(
  tabla_graf,
  aes(x = edad, y = qx, group = anio, color = anio)
) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1.4) +
  facet_wrap(~ sexo) +
  scale_y_log10() +
  scale_color_manual(values = colores_anios) +
  labs(
    title = "Probabilidades de muerte por edad, sexo y año",
    subtitle = "Michoacán, 2010, 2019 y 2021",
    x = "Edad inicial del grupo",
    y = expression(n*q[x]~"(escala logarítmica)"),
    color = "Año"
  ) +
  theme_minimal()

ggsave(
  filename = paste0(ruta_graficos, "qx_michoacan.png"),
  plot = grafica_qx,
  width = 9,
  height = 5.5,
  dpi = 300
)

# ------------------------------------------------------------
# 3. Gráfica de lx
# ------------------------------------------------------------

grafica_lx <- ggplot(
  tabla_graf,
  aes(x = edad, y = lx, group = anio, color = anio)
) +
  geom_line(linewidth = 0.9) +
  facet_wrap(~ sexo) +
  scale_color_manual(values = colores_anios) +
  labs(
    title = "Sobrevivientes de la cohorte hipotética por edad",
    subtitle = "Raíz de la tabla: 100,000 nacimientos",
    x = "Edad inicial del grupo",
    y = expression(l[x]),
    color = "Año"
  ) +
  theme_minimal()

ggsave(
  filename = paste0(ruta_graficos, "lx_michoacan.png"),
  plot = grafica_lx,
  width = 9,
  height = 5.5,
  dpi = 300
)

# ------------------------------------------------------------
# 4. Esperanza de vida al nacer
# ------------------------------------------------------------

grafica_esperanza <- ggplot(
  esperanza_graf,
  aes(x = anio, y = esperanza_vida_nacer, group = sexo, color = sexo)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  scale_color_manual(values = colores_sexo) +
  labs(
    title = "Esperanza de vida al nacer por sexo",
    subtitle = "Michoacán, 2010, 2019 y 2021",
    x = "Año",
    y = "Esperanza de vida al nacer",
    color = "Sexo"
  ) +
  theme_minimal()

ggsave(
  filename = paste0(ruta_graficos, "esperanza_vida_michoacan.png"),
  plot = grafica_esperanza,
  width = 8,
  height = 5,
  dpi = 300
)

# ------------------------------------------------------------
# Revisión
# ------------------------------------------------------------

print("Gráficas guardadas en output/:")
print(list.files(ruta_graficos, pattern = "\\.png$"))
