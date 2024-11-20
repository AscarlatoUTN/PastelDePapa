class Personaje{
    var property copas
    const tipoPersonaje
    const agilidad
    const rango
    const fuerza

    method destreza() = tipoPersonaje.destreza(self)
    method tieneEstrategia() = tipoPersonaje.tieneEstrategia(self)

    method agilidad() = agilidad
    method rango() = rango
    method fuerza() = fuerza
}

class Flechero{
    method tieneEstrategia(jugador) = jugador.rango() > 100

    method destreza(jugador) = jugador.agilidad() * jugador.rango()
}

object arquero inherits Flechero{}
object ballestero inherits Flechero{
    override method destreza(jugador) = super(jugador) * 2
}

class Guerrera{
    const tieneEstrategia
    
    method destreza(jugador) = jugador.fuerza() * 1.5
    method tieneEstrategia() = tieneEstrategia
}

class Mision{
    const tipoMision
    const dificultad
    const property jugadores
    method copas() = tipoMision.copas(self)

    method dificultad() = dificultad

    method puedeSerSuperada() = tipoMision.puedeSerSuperada(self)

    method realizarMision(){
        if(tipoMision.puedeRealizarse(self)){
            self.realizar()
        } else{
            //throw new MyException() // Mision no puede comenzar
            console.println("No se pudo realizar la mision. Abortando...")
        }
    }

    method realizar(){
        if(tipoMision.puedeSerSuperada(self)){
            self.misionSuperada(true)
        } else{
            self.misionSuperada(false)
        }
    }

    method misionSuperada(condicion){
        var copasPorJugador = self.copas()
        if(!condicion){
            copasPorJugador *= (-1)
        }
        jugadores.forEach({jugador => jugador.copas(jugador.copas() + copasPorJugador)})
    }
}

class Boost inherits Mision{
    const multiplicador
    
    override method copas() = super() * multiplicador
}

class Bonus inherits Mision{
    override method copas() = super() + jugadores.size()
}

object individual{
    method copas(mision) = mision.dificultad() * 2

    method puedeSerSuperada(mision){
        const jugador = self.jugador(mision)
        return (jugador.tieneEstrategia() || jugador.destreza() > mision.dificultad())
    }

    method jugador(mision) = mision.jugadores().anyOne()

    method puedeRealizarse(mision) = self.jugador(mision).copas() >= 10
}
object grupal{
    method copas(mision) = 50 / self.cantJugadores(mision)

    method puedeSerSuperada(mision){
        const jugadoresConEstrategia = mision.jugadores().filter({jugador => jugador.tieneEstrategia()})
        return (jugadoresConEstrategia.size() * 2 > self.cantJugadores(mision) || mision.jugadores().all({jugador => jugador.destreza() > 400}))
    }

    method cantJugadores(mision) = mision.jugadores().size()

    method puedeRealizarse(mision) = mision.jugadores().sum({jugadores => jugadores.copas()}) >= 60
}