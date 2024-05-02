module Library where
import PdePreludat
import Text.Show.Functions

---------------------- Estructuras ------------------------
type Cancion = String

data Artista = UnArtista {
    nombre :: String,
    canciones :: [Cancion]
} deriving (Show, Eq)

fitito :: Artista
fitito = UnArtista {
    nombre = "Fitito Paez",
    canciones = ["11 y 6", "El amor despues del amor", "Mariposa Tecknicolor"]
}

calamardo :: Artista
calamardo = UnArtista {
    nombre = "Andres Calamardo",
    canciones = ["Flaca", "Sin Documentos", "Tuyo siempre"]
}

paty :: Artista
paty = UnArtista {
    nombre = "Taylor Paty",
    canciones = ["Shake It Off", "Lover"]
}

---------------------- Parte 1 ------------------------

calificarCancion :: Cancion -> Number
calificarCancion cancion = foldl (\nota letra -> nota + valorLetra letra) 10 cancion
  where
    valorLetra letra =
      if elem letra ['a'..'z']
        then 1
        else 0

---------------------- Parte 2 ------------------------

sumarCalificaciones :: Artista -> Number
sumarCalificaciones artista = foldl (\nota cancion -> nota + buenaCalificacion cancion) 0 (canciones artista)
  where
    buenaCalificacion cancion =
      if (calificarCancion cancion) > 20
        then calificarCancion cancion
        else 0

esArtistaExitoso :: Artista -> Bool
esArtistaExitoso artista = sumarCalificaciones artista > 50

---------------------- Parte 3 ------------------------
type Artistas = [Artista]

artistas :: Artistas
artistas = [fitito, calamardo, paty]

artistasExitosos :: Artistas -> Artistas
artistasExitosos artistas = foldl (\lista artista -> lista ++ agregarArtista artista) [] artistas
  where
    agregarArtista artista =
      if esArtistaExitoso artista
        then [artista]
        else []

---------------------- Parte 4 ------------------------

-- Vista lineal
superFuncionLineal :: Artistas -> Artistas
superFuncion artistas = foldl (\lista artista -> lista ++ if(foldl (\nota cancion -> nota + if(foldl (\nota letra -> nota + if elem letra ['a'..'z'] then 1 else 0) 10 cancion) > 20 then foldl (\nota letra -> nota + if elem letra ['a'..'z'] then 1 else 0) 10 cancion else 0) 0 (canciones artista) > 50 ) then [artista] else []) [] artistas

-- Vista estructurada
superFuncionEstructurada :: Artistas -> Artistas
superFuncion artistas = foldl (\lista artista -> lista ++ 
  if(foldl (\nota cancion -> nota + 
    if(foldl (\nota letra -> nota + 
      if elem letra ['a'..'z'] 
        then 1 
        else 0) 10 cancion) > 20 
      then foldl (\nota letra -> nota + 
        if elem letra ['a'..'z'] 
          then 1 
          else 0 ) 10 cancion 
      else 0) 0 (canciones artista) > 50 )
    then [artista] 
    else []) [] artistas