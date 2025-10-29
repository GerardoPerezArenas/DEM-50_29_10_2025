# SOLUCI�N: Guardado Secuencial TAB1 y TAB2 en Modal Desglose

## ?? Problema Identificado

### S�ntoma
Al modificar l�neas de desglose en TAB2 y dar "Aceptar", la vista no reflejaba los nuevos c�lculos de RSBCOMPCONV y CSTCONT hasta reentrar al formulario.

### Causa Ra�z Descubierta

El flujo real del modal es:

```
Ventana Padre (Formulario Contrataci�n)
  ?
  ??? Modal Desglose (m11Desglose.jsp)
       ??? TAB 1 (m11Desglose_Tab1.jsp) - Resumen RSB
       ?    - rsbSalBase (Salario base)
       ?    - rsbPagasExtra (Pagas extraordinarias)
       ?    - rsbCompImporte (Complementos totales)
       ?    - rsbCompExtra (Extrasalariales totales)
       ?
       ??? TAB 2 (m11Desglose_Tab2.jsp) - Detalle l�neas
            - Tabla de complementos salariales (RSBTIPO='1')
            - Tabla de complementos extrasalariales (RSBTIPO='2')
            - Di�logo inline para modificar/a�adir l�neas
```

### El Problema Real

**Antes de la soluci�n:**

1. Usuario modifica l�nea en TAB2 ? Abre di�logo inline
2. Usuario da "Aceptar" en di�logo ? Solo actualiza **cache local** (NO BD)
3. Usuario da "Aceptar" en modal principal ? Solo ejecuta `guardarDesglose()` de TAB1
4. **TAB1 guarda sus campos** (base, pagas, totales) **pero NO llama a TAB2**
5. **Las l�neas modificadas en TAB2 NUNCA se guardaban**
6. Los c�lculos no se actualizaban porque los datos en BD no cambiaron

**Flujo incorrecto:**
```
Modificar l�nea TAB2 ? Cache local actualizado
                         ?? BD SIN CAMBIOS
?
Aceptar modal ? guardarDesglose() TAB1 solamente
                ?? TAB2 NO SE GUARDA
?
C�lculos ejecutados ? Pero usan datos VIEJOS de BD
?
Vista muestra valores incorrectos
```

## ? Soluci�n Implementada

### Estrategia

Modificar `guardarDesglose()` en TAB1 para que:

1. **Primero guarde TAB2** (l�neas de desglose)
2. **Espere confirmaci�n** de guardado exitoso
3. **Luego guarde TAB1** (campos de resumen)
4. **Reciba valores actualizados** desde BD
5. **Actualice ventana padre** con valores frescos

**Flujo correcto:**
```
Modificar l�nea TAB2 ? Cache local actualizado
?
Aceptar modal ? ? Guardar TAB2 primero
                  - Env�a lineasAllCache a BD
                  - BD ejecuta INSERT/UPDATE/DELETE
                  - BD ejecuta recalcularRsbCompConv()
                  - BD ejecuta recalcularCstContDesdeDesglose()
?
Callback exitoso ? ? Guardar TAB1 (300ms despu�s)
                  - Guarda campos de resumen
                  - Backend consulta BD para valores frescos
                  - Devuelve JSON con rsbCompConv y cstCont
?
AJAX response ? ? Actualizar window.opener
                  - Extrae rsbCompConv del JSON
                  - Actualiza campo rsbTotal en ventana padre
?
Modal se cierra ? Vista muestra valores correctos ?
```

---

## ?? Cambios Implementados

### 1. Exponer Funci�n de Guardado de TAB2 Globalmente

**Archivo:** `src/web/jsp/extension/melanbide11/desglose/m11Desglose_Tab2.jsp`

**L�nea:** ~604 (al final del IIFE)

**Cambio:**

```javascript
// ANTES:
	window.refrescarDesgloseRSB = cargarDesgloseTabla;
	setTimeout(cargarDesgloseTabla, 60);
})();

// DESPU�S:
	// Exponer funciones globalmente para que TAB1 pueda llamarlas
	window.refrescarDesgloseRSB = cargarDesgloseTabla;
	window.guardarLineasDesgloseTab2 = guardarLineasDesglose;
	
	console.log("=== TAB2 FUNCIONES EXPUESTAS ===");
	console.log("window.refrescarDesgloseRSB:", typeof window.refrescarDesgloseRSB);
	console.log("window.guardarLineasDesgloseTab2:", typeof window.guardarLineasDesgloseTab2);
	
	setTimeout(cargarDesgloseTabla, 60);
})();
```

**Prop�sito:**
- Permitir que TAB1 acceda a la funci�n de guardado de TAB2
- Mantener encapsulaci�n pero exponer API controlada
- A�adir logs de depuraci�n

---

### 2. Modificar Funci�n de Guardado en TAB1

**Archivo:** `src/web/jsp/extension/melanbide11/desglose/m11Desglose_Tab1.jsp`

**L�nea:** ~152

**Cambio completo:**

```javascript
function guardarDesglose(){
    if(!validarDesglose()){
      jsp_alerta('A', mensajeValidacion);
      return;
    }
    
    console.log("=== INICIANDO GUARDADO COMPLETO ===");
    
    // PASO 1: Buscar funci�n de guardado de TAB2
    var guardarTab2Existe = false;
    var fnGuardarTab2 = null;
    
    try {
      // Buscar funci�n expuesta por TAB2
      if (typeof window.guardarLineasDesgloseTab2 === 'function') {
        console.log("? window.guardarLineasDesgloseTab2 encontrada");
        fnGuardarTab2 = window.guardarLineasDesgloseTab2;
        guardarTab2Existe = true;
      } else if (typeof guardarLineasDesglose === 'function') {
        console.log("? guardarLineasDesglose encontrada en contexto actual");
        fnGuardarTab2 = guardarLineasDesglose;
        guardarTab2Existe = true;
      }
    } catch (e) {
      console.warn("No se pudo acceder a funci�n de guardado de TAB2:", e);
    }
    
    // PASO 2: Funci�n interna para guardar datos de TAB1
    function guardarDatosTab1() {
      console.log("=== GUARDANDO DATOS TAB1 (Resumen) ===");
      elementoVisible('on', 'barraProgresoLPEEL');

      var rsbSalBase = document.getElementById('rsbSalBase').value;
      var rsbPagasExtra = document.getElementById('rsbPagasExtra').value;
      var rsbCompImporte = document.getElementById('rsbCompImporte').value;
      var rsbCompExtra = document.getElementById('rsbCompExtra').value;

      var parametros = "tarea=preparar&modulo=MELANBIDE11&operacion=guardarDesgloseRSB&tipo=0"
        + "&idRegistro=" + encodeURIComponent('<%=idRegistro%>')
        + "&rsbSalBase=" + encodeURIComponent(rsbSalBase)
        + "&rsbPagasExtra=" + encodeURIComponent(rsbPagasExtra)
        + "&rsbCompImporte=" + encodeURIComponent(rsbCompImporte)
        + "&rsbCompExtra=" + encodeURIComponent(rsbCompExtra);

      try{
        $.ajax({
          url: url,
          type: 'POST',
          async: true,
          data: parametros,
          success: procesarRespuestaGuardar,
          error: mostrarErrorGuardar
        });
      }catch(err){
        console.error("Error en AJAX TAB1:", err);
        elementoVisible('off', 'barraProgresoLPEEL');
        mostrarErrorPeticion();
      }
    }
    
    // PASO 3: Ejecutar guardado secuencial
    if (guardarTab2Existe && fnGuardarTab2) {
      console.log("=== GUARDANDO PRIMERO L�NEAS DE DESGLOSE (TAB2) ===");
      elementoVisible('on', 'barraProgresoLPEEL');
      
      try {
        // Guardar TAB2 con callback para continuar con TAB1
        fnGuardarTab2(function(exitoTab2) {
          console.log("Resultado guardado TAB2:", exitoTab2);
          if (exitoTab2) {
            console.log("? TAB2 guardado exitosamente, continuando con TAB1");
            // Peque�a pausa para asegurar que BD se actualiz�
            setTimeout(guardarDatosTab1, 300);
          } else {
            console.error("? Error guardando TAB2, abortando");
            elementoVisible('off', 'barraProgresoLPEEL');
            jsp_alerta('A', 'Error al guardar las l�neas de desglose. No se continuar� con el guardado.');
          }
        });
      } catch (errTab2) {
        console.error("Error ejecutando guardarLineasDesgloseTab2:", errTab2);
        // Si falla TAB2, continuar con TAB1 de todos modos
        console.warn("Continuando con guardado TAB1 a pesar del error en TAB2");
        guardarDatosTab1();
      }
    } else {
      console.log("? TAB2 no tiene funci�n de guardado o no est� disponible");
      console.log("Guardando solo datos de TAB1");
      guardarDatosTab1();
    }
  }
```

**L�gica implementada:**

1. **Detecci�n de funci�n TAB2:**
   - Busca `window.guardarLineasDesgloseTab2` (expuesta por TAB2)
   - Fallback a `guardarLineasDesglose` si est� en contexto local
   - Logs detallados de depuraci�n

2. **Guardado secuencial con callback:**
   - Llama `fnGuardarTab2(callback)`
   - Callback recibe `exitoTab2` (true/false)
   - Si exitoso ? Espera 300ms ? Guarda TAB1
   - Si fallo ? Aborta y muestra alerta

3. **Timeout de 300ms:**
   - Permite que BD complete transacciones
   - Asegura que `recalcularRsbCompConv()` y `recalcularCstContDesdeDesglose()` terminen
   - Evita condiciones de carrera

4. **Fallback robusto:**
   - Si TAB2 no est� disponible ? Guarda solo TAB1
   - Si hay error en TAB2 ? Intenta guardar TAB1 de todos modos

---

### 3. A�adir Campo CSTCONT a ContratacionVO

**Archivo:** `src/java/es/altia/flexia/integracion/moduloexterno/melanbide11/vo/ContratacionVO.java`

**L�neas:** ~125 y ~527

**Cambios:**

#### A) Declaraci�n de variable (l�nea ~125):

```java
// Nuevos campos MELANBIDE11: Retribuci�n salarial bruta
private Double rsbSalBase; // RSBSALBASE - Salario base
private Double rsbPagExtra; // RSBPAGEXTRA - Pagas extraordinarias
private Double rsbImporte; // RSBIMPORTE - Complementos salariales
private Double rsbCompConv; // RSBCOMPCONV - Retribuci�n salarial bruta computable
private Double cstCont; // CSTCONT - Coste total del contrato ? NUEVO
private String rsbTipo; // RSBTIPO
```

#### B) Getters y setters (l�nea ~527):

```java
public Double getCstCont() {
    return cstCont;
}

public void setCstCont(Double cstCont) {
    this.cstCont = cstCont;
}
```

**Prop�sito:**
- Permitir que `MeLanbide11DAO.getContratacionByExpDni()` devuelva CSTCONT
- Permitir que `MELANBIDE11.guardarLineasDesgloseRSB()` acceda al valor
- Mantener coherencia con otros campos RSB

---

## ?? Flujo de Ejecuci�n Completo

### Secuencia de Eventos

```mermaid
sequenceDiagram
    participant U as Usuario
    participant M1 as Modal TAB1
    participant M2 as Modal TAB2
    participant S as Servidor
    participant DB as Base de Datos
    participant P as Ventana Padre

    U->>M2: Modifica l�nea de desglose
    M2->>M2: Actualiza lineasAllCache[]
    Note over M2: Solo en memoria local

    U->>M1: Clic bot�n "Aceptar"
    M1->>M1: Ejecuta guardarDesglose()
    M1->>M1: Busca window.guardarLineasDesgloseTab2
    
    alt TAB2 disponible
        M1->>M2: Llama guardarLineasDesgloseTab2(callback)
        M2->>S: POST guardarLineasDesgloseRSB
        S->>DB: INSERT/UPDATE/DELETE l�neas desglose
        S->>DB: Ejecuta recalcularRsbCompConv()
        S->>DB: Ejecuta recalcularCstContDesdeDesglose()
        DB-->>S: L�neas guardadas, valores recalculados
        S-->>M2: JSON {codigoOperacion: 0}
        M2->>M2: callback(true)
        M2-->>M1: Guardado exitoso
        
        M1->>M1: setTimeout(guardarDatosTab1, 300ms)
        Note over M1: Espera a que BD termine
        
        M1->>S: POST guardarDesgloseRSB (TAB1)
        S->>DB: UPDATE campos resumen
        S->>DB: SELECT valores actualizados (RSBCOMPCONV, CSTCONT)
        DB-->>S: Valores frescos desde BD
        S-->>M1: JSON {codigoOperacion:0, rsbCompConv:X, cstCont:Y}
        
        M1->>P: Actualiza window.opener rsbTotal field
        M1->>U: jsp_alerta('I', 'Guardado correcto')
        M1->>P: Cierra modal
        P->>U: Muestra valor actualizado ?
    else TAB2 NO disponible
        M1->>S: POST guardarDesgloseRSB (solo TAB1)
        Note over M1: Fallback a comportamiento original
    end
```

---

## ?? Pruebas Recomendadas

### Prueba 1: Modificaci�n Simple

1. **Abrir formulario de contrataci�n**
   - Anotar valor inicial de RSBCOMPCONV (campo `rsbTotal`)
   - Ejemplo: 150.000,00�

2. **Abrir modal desglose ? TAB2**
   - Ver lista de complementos salariales (RSBTIPO='1')

3. **Modificar una l�nea FIJA existente**
   - Seleccionar l�nea con RSBCONCEPTO='F'
   - Cambiar importe de 10.000� a 15.000�
   - Dar "Aceptar" en di�logo

4. **NO cambiar a TAB1**
   - Quedarse en TAB2

5. **Dar "Aceptar" en modal principal**
   - **Verificar consola:**
     ```
     === INICIANDO GUARDADO COMPLETO ===
     ? window.guardarLineasDesgloseTab2 encontrada
     === GUARDANDO PRIMERO L�NEAS DE DESGLOSE (TAB2) ===
     Resultado guardado TAB2: true
     ? TAB2 guardado exitosamente, continuando con TAB1
     === GUARDANDO DATOS TAB1 (Resumen) ===
     Valores actualizados desde BD:
       - RSBCOMPCONV: 155000
       - CSTCONT: 755000
     Campo rsbTotal actualizado en ventana padre: 155.000,00
     ```
   
6. **Verificar resultado:**
   - Campo `rsbTotal` debe mostrar: **155.000,00�**
   - Incremento de 5.000� (diferencia entre 10k y 15k)
   - **SIN recargar la p�gina**

---

### Prueba 2: A�adir Nueva L�nea

1. **TAB2 ? Clic "Nuevo" en Complementos Salariales**

2. **Rellenar formulario:**
   - Importe: 8.500�
   - Concepto: **Fijo** (F)
   - Observaciones: "Complemento de responsabilidad"

3. **Aceptar di�logo ? Aceptar modal**

4. **Verificar:**
   - RSBCOMPCONV debe incrementarse en 8.500�
   - Consola debe mostrar guardado secuencial TAB2 ? TAB1
   - Campo actualizado en ventana padre

---

### Prueba 3: Eliminar L�nea

1. **TAB2 ? Seleccionar l�nea FIJA ? Clic "Eliminar"**

2. **Confirmar eliminaci�n**

3. **Aceptar modal**

4. **Verificar:**
   - RSBCOMPCONV debe decrementarse
   - Campo actualizado inmediatamente

---

### Prueba 4: Modificar L�nea VARIABLE (no debe afectar RSBCOMPCONV)

1. **TAB2 ? Modificar l�nea con RSBCONCEPTO='V'**
   - Cambiar importe de 3.000� a 10.000�

2. **Aceptar modal**

3. **Verificar:**
   - RSBCOMPCONV **NO cambia** (correcto, solo FIJOS)
   - CSTCONT **S� cambia** (incluye variables)
   - Consola muestra guardado correcto

---

### Prueba 5: Sin Cambios en TAB2

1. **Abrir modal ? NO modificar nada en TAB2**

2. **Cambiar solo TAB1:**
   - Modificar "Salario base"
   - De 100.000� a 105.000�

3. **Aceptar modal**

4. **Verificar:**
   - Guardado normal de TAB1
   - RSBCOMPCONV actualizado con nuevo base
   - Consola debe mostrar:
     ```
     ? TAB2 no tiene funci�n de guardado o no est� disponible
     Guardando solo datos de TAB1
     ```

---

## ?? Depuraci�n con Consola

### Logs Esperados (Caso Exitoso)

```javascript
=== INICIANDO GUARDADO COMPLETO ===
? window.guardarLineasDesgloseTab2 encontrada

=== TAB2 FUNCIONES EXPUESTAS ===
window.refrescarDesgloseRSB: function
window.guardarLineasDesgloseTab2: function

=== GUARDANDO PRIMERO L�NEAS DE DESGLOSE (TAB2) ===
[XHR POST] /Flexia18/PeticionModuloIntegracion.do?...&operacion=guardarLineasDesgloseRSB
Resultado guardado TAB2: true
? TAB2 guardado exitosamente, continuando con TAB1

=== GUARDANDO DATOS TAB1 (Resumen) ===
[XHR POST] /Flexia18/PeticionModuloIntegracion.do?...&operacion=guardarDesgloseRSB

Respuesta recibida: {resultado: {codigoOperacion: 0, rsbCompConv: 154300, cstCont: 754653}}
Valores actualizados desde BD:
  - RSBCOMPCONV: 154300
  - CSTCONT: 754653
Campo rsbTotal actualizado en ventana padre: 154.300,00

Desglose RSB guardado exitosamente
```

### Logs de Error (TAB2 No Disponible)

```javascript
=== INICIANDO GUARDADO COMPLETO ===
No se pudo acceder a funci�n de guardado de TAB2: ReferenceError
? TAB2 no tiene funci�n de guardado o no est� disponible
Guardando solo datos de TAB1
```

### Logs de Error (Fallo en TAB2)

```javascript
=== GUARDANDO PRIMERO L�NEAS DE DESGLOSE (TAB2) ===
Resultado guardado TAB2: false
? Error guardando TAB2, abortando
[Alerta] Error al guardar las l�neas de desglose. No se continuar� con el guardado.
```

---

## ?? Notas T�cnicas

### Timeout de 300ms

**Raz�n:**
- Permite que la transacci�n de BD complete
- Asegura que `recalcularRsbCompConv()` termine
- Asegura que `recalcularCstContDesdeDesglose()` termine
- Evita consultar valores mientras se est�n actualizando

**Alternativa:** Usar `Connection.commit()` + respuesta confirmada desde servidor

### Callback Pattern

**Ventajas:**
- Garantiza orden de ejecuci�n: TAB2 ? TAB1
- Permite abortar si TAB2 falla
- No bloquea UI durante guardado
- Compatible con AJAX as�ncrono

**Desventajas:**
- Callback hell si se a�aden m�s pasos
- Dif�cil de seguir en c�digo complejo

**Mejora futura:** Migrar a Promises/async-await cuando Flexia lo soporte

### Exposici�n Global de Funciones

**Patr�n usado:**
```javascript
// Dentro de IIFE
function guardarLineasDesglose(callback) { ... }

// Al final del IIFE
window.guardarLineasDesgloseTab2 = guardarLineasDesglose;
```

**Ventajas:**
- Mantiene encapsulaci�n del IIFE
- API p�blica controlada
- Namespace expl�cito (`...Tab2`)

**Alternativa:** Event Bus o Custom Events (m�s moderno pero requiere librer�a)

---

## ? Estado del Despliegue

- [x] TAB2: Funci�n `guardarLineasDesgloseTab2` expuesta globalmente
- [x] TAB1: Funci�n `guardarDesglose()` modificada con guardado secuencial
- [x] ContratacionVO: Campo `cstCont` a�adido con getters/setters
- [x] C�digo compilado exitosamente (20 archivos Java)
- [x] JSP desplegados (120 archivos)
- [x] Tomcat reiniciado (PIDs: 8224, 10112)
- [x] Sistema operativo y listo para pruebas

---

## ?? Pr�ximos Pasos

### Inmediato: Pruebas de Usuario

1. Seguir las **5 pruebas recomendadas** arriba
2. Verificar logs en consola del navegador
3. Confirmar que valores se actualizan sin recargar
4. Verificar c�lculos con script SQL `VERIFICAR_CALCULO_RSB_CSTCONT.sql`

### Opcional: Mejoras Futuras

1. **Migrar a Promises:**
   ```javascript
   function guardarDesglose() {
       guardarTab2()
           .then(() => guardarTab1())
           .then(() => actualizarVentanaPadre())
           .catch(err => mostrarError(err));
   }
   ```

2. **Indicador de progreso m�s detallado:**
   - "Guardando l�neas de desglose... (1/2)"
   - "Guardando resumen... (2/2)"
   - "Actualizando valores..."

3. **Validaci�n cruzada TAB1-TAB2:**
   - Verificar que totales en TAB1 coincidan con suma de TAB2
   - Alertar si hay discrepancias antes de guardar

4. **Manejo de concurrencia:**
   - Detectar si otro usuario modific� el registro
   - Implementar versioning optimista

---

**Fecha de implementaci�n:** 29 de octubre de 2025  
**Estado:** ? COMPLETADO Y DESPLEGADO  
**Versi�n:** 1.0
