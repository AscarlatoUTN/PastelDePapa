class Vikingo{
    const castaSocial
    const tipoVikingo
    var property vidasCobradas
    var property armas
    var property cantHijos
    var property cantHectareas
    var property oro

    method castaSocial() = castaSocial

    method esProductivo() = tipoVikingo.esProductivo(self)

    method ascenderSocialmente() = castaSocial.ascenderSocialmente(self)

    method puedeRealizarExpedicion(expedicion) = castaSocial.puedeIr(self) and self.esProductivo()

    // Punto 1
}

class Expedicion{
    const property vikingos
    const property objetivos

    method valeLaPena() = objetivos.all({objetivo => objetivo.valeLaPena(vikingos)})

    method subirVikingo(vikingo){
        if(vikingo.puedeRealizarExpedicion(self)){
            vikingos.add(vikingo)
        }
        // Tirar excepcion
    }

    method realizarExpedicion(){
        objetivos.forEach({objetivo => objetivo.esInvadido(vikingos)})
    }
}

class Capital{
    const factorRiqueza
    var cantDefensores

    method factorRiqueza() = factorRiqueza

    method valeLaPena(vikingos) = self.cantMonedas(vikingos) >= 3 * vikingos.size()

    method cantMonedas(vikingos) = self.cantDefensoresDerrotados(vikingos) + factorRiqueza

    method cantDefensoresDerrotados(vikingos) = vikingos.size().randomUpTo(cantDefensores).roundUp()

    method esInvadido(vikingos){
        const enemigosDerrotados = self.cantDefensoresDerrotados(vikingos)
        const monedasPorVikingo = (enemigosDerrotados + factorRiqueza) / vikingos.size()
        vikingos.forEach({vikingo => vikingo.oro(vikingo.oro() + monedasPorVikingo)})
        cantDefensores -= enemigosDerrotados
    }
}

class Aldea{
    const cantMinVikingos // 0 si no es amurallada
    const property iglesias

    method valeLaPena(vikingos) = self.cantMonedas() >= 15 and self.comitivaMinima(vikingos)

    method cantMonedas() = iglesias.sum({iglesia => iglesia.cantCrucifijos()})

    method comitivaMinima(vikingos) = vikingos.size() >= cantMinVikingos

    method esInvadido(vikingos){
        const monedasPorVikingo = self.cantMonedas() / vikingos
        vikingos.forEach({vikingo => vikingo.oro(vikingo.oro() + monedasPorVikingo)})
        iglesias.forEach({iglesia => iglesia.cantCrucifijos(0)})
    }
}


class Iglesia{
    var property cantCrucifijos
}

// Castas sociales
object jarl {
    method puedeIr(vikingo) = vikingo.armas().isEmpty()

    method ascenderSocialmente(vikingo){
        vikingo.castaSocial(karl)
        vikingo.tipoVikingo().ascender(vikingo)
    }
}
object karl {
    method puedeIr() = true

    method ascenderSocialmente(vikingo){
        vikingo.castaSocial(thrall)
    }
}
object thrall {
    method puedeIr() = true

    method ascenderSocialmente(_){}
}

// Tipos de vikingos
object soldado {
    method esProductivo(vikingo) = vikingo.vidasCobradas() > 20 and !vikingo.armas().isEmpty()

    method ascender(vikingo){
        vikingo.armas(vikingo.armas() + 10)
    }
}
object granjero {
    method esProductivo(vikingo) = vikingo.cantHectareas() >= vikingo.cantHijos() * 2

    method ascender(vikingo){
        vikingo.cantHijos(vikingo.cantHijos() + 2)
        vikingo.cantHectareas(vikingo.cantHectareas() + 2)
    }
}

/* 

Punto 1

describe "Vikingos" {

    test "Armar expediciones" { // 1
        const ragnar = new Vikingo(castaSocial = jarl, tipoVikingo = soldado, vidasCobradas = 2, armas = , hijos = [], cantHectareas = 1, oro = 10)
        const aldea1 = new Aldea(cantMinVikingos = 0, iglesias = [new Iglesia(cantCrucifijos = 10)])
        const norteAmerica = new Expedicion(vikingos = [ragnar], objetivos = [aldea1])
        norteAmerica.subirVikingo(ragnar)
        assert.that(norteAmerica.vikingos().isEmpty())
    }

    test "Expediciones que valen la pena" { // 2
        const ragnar = new Vikingo(castaSocial = jarl, tipoVikingo = soldado, vidasCobradas = 2, armas = , hijos = [], cantHectareas = 1, oro = 10)
        const aldea1 = new Aldea(cantMinVikingos = 0, iglesias = [new Iglesia(cantCrucifijos = 30)])
        const norteAmerica = new Expedicion(vikingos = [ragnar], objetivos = [aldea1])
        assert.isTrue(norteAmerica.valeLaPena())        
    }

    test "Ascenso social" { // 5
        const ragnar = new Vikingo(castaSocial = karl, tipoVikingo = soldado, vidasCobradas = 2, armas = , hijos = [], cantHectareas = 1, oro = 10)
        ragnar.ascenderSocialmente()
        assert.equals(thrall, ragnar.castaSocial())
    }
}

Punto 4

Si, dado que se hace uso de polimorfismo para el metodo esInvadido() y valeLaPena(), se implementa agregando una clase castillo que implemente estos metodos de forma diferente a las clases Capital y Aldea.
*/