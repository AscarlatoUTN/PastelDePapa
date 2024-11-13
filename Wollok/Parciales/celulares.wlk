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

class Descarga{
    const comprador
    const mesCompra
    const productoAdquirido

    method comprador() = comprador
    method mesCompra() = mesCompra
    method productoAdquirido() = productoAdquirido
}

class Empresa{
    const property descargas

    // Punto 1
    method precioDescarga(producto, cliente) = (producto.derechoAutor() * (1 + 0.25) + cliente.companiaTeleco().cobro(producto)) * cliente.plan().recargo()

    // Punto 2
    method registrarDescarga(producto, cliente){
        if(cliente.puedeDescargar(self.precioDescarga(producto, cliente))){
            const fecha = new Date().Month()
            descargas.add(new Descarga(comprador = cliente, productoAdquirido = producto, mesCompra = fecha))
            cliente.plan().actualizarMonto(self.precioDescarga(producto, cliente))
            cliente.descargas().add(producto)
        }
    }

    // Punto 3
    method gastoCliente(cliente, mes){
        var listaFiltrada = self.descargasCliente(cliente)
        listaFiltrada = listaFiltrada.filter({descarga => descarga.mesCompra() == mes})
        listaFiltrada = listaFiltrada.map({descarga => descarga.productoAdquirido()})
        return listaFiltrada.sum({producto => self.precioDescarga(producto, cliente)})
    }

    method descargasCliente(cliente) = descargas.filter({descarga => descarga.comprador() == cliente})

    // Punto 4
    method clienteColgado(cliente) = self.descargasCliente(cliente).any({descarga => self.descargasCliente(cliente).occurrencesOf(descarga) > 1})

    method productoEncabezado(mes){
        const listaFiltrada = self.productosDelMes(mes)
        
        const maxOcurrences = listaFiltrada.map({producto => listaFiltrada.occurrencesOf(producto)}).max()

        return self.productosDelMes(mes).filter({producto => self.productosDelMes(mes).occurrencesOf(producto) == maxOcurrences})
    }

    method productosDelMes(mes){
        const listaFiltrada = descargas.filter({descarga => descarga.mesCompra() == mes})
        return listaFiltrada.map({descarga => descarga.productoAdquirido()})
    }
}

// const ringtone1 = new Ringtone(duracion = 30, precioPorMinuto = 0.5)
// const descarga1 = new Descarga(comprador = cliente1, productoAdquirido = ringtone1, mesCompra = 1)
// const descarga2 = new Descarga(comprador = cliente1, productoAdquirido = ringtone1, mesCompra = 2)
// const cliente1 = new Cliente(companiaTeleco = nacional, descargas = [], plan = new Plan(tipoPlan = prepago, saldo = 1000))
// const empresa = new Empresa(descargas = [descarga1, descarga2])

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