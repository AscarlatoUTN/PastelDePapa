module Naruto where
import PdePreludat
import Data.List (delete)

type Herramienta = (String, Number)

data Ninja = UnNinja {
    nombre :: String,
    herramientas :: [Herramienta],
    jutsus :: [String],
    rango :: Number
} deriving (Show, Eq)

naruto = UnNinja "naruto" [("bombaDeHumo", 10), ("shuriken", 0)] ["super"] 0

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