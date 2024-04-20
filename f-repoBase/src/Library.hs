module Library where
import PdePreludat

-- Definición de tipos y estructuras de datos --

type Minutos = Number  -- Definimos un alias para Number llamado Minutos

-- Definimos el tipo de dato Cancion con sus respectivos campos
data Cancion = Cancion {
    titulo :: String,
    duracion :: Minutos,
    instrumentos :: [Instrumentos],
    acapella :: Bool
} deriving (Eq, Show)

-- Definimos el tipo de dato Repertorio como un tipo enumerado
data Repertorio = PatternMatching | SeisDieciocho | LaVidaEnHaskell | MalaVidaEnHaskell | TiemblanLosZurdos
    deriving (Eq, Show)

-- Función que devuelve la canción correspondiente a cada repertorio
cancionesRepertorio :: Repertorio -> Cancion
cancionesRepertorio PatternMatching = patternMatching
cancionesRepertorio SeisDieciocho = seisDieciocho
cancionesRepertorio LaVidaEnHaskell = laVidaEnHaskell
cancionesRepertorio MalaVidaEnHaskell = malaVidaEnHaskell
cancionesRepertorio TiemblanLosZurdos = tiemblanLosZurdos

-- Definimos el tipo de dato Instrumentos como un tipo enumerado
data Instrumentos = Guitarra | Bajo | Bateria | Teclado
    deriving (Eq, Show)

-- Definición de canciones --

patternMatching :: Cancion
patternMatching = Cancion {
    titulo = "Pattern Matching",
    duracion = 4,
    instrumentos = [Guitarra, Bajo, Bateria],
    acapella = False
}

seisDieciocho :: Cancion
seisDieciocho = Cancion {
    titulo = "Seis dieciocho",
    duracion = 3,
    instrumentos = [Teclado, Guitarra],
    acapella = False
}

laVidaEnHaskell :: Cancion
laVidaEnHaskell = Cancion {
    titulo = "La vida en Haskell",
    duracion = 5,
    instrumentos = [],
    acapella = True
}

malaVidaEnHaskell :: Cancion
malaVidaEnHaskell = Cancion {
    titulo = "Mala vida en Haskell",
    duracion = 5,
    instrumentos = [],
    acapella = True
}

tiemblanLosZurdos :: Cancion
tiemblanLosZurdos = Cancion {
    titulo = "Tiemblan los zurdos",
    duracion = 2,
    instrumentos = [Guitarra, Bateria],
    acapella = False
}

-- Definición de funciones --

-- Función que devuelve el primer carácter del título de una canción
primerCaracter :: Cancion -> Char
primerCaracter cancion = head (titulo cancion)

-- Función que verifica si la duración de una canción es un número par
duracionPar :: Cancion -> Bool
duracionPar cancion = rem (duracion cancion) 2 == 0

-- Función que verifica si una canción es acapella (no tiene instrumentos)
acapellaCancion :: Cancion -> Bool
acapellaCancion cancion = instrumentos cancion == []

-- Función que calcula la aceptación de una canción basándose en ciertas condiciones
aceptacionCancion :: Cancion -> Number
aceptacionCancion cancion
    | primerCaracter cancion == 'M' = 500
    | duracionPar cancion = 10 * length (titulo cancion)
    | acapellaCancion cancion = 10
    | otherwise = 0

-- Función que decide qué canción tocar basándose en el primer carácter del título
tocarCancion :: Repertorio -> Repertorio -> String
tocarCancion cancion1 cancion2
    | primerCaracter (cancionesRepertorio cancion1) <= primerCaracter (cancionesRepertorio cancion2) = titulo (cancionesRepertorio cancion1)
    | otherwise = titulo (cancionesRepertorio cancion2)

-- Función que verifica si una canción es aceptada por el público
aceptadaPorPublico :: Cancion -> Bool
aceptadaPorPublico cancion = aceptacionCancion cancion > 60

-- Función que verifica si un instrumento puede interpretar una canción
interpretarCancion :: Instrumentos -> Repertorio -> Bool
interpretarCancion instrumento cancion = elem (instrumento) (instrumentos (cancionesRepertorio cancion))

-- Función que decide cuánto tiempo tocar una canción basándose en si es aceptada por el público
tocarCancionAceptada :: Repertorio -> Minutos
tocarCancionAceptada cancion
    | aceptadaPorPublico (cancionesRepertorio cancion) = duracion (cancionesRepertorio cancion)
    | otherwise = (duracion (cancionesRepertorio cancion)) / 2