module Escuelita where
import PdePreludat
import Data.List (delete, sort)

type Material = String
type Habilidad = String
type Chasquido = Universo -> Universo
type Planeta = String

data Universo = UnUniverso {
    nombre :: String,
    personajes :: [Personaje]
} deriving (Show, Eq)

galaxia = UnUniverso "galaxia" [ironMan, drStrange, groot, wolverine]

data Guantelete = UnGuantelete {
    material :: [Material],
    gemas :: [Gema]
} deriving (Show, Eq)

data Personaje = UnPersonaje {
    personaje :: String,
    edad :: Number,
    energia :: Number,
    habilidades :: [Habilidad],
    planeta :: Planeta
} deriving (Show, Eq)

ironMan = UnPersonaje "ironMan" 34 80 ["volar", "rayos", "usar Mjolnir"] "tierra"
drStrange = UnPersonaje "drStrange" 40 20 ["telepatia", "telequinesis", "teletransportacion"] "tierra"
groot = UnPersonaje "groot" 5 60 ["fuerza", "regeneracion"] "tierra"
wolverine = UnPersonaje "wolverine" 44 60 ["garras", "programacion en Haskell"] "tierra"

----------------- Punto 1 -----------------
chasquear :: Guantelete -> Chasquido
chasquear guante universo
    | length (gemas guante) == 6 = universo { personajes = take ((floor . (/ 2) . length . personajes) universo) (personajes universo) }
    | otherwise = universo

----------------- Punto 2 -----------------
saber :: (Universo -> Bool) -> Universo -> Bool
saber criterio = criterio

pendex :: Universo -> Bool
pendex = all ((<45) . edad) . personajes

energiaTotal :: Universo -> Number
energiaTotal = sum . map energia . filter ((>1) . length . habilidades) . personajes
--foldl1 (+) . map energia . filter ((>1) . length . habilidades) . personajes

----------------- Punto 3 -----------------
type Gema = Personaje -> Personaje

mente :: Number -> Gema
mente num personaje = personaje { energia = quitarEnergia num personaje }

alma :: Habilidad -> Gema
alma habilidad personaje = personaje { energia = quitarEnergia 10 personaje, habilidades = delete habilidad (habilidades personaje)}

espacio :: Planeta -> Gema
espacio planeta personaje = personaje { energia = quitarEnergia 20 personaje, planeta = planeta }

poder :: Gema
poder personaje = personaje { energia = 0, habilidades = quitarHabilidad personaje }

quitarHabilidad :: Personaje -> [Habilidad]
quitarHabilidad personaje
    | length (habilidades personaje) > 2 = habilidades personaje
    | otherwise = []

tiempo :: Gema
tiempo personaje = personaje { energia = quitarEnergia 50 personaje, edad = bajarEdad personaje }

loca :: Gema -> Personaje -> Personaje
loca gema = gema . gema

bajarEdad :: Personaje -> Number
bajarEdad personaje
    | edad personaje < 36 = 18
    | otherwise = floor (edad personaje / 2)

quitarEnergia :: Number -> Personaje -> Number
quitarEnergia num personaje
    | energia personaje < num = 0
    | otherwise = energia personaje - num

----------------- Punto 4 -----------------
guanteleteGoma = UnGuantelete ["uru"] [tiempo, alma "usar Mjolnir", loca (alma "programacion en Haskell")]

----------------- Punto 5 -----------------
utilizar ::[Gema] -> Personaje -> Personaje
utilizar = foldl1 (.)

----------------- Punto 6 ----------------- Sort manual ---
gemaMasPoderosa :: Guantelete -> Personaje -> Personaje
gemaMasPoderosa guantelete = menorEnergia . aplicarPoderes (gemas guantelete)

aplicarPoderes :: [Gema] -> Personaje -> [Personaje]
aplicarPoderes [] _ = []
aplicarPoderes (gema:gemas) personaje = gema personaje : aplicarPoderes gemas personaje

menorEnergia :: [Personaje] -> Personaje
menorEnergia (actual:restantes)
    | null restantes = actual
    | energia actual < energia (head restantes) = menorEnergia (actual:tail restantes)
    | otherwise = menorEnergia restantes

----------------- Punto 7 -----------------
{-
No, ya que el guante está compuesto por una lista de materiales, y en caso de que sea de tan sólo un material, este debe estar dentro de una lista.
1. No, ya que nunca terminará de aplicar los poderes de las infinitas gemas sobre el personaje.
2. Si, ya que take 3 obtiene los primeros 3 elementos de la lista, y como haskell utiliza lazy evaluation, no tiene por qué importarte lo que resta de la infinita lista.
-}