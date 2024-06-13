module Vacaciones () where
import PdePreludat

type Idioma = String
type Excursion = Turista -> Turista 

data Turista = UnTurista {
    cansancio :: Number,
    estres :: Number,
    solo :: Bool,
    idiomas :: [Idioma]
} deriving (Show, Eq)

playa :: Excursion
playa turista
    | solo turista = turista { cansancio = limitarCriterio (cansancio turista - 5) }
    | otherwise = turista { estres = estres turista - 1 }

paisaje :: String -> Excursion
paisaje vista turista = turista { estres = limitarCriterio (estres turista - length vista) }

hablar :: Idioma -> Excursion
hablar idioma turista = turista { idiomas = idioma:idiomas turista }

caminar :: Number -> Excursion
caminar cant turista = turista { cansancio = cansancio turista +  cant / 4, estres = limitarCriterio (estres turista - cant / 4) }

pasear :: String -> Excursion
pasear estado turista
    | estado == "fuerte" = turista { estres = estres turista + 6, cansancio = cansancio turista + 10 }
    | estado == "moderada" = turista
    | estado == "tranquila" = hablar "aleman" (paisaje "mar" (caminar 10 turista))

limitarCriterio :: Number -> Number 
limitarCriterio operacion
    | operacion < 0 = 0
    | otherwise = operacion

----------------- Parte 1 -----------------

ana = UnTurista 0 21 False ["espaniol"]
beto = UnTurista 15 15 True ["aleman"]
cathi = UnTurista 15 15 True ["aleman", "catalan"]

----------------- Parte 2 -----------------
numero :: String -> Number
numero num = sum (conversor num)

conversor :: String -> [Number]
conversor (x:xs)
    | null xs = [length (takeWhile (/= x) ['0'..'9']) * (10^length xs)]
    | otherwise = length (takeWhile (/= x) ['0'..'9']) * (10^length xs) : conversor xs

--------- Punto A ---------
excursionar :: Excursion
excursionar excursion = excursion { estres = limitarCriterio (estres excursion * 0.9)}

--------- Punto B ---------
deltaExcursionSegun :: (Turista -> Number) -> Turista -> Turista -> Number
deltaExcursionSegun = deltaSegun

deltaSegun :: (Turista -> Number) -> Turista -> Turista -> Number
deltaSegun criterio turista excursion = criterio excursion - criterio turista

--------- Punto C ---------

---- Inciso I ----
esEducativa :: Turista -> Turista -> Bool
esEducativa turista = not . flip elem (idiomas turista) . head . nuevoIdioma turista
    
nuevoIdioma :: Turista -> Turista -> [Idioma]
nuevoIdioma turista excursion
    | length (idiomas (excursionar excursion)) > length (idiomas turista) = idiomas (excursionar excursion)
    | otherwise = [" "]

---- Inciso I ----
esDesestresante :: Turista -> Turista -> Bool
esDesestresante turista = (>=3) . abs . deltaSegun estres turista . excursionar

----------------- Parte 3 -----------------
type Tour = [Excursion]

completo :: Tour
completo = [caminar 20, paisaje "cascada", caminar 40, playa, hablar "melmacquiano"]

ladoB :: Excursion -> Tour
ladoB excursion = [pasear "tranquila", excursion, caminar 120]

islaVecina :: String -> Tour
islaVecina marea
    | marea == "fuerte" = [pasear marea, paisaje "lago", pasear marea]
    | otherwise = [pasear marea, playa, pasear marea]

--------- Punto A ---------
comenzarTour :: Turista -> Tour -> Turista
comenzarTour turista tour = turista { estres = estres turista + length tour}

hacerTour :: Turista -> Tour -> Turista
hacerTour = foldl (\ turista excursion -> excursionar (excursion turista))

--------- Punto B ---------
tourConvincente :: Turista -> [Tour] -> Turista
tourConvincente turista = acompaniar . hacerTour turista . head . filter (comprobar turista)

comprobar :: Turista -> Tour -> Bool
comprobar turista = esDesestresante turista . hacerTour turista

acompaniar :: Turista -> Turista
acompaniar turista = turista { solo = False }

--------- Punto C ---------
efectividadTour :: Tour -> [Turista] -> Number
efectividadTour tour turistas = (espiritualidad turistas . filtro2 turistas . filtro1 turistas . map (`hacerTour` tour)) turistas

filtro1 :: [Turista] -> [Turista] -> [Turista]
filtro1 [] [] = []
filtro1 turistas nuevosTuristas = filter ((<0) . deltaSegun cansancio (head turistas)) nuevosTuristas ++ filtro1 (tail turistas) nuevosTuristas

filtro2 :: [Turista] -> [Turista] -> [Turista]
filtro2 [] [] = []
filtro2 turistas nuevosTuristas = filter ((<0) . deltaSegun estres (head turistas)) nuevosTuristas ++ filtro2 (tail turistas) nuevosTuristas

espiritualidad :: [Turista] -> [Turista] -> Number
espiritualidad [] [] = 0
espiritualidad turistas nuevosTuristas = deltaSegun cansancio (head turistas) (head nuevosTuristas) + espiritualidad (tail turistas) (tail nuevosTuristas)

----------------- Parte 4 -----------------

--------- Punto A ---------
infinitasPlayas :: Tour
infinitasPlayas = repeat playa

--------- Punto B ---------
-- No, ya que a la hora de comprobar si es convincente, debo comparar un estado del turista antes y luego de las excursiones, donde este ultimo nunca terminaría de terminar por completo.
-- Esto aplica tanto para Ana, como para Beto

--------- Punto C ---------
-- No, porque todo lo que implique hacer el tour, quedará infinitamente ejecutando las excursiones y nunca terminará