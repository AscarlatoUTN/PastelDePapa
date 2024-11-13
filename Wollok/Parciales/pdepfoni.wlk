// Punto 1

class Linea{
    const telefono
    const property packsActivos
    const property consumos

    method costoConsumo(pack, cantidad) = pack.costePorConsumo(cantidad)

    method promedioConsumos(fechaInicial, fechaFinal) = self.infoConsumos(fechaInicial, fechaFinal) / consumos.size()

    method infoConsumos(fechaInicial, fechaFinal){
        const gastoConsumos = []
        return consumos.filter({consumo => consumo.fechaConsumo().between(fechaInicial, fechaFinal)}).map({consumo => consumo.valorConsumido()}).sum()
    }

    method ultimoGastoMensual(inicioMes, finMes) = self.infoConsumos(inicioMes, finMes)
}

class Consumo{
    const fechaConsumo
    var valorConsumido

    method fechaConsumo() = fechaConsumo
}


class Pack{
    method satisfaceConsumo()
}

class Internet{
    const megasTotales
    var megasRestantes
    const precioPorMega

    method costePorConsumo(cantMegas) = cantMegas * precioPorMega

    method costoConsumido() = (megasTotales - megasRestantes) * precioPorMega

    method satisfaceConsumo(cantidad)
}

class Llamadas{
    const llamadasTotales
    var llamadasRestantes
    const precioPorSegundo
    const precioFijo

    method costePorConsumo(segundos){
        if(segundos > 30){
            return precioFijo + (segundos - 30) * precioPorSegundo
        } else {
            return precioFijo
        }
    }

    method costoConsumido() = (llamadasTotales - llamadasRestantes)
}

// Punto 3