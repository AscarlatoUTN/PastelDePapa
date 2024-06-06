module Dune where
import PdePreludat

type Tribu = [Fremen]

----------------- Punto 1 -----------------
data Fremen = UnFremen {
    nombre :: String,
    tolerancia :: Number,
    titulos :: [String],
    reconocimientos :: Number
} deriving (Show, Eq)

stilgar = UnFremen "stilgar" 150 ["Guía"] 3

---- Inciso A ----
nuevoReconocimiento :: Fremen -> Fremen
nuevoReconocimiento = cambiarReconocimientos 1

cambiarReconocimientos :: Number -> Fremen -> Fremen
cambiarReconocimientos num fremen = fremen { reconocimientos = reconocimientos fremen + num}

---- Inciso B ----
candidatoElegido :: Tribu -> Tribu
candidatoElegido = saberTolerancia 100. filter (elem "Domador" . titulos)

saberTolerancia :: Number -> Tribu -> Tribu
saberTolerancia num = filter ((>num) . tolerancia)

---- Inciso C ----
hallarElegido :: Tribu -> Fremen
hallarElegido = verificarNulo . candidatoElegido

verificarNulo :: Tribu -> Fremen
verificarNulo [] = UnFremen "" 0 [] 0
verificarNulo (fremen:tribu) = mayorReconocimiento fremen tribu

mayorReconocimiento :: Fremen -> Tribu -> Fremen
mayorReconocimiento mejorFremen [] = mejorFremen
mayorReconocimiento mejorFremen (fremen:tribu)
    | reconocimientos mejorFremen < reconocimientos fremen = mayorReconocimiento fremen tribu
    | otherwise = mayorReconocimiento mejorFremen tribu

----------------- Punto 2 -----------------
data Gusano = UnGusano {
    longitud :: Number,
    hidratacion :: Number,
    descripcion :: String
} deriving (Show, Eq)

gusano_1 = UnGusano 10 5 "rojo con lunares"
gusano_2 = UnGusano 8 1 "dientes puntiagudos"

reproduccion :: Gusano -> Gusano -> Gusano
reproduccion gusano1 gusano2 = UnGusano {
    longitud = ((*0.1) . max (longitud gusano1) . longitud) gusano2,
    hidratacion = 0,
    descripcion = descripcion gusano1 ++ " - " ++ descripcion gusano2
}

multiReproduccion :: [Gusano] -> [Gusano] -> [Gusano]
multiReproduccion [] _ = []
multiReproduccion _ [] = []
multiReproduccion (g1:g1s) (g2:g2s) = reproduccion g1 g2 : multiReproduccion g1s g2s

----------------- Punto 3 -----------------
type Mision = Fremen -> Gusano -> Fremen

cambiarTolerancia :: (Number -> Number -> Number) -> Number -> Fremen -> Fremen
cambiarTolerancia operacion num fremen = fremen { tolerancia = tolerancia fremen `operacion` num}

domarGusanoDeArena :: Mision
domarGusanoDeArena fremen gusano
    | loDoma fremen gusano = cambiarTolerancia (+) 100 fremen { titulos = "Domador" : titulos fremen }
    | otherwise = cambiarTolerancia (*) 0.9 fremen
    
loDoma :: Fremen -> Gusano -> Bool
loDoma fremen gusano = tolerancia fremen >= 0.5 * longitud gusano

destruirGusanoDeArena :: Mision
destruirGusanoDeArena fremen gusano
    | loDestruye fremen gusano = (cambiarTolerancia (+) 100 . cambiarReconocimientos 1) fremen
    | otherwise = cambiarTolerancia (*) 0.8 fremen

loDestruye :: Fremen -> Gusano -> Bool
loDestruye fremen gusano = "Domador" `elem` titulos fremen && tolerancia fremen < 0.5 * longitud gusano

detonarGusanoDeArena :: Mision
detonarGusanoDeArena fremen gusano
    | loDoma fremen gusano && loDestruye fremen gusano = (flip destruirGusanoDeArena gusano . domarGusanoDeArena fremen) gusano
    | otherwise = (cambiarTolerancia (*) 0 . cambiarReconocimientos (- reconocimientos fremen)) fremen { titulos = ["Domado"]}

----------------- Punto 4 -----------------
megaTribu :: Tribu
megaTribu = repeat stilgar

--A-- Si bien se irían entrenando, nunca se mostraría ya que se están entrenando infinitos fremen, por lo que nunca veremos los resultados de los entrenamientos, a menos que sólo nos importe ver cierta cantidad de estos

--B-- Nunca terminaría de filtrar cuantos candidatos podrían haber, ya que filter no termina hasta que llega al final de la lista, a menos que sólo nos importe ver cierta cantidad de estos

--C-- Lo mismo que el B, ya que debe filtrar.

{-
Los Fremen 

La tribu está compuesta por varios Fremen. Cada Fremen tiene un nombre, un nivel de tolerancia a la Especia, una serie de títulos y una cantidad de reconocimientos.  

Ejemplo:
Stilgar tiene un nivel de tolerancia a la Especia de 150 y el título de "Guía". Fue reconocido 3 veces. 

Se pide:
Averiguar cómo queda un Fremen al recibir un nuevo reconocimiento.
Saber si hay algún candidato a ser el elegido. Son candidatos quienes tengan el título de "Domador" y una tolerancia a la especia de más de 100.
Hallar al Elegido: Es el Fremen de la tribu que más reconocimientos tenga entre los candidatos a serlo. 

Gusanos de arena

Se conoce su longitud, su nivel de hidratación y una descripción. 
Los gusanos se reproducen. Dados dos gusanos, la cría nace de la siguiente manera:
Su longitud es el 10% de la máxima longitud de sus dos progenitores
Su nivel de hidratación es 0
La descripción es la concatenación de ambas descripciones de sus progenitores. 
Ejemplo:
Un gusano de longitud 10, hidratacion 5 y descripción “rojo con lunares”
Otro gusano de longitud 8, hidratación 1 y descripción “dientes puntiagudos”
La cría entre estos dos gusanos debería tener de longitud 1, hidratación 0 y descripción “rojo con lunares - dientes puntiagudos”
Se pide:
Obtener la lista de crías que surge de aparear dos listas de gusanos, uno a uno. En caso que un gusano no tenga con qué otro gusano aparearse, obviamente no hay cría. Por ejemplo, el primero de la primera lista con el primero de la segunda lista, los segundos entre sí y así sucesivamente.
Importante: No vale usar zipWith


Misiones

Los Fremen realizan misiones para sobrevivir en el desierto donde proliferan los gusanos. Las misiones son:

Domar gusano de arena: Un Fremen puede domar a un gusano de arena si su nivel de tolerancia a la Especia es al menos la mitad de la longitud del gusano. Al hacerlo, obtiene el título de "Domador" y su tolerancia a la especia aumenta en 100 unidades. Si no lo puede hacer su tolerancia a la Especia baja un 10%. 

Destruir gusano de arena: Un Fremen puede destruir a un gusano de arena si tiene el título de "Domador" y si su nivel de tolerancia a la Especia es menor que la mitad de la longitud del gusano. Al hacerlo, recibe un reconocimiento y su tolerancia a la especia aumenta en 100 unidades. Si no lo logra, su especia baja un 20%. 

Inventada: Inventar otra misión que un Fremen pueda hacer con un gusano, que también se pueda realizar dependiendo de cómo sea el gusano en relación al Fremen y que provoque consecuencias diferentes sobre el Fremen si lo logra o no.

Se pide:
Simular la realización colectiva de una misión: Dada una tribu, una misión cualquiera y un gusano de arena, hacer que cada uno de los Fremen de la tribu intenten llevar a cabo la misión con dicho gusano, obteniendo cómo queda la tribu en consecuencia.
Averiguar, para una tribu, una misión y un gusano, si el hecho de realizarla colectivamente haría que el elegido de la tribu fuera un Fremen diferente al que hubieran elegido previamente.

Al infinito 

Qué pasaría con una tribu de infinitos Fremen?
Al entrenarlos
Al querer saber si hay algún candidato a ser elegido
Al encontrar al elegido

Justificar conceptualmente
Mostrar un ejemplo de consulta y su resultado.
-}