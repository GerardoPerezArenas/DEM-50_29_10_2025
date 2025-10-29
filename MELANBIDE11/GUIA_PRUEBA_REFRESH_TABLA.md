# ? Guía de Prueba: Actualización Automática de Tabla de Contrataciones

## ?? Objetivo
Verificar que la tabla principal de contrataciones en `melanbide11.jsp` se actualiza automáticamente después de cerrar el modal de "Desglose RSB" con cambios guardados.

---

## ?? Cambios Implementados

### 1. **melanbide11.jsp** - Funciones de Actualización Agregadas
Se han agregado dos nuevas funciones globales accesibles desde ventanas modales:

#### `refrescarDatosContratacion()` - Función Principal
```javascript
function refrescarDatosContratacion() {
    console.log("Refrescando tabla de contrataciones...");
    window.location.reload();
}
```
- **Qué hace**: Recarga toda la página para obtener datos frescos del servidor
- **Por qué**: Garantiza sincronización completa sin problemas de AJAX
- **Cuándo se llama**: Desde `m11Desglose_Tab1.jsp` a los 300ms después de guardar

#### `recargarTabla()` - Función Alternativa
```javascript
function recargarTabla() {
    if (typeof cargarDatosContratacion === 'function') {
        cargarDatosContratacion();
    } else {
        refrescarDatosContratacion();
    }
}
```
- **Qué hace**: Intenta recargar solo la tabla (si existe la función), sino recarga la página
- **Fallback**: Si no encuentra función de recarga parcial, usa `refrescarDatosContratacion()`

---

## ?? Pasos de Prueba Detallados

### Escenario 1: Modificar Complementos Salariales

1. **Acceder al sistema**
   ```
   URL: http://localhost:8080/Flexia18/PeticionModuloIntegracion.do?
        tarea=preparar&
        modulo=MELANBIDE11&
        operacion=cargarPantallaPrincipal&
        tipo=0&
        numExpediente=TEST001
   ```

2. **Ubicar una contratación existente**
   - En la tabla principal, observar el campo **"RSB Total"** (columna RSBCOMPCONV)
   - Anotar el valor actual, por ejemplo: `25.500,00 €`

3. **Abrir modal "Desglose RSB"**
   - Seleccionar una fila haciendo clic sobre ella
   - Hacer clic en el botón **"Desglose RSB"**
   - Se abrirá ventana modal con dos pestañas: TAB1 (Resumen) y TAB2 (Líneas de Desglose)

4. **Modificar complementos en TAB2**
   - Ir a pestaña **"Líneas de Desglose (TAB2)"**
   - Agregar o modificar una línea de complemento salarial:
     * Tipo RSB: **Complementos salariales**
     * Concepto: **FIJO**
     * Importe: **500,00**
     * Observaciones: **Prueba actualización tabla**
   - Hacer clic en **"Añadir línea"**

5. **Guardar y cerrar modal**
   - Hacer clic en botón **"Aceptar"** en TAB1
   - Observar en la consola del navegador (F12):
     ```
     [TAB1] Iniciando guardado secuencial...
     [TAB1] Llamando a guardarLineasDesgloseTab2...
     [TAB2] Líneas del desglose guardadas correctamente
     [TAB1] TAB2 guardado, procediendo a guardar TAB1...
     [TAB1] Actualizando campos en TAB1 desde respuesta del servidor
     Refrescando tabla de contrataciones...  ? NUEVA LÍNEA
     ```

6. **Verificar actualización de la tabla**
   - ? **ESPERADO**: La página se recarga automáticamente
   - ? **VERIFICAR**: El campo "RSB Total" muestra el nuevo valor calculado
   - ? **EJEMPLO**: Si antes era `25.500,00 €`, ahora debería mostrar `26.000,00 €`

---

### Escenario 2: Modificar Extrasalariales

1. **Seguir pasos 1-3 del Escenario 1**

2. **Modificar extrasalariales en TAB2**
   - Ir a pestaña **"Líneas de Desglose (TAB2)"**
   - Agregar línea de extrasalarial:
     * Tipo RSB: **Extrasalariales**
     * Concepto: **VARIABLE**
     * Importe: **300,00**
     * Observaciones: **Prueba extrasalarial**
   - Hacer clic en **"Añadir línea"**

3. **Guardar y verificar**
   - Hacer clic en **"Aceptar"**
   - Observar recarga automática de la página
   - Verificar que el campo "RSB Total" refleja el cambio

---

### Escenario 3: Eliminar Líneas de Desglose

1. **Abrir modal con contratación que tenga líneas de desglose**

2. **Eliminar líneas en TAB2**
   - Ir a TAB2
   - Seleccionar una línea existente
   - Hacer clic en **"Eliminar línea seleccionada"**

3. **Guardar y verificar**
   - Hacer clic en **"Aceptar"**
   - Verificar recarga automática
   - Confirmar que "RSB Total" disminuyó según la línea eliminada

---

## ?? Puntos de Verificación

### Consola del Navegador (F12 ? Console)

Debe mostrar el flujo completo:
```
1. [TAB1] Iniciando guardado secuencial...
2. [TAB1] Llamando a guardarLineasDesgloseTab2...
3. [TAB2] Líneas del desglose guardadas correctamente
4. [TAB1] TAB2 guardado, procediendo a guardar TAB1...
5. [TAB1] Datos TAB1 guardados correctamente
6. [TAB1] Actualizando campos en TAB1 desde respuesta del servidor
7. [TAB1] Campo actualizado: rsbSalBase = 25000.0
8. [TAB1] Campo actualizado: rsbPagExtra = 1500.0
9. [TAB1] Campo actualizado: rsbCompConv = 26500.0  ? Valor nuevo
10. [TAB1] Campo actualizado: cstCont = 27000.0
11. [TAB1] Invocando refrescarDesgloseRSB en 200ms
12. [TAB1] Intentando refrescar datos en ventana padre a 300ms
13. Refrescando tabla de contrataciones...          ? LLAMADA AL PADRE
14. [TAB1] Cerrando ventana modal en 600ms
```

### Red (F12 ? Network)

Al guardar debe mostrar:
1. **POST** `PeticionModuloIntegracion.do?operacion=guardarDesgloseRSB` 
   - Estado: `200 OK`
   - Respuesta JSON: `{"codigoOperacion":"0","mensaje":"...","rsbSalBase":25000.0,...}`

2. **Recarga de página** (después del modal)
   - GET `PeticionModuloIntegracion.do?operacion=cargarPantallaPrincipal`
   - Estado: `200 OK`
   - HTML completo con tabla actualizada

### Base de Datos

Verificar valores en Oracle:
```sql
-- Ver contratación actualizada
SELECT ID, DNICONT, RSBSALBASE, RSBPAGEXTRA, RSBCOMPCONV, CSTCONT
FROM MELANBIDE11_CONTRATACION
WHERE NUM_EXP = 'TEST001';

-- Ver líneas de desglose
SELECT ID, DNICONTRSB, RSBTIPO, RSBIMPORTE, RSBCONCEPTO, RSBOBSERV
FROM MELANBIDE11_DESGRSB
WHERE NUM_EXP = 'TEST001'
ORDER BY ID DESC;
```

---

## ? Problemas Conocidos y Soluciones

### Problema 1: Tabla No Se Actualiza

**Síntoma**: El modal se cierra pero la tabla muestra valores antiguos

**Diagnóstico**:
1. Abrir consola del navegador (F12)
2. Buscar mensaje: `"Refrescando tabla de contrataciones..."`

**Si NO aparece el mensaje**:
- Verificar que `m11Desglose_Tab1.jsp` esté desplegado correctamente
- Verificar línea 372-380 del JSP (llamadas a window.opener)

**Si SÍ aparece el mensaje pero no recarga**:
- Verificar que `melanbide11.jsp` tenga las funciones `refrescarDatosContratacion()` y `recargarTabla()`
- Limpiar caché del navegador (Ctrl+F5)
- Reiniciar Tomcat

### Problema 2: Error "Cannot read property 'refrescarDatosContratacion'"

**Causa**: La ventana padre (melanbide11.jsp) no tiene la función definida

**Solución**:
```bash
# Verificar despliegue del JSP actualizado
dir "C:\apache-tomcat-7.0.104-64Bit\webapps\Flexia18\jsp\extension\melanbide11\melanbide11.jsp"

# Buscar la función en el archivo desplegado
findstr /C:"refrescarDatosContratacion" "C:\apache-tomcat-7.0.104-64Bit\webapps\Flexia18\jsp\extension\melanbide11\melanbide11.jsp"

# Si no aparece, recompilar y redesplegar
cd C:\Users\gerardo.perez\Desktop\866124_DEM50-\MELANBIDE11
ant -f build-parche.xml desplegar

# Reiniciar Tomcat
taskkill /F /IM java.exe
timeout /t 3 /nobreak
C:\apache-tomcat-7.0.104-64Bit\bin\startup.bat
```

### Problema 3: Página Se Recarga Pero Valores No Cambian

**Causa**: Error en el guardado de datos en TAB1 o TAB2

**Diagnóstico**:
1. Verificar respuesta JSON del servidor en Network tab
2. Buscar `"codigoOperacion":"0"` (éxito) o `"codigoOperacion":"1"` (error)
3. Si codigoOperacion != 0, revisar logs de Tomcat:
   ```bash
   type C:\apache-tomcat-7.0.104-64Bit\logs\catalina.2025-*.log | findstr /I "MELANBIDE11"
   ```

**Solución**:
- Si error de validación: verificar que todos los campos tengan valores válidos
- Si error de BD: revisar permisos y conexión a Oracle

---

## ?? Comparación Antes vs Después

### ANTES (Comportamiento Problemático)
```
1. Usuario modifica TAB2 ? Guarda
2. Modal se cierra
3. Usuario ve tabla con valores antiguos
4. Usuario debe presionar F5 manualmente
5. Tabla se actualiza
```

### DESPUÉS (Comportamiento Correcto)
```
1. Usuario modifica TAB2 ? Guarda
2. TAB2 guarda ? TAB1 guarda ? Respuesta del servidor
3. Campos en modal se actualizan con valores frescos
4. Modal se cierra después de 600ms
5. Función refrescarDatosContratacion() se llama automáticamente
6. Página se recarga mostrando tabla actualizada
7. Usuario ve valores nuevos sin intervención manual ?
```

---

## ?? Flujo Temporal Detallado

```
T=0ms    : Usuario hace clic en "Aceptar" (TAB1)
T=0ms    : guardarDesglose() inicia guardado secuencial
T=10ms   : Llamada a window.guardarLineasDesgloseTab2()
T=50ms   : TAB2 responde con éxito
T=60ms   : TAB1 inicia guardado propio
T=150ms  : Servidor responde JSON con datos actualizados
T=160ms  : procesarRespuestaGuardar() actualiza campos en TAB1
T=200ms  : refrescarDesgloseRSB() actualiza vista del modal
T=300ms  : window.opener.refrescarDatosContratacion() llamada
T=310ms  : Página padre inicia reload (window.location.reload())
T=600ms  : Modal se cierra (cerrarVentanaModal)
T=800ms  : Página completamente recargada con datos frescos
```

---

## ? Criterios de Aceptación

La funcionalidad se considera exitosa si:

1. ? **Guardado secuencial funciona**: TAB2 guarda primero, luego TAB1
2. ? **Campos en modal se actualizan**: Valores en TAB1 reflejan cálculos nuevos del servidor
3. ? **Tabla principal se refresca**: Después de cerrar el modal, la tabla muestra valores actualizados
4. ? **Sin intervención manual**: Usuario NO necesita presionar F5
5. ? **Sin errores en consola**: No hay mensajes de error en la consola del navegador
6. ? **Compatible Java 6/IE8**: Funciona en navegadores legacy
7. ? **Base de datos actualizada**: Valores en Oracle coinciden con los mostrados en la tabla

---

## ?? Notas Adicionales

### Consideraciones de Rendimiento
- La recarga completa de página (`window.location.reload()`) es la opción más simple y confiable
- Alternativa futura: implementar recarga AJAX solo de la tabla (requiere nueva operación backend)

### Compatibilidad
- ? Internet Explorer 8+ (window.opener, window.location.reload)
- ? Firefox 52+ (versión ESR legacy)
- ? Chrome 49+ (última versión para Windows XP)

### Logs de Auditoría
Todas las operaciones quedan registradas en:
```
C:\apache-tomcat-7.0.104-64Bit\logs\catalina.YYYY-MM-DD.log
```

Buscar por:
```
[guardarDesgloseRSB]
[eliminarContratacion]
[MeLanbide11Manager]
```

---

## ?? Resumen Ejecutivo

**Problema resuelto**: Tabla de contrataciones no se actualizaba después de modificar el desglose RSB

**Solución implementada**: 
1. Función `refrescarDatosContratacion()` en `melanbide11.jsp`
2. Llamada automática desde `m11Desglose_Tab1.jsp` a los 300ms después de guardar
3. Recarga completa de página para garantizar sincronización

**Archivos modificados**:
- `src/web/jsp/extension/melanbide11/melanbide11.jsp` (funciones de refresh)
- (Sin cambios en m11Desglose_Tab1.jsp - ya tenía las llamadas)

**Estado**: ? Desplegado y listo para pruebas

**Fecha de implementación**: 2025-02-25
