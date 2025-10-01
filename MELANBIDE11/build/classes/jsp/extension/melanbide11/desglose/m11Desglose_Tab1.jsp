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
<div style="padding:6px 8px 4px 8px;" class="m11-form">
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

   
      String nuevo       = request.getAttribute("nuevo") != null ? (String)request.getAttribute("nuevo") : "1";
      String idRegistro  = request.getAttribute("id")    != null ? (String)request.getAttribute("id")    : "";

    
      String vSalBase  = request.getAttribute("salarioBase") != null ? ((String)request.getAttribute("salarioBase")).replace(".", ",") : "";
      String vPagas    = request.getAttribute("pagasExtra")  != null ? ((String)request.getAttribute("pagasExtra")).replace(".", ",")  : "";
      String vCompImp  = request.getAttribute("compImporte") != null ? ((String)request.getAttribute("compImporte")).replace(".", ",") : "";
      String vCompTipo = request.getAttribute("compTipo")    != null ? (String)request.getAttribute("compTipo") : "";
      String vCompExtra = request.getAttribute("compExtra")  != null ? ((String)request.getAttribute("compExtra")).replace(".", ",") : ""; // nuevo: valor complementos extrasalariales
    %>
    <jsp:useBean id="descriptor" scope="request" class="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean"  type="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean" />
    <jsp:setProperty name="descriptor"  property="idi_cod" value="<%=idiomaUsuario%>" />
    <jsp:setProperty name="descriptor"  property="apl_cod" value="<%=apl%>" />

 
    <script type="text/javascript">
      var APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
      var url = APP_CONTEXT_PATH + '/PeticionModuloIntegracion.do';
      var mensajeValidacion = '';

    
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

      
      if (typeof jsp_alerta === 'undefined') {
        function jsp_alerta(tipo, mensaje) {
          if (tipo === '') {
            return confirm(mensaje) ? 1 : 0;
          } else {
            alert(mensaje);
          }
        }
      }

      if (typeof mostrarErrorPeticion === 'undefined') {
        function mostrarErrorPeticion(codigo) {
          console.error("Error en peticin AJAX, cdigo:", codigo);
          alert("Error en la comunicacin con el servidor");
        }
      }

      
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

      
      function validarNumeroReal(campo) {
        try {
          if (!campo || !campo.value || campo.value.trim() === '') {
            return true; // Los campos vacos se permiten
          }
          
          var valor = campo.value.replace(',', '.'); 
          var numero = parseFloat(valor);
          
          if (isNaN(numero) || !isFinite(numero)) {
            return false;
          }
          
         
          if (numero < 0) {
            return false;
          }
          
          return true;
        } catch (e) {
          console.warn('Error validando campo numrico:', e);
          return false;
        }
      }

      function validarDesglose(){
        mensajeValidacion='';
        var sal=document.getElementById('rsbSalBase');
        if(sal.value && !validarNumeroReal(sal)){
            mensajeValidacion='Salario base: formato invlido.';
            return false;
        }
        
        var pag=document.getElementById('rsbPagasExtra');
        if(pag.value && !validarNumeroReal(pag)){
            mensajeValidacion='Pagas extraordinarias: formato invlido.';
            return false;
        }
        
        var imp=document.getElementById('rsbCompImporte');
        if(imp.value && !validarNumeroReal(imp)){
            mensajeValidacion='Complementos salariales: formato invlido.';
            return false;
        }
        
        var impExtra=document.getElementById('rsbCompExtra');
        if(impExtra.value && !validarNumeroReal(impExtra)){
            mensajeValidacion='Complementos extrasalariales: formato invlido.';
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
         
          var codigoOperacion = datos && datos.resultado ? datos.resultado.codigoOperacion : "4";
          if (codigoOperacion == "0"){
            console.log("Desglose RSB guardado exitosamente - cerrando modal");
           
            jsp_alerta('I', 'Guardado correcto');
            
            try {
              if (window.opener && window.opener.modalCallback) {
                window.opener.modalCallback(['0', 'Desglose RSB guardado exitosamente']);
              } else if (window.parent && window.parent.modalCallback) {
                window.parent.modalCallback(['0', 'Desglose RSB guardado exitosamente']);
              }
            } catch(e) {
              console.warn("No se pudo pasar resultado al padre:", e);
            }
           
            setTimeout(function() {
              cerrarVentana(['0', 'Desglose RSB guardado exitosamente']);
            }, 1500); 
          } else if (codigoOperacion == "1") {
            jsp_alerta('A', document.getElementById('errorBD').value);
          } else if (codigoOperacion == "3") {
            jsp_alerta('A', 'Parmetros insuficientes');
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
          console.log("Validacin fall:", mensajeValidacion);
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
          if (window.skipCancelConfirm) { 
            cerrarVentana();
            return;
          }
        }catch(e){}
        var r = jsp_alerta('', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.preguntaCancelar")%>');
        if(r == 1){ cerrarVentana(); } 
      }

      
      console.log("=== FUNCIONES REGISTRADAS EN TAB1 ===");
      console.log("window.guardarDesglose:", typeof window.guardarDesglose);
      console.log("window.cancelar:", typeof window.cancelar);

     
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
                  
               
                  limpiarFormularioTab1();
                  
                 
                  if (typeof window.habilitarBotonEliminar === 'function') {
                    window.habilitarBotonEliminar(false);
                  }
                  
                  
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
                console.error("Error procesando respuesta de eliminacin:", e);
                jsp_alerta('A', 'Error al procesar la respuesta del servidor');
              }
            },
            error: function(xhr, status, error) {
              elementoVisible('off', 'barraProgresoLPEEL');
              console.error("Error en AJAX de eliminacin:", error);
              jsp_alerta('A', 'Error de comunicacin con el servidor');
            }
          });
        } catch(err) {
          console.error("Error en eliminacin:", err);
          elementoVisible('off', 'barraProgresoLPEEL');
          jsp_alerta('A', 'Error al eliminar el registro');
        }
        
        return true;
      };
      
 
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
      
  
      function verificarRegistroSeleccionado() {
        var idRegistro = document.getElementById('idRegistroContratacion');
        var hayRegistro = idRegistro && idRegistro.value && idRegistro.value.trim() !== '';
        
        if (typeof window.habilitarBotonEliminar === 'function') {
          window.habilitarBotonEliminar(hayRegistro);
        }
        
        return hayRegistro;
      }
      
  
      try {
        var idInput = document.getElementById('idRegistroContratacion');
        if (idInput) {
          idInput.addEventListener('change', verificarRegistroSeleccionado);
          idInput.addEventListener('input', verificarRegistroSeleccionado);
        }
      } catch(e) {
        console.warn("Error aadiendo listeners:", e);
      }
      
    
      setTimeout(verificarRegistroSeleccionado, 100);

   
      function cerrarVentana(resultado) {
        console.log("=== CERRANDO MODAL DESGLOSE RSB ===");
        console.log("Resultado a pasar:", resultado);
        try {
          var ventanaCerrada = false;
          
         
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
          
         
          if (window.opener && !window.parent.opener) {
            console.log("Mtodo 1: Ventana popup - cerrando con window.close()");
            window.close();
            ventanaCerrada = true;
          }
          
    
          else if (window.parent && window.parent !== window.self) {
            console.log("Mtodo 2: Ventana en frame/iframe");
            
           
            if (window.parent.window && typeof window.parent.window.close === 'function') {
              console.log("Cerrando desde window.parent.window.close()");
              window.parent.window.close();
              ventanaCerrada = true;
            }
          
            else {
              console.log("Fallback frame: cerrando ventana actual");
              window.close();
              ventanaCerrada = true;
            }
          }
          
          
          if (!ventanaCerrada) {
            console.log("Mtodo 3: Fallback general");
            if (window.close) {
              window.close();
              ventanaCerrada = true;
            }
          }
          
   
          if (!ventanaCerrada) {
            console.log("Mtodo 4: ltimo recurso - recargar pgina padre");
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
            <!-- Botn Volver movido al JSP principal (m11Desglose.jsp) -->
          </div>
      </div>

      <form>
        <input type="hidden" id="idRegistroContratacion" name="idRegistroContratacion" value="<%=idRegistro%>" />
        <div style="width:100%; padding:4px 2px 2px 2px; text-align:left;">
         
          <div class="lineaFormulario" style="padding-top:4px;">
            <div class="etiquetaLPEEL">
              <span class="label-bilingual">
                <span class="label-es"><%=meLanbide11I18n.getMensaje(1,"tablaDesglose.salarioBase")%></span>
                <span class="label-eu"><%=meLanbide11I18n.getMensaje(2,"tablaDesglose.salarioBase")%></span>
              </span>
            </div>
            <div class="campoFormulario">
              <input id="rsbSalBase" name="rsbSalBase" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vSalBase%>" />
            </div>
          </div>

          <div class="lineaFormulario" style="padding-top:10px;">
            <div class="etiquetaLPEEL">
              <span class="label-bilingual">
                <span class="label-es"><%=meLanbide11I18n.getMensaje(1,"tablaDesglose.pagasExtra")%></span>
                <span class="label-eu"><%=meLanbide11I18n.getMensaje(2,"tablaDesglose.pagasExtra")%></span>
              </span>
            </div>
            <div class="campoFormulario">
              <input id="rsbPagasExtra" name="rsbPagasExtra" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vPagas%>" />
            </div>
          </div>

          <div class="lineaFormulario" style="padding-top:10px;">
            <div class="etiquetaLPEEL">
              <span class="label-bilingual">
                <span class="label-es"><%=meLanbide11I18n.getMensaje(1,"tablaDesglose.complementosSalariales")%></span>
                <span class="label-eu"><%=meLanbide11I18n.getMensaje(2,"tablaDesglose.complementosSalariales")%></span>
              </span>
            </div>
            <div class="campoFormulario">
              <input id="rsbCompImporte" name="rsbCompImporte" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vCompImp%>" />
            </div>
          </div>       

          <div class="lineaFormulario" style="padding-top:10px;">
            <div class="etiquetaLPEEL">
              <span class="label-bilingual">
                <span class="label-es"><%=meLanbide11I18n.getMensaje(1,"tablaDesglose.extrasalariales")%></span>
                <span class="label-eu"><%=meLanbide11I18n.getMensaje(2,"tablaDesglose.extrasalariales")%></span>
              </span>
            </div>
            <div class="campoFormulario">
              <input id="rsbCompExtra" name="rsbCompExtra" type="text" class="inputTexto" size="10" maxlength="10"
                     onchange="reemplazarPuntos(this);" onblur="validarNumeroReal(this);" value="<%=vCompExtra%>" />
            </div>
          </div>
        
        </div>
      </form>
    </div>
</div>
