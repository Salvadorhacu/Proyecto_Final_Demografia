# ============================================================
# 04_tablas_vida.R
# Construcción de tablas de mortalidad para Michoacán
# Años: 2010, 2019 y 2021
# Sexo: Hombres y Mujeres
# ============================================================

if (!exists("apv") | !exists("defunciones")) {
  source("script/00_config.R")
  source("script/01_poblacion.R")
  source("script/02_defunciones.R")
  source("script/03_apv.R")
}

# ------------------------------------------------------------
# Función para calcular una tabla de mortalidad abreviada
# ------------------------------------------------------------

calcular_tabla_vida <- function(datos, sexo_actual, anio_actual, l0 = 100000) {
  
  # Ordenar datos por edad
  datos <- datos[order(edad)]
  
  # Edad inicial de cada intervalo
  x <- datos$edad
  
  # Amplitud del intervalo n
  # 0 a 1 = 1
  # 1 a 5 = 4
  # 5 a 10 = 5
  # ...
  # último grupo = abierto
  n <- c(diff(x), NA)
  
  # Tasas centrales de mortalidad
  mx <- datos$mx
  
  # ------------------------------------------------------------
  # Calcular ax
  # ------------------------------------------------------------
  # ax = años-persona promedio vividos por quienes mueren
  # dentro del intervalo.
  
  ax <- rep(NA_real_, length(x))
  
  # Para edades de 5 años en adelante, excepto grupo abierto:
  # se usa n/2, por ejemplo 2.5 en grupos quinquenales.
  ax[!x %in% c(0, 1) & !is.na(n)] <- n[!x %in% c(0, 1) & !is.na(n)] / 2
  
  # Mortalidad infantil m0
  m0 <- mx[x == 0][1]
  
  # Edad 0: Coale-Demeny, según sexo
  if (any(x == 0)) {
    if (sexo_actual == "Hombres") {
      ax[x == 0] <- ifelse(m0 >= 0.107,
                           0.330,
                           0.045 + 2.684 * m0)
    }
    
    if (sexo_actual == "Mujeres") {
      ax[x == 0] <- ifelse(m0 >= 0.107,
                           0.350,
                           0.053 + 2.800 * m0)
    }
  }
  
  # Edad 1-4: Coale-Demeny, según sexo
  if (any(x == 1)) {
    if (sexo_actual == "Hombres") {
      ax[x == 1] <- ifelse(m0 >= 0.107,
                           1.352,
                           1.651 - 2.816 * m0)
    }
    
    if (sexo_actual == "Mujeres") {
      ax[x == 1] <- ifelse(m0 >= 0.107,
                           1.361,
                           1.522 - 1.518 * m0)
    }
  }
  
  # Para el grupo abierto, se usa ax = 1 / mx
  # Esto permite que Lx = lx / mx en el último grupo.
  ax[length(ax)] <- 1 / mx[length(mx)]
  
  # ------------------------------------------------------------
  # Calcular qx
  # ------------------------------------------------------------
  # qx = (n * mx) / (1 + (n - ax) * mx)
  # Para el grupo abierto qx = 1.
  
  qx <- (n * mx) / (1 + (n - ax) * mx)
  qx[length(qx)] <- 1
  
  # Evitar valores fuera de rango por redondeos
  qx <- pmin(pmax(qx, 0), 1)
  
  # ------------------------------------------------------------
  # Calcular px
  # ------------------------------------------------------------
  
  px <- 1 - qx
  
  # ------------------------------------------------------------
  # Calcular lx
  # ------------------------------------------------------------
  
  lx <- numeric(length(x))
  lx[1] <- l0
  
  for (i in 2:length(lx)) {
    lx[i] <- lx[i - 1] * px[i - 1]
  }
  
  # ------------------------------------------------------------
  # Calcular dx
  # ------------------------------------------------------------
  
  dx <- lx * qx
  
  # ------------------------------------------------------------
  # Calcular Lx
  # ------------------------------------------------------------
  # Para intervalos cerrados:
  # Lx = n * l(x+n) + ax * dx
  #
  # Para grupo abierto:
  # Lx = lx / mx
  
  Lx <- numeric(length(x))
  
  for (i in 1:(length(x) - 1)) {
    Lx[i] <- n[i] * lx[i + 1] + ax[i] * dx[i]
  }
  
  Lx[length(x)] <- lx[length(x)] / mx[length(mx)]
  
  # ------------------------------------------------------------
  # Calcular Tx
  # ------------------------------------------------------------
  
  Tx <- rev(cumsum(rev(Lx)))
  
  # ------------------------------------------------------------
  # Calcular ex
  # ------------------------------------------------------------
  
  ex <- Tx / lx
  
  # ------------------------------------------------------------
  # Tabla final
  # ------------------------------------------------------------
  
  tabla <- data.table(
    anio = anio_actual,
    sexo = sexo_actual,
    edad = x,
    n = n,
    mx = mx,
    ax = ax,
    qx = qx,
    px = px,
    lx = lx,
    dx = dx,
    Lx = Lx,
    Tx = Tx,
    ex = ex
  )
  
  return(tabla)
}

# ------------------------------------------------------------
# Unir APV con defunciones
# ------------------------------------------------------------

base_tabla <- merge(
  apv,
  defunciones,
  by = c("anio", "sexo", "edad"),
  all.x = TRUE
)

# Si hay edades sin defunciones registradas, se toman como cero
base_tabla[is.na(defunciones), defunciones := 0]

# Calcular tasa central de mortalidad
base_tabla[, mx := defunciones / APV]

# Evitar problemas en caso de tasas cero en el grupo abierto
base_tabla[mx == 0, mx := NA_real_]

# Quitar registros problemáticos
base_tabla <- base_tabla[
  !is.na(mx) & is.finite(mx) & APV > 0
]

setorder(base_tabla, anio, sexo, edad)

# ------------------------------------------------------------
# Construir las 6 tablas de vida
# ------------------------------------------------------------

tabla_mortalidad <- data.table()

for (a in anios_objetivo) {
  for (s in c("Hombres", "Mujeres")) {
    
    datos_aux <- base_tabla[anio == a & sexo == s]
    
    tabla_aux <- calcular_tabla_vida(
      datos = datos_aux,
      sexo_actual = s,
      anio_actual = a,
      l0 = l0
    )
    
    tabla_mortalidad <- rbind(tabla_mortalidad, tabla_aux)
  }
}

setorder(tabla_mortalidad, anio, sexo, edad)

# ------------------------------------------------------------
# Cuadro de esperanza de vida al nacer
# ------------------------------------------------------------

esperanza_vida <- tabla_mortalidad[
  edad == 0,
  .(
    anio,
    sexo,
    esperanza_vida_nacer = ex
  )
]

# ------------------------------------------------------------
# Revisión final
# ------------------------------------------------------------

print("Esperanza de vida al nacer por año y sexo:")
print(esperanza_vida)

print("Revisión rápida de tablas generadas:")
print(tabla_mortalidad[, .N, by = .(anio, sexo)])

# ------------------------------------------------------------
# Guardar salidas
# ------------------------------------------------------------

if (!dir.exists(ruta_graficos)) {
  dir.create(ruta_graficos)
}

fwrite(
  tabla_mortalidad,
  paste0(ruta_graficos, "tabla_mortalidad_michoacan_2010_2019_2021.csv")
)

fwrite(
  esperanza_vida,
  paste0(ruta_graficos, "esperanza_vida_michoacan.csv")
)
