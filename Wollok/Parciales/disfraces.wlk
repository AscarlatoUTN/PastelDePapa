class Fiesta{
    const lugar
    const fecha = new Date()
    const property invitados

    method esUnBodrio() = !invitados.any({invitado => invitado.estaConforme()})

    method mejorDisfraz(){
        const mejorPuntuacion = invitados.map({invitado => invitado.disfraz().tipoDisfraz().puntuarDisfraz(invitado)}).max()
        return invitados.find({invitado => invitado.disfraz().tipoDisfraz().puntuarDisfraz(invitado) == mejorPuntuacion})
    }

    method intercambianTrajes(invitado1, invitado2) = invitado1.fiesta() == invitado2.fiesta() and self.algunDisconforme(invitado1, invitado2) and self.conformesConCambio(invitado1, invitado2)

    method algunDisconforme(invitado1, invitado2) = [invitado1, invitado2].any({invitado => !invitado.estaConforme()})

    method conformesConCambio(invitado1, invitado2) = [invitado1.disfraz(invitado2.disfraz()), invitado2.disfraz(invitado1.disfraz())].all({invitado => invitado.estaConforme()})

    method agregarInvitado(invitado){
        if(invitado.disfraz() != null and !invitados.contains(invitado)){
            invitados.add(invitado)
        }
    }

    method fiestaInolvidable() = invitados.all({invitado => invitado.esSexy() and invitado.estaConforme()})
}

class Invitado{
    var fiesta
    var property disfraz
    var property personalidad
    const eleccionTrajes

    method puntuacionDisfraz(invitado) = invitado.disfraz().puntuarDisfraz(invitado)

    method esSexy() = personalidad.esSexy(self)

    method estaConforme() = eleccionTrajes.necesidad(disfraz, self)
}

class Disfraz{
    const nombre
    const fechaConfeccion
    const property tipoDisfraz
    const valorCareta

    method valorCareta() = valorCareta
    method nombre() = nombre

    method puntuarDisfraz(invitado) = tipoDisfraz.sum({tipo => tipo.puntuacion(self, invitado)})
}

// Puntuación de un disfraz

object gracioso{
    method puntuacion(_, invitado) = [1..10].anyOne() * self.multiplicador(invitado)

    method multiplicador(invitado){
        if(invitado.edad() > 50){
            return 3
        }
        return 1
    }
}

object tobara{
    method puntuacion(disfraz, invitado){
        if(disfraz.fechaConfeccion().day() <= invitado.fiesta().fecha().day() - 2){
            return 5
        } else{
            return 3
        }
    }
}
object careta{
    method puntuacion(disfraz, _) = disfraz.valorCareta()
}

object mickeyMouse{
    method puntaje() = 8
}
object osoCarolina{
    method puntaje() = 6
}

object sexies{
    method puntuacion(_, invitado){
        if(invitado.esSexy()){
            return 15
        } else{
            return 2
        }
    }
}

// Personalidades

object alegre {
    method esSexy(_) = false
}
object taciturno {
    method esSexy(invitado) = invitado.edad() < 30
}
object bipolar {
    method esSexy(invitado) = [alegre, taciturno].anyOne().esSexy()
}

// Satisfecho o le devolvemos su traje

object caprichosos{
    method necesidad(traje, _) = traje.nombre().size() % 2 == 0
}
object pretenciosos{
    method necesidad(traje, _) = new Date().today() - traje.fechaConfeccion() < 30
}
object numerologos{
    const puntajeEsperado = 15

    method necesidad(traje, invitado) = traje.puntuarDisfraz(invitado) == puntajeEsperado
}