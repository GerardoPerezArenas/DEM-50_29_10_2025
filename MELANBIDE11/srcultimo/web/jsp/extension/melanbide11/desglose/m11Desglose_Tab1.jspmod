<%@taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>
<%@page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@page import="es.altia.common.service.config.Config"%>
<%@page import="es.altia.common.service.config.ConfigServiceHelper"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Fragmento simplificado: se elimina estructura html/head/body para inline dentro de contenedor --%>
<div style="padding:6px 8px 4px 8px;">
    <%
      UsuarioValueObject usuarioVO = new UsuarioValueObject();
      int idiomaUsuario = 1;
      int apl = 5;
      String css = "";
      if (session.getAttribute("usuario") != null){
          usuarioVO = (UsuarioValueObject) session.getAttribute("usuario");
          apl = usuarioVO.getAppCod();
          idiomaUsuario = usuarioVO.getIdioma();
          css = usuarioVO.getCss();
      }

  MeLanbide11I18n meLanbide11I18n = MeLanbide11I18n.getInstance();
      String numExpediente = (String)request.getAttribute("numExp");

      // Parámetros opcionales (modo alta/modificación)
      String nuevo       = request.getAttribute("nuevo") != null ? (String)request.getAttribute("nuevo") : "1";
      String idRegistro  = request.getAttribute("id")    != null ? (String)request.getAttribute("id")    : "";

      // Valores iniciales opcionales (si vienes a modificar)
      String vSalBase  = request.getAttribute("salarioBase") != null ? ((String)request.getAttribute("salarioBase")).replace(".", ",") : "";
      String vPagas    = request.getAttribute("pagasExtra")  != null ? ((String)request.getAttribute("pagasExtra")).replace(".", ",")  : "";
  String vCompImp  = request.getAttribute("compImporte") != null ? ((String)request.getAttribute("compImporte")).replace(".", ",") : "";
  String vCompTipo = request.getAttribute("compTipo")    != null ? (String)request.getAttribute("compTipo") : "";
  String vCompExtra = request.getAttribute("compExtra")  != null ? ((String)request.getAttribute("compExtra")).replace(".", ",") : ""; // nuevo: valor complementos extrasalariales
    %>
    <jsp:useBean id="descriptor" scope="request" class="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean"  type="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean" />
    <jsp:setProperty name="descriptor"  property="idi_cod" value="<%=idiomaUsuario%>" />
    <jsp:setProperty name="descriptor"  property="apl_cod" value="<%=apl%>" />

    <%-- Cabecera visual se muestra ahora en el contenedor principal --%>

  <%-- Dependencias ya deberían estar cargadas por el contenedor. Si no, reintroducir enlaces arriba. --%>

    <script type="text/javascript">
      var APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
      var url = APP_CONTEXT_PATH + '/PeticionModuloIntegracion.do';
      var mensajeValidacion = '';

      // Fallback: si la función global elementoVisible (definida en JavaScriptUtil.js) no está cargada
      if (typeof elementoVisible === 'undefined') {
        function elementoVisible(accion, idBarra){
          try {
            var el = document.getElementById(idBarra);
            if(!el) return;
            if(accion=='on' || accion=='mostrar') el.style.display=''; 
            else if(accion=='off' || accion=='ocultar') el.style.display='none';
          } catch(e) {}
        }
      }

      // Fallback para jsp_alerta si no está disponible
      if (typeof jsp_alerta === 'undefined') {
        function jsp_alerta(tipo, mensaje) {
          if (tipo === '') {
            return confirm(mensaje) ? 1 : 0;
          } else {
            alert(mensaje);
          }
        }
      }

      // Fallback para mostrarErrorPeticion si no está disponible
      if (typeof mostrarErrorPeticion === 'undefined') {
        function mostrarErrorPeticion(codigo) {
          console.error("Error en petición AJAX, código:", codigo);
          alert("Error en la comunicación con el servidor");
        }
      }

      // Función reemplazarPuntos requerida por los campos numéricos
      function reemplazarPuntos(campo) {
        try {
          var valor = campo.value;
          if (valor != null && valor != '') {
            valor = valor.replace(/\./g, ',');
            campo.value = valor;
          }
        } catch (err) {
          console.warn('Error en reemplazarPuntos:', err);
        }
      }

      // Función validarNumeroReal requerida por los campos numéricos
      function validarNumeroReal(campo) {
        try {
          if (!campo || !campo.value || campo.value.trim() === '') {
            return true; // Los campos vacíos se permiten
          }
          
          var valor = campo.value.replace(',', '.'); // Convertir formato español a decimal
          var numero = parseFloat(valor);
          
          if (isNaN(numero) || !isFinite(numero)) {
            return false;
          }
          
          // Validar que sea positivo para campos monetarios
          if (numero < 0) {
            return false;
          }
          
          return true;
        } catch (e) {
          console.warn('Error validando campo numérico:', e);
          return false;
        }
      }

      function validarDesglose(){
        mensajeValidacion='';
        var sal=document.getElementById('rsbSalBase');
        if(sal.value && !validarNumeroReal(sal)){
            mensajeValidacion='Salario base: formato inválido.';
            return false;
        }
        
        var pag=document.getElementById('rsbPagasExtra');
        if(pag.value && !validarNumeroReal(pag)){
            mensajeValidacion='Pagas extraordinarias: formato inválido.';
            return false;
        }
        
        var imp=document.getElementById('rsbCompImporte');
        if(imp.value && !validarNumeroReal(imp)){
            mensajeValidacion='Complementos salariales: formato inválido.';
            return false;
        }
        
        var impExtra=document.getElementById('rsbCompExtra');
        if(impExtra.value && !validarNumeroReal(impExtra)){
            mensajeValidacion='Complementos extrasalariales: formato inválido.';
            return false;
        }
        return true;
      }

      function guardarDesglose(){
        if(!validarDesglose()){
          jsp_alerta('A', mensajeValidacion);
          return;
        }
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
          elementoVisible('off', 'barraProgresoLPEEL');
          mostrarErrorPeticion();
        }
      }

      function procesarRespuestaGuardar(ajaxResult){
        elementoVisible('off', 'barraProgresoLPEEL');
        try{
          var datos = JSON.parse(ajaxResult);
          // Nuevo JSON: {resultado:{codigoOperacion:"0", salariales: n, extrasalariales: m}}
          var codigoOperacion = datos && datos.resultado ? datos.resultado.codigoOperacion : "4";
          if (codigoOperacion == "0"){
            console.log("Desglose RSB guardado exitosamente - cerrando modal");
            // Actualizar (si existiera) resumen de totales en UI
            jsp_alerta('I', 'Guardado correcto');
            // Pasar resultado al padre antes de cerrar
            try {
              if (window.opener && window.opener.modalCallback) {
                window.opener.modalCallback(['0', 'Desglose RSB guardado exitosamente']);
              } else if (window.parent && window.parent.modalCallback) {
                window.parent.modalCallback(['0', 'Desglose RSB guardado exitosamente']);
              }
            } catch(e) {
              console.warn("No se pudo pasar resultado al padre:", e);
            }
            // Cerrar modal después de guardar exitosamente
            setTimeout(function() {
              cerrarVentana(['0', 'Desglose RSB guardado exitosamente']);
            }, 1500); // Delay de 1.5 segundos para que el usuario vea el mensaje
          } else if (codigoOperacion == "1") {
            jsp_alerta('A', document.getElementById('errorBD').value);
          } else if (codigoOperacion == "3") {
            jsp_alerta('A', 'Parámetros insuficientes');
          } else {
            jsp_alerta('A', document.getElementById('generico').value);
          }
        }catch(e){
          jsp_alerta('A', document.getElementById('generico').value);
        }
      }

      function mostrarErrorGuardar(){
        elementoVisible('off', 'barraProgresoLPEEL');
        mostrarErrorPeticion(7);
      }

      window.guardarDesglose = function(){
        console.log("=== EJECUTANDO GUARDAR DESGLOSE ===");
        if(!validarDesglose()){
          console.log("Validación falló:", mensajeValidacion);
          jsp_alerta('A', mensajeValidacion);
          return;
        }
        elementoVisible('on', 'barraProgresoLPEEL');

        var rsbSalBase = document.getElementById('rsbSalBase').value;
        var rsbPagasExtra = document.getElementById('rsbPagasExtra').value;
        var rsbCompImporte = document.getElementById('rsbCompImporte').value;
        var rsbCompExtra = document.getElementById('rsbCompExtra').value;

        console.log("Valores a guardar:", {rsbSalBase, rsbPagasExtra, rsbCompImporte, rsbCompExtra});

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
          console.error("Error en AJAX:", err);
          elementoVisible('off', 'barraProgresoLPEEL');
          mostrarErrorPeticion();
        }
      }

      window.cancelar = function(){
        console.log("=== EJECUTANDO CANCELAR DESGLOSE ===");
        try{
          if (window.skipCancelConfirm) { // llamado desde volverDesglose(): no duplicar confirmación
            cerrarVentana();
            return;
          }
        }catch(e){}
        var r = jsp_alerta('', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.preguntaCancelar")%>');
        if(r == 1){ cerrarVentana(); } // Sin resultado al cancelar
      }

      // Verificar que las funciones se han registrado correctamente
      console.log("=== FUNCIONES REGISTRADAS EN TAB1 ===");
      console.log("window.guardarDesglose:", typeof window.guardarDesglose);
      console.log("window.cancelar:", typeof window.cancelar);

      // Función de eliminación específica para Tab1
      window.m11_eliminarTab1 = function() {
        console.log("=== ELIMINANDO DESDE TAB1 ===");
        
        var idRegistro = document.getElementById('idRegistroContratacion');
        if (!idRegistro || !idRegistro.value || idRegistro.value.trim() === '') {
          if (typeof jsp_alerta === 'function') {
            jsp_alerta('A', 'No hay registro seleccionado para eliminar.');
          } else {
            alert('No hay registro seleccionado para eliminar.');
          }
          return false;
        }
        
        var id = idRegistro.value.trim();
        console.log("Eliminando registro con ID:", id);
        
        // Mostrar progreso
        elementoVisible('on', 'barraProgresoLPEEL');
        
        var parametros = "tarea=preparar&modulo=MELANBIDE11&operacion=eliminarContratacionAJAX&tipo=0"
          + "&id=" + encodeURIComponent(id)
          + "&numExp=" + encodeURIComponent('<%=numExpediente%>');
        
        try {
          $.ajax({
            url: url,
            type: 'POST',
            async: true,
            data: parametros,
            success: function(ajaxResult) {
              elementoVisible('off', 'barraProgresoLPEEL');
              try {
                var datos = JSON.parse(ajaxResult);
                var codigoOperacion = datos && datos.resultado ? datos.resultado.codigoOperacion : "4";
                
                if (codigoOperacion == "0") {
                  console.log("Registro eliminado exitosamente");
                  jsp_alerta('I', 'Registro eliminado correctamente');
                  
                  // Limpiar formulario
                  limpiarFormularioTab1();
                  
                  // Deshabilitar botón eliminar
                  if (typeof window.habilitarBotonEliminar === 'function') {
                    window.habilitarBotonEliminar(false);
                  }
                  
                  // Recargar lista si existe
                  if (typeof window.m11_cargarContrataciones === 'function') {
                    setTimeout(window.m11_cargarContrataciones, 500);
                  }
                  
                } else {
                  var mensaje = datos && datos.resultado && datos.resultado.mensajeOperacion 
                    ? datos.resultado.mensajeOperacion 
                    : "Error al eliminar el registro";
                  jsp_alerta('A', mensaje);
                }
              } catch(e) {
                console.error("Error procesando respuesta de eliminación:", e);
                jsp_alerta('A', 'Error al procesar la respuesta del servidor');
              }
            },
            error: function(xhr, status, error) {
              elementoVisible('off', 'barraProgresoLPEEL');
              console.error("Error en AJAX de eliminación:", error);
              jsp_alerta('A', 'Error de comunicación con el servidor');
            }
          });
        } catch(err) {
          console.error("Error en eliminación:", err);
          elementoVisible('off', 'barraProgresoLPEEL');
          jsp_alerta('A', 'Error al eliminar el registro');
        }
        
        return true;
      };
      
      // Función para limpiar el formulario Tab1
      function limpiarFormularioTab1() {
        try {
          document.getElementById('idRegistroContratacion').value = '';
          document.getElementById('rsbSalBase').value = '';
          document.getElementById('rsbPagasExtra').value = '';
          document.getElementById('rsbCompImporte').value = '';
          document.getElementById('rsbCompExtra').value = '';
        } catch(e) {
          console.warn("Error limpiando formulario Tab1:", e);
        }
      }
      
      // Función para detectar cambios y habilitar/deshabilitar botón eliminar
      function verificarRegistroSeleccionado() {
        var idRegistro = document.getElementById('idRegistroContratacion');
        var hayRegistro = idRegistro && idRegistro.value && idRegistro.value.trim() !== '';
        
        if (typeof window.habilitarBotonEliminar === 'function') {
          window.habilitarBotonEliminar(hayRegistro);
        }
        
        return hayRegistro;
      }
      
      // Añadir listeners para detectar cambios en el ID del registro
      try {
        var idInput = document.getElementById('idRegistroContratacion');
        if (idInput) {
          idInput.addEventListener('change', verificarRegistroSeleccionado);
          idInput.addEventListener('input', verificarRegistroSeleccionado);
        }
      } catch(e) {
        console.warn("Error añadiendo listeners:", e);
      }
      
      // Verificar estado inicial
      setTimeout(verificarRegistroSeleccionado, 100);

      // Función para cerrar ventana del modal de desglose RSB
      function cerrarVentana(resultado) {
        console.log("=== CERRANDO MODAL DESGLOSE RSB ===");
        console.log("Resultado a pasar:", resultado);
        try {
          var ventanaCerrada = false;
          
          // Pasar resultado antes de cerrar si se proporciona
          if (resultado) {
            try {
              if (window.opener && typeof window.opener === 'object') {
                console.log("Pasando resultado al opener");
                window.returnValue = resultado;
                if (window.opener.modalCallback) {
                  window.opener.modalCallback(resultado);
                }
              } else if (window.parent && window.parent !== window.self) {
                console.log("Pasando resultado al parent");
                window.returnValue = resultado;
                if (window.parent.modalCallback) {
                  window.parent.modalCallback(resultado);
                }
              }
            } catch(e) {
              console.warn("Error pasando resultado:", e);
            }
          }
          
          // Método 1: Ventana modal o popup tradicional
          if (window.opener && !window.parent.opener) {
            console.log("Método 1: Ventana popup - cerrando con window.close()");
            window.close();
            ventanaCerrada = true;
          }
          
          // Método 2: Ventana dentro de un iframe o frame
          else if (window.parent && window.parent !== window.self) {
            console.log("Método 2: Ventana en frame/iframe");
            
            // Intentar cerrar desde el parent
            if (window.parent.window && typeof window.parent.window.close === 'function') {
              console.log("Cerrando desde window.parent.window.close()");
              window.parent.window.close();
              ventanaCerrada = true;
            }
            // Fallback: cerrar ventana actual
            else {
              console.log("Fallback frame: cerrando ventana actual");
              window.close();
              ventanaCerrada = true;
            }
          }
          
          // Método 3: Fallback general para navegadores modernos
          if (!ventanaCerrada) {
            console.log("Método 3: Fallback general");
            if (window.close) {
              window.close();
              ventanaCerrada = true;
            }
          }
          
          // Método 4: Si aún no se ha cerrado, intentar redirección
          if (!ventanaCerrada) {
            console.log("Método 4: Último recurso - recargar página padre");
            if (window.parent && window.parent.location && window.parent.location.reload) {
              setTimeout(function() {
                window.parent.location.reload();
              }, 100);
            } else if (window.opener && window.opener.location && window.opener.location.reload) {
              setTimeout(function() {
                window.opener.location.reload();
                window.close();
              }, 100);
            }
          }
          
          console.log("=== MODAL DESGLOSE RSB CERRADO ===");
          
        } catch(e) {
          console.error("Error cerrando modal desglose RSB:", e);
          // Fallback final
          try {
            window.close();
          } catch(e2) {
            console.error("Error en fallback:", e2);
          }
        }
      }

      /*
      ================================================
      CÓDIGO CRUD CONTRATACIONES COMENTADO - NO SE USA
      (Sección "Listado de contrataciones existentes" removida)
      ================================================
      // =====================
      // CRUD CONTRATACIONES (PESTAÑA 1 - DESGLOSE RSB)
      // =====================
      (function(){
          if(window.m11_contratacionesInicializado){return;} // evitar doble init si JSP se incluye 2 veces
          window.m11_contratacionesInicializado = true;

          function qs(id){return document.getElementById(id);}  
          function msg(t){var d=qs('crudContMensaje'); if(d){d.textContent=t||'';} }
          function habilitarEliminar(si){var b=qs('btnEliminarCont'); if(b){b.disabled=!si;}}

          window.m11_cargarContrataciones = function(){
              msg('Cargando...');
              habilitarEliminar(false);
              var numExp = '<%=numExpediente%>';
              console.log('Cargando contrataciones para expediente:', numExp);
              
              if(!numExp || numExp === 'null' || numExp === '') {
                  msg('Error: Número de expediente no disponible');
                  renderTabla([]);
                  return;
              }
              
              var url = APP_CONTEXT_PATH + '/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=listarContratacionesAJAX&tipo=0&numExp='+ encodeURIComponent(numExp) + '&id=0';
              console.log('URL de petición:', url);
              
              fetch(url, {cache:'no-cache'})
                  .then(r=>{
                      console.log('Respuesta HTTP:', r.status, r.statusText);
                      if(!r.ok) {
                          return r.text().then(errorText => {
                              console.error('Error en respuesta:', errorText);
                              throw new Error('HTTP ' + r.status + ': ' + r.statusText);
                          });
                      }
                      return r.json();
                  })
                  .then(json=>{
                      console.log('Respuesta JSON recibida:', json);
                      if(!json) {
                          msg('Error: Respuesta vacía del servidor');
                          renderTabla([]);
                          return;
                      }
                      if(json.error) {
                          msg('Error del servidor: ' + json.error);
                          renderTabla([]);
                          return;
                      }
                      if(!json.contrataciones){
                          console.log('Sin contrataciones en la respuesta');
                          msg('Sin datos'); 
                          renderTabla([]); 
                          return;
                      }
                      window.m11_cacheContrataciones = json.contrataciones; // cachear para selección
                      renderTabla(json.contrataciones);
                      msg(json.contrataciones.length + ' registro(s).');
                  })
                  .catch(err=>{
                      console.error('Error completo en listarContratacionesAJAX:', err);
                      msg('Error cargando listado: ' + err.message); 
                      renderTabla([]);
                  });
          };

          function renderTabla(lista){
              var cont = qs('tablaContrataciones');
              if(!cont){return;}
              if(!lista || lista.length===0){cont.innerHTML='<div style="padding:6px; font-size:12px;">(Sin registros)</div>'; return;}
              
              var html = ['<table style="width:100%; border-collapse:collapse; font-size:11px;">'];
              html.push('<thead><tr style="background:#e9ecef;">'
                  + '<th style="border:1px solid #ccc; padding:4px;">ID</th>'
                  + '<th style="border:1px solid #ccc; padding:4px;">DNI</th>'
                  + '<th style="border:1px solid #ccc; padding:4px;">Nombre</th>'
                  + '<th style="border:1px solid #ccc; padding:4px;">Puesto</th>'
                  + '<th style="border:1px solid #ccc; padding:4px;">Salario Base</th>'
                  + '<th style="border:1px solid #ccc; padding:4px;">Pagas Extra</th>'
                  + '<th style="border:1px solid #ccc; padding:4px;">Compl. Salariales</th>'
                  + '</tr></thead><tbody>');
              
              for(var i=0;i<lista.length;i++){
                  var r = lista[i];
                  var id = (r.id!=null?r.id:'');
                  var dni = (r.dni||'');
                  var nombre = ((r.nombre||'') + ' ' + (r.apellido1||'') + ' ' + (r.apellido2||'')).trim();
                  var puesto = (r.puesto||'');
                  var salBase = (r.rsbSalBase||'');
                  var pagExtra = (r.rsbPagExtra||'');
                  var compConv = (r.rsbCompConv||'');
                  
                  html.push('<tr style="cursor:pointer;" onclick="m11_seleccionarContratacion('+i+')" onmouseover="this.style.backgroundColor=\'#f5f5f5\'" onmouseout="this.style.backgroundColor=\'\'">');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+id+'</td>');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+dni+'</td>');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+nombre+'</td>');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+puesto+'</td>');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+salBase+'</td>');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+pagExtra+'</td>');
                  html.push('<td style="border:1px solid #ddd; padding:4px;">'+compConv+'</td>');
                  html.push('</tr>');
              }
              html.push('</tbody></table>');
              cont.innerHTML = html.join('');
          }

          window.m11_seleccionarContratacion = function(index){
              if(!window.m11_cacheContrataciones || index<0 || index>=window.m11_cacheContrataciones.length) return;
              var reg = window.m11_cacheContrataciones[index];
              rellenarFormularioDesdeRegistro(reg);
              habilitarEliminar(true);
              msg('Registro seleccionado - ID: '+(reg.id||''));
          };

          function rellenarFormularioDesdeRegistro(reg){
              qs('idRegistroContratacion').value = reg.id||'';
              // Rellenar campos de desglose RSB con los valores de la contratación seleccionada
              if(qs('rsbSalBase')) qs('rsbSalBase').value = reg.rsbSalBase||'';
              if(qs('rsbPagasExtra')) qs('rsbPagasExtra').value = reg.rsbPagExtra||'';
              if(qs('rsbCompImporte')) qs('rsbCompImporte').value = reg.rsbCompConv||'';
              if(qs('rsbCompExtra')) qs('rsbCompExtra').value = reg.rsbCompExtra||'';
          }

          window.m11_nuevaContratacionFormulario = function(){
              // Limpiar formulario para nuevo registro
              qs('idRegistroContratacion').value = '';
              var campos = ['rsbSalBase','rsbPagasExtra','rsbCompImporte','rsbCompExtra'];
              for(var i=0; i<campos.length; i++){
                  var campo = qs(campos[i]);
                  if(campo) campo.value = '';
              }
              habilitarEliminar(false);
              msg('Nuevo registro - complete los datos y guarde');
          };

          window.m11_eliminarContratacionSeleccionada = function(){
              var id = qs('idRegistroContratacion').value;
              if(!id) {msg('No hay registro seleccionado para eliminar'); return;}
              
              if(!confirm('¿Está seguro de eliminar la contratación con ID: '+id+'?')) return;
              
              msg('Eliminando...');
              var numExp = '<%=numExpediente%>';
              var url = APP_CONTEXT_PATH + '/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=eliminarContratacionAJAX&tipo=0&numExp='+ encodeURIComponent(numExp||'') + '&id=' + encodeURIComponent(id);
              
              fetch(url, {cache:'no-cache'})
                  .then(r=>r.ok?r.json():Promise.reject(r.status))
                  .then(json=>{
                      if(json && json.resultado && json.resultado.codigoOperacion === 0){
                          msg('Eliminado correctamente');
                          m11_nuevaContratacionFormulario(); // limpiar formulario
                          m11_cargarContrataciones(); // recargar lista
                      } else {
                          msg('Error al eliminar: ' + (json.resultado?.mensajeOperacion || 'Error desconocido'));
                      }
                  })
                  .catch(err=>{console.error('Error eliminarContratacionAJAX',err); msg('Error eliminando registro');});
          };

          // Modificar la función guardarDesglose para que también guarde la información de contratación
          // Nota: Se ha eliminado la redefinición de window.guardarDesglose aquí para evitar duplicidades.

          // Cargar lista inicial cuando el DOM esté listo
          if(document.readyState === 'loading'){
              document.addEventListener('DOMContentLoaded', function(){
                  setTimeout(m11_cargarContrataciones, 100);
              });
          } else {
              setTimeout(m11_cargarContrataciones, 100);
          }

      })(); // fin IIFE CRUD CONTRATACIONES
      ================================================
      FIN CÓDIGO CRUD CONTRATACIONES COMENTADO
      ================================================
      */
    </script>
    <div>
  <input type="hidden" id="errorBD" name="errorBD" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorBD")%>"/>
  <input type="hidden" id="generico" name="generico" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.generico")%>"/>

  <div id="barraProgresoLPEEL" style="visibility:hidden;display:none;">
        <div class="contenedorHidepage">
          <div class="textoHide">
            <span><%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.procesando")%></span>
          </div>
          <div class="imagenHide">
            <span id="disco" class="fa fa-spinner fa-spin" aria-hidden="true"></span>
          </div>
        </div>
          <div style="text-align:center; margin:14px 0 6px 0;">
            <!-- Botón Volver movido al JSP principal (m11Desglose.jsp) -->
          </div>
      </div>

      <form>
        <input type="hidden" id="idRegistroContratacion" name="idRegistroContratacion" value="<%=idRegistro%>" />
        <div style="width:100%; padding:4px 2px 2px 2px; text-align:left;">
          <%-- Cabecera ya incluida arriba (H1 + expediente) --%>

          <div class="lineaFormulario" style="padding-top:4px;">
            <div class="etiquetaLPEEL">Salario base (Oinarrizko soldata)</div>
            <div class="campoFormulario">
              <input id="rsbSalBase" name="rsbSalBase" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vSalBase%>" />
            </div>
          </div>

          <div class="lineaFormulario" style="padding-top:10px;">
            <div class="etiquetaLPEEL">Pagas extraordinarias (Aparteko ordainsariak)</div>
            <div class="campoFormulario">
              <input id="rsbPagasExtra" name="rsbPagasExtra" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vPagas%>" />
            </div>
          </div>

          <div class="lineaFormulario" style="padding-top:10px;">
            <div class="etiquetaLPEEL">Complementos salariales (Soldata-osagarriak)</div>
            <div class="campoFormulario">
              <input id="rsbCompImporte" name="rsbCompImporte" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vCompImp%>" />
            </div>
          </div>

          <%-- Campo Concepto FIJO/VARIABLE eliminado según nuevo diseño --%>

          <div class="lineaFormulario" style="padding-top:10px;">
            <div class="etiquetaLPEEL">Complementos extrasalariales</div>
            <div class="campoFormulario">
              <input id="rsbCompExtra" name="rsbCompExtra" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vCompExtra%>" />
            </div>
          </div>
          <!-- Complementos extrasalariales son informativos; no se guardan en este endpoint -->

          <!-- Botonera movida al contenedor principal (fuera de las pestañas) -->

        </div>
      </form>
    </div>
</div>
