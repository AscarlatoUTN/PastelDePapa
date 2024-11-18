class Plato{
    const peso
    const pesoParaEspecial
    const moneda

    method peso() = peso

    method aptoCeliaco()
    method valoracion()
    method esEspecial() = peso > pesoParaEspecial
    method precio(){
        const precio = 300 * self.valoracion()
        if(self.aptoCeliaco() and !monedasLegales.monedasConocidas().contains(moneda)){
            return precio + 1200
        }
        return precio
    }
}

object monedasLegales{
    const property monedasConocidas = ["peso", "dolar"]
}

class Moneda{
    const esConocida
    method esConocida() = esConocida
}

// Provoleta
class Provoleta inherits Plato(pesoParaEspecial = 250){
    const tieneEmpanado

    override method aptoCeliaco() = !tieneEmpanado

    override method esEspecial() = super() and tieneEmpanado

    override method valoracion(){
        if(self.esEspecial()){
            return 120
        } else{
            return 80
        }
    }
}

// Hamburguesas
class Hamburguesa inherits Plato(peso = pesoMedallon * tipoHamburguesa.cantMedallones() + pan.peso(), pesoParaEspecial = tipoHamburguesa.pesoParaEspecial()){
    const pesoMedallon
    const pan
    const tipoHamburguesa

    method peso() = peso

    override method aptoCeliaco() = pan.aptoCeliaco()

    override method valoracion() = peso * 0.1
}

object industrial {
  method peso() = 60
  method aptoCeliaco() = false
}
object casero {
  method peso() = 100
  method aptoCeliaco() = false
}
object maiz {
  method peso() = 30
  method aptoCeliaco() = true
}

object simple{
    method pesoParaEspecial() = 250
    method cantMedallones() = 1
    method esEspecial(hamburguesa) = hamburguesa.peso() > 250
}
object doble{
    method pesoParaEspecial() = 500
    method cantMedallones() = 2
    method esEspecial(hamburguesa) = hamburguesa.peso() > 500
}

// Corte de Carne
class CorteDeCarne inherits Plato(peso = 200.randomUpTo(300), pesoParaEspecial = 250){
    const tipoCorte
    const tipoCarne

    override method esEspecial() = super() and tipoCarne.esEspecial()

    override method aptoCeliaco() = true

    override method valoracion() = 100
}

object asado{}
object vacio{}
object matambre{}

object jugoso{
    method esEspecial() = false
}
object aPunto{
    method esEspecial() = true
}
object cocido{
    method esEspecial() = false
}

// Parrillada
class Parrillada inherits Plato(peso = self.pesoPlatos(), pesoParaEspecial = 250){
    const property platos

    method pesoPlatos() = platos.sum({plato => plato.peso()})

    override method esEspecial() = super() and platos.size() >= 3

    override method aptoCeliaco() = platos.all({plato => plato.aptoCeliaco()})

    override method valoracion() = platos.map({plato => plato.valoracion()}).max()
}

object parrilla{
    const property platos = []
    var property ingresos = 0
    const property comensales = []

    method nuevoPlato(plato){
        platos.add(plato)
    }
    method nuevoComensal(comensal){
        comensales.add(comensal)
    }

    method promocionar(dineroPorComensal){ // Depende si el nro es aleatorio o dado por parametro, se puede hacer de ambas formas, me pinto hacer esta
        const gastoPromocion = dineroPorComensal * comensales.size()
        if(ingresos >= gastoPromocion){
            comensales.forEach({comensal => self.regalarDinero(comensal, dineroPorComensal)})
            ingresos -= gastoPromocion
        }
    }

    method regalarDinero(comensal, dineroPorComensal){
        comensal.dinero(comensal.dinero() + dineroPorComensal)        
    }
}

class Comensal{
    var property dinero
    var property tipoComensal

    method leAgrada(plato) = tipoComensal.leAgrada(plato)

    method darGusto(){
        const platosPosibles = parrilla.platos().filter({plato => self.leAgrada(plato) and self.puedePagar(plato)})
        // const platosPosibles = parrilla.platos().filter({plato => comensal1.leAgrada(plato) and comensal1.puedePagar(plato)})
        if(!platosPosibles.isEmpty()){
            // const plato = parrilla.platos().sortBy({plato1, plato2 => plato1.valoracion() > plato2.valoracion()}).first()
            const masValorado = platosPosibles.max({plato => plato.valoracion()})
            self.pagarPlato(masValorado)
        }
        // else throw new MyException "no es posible darse un gusto"
    }

    method puedePagar(plato) = dinero >= plato.precio()

    method pagarPlato(plato){
        self.dinero(self.dinero() - plato.precio())
        parrilla.ingresos(parrilla.ingresos() + plato.precio())
    }

    method cambioDeHabito(tipoProblema){
        tipoProblema.cambioHabito(self)
    }
}

// Tipos de comensal
object celiaco{
    method leAgrada(plato) = plato.aptoCeliaco()
}
object paladarFino{
    method leAgrada(plato) = plato.esEspecial() || plato.valoracion() > 100
}
object todoTerreno{
    method leAgrada(_) = true
}

// Tipo de problemas
object gastrico{
    method cambioHabito(comensal){
        comensal.tipoComensal(celiaco)
    }
}
object economico{
    method cambioHabito(comensal){
        if(comensal.tipoComensal() == paladarFino){
            comensal.tipoComensal(todoTerreno)
        }
    }
    
}
object social{
    method cambioHabito(comensal){
        comensal.tipoComensal(paladarFino)
    }
}
/*
describe "Parrilla" {

    test "Casos significativos de parrillada con al menos tres componentes" {
        const parrillada1 = new Parrillada(moneda = "peso", platos = [new Provoleta(peso = 200, tieneEmpanado = false, moneda = "peso"), new Hamburguesa(pesoMedallon = 100, pan = industrial, tipoHamburguesa = simple, moneda = "peso"), new CorteDeCarne(tipoCorte = asado, tipoCarne = jugoso, moneda = "peso")])
        assert.that(parrillada1.esEspecial())
        assert.notThat(parrillada1.aptoCeliaco())
        assert.equals(100, parrillada1.valoracion())
    }
    test "Comensal quiere darse un gusto en la parrilla y puede" {
        parrilla.platos().add(new Parrillada(moneda = "peso", platos = [new Provoleta(peso = 200, tieneEmpanado = false, moneda = "peso")ovoleta1, new Hamburguesa(pesoMedallon = 100, pan = industrial, tipoHamburguesa = simple, moneda = "peso"), new CorteDeCarne(tipoCorte = asado, tipoCarne = jugoso, moneda = "peso")]))
        parrilla.platos().add(new Provoleta(peso = 200000, tieneEmpanado = false, moneda = "peso"))
        const comensal1 = new Comensal(dinero = 26000, tipoComensal = todoTerreno)
        comensal1.darGusto()
        assert.equals(2000, comensal1.dinero())
    }
    test "Cambio de hábito de algún comensal" {
        const comensal1 = new Comensal(dinero = 26000, tipoComensal = todoTerreno)
        comensal1.cambioDeHabito(gastrico)
        assert.equals(celiaco, comensal1.tipoComensal())
    }
}
*/