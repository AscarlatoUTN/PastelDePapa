// Obetos de mochila
object llaveInglesa{}
object escoba{}
object bolsaDeConsorcio{}
object tuboDeOxigeno{}

class Jugador{
    const property mochila
    const property tareasPendientes
    const color
    const nave
    var property nivelSospecha = 40
    var property tipoJugador
    var property votos = 0
    const property personalidad

    method fueExpulsado() = false

    method votoAnulado() = false

    method esSospechoso() = nivelSospecha > 50

    method buscarItem(item){
        mochila.add(item)
    }

    method realizarTarea(tarea){
        tipoJugador.realizarTarea(tarea)
    }

    method informarNave(){
        nave.chequearTareas()
    }

    method iniciarReunion(){
        nave.reunionEmergencia()
    }
}

object t_tripulante{
    var property cantidadTripulantes = 8
    method realizarTarea(tripulante){
        if(!self.completoSusTareas(tripulante)){
            const tareaPendiente = tripulante.tareasPendientes().filter({tarea => tarea.puedeHacerse(tripulante)}).anyOne()
            tareaPendiente.hacerTarea()
        }
    }

    method completoSusTareas(tripulante) = tripulante.tareasPendientes().size() == 0

    method reducirCantidad(){
        cantidadTripulantes -= 1
    }
}

// Misiones
object arreglarTablero{
    method puedeHacerse(tripulante) = tripulante.mochila().contains(llaveInglesa)

    method hacerTarea(tripulante){
        tripulante.nivelSospecha(tripulante.nivelSospecha() + 10)
    }
}

object sacarBasura{
    const property herramientasNecesarias = [escoba, bolsaDeConsorcio]

    method puedeHacerse(tripulante) = herramientasNecesarias.all({herramienta => tripulante.mochila().contains(herramienta)})

    method hacerTarea(tripulante){
        tripulante.nivelSospecha(tripulante.nivelSospecha()  - 4)
    }
}

object ventilarNave{
    method puedeHacerse(_) = true

    method hacerTarea(tripulante){
        const naveTripulante = tripulante.nave()
        naveTripulante.nivelOxigeno(naveTripulante.nivelOxigeno() + 5)
    }
}

object t_impostor{
    var property cantidadImpostores = 2
    method realizarTarea(_){}

    method completoSusTareas(_) = true

    method realizarSabotaje(impostor){
        impostor.posiblesSaboteos().anyOne().sabotear(impostor)
        impostor.nivelSospecha(impostor.nivelSospecha() + 5)
    }

    method reducirCantidad(){
        cantidadImpostores -= 1
    }
}

object reducirOxigeno{
    method sabotear(impostor, _){
        const nave = impostor.nave()
        if(!self.alguienTieneTuboOxigeno(nave)){
            nave.nivelOxigeno(nave.nivelOxigeno() - 10)
            nave.chequearOxigeno()
        }
    }

    method alguienTieneTuboOxigeno(nave) = nave.tripulantes().any({tripulante => tripulante.mochila().contains(tuboDeOxigeno)})
}

object impugnarJugador{
    method sabotear(impostor, tripulante){
        tripulante.votoAnulado(true)
    }
}

class MyException inherits wollok.lang.Exception{}
object nave {
    const property jugadores = []
    var property nivelOxigeno = 50
    var property votosEnBlanco = 0

    method chequearTareas(){
        if(self.ganaronTripulantes()){
            throw new MyException() // No lo vimos
        }
    }

    method ganaronTripulantes() = jugadores.all({jugador => jugador.tipoJugador().completoSusTareas(jugador)}) || t_impostor.cantidadImpostores() == 0

    method ganaronImpostores() = t_impostor.cantidadImpostores() == t_tripulante.cantidadTripulantes()

    method tripulantes() = jugadores.filter({jugador => jugador.tipoJugador(t_tripulante)})

    method chequearOxigeno(){
        if(nivelOxigeno == 0){
            throw new MyException() // No lo vimos
        }
    }

    method jugadoresRestantes() = jugadores.filter({jugador => !jugador.fueExpulsado()})

    method jugadoresValidos() = self.jugadoresRestantes().filter({jugador => !jugador.votoAnulado()})

    method cantJugadoresVivos() = t_impostor.cantidadImpostores() + t_tripulante.cantidadTripulantes()

    method reunionEmergencia(){

        self.jugadoresValidos().forEach({jugador => jugador.personalidad().votar(self)})
        votosEnBlanco += self.cantJugadoresVivos() - self.jugadoresValidos().size()
        const jugadorAExpulsar = self.jugadorMasVotado()
        if(jugadorAExpulsar != null){
            self.expulsar(jugadorAExpulsar)
        }
        self.reiniciarVotos()
        self.verificarAlgunGanador()
    }

    method expulsar(jugador){
        jugador.esExpulsado(true)
        jugador.tipoJugador().reducirCantidad()
    }

    method reiniciarVotos(){
        jugadores.forEach({jugador => jugador.votos(0) and jugador.votoAnulado(false)} )
        votosEnBlanco = 0
    }

    method verificarAlgunGanador(){
        if(self.ganaronTripulantes()){
            throw new MyException()
        } else if(self.ganaronImpostores()){
            throw new MyException()
        }
    }

    method jugadorMasVotado(){
        const listaVotos = jugadores.map({jugador => jugador.votos()})
        const maxCantVotos = listaVotos.max()
        if(maxCantVotos >= votosEnBlanco){
            const jugadorMasVotado = jugadores.filter({jugador => jugador.votos() == maxCantVotos})
            return jugadores.anyOne()
        } else{
            return null
        }
    }

    method jugadoresSospechosos() = jugadores.filter({jugador => jugador.esSospechoso()})

    method jugadoresMochilaVacia(){
        const jugadoresMochilaVacia = jugadores.filter({jugador => jugador.mochila()})
        if(!jugadoresMochilaVacia.isEmpty()){
            return jugadoresMochilaVacia
        }
        return [null]
    }
}

object troll{

    method votar(nave){
        if(!nave.jugadoresSospechosos().isEmpty()){
            const jugadorVotado = nave.jugadoresSospechosos().anyOne()
            jugadorVotado.votos(jugadorVotado.votos() + 1)
        } else{
            nave.votosEnBlanco(nave.votosEnBlanco() + 1)
        }
    }
}

object detective{
    method votar(nave){
        const mayorSospecha = nave.jugadores().map({jugador => jugador.nivelSospecha()}).max()
        const jugadorAVotar = nave.jugadores().filter({jugador => jugador.nivelSospecha(mayorSospecha)}).anyOne()
    }
}

object materialista{
    method votar(nave){
        if(!nave.jugadoresMochilaVacia().isEmpty()){
            const jugadorAVotar = nave.jugadoresMochilaVacia().anyOne()
            jugadorAVotar.votos(jugadorAVotar.votos() + 1)
        } else{
            nave.votosEnBlanco(nave.votosEnBlanco() + 1)
        }
    }
}