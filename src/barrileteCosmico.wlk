class Destinos {
		var nombre
		var sugerenciasDeViaje = []
		var precioPorVolar
		
		method sugerenciasDeViaje(){
			return sugerenciasDeViaje
		}
		method destacado(){
			return precioPorVolar > 2000
		}
		method aplicarDescuento(descuento){
			precioPorVolar = precioPorVolar - precioPorVolar * descuento / 100
			self.agregarEquipaje("Certificado de descuento")
		}
		method precioPorVolarConDescuento(descuento){
			self.aplicarDescuento(descuento)
			return precioPorVolar
		}
		method agregarEquipaje(equipaje){
			sugerenciasDeViaje.add(equipaje)
		}
		method llevarVacuna(){
			return sugerenciasDeViaje.contains("Vacuna Gripal")|| sugerenciasDeViaje.contains("Vacuna B")
			
		}
		method nombre(){
			return nombre
		}
		method precioPorVolar(){
			return precioPorVolar
		}
}
object barrileteCosmico{ 
	var destinos = []
	method obtenerLosDestinosMasImportantes(){
		return destinos.filter({destino=>destino.destacado()})
	}
	method aplicarDescuentoALosDestinos(descuento){
		destinos.forEach({destino => destino.aplicarDescuento(descuento)})
	}
	method esEmpresaExtrema(){
		return destinos.any({destino => destino.llevarVacuna()})
	}
	method cartaDeDestinos(){
		return destinos.forEach({destino => destino.nombre()})
	}
	method agregarDestinos(destino){
		destinos.add(destino)
	}
	method lugaresPeligrosos(){
		return destinos.filter({destino => destino.llevarVacuna()})
	}
}
	
	