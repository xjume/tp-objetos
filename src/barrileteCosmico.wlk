class Destino inherits Localidades {
		var nombre
		var sugerenciasDeViaje = []
		var precioPorVolar
		
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
		
		method esPeligroso(){
			return sugerenciasDeViaje.any({sugerencia => sugerencia.contains("Vacuna")})
		}

}

object barrileteCosmico{ 
	var destinos = []
	var mediosDeTransporte = []
	
	method cartaDeDestinos(){
		return destinos.map({ destino => destino.nombre() })
	}
	
	method agregarDestino(destino){
		destinos.add(destino)
	}
	
	method agregarMedioDeTransporte(medioDeTransporte){
		mediosDeTransporte.add(medioDeTransporte)
	}
	
	method elegirAlAzarTransporte(){
		return mediosDeTransporte.take(1)	/*Hay que ver como sacamos un medio de transporte al azar porque asi agarra siempre el primero*/
	}
	
	
	method destinosMasImportantes(){
		return destinos.filter({ destino=>destino.destacado() })
	}
	
	method aplicarDescuentoATodosLosDestinos(descuento){
		destinos.forEach({ destino => destino.aplicarDescuento(descuento) })
	}
	
	method esEmpresaExtrema(){
		return destinos.any({ destino => destino.esPeligroso() })
	}
		
	method lugaresPeligrosos(){
		return destinos.filter({ destino => destino.esPeligroso() })
	}
	method armarViaje(viaje,localidadDeDestino,usuario){
		viaje.cambiarOrigen(usuario)
		viaje.colocarDestino(localidadDeDestino)
		viaje.medioDeTransporte(self)
	}
	
}
	
class Usuario {
	var username
	var historial = []
	var cuenta
	var siguiendo = []
	var localidadDeOrigen
	
	
	method localidadDeOrigen(){
		return localidadDeOrigen
	}
	method historial(){
		return historial
	}

	method cuenta() = cuenta 
	
	method viajar(viajes){
		if (cuenta < viajes.precioDelViaje()){
			throw new UserException(message = "No puede viajar")
		}else{
			historial.add(viajes)
			cuenta = cuenta - viajes.precioDelViaje()
			localidadDeOrigen = viajes.localidadDeDestino()
		}
	}
	method kilometros(){
		return historial.map({viajes => viajes.kilometrosEntre()}).sum() 
	}
	
	
	method seguirA(usuario){
		siguiendo.add(usuario)
		usuario.follow(self)
	}
	method follow(usuario){
		siguiendo.add(usuario)
	}
}
class MedioDeTransporte{
	var duracion
	var valorPorKilometro
	method valorPorKilometro(){
		return valorPorKilometro
	}
}
class Localidades {
	var kilometroDeUbicacion
	
	method kilometroDeUbicacion(){
		return kilometroDeUbicacion
	}
	method kilometrosHasta(localidad){
		return (self.kilometroDeUbicacion() - localidad.kilometroDeUbicacion()).abs()
	}
}
class Viajes {
	var localidadDeOrigen
	var localidadDeDestino
	var medioDeTransporte 
	method kilometrosEntre(){
		return (localidadDeOrigen.kilometroDeUbicacion() - localidadDeDestino.kilometroDeUbicacion()).abs()
	}
	
	method localidadDeOrigen(){
		return localidadDeOrigen
	}
	method localidadDeDestino(){
		return localidadDeDestino
	}
	method precioDelViaje(){
		return self.precioDelMedioDeTransporte()+ localidadDeDestino.precioPorVolar()
	}
	method precioDelMedioDeTransporte(){
		return medioDeTransporte.valorPorKilometro()*localidadDeOrigen.kilometrosHasta(localidadDeDestino)
	}
	method cambiarOrigen(usuario){
		localidadDeOrigen = usuario.localidadDeOrigen()
	}
	method colocarDestino(localidad){
		localidadDeDestino = localidad 
			
	}
	method medioDeTransporte(barrileteCosmico){
		medioDeTransporte = barrileteCosmico.elegirAlAzarTransporte()
	}
		
}
class UserException inherits Exception { }