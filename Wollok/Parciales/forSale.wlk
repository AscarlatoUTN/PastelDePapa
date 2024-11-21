object inmobiliaria{
    const property operaciones = []
    const property empleados = []

    method mejorEmpleado(criterio){
        empleados.max({empleado => criterio.estadisticas(empleado)})
    }
}

object operacionesCerradas{
    method estadisticas(empleado) = empleado.operacionesCerradas().sum({operacion => operacion.inmueble().comision()})
}
object cantOperacionesCerradas{
    method estadisticas(empleado) = empleado.operacionesCerradas().size()
}
object cantReservas{
    method estadisticas(empleado) = empleado.operacionesEnReserva().size()
}

class Empleado{
    method operaciones() = inmobiliaria.operaciones().filter({operacion => operacion.empleado() == self})

    method operacionesCerradas() = self.operaciones().filter({operacion => operacion.estaCerrada()})

    method operacionesEnReserva() = self.operaciones().filter({operacion => operacion.reserva() != null})

    method tieneProblemasCon(empleado2){
        const zonasEmpleado1 = self.operaciones().map({operacion => operacion.inmueble().zona()}).asSet()
        const zonasEmpleado2 = empleado2.operaciones().map({operacion => operacion.inmueble().zona()}).asSet()
        return (zonasEmpleado1.intersection(zonasEmpleado2)).size() > 0 // and self.leCagoUnaOperacion(empleado2) que no tengo ganas de pensar
    }

    method reservar(inmueble, cliente){
        const operacionInmueble = self.operaciones().find({operacion => operacion.inmueble() == inmueble and !operacion.estaCerrada()})
        if(operacionInmueble.reserva() == null){
            operacionInmueble.reserva(cliente)
            operacionInmueble.empleado(self)
        }
    }

    method concretar(operacion, cliente){
        if(!operacion.estaCerrada() and (operacion.reserva() == null || operacion.reserva() == cliente)){
            operacion.estaCerrada(true)
            operacion.empleado(self)
        }
    }
}

class Cliente{

    method reservar(inmueble, empleado){
        empleado.reservar(inmueble, self)
    }

    method concretar(operacion, empleado){
        empleado.concretar(operacion, self)
    }
}

class Operacion{
    const empleado
    const inmueble
    var property estaCerrada
    var property reserva

    method inmueble() = inmueble

    method comision() = inmueble.comision()
}

class Inmueble{
    const tamanio
    const ambientes

    const tipoOperacion
    const tipoInmueble
    var property zona

    method operacion() = tipoOperacion

    method valorInmueble() = tipoInmueble.valor(self) + zona.plus()

    method comision() = tipoOperacion.comision()
}

// tipoOperacion
class Alquiler{
    const meses

    method comision(inmueble) = (inmueble.valor() * meses) / 50000
}

object venta{
    method comision(inmueble) = 0.015 * inmueble.valor()
}

// tipoInmueble
class Casa{
    const valorParticular

    method puedeVenderse() = true

    method valor(_) = valorParticular
}
object ph{
    method valor(inmueble) = (inmueble.tamanio() * 14000).max(500000)

    method puedeVenderse() = true
}
object departamento{
    method valor(inmueble) = 350000 * inmueble.ambientes()

    method puedeVenderse() = true
}

class Local inherits Casa{
    var tipoLocal

    override method puedeVenderse() = false

    override method valor(_) = tipoLocal.valor()
}

class Galpon inherits Local{


    override method valor(_) = super(_) * 0.5
}

class ALaCalle inherits Local{
    const montoFijo = 100000

    override method valor(_) = super(_) + montoFijo
}

// zona
class Zona{
    var property plus
}