class Plato{
    const azucar
    const esBonito

    method calorias() = 100 + 3 * azucar
    method esBonito() = esBonito
    method azucar() = azucar
}

class Entrada inherits Plato(azucar = 0, esBonito = true){
}
class Principal inherits Plato{
}
class Postre inherits Plato(azucar = 120, esBonito = colores > 3){
    const colores
}

class Cocinero{
    const tipoCocinero
    const dulzorDeseado
    const calorias

    method calorias() = calorias
    method dulzorDeseado() = dulzorDeseado

    method catar(plato) = tipoCocinero.calificar(self, plato)

    method cocinar() = tipoCocinero.cocinar(self)

    method participar(torneo){
        torneo.cocineros().add(self)
    }
}

object pastelero{
    method calificar(cocinero, plato) = (5 * plato.azucar()) / cocinero.dulzorDeseado()

    method cocinar(cocinero) = new Postre(colores = cocinero.dulzorDeseado() / 50)
}

class Chef{

    method calificar(cocinero, plato){
        if(plato.esBonito() and self.cumpleCalorias(cocinero, plato)){
            return 10
        } else{
            return self.malaCalificacion(plato)
        }
    }

    method cumpleCalorias(cocinero, plato) = plato.calorias() <= cocinero.calorias()

    method malaCalificacion(plato)
}

object chef inherits Chef{
    override method malaCalificacion(_) = 0

    method cocinar(cocinero) = new Principal(azucar = cocinero.calorias() / 50, esBonito = [true, false].anyOne())
}

object souschef inherits Chef{
    override method malaCalificacion(plato) = (plato.calorias() / 100).min(6)

    method cocinar(_) = new Entrada()
}

class Torneo{
    const property catadores
    const property cocineros

    method ganador(){
        if(!cocineros.isEmpty()){
            return cocineros.max({cocinero => self.sumaValoraciones(cocinero.cocinar())})
        }
        return null
    }

    method sumaValoraciones(plato) = catadores.sum({catador => catador.catar(plato)})
}


/*

describe "Catar" {

    test "Otorgar calificacion a un plato con dulzorDeseado > 0" {
        const cocinero1 = new Cocinero(tipoCocinero = pastelero, dulzorDeseado = 10, calorias = 1000)
        const plato = cocinero1.cocinar()
        assert.equals(60, cocinero1.catar(plato))
    }

    test "Otorgar calificacion a un plato con dulzorDeseado = 0" {
        const cocinero1 = new Cocinero(tipoCocinero = pastelero, dulzorDeseado = 0, calorias = 1000)
        const plato = cocinero1.cocinar()
        assert.throwsException({cocinero1.catar(plato)})
    }

*/