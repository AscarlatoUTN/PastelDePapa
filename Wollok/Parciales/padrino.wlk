/*
class Familia{
    const property integrantes
}

class Persona{
    const familia
    var property muerta = false
    const property armas = [new Revolver(balas = 3)]
    var property ultimaArmaUtilizada
    const rango

    method familia() = familia

    method usarArma(arma, persona){
        arma.matar(persona)
    }

    method hacerTrabajo(objetivo){
        rango.hacerTrabajo(self, objetivo)
    }
}

object don{
    method hacerTrabajo(persona, objetivo){
        persona.familia().integrantes().filter({persona => persona.rango() != self}).anyOne().hacerTrabajo(objetivo)
    }
}

object subjefe{
    method hacerTrabajo(persona){
        const armaSeleccionada = persona.armas().anyOne({arma => arma != persona.ultimaArmaUtilizada()})
        persona.usarArma(armaSeleccionada)
    }
}
object soldado{}

class Arma{
    var balas

    method matar(persona){
        persona.muerta(true)
    }
}

class Revolver inherits Arma{
    var property estaCargada = true

    method disparar(persona){
        if(self.estaCargada()){
            self.matar(persona)
            balas -= 1
            self.estaCargada(false)
        }
    }

    method recargarArma(){
        self.estaCargada(true)
    }
}

class Escopeta inherits Arma{

    method disparar(persona){
        if(persona.salud() < 100){
            self.matar(persona)
        } else{
            persona.salud(persona.salud() - 60)
        }
    }
}

class CuerdaDePiano inherits Arma{
    const calidad

    method disparar(persona){
        if(calidad.esBuenaCalidad()){
            self.matar(persona)
            balas -= 1
        }
    }
}

object buena{
    method esBuenaCalidad() = true
}
object mala{
    method esBuenaCalidad() = false
}
*/