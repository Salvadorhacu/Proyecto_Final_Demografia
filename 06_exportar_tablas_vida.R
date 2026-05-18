# ============================================================
# 06_exportar_tablas_vida.R
# Exportar las seis tablas de vida finales
# ============================================================

if (!exists("tabla_mortalidad")) {
  source("script/00_config.R")
  source("script/01_poblacion.R")
  source("script/02_defunciones.R")
  source("script/03_apv.R")
  source("script/04_tablas_vida.R")
}

# ------------------------------------------------------------
# Crear carpeta de resultados
# ------------------------------------------------------------

ruta_resultados <- "resultados_tablas_vida/"

if (!dir.exists(ruta_resultados)) {
  dir.create(ruta_resultados)
}

# ------------------------------------------------------------
# Preparar tabla final
# ------------------------------------------------------------

tabla_final <- copy(tabla_mortalidad)

# Redondear para que se vea limpia al abrir en Excel
tabla_final[, `:=`(
  mx = round(mx, 8),
  ax = round(ax, 4),
  qx = round(qx, 8),
  px = round(px, 8),
  lx = round(lx, 2),
  dx = round(dx, 2),
  Lx = round(Lx, 2),
  Tx = round(Tx, 2),
  ex = round(ex, 4)
)]

# Cambiar nombres a notación más parecida a clase
setnames(
  tabla_final,
  old = c("edad", "n", "mx", "ax", "qx", "px", "lx", "dx", "Lx", "Tx", "ex"),
  new = c("x", "n", "nmx", "nax", "nqx", "npx", "lx", "ndx", "nLx", "Tx", "ex")
)

# ------------------------------------------------------------
# Exportar tabla completa
# ------------------------------------------------------------

fwrite(
  tabla_final,
  paste0(ruta_resultados, "tabla_vida_completa_michoacan_2010_2019_2021.csv")
)

# ------------------------------------------------------------
# Exportar las 6 tablas por año y sexo
# ------------------------------------------------------------

for (a in unique(tabla_final$anio)) {
  for (s in unique(tabla_final$sexo)) {
    
    tabla_aux <- tabla_final[anio == a & sexo == s]
    
    nombre_sexo <- ifelse(s == "Hombres", "hombres", "mujeres")
    
    nombre_archivo <- paste0(
      ruta_resultados,
      "tabla_vida_",
      a,
      "_",
      nombre_sexo,
      ".csv"
    )
    
    fwrite(tabla_aux, nombre_archivo)
  }
}

# ------------------------------------------------------------
# Exportar cuadro resumen de esperanza de vida
# ------------------------------------------------------------

esperanza_final <- copy(esperanza_vida)

esperanza_final[, esperanza_vida_nacer := round(esperanza_vida_nacer, 4)]

fwrite(
  esperanza_final,
  paste0(ruta_resultados, "resumen_esperanza_vida_michoacan.csv")
)

# ------------------------------------------------------------
# Revisión
# ------------------------------------------------------------

print("Archivos exportados en resultados_tablas_vida/:")
print(list.files(ruta_resultados))
