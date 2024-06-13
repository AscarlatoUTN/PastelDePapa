module Library where
import PdePreludat

-- Funcion principal --

totalEmpleados :: Number -> String -> Number
totalEmpleados cantidadSucursales nombreEmpresa = cantidadEmpleadosPorSucursal nombreEmpresa * cantidadSucursales

-- Condiciones iniciales --

terminaConLetraMenor :: String -> Bool
terminaConLetraMenor nombreEmpresa = head nombreEmpresa > last nombreEmpresa

esCapicua :: String -> Bool
esCapicua nombreEmpresa = nombreEmpresa == reverse nombreEmpresa 

esPar :: String -> Bool
esPar nombreEmpresa = even (length nombreEmpresa)

esMultiploDe :: String -> Number -> Bool
esMultiploDe nombreEmpresa x = rem (length nombreEmpresa) x == 0

-- Funciones practicas --

letrasIntermedias :: String -> Number
letrasIntermedias nombreEmpresa = length nombreEmpresa - 2

cantidadCopasArgentina :: Number
cantidadCopasArgentina = 3

cantidadEmpleadosPorSucursal :: String -> Number
cantidadEmpleadosPorSucursal nombreEmpresa -- guardas
    | nombreEmpresa == "acme" = 10
    | terminaConLetraMenor nombreEmpresa = letrasIntermedias nombreEmpresa
    | esCapicua nombreEmpresa && esPar nombreEmpresa = letrasIntermedias nombreEmpresa * 2
    | esMultiploDe nombreEmpresa 3 || esMultiploDe nombreEmpresa 7 = cantidadCopasArgentina
    | otherwise = 0

-- Parte 2 --

esBisiesto :: Number -> Bool
esBisiesto anno = (rem anno 4 == 0 && rem anno 100 /= 0) || rem anno 400 == 0

cuantosDiasTiene :: Number -> Number
cuantosDiasTiene anno
    | esBisiesto anno = 366
    | otherwise = 365