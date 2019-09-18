class Destino {
		var nombre
		var sugerenciasDeViaje = []
		var precioPorVolar
		
		method nombre(){
			return nombre
		}
		
		method sugerenciasDeViaje(){
			return sugerenciasDeViaje
		}
		
		method agregarEquipaje(equipaje){
			sugerenciasDeViaje.add(equipaje)
		}
		
		method precioPorVolar(){
			return precioPorVolar
		}
	
		method destacado(){
			return precioPorVolar > 2000
		}
		
		method aplicarDescuento(descuento){
			precioPorVolar = precioPorVolar - precioPorVolar * descuento / 100
			self.agregarEquipaje("Certificado de descuento")
		}
		
		method esPeligroso(){
			return sugerenciasDeViaje.contains("Vacuna Gripal")|| sugerenciasDeViaje.contains("Vacuna B")
		}

}

object barrileteCosmico{ 
	var destinos = []
	
	method cartaDeDestinos(){
		return destinos.map({ destino => destino.nombre() })
	}
	
	method agregarDestino(destino){
		destinos.add(destino)
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
}
	
class Usuario {
	var username
	var historial = []
	var cuenta
	var siguiendo = []
	
	method historial(){
		return historial
	}

	method cuenta(){
		return cuenta
	}
	
	method volarA(destino){
		if (cuenta >= destino.precioPorVolar()){
			historial.add(destino)
			cuenta = cuenta - destino.precioPorVolar()	
		}
	}
	
	method kilometros(){
		return (historial.map({ destino => destino.precioPorVolar() })).sum() * 0.1
	}
	
	method seguirA(usuario){
		siguiendo.add(usuario)
		usuario.seguirA(self)
	}
}