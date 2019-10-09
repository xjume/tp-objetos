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
		
		method esPeligroso(){
			return sugerenciasDeViaje.any({sugerencia => sugerencia.contains("Vacuna")})
		}

}

class MedioDeTransporte{
	var duracion
	var valorPorKilometro

	method valorPorKilometro() = valorPorKilometro
	
}

class Usuario {
	var username
	var historial = []
	var cuenta
	var siguiendo = []
	var localidadDeOrigen
	
	method historial() = historial

	method cuenta () = cuenta 
	
	method localidadDeOrigen() = localidadDeOrigen
	
	method viajar(viaje){
		if (cuenta < viaje.precioDelViaje()){
			throw new UserException(message = "No puede viajar. Cuenta: " + cuenta + " Viaje: " 
				+ viaje.precioDelViaje()
			)
		}else{
			historial.add(viaje)
			cuenta = cuenta - viaje.precioDelViaje()
			localidadDeOrigen = viaje.localidadDeDestino()
		}
	}
	
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
}

class UserException inherits Exception { }

object barrileteCosmico{ 
	var destinos = []
	var mediosDeTransporte = []
	
	method mediosDeTransporte() = mediosDeTransporte
	
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
		return destinos.any({ destino => destino.esPeligroso() })
	}
		
	method lugaresPeligrosos(){
		return destinos.filter({ destino => destino.esPeligroso() })
	}
	
	method armarViaje(viaje, localidadDeDestino, usuario){
		viaje.cambiarOrigenSegun(usuario)
		viaje.colocarDestino(localidadDeDestino)
		viaje.medioDeTransportesAlAzar(mediosDeTransporte.take([0.randomUpTo(mediosDeTransporte.size())]))
	}
	
}