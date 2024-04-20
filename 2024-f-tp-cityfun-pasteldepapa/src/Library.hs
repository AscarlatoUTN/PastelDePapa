module Library where
import PdePreludat

-- Dominio --

data Ciudad = Ciudad {
  nombre :: String,
  año :: Number,
  atracciones :: [String],
  costoDeVida :: Number
} deriving (Show, Eq)

-- Definiciones de ciudades

baradero :: Ciudad
baradero = Ciudad {
  nombre = "Baradero",
  año = 1615,
  atracciones = ["Parque del Este", "Museo Alejandro Barbich"],
  costoDeVida = 150
}

nullish :: Ciudad
nullish = Ciudad {
  nombre = "Nullish",
  año = 1800,
  atracciones = [],
  costoDeVida = 140
}

caletaOlivia :: Ciudad
caletaOlivia = Ciudad {
  nombre = "CaletaOlivia",
  año = 1901,
  atracciones = ["El Gorosito", "Faro Costanera"],
  costoDeVida = 120
}

maipu :: Ciudad
maipu = Ciudad {
  nombre = "Maipu",
  año = 1878,
  atracciones = ["Fortín Kakel"],
  costoDeVida = 115
}

azul :: Ciudad
azul = Ciudad {
  nombre = "Azul",
  año = 1832,
  atracciones = ["Teatro Español", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
  costoDeVida = 190
}

-- Parte 1 --

valorDeUnaCiudad :: Ciudad -> Number
valorDeUnaCiudad ciudad 
  | año ciudad < 1800 = valorCiudadFundadaAntesDe1800 ciudad
  | (null . atracciones) ciudad = 2 * costoDeVida ciudad
  | otherwise = 3 * costoDeVida ciudad

valorCiudadFundadaAntesDe1800 :: Ciudad -> Number
valorCiudadFundadaAntesDe1800 ciudad = 5 * (1800 - año ciudad)

-- Parte 2 --

-- Funcion 1
tieneAtraccionCopada :: Ciudad -> Bool
tieneAtraccionCopada  = elem True . primerCaracter

primerCaracter :: Ciudad -> [Bool]
primerCaracter ciudad = map empiezaConVocal (atracciones ciudad)

empiezaConVocal :: String -> Bool
empiezaConVocal palabra = elem (head palabra) ['A', 'E', 'I', 'O', 'U']

-- Funcion 2
esCiudadSobria :: Ciudad -> Number -> Bool
esCiudadSobria ciudad x = (all (== True) (atraccionesTienenMasDeXLetras ciudad x)) && (not (null (atracciones ciudad)))

atraccionesTienenMasDeXLetras :: Ciudad -> Number -> [Bool]
atraccionesTienenMasDeXLetras ciudad x = map (x <) (longitudDeAtracciones ciudad)

longitudDeAtracciones :: Ciudad -> [Number]
longitudDeAtracciones ciudad = map length (atracciones ciudad)

-- Funcion 3
nombreRaro :: Ciudad -> Bool
nombreRaro = (< 5) . length . nombre

-- Parte 3 --



-- Parte 4 --