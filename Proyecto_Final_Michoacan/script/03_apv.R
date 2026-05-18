# ============================================================
# 03_apv.R
# Cálculo de Años Persona Vividos (APV)
# ============================================================

if (!exists("poblacion")) {
  source("script/00_config.R")
  source("script/01_poblacion.R")
}

# ------------------------------------------------------------
# Función auxiliar: convertir fecha a año decimal
# ------------------------------------------------------------

fecha_decimal <- function(fecha) {
  fecha <- as.Date(fecha)
  anio <- as.numeric(format(fecha, "%Y"))
  inicio_anio <- as.Date(paste0(anio, "-01-01"))
  fin_anio <- as.Date(paste0(anio + 1, "-01-01"))
  
  anio + as.numeric(fecha - inicio_anio) / as.numeric(fin_anio - inicio_anio)
}

# ------------------------------------------------------------
# Función de crecimiento exponencial
# N(t) = N0 * exp(r * h)
# ------------------------------------------------------------

expo <- function(N0, NT, t0, tT, t) {
  
  t0_dec <- fecha_decimal(t0)
  tT_dec <- fecha_decimal(tT)
  
  r <- log(NT / N0) / (tT_dec - t0_dec)
  h <- t - t0_dec
  
  Nt <- N0 * exp(r * h)
  
  return(Nt)
}

# ------------------------------------------------------------
# Pasar población a formato ancho
# ------------------------------------------------------------

poblacion_wide <- dcast(
  poblacion,
  edad + sexo ~ anio,
  value.var = "poblacion"
)

# ------------------------------------------------------------
# Calcular APV para 2010, 2019 y 2021
# ------------------------------------------------------------
# Se usan fechas de referencia censal para interpolar/extrapolar
# la población a mitad del año correspondiente.

poblacion_wide[, APV_2010 := expo(
  N0 = `2010`,
  NT = `2020`,
  t0 = "2010-03-15",
  tT = "2020-03-15",
  t = 2010.5
)]

poblacion_wide[, APV_2019 := expo(
  N0 = `2010`,
  NT = `2020`,
  t0 = "2010-03-15",
  tT = "2020-03-15",
  t = 2019.5
)]

poblacion_wide[, APV_2021 := expo(
  N0 = `2010`,
  NT = `2020`,
  t0 = "2010-03-15",
  tT = "2020-03-15",
  t = 2021.5
)]

# ------------------------------------------------------------
# Pasar APV a formato largo
# ------------------------------------------------------------

apv <- melt(
  poblacion_wide,
  id.vars = c("edad", "sexo"),
  measure.vars = c("APV_2010", "APV_2019", "APV_2021"),
  variable.name = "anio",
  value.name = "APV"
)

apv[, anio := as.numeric(gsub("APV_", "", anio))]

apv <- apv[, .(anio, sexo, edad, APV)]

setorder(apv, anio, sexo, edad)

# ------------------------------------------------------------
# Revisión final
# ------------------------------------------------------------

revision_apv <- apv[
  ,
  .(APV_total = sum(APV, na.rm = TRUE)),
  by = .(anio, sexo)
]

print("Revisión final de APV:")
print(revision_apv)
