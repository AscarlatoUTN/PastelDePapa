module Library where
import PdePreludat
import Data.List (sort)

-- ----------------- Dominio ------------------

data Ciudad = UnaCiudad{
  nombre :: String,
  annio :: Number,            -- annio de fundación
  atracciones :: [String],
  costoDeVida :: Number
} deriving (Show, Eq)

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

-- ----------------- Parte 1 ------------------

valorDeUnaCiudad :: Ciudad -> Number
valorDeUnaCiudad ciudad 
  | annio ciudad < 1800 = valorCiudadFundadaAntesDe1800 ciudad
  | conAtracciones ciudad = 2 * costoDeVida ciudad
  | otherwise = 3 * costoDeVida ciudad

valorCiudadFundadaAntesDe1800 :: Ciudad -> Number
valorCiudadFundadaAntesDe1800 ciudad = 5 * (1800 - annio ciudad)

conAtracciones :: Ciudad -> Bool
conAtracciones = not . null . atracciones

-- ----------------- Parte 2 ------------------

-- Función 1
tieneAtraccionCopada :: Ciudad -> Bool
tieneAtraccionCopada  = elem True . primerCaracter

primerCaracter :: Ciudad -> [Bool]
primerCaracter ciudad = map empiezaConVocal (atracciones ciudad)

empiezaConVocal :: String -> Bool
empiezaConVocal palabra = elem (head palabra) ['A', 'E', 'I', 'O', 'U']

-- Función 2
esCiudadSobria :: Ciudad -> Number -> Bool
esCiudadSobria ciudad numeroLetras = all ((numeroLetras <) . length) (atracciones ciudad) && (conAtracciones ciudad)

-- Función 3
nombreRaro :: Ciudad -> Bool
nombreRaro = (< 5) . length . nombre

-- ----------------- Parte 3 ------------------

type Evento = Ciudad -> Ciudad

-- Función 1
sumarNuevaAtraccion :: String -> Evento
sumarNuevaAtraccion atraccion ciudad = ((agregarAtraccion atraccion) . (modificarCostoDeVida 1.2) ) ciudad

modificarCostoDeVida ::  Number -> Evento
modificarCostoDeVida x ciudad = ciudad { 
  costoDeVida = ((* x) . costoDeVida) ciudad
}

agregarAtraccion :: String -> Evento
agregarAtraccion atraccion ciudad = ciudad {
  atracciones = atracciones ciudad ++ [atraccion]
}
-- Función 2

crisis :: Evento
crisis ciudad
  | conAtracciones ciudad = ciudad {
      atracciones = init (atracciones ciudad),
      costoDeVida = costoDeVida ciudad * 0.9
    }
  | otherwise = ciudad { -- En caso de no tener atracciones
      atracciones = atracciones ciudad,
      costoDeVida = costoDeVida ciudad * 0.9
    }

-- Función 3
remodelacion :: Number -> Evento
remodelacion porcentaje ciudad = (agregarNewNombre . modificarCostoDeVida (conseguirPorcentaje porcentaje)) ciudad

agregarNewNombre :: Evento
agregarNewNombre ciudad = ciudad {nombre = "New " ++ nombre ciudad}

conseguirPorcentaje :: Number ->  Number
conseguirPorcentaje numero = 1 + (numero / 100)

-- Función 4

reevaluacion :: Number -> Evento
reevaluacion numeroLetras ciudad  
  | esCiudadSobria ciudad numeroLetras = modificarCostoDeVida 1.1 ciudad
  | otherwise = restarCostoDeVida 3 ciudad

restarCostoDeVida :: Number -> Evento
restarCostoDeVida x ciudad = ciudad {
  costoDeVida = costoDeVida ciudad - x
}

-- ----------------- Parte 4 ------------------

transformacion :: Number -> Number -> Evento
transformacion porcentaje numeroLetras = (reevaluacion  numeroLetras) . crisis . (remodelacion porcentaje)

--------------------- Entrega 2 ---------------------------

data Criterio = CostoDeVida | CantAtracciones
  deriving (Show, Eq)

data Annio = UnAnnio {
  pasoAnnio :: Number,
  eventos :: [Evento]
} deriving (Show, Eq)

dosMilVeintiDos :: Annio
dosMilVeintiDos = UnAnnio {
  pasoAnnio = 2022,
  eventos = [crisis, remodelacion 5, reevaluacion 7]
}

dosMilQuince :: Annio
dosMilQuince = UnAnnio {
  pasoAnnio = 2015,
  eventos = []
}

-- Parte 4

-- Funcion 1

pasoDelAnnio :: Annio -> Evento
pasoDelAnnio pasoAnnio ciudad = foldl (\ciudadAnnio eventos -> eventos ciudadAnnio) ciudad (eventos pasoAnnio) 

-- Funcion 2

-- Comparar una ciudad antes y después de un evento
compararCiudad :: Ciudad -> Criterio -> Evento -> Bool
compararCiudad ciudad criterio evento
  | criterio == CostoDeVida = compararCostoDeVida ciudad evento
  | criterio == CantAtracciones = compararCantAtracciones ciudad evento

-- Comparar el costo de vida de la ciudad antes y después del evento
compararCostoDeVida :: Ciudad -> Evento -> Bool
compararCostoDeVida ciudad evento = costoDeVida (aplicarEvento evento ciudad) > costoDeVida ciudad

-- Comparar la cantidad de atracciones de la ciudad antes y después del evento
compararCantAtracciones :: Ciudad -> Evento -> Bool
compararCantAtracciones ciudad evento = length (atracciones (aplicarEvento evento ciudad)) > length (atracciones ciudad)

-- Aplicar un evento a una ciudad
aplicarEvento :: Evento -> Ciudad -> Ciudad
aplicarEvento evento ciudad = evento ciudad


-- Funcion 3

eventoAumentaCostoDeVida :: Annio -> Ciudad -> Ciudad
eventoAumentaCostoDeVida annio ciudad = foldl (flip aplicarEvento) ciudad (filter (compararCostoDeVida ciudad) (eventos annio))

-- Funcion 4

eventoDisminuyeCostoDeVida :: Annio -> Ciudad -> Ciudad
eventoDisminuyeCostoDeVida annio ciudad = foldl (flip aplicarEvento) ciudad (filter (not . compararCostoDeVida ciudad) (eventos annio))

-- Funcion 5

aplicarSiAumentaValorCiudad :: Ciudad -> Evento -> Bool
aplicarSiAumentaValorCiudad ciudad evento = (valorDeUnaCiudad (aplicarEvento evento ciudad)) > valorDeUnaCiudad ciudad

eventoAumentaValor :: Ciudad -> Annio -> Ciudad
eventoAumentaValor ciudad annio = foldl (flip aplicarEvento) ciudad (filter (aplicarSiAumentaValorCiudad ciudad) (eventos annio))

--------------------- Parte 5 ---------------------------

eventosOrdenados :: Annio -> Ciudad -> Bool
eventosOrdenados annio ciudad = estaOrdenada (convertirAvalores annio ciudad)

estaOrdenada :: [Number] -> Bool
estaOrdenada lista = lista == sort lista

convertirAvalores :: Annio -> Ciudad -> [Number]
convertirAvalores anio ciudad = map (`aumentoDeCostoDeVida` ciudad) (eventos anio) 

aumentoDeCostoDeVida :: Evento -> Ciudad -> Number
aumentoDeCostoDeVida evento ciudad = costoDeVida (aplicarEvento evento ciudad) - costoDeVida ciudad

dosMilVeintiTres :: Annio
dosMilVeintiTres = UnAnnio {
  pasoAnnio = 2023,
  eventos = [crisis, sumarNuevaAtraccion "parque", remodelacion 10, remodelacion 20]
}

ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool
ciudadesOrdenadas evento ciudades = estaOrdenada (listaCostosDeVida evento ciudades)

listaCostosDeVida :: Evento -> [Ciudad] -> [Number]
listaCostosDeVida evento = map (costoDeVida . aplicarEvento evento) 