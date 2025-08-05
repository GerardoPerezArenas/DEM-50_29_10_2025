<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>

<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@page import="es.altia.common.service.config.Config"%>
<%@page import="es.altia.common.service.config.ConfigServiceHelper"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="java.text.DateFormat" %>
<%@page import="java.text.SimpleDateFormat" %>
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

    //Clase para internacionalizar los mensajes de la aplicación.
    MeLanbide11I18n meLanbide11I18n = MeLanbide11I18n.getInstance();
    String numExpediente = (String)request.getAttribute("numExp");
    
%>
<jsp:useBean id="descriptor" scope="request" class="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean"  type="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean" />
<jsp:setProperty name="descriptor"  property="idi_cod" value="<%=idioma%>" />
<jsp:setProperty name="descriptor"  property="apl_cod" value="<%=apl%>" />
<link rel="StyleSheet" media="screen" type="text/css" href="<%=request.getContextPath()%><%=css%>"/>
<script type="text/javascript">

    function pulsarNuevoMinimis() {
        lanzarPopUpModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarNuevaMinimis&tipo=0&numExp=<%=numExpediente%>&nuevo=1', 750, 1200, 'no', 'no', function (result) {
            if (result != undefined) {
                if (result[0] == '0') {
                    recargarTablaMinimis(result);
                }
            }
        });
    }

    function pulsarModificarMinimis() {
        if (tablaMinimis.selectedIndex != -1) {
            lanzarPopUpModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarModificarMinimis&tipo=0&nuevo=0&numExp=<%=numExpediente%>&id=' + listaMinimis[tablaMinimis.selectedIndex][0], 750, 1200, 'no', 'no', function (result) {
                if (result != undefined) {
                    if (result[0] == '0') {
                        recargarTablaMinimis(result);
                    }
                }
            });
        } else {
            jsp_alerta('A', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.msjNoSelecFila")%>');
        }
    }

    function pulsarEliminarMinimis() {
        if (tablaMinimis.selectedIndex != -1) {
            var resultado = jsp_alerta('', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.preguntaEliminar")%>');
            if (resultado == 1) {

                var ajax = getXMLHttpRequest();
                var nodos = null;
                var CONTEXT_PATH = '<%=request.getContextPath()%>'
                var url = CONTEXT_PATH + "/PeticionModuloIntegracion.do";
                var parametros = "";
                parametros = 'tarea=preparar&modulo=MELANBIDE11&operacion=eliminarMinimis&tipo=0&numExp=<%=numExpediente%>&id=' + listaMinimis[tablaMinimis.selectedIndex][0];
                try {
                    ajax.open("POST", url, false);
                    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                    ajax.setRequestHeader("Accept", "text/xml, application/xml, text/plain");
                    ajax.send(parametros);
                    if (ajax.readyState == 4 && ajax.status == 200) {
                        var xmlDoc = null;
                        if (navigator.appName.indexOf("Internet Explorer") != -1) {
                            // En IE el XML viene en responseText y no en la propiedad responseXML
                            var text = ajax.responseText;
                            xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                            xmlDoc.async = "false";
                            xmlDoc.loadXML(text);
                        } else {
                            // En el resto de navegadores el XML se recupera de la propiedad responseXML
                            xmlDoc = ajax.responseXML;
                        }//if(navigator.appName.indexOf("Internet Explorer")!=-1)
                    }//if (ajax.readyState==4 && ajax.status==200)

                    nodos = xmlDoc.getElementsByTagName("RESPUESTA");
                    var listaMinimisNueva = extraerListaMinimis(nodos);
                    var codigoOperacion = listaMinimisNueva[0];

                    if (codigoOperacion == "0") {
                        recargarTablaMinimis(listaMinimisNueva);
                    } else if (codigoOperacion == "1") {
                        jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorBD")%>');
                    } else if (codigoOperacion == "2") {
                        jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
                    } else if (codigoOperacion == "3") {
                        jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.pasoParametros")%>');
                    } else {
                        jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
                    }//if(
                } catch (Err) {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
                }//try-catch
            }
        } else {
            jsp_alerta('A', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.msjNoSelecFila")%>');
        }
    }

    function extraerListaMinimis(nodos) {

        var elemento = nodos[0];
        var hijos = elemento.childNodes;
        var codigoOperacion = null;
        var listaNueva = new Array();
        var fila = new Array();
        var nodoFila;
        var hijosFila;
        for (j = 0; hijos != null && j < hijos.length; j++) {
            if (hijos[j].nodeName == "CODIGO_OPERACION") {
                codigoOperacion = hijos[j].childNodes[0].nodeValue;
                listaNueva[j] = codigoOperacion;
            }//if(hijos[j].nodeName=="CODIGO_OPERACION")                      
            else if (hijos[j].nodeName == "FILA") {
                nodoFila = hijos[j];
                hijosFila = nodoFila.childNodes;
                for (var cont = 0; cont < hijosFila.length; cont++) {
                    if (hijosFila[cont].nodeName == "ID") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[0] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[0] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "ESTADO") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[1] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[1] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "ORGANISMO") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[2] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[2] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "OBJETO") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[3] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[3] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "IMPORTE") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[4] = hijosFila[cont].childNodes[0].nodeValue;
                            var tex = fila[4].toString();
                            tex = tex.replace(".", ",");
                            fila[4] = tex;
                        } else {
                            fila[4] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "FECHA") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[5] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[5] = '-';
                        }
                    }
                }
                listaNueva[j] = fila;
                fila = new Array();
            }
        }//for(j=0;hijos!=null && j<hijos.length;j++)

        return listaNueva;
    }

    function recargarTablaMinimis(result) {
        var fila;
        listaMinimis = new Array();
        listaMinimisTabla = new Array();
        for (var i = 1; i < result.length; i++) {
            fila = result[i];
            listaMinimis[i - 1] = [fila[0], fila[1], fila[2], fila[3], fila[4], fila[5]];
            listaMinimisTabla[i - 1] = [fila[0], fila[1], fila[2], fila[3], fila[4], fila[5]];
        }

        inicializarTabla();
        tablaMinimis.lineas = listaMinimisTabla;
        tablaMinimis.displayTabla();
    }

    function dblClckTablaMinimis(rowID, tableName) {
        pulsarModificarMinimis();
    }

    function inicializarTabla() {
        tablaMinimis = new FixedColumnTable(document.getElementById('listaMinimis'), 1600, 1650, 'listaMinimis');

        tablaMinimis.addColumna('50', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"minimis.tablaMinimis.id")%>");
        tablaMinimis.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"minimis.tablaMinimis.estado")%>");
        tablaMinimis.addColumna('400', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"minimis.tablaMinimis.organismo")%>");
        tablaMinimis.addColumna('820', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"minimis.tablaMinimis.objeto")%>");
        tablaMinimis.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"minimis.tablaMinimis.importe")%>");
        tablaMinimis.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"minimis.tablaMinimis.fecha")%>");

        tablaMinimis.displayCabecera = true;
        tablaMinimis.height = 360;
        tablaMinimis.altoCabecera = 40;
        tablaMinimis.scrollWidth = 5670;
        tablaMinimis.dblClkFunction = 'dblClckTablaMinimis';
        tablaMinimis.displayTabla();
        tablaMinimis.pack();
    }


</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/jquery/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/extension/melanbide11/melanbide11.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/validaciones.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/popup.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/FixedColumnsTable.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/meLanbide11/JavaScriptUtil.js"></script>
<script type="text/javascript">
    var APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
</script>

<div class="tab-page" id="tabPage112" style="height:520px; width: 100%;">
    <h2 class="tab" id="pestana112"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.titulo.pestanaSub")%></h2> 
    <script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage112"));</script>
    <br/>
    <h2 class="legendAzul" id="pestanaPrinc"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.tituloMinimis")%></h2>
    <div>    
        <br>
        <div id="divGeneral">     
            <div id="listaMinimis"  align="center"></div>
        </div>
        <br/><br>
        <div class="botonera" style="text-align: center;">
            <input type="button" id="btnNuevoMinimis" name="btnNuevoMinimis" class="botonGeneral"  value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.nuevo")%>" onclick="pulsarNuevoMinimis();">
            <input type="button" id="btnModificarMinimis" name="btnModificarMinimis" class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.modificar")%>" onclick="pulsarModificarMinimis();">
            <input type="button" id="btnEliminarMinimis" name="btnEliminarMinimis"   class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.eliminar")%>" onclick="pulsarEliminarMinimis();">
        </div>
    </div>  
</div>
<script  type="text/javascript">

    var tablaMinimis;
    var listaMinimis = new Array();
    var listaMinimisTabla = new Array();

    inicializarTabla();

    <%  		
            MinimisVO objectVO = null;
            List<MinimisVO> List = null;
            if(request.getAttribute("listaMinimis")!=null){
                List = (List<MinimisVO>)request.getAttribute("listaMinimis");
            }													
            if (List!= null && List.size() >0){
                for (int indice=0;indice<List.size();indice++)
                {
                    objectVO = List.get(indice);
                    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    
                    String estado="";
                    if(objectVO.getDesEstado()!=null){
                        String descripcion = objectVO.getDesEstado();
                        
                        String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                        String[] descripcionDobleIdioma = (descripcion!=null?descripcion.split(barraSeparadoraDobleIdiomaDesple):null);
                        if(descripcionDobleIdioma!=null && descripcionDobleIdioma.length>1){
                            if(idiomaUsuario==ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA){
                                descripcion=descripcionDobleIdioma[1];
                            }else{
                                // Cogemos la primera posición que debería ser castellano
                                descripcion=descripcionDobleIdioma[0];
                            }
                        }
                        estado = descripcion;
                    }else{
                        estado="-";
                    }
                    
                    String organismo="";
                    if(objectVO.getOrganismo()!=null){
                        organismo=objectVO.getOrganismo();
                    }else{
                        organismo="-";
                    }
                    String objeto="";
                    if(objectVO.getObjeto()!=null){
                        objeto=objectVO.getObjeto();
                    }else{
                        objeto="-";
                    }
                    String importe="";
                    if(objectVO.getImporte()!=null){
                        importe=String.valueOf((objectVO.getImporte().toString()).replace(".",","));
                    }else{
                        importe="-";
                    }
                    String fecha="";
                    if(objectVO.getFecha()!=null){
                        fecha=dateFormat.format(objectVO.getFecha());
                    }else{
                        fecha="-";
                    }

    %>
    listaMinimis[<%=indice%>] = ['<%=objectVO.getId()%>', '<%=estado%>', '<%=organismo%>', '<%=objeto%>', '<%=importe%>', '<%=fecha%>'];
    listaMinimisTabla[<%=indice%>] = ['<%=objectVO.getId()%>', '<%=estado%>', '<%=organismo%>', '<%=objeto%>', '<%=importe%>', '<%=fecha%>'];
    <%
                }// for
            }// if
    %>

    tablaMinimis.lineas = listaMinimisTabla;
    tablaMinimis.displayTabla();

</script>
<div id="popupcalendar" class="text"></div>                

