module Library where
import PdePreludat

-- ----------------- Dominio ------------------

data Ciudad = UnaCiudad{
  nombre :: Nombre,
  annio :: Annio,            -- annio de fundación
  atracciones :: [Atraccion],
  costoDeVida :: CostoDeVida
} deriving (Show, Eq)

-- ----------------- Definición de Tipos ------------------
type Atraccion = String
type Nombre = String
type Annio = Number
type CostoDeVida = Number
type Evento = Ciudad -> Ciudad

-- ----------------- Definición de Ciudades (Ejemplo) ------------------

baradero :: Ciudad
baradero = UnaCiudad {
  nombre = "Baradero",
  annio = 1615,
  atracciones = ["Parque del Este", "Museo Alejandro Barbich"],
  costoDeVida = 150
}

nullish :: Ciudad
nullish = UnaCiudad {
  nombre = "Nullish",
  annio = 1800,
  atracciones = [],
  costoDeVida = 140
}

caletaOlivia :: Ciudad
caletaOlivia = UnaCiudad {
  nombre = "CaletaOlivia",
  annio = 1901,
  atracciones = ["El Gorosito", "Faro Costanera"],
  costoDeVida = 120
}

maipu :: Ciudad
maipu = UnaCiudad {
  nombre = "Maipu",
  annio = 1878,
  atracciones = ["Fortín Kakel"],
  costoDeVida = 115
}

azul :: Ciudad
azul = UnaCiudad {
  nombre = "Azul",
  annio = 1832,
  atracciones = ["Teatro Espanniol", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
  costoDeVida = 190
}

-- ----------------- ENTREGA 1 ------------------

-- ----------------- Parte 1

valorDeUnaCiudad :: Ciudad -> CostoDeVida
valorDeUnaCiudad ciudad 
  | annio ciudad < 1800 = valorCiudadFundadaAntesDe1800 ciudad
  | conAtracciones ciudad = 2 * costoDeVida ciudad
  | otherwise = 3 * costoDeVida ciudad

valorCiudadFundadaAntesDe1800 :: Ciudad -> CostoDeVida
valorCiudadFundadaAntesDe1800 ciudad = 5 * (1800 - annio ciudad)

conAtracciones :: Ciudad -> Bool
conAtracciones = not . null . atracciones

-- ----------------- Parte 2 

vocales :: String
vocales = "AEIOU"

-- Función 1
tieneAtraccionCopada :: Ciudad -> Bool
tieneAtraccionCopada = any empiezaConVocal . atracciones

empiezaConVocal :: String -> Bool
empiezaConVocal palabra = elem (head palabra) vocales

-- Función 2
esCiudadSobria :: Ciudad -> Number -> Bool
esCiudadSobria ciudad numeroLetras = conAtracciones ciudad && atraccionesMenoresA ciudad numeroLetras

atraccionesMenoresA :: Ciudad -> Number -> Bool
atraccionesMenoresA ciudad numeroLetras = all ((< numeroLetras) . length) (atracciones ciudad)

-- Función 3
nombreRaro :: Ciudad -> Bool
nombreRaro = (< 5) . length . nombre

-- ----------------- Parte 3 

-- Función 1
sumarNuevaAtraccion :: String -> Evento
sumarNuevaAtraccion atraccion = agregarAtraccion atraccion . modificarCostoDeVida 1.2 

modificarCostoDeVida ::  Number -> Evento
modificarCostoDeVida cantidad ciudad = ciudad { 
  costoDeVida = ((* cantidad) . costoDeVida) ciudad
}

agregarAtraccion :: String -> Evento
agregarAtraccion atraccion ciudad = ciudad {
  atracciones = atracciones ciudad ++ [atraccion]
}
-- Función 2

crisis :: Evento
crisis ciudad = ciudad { 
  atracciones = cerrarUltimaAtraccion ciudad, 
  costoDeVida = 0.9 * costoDeVida ciudad 
}

cerrarUltimaAtraccion :: Ciudad -> [Atraccion]
cerrarUltimaAtraccion ciudad
  | conAtracciones ciudad = init (atracciones ciudad)
  | otherwise = []

-- Función 3
remodelacion :: Number -> Evento
remodelacion porcentaje = agregarPrefijoNombre "New " . modificarCostoDeVida (conseguirPorcentaje porcentaje)

agregarPrefijoNombre :: String -> Evento
agregarPrefijoNombre prefijo ciudad = ciudad {nombre = prefijo ++ nombre ciudad}

conseguirPorcentaje :: Number -> Number
conseguirPorcentaje numero = 1 + (numero / 100)

-- Función 4

reevaluacion :: Number -> Evento
reevaluacion numeroLetras ciudad  
  | esCiudadSobria ciudad numeroLetras = modificarCostoDeVida 1.1 ciudad
  | otherwise = restarCostoDeVida 3 ciudad

restarCostoDeVida :: Number -> Evento
restarCostoDeVida cantidad ciudad = ciudad {
  costoDeVida = costoDeVida ciudad - cantidad
}

-- ----------------- Parte 4 

transformacion :: Number -> Number -> Evento
transformacion porcentaje numeroLetras = reevaluacion numeroLetras . crisis . remodelacion porcentaje

-- ------------------- ENTREGA 2 ---------------------------

-- ----------------- Dominio ------------------

data Criterio = CostoDeVida | CantAtracciones
  deriving (Show, Eq)

data Anio = UnAnio {
  pasoAnnio :: Annio,
  eventos :: [Evento]
} deriving (Show, Eq)

-- ----------------- Definición de Annios (Ejemplo) ------------------


dosMilQuince :: Anio
dosMilQuince = UnAnio {
  pasoAnnio = 2015,
  eventos = []
}

dosMilVeintiDos :: Anio
dosMilVeintiDos = UnAnio {
  pasoAnnio = 2022,
  eventos = [crisis, remodelacion 5, reevaluacion 7]
}

dosMilVeintiTres :: Anio
dosMilVeintiTres = UnAnio {
  pasoAnnio = 2023,
  eventos = [crisis, sumarNuevaAtraccion "parque", remodelacion 10, remodelacion 20]
}

-- ----------------- Parte 4 

-- Funcion 1

pasoDelAnnio :: Anio -> Evento
pasoDelAnnio anio ciudad = foldl (\ciudadAnnio eventos -> eventos ciudadAnnio) ciudad (eventos anio) 

-- Funcion 2

-- Comparar una ciudad antes y después de un evento usando una función de comparación genérica
compararCiudad :: Ciudad -> Criterio -> Evento -> Bool
compararCiudad ciudad criterio evento = compararSegunCriterio ciudad (obtenerCriterio criterio) evento

-- Función genérica para comparar cualquier propiedad de la ciudad
compararSegunCriterio :: Ciudad -> (Ciudad -> a) -> Evento -> Bool
compararSegunCriterio ciudad criterio evento = criterio (evento ciudad) > propiedad ciudad

-- Seleccionar la propiedad de la ciudad basada en el criterio
obtenerCriterio :: Criterio -> (Ciudad -> a)
obtenerCriterio CostoDeVida = costoDeVida
obtenerCriterio CantAtracciones = length . atracciones

-- Funcion 3 y 4

-- Función para eventos que aumentan el costo de vida
eventoAumentaCostoDeVida :: Anio -> Ciudad -> Ciudad
eventoAumentaCostoDeVida annio ciudad =
  aplicarEventosSegunCondicion (obtenerCriterio CostoDeVida) (>) annio ciudad

-- Función para eventos que disminuyen el costo de vida
eventoDisminuyeCostoDeVida :: Anio -> Ciudad -> Ciudad
eventoDisminuyeCostoDeVida annio ciudad =
  aplicarEventosSegunCondicion (not . obtenerCriterio CostoDeVida) (<) annio ciudad

-- Función genérica para aplicar eventos según un predicado dado
aplicarEventosSegunCondicion :: (Evento -> Bool) -> Anio -> Ciudad -> Ciudad
aplicarEventosSegunCondicion cond annio ciudad =
  foldl (flip aplicarEvento) ciudad (filter cond (eventos annio))

-- Aplicar un evento a una ciudad 
aplicarEvento :: Evento -> Ciudad -> Ciudad
aplicarEvento evento ciudad = evento ciudad

-- Funcion 5

-- Función para determinar si un evento aumenta el valor de una ciudad
aumentaValorCiudad :: Ciudad -> Evento -> Bool
aumentaValorCiudad ciudad evento = (valorDeUnaCiudad (aplicarEvento evento ciudad)) > valorDeUnaCiudad ciudad

-- Función para eventos que aumentan el valor de una ciudad
eventoAumentaValor ciudad annio =
  aplicarEventosSegunCondicion (aumentaValorCiudad ciudad) annio ciudad

-- ------------------- Parte 5 

eventosOrdenados :: Anio -> Ciudad -> Bool
eventosOrdenados annio ciudad = estaOrdenada (convertirAvalores annio ciudad)

estaOrdenada :: [Number] -> Bool
estaOrdenada [] = True
estaOrdenada (x:y:xs) = x <= y && estaOrdenada (y:xs)

convertirAvalores :: Anio -> Ciudad -> [Number]
convertirAvalores anio ciudad = map (`aumentoDeCostoDeVida` ciudad) (eventos anio) 

aumentoDeCostoDeVida :: Evento -> Ciudad -> Number
aumentoDeCostoDeVida evento ciudad = costoDeVida (aplicarEvento evento ciudad) - costoDeVida ciudad

ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool
ciudadesOrdenadas evento ciudades = estaOrdenada (listaCostosDeVida evento ciudades)

listaCostosDeVida :: Evento -> [Ciudad] -> [Number]
listaCostosDeVida evento = map (costoDeVida . aplicarEvento evento)

-- ------------------- Parte 6