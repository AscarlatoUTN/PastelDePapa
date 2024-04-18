module Library where
import PdePreludat

-- Estructuras --

type Minutos = Number

data Cancion = Cancion {
    titulo :: String,
    duracion :: Minutos,
    instrumentos :: [Instrumentos],
    acapella :: Bool
} deriving (Eq, Show)

data Repertorio = PatternMatching | SeisDieciocho | LaVidaEnHaskell | MalaVidaEnHaskell | TiemblanLosZurdos
    deriving (Eq, Show)

cancionesRepertorio :: Repertorio -> Cancion
cancionesRepertorio PatternMatching = patternMatching
cancionesRepertorio SeisDieciocho = seisDieciocho
cancionesRepertorio LaVidaEnHaskell = laVidaEnHaskell
cancionesRepertorio MalaVidaEnHaskell = malaVidaEnHaskell
cancionesRepertorio TiemblanLosZurdos = tiemblanLosZurdos

data Instrumentos = Guitarra | Bajo | Bateria | Teclado
    deriving (Eq, Show)

-- Canciones --

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

-- Funciones --

primerCaracter :: Cancion -> Char
primerCaracter cancion = head (titulo cancion)

duracionPar :: Cancion -> Bool
duracionPar cancion = rem (duracion cancion) 2 == 0

acapellaCancion :: Cancion -> Bool
acapellaCancion cancion = instrumentos cancion == []

aceptacionCancion :: Cancion -> Number
aceptacionCancion cancion
    | primerCaracter cancion == 'M' = 500
    | duracionPar cancion = 10 * length (titulo cancion)
    | acapellaCancion cancion = 10
    | otherwise = 0

tocarCancion :: Repertorio -> Repertorio -> String
tocarCancion cancion1 cancion2
    | primerCaracter (cancionesRepertorio cancion1) <= primerCaracter (cancionesRepertorio cancion2) = titulo (cancionesRepertorio cancion1)
    | otherwise = titulo (cancionesRepertorio cancion2)

aceptadaPorPublico :: Cancion -> Bool
aceptadaPorPublico cancion = aceptacionCancion cancion > 60

interpretarCancion :: Instrumentos -> Repertorio -> Bool
interpretarCancion instrumento cancion = elem (instrumento) (instrumentos (cancionesRepertorio cancion))

tocarCancionAceptada :: Repertorio -> Minutos
tocarCancionAceptada cancion
    | aceptadaPorPublico (cancionesRepertorio cancion) = duracion (cancionesRepertorio cancion)
    | otherwise = (duracion (cancionesRepertorio cancion)) / 2