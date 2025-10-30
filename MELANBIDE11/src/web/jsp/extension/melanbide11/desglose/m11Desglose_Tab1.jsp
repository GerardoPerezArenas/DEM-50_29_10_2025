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

      function esNumeroValido(valor) {
        return typeof valor === 'number' && !isNaN(valor) && isFinite(valor);
      }

      function esCasiCero(valor) {
        if (!esNumeroValido(valor)) {
          return true;
        }
        return Math.abs(valor) < 0.005;
      }

      function parseImporteSeguro(valor) {
        if (valor === null || valor === undefined) {
          return 0;
        }
        try {
          var limpio = String(valor).replace(/\s+/g, '');
          if (limpio.indexOf(',') !== -1) {
            limpio = limpio.replace(/\./g, '').replace(',', '.');
          }
          var numero = parseFloat(limpio);
          return isNaN(numero) ? 0 : numero;
        } catch (e) {
          console.warn('parseImporteSeguro fall', e);
          return 0;
        }
      }

      function redondearDosDecimales(valor) {
        if (!esNumeroValido(valor)) {
          return 0;
        }
        return Math.round(valor * 100) / 100;
      }

      function obtenerTotalesLocalesDesglose() {
        var salBaseEl = document.getElementById('rsbSalBase');
        var pagasEl = document.getElementById('rsbPagasExtra');
        var compImpEl = document.getElementById('rsbCompImporte');
        var compExtraEl = document.getElementById('rsbCompExtra');

        var salBase = parseImporteSeguro(salBaseEl ? salBaseEl.value : '0');
        var pagasExtra = parseImporteSeguro(pagasEl ? pagasEl.value : '0');
        var compImporteCampo = parseImporteSeguro(compImpEl ? compImpEl.value : '0');
        var compExtraCampo = parseImporteSeguro(compExtraEl ? compExtraEl.value : '0');

        var compImporte = compImporteCampo;
        var compExtra = compExtraCampo;
        var totalesTab2 = null;
        try {
          if (typeof window.obtenerTotalesDesgloseRSB === 'function') {
            totalesTab2 = window.obtenerTotalesDesgloseRSB();
          }
        } catch (errTotales) {
          console.warn('No se pudieron obtener totales de TAB2:', errTotales);
        }

        if (totalesTab2) {
          if (esNumeroValido(totalesTab2.salarialesFijos)) {
            compImporte = redondearDosDecimales(Number(totalesTab2.salarialesFijos));
          }
          if (esNumeroValido(totalesTab2.extrasalariales)) {
            compExtra = redondearDosDecimales(Number(totalesTab2.extrasalariales));
          }
        }

        var rsbCalculado = redondearDosDecimales(salBase + pagasExtra + compImporte);
        var costeCalculado = redondearDosDecimales(rsbCalculado + compExtra);

        return {
          tieneDatos: (salBase !== 0 || pagasExtra !== 0 || compImporte !== 0 || compExtra !== 0),
          rsbCompConv: rsbCalculado,
          cstCont: costeCalculado,
          fuenteTab2: !!(totalesTab2 && (esNumeroValido(totalesTab2.salarialesFijos) || esNumeroValido(totalesTab2.extrasalariales)))
        };
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
        
        console.log("=== INICIANDO GUARDADO COMPLETO ===");
        
        // PASO 1: Primero guardar las líneas de desglose de TAB2 (si existe)
        // Buscar la función de guardado de TAB2 en el contexto global
        var guardarTab2Existe = false;
        var fnGuardarTab2 = null;
        
        try {
          // Buscar función expuesta por TAB2
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
          console.warn("No se pudo acceder a función de guardado de TAB2:", e);
        }
        
        // Función interna para guardar datos de TAB1
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
        
        // Si TAB2 tiene guardado pendiente, ejecutarlo primero
        if (guardarTab2Existe && fnGuardarTab2) {
          console.log("=== GUARDANDO PRIMERO LÍNEAS DE DESGLOSE (TAB2) ===");
          elementoVisible('on', 'barraProgresoLPEEL');
          
          try {
            // Guardar TAB2 con callback para continuar con TAB1
            fnGuardarTab2(function(exitoTab2) {
              console.log("Resultado guardado TAB2:", exitoTab2);
              if (exitoTab2) {
                console.log("? TAB2 guardado exitosamente, continuando con TAB1");
                // Pequeña pausa para asegurar que BD se actualizó
                setTimeout(guardarDatosTab1, 300);
              } else {
                console.error("? Error guardando TAB2, abortando");
                elementoVisible('off', 'barraProgresoLPEEL');
                jsp_alerta('A', 'Error al guardar las líneas de desglose. No se continuará con el guardado.');
              }
            });
          } catch (errTab2) {
            console.error("Error ejecutando guardarLineasDesgloseTab2:", errTab2);
            // Si falla TAB2, continuar con TAB1 de todos modos
            console.warn("Continuando con guardado TAB1 a pesar del error en TAB2");
            guardarDatosTab1();
          }
        } else {
          console.log("? TAB2 no tiene función de guardado o no está disponible");
          console.log("Guardando solo datos de TAB1");
          guardarDatosTab1();
        }
      }

            function procesarRespuestaGuardar(ajaxResult) {
        elementoVisible('off', 'barraProgresoLPEEL');
        
        console.log("Respuesta recibida:", ajaxResult);
        console.log("Tipo de respuesta:", typeof ajaxResult);
        
        if (!ajaxResult) {
            console.error('Respuesta vacía al guardar desglose RSB');
            jsp_alerta('A', 'Se ha recibido una respuesta vacía del servidor.');
            return;
        }
        
        try {
            // Parsear respuesta - compatible con Java 6
            var datos;
            if (typeof ajaxResult === 'string') {
                console.log("Respuesta es string, parseando JSON...");
                // Para IE8/Java 6 compatibility
                try {
                    datos = eval('(' + ajaxResult + ')');
                } catch(e) {
                    // Fallback a JSON.parse si está disponible
                    if (typeof JSON !== 'undefined' && JSON.parse) {
                        datos = JSON.parse(ajaxResult);
                    } else {
                        throw e;
                    }
                }
            } else {
                console.log("Respuesta ya es objeto, usando directamente...");
                datos = ajaxResult;
            }

      var codigoOperacion = "4";
      var rsbCompConv = null;
      var cstCont = null;
      var idRegistroSeleccionado = null;
      var puedeActualizarSinRecarga = false;
      if (datos && datos.resultado) {
        codigoOperacion = datos.resultado.codigoOperacion + "";
        if (datos.resultado.idRegistro !== undefined && datos.resultado.idRegistro !== null) {
          idRegistroSeleccionado = String(datos.resultado.idRegistro);
        }
      }

      if (!idRegistroSeleccionado) {
        var campoIdRegistro = document.getElementById('idRegistroContratacion');
        if (campoIdRegistro && campoIdRegistro.value && campoIdRegistro.value.trim() !== '') {
          idRegistroSeleccionado = campoIdRegistro.value.trim();
        }
      }

      if (window.opener && !window.opener.closed && typeof window.opener.actualizarImportesContratacion === 'function') {
        puedeActualizarSinRecarga = true;
      }
            
            console.log("Código de operación:", codigoOperacion);
            
            if (codigoOperacion == "0") {
                console.log("Desglose RSB guardado exitosamente");
                
                // Actualizar valores calculados en ventana padre
                try {
                    if (datos.resultado) {
            rsbCompConv = 0;
            cstCont = 0;
                        
                        // Parsear valores con manejo de null/undefined
                        if (datos.resultado.rsbCompConv !== undefined && datos.resultado.rsbCompConv !== null) {
                            var tmpVal = String(datos.resultado.rsbCompConv).replace(',', '.');
                            rsbCompConv = parseFloat(tmpVal);
                            if (isNaN(rsbCompConv)) rsbCompConv = 0;
                        }
                        
                        if (datos.resultado.cstCont !== undefined && datos.resultado.cstCont !== null) {
                            var tmpVal2 = String(datos.resultado.cstCont).replace(',', '.');
                            cstCont = parseFloat(tmpVal2);
                            if (isNaN(cstCont)) cstCont = 0;
                        }

            var totalesLocales = obtenerTotalesLocalesDesglose();
            var usarFallback =
              totalesLocales.tieneDatos &&
              (!esNumeroValido(rsbCompConv) ||
               !esNumeroValido(cstCont) ||
               (esCasiCero(rsbCompConv) && totalesLocales.rsbCompConv > 0) ||
               (esCasiCero(cstCont) && totalesLocales.cstCont > 0));

            if (usarFallback) {
              if (totalesLocales.fuenteTab2) {
                console.log("Totales de BD no disponibles. Usando sumatorio de TAB2.");
              } else {
                console.log("Totales de BD no disponibles. Usando valores de formulario TAB1.");
              }
              rsbCompConv = totalesLocales.rsbCompConv;
              cstCont = totalesLocales.cstCont;
            }

            rsbCompConv = redondearDosDecimales(rsbCompConv);
            cstCont = redondearDosDecimales(cstCont);
                        
                        console.log("Valores actualizados desde BD:");
            console.log("  - RSBCOMPCONV:", rsbCompConv);
            console.log("  - CSTCONT:", cstCont);

            if (window.opener && !window.opener.closed && typeof window.opener.actualizarImportesContratacion === 'function') {
              try {
                window.opener.actualizarImportesContratacion({
                  rsbCompConv: rsbCompConv,
                  cstCont: cstCont,
                  idRegistro: idRegistroSeleccionado || null
                });
              } catch (inlineErr) {
                console.warn("No se pudo actualizar tabla principal sin recarga:", inlineErr);
              }
            }

            // Actualizar campo rsbTotal en ventana padre
                        if (window.opener && !window.opener.closed) {
                            try {
                                var rsbTotalField = window.opener.document.getElementById('rsbTotal');
                                if (rsbTotalField) {
                                    // Formatear con 2 decimales y coma
                                    var valorFormateado = rsbCompConv.toFixed(2).replace('.', ',');
                                    rsbTotalField.value = valorFormateado;
                                    console.log("Campo rsbTotal actualizado en ventana padre:", valorFormateado);
                                    
                                    // Disparar evento change para que se actualice la UI
                                    if (rsbTotalField.onchange) {
                                        rsbTotalField.onchange();
                                    }
                                }
                                
                                // También actualizar cstCont si existe el campo
                                var cstContField = window.opener.document.getElementById('cstCont');
                                if (cstContField) {
                                    var valorFormateado2 = cstCont.toFixed(2).replace('.', ',');
                                    cstContField.value = valorFormateado2;
                                    console.log("Campo cstCont actualizado en ventana padre:", valorFormateado2);
                                    
                                    if (cstContField.onchange) {
                                        cstContField.onchange();
                                    }
                                }
                            } catch(e) {
                                console.warn("Error actualizando campos padre:", e);
                            }
                        }
                    } 
                } catch (updateErr) {
                    console.warn("No se pudo actualizar campos en ventana padre:", updateErr);
                }
                
                jsp_alerta('I', 'Guardado correcto');
                
                // IMPORTANTE: Refrescar los datos antes de cerrar
                // Compatible con IE8/Java 6
                
                // 1. Refrescar las tablas de TAB2
                try {
                    if (typeof window.refrescarDesgloseRSB === 'function') {
                        console.log("Refrescando tablas de desglose TAB2...");
                        // Usar setTimeout para compatibilidad
                        window.setTimeout(function() {
                            try {
                                window.refrescarDesgloseRSB();
                            } catch(e) {
                                console.warn("Error refrescando TAB2:", e);
                            }
                        }, 200);
                    }
                } catch(e) {
                    console.warn("No se pudo refrescar TAB2:", e);
                }
                
        // 2. Refrescar ventana padre solo si no existe actualización inline
        if (!puedeActualizarSinRecarga && window.opener && !window.opener.closed) {
          console.log("No hay función inline en ventana padre, aplicando refrescos tradicionales...");
                    window.setTimeout(function() {
                        try {
                            // Buscar funciones de refresco en el padre
                            if (typeof window.opener.refrescarDatosContratacion === 'function') {
                                console.log("Llamando refrescarDatosContratacion...");
                                window.opener.refrescarDatosContratacion();
                            } else if (typeof window.opener.cargarDatosContratacion === 'function') {
                                console.log("Llamando cargarDatosContratacion...");
                                window.opener.cargarDatosContratacion();
                            } else if (typeof window.opener.recargarTabla === 'function') {
                                console.log("Llamando recargarTabla...");
                                window.opener.recargarTabla();
                            }
                            

                            // Si hay una tabla de contrataciones, refrescarla
                            if (typeof window.opener.tablaContrataciones !== 'undefined' && 
                                window.opener.tablaContrataciones && 
                                typeof window.opener.tablaContrataciones.displayTabla === 'function') {
                                console.log("Refrescando tabla de contrataciones...");
                                window.opener.tablaContrataciones.displayTabla();
                            }
                        } catch(e) {
                            console.warn("No se pudo refrescar ventana padre:", e);
                        }
                    }, 300);
                }
                
                // 3. Cerrar ventana después de asegurar que todo se actualizó
                window.setTimeout(function() {
                    console.log("Cerrando ventana modal después de refrescos...");
                    try {
                        // Preparar resultado para el padre
            var resultado = ['0', 'Desglose RSB guardado exitosamente', 'DESGLOSE_RSB'];
            resultado.push(rsbCompConv !== null ? rsbCompConv : '');
            resultado.push(cstCont !== null ? cstCont : '');
            if (idRegistroSeleccionado) {
              resultado.push(idRegistroSeleccionado);
            }
                        
                        // Si existe cerrarVentanaModal del framework, usarla
                        if (typeof cerrarVentanaModal === 'function') {
                            cerrarVentanaModal(resultado);
                        } else {
                            // Fallback: cerrar manualmente
                            if (window.opener && !window.opener.closed) {
                                // Notificar al padre si tiene callback
                                if (typeof window.opener.onDesgloseGuardado === 'function') {
                                    window.opener.onDesgloseGuardado(resultado);
                                }
                            }
                            window.close();
                        }
                    } catch(e) {
                        console.error("Error cerrando ventana:", e);
                        // Último intento
                        try { 
                            window.close(); 
                        } catch(e2) {
                            self.close();
                        }
                    }
                }, 600); // Delay de 600ms para asegurar todos los refrescos
                
            } else if (codigoOperacion == "1") {
                jsp_alerta('A', document.getElementById('errorBD').value);
            } else if (codigoOperacion == "3") {
                jsp_alerta('A', 'Parámetros insuficientes');
            } else {
                jsp_alerta('A', document.getElementById('generico').value);
            }
        } catch (e) {
            console.error('Error procesando respuesta de guardado RSB:', e);
            jsp_alerta('A', document.getElementById('generico').value);
        }
      }

      function mostrarErrorGuardar(){
        elementoVisible('off', 'barraProgresoLPEEL');
        mostrarErrorPeticion(7);
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
             success: function (ajaxResult) {
              elementoVisible('off', 'barraProgresoLPEEL');
              if (!ajaxResult || !ajaxResult.trim()) {
                console.error('Respuesta vacía al eliminar contratación RSB');
                jsp_alerta('A', 'Se ha recibido una respuesta vacía del servidor.');
                return;
              }
              try {
                var datos = JSON.parse(ajaxResult || '{}');
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

      // Sobrescribir con función que usa el framework
      function cerrarVentana(resultado) {
        console.log("=== CERRANDO MODAL DESGLOSE RSB (framework) ===");
        console.log("Resultado a pasar:", resultado);
        
        try {
          // Verificar si cerrarVentanaModal existe
          if (typeof cerrarVentanaModal === 'function') {
            console.log("? cerrarVentanaModal disponible - usando framework");
            cerrarVentanaModal(resultado || ['0']);
            return; // Salir después de usar el framework
          } else {
            console.warn("? cerrarVentanaModal NO disponible - usando fallback");
          }
        } catch(e) {
          console.error("? Error llamando cerrarVentanaModal:", e);
        }
        
        // Fallback: cerrar manualmente
        try {
          console.log("Usando fallback: window.close()");
          
          // Intentar pasar resultado al padre si existe
          if (resultado && window.opener && !window.opener.closed) {
            console.log("Pasando resultado a window.opener");
            window.returnValue = resultado;
            
            // Si el padre tiene callback, llamarlo
            if (typeof window.opener.onModalClosed === 'function') {
              window.opener.onModalClosed(resultado);
            }
          }
          
          // Cerrar la ventana
          window.close();
        } catch(e2) {
          console.error("? Error en fallback:", e2);
          // Último intento
          try { self.close(); } catch(e3) { }
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
