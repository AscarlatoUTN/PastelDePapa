class Empleado{
    const property habilidades
    const property misionesCompletadas
    const saludCritica = tipoEmpleado.saludCritica()
    var property salud
    var property tipoEmpleado
    var estrellas

    method estaIncapacitado() = salud < saludCritica

    method hacerMision(mision){
        if(self.puedeCumplir(mision)){
            self.cumplirMision(mision)
        }
    }
    method puedeCumplir(mision) = mision.habilidadesRequeridas().all({habilidad => self.puedeUsarHabilidad(habilidad)})

    method cumplirMision(mision){
        salud -= mision.peligrosidad()
        if(salud > 0){
            self.registrarMision(mision)
        }
    }

    method puedeUsarHabilidad(habilidad) = !self.estaIncapacitado() && habilidades.contains(habilidad)

    method registrarMision(mision) = tipoEmpleado.registrarMision(self, mision)
}

class Jefe inherits Empleado{
    const property subordinados
}

object espia{
    method saludCritica() = 15

    method registrarMision(empleado, mision){
        empleado.misionesCompletadas().add(mision)
        empleado.habilidades().concat(mision.habilidades().filter({habilidad => !empleado.habilidades().contains(habilidad)}))
    }
}

object oficinista{
    method saludCritica(empleado) = 40 - 5 * empleado.estrellas()

    method registrarMision(empleado, mision){
        empleado.estrellas(empleado.estrellas() + 1)
        if(empleado.estrellas() == 3){
            empleado.tipoEmpleado(espia)
        }
    }
}

class Mision{
    const property habilidadesRequeridas
    const peligrosidad

    method peligrosidad() = peligrosidad
}

class Equipo{
    const property empleados

    method quitarIntegrante(integrante){
        empleados.remove(integrante)
    }

    method agregarIntegrante(integrante){
        empleados.add(integrante)
    }

    method hacerMision(mision){
        if(self.algunoCumple()){
            self.cumplirMision(mision)
        }
    }

    method algunoCumple() = empleados.any({empleado => empleado.cumplirMision()})

    method cumplirMision(mision){
        empleados.forEach({empleado => empleado.salud(empleado.salud() - mision.peligrosidad() / 3)})
        empleados.filter({empleado => empleado.salud() > 0}).forEach({empleado => empleado.registrarMision(mision)})
    }
}