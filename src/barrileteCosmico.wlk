class Localidad {
		var nombre
		var sugerenciasDeViaje = []
		var precioPorVolar
		var kilometroDeUbicacion
	
		method kilometroDeUbicacion() = kilometroDeUbicacion
		
		method kilometrosHasta(localidad){
			return (self.kilometroDeUbicacion() - localidad.kilometroDeUbicacion()).abs()
		}
	
		method nombre() = nombre
		
		method sugerenciasDeViaje() = sugerenciasDeViaje 
		
		method precioPorVolar() = precioPorVolar
		
		method agregarEquipaje(equipaje){
			sugerenciasDeViaje.add(equipaje)
		}
	
		method destacado(){
			return precioPorVolar > 2000
		}
		
		method aplicarDescuento(descuento){
			precioPorVolar = precioPorVolar - precioPorVolar * descuento / 100
			self.agregarEquipaje("Certificado de descuento")
		}
		
		method esPeligroso(localidad){
			return sugerenciasDeViaje.any({sugerencia => sugerencia.contains("Vacuna")})
		}
		method destinoDestacado(localidad){
			return precioPorVolar > 2000
		}

}

class Playas inherits Localidad{
	override method esPeligroso(localidad){
		return false
	}
}
class Montanias inherits Localidad{
	var altura 
	
	 override method esPeligroso(localidad){
		return super(localidad) && self.tengoMasDe5000()
	}
	method tengoMasDe5000(){
		return altura > 5000
	}
	override method destinoDestacado(localidad){
		return true
	}
}
class CiudadesHistoricas inherits Localidad{
	var museos = []
	
	override method esPeligroso(localidad){
		return sugerenciasDeViaje.any({sugerencia => sugerencia.contains("Asistencia al viajero")})
	}
	override method destinoDestacado(localidad){
		return super(localidad) && self.poseeMasDe3Museos() 
	}
	method poseeMasDe3Museos(){
		return self.cantidadDeMuseos() > 3
	}
	method cantidadDeMuseos(){
		return museos.size()
	}
}

class MedioDeTransporte{
	var duracion
	var valorPorKilometro
	
	method valorPorKilometro() = valorPorKilometro
	method duracion()= duracion
}
class Aviones inherits MedioDeTransporte{
	var turbinas = []
	
	override method valorPorKilometro(){
		return self.impulsoDeTurbinas().sum()
	}
	method impulsoDeTurbinas(){
		return turbinas.map({turbina=>turbina.nivelDeImpulso()})
	}
	method agregarTurbina(turbina){
		turbinas.add(turbina)
	}
}
class Micros inherits MedioDeTransporte{
	override method valorPorKilometro(){
		return 5000
	}
}
class Trenes inherits MedioDeTransporte{
	override method valorPorKilometro(){
		return 2300 * 1.6
	}
}
class Barcos inherits MedioDeTransporte{
	var probabilidadDeChocarConIceberg
	
	override method valorPorKilometro(){
		return 1000 * probabilidadDeChocarConIceberg
	}
}
class Turbinas{
	var nivelDeImpulso
	
	method nivelDeImpulso(){
		return nivelDeImpulso
	}
}

class Usuario {
	var userName
	var historial = []
	var cuenta
	var siguiendo = []
	var localidadDeOrigen
	var perfil
	//var mochila = []
	
	method historial() = historial

	method cuenta () = cuenta 
	
	method localidadDeOrigen() = localidadDeOrigen
	
	method viajar(viaje){
		var precio = viaje.precioDelViaje()
		
		if (cuenta < precio /* || self.mochilaTieneTodo(viaje).negate()*/){
			
			throw new UserException(message = "No puede viajar. Cuenta: " + cuenta + " Viaje: " + precio)
		
		} else {
			historial.add(viaje)
			cuenta = cuenta - precio
			localidadDeOrigen = viaje.localidadDeDestino()
		}
	}
	/*method mochilaTieneTodo(viaje){
		return mochila.containsall(viaje.localidadDeDestino().sugerenciasDeViaje())
	}*/
	method kilometros(){
		return historial.map({viaje => viaje.kilometrosEntre()}).sum() 
	}
	
	method seguirA(usuario){
		siguiendo.add(usuario)
		usuario.follow(self)
	}
	
	method follow(usuario){
		siguiendo.add(usuario)
	}
}
object empresario inherits Usuario{
	method elegirMedioDeTransporteDe(agencia){
		return agencia.medioDeTransporteMasRapido()
	}
}
/*object estudiantil inherits Usuario{
	method elegirMedioDeTransporteDe(agencia){
		if(self.cuenta()>= agencia.medioDeTransporteMasRapido().valor)
		return agencia.medioDeTransporteMasRapido()
	}
}*/
object grupoFamiliar inherits Usuario{
	method elegirMedioDeTransporteDe(agencia){
		return agencia.mediosDeTransporte().take([0.randomUpTo(agencia.cantidadDeMediosDeTransporte())])
	}
	}

class Viajes {
	var localidadDeOrigen
	var localidadDeDestino
	var medioDeTransporte 
	
	method kilometrosEntre(){
		return (localidadDeOrigen.kilometroDeUbicacion() - localidadDeDestino.kilometroDeUbicacion()).abs()
	}
	
	method localidadDeOrigen() = localidadDeOrigen
	
	method localidadDeDestino() = localidadDeDestino
	
	method medioDeTransporte() = medioDeTransporte

	method precioDelViaje(){
		return self.precioDelMedioDeTransporte() + localidadDeDestino.precioPorVolar()
	}
	
	method precioDelMedioDeTransporte(){
		return medioDeTransporte.valorPorKilometro()*localidadDeOrigen.kilometrosHasta(localidadDeDestino)
	}
	
	method cambiarOrigenSegun(usuario){
		localidadDeOrigen = usuario.localidadDeOrigen()
	}
	
	method colocarDestino(localidad){
		localidadDeDestino = localidad		
	}
	
	method medioDeTransportesAlAzar(transporte){
		medioDeTransporte = transporte
	}
	method medioDeTransportesElegidoPor(usuario,agencia){
		medioDeTransporte = usuario.elegirMedioDeTransporteDe(agencia)
	}		
}

class UserException inherits Exception { }

object barrileteCosmico{ 
	var destinos = []
	var mediosDeTransporte = []
	
	method mediosDeTransporte(){
		return mediosDeTransporte
		
		}
	
	method cartaDeDestinos(){
		return destinos.map({ destino => destino.nombre() })
	}
	
	method agregarDestino(destino){
		destinos.add(destino)
	}
	
	method agregarMedioDeTransporte(medioDeTransporte){
		mediosDeTransporte.add(medioDeTransporte)
	}
	
	method destinosMasImportantes(){
		return destinos.filter({ destino=>destino.destacado() })
	}
	
	method aplicarDescuentoATodosLosDestinos(descuento){
		destinos.forEach({ destino => destino.aplicarDescuento(descuento) })
	}
	
	method esEmpresaExtrema(){
		return destinos.any({ destino => destino.esPeligroso(destino) })
	}
		
	method lugaresPeligrosos(){
		return destinos.filter({ destino => destino.esPeligroso(destino) })
	}
	
	method armarViaje(viaje, localidadDeDestino, usuario){
		viaje.cambiarOrigenSegun(usuario)
		viaje.colocarDestino(localidadDeDestino)
		viaje.medioDeTransportesAlAzar(mediosDeTransporte.take([0.randomUpTo(self.cantidadDeMediosDeTransporte())]))
	}
	
	method cantidadDeMediosDeTransporte() {
		return mediosDeTransporte.size()
	}
	method medioDeTransporteMasRapido(){
		return mediosDeTransporte.min({transporte=>transporte.duracion()})
	}
	
}
