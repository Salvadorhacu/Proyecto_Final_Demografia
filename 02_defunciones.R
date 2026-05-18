# ============================================================
# 02_defunciones.R
# Limpieza y prorrateo de defunciones registradas
# ============================================================

if (!exists("archivo_defunciones")) {
  source("script/00_config.R")
}

# ------------------------------------------------------------
# Leer base limpia de defunciones
# ------------------------------------------------------------

def_raw <- readxl::read_excel(archivo_defunciones)
setDT(def_raw)

# Homologar nombres
setnames(def_raw, names(def_raw), c("edad_texto", "anio_registro", "anio_ocurrencia",
                                    "total", "hombres", "mujeres", "no_especificado"))

# Limpiar texto
def_raw[, edad_texto := str_trim(edad_texto)]
def_raw[, anio_ocurrencia := str_trim(as.character(anio_ocurrencia))]

# Convertir cantidades a número
def_raw[, total := as.numeric(total)]
def_raw[, hombres := as.numeric(hombres)]
def_raw[, mujeres := as.numeric(mujeres)]
def_raw[, no_especificado := as.numeric(no_especificado)]

# Reemplazar NA por cero en columnas numéricas
def_raw[is.na(total), total := 0]
def_raw[is.na(hombres), hombres := 0]
def_raw[is.na(mujeres), mujeres := 0]
def_raw[is.na(no_especificado), no_especificado := 0]

# ------------------------------------------------------------
# Quitar filas que no sirven para tabla de vida
# ------------------------------------------------------------

def_raw <- def_raw[
  edad_texto != "Total" &
    anio_ocurrencia != "Total" &
    anio_ocurrencia != "No especificado"
]

# Convertir año de ocurrencia a numérico
def_raw[, anio_ocurrencia := as.numeric(anio_ocurrencia)]

# Filtrar años necesarios
def_raw <- def_raw[
  anio_ocurrencia %in% anios_defunciones
]

# ------------------------------------------------------------
# Crear edad inicial del grupo
# ------------------------------------------------------------

def_raw[, edad := case_when(
  str_detect(edad_texto, "Menores de 1") ~ 0,
  str_detect(edad_texto, "1-4") ~ 1,
  str_detect(edad_texto, "5-9") ~ 5,
  str_detect(edad_texto, "10-14") ~ 10,
  str_detect(edad_texto, "15-19") ~ 15,
  str_detect(edad_texto, "20-24") ~ 20,
  str_detect(edad_texto, "25-29") ~ 25,
  str_detect(edad_texto, "30-34") ~ 30,
  str_detect(edad_texto, "35-39") ~ 35,
  str_detect(edad_texto, "40-44") ~ 40,
  str_detect(edad_texto, "45-49") ~ 45,
  str_detect(edad_texto, "50-54") ~ 50,
  str_detect(edad_texto, "55-59") ~ 55,
  str_detect(edad_texto, "60-64") ~ 60,
  str_detect(edad_texto, "65-69") ~ 65,
  str_detect(edad_texto, "70-74") ~ 70,
  str_detect(edad_texto, "75-79") ~ 75,
  str_detect(edad_texto, "80-84") ~ 80,
  str_detect(edad_texto, "85") ~ 85,
  TRUE ~ NA_real_
)]

# Quitar edades no especificadas por ahora
def_edad_no_esp <- def_raw[is.na(edad)]

def_raw <- def_raw[!is.na(edad)]

# ------------------------------------------------------------
# Agrupar por año de ocurrencia y edad
# Ignoramos año de registro
# ------------------------------------------------------------

def <- def_raw[
  ,
  .(
    total = sum(total, na.rm = TRUE),
    hombres = sum(hombres, na.rm = TRUE),
    mujeres = sum(mujeres, na.rm = TRUE),
    no_especificado = sum(no_especificado, na.rm = TRUE)
  ),
  by = .(anio_ocurrencia, edad)
]

# ------------------------------------------------------------
# Prorrateo del sexo no especificado
# ------------------------------------------------------------

def[, total_sexo_conocido := hombres + mujeres]

def[, prop_hombres := fifelse(total_sexo_conocido > 0,
                              hombres / total_sexo_conocido,
                              0)]

def[, prop_mujeres := fifelse(total_sexo_conocido > 0,
                              mujeres / total_sexo_conocido,
                              0)]

def[, hombres := hombres + prop_hombres * no_especificado]
def[, mujeres := mujeres + prop_mujeres * no_especificado]

def[, c("total_sexo_conocido", "prop_hombres", "prop_mujeres") := NULL]

# ------------------------------------------------------------
# Pasar a formato largo
# ------------------------------------------------------------

def_long <- melt(
  def,
  id.vars = c("anio_ocurrencia", "edad"),
  measure.vars = c("hombres", "mujeres"),
  variable.name = "sexo",
  value.name = "defunciones"
)

def_long[, sexo := case_when(
  sexo == "hombres" ~ "Hombres",
  sexo == "mujeres" ~ "Mujeres",
  TRUE ~ sexo
)]

# ------------------------------------------------------------
# Crear años de referencia
# 2009-2011 -> 2010
# 2018-2019 -> 2019
# 2020-2022 -> 2021
# ------------------------------------------------------------

def_long[, anio := case_when(
  anio_ocurrencia %in% c(2009, 2010, 2011) ~ 2010,
  anio_ocurrencia %in% c(2018, 2019) ~ 2019,
  anio_ocurrencia %in% c(2020, 2021, 2022) ~ 2021,
  TRUE ~ NA_real_
)]

# ------------------------------------------------------------
# Promediar defunciones para cada año de referencia
# ------------------------------------------------------------

defunciones <- def_long[
  !is.na(anio),
  .(
    defunciones = mean(defunciones, na.rm = TRUE)
  ),
  by = .(anio, sexo, edad)
]

setorder(defunciones, anio, sexo, edad)

# ------------------------------------------------------------
# Revisión final
# ------------------------------------------------------------

revision_defunciones <- defunciones[
  ,
  .(defunciones_total = sum(defunciones, na.rm = TRUE)),
  by = .(anio, sexo)
]

print("Revisión final de defunciones:")
print(revision_defunciones)
