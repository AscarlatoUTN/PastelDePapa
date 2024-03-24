module Library where
import PdePreludat

-- Does all math operations by default

doble :: Number -> Number
doble numero = numero + numero

mitad :: Number -> Number
mitad numero = numero / 2

suma :: Number -> Number -> Number
suma numero1 numero2 = numero1 + numero2

resta :: Number -> Number -> Number
resta numero1 numero2 = numero1 - numero2