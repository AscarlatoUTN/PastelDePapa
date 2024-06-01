module Library where
import PdePreludat
import Text.Show.Functions

---------------------- Estructuras ------------------------

type Cancion = String

data Artista = UnArtista
  { nombre :: String,
    canciones :: [Cancion]
  }
  deriving (Show, Eq)

fitito :: Artista
fitito =
  UnArtista
    { nombre = "Fitito Paez",
      canciones = ["11 y 6", "El amor despues del amor", "Mariposa Tecknicolor"]
    }

calamardo :: Artista
calamardo =
  UnArtista
    { nombre = "Andres Calamardo",
      canciones = ["Flaca", "Sin Documentos", "Tuyo siempre"]
    }

paty :: Artista
paty =
  UnArtista
    { nombre = "Taylor Paty",
      canciones = ["Shake It Off", "Lover"]
    }

---------------------- Parte 1 ------------------------

calificarCancion :: Cancion -> Number
calificarCancion = (+10) . length . filter minuscula

minuscula :: Char -> Bool
minuscula = flip elem ['a'..'z']

---------------------- Parte 2 ------------------------

esExitoso :: Artista -> Bool
esExitoso = (>50) . sum . map calificarCancion . buenasCanciones . canciones

buenasCanciones :: [Cancion] -> [Cancion]
buenasCanciones = filter ((>20) . calificarCancion)

---------------------- Parte 3 ------------------------

type Artistas = [Artista] -> [Artista]

artistasExitosos :: Artistas
artistasExitosos = filter esExitoso

---------------------- Parte 4 ------------------------

superFuncion :: Artistas
superFuncion = filter ((>50) . sum . map ((+10) . length . filter (`elem` ['a' .. 'z'])) . filter ((>20) . ((+10) . length . filter (`elem` ['a' .. 'z']))) . canciones)

---------------------- Parte 5 ------------------------

type Nombre = String
type Apellido = String

apellidosProlificos :: [Artista] -> [Apellido]
apellidosProlificos = concat . descomposicion . prolifico

prolifico :: Artistas
prolifico = filter ((>2) . length . canciones)

descomposicion :: [Artista] -> [[Nombre]]
descomposicion = apellidosArtistas . dividirArtista . nombresArtistas

nombresArtistas :: [Artista] -> [Nombre]
nombresArtistas = map nombre

dividirArtista :: [Nombre] -> [[Nombre]]
dividirArtista = map words

apellidosArtistas :: [[Nombre]] -> [[Apellido]]
apellidosArtistas = map tail

---------------------- Parte 6 ------------------------

apellidosProlificosLineal :: [Artista] -> [Apellido]
apellidosProlificosLineal = concatMap ((tail . words) . nombre)
  . filter ((> 2) . length . canciones)