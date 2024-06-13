module Minigolfito () where
import PdePreludat

-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Number,
  precisionJugador :: Number
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  palo :: String,
  velocidad :: Number,
  precision :: Number,
  altura :: Number
} deriving (Eq, Show)

type Puntos = Number

----------------- Parte 1 -----------------
type Palo = Tiro

--------- Punto A ---------

putter :: Jugador -> Number -> Palo 
putter jugador _ = tiroPutter jugador

tiroPutter :: Jugador -> Tiro
tiroPutter jugador = UnTiro "Putter" 10 (2 * precisionJugador (habilidad jugador)) 0

madera :: Jugador -> Number -> Palo 
madera jugador _ = tiroMadera jugador

tiroMadera :: Jugador -> Tiro
tiroMadera jugador = UnTiro "Madera" 100 (0.5 * precisionJugador (habilidad jugador)) 5

hierros :: Jugador -> Number -> Palo 
hierros jugador n = tiroHierros n jugador

tiroHierros :: Number -> Jugador -> Tiro
tiroHierros n jugador = UnTiro "Hierros" (n * fuerzaJugador (habilidad jugador)) (precisionHierros n jugador) (alturaHierros n)

alturaHierros :: Number -> Number
alturaHierros n
    | (n - 3) < 0 = 0
    | otherwise = n - 3

precisionHierros :: Number -> Jugador -> Number
precisionHierros n jugador
    | n <= 0 = 0
    | otherwise = precisionJugador (habilidad jugador) / n

--------- Punto B ---------
palos :: Jugador -> Number -> [Palo]
palos jugador n = [putter jugador n, madera jugador n, hierros jugador n]

----------------- Parte 2 -----------------
type Golpe = Jugador -> Number -> (Jugador -> Number -> Palo) -> Tiro

golpe :: Golpe
golpe jugador n palo = palo jugador n

----------------- Parte 3 -----------------
type Obstaculo = Tiro -> Number -> Tiro

tiroNulo = UnTiro "Ninguno" 0 0 0

--------- Punto A ---------
tunel :: Obstaculo
tunel golpeo _
    | superaTunel golpeo = UnTiro (palo golpeo) (velocidad golpeo * 2) 100 0
    | otherwise = tiroNulo
    
superaTunel :: Tiro -> Bool
superaTunel golpeo
    | precision golpeo > 90 && altura golpeo == 0 = True
    | otherwise = False

--------- Punto B ---------
laguna :: Obstaculo
laguna golpeo largo
    | superaLaguna golpeo = UnTiro (palo golpeo) (velocidad golpeo) (precision golpeo) (alturaLaguna largo golpeo)
    | otherwise = tiroNulo

superaLaguna :: Tiro -> Bool
superaLaguna golpeo
    | velocidad golpeo > 80 && elem (altura golpeo) [1..5] = True
    | otherwise = False

alturaLaguna :: Number -> Tiro -> Number
alturaLaguna largo
    | largo <= 0 = (* 0) . altura
    | otherwise = (/largo) . altura

--------- Punto C ---------
hoyo :: Obstaculo
hoyo golpeo _
    | superaHoyo golpeo = tiroNulo
    | otherwise = tiroNulo

superaHoyo :: Tiro -> Bool
superaHoyo golpeo
    | elem (velocidad golpeo) [5..20] && altura golpeo == 0 && precision golpeo > 95 = True
    | otherwise = False

----------------- Parte 4 -----------------

--------- Punto A ---------
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador = cicloDeBusqueda jugador 0

cicloDeBusqueda :: Jugador -> Number -> Obstaculo -> [Palo]
cicloDeBusqueda jugador cont obstaculo
    | cont == 3 = []
    | otherwise = filter (/= tiroNulo) (map (`obstaculo` cont) (palos jugador cont)) ++ cicloDeBusqueda jugador (cont + 1) obstaculo

--------- Punto B ---------
obstaculosSuperados :: Tiro -> Number -> [Obstaculo] -> Number
obstaculosSuperados tiro num = length . takeWhile (/= tiroNulo) . pasarObstaculos tiro num 

pasarObstaculos :: Tiro -> Number -> [Obstaculo] -> [Tiro]
pasarObstaculos tiro num (obstaculo:obstaculos)
    | null [obstaculo] = []
    | null obstaculos = [obstaculo tiro num]
    | otherwise = obstaculo tiro num : pasarObstaculos (obstaculo tiro num) num obstaculos