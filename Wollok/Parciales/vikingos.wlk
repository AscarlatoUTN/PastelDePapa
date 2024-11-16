class Vikingo{
    const castaSocial
    const tipoVikingo
    var property vidasCobradas
    var property armas
    const property hijos
    var property cantHectareas

    method esProductivo() = tipoVikingo.esProductivo(self)

    method realizarExpedicion(expedicion){
        if(castaSocial.puedeIr(self) and self.esProductivo()){}
    }

}

class Expedicion{
    const tipoExpedicion

    method valeLaPena(lugar, vikingos) = tipoExpedicion.valeLaPena(lugar, vikingos)
}

class Capital{
    const factorRiqueza

    method factorRiqueza() = factorRiqueza
}

class Aldea{
    const cantMinVikingos
    const property iglesias

    method cantMinVikingos() = cantMinVikingos
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
    method esProductivo(vikingo) = vikingo.hijos().all({hijo => hijo.cantHectareas() >= 2})

    method ascender(vikingo){
        // vikingo.add(new Vikingo())
    }
}

object invasioncapital{
    method valeLaPena(capital, vikingos) = self.cantMonedas(capital, vikingos) >= 3 * vikingos.size()

    method cantMonedas(capital, vikingos) = self.cantDefensoresDerrotados(vikingos) * capital.factorRiqueza()

    method cantDefensoresDerrotados(vikingos) = vikingos.size()
}

object invasionAldea{
    method valeLaPena(aldea, vikingos) = aldea.cantMonedas(aldea) >= 15 and self.comitivaMinima(aldea, vikingos)

    method cantMonedas(aldea){
        const iglesias = aldea.iglesias()
        const cantCrucifijos = iglesias.sum({iglesia => iglesia.cantCrucifijos()})
        iglesias.forEach({iglesia => iglesia.cantCrucifijos(0)})
        return cantCrucifijos
    }

    method comitivaMinima(aldea, vikingos) = vikingos.size() >= aldea.cantMinVikingos()
}
