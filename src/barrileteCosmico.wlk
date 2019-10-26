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
		
		method esPeligrosoPara(usuario){
			return sugerenciasDeViaje.any({sugerencia => sugerencia.contains("Vacuna")})
		}
}

class Playa inherits Localidad{
	override method esPeligrosoPara(usuario){
		return false
	}
}

class Montania inherits Localidad{
	var altura 
	
	override method esPeligrosoPara(usuario){
		return super(usuario) && self.mideMasDe5000()
	}
	
	method mideMasDe5000(){
		return altura > 5000
	}
	
	override method destacado(){
		return true
	}
}

class CiudadHistorica inherits Localidad{
	var museos = []
	
	override method esPeligrosoPara(usuario){
		return usuario.tiene("Asistencia al viajero").negate()
	}
	
	override method destacado(){
		return super() && self.poseeMasDe3Museos() 
	}
	
	method poseeMasDe3Museos(){
		return museos.size() > 3
	}
}

class MedioDeTransporte{
	var duracion
	var valorPorKM = 1
	
	method duracion() = duracion
	method valorPorKilometro() = valorPorKM
}

class Avion inherits MedioDeTransporte{
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

class Micro inherits MedioDeTransporte{
	override method valorPorKilometro(){
		return 5000
	}
}

class Tren inherits MedioDeTransporte{
	override method valorPorKilometro(){
		return 2300 * 1.6
	}
}

class Barco inherits MedioDeTransporte{
	var probabilidadDeChocarConIceberg
	
	override method valorPorKilometro(){
		return 1000 * probabilidadDeChocarConIceberg
	}
}

class Turbina{
	var nivelDeImpulso
	
	method nivelDeImpulso(){
		return nivelDeImpulso
	}
}

class Usuario {
	var username
	var historial = []
	var cuenta
	var siguiendo = []
	var origen
	var destino
	var perfil
	var mochila = []
	
	method historial() = historial

	method cuenta () = cuenta 
	
	method localidadDeOrigen() = origen
	
	method viajar(viaje){
		var precio = viaje.precioDelViaje()
		
		if (cuenta < precio || self.mochilaTieneTodoPara(viaje.localidadDeDestino()).negate()){		
			throw new UserException(message = "No puede viajar. Cuenta: " + cuenta + " Viaje: " + precio)	
		} else {
			historial.add(viaje)
			cuenta = cuenta - precio
			origen = viaje.localidadDeDestino()
		}
	}
	
	// Método desarrollado específicamente para testing
	method vaciarMochila(){
		mochila.clear()
	}
	
	method mochilaTieneTodoPara(localidadDestino){
		return localidadDestino.sugerenciasDeViaje().all({ sugerencia => mochila.any({ item => item == sugerencia }) })
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

	method perfil(perfilDeUsuario){
		perfil = perfilDeUsuario
	}
	
	method medioDeTransportePreferidoDe(agencia){
		perfil.elegirMedioDeTransporteDe(agencia)
	}
	
	method tiene(objetoEnLaMochila){
		return mochila.any({item => item.contains("Asistencia al viajero")})
	}
}

object empresario{
	method elegirMedioDeTransporteDe(agencia){
		return agencia.medioDeTransporteMasRapido()
	}
}

//object estudiantil{
//	method elegirMedioDeTransporteDe(agencia){
//		if(self.cuenta()>= agencia.medioDeTransporteMasRapido().valor)
//		return agencia.medioDeTransporteMasRapido()
//	}
//}

object grupoFamiliar{
	method elegirMedioDeTransporteDe(agencia){
		return agencia.mediosDeTransporte().take([0.randomUpTo(agencia.cantidadDeMediosDeTransporte())])
	}
}

class Viaje{
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
		return medioDeTransporte.valorPorKilometro() * localidadDeOrigen.kilometrosHasta(localidadDeDestino)
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
		return destinos.filter({ destino => destino.destacado() })
	}
	
	method aplicarDescuentoATodosLosDestinos(descuento){
		destinos.forEach({ destino => destino.aplicarDescuento(descuento) })
	}
	
	method esEmpresaExtremaPara(usuario){
		return destinos.any({ destino => destino.esPeligrosoPara(usuario) })
	}
		
	method lugaresPeligrososPara(usuario){
		return destinos.filter({ destino => destino.esPeligrosoPara(usuario) })
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
