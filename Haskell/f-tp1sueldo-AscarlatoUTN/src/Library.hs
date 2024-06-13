-- Apellido y nombre: Alejo Scarlato

module Library where
import PdePreludat

sueldo :: String -> Number -> Number -> Number
sueldo cargoDocente annos horas = sueldoPorCargo cargoDocente * adicionalPorAntiguedad annos * horasTrabajadas horas

-- Valores preestablecidos --

sueldoBaseTitular :: Number
sueldoBaseTitular = 149000

sueldoBaseAdjunto :: Number
sueldoBaseAdjunto = 116000

sueldoBaseAyudante :: Number
sueldoBaseAyudante = 66000

-- Funciones de cálculo --

sueldoPorCargo :: String -> Number
sueldoPorCargo cargoDocente
    | cargoDocente == "titular" = sueldoBaseTitular
    | cargoDocente == "adjunto" = sueldoBaseAdjunto
    | cargoDocente == "ayudante" = sueldoBaseAyudante
    | otherwise = 0

adicionalPorAntiguedad :: Number -> Number
adicionalPorAntiguedad annos
    | annos >= 24 = 2.2
    | annos >= 10 = 1.5
    | annos >= 5 = 1.3
    | annos >= 3 && annos <= 5 = 1.2
    | otherwise = 1

horasTrabajadas :: Number -> Number
horasTrabajadas horas
    | horas >= 5 && horas <= 50 && rem horas 10 > 5 = div horas 10 + 1
    | horas >= 5 && horas <= 50 && rem horas 10 <= 5 = div horas 10
    | otherwise = 0

-- Tests --

{- 
consulta: sueldo "titular" 3 10
resultado esperado: 178800.0

consulta: sueldo "adjunto" 10 20
resultado esperado: 348000.0
-}