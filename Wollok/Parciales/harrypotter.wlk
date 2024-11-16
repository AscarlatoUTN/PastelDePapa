/*
class Bot{
    var property cargaElectrica
    var property tipoAceite
}

class Persona inherits Bot{
    const casa
    const tipoPersona
    const property hechizosAprendidos
    const property materiasDictadas

    method esExperimentado() = tipoPersona.esExperimentado()

    method casa() = casa
    method lanzarEchizo(hechizo, bot){
        if(self.puedeLanzar(hechizo)){
            hechizo.lanzar(bot)
        }
    }

    method puedeLanzar(hechizo) = self.hechizosAprendidos().contains(hechizo) and self.activo() and hechizo.cumpleCondiciones(self)

    method activo() = cargaElectrica > 0
}

object profesor{
    method esProfesor() = true

    method esExperimentado(persona) = persona.materiasDictadas().size() >= 2 and estudiante.esExperimentado(persona)
}

object estudiante{
    method esProfesor() = false

    method esExperimentado(persona) = persona.hechizosAprendidos().size() >= 3 and persona.cargaElectrica() > 50
}

object hoghwarts{
    const property estudiantes = []

    method estudiantesSucios() = estudiantes.filter({estudiante => estudiante.tipoAceite().esSucio()})

    method estudiantesPuros() = estudiantes.filter({estudiante => !estudiante.tipoAceite().esSucio()})
}

// Objetos

object puro{
    method esSucio() = false
}
object sucio{
    method esSucio() = true
}

object escoba{}
object varita{}
object snitch{}
object sombreroSeleccionador{}

object gryffindor{
    method esPeligrosa() = false
}
object slytherin{
    method esPeligrosa() = true
}
object ravenclaw{
    method esPeligrosa() = hoghwarts.estudiantesSucios().size() > hoghwarts.estudiantesPuros().size()
}
object hufflepuff{
    method esPeligrosa() = hoghwarts.estudiantesSucios().size() > hoghwarts.estudiantesPuros().size()
}

object inmobilus {
    method cumpleCondiciones(_) = true

    method lanzar(persona) {
        if(persona.tipoPersona().esProfesor()){
            persona.cargaElectrica(persona.cargaElectrica() - 50)
        }
    }
}

object sectumSempra {
    method cumpleCondiciones(bot) = bot.experimentado()

    method lanzar(persona) {
        if(persona.tipoPersona() != sombreroSeleccionador){
            persona.tipoAceite(sucio)
        }
    }
}
object avadakedabra {
    method cumpleCondiciones(persona) = persona.tipoAceite().esSucio() || persona.casa().esPeligrosa()

    method lanzar(bot) {
        bot.cargaElectrica(0)
    }
}

object expelliarmus{
    method cumpleCondiciones(bot) = true

    method lanzar(bot){
        bot.experimentado(false)
    }
}

class HechizoElectrico{
    const danioElectrico
    method cumpleCondiciones(bot) = bot.cargaElectrica() > danioElectrico
    
    method lanzar(persona) {
        if(persona.tipoPersona().esProfesor()){
            persona.cargaElectrica(persona.cargaElectrica() - danioElectrico)
        } else if(danioElectrico == persona.cargaElectrica()){
            persona.cargaElectrica(persona.cargaElectrica() * 0.5)
        }
    }
}
*/