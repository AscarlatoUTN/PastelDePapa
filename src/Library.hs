module Library where
import PdePreludat

-- Does all math operations by default

doble :: Number -> Number
doble numero = numero * 2

suma :: Number -> Number -> Number
suma numero1 numero2 = numero1 + numero2

-- Point-free style

mitad :: Number -> Number
mitad = (/2)

resta :: Number -> Number -> Number
resta = (-)