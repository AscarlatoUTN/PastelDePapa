module Carreras () where
import PdePreludat

data Auto = UnAuto {
    color :: String,
    velocidad :: Number,
    distancia :: Number
} deriving (Show, Eq)

mario :: Auto
mario = UnAuto {
    color = "Rojo",
    velocidad = 100,
    distancia = 30
}

luigi :: Auto
luigi = UnAuto {
    color = "Azul",
    velocidad = 120,
    distancia = 5
}

yoshi :: Auto
yoshi = UnAuto {
    color = "Verde",
    velocidad = 80,
    distancia = 15
}

peach :: Auto
peach = UnAuto {
    color = "Rosa",
    velocidad = 60,
    distancia = 10
}

type Carrera = [Auto]

piston :: Carrera
piston = [mario, luigi, yoshi, peach]

----------------- Parte 1 -----------------

--------- Punto A ---------
cercanos :: Auto -> Auto -> Bool
cercanos auto1 = (<10) . abs . distancias auto1

distancias :: Auto -> Auto -> Number
distancias auto1 auto2 = distancia auto1 - distancia auto2

--------- Punto B ---------
tranquilo :: Auto -> Carrera -> Bool
tranquilo auto carrera = (not . any (cercanos auto) . listaCompetidores auto) carrera && (all ((> 0) . distancias auto) . listaCompetidores auto) carrera

listaCompetidores :: Auto -> Carrera -> Carrera
listaCompetidores auto = filter (/= auto) 

--------- Punto C ---------
puesto :: Auto -> Carrera -> Number
puesto auto = (+1) . length . filter ((< 0) . distancias auto)

----------------- Parte 2 -----------------

--------- Punto A ---------
correr :: Auto -> Number -> Auto
correr auto tiempo = auto {
    distancia = nuevaDistancia auto tiempo
}

nuevaDistancia :: Auto -> Number -> Number
nuevaDistancia auto = (+ distancia auto) . (* velocidad auto)

--------- Punto B ---------
modificador :: (Number -> Auto -> Auto) -> Number -> Auto -> Auto
modificador criterio = criterio

---- Inciso I ----
nuevaVelocidad :: Number -> Auto -> Auto
nuevaVelocidad numero auto
    | not ((> 0) numero) = auto { velocidad = 0 * velocidad auto }
    | otherwise = auto { velocidad = numero * velocidad auto }

---- Inciso II ----
velocidadFinal :: Number -> Auto -> Auto
velocidadFinal numero auto
    | (< numero) (velocidad auto) = auto { velocidad = 0 * velocidad auto }
    | otherwise = auto { velocidad = velocidad auto - numero}

----------------- Parte 3 -----------------

type Poder = (Auto -> Number -> Carrera -> Carrera)

powerUp :: Auto -> Poder -> Number -> Carrera -> Carrera
powerUp auto power = power auto

--------- Punto A ---------
terremoto :: Poder
terremoto auto _ = map (velocidadFinal 50) . filter (cercanos auto) . listaCompetidores auto

--------- Punto B ---------
miguelitos :: Poder
miguelitos auto num carrera = map (velocidadFinal num) (filter (estaGanando carrera auto) carrera)

estaGanando :: Carrera -> Auto -> Auto -> Bool
estaGanando carrera auto1 = (>puesto auto1 carrera) . flip puesto carrera

--------- Punto C ---------
jetpack :: Poder
jetpack auto num = (nuevaVelocidad 0.5 (correr (nuevaVelocidad 2 auto) num) :) . listaCompetidores auto