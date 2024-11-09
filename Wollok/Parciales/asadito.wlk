object sal{}
object aceite{}
object vinagre{}
object aceto{}
object oliva{}
object cuchillo{}

// Punto 1

class Comensal{
    var property position
    var property condicion
    const property eleccionComida
    var property elementosCerca
    const property comido

    method pedirElemento(comensal, elemento) = comensal.condicion().pasarElemento(comensal, self, elemento)

    method cambiarPosicion(comensal){
        const auxPos = comensal.position()
        comensal.position(position)
        self.position(auxPos)
        // Intercambiar elementos cercanos
        const auxElem = comensal.elementosCerca()
        comensal.elementosCerca(self.elementosCerca())
        self.elementosCerca(auxElem)
    }

    method quiereComer(comida){
        if(eleccionComida.all({eleccion => eleccion.puedeComer(comida)})){
            comido.add(comida)
        }
    } 

    method estaPipon() = comido.any({comida => comida.calorias() > 500})

    method laPasaBien()
}

object sordo{
    method pasarElemento(comensalOrigen, comensalDestino, _){
        comensalDestino.elementosCerca().add(comensalOrigen.elementosCerca().first())
        comensalOrigen.elementosCerca().remove(comensalOrigen.elementosCerca().first())
    }
}

object mechaCorta{
    method pasarElemento(comensalOrigen, comensalDestino, _){
        comensalOrigen.elementosCerca().forEach({elemento => comensalDestino.elementosCerca().add(elemento)})
        comensalOrigen.elementosCerca().clear()
    }
}
object comun{
    method pasarElemento(comensalOrigen, comensalDestino, elemento){
        if(comensalOrigen.elementosCerca().contains(elemento)){
            comensalDestino.elementosCerca().add(elemento)
            comensalOrigen.elementosCerca().remove(elemento)
        }
    }
}

// Punto 2

class Comida{
    const calorias
    const esCarne
    method esCarne() = esCarne
    method calorias() = calorias
}

class Bandeja{
    const comida

    method ofrecerBandeja(comensal){
        comensal.quiereComer(comida)
    }
}

object vegetariano{
    method puedeComer(comida) = comida.esCarne()  
}

object dietetico{
    method puedeComer(comida) = comida.calorias() < 500  
}

object alternado{
    var ultimaComidaAceptada = false

    method puedeComer(comida){
        if(!ultimaComidaAceptada){
            ultimaComidaAceptada = true
            return true
        }
        ultimaComidaAceptada = false
        return false
    }
}

// Punto 4

object osky inherits Comensal(position = new MutablePosition(x=1, y=1), condicion = mechaCorta, eleccionComida = [dietetico], elementosCerca = [aceto, oliva], comido = []){
    
    override method laPasaBien() = true
}

object moni inherits Comensal(position = new MutablePosition(x=1, y=2), condicion = mechaCorta, eleccionComida = [dietetico], elementosCerca = [aceto, oliva], comido = []){

    override method laPasaBien() = position.x() == 1 && position.y() == 1
}

object facu inherits Comensal(position = new MutablePosition(x=2, y=1), condicion = comun, eleccionComida = [alternado], elementosCerca = [cuchillo], comido = []){

  override method laPasaBien() = comido.any({comida => comida.esCarne()})
}

object vero inherits Comensal(position = new MutablePosition(x=2, y=2), condicion = comun, eleccionComida = [vegetariano, alternado], elementosCerca = [vinagre], comido = []){

    override method laPasaBien() = !(elementosCerca.size() > 3)
}

// Punto 5

/*
a) En method puedeComer(comida) = comida.esCarne(), dado que toda comida entiende el mensaje esCarne()

b) En object osky inherits Comensal, dado que osky es un objeto de la clase comensal, hereda todos los atributos que este posea

c) En comensalDestino.elementosCerca().add(elemento), dado que quiero agregar un elemento nuevo a los elementos que tiene cerca el comensal, primero obtengo la lista y luego le añado el elemento
*/
