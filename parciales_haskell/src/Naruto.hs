module Naruto where
import PdePreludat
import Data.List (delete)

type Herramienta = (String, Number)

data Ninja = UnNinja {
    nombre :: String,
    herramientas :: [Herramienta],
    jutsus :: [Jutsu],
    rango :: Number
} deriving (Show, Eq)

naruto = UnNinja "naruto" [("bombaDeHumo", 10), ("shuriken", 0)] [clonesDeSombra] 5

----------------- Parte A -----------------
obtenerHerramienta :: Ninja -> Herramienta -> Ninja
obtenerHerramienta ninja (tipo, cant) = ninja { herramientas = (sumarHerramienta ninja tipo . sumaTotal ninja) cant : eliminarActual (tipo, cant) ninja }

eliminarActual :: Herramienta -> Ninja -> [Herramienta]
eliminarActual (tipo, cant) ninja = delete (tipo, cantHerramientasActuales ninja tipo) (herramientas ninja)

-- Cantidad total de herramientas a sumar
sumaTotal :: Ninja -> Number -> Number
sumaTotal ninja cant
    | length (herramientas ninja) + cant < 100 = cant
    | otherwise = 100 - length (herramientas ninja)

sumarHerramienta :: Ninja -> String -> Number -> Herramienta
sumarHerramienta ninja tipo cant = (tipo, cantHerramientasActuales ninja tipo + cant)

cantHerramientasActuales :: Ninja -> String -> Number
cantHerramientasActuales ninja tipo = (snd . head . filter ((==tipo) . fst) . herramientas) ninja

usarHerramienta :: Ninja -> Herramienta -> Ninja
usarHerramienta ninja herramienta = ninja { herramientas = eliminarActual herramienta ninja }

----------------- Parte B -----------------
data Mision = UnaMision {
    cantidad :: Number,
    nivel :: Number,
    enemigos :: [Ninja],
    recompensa :: Herramienta
}

esDesafiante :: [Ninja] -> Mision -> Bool
esDesafiante ninjas mision = any ((< nivel mision). rango) ninjas && length (enemigos mision) > 1

esCopada :: [Ninja] -> Mision -> Bool
esCopada _ mision = recompensa mision == ("bombaDeHumo", 3) || recompensa mision == ("shuriken", 5) || recompensa mision == ("kunai", 14)

esFactible :: [Ninja] -> Mision -> Bool
esFactible ninjas mision = not (esDesafiante ninjas mision) && ((> 500) . sum . map cantHerramientas) ninjas 

cantHerramientas :: Ninja -> Number
cantHerramientas = sum . map snd . herramientas

fallarMision :: Mision -> [Ninja] -> [Ninja]
fallarMision mision = cambiaRango (-2) . perdidos mision

perdidos :: Mision -> [Ninja] -> [Ninja]
perdidos mision = filter ((>= nivel mision) . rango)

cambiaRango :: Number -> [Ninja] -> [Ninja]
cambiaRango _ [] = []
cambiaRango num (ninja:ninjas) = ninja { rango = rango ninja + num } : cambiaRango num ninjas

cumplirMision :: Mision -> [Ninja] -> [Ninja]
cumplirMision mision = cambiaRango 1 . map (recompensar mision)

recompensar :: Mision -> Ninja -> Ninja
recompensar mision ninja = obtenerHerramienta ninja (recompensa mision)

-- Jutsus
type Jutsu = Mision -> Mision

clonesDeSombra :: Jutsu
clonesDeSombra mision = mision { cantidad = reducirCantidad mision (cantidadEnemigos (=="clonSombra") mision)}

cantidadEnemigos :: (String -> Bool) -> Mision -> Number
cantidadEnemigos criterio = length . filter (criterio . nombre) . enemigos

reducirCantidad :: Mision -> Number -> Number
reducirCantidad mision num
    | cantidad mision > num = cantidad mision - num
    | otherwise = 1

fuerzaDeUnCentenar :: Jutsu
fuerzaDeUnCentenar mision = mision { enemigos = filter ((< 500) . rango) (enemigos mision)}

ejecutarMision :: [Ninja] -> Mision -> [Ninja]
ejecutarMision ninjas mision
    | esCopada ninjas mision || esFactible ninjas mision = cumplirMision mision ninjas
    | otherwise = fallarMision mision ninjas