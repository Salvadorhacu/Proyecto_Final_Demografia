# ============================================================
# 01_poblacion.R
# Limpieza y prorrateo de población censal 2010 y 2020
# ============================================================

if (!exists("archivo_poblacion_2010")) {
  source("script/00_config.R")
}

leer_poblacion <- function(archivo, anio) {
  
  pob <- readxl::read_excel(archivo)
  setDT(pob)
  
  setnames(pob, names(pob), c("edad_texto", "total", "hombres", "mujeres"))
  
  pob[, edad_texto := str_trim(edad_texto)]
  
  pob[, total := as.numeric(total)]
  pob[, hombres := as.numeric(hombres)]
  pob[, mujeres := as.numeric(mujeres)]
  
  total_original <- pob[edad_texto == "Total",
                        .(total, hombres, mujeres)]
  
  pob_no_esp <- pob[edad_texto == "No especificado",
                    .(total, hombres, mujeres)]
  
  pob <- pob[
    !edad_texto %in% c("Total", "De 0 a 4 años", "No especificado")
  ]
  
  pob[, edad := case_when(
    edad_texto == "0 Años" ~ 0,
    edad_texto %in% c("1 Año", "2 Años", "3 Años", "4 Años") ~ 1,
    str_detect(edad_texto, "5 a 9") ~ 5,
    str_detect(edad_texto, "10 a 14") ~ 10,
    str_detect(edad_texto, "15 a 19") ~ 15,
    str_detect(edad_texto, "20 a 24") ~ 20,
    str_detect(edad_texto, "25 a 29") ~ 25,
    str_detect(edad_texto, "30 a 34") ~ 30,
    str_detect(edad_texto, "35 a 39") ~ 35,
    str_detect(edad_texto, "40 a 44") ~ 40,
    str_detect(edad_texto, "45 a 49") ~ 45,
    str_detect(edad_texto, "50 a 54") ~ 50,
    str_detect(edad_texto, "55 a 59") ~ 55,
    str_detect(edad_texto, "60 a 64") ~ 60,
    str_detect(edad_texto, "65 a 69") ~ 65,
    str_detect(edad_texto, "70 a 74") ~ 70,
    str_detect(edad_texto, "75 a 79") ~ 75,
    str_detect(edad_texto, "80 a 84") ~ 80,
    str_detect(edad_texto, "85") ~ 85,
    TRUE ~ NA_real_
  )]
  
  pob <- pob[
    !is.na(edad),
    .(
      hombres = sum(hombres, na.rm = TRUE),
      mujeres = sum(mujeres, na.rm = TRUE)
    ),
    by = edad
  ]
  
  # Prorrateo de edad no especificada
  total_hombres_conocido <- sum(pob$hombres, na.rm = TRUE)
  total_mujeres_conocido <- sum(pob$mujeres, na.rm = TRUE)
  
  no_esp_hombres <- pob_no_esp$hombres
  no_esp_mujeres <- pob_no_esp$mujeres
  
  pob[, prop_hombres := hombres / total_hombres_conocido]
  pob[, prop_mujeres := mujeres / total_mujeres_conocido]
  
  pob[, hombres := hombres + prop_hombres * no_esp_hombres]
  pob[, mujeres := mujeres + prop_mujeres * no_esp_mujeres]
  
  pob[, c("prop_hombres", "prop_mujeres") := NULL]
  
  pob_long <- melt(
    pob,
    id.vars = "edad",
    measure.vars = c("hombres", "mujeres"),
    variable.name = "sexo",
    value.name = "poblacion"
  )
  
  pob_long[, sexo := case_when(
    sexo == "hombres" ~ "Hombres",
    sexo == "mujeres" ~ "Mujeres"
  )]
  
  pob_long[, anio := anio]
  pob_long <- pob_long[, .(anio, sexo, edad, poblacion)]
  setorder(pob_long, anio, sexo, edad)
  
  revision <- pob_long[
    ,
    .(poblacion_total = sum(poblacion, na.rm = TRUE)),
    by = sexo
  ]
  
  revision_original <- data.table(
    sexo = c("Hombres", "Mujeres"),
    poblacion_original = c(total_original$hombres, total_original$mujeres)
  )
  
  revision <- merge(revision, revision_original, by = "sexo")
  revision[, diferencia := poblacion_total - poblacion_original]
  
  print(paste("Revisión población", anio))
  print(revision)
  
  return(pob_long)
}

poblacion_2010 <- leer_poblacion(archivo_poblacion_2010, 2010)
poblacion_2020 <- leer_poblacion(archivo_poblacion_2020, 2020)

poblacion <- rbind(poblacion_2010, poblacion_2020)

revision_poblacion <- poblacion[
  ,
  .(poblacion_total = sum(poblacion, na.rm = TRUE)),
  by = .(anio, sexo)
]

print("Revisión final de población:")
print(revision_poblacion)
