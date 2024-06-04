module Gravity where
import PdePreludat

data Criatura = UnaCriatura {
    nombre :: String,
    peligrosidad :: Number,
    debilidad :: String
} deriving (Show, Eq)

data Persona = UnaPersona {
    edad :: Number,
    items :: [String],
    experiencia :: Number
} deriving (Show, Eq)

----------------- Punto 1 -----------------
siempreDetras = UnaCriatura "siempredetras" 0 ""
gnomo n = UnaCriatura "gnomo" (2**n) "soplador de hojas"
fantasma poder = UnaCriatura "fantasma" (poder * 20)

cazafantasmas = UnaPersona 40 ["soplador de hojas"] 10

----------------- Punto 2 -----------------
enfrentamiento :: Persona -> Criatura -> Persona
enfrentamiento persona criatura
    | ganaEnfrentamiento persona criatura = cambioExperiencia persona (peligrosidad criatura)
    | otherwise = cambioExperiencia persona 1

ganaEnfrentamiento :: Persona -> Criatura -> Bool
ganaEnfrentamiento persona criatura = debilidad criatura `elem` items persona

cambioExperiencia :: Persona -> Number -> Persona
cambioExperiencia persona num = persona { experiencia = experiencia persona + num }
----------------- Punto 3 -----------------

---- Inciso A ----
sucesivosEnfrentamientos :: Persona -> [Criatura] -> Number
sucesivosEnfrentamientos persona = experiencia . foldl enfrentamiento persona

---- Inciso B ----


----------------- Punto 4 -----------------
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf _ _ _ [] = []
zipWithIf _ _ [] _ = []
zipWithIf operacion condicion (x:xs) (y:ys)
    | condicion y = x `operacion` y : zipWithIf operacion condicion xs ys
    | otherwise = y : zipWithIf operacion condicion (x:xs) ys

----------------- Punto 5 -----------------

---- Inciso A ----
abecedarioDesde :: Char -> [Char]
abecedarioDesde letra = dropWhile (/= letra) ['a'..'z'] ++ takeWhile (/= letra) ['a'..'z']

---- Inciso B ----
desencriptarLetra :: Char -> Char -> Char
desencriptarLetra clave letra
    | clave > letra = ['a'..'z'] !! (length ([clave..'z'] ++ ['a'..letra]) - 1)
    | otherwise = '-'

---- Inciso C ----
cesar :: Char -> String -> String
cesar clave = zipWithIf desencriptarLetra (`elem` ['a'..'z']) (repeat clave)