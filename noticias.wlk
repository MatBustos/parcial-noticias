const palabrasSensacionalistas = ["espectacular", "increíble", "grandioso"]

class Noticia {
  const property fechaDePublicacion
  const property publicador
  const property gradoDeImportancia
  const property titulo
  const property desarrollo
  
  method esImportante() = gradoDeImportancia >= 8
  
  method esReciente() = (new Date() - fechaDePublicacion) < 3
  
  method esCopada() = self.esImportante() and self.esReciente()
  
  method tituloTieneAlgunaDe(unaListaDePalabras) = unaListaDePalabras.any(
    { palabra => titulo.contains(palabra) }
  )
  
  method esSensacionalista() = self.tituloTieneAlgunaDe(
    palabrasSensacionalistas
  )
  
  method esChivo() = false
  
  method tieneUnDesarrolloCorto() = desarrollo.size() < 100
  
  method tituloComienzaConT() = titulo.take(1) == "T"
  
  method fuePublicadaHoy() = fechaDePublicacion == new Date()
  
  method esDeLaUltimaSemana() = (new Date() - fechaDePublicacion) <= 7
  
  method estaBienEscrita() = (titulo.size() >= 2) and (not desarrollo.isEmpty())
}

class ArticuloComun inherits Noticia {
  const links
  
  method tieneSuficientesLinks() = links.size() >= 2
  
  override method esCopada() = super() and self.tieneSuficientesLinks()
}

class Chivo inherits Noticia {
  const property productoPromocionado
  const property costoMonetarioDeLaNoticia
  
  method sePagoLoSuficiente() = costoMonetarioDeLaNoticia > 2000000
  
  override method esCopada() = super() and self.sePagoLoSuficiente()
  
  override method esChivo() = true
}

class Reportaje inherits Noticia {
  const property personaEntrevistada
  
  method entrevistadoImpar() = (personaEntrevistada.size() % 2) == 1
  
  override method esCopada() = super() and self.entrevistadoImpar()
  
  override method esSensacionalista() = super() and (personaEntrevistada == "Dibu Martínez")
}

class Cobertura inherits Noticia {
  const property serieDeNoticiasRelacionadas
  
  override method esCopada() = super() and serieDeNoticiasRelacionadas.all(
    { noticia => noticia.esCopada() }
  )
}

class Periodista {
  const property fechaDeIngreso
  const preferencia
  const publicaciones = []
  
  method prefiere(unaNoticia) = preferencia.acepta(unaNoticia)
  
  method noPreferidasDeHoy() = publicaciones.count(
    { noticia => (not self.prefiere(noticia)) and noticia.fuePublicadaHoy() }
  )
  
  method puedePublicarOtraNoPreferidaHoy() = self.noPreferidasDeHoy() < 2
  
  method publicar(unaNoticia) {
    if (not unaNoticia.estaBienEscrita()) self.error(
        "La noticia no está bien escrita"
      )
    
    if ((not self.puedePublicarOtraNoPreferidaHoy()) and (not self.prefiere(
        unaNoticia
      ))) self.error("No puede publicar otra noticia no preferida hoy")
    
    publicaciones.add(unaNoticia)
  }
  
  method esReciente() = fechaDeIngreso.plusYears(1) >= new Date()
  
  method publicoEnLaUltimaSemana() = publicaciones.any(
    { noticia => noticia.esDeLaUltimaSemana() }
  )
}

object copado {
  method acepta(unaNoticia) = unaNoticia.esCopada()
}

object sensacionalista {
  method acepta(unaNoticia) = unaNoticia.esSensacionalista()
}

object vago {
  method acepta(
    unaNoticia
  ) = unaNoticia.esChivo() or unaNoticia.tieneUnDesarrolloCorto()
}

object titulosConT {
  method acepta(unaNoticia) = unaNoticia.tituloComienzaConT()
}

const joseDeZer = new Periodista(
  fechaDeIngreso = new Date().minusYears(3),
  preferencia = titulosConT
)

object diario {
  const periodistas = []
  
  method periodistasRecientesQuePublicaronEnLaUltimaSemana() = periodistas.filter(
    { periodista =>
      periodista.esReciente() and periodista.publicoEnLaUltimaSemana() }
  )
}
