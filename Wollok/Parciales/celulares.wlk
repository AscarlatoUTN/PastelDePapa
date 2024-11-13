class Cliente{
    var property companiaTeleco
    const property descargas
    var property plan

    method puedeDescargar(monto) = plan.puedePagar(monto)
}

class Plan{
    const tipoPlan
    var property saldo

    method puedePagar(monto) = tipoPlan.puedePagar(monto, saldo)

    method actualizarMonto(monto){
        tipoPlan.actualizarMonto(self, monto)
    }
}

object prepago{
    method recargo() = 1.1 // Recargo del 10%

    method puedePagar(monto, saldoDisponible) = saldoDisponible >= monto

    method actualizarMonto(plan, monto){
        plan.saldo(plan.saldo() - monto)
    }
}
object facturado{
    method recargo() = 1 // Sin recargo

    method puedePagar(_) = true

    method actualizarMonto(plan, monto){
        plan.saldo(plan.saldo() + monto)
    }
}

class Empresa{
    const property descargas

    // Punto 1
    method precioDescarga(producto, cliente) = (producto.derechoAutor() * (1 + 0.25) + cliente.companiaTeleco().cobro(producto)) * cliente.plan().recargo()

    // Punto 2
    method registrarDescarga(producto, cliente){
        if(cliente.puedeDescargar(self.precioDescarga(producto, cliente))){
            const fecha = new Date().Month()
            descargas.add([cliente, producto, fecha])
            cliente.plan().actualizarMonto(self.precioDescarga(producto, cliente))
            cliente.descargas().add(producto)
        }
    }

    // Punto 3
    method gastoCliente(cliente, mesActual){
        const listaFiltrada = descargas.filter({descarga => descarga.take(0) == cliente and descarga.take(2) == mesActual})
        return listaFiltrada.map({descarga => self.precioDescarga(descarga.take(1), cliente)}).sum()
    }

    method descargasCliente(cliente) = descargas.filter({descarga => descarga.take(0) == cliente})

    // Punto 4
    method clienteColgado(cliente) = cliente.descargas().any({descarga => cliente.descargas().occurrencesOf(descarga) > 1})

    method productoEncabezado(fecha)
}

class Producto{
    const tipoProducto

    method derechoAutor() = tipoProducto.derechoAutor()
}

class Ringtone{
    const duracion
    const precioPorMinuto

    method derechoAutor() = duracion * precioPorMinuto
}

class Chiste{
    const montoFijo = 2
    const cantCaracteres

    method derechoAutor() = montoFijo * cantCaracteres
}

class Juego{
    const montoFijo

    method derechoAutor() = montoFijo
}


class Teleco{
    const impuestoPrestacion

    method cobro(producto) = producto.cobro() * 0.05 + impuestoPrestacion
}

object nacional inherits Teleco(impuestoPrestacion = 0){}

object telecoExtranjera inherits Teleco(impuestoPrestacion = 10){} // nro random