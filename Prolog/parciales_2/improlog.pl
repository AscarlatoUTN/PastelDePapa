integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

% Punto 1
buenaBase(Grupo):-
    integrante(Grupo, _, Instrumento1),
    integrante(Grupo, _, Instrumento2),
    instrumento(Instrumento1, ritmico),
    instrumento(Instrumento2, armonico).

% Punto 2
seDestaca(Persona, Grupo):-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, MaxNivel),
    forall((integrante(Grupo, Persona1, Instrumento1), Persona1 \= Persona), (nivelQueTiene(Persona1, Instrumento1, Nivel), Nivel + 2 =< MaxNivel)).
    
% Punto 3
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, ensamble(3)).

% Punto 4
hayCupo(Grupo, Instrumento):-
    grupo(Grupo, Tipo),
    not(integrante(Grupo, _, Instrumento)),
    sirveAlGrupo(Tipo, Instrumento).
hayCupo(Grupo, _):-
    grupo(Grupo, ensamble(_)).

sirveAlGrupo(formacion(Instrumentos), Instrumento):-
    member(Instrumento, Instrumentos).
sirveAlGrupo(bigBand, Instrumento):-
    instrumento(Instrumento, melodico(viento)).
sirveAlGrupo(bigBand, bateria).
sirveAlGrupo(bigBand, bajo).
sirveAlGrupo(bigBand, piano).

% Punto 5
puedeIncorporarse(Persona, Instrumento, Grupo):-
    nivelQueTiene(Persona, Instrumento, Nivel),
    grupo(Grupo, TipoGrupo),
    not(integrante(Grupo, Persona, _)),
    hayCupo(Grupo, Instrumento),
    cumpleNivelMinimo(TipoGrupo, Nivel).

cumpleNivelMinimo(bigBand, _).
cumpleNivelMinimo(formacion(Instrumentos), Nivel):-
    length(Instrumentos, CantInstrumentos),
    Nivel >= 7 - CantInstrumentos.
cumpleNivelMinimo(ensamble(NivelMinimo), Nivel):-
    Nivel >= NivelMinimo.

% Punto 6
quedoEnBanda(Persona):-
    musico(Persona),
    not(integrante(_, Persona, _)),
    not(puedeIncorporarse(Persona, _, _)).

musico(Persona):-
    nivelQueTiene(Persona, _, _).

% Punto 7
puedeTocar(Grupo):-
    grupo(Grupo, TipoGrupo),
    requisitosMinimos(Grupo, TipoGrupo).

requisitosMinimos(Grupo, bigBand):-
    buenaBase(Grupo),
    findall(Persona, (integrante(Grupo, Persona, Instrumento), instrumento(Instrumento, melodico(viento))), Personas),
    length(Personas, CantPersonas),
    CantPersonas >= 5.
requisitosMinimos(Grupo, formacion(InstrumentosRequeridos)):-
    findall(Instrumento, integrante(Grupo, _, Instrumento), Instrumentos),
    intersection(InstrumentosRequeridos, Instrumentos, InstrumentosRequeridos).
requisitosMinimos(Grupo, ensamble(_)):-
    buenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).