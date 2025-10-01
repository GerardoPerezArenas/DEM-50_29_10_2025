<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>

<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@page import="es.altia.common.service.config.Config"%>
<%@page import="es.altia.common.service.config.ConfigServiceHelper"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesgloseRSBVO"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%
    int idiomaUsuario = 1;
    if(request.getParameter("idioma") != null)
    {
        try
        {
            idiomaUsuario = Integer.parseInt(request.getParameter("idioma"));
        }
        catch(Exception ex)
        {}
    }

    UsuarioValueObject usuarioVO = new UsuarioValueObject();
    int idioma = 1;
    int apl = 5;
    String css = "";
    if (session.getAttribute("usuario") != null) {
        usuarioVO = (UsuarioValueObject) session.getAttribute("usuario");
        apl = usuarioVO.getAppCod();
        idioma = usuarioVO.getIdioma();
        css = usuarioVO.getCss();
    }

    MeLanbide11I18n meLanbide11I18n = MeLanbide11I18n.getInstance();
    String numExpediente = (String)request.getAttribute("numExp");
%>

<jsp:useBean id="descriptor" scope="request" class="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean"  type="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean" />
<jsp:setProperty name="descriptor"  property="idi_cod" value="<%=idioma%>" />
<jsp:setProperty name="descriptor"  property="apl_cod" value="<%=apl%>" />
<link rel="StyleSheet" media="screen" type="text/css" href="<%=request.getContextPath()%><%=css%>"/>

<script type="text/javascript">
    
function pulsarNuevoRSB() {
    lanzarPopUpModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarNuevaRSB&tipo=0&numExp=<%=numExpediente%>&nuevo=1', 750, 1200, 'no', 'no', function (result) {
        if (result != undefined) { if (result[0] == '0') { recargarTablaRSB(result); } }
    });
}

function pulsarModificarRSB() {
    if (tablaRSB.selectedIndex != -1) {
        lanzarPopUpModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarModificarRSB&tipo=0&nuevo=0&numExp=<%=numExpediente%>&id=' + listaRSB[tablaRSB.selectedIndex][0], 750, 1200, 'no', 'no', function (result) {
            if (result != undefined) { if (result[0] == '0') { recargarTablaRSB(result); } }
        });
    } else {
        jsp_alerta('A', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.msjNoSelecFila")%>');
    }
}

function pulsarEliminarRSB() {
    if (tablaRSB.selectedIndex != -1) {
        var resultado = jsp_alerta('', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.preguntaEliminar")%>');
        if (resultado == 1) {
            var ajax = getXMLHttpRequest();
            var CONTEXT_PATH = '<%=request.getContextPath()%>';
            var url = CONTEXT_PATH + "/PeticionModuloIntegracion.do";
            var parametros = 'tarea=preparar&modulo=MELANBIDE11&operacion=eliminarRSB&tipo=0&numExp=<%=numExpediente%>&id=' + listaRSB[tablaRSB.selectedIndex][0];
            try {
                ajax.open("POST", url, false);
                ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                ajax.setRequestHeader("Accept", "text/xml, application/xml, text/plain");
                ajax.send(parametros);
                if (ajax.readyState == 4 && ajax.status == 200) {
                    var xmlDoc = null;
                    if (navigator.appName.indexOf("Internet Explorer") != -1) {
                        var text = ajax.responseText;
                        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                        xmlDoc.async = "false";
                        xmlDoc.loadXML(text);
                    } else {
                        xmlDoc = ajax.responseXML;
                    }
                }
                var nodos = xmlDoc.getElementsByTagName("RESPUESTA");
                var listaNueva = extraerListaRSB(nodos);
                var codigoOperacion = listaNueva[0];
                if (codigoOperacion == "0") {
                    recargarTablaRSB(listaNueva);
                } else if (codigoOperacion == "1") {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorBD")%>');
                } else if (codigoOperacion == "2") {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
                } else if (codigoOperacion == "3") {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.pasoParametros")%>');
                } else {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
                }
            } catch (Err) {
                jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
            }
        }
    } else {
        jsp_alerta('A', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.msjNoSelecFila")%>');
    }
}

function extraerListaRSB(nodos) {
    var elemento = nodos[0];
    var hijos = elemento.childNodes;
    var listaNueva = new Array();
    var fila = new Array();
    var codigoOperacion = null;

    for (j = 0; hijos != null && j < hijos.length; j++) {
        if (hijos[j].nodeName == "CODIGO_OPERACION") {
            codigoOperacion = hijos[j].childNodes[0].nodeValue;
            listaNueva[j] = codigoOperacion;
        } else if (hijos[j].nodeName == "FILA") {
            var hijosFila = hijos[j].childNodes;
            for (var c = 0; c < hijosFila.length; c++) {
                if (hijosFila[c].nodeName == "ID") {
                    fila[0] = (hijosFila[c].childNodes.length > 0) ? hijosFila[c].childNodes[0].nodeValue : '-';
                } else if (hijosFila[c].nodeName == "TIPO") { // descripcion ya traducida
                    fila[1] = (hijosFila[c].childNodes.length > 0) ? hijosFila[c].childNodes[0].nodeValue : '-';
                } else if (hijosFila[c].nodeName == "CONCEPTO") {
                    fila[2] = (hijosFila[c].childNodes.length > 0) ? hijosFila[c].childNodes[0].nodeValue : '-';
                } else if (hijosFila[c].nodeName == "IMPORTE") {
                    if (hijosFila[c].childNodes.length > 0) {
                        var tex = hijosFila[c].childNodes[0].nodeValue;
                        tex = tex.toString().replace(".", ",");
                        fila[3] = tex;
                    } else {
                        fila[3] = '-';
                    }
                } else if (hijosFila[c].nodeName == "OBSERVACIONES") {
                    fila[4] = (hijosFila[c].childNodes.length > 0) ? hijosFila[c].childNodes[0].nodeValue : '-';
                }
            }
            listaNueva[j] = fila;
            fila = new Array();
        }
    }
    return listaNueva;
}

function recargarTablaRSB(result) {
    var fila;
    listaRSB = new Array();
    listaRSBTabla = new Array();
    for (var i = 1; i < result.length; i++) {
        fila = result[i];
        // [ID, TIPO(desc), CONCEPTO(desc), IMPORTE, OBS]
        listaRSB[i - 1] = [fila[0], fila[1], fila[2], fila[3], fila[4]];
        listaRSBTabla[i - 1] = [fila[0], fila[1], fila[2], fila[3], fila[4]];
    }
    inicializarTablaRSB();
    tablaRSB.lineas = listaRSBTabla;
    tablaRSB.displayTabla();
}

function dblClckTablaRSB(rowID, tableName) { pulsarModificarRSB(); }

function inicializarTablaRSB() {
    tablaRSB = new FixedColumnTable(document.getElementById('listaRSB'), 1600, 1650, 'listaRSB');
    tablaRSB.addColumna('60',  'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"rsb.tabla.id")%>");
    tablaRSB.addColumna('300', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"rsb.tabla.tipo")%>");
    tablaRSB.addColumna('300', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"rsb.tabla.concepto")%>");
    tablaRSB.addColumna('120', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"rsb.tabla.importe")%>");
    tablaRSB.addColumna('820', 'left',   "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"rsb.tabla.observaciones")%>");
    tablaRSB.displayCabecera = true;
    tablaRSB.height = 360;
    tablaRSB.altoCabecera = 40;
    tablaRSB.scrollWidth = 5670;
    tablaRSB.dblClkFunction = 'dblClckTablaRSB';
    tablaRSB.displayTabla();
    tablaRSB.pack();
}
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/jquery/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/extension/melanbide11/melanbide11.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/validaciones.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/popup.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/FixedColumnsTable.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/JavaScriptUtil.js"></script>
<script type="text/javascript"> var APP_CONTEXT_PATH = '<%=request.getContextPath()%>'; </script>

<div class="tab-page" id="tabPage113" style="height:520px; width: 100%;">
    <h2 class="tab" id="pestana113"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.titulo.pestanaDesgloseRSB")%></h2>
    <script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage113"));</script>
    <br/>
    <h2 class="legendAzul" id="pestanaPrincRSB"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.tituloDesgloseRSB")%></h2>
    <div>
        <br>
        <div id="divGeneralRSB">
            <div id="listaRSB" align="center"></div>
        </div>
        <br/><br>
        <div class="botonera" style="text-align: center;">
            <input type="button" id="btnNuevoRSB" name="btnNuevoRSB" class="botonGeneral"  value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.nuevo")%>" onclick="pulsarNuevoRSB();">
            <input type="button" id="btnModificarRSB" name="btnModificarRSB" class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.modificar")%>" onclick="pulsarModificarRSB();">
            <input type="button" id="btnEliminarRSB" name="btnEliminarRSB"   class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.eliminar")%>" onclick="pulsarEliminarRSB();">
        </div>
    </div>
</div>

<script type="text/javascript">
var tablaRSB;
var listaRSB = new Array();
var listaRSBTabla = new Array();

inicializarTablaRSB();

<%
    DesgloseRSBVO objectVO = null;
    List<DesgloseRSBVO> List = null;
    if(request.getAttribute("listaRSB")!=null){
        List = (List<DesgloseRSBVO>)request.getAttribute("listaRSB");
    }
    if (List!= null && List.size() > 0){
        for (int indice=0; indice<List.size(); indice++){
            objectVO = List.get(indice);

            // Tipo
            String tipo = "-";
            if(objectVO.getDesRsbTipo()!=null){
                String descripcion = objectVO.getDesRsbTipo();
                String barra = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] dd = (descripcion!=null?descripcion.split(barra):null);
                if(dd!=null && dd.length>1){
                    if(idiomaUsuario==ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA){ descripcion=dd[1]; } else { descripcion=dd[0]; }
                }
                tipo = descripcion;
            }

            // Concepto
            String concepto = "-";
            if(objectVO.getDesRsbConcepto()!=null){
                String descripcion = objectVO.getDesRsbConcepto();
                String barra = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] dd = (descripcion!=null?descripcion.split(barra):null);
                if(dd!=null && dd.length>1){
                    if(idiomaUsuario==ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA){ descripcion=dd[1]; } else { descripcion=dd[0]; }
                }
                concepto = descripcion;
            }

            // Importe
            String importe = "-";
            if(objectVO.getRsbImporte()!=null){
                importe = String.valueOf(objectVO.getRsbImporte().toString().replace(".",","));
            }

            // Observaciones
            String observ = (objectVO.getRsbObserv()!=null ? objectVO.getRsbObserv() : "-");
%>
listaRSB[<%=indice%>] = ['<%=objectVO.getId()%>', '<%=tipo%>', '<%=concepto%>', '<%=importe%>', '<%=observ.replace("'", "\\'")%>'];
listaRSBTabla[<%=indice%>] = ['<%=objectVO.getId()%>', '<%=tipo%>', '<%=concepto%>', '<%=importe%>', '<%=observ.replace("'", "\\'")%>'];
<%
        }
    }
%>

tablaRSB.lineas = listaRSBTabla;
tablaRSB.displayTabla();
</script>
<div id="popupcalendar" class="text"></div>
