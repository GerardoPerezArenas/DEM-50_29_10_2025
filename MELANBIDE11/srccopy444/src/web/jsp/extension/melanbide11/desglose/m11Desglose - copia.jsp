<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld"  prefix="bean"  %>
<%@ taglib uri="/WEB-INF/tlds/c.tld"       prefix="c"     %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@ page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@ page import="es.altia.common.service.config.Config" %>
<%@ page import="es.altia.common.service.config.ConfigServiceHelper" %>
<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter" %>
<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11" %>

<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<%
    int idiomaUsuario = 1;
    UsuarioValueObject usuarioVO = new UsuarioValueObject();
    int idioma = 1;
    int apl = 5;
    String css = "";
    if (session.getAttribute("usuario") != null) {
        usuarioVO = (UsuarioValueObject) session.getAttribute("usuario");
        apl = usuarioVO.getAppCod();
        idioma = usuarioVO.getIdioma();
        idiomaUsuario = idioma;
        css = usuarioVO.getCss();
    }

    MeLanbide11I18n I18N = MeLanbide11I18n.getInstance();

    String numExpediente = (String)request.getAttribute("numExp");
    String idProyecto    = (String)request.getAttribute("idProyecto");

    String urlPestanaResumen = (String)request.getAttribute("urlPestanaResumen");
    if (urlPestanaResumen == null || urlPestanaResumen.length() == 0) {
        urlPestanaResumen = "/jsp/extension/melanbide11/desglose/m11Desglose_Tab1.jsp";
    }
    String urlPestanaComplementos = (String)request.getAttribute("urlPestanaComplementos");
    if (urlPestanaComplementos == null || urlPestanaComplementos.length() == 0) {
        urlPestanaComplementos = "/jsp/extension/melanbide11/desglose/m11Desglose_Tab2.jsp";
    }
%>

  <link rel="StyleSheet" media="screen" type="text/css" href="<%=request.getContextPath()%><%=css%>"/>
  <link rel="StyleSheet" media="screen" type="text/css" href="<%=request.getContextPath()%>/css/extension/melanbide11/melanbide11.css"/>

  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/jquery/jquery-1.9.1.min.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.js"></script>
  <link  rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.css"/>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/validaciones.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/popup.js"></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/FixedColumnsTable.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/JavaScriptUtil.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/Parsers.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/InputMask.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/lanbide.js"></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/tabpane.js"></script>

  <!-- Tabla nueva genérica (sin dependencias ECA) -->
  <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/TablaNueva.js"></script>

  <title><%= I18N.getMensaje(idiomaUsuario, "label.m11.desglose.titulo") %></title>

  <script type="text/javascript">
    function ajustarVentanaDesglose(){
      try{
        var alto = document.body.scrollHeight + 20;
        var ancho = 790;
        if (window.resizeTo){ window.resizeTo(ancho, (alto<600?600:alto)); }
      }catch(e){}
    }
  </script>
</head>

<body class="bandaBody" onload="elementoVisible('off','barraProgresoLPEEL'); ajustarVentanaDesglose();">
  <jsp:useBean id="descriptor" scope="request" class="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean" />
  <jsp:setProperty name="descriptor"  property="idi_cod" value="<%=idioma%>" />
  <jsp:setProperty name="descriptor"  property="apl_cod" value="<%=apl%>" />

  <div id="m11Container" style="width:750px; margin:10px auto 12px auto;">
    <div style="border:1px solid #2f5b8a;background:#2f5b8a;color:#fff;padding:14px 18px;margin:14px 5px 16px 5px;">
      <h1 id="tituloPrincipalM11" style="margin:0;text-align:center;font-size:20px;line-height:1.2;">
        Desglose retribución salarial bruta
      </h1>
      <div style="text-align:center;font-size:13px;margin-top:6px;">
        <strong>Expediente:</strong> <%= (numExpediente!=null?numExpediente:"-") %>
      </div>
    </div>

    <!-- Estructura correcta: tab-pane contiene las tab-page; cada tab-page inicia con h2.tab -->
    <div id="tab-panel-m11" class="tab-pane">

      <div class="tab-page" id="tabPageM11_1">
        <h2 class="tab"><%= I18N.getMensaje(idiomaUsuario, "label.m11.desglose.titulo.tab1") %></h2>
        <jsp:include page="<%= urlPestanaResumen %>" flush="true"/>
      </div>

      <div class="tab-page" id="tabPageM11_2">
        <h2 class="tab"><%= I18N.getMensaje(idiomaUsuario, "label.m11.desglose.titulo.tab2") %></h2>
        <jsp:include page="<%= urlPestanaComplementos %>" flush="true"/>
      </div>

    </div>

    <!-- Botón Volver centrado para todas las pestañas -->
    <div style="text-align:center; margin:20px 0 10px 0; padding:10px;">
      <input type="button" class="botonMasLargo" value="Volver" onclick="if(window.volverDesglose){ window.volverDesglose(); } else if(window.cancelar){ window.cancelar(); }" style="min-width:120px; padding:8px 16px;" />
    </div>

    <script type="text/javascript">
      // Inicializar tras existir .tab-page con <h2 class="tab">
      (function(){
        var cont = document.getElementById('tab-panel-m11');
        if(!cont){ return; }
        try {
          if (typeof WebFXTabPane !== 'undefined') {
            var tpM11 = new WebFXTabPane(cont);
            try { tpM11.setSelectedIndex(0); } catch(e){}
            return; // WebFX inicializado correctamente
          }
        } catch(ign) {}

        // Fallback simple: cambiar pestañas mostrando/ocultando .tab-page y toggling .selected
        try {
          var tabPages = cont.getElementsByClassName('tab-page');
          var headers = cont.querySelectorAll('h2.tab');
          function selectTab(idx){
            for (var i=0;i<tabPages.length;i++){
              tabPages[i].style.display = (i===idx? 'block':'none');
              if (headers[i]){
                if (i===idx) headers[i].className = 'tab selected';
                else headers[i].className = 'tab';
              }
              // marcar selected en el contenedor de la página (por compat)
              if (i===idx) {
                if (tabPages[i].className.indexOf('selected') === -1){ tabPages[i].className += ' selected'; }
              } else {
                tabPages[i].className = tabPages[i].className.replace(/\bselected\b/g,'').trim();
              }
            }
          }
          for (var j=0;j<headers.length;j++){
            (function(ix){ headers[ix].onclick = function(){ selectTab(ix); }; })(j);
          }
          // seleccionar primera pestaña por defecto
          selectTab(0);
        } catch(e){ /* sin pestañas */ }
      })();
    </script>

    <!-- Botonera general eliminada a petición: cada pestaña gestiona sus propios controles -->

    <script type="text/javascript">
      function aceptarDesglose() {
        console.log("=== ACEPTAR DESGLOSE ===");
        console.log("window.guardarDesglose exists:", typeof window.guardarDesglose);
        if (typeof window.guardarDesglose === 'function') {
          window.guardarDesglose();
        } else {
          console.warn("window.guardarDesglose no está disponible, cerrando ventana");
          window.close();
        }
      }

      // Confirmación general para botones "Volver" de ambas pestañas
      function volverDesglose() {
        var mensaje = "¿Seguro que quieres salir?";
        var confirmar = false;
        try {
          if (typeof jsp_alerta === 'function') {
            confirmar = (jsp_alerta('', mensaje) == 1);
          } else {
            confirmar = confirm(mensaje);
          }
        } catch(e) {
          confirmar = confirm(mensaje);
        }
        if (!confirmar) return;

        // Evitar doble confirmación en cancelar() de Tab1
        try { window.skipCancelConfirm = true; } catch(e) {}
        if (typeof window.cancelar === 'function') {
          window.cancelar();
        } else {
          try { window.close(); } catch(e) {}
        }
        // Limpiar flag tras un breve tiempo
        setTimeout(function(){ try { window.skipCancelConfirm = false; } catch(e) {} }, 1500);
      }

      function cancelarDesglose() {
        console.log("=== CANCELAR DESGLOSE ===");
        console.log("window.cancelar exists:", typeof window.cancelar);
        if (typeof window.cancelar === 'function') {
          window.cancelar();
        } else {
          console.warn("window.cancelar no está disponible, cerrando ventana");
          if (confirm("¿Seguro que desea cancelar la operación?")) {
            window.close();
          }
        }
      }

      function eliminarDesglose() {
        console.log("=== ELIMINAR DESGLOSE ===");
        
        // Verificar que hay un registro seleccionado para eliminar
        var hayRegistroSeleccionado = false;
        var mensajeConfirmacion = "¿Está seguro de que desea eliminar este registro?";
        var detallesRegistro = "";
        
        try {
          // Verificar si hay algún ID o dato que indique registro seleccionado
          var idRegistro = "";
          
          // Buscar en Tab1
          var inputId1 = document.getElementById('idRegistroContratacion');
          if (inputId1 && inputId1.value && inputId1.value.trim() !== '') {
            idRegistro = inputId1.value.trim();
            hayRegistroSeleccionado = true;
            detallesRegistro = " (ID: " + idRegistro + ")";
          }
          
          // Si no hay registro en Tab1, buscar en Tab2
          if (!hayRegistroSeleccionado) {
            var inputs = document.querySelectorAll('input[id*="id"], input[name*="id"], input[id*="Id"], input[name*="Id"]');
            for (var i = 0; i < inputs.length; i++) {
              if (inputs[i].value && inputs[i].value.trim() !== '') {
                idRegistro = inputs[i].value.trim();
                hayRegistroSeleccionado = true;
                detallesRegistro = " (ID: " + idRegistro + ")";
                break;
              }
            }
          }
          
          // Si aún no hay registro, verificar si hay filas seleccionadas en tablas
          if (!hayRegistroSeleccionado) {
            var filasSeleccionadas = document.querySelectorAll('tr.selected, tr.highlight, tr.rowSelected');
            if (filasSeleccionadas && filasSeleccionadas.length > 0) {
              hayRegistroSeleccionado = true;
              detallesRegistro = " (" + filasSeleccionadas.length + " registro(s) seleccionado(s))";
            }
          }
          
        } catch(e) {
          console.warn("Error verificando registro seleccionado:", e);
        }
        
        if (!hayRegistroSeleccionado) {
          if (typeof jsp_alerta === 'function') {
            jsp_alerta('A', 'Debe seleccionar un registro para eliminar.');
          } else {
            alert('Debe seleccionar un registro para eliminar.');
          }
          return;
        }
        
        // Confirmar eliminación con detalles
        mensajeConfirmacion = "¿Está seguro de que desea eliminar este registro" + detallesRegistro + "?\n\nEsta acción no se puede deshacer.";
        
        var confirmar = false;
        try {
          if (typeof jsp_alerta === 'function') {
            var resultado = jsp_alerta('C', mensajeConfirmacion);
            confirmar = (resultado == 1);
          } else {
            confirmar = confirm(mensajeConfirmacion);
          }
        } catch(e) {
          confirmar = confirm("¿Está seguro de que desea eliminar este registro?");
        }
        
        if (!confirmar) {
          console.log("Eliminación cancelada por el usuario");
          return;
        }
        
        // Determinar pestaña activa para llamar función específica
        var tab1 = document.getElementById('tabPageM11_1');
        var tab2 = document.getElementById('tabPageM11_2');
        var tab1Active = tab1 && tab1.className && tab1.className.indexOf('selected') !== -1;
        var tab2Active = tab2 && tab2.className && tab2.className.indexOf('selected') !== -1;
        
        console.log("Eliminando desde pestaña - Tab1 activa:", tab1Active, "Tab2 activa:", tab2Active);
        
        // Intentar eliminar desde la pestaña activa
        if (tab1Active && typeof window.m11_eliminarTab1 === 'function') {
          console.log("Eliminando desde Tab1");
          return window.m11_eliminarTab1();
        }
        
        if (tab2Active && typeof window.m11_eliminarTab2 === 'function') {
          console.log("Eliminando desde Tab2");
          return window.m11_eliminarTab2();
        }
        
        if (typeof window.m11_eliminar === 'function') {
          console.log("Eliminando con m11_eliminar");
          return window.m11_eliminar();
        }
        
        // Si no hay función específica, mostrar mensaje
        if (typeof jsp_alerta === 'function') {
          jsp_alerta('A', 'Función de eliminación no disponible en esta pestaña.');
        } else {
          alert('Función de eliminación no disponible en esta pestaña.');
        }
      }
      
      // Función para habilitar/deshabilitar el botón eliminar
      function habilitarBotonEliminar(habilitar) {
        var btnEliminar = document.getElementById('btnEliminarDesglose');
        if (btnEliminar) {
          btnEliminar.disabled = !habilitar;
          if (habilitar) {
            btnEliminar.title = "Eliminar registro seleccionado";
          } else {
            btnEliminar.title = "Seleccione un registro para eliminar";
          }
        }
      }

      // Exponer funciones globalmente
      window.aceptarDesglose = aceptarDesglose;
      window.cancelarDesglose = cancelarDesglose;
      window.eliminarDesglose = eliminarDesglose;
      window.habilitarBotonEliminar = habilitarBotonEliminar;
      window.volverDesglose = volverDesglose;
    </script>
  </div>
</body>
</html>
