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
    var nivelSospecha = 40
    var property tipoJugador
    var property votaA

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
}

object t_tripulante{
    method realizarTarea(tripulante){
        if(!self.completoSusTareas(tripulante)){
            const tareaPendiente = tripulante.tareasPendientes().filter({tarea => tarea.puedeHacerse(tripulante)}).anyOne()
            tareaPendiente.hacerTarea()
        }
    }

    method completoSusTareas(tripulante) = tripulante.tareasPendientes().size() == 0
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
    method realizarTarea(_){}

    method completoSusTareas(_) = true

    method realizarSabotaje(impostor){
        impostor.posiblesSaboteos().anyOne().sabotear(impostor)
        impostor.nivelSospecha(impostor.nivelSospecha() + 5)
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
        tripulante.votaA(null)
    }
}

class MyException inherits wollok.lang.Exception{}
object nave {
    const property tripulantes = []
    var property nivelOxigeno = 50

    method chequearTareas(){
        if(self.ganaronTripulantes()){
            throw new MyException() // No lo vimos
        }
    }

    method ganaronTripulantes() = tripulantes.all({tripulante => tripulante.tipoJugador().completoSusTareas(tripulante)})

    method chequearOxigeno(){
        if(nivelOxigeno == 0){
            throw new MyException() // No lo vimos
        }
    }
}