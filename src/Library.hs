module Library where
import PdePreludat
import Text.Show.Functions

---------------------- Estructuras ------------------------

-- Defino una equivalencia
type SoyString = String

-- Aplico la equivalencia
data Persona = Persona {
    nombre :: SoyString,
    edad :: Number,
    domicilio :: SoyString,
    telefono :: SoyString,
    fechaNacimiento :: (Number, Number, Number),
    buenaPersona :: Bool,
    plata :: Number
} deriving (Show)

-- Ejemplo de uso
persona1 :: Persona
persona1 = Persona {
    nombre = "Juan",
    edad = 30,
    domicilio = "Calle Falsa 123",
    telefono = "1234567890",
    fechaNacimiento = (1, 1, 1990),
    buenaPersona = True,
    plata = 1000
}

---------------------- Typeclasses ------------------------

-- Defino una clase --> Damos paso al polimorfismo ad-hoc
class Nota a where
   aprobo :: a -> Bool
   promociono :: a -> Bool

-- Defino un tipo enumerado
data Concepto = Insuficiente | Regular | Aprobado | Sobresaliente 
    deriving (Eq, Ord, Show, Enum)

-- Defino primer instancia de la clase
instance Nota Number where
   aprobo nota = nota >= 6
   promociono nota = nota >= 8

-- Defino segunda instancia de la clase
instance Nota Concepto where
   aprobo Insuficiente = False
   aprobo _            = True
   promociono Sobresaliente = True
   promociono _             = False

---------------------- Funciones ------------------------

doble :: Number -> Number
doble numero = numero * 2

-- PoNumber-free style

mitad :: Number -> Number
mitad = (/2)

resta :: Number -> Number -> Number
resta = (-)