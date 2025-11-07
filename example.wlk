class Tripulante {                                
   var property rol = rolLibre
   var property edad = 0
   var property fuerza = 0
   var property conocimiento = 0
 
  	
   method mayorDeEdad() = self.edad() >= 18

   	
   method prestigio() = rol.prestigio()
   	
   method podesCambiarA(otroRol) = otroRol.acepta(self)
   		   		
   method cambiarRol(otroRol){
     if (self.podesCambiarA(otroRol)) {
        rol = otroRol     
      } else {
        throw new DomainException(message="No se puede cambiar al rol indicado")
      }
   }
}

class Rol {
  method acepta(tripulante) = tripulante.mayorDeEdad() && self.condicionParticular(tripulante)

  method condicionParticular(tripulante) 
}
class RolObrero inherits Rol {
  override method condicionParticular(tripulante) = tripulante.fuerza() > 50
  method prestigio() = 50
}
class RolCapitan inherits RolMrFusion {
  override method condicionParticular(tripulante) = super(tripulante) && tripulante.esFuerte()
}
class RolMrFusion inherits Rol { // debe ser clase
  var conocimiento = 0
  override method condicionParticular(tripulante) = tripulante.conocimiento() >
        estacionEspacial.conocimientoPromedio() * 1.21
  method prestigio() = 100
}
object rolLibre {
  method acepta(tripulante) = true
  method prestigio() = 0
}


object estacionEspacial {
  var conocimientoPromedio = 20
  method conocimientoPromedio() = conocimientoPromedio
}

/* 

1a) Libre, Obrero y MrFusion deberían ser subclases de Tripulante.
    Falso, porque si por ejemplo Obrero hereda de tripulante, una vez que instancio el obrero, no puedo cambiar su clase.
    
1b) Puede agregarse un rol Capitán sin necesidad de modificar código existente (el rol Capitán es como Mr Fusión, pero además de ser inteligente debe ser fuerte, con fuerza mayor a 73).
    Falso, porque hay que modificar el podesCambiarA, agregando una condición al if.

1c) Puede agregarse el rol Capitán sin necesidad de repetir código.
    Verdadero, agrego esto:
    method prestigio() =
     if (self.rolActual() == "Libre") 0 else
     if (self.rolActual() == "Obrero") 50 else
     if (self.rolActual() == "MrFusión" || self.rolActual() == "Capitan") 100 else -1.
   Además, en el método podesCambiarA: agregaría:
  otroRol == "Capitan" && self.condicionParaCapitan()

  method condicionParaCapitan() = self.condicionParaMrFusion() && self.esFuerte()

1d) Suponiendo que en la estación hay varios tripulantes menores de edad. Puedo hacer:
tripulantes.forEach({ tripulante => tripulante.rolActual(“Obrero”) }
Y jamás me enteraría de que hubo un error.

   Verdadero, jamás me enteraría que hubo un error, porque el foreach:
   tripulantes.forEach({ tripulante => tripulante.rolActual(“Obrero”) }
   no hace nada con el string de retorno. 

*/