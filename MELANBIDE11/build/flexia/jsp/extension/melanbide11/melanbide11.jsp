<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>

<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@page import="es.altia.common.service.config.Config"%>
<%@page import="es.altia.common.service.config.ConfigServiceHelper"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="java.text.DateFormat" %>
<%@page import="java.text.SimpleDateFormat" %>

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
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
    function pulsarNuevaContratacion() {
        lanzarPopUpModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarNuevaContratacion&tipo=0&numExp=<%=numExpediente%>&nuevo=1', 750, 1200, 'no', 'no', function (result) {
            if (result != undefined) {
                if (result[0] == '0') {
                    recargarTablaContrataciones(result);
                }
            }
        });
    }

    function pulsarModificarContratacion() {
        if (tabaAccesos.selectedIndex != -1) {
            lanzarPopUpModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarModificarContratacion&tipo=0&nuevo=0&numExp=<%=numExpediente%>&id=' + listaAccesos[tabaAccesos.selectedIndex][0], 750, 1200, 'no', 'no', function (result) {
                if (result != undefined) {
                    if (result[0] == '0') {
                        recargarTablaContrataciones(result);
                    }
                }
            });
        } else {
            jsp_alerta('A', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.msjNoSelecFila")%>');
        }
    }

    function pulsarEliminarContratacion() {
        if (tabaAccesos.selectedIndex != -1) {
            var resultado = jsp_alerta('', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.preguntaEliminar")%>');
            if (resultado == 1) {

                var ajax = getXMLHttpRequest();
                var nodos = null;
                var CONTEXT_PATH = '<%=request.getContextPath()%>';
                var url = CONTEXT_PATH + "/PeticionModuloIntegracion.do";
                var parametros = "";
                parametros = 'tarea=preparar&modulo=MELANBIDE11&operacion=eliminarContratacion&tipo=0&numExp=<%=numExpediente%>&id=' + listaAccesos[tabaAccesos.selectedIndex][0];
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
                    var listaContratacionesNueva = extraerListaContrataciones(nodos);
                    var codigoOperacion = listaContratacionesNueva[0];

                    if (codigoOperacion == "0") {
                        recargarTablaContrataciones(listaContratacionesNueva);
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

    function extraerListaContrataciones(nodos) {
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
                    } else if (hijosFila[cont].nodeName == "NOFECONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[1] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[1] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "IDCONT1") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[2] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[2] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "IDCONT2") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[3] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[3] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "DNICONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[4] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[4] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "NOMCONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[5] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[5] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "APE1CONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[6] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[6] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "APE2CONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[7] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[7] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "FECHNACCONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[8] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[8] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "EDADCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[9] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[9] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "SEXOCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[10] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[10] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "MAY55CONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[11] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[11] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "ACCFORCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[12] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[12] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "CODFORCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[13] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[13] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "DENFORCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[14] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[14] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "PUESTOCONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[15] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[15] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "CODOCUCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[16] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[16] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "OCUCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[17] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[17] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "DESTITULACION") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[18] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[18] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "TITULACION") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[19] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[19] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "CPROFESIONALIDAD") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[20] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[20] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "MODCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[21] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[21] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "JORCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[22] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[22] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "PORCJOR") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[23] = hijosFila[cont].childNodes[0].nodeValue;
                            var tex = fila[23].toString();
                            tex = tex.replace(".", ",");
                            fila[23] = tex;
                        } else {
                            fila[23] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "HORASCONV") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[24] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[24] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "FECHINICONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[25] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[25] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "FECHFINCONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[26] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[26] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "DURCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[27] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[27] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "GRSS") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[28] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[28] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "DIRCENTRCONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[29] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[29] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "NSSCONT") {
                        if (hijosFila[cont].childNodes.length > 0) {
                            fila[30] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[30] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "CSTCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[31] = hijosFila[cont].childNodes[0].nodeValue;
                            var tex = fila[31].toString();
                            tex = tex.replace(".", ",");
                            fila[31] = tex;
                        } else {
                            fila[31] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "TIPRSB") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[32] = hijosFila[cont].childNodes[0].nodeValue;
                        } else {
                            fila[32] = '-';
                        }
                    } else if (hijosFila[cont].nodeName == "IMPSUBVCONT") {
                        if (hijosFila[cont].childNodes[0].nodeValue != "null") {
                            fila[33] = hijosFila[cont].childNodes[0].nodeValue;
                            var tex = fila[33].toString();
                            tex = tex.replace(".", ",");
                            fila[33] = tex;
                        } else {
                            fila[33] = '-';
                        }
                    }
                }
                listaNueva[j] = fila;
                fila = new Array();
            }
        }//for(j=0;hijos!=null && j<hijos.length;j++)

        return listaNueva;
    }

    function recargarTablaContrataciones(result) {
        var fila;
        listaAccesos = new Array();
        listaAccesosTabla = new Array();
        for (var i = 1; i < result.length; i++) {
            fila = result[i];
            listaAccesos[i - 1] = [fila[0], fila[1], fila[2], fila[3], fila[4], fila[5], fila[6], fila[7], fila[8], fila[9], fila[10], fila[11], fila[12],
                fila[13], fila[14], fila[15], fila[16], fila[17], fila[18], fila[19], fila[20], fila[21], fila[22], fila[23], fila[24], fila[25], fila[26], fila[27], fila[28], fila[29], fila[30], fila[31], fila[32], fila[33]];
            listaAccesosTabla[i - 1] = [fila[0], fila[1], fila[2], fila[3], fila[4], fila[5], fila[6], fila[7], fila[8], fila[9], fila[10], fila[11], fila[12],
                fila[13], fila[14], fila[15], fila[16], fila[17], fila[18], fila[19], fila[20], fila[21], fila[22], fila[23], fila[24], fila[25], fila[26], fila[27], fila[28], fila[29], fila[30], fila[31], fila[32], fila[33]];
        }

        inicializarTabla();
        tabaAccesos.lineas = listaAccesosTabla;
        tabaAccesos.displayTabla();
    }

    function dblClckTablaContrataciones(rowID, tableName) {
        pulsarModificarContratacion();
    }

    function inicializarTabla() {
        tabaAccesos = new FixedColumnTable(document.getElementById('listaAccesos'), 1600, 1650, 'listaAccesos');

        tabaAccesos.addColumna('50', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.id")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.nOferta")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.idContratoOferta")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.idContratoDirecto")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.dni_nie")%>");
        tabaAccesos.addColumna('200', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.nombre")%>");
        tabaAccesos.addColumna('200', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.apellido1")%>");
        tabaAccesos.addColumna('200', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.apellido2")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.fechaNacimiento")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.edad")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.sexo")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.may55")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.finFormativa")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.codFormativa")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.denFormativa")%>");
        tabaAccesos.addColumna('200', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.puesto")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.codOcupacion")%>");
        tabaAccesos.addColumna('330', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.ocupacion")%>");
        tabaAccesos.addColumna('330', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.desTitulacion")%>");
        tabaAccesos.addColumna('330', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.titulacion")%>");
        tabaAccesos.addColumna('330', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.cProfesionalidad")%>");
        tabaAccesos.addColumna('150', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.modalidadContrato")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.jornada")%>");
        tabaAccesos.addColumna('50', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.porcJornada")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.horasConv")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.fechaInicio")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.fechaFin")%>");
        tabaAccesos.addColumna('50', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.mesesContrato")%>");
        tabaAccesos.addColumna('350', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.grupoCotizacion")%>");
        tabaAccesos.addColumna('250', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.direccionCT")%>");
        tabaAccesos.addColumna('100', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.nSS")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.costeContrato")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.tipRetribucion")%>");
        tabaAccesos.addColumna('70', 'center', "<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.importeSub")%>");

        //tabaAccesos.numColumnasFijas = 3;              
        tabaAccesos.displayCabecera = true;
        tabaAccesos.height = 360;
        tabaAccesos.altoCabecera = 40;
        tabaAccesos.scrollWidth = 5670;
        tabaAccesos.dblClkFunction = 'dblClckTablaContrataciones';
        tabaAccesos.displayTabla();
        tabaAccesos.pack();
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
<!-- Eventos onKeyPress compatibilidad firefox  -->
<!--<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.4.js"></script>-->
<div class="tab-page" id="tabPage111" style="height:520px; width: 100%;">
    <h2 class="tab" id="pestana111"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.titulo.pestana")%></h2> 
    <script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage111"));</script>
    <br/>
    <h2 class="legendAzul" id="pestanaPrinc"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.tituloPrincipal")%></h2>
    <div>    
        <br>
        <div id="divGeneral">     
            <div id="listaAccesos"  align="center"></div>
        </div>
        <br/><br>
        <div class="botonera" style="text-align: center;">
            <input type="button" id="btnNuevoAcceso" name="btnNuevoAcceso" class="botonGeneral"  value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.nuevo")%>" onclick="pulsarNuevaContratacion();">
            <input type="button" id="btnModificarAcceso" name="btnModificarAcceso" class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.modificar")%>" onclick="pulsarModificarContratacion();">
            <input type="button" id="btnEliminarAcceso" name="btnEliminarAcceso"   class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.eliminar")%>" onclick="pulsarEliminarContratacion();">
        </div>
    </div>  
</div>
<script  type="text/javascript">
    var tabaAccesos;
    var listaAccesos = new Array();
    var listaAccesosTabla = new Array();

    inicializarTabla();

    <%  		
            ContratacionVO objectVO = null;
            List<ContratacionVO> List = null;
            if(request.getAttribute("listaAccesos")!=null){
                List = (List<ContratacionVO>)request.getAttribute("listaAccesos");
            }													
            if (List!= null && List.size() >0){
                for (int indice=0;indice<List.size();indice++)
                {
                    objectVO = List.get(indice);
                    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    
                    String oferta="";
                    if(objectVO.getOferta()!=null){
                        oferta=objectVO.getOferta();
                    }else{
                        oferta="-";
                    }
                    String idContrato1="";
                    if(objectVO.getIdContrato1()!=null){
                        idContrato1=objectVO.getIdContrato1();
                    }else{
                        idContrato1="-";
                    }
                    String idContrato2="";
                    if(objectVO.getIdContrato2()!=null){
                        idContrato2=objectVO.getIdContrato2();
                    }else{
                        idContrato2="-";
                    }
                    
                    String dni="";
                    if(objectVO.getDni()!=null){
                        dni=objectVO.getDni();
                    }else{
                        dni="-";
                    }
                    String nombre="";
                    if(objectVO.getNombre()!=null){
                        nombre=objectVO.getNombre();
                    }else{
                        nombre="-";
                    }
                    String apellido1="";
                    if(objectVO.getApellido1()!=null){
                        apellido1=objectVO.getApellido1();
                    }else{
                        apellido1="-";
                    }
                    String apellido2="";
                    if(objectVO.getApellido2()!=null){
                        apellido2=objectVO.getApellido2();
                    }else{
                        apellido2="-";
                    }
                    String fechaNacimiento="";
                    if(objectVO.getFechaNacimiento()!=null){
                        fechaNacimiento=dateFormat.format(objectVO.getFechaNacimiento());
                    }else{
                        fechaNacimiento="-";
                    }
                    String edad="";
                    if(objectVO.getEdad()!=null && !"".equals(objectVO.getEdad())){
                        edad=Integer.toString(objectVO.getEdad());
                    }else{
                        edad="-";
                    }
                    String sexo="";
                    if(objectVO.getDesSexo()!=null){
                        String descripcion = objectVO.getDesSexo();
                        
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
                        sexo = descripcion;
                    }else{
                        sexo="-";
                    }
                    String mayor55="";
                    if(objectVO.getMayor55()!=null){
                        mayor55=objectVO.getMayor55();
                    }else{
                        mayor55="-";
                    }
                    String finFormativa="";
                    if(objectVO.getFinFormativa()!=null){
                        finFormativa=objectVO.getFinFormativa();
                    }else{
                        finFormativa="-";
                    }
                    String codFormativa="";
                    if(objectVO.getCodFormativa()!=null){
                        codFormativa=objectVO.getCodFormativa();
                    }else{
                        codFormativa="-";
                    }
                    String denFormativa="";
                    if(objectVO.getDenFormativa()!=null){
                        denFormativa=objectVO.getDenFormativa();
                    }else{
                        denFormativa="-";
                    }
                    
                    String puesto="";
                    if(objectVO.getPuesto()!=null){
                        puesto=objectVO.getPuesto();
                    }else{
                        puesto="-";
                    }
                    String codOcupacion="";
                    if(objectVO.getOcupacion()!=null){
                        codOcupacion=objectVO.getOcupacion();
                    }else{
                        codOcupacion="-";
                    }
                    String ocupacion="";
                    if(objectVO.getDesOcupacionLibre()!=null){
                        ocupacion = objectVO.getDesOcupacionLibre();
                    }else{
                        if(objectVO.getDesOcupacion()!=null){
                            ocupacion = objectVO.getDesOcupacion();
                        }else{
                            ocupacion="-";
                        }
                    }
                    String desTitulacion="";
                    if(objectVO.getDesTitulacionLibre()!=null){
                        desTitulacion = objectVO.getDesTitulacionLibre();
                    }else{
                        desTitulacion="-";
                    }
                    String titulacion="";
                    if(objectVO.getDesTitulacion()!=null){
                        titulacion = objectVO.getDesTitulacion();
                    }else{
                        titulacion="-";
                    }
                    String cProfesionalidad="";
                    if(objectVO.getDesCProfesionalidad()!=null){
                        cProfesionalidad = objectVO.getDesCProfesionalidad();
                    }else{
                        cProfesionalidad="-";
                    }
                    String modalidadContrato="";
                    if(objectVO.getModalidadContrato()!=null){
                        modalidadContrato=objectVO.getModalidadContrato();
                    }else{
                        modalidadContrato="-";
                    }
                    String jornada="";
                    if(objectVO.getDesJornada()!=null){
                        String descripcion = objectVO.getDesJornada();
                        
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
                        jornada = descripcion;
                    }else{
                        jornada="-";
                    }
                    String porcJornada="";
                    if(objectVO.getPorcJornada()!=null){
                        porcJornada=String.valueOf((objectVO.getPorcJornada().toString()).replace(".",","));
                    }else{
                        porcJornada="-";
                    }
                    String horasConv="";
                    if(objectVO.getHorasConv()!=null && !"".equals(objectVO.getHorasConv())){
                        horasConv=Integer.toString(objectVO.getHorasConv());
                    }else{
                        horasConv="-";
                    }
                    String fechaInicio="";
                    if(objectVO.getFechaInicio()!=null){
                        fechaInicio=dateFormat.format(objectVO.getFechaInicio());
                    }else{
                        fechaInicio="-";
                    }
                    String fechaFin="";
                    if(objectVO.getFechaFin()!=null){
                        fechaFin=dateFormat.format(objectVO.getFechaFin());
                    }else{
                        fechaFin="-";
                    }
                    String mesesContrato="";
                    if(objectVO.getMesesContrato()!=null && !"".equals(objectVO.getMesesContrato()) && !"0".equals(objectVO.getMesesContrato())){
                        mesesContrato=objectVO.getMesesContrato();
                    }else{
                        mesesContrato="-";
                    }
                    String grupoCotizacion="";
                    if(objectVO.getDesGrupoCotizacion()!=null){
                        String descripcion = objectVO.getDesGrupoCotizacion();
                        
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
                        grupoCotizacion = descripcion;
                    }else{
                        grupoCotizacion="-";
                    }
                    String direccionCT="";
                    if(objectVO.getDireccionCT()!=null){
                        direccionCT=objectVO.getDireccionCT();
                    }else{
                        direccionCT="-";
                    }
                    String numSS="";
                    if(objectVO.getNumSS()!=null){
                        numSS=objectVO.getNumSS();
                    }else{
                        numSS="-";
                    }
                    String costeContrato="";
                    if(objectVO.getCosteContrato()!=null){
                        costeContrato=String.valueOf((objectVO.getCosteContrato().toString()).replace(".",","));
                    }else{
                        costeContrato="-";
                    }
                    String tipRetribucion="";
                    if(objectVO.getDesTipRetribucion()!=null){
                        String descripcion = objectVO.getDesTipRetribucion();
                        
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
                        tipRetribucion = descripcion;
                    }else{
                        tipRetribucion="-";
                    }
                    
                    String importeSub="";
                    if(objectVO.getImporteSub()!=null){
                        importeSub=String.valueOf((objectVO.getImporteSub().toString()).replace(".",","));
                    }else{
                        importeSub="-";
                    }
        

    %>
    listaAccesos[<%=indice%>] = ['<%=objectVO.getId()%>', '<%=oferta%>', '<%=idContrato1%>', '<%=idContrato2%>', '<%=dni%>',
        '<%=nombre%>', '<%=apellido1%>', '<%=apellido2%>', '<%=fechaNacimiento%>', '<%=edad%>', '<%=sexo%>', '<%=mayor55%>',
        '<%=finFormativa%>', '<%=codFormativa%>', '<%=denFormativa%>', '<%=puesto%>', '<%=codOcupacion%>', '<%=ocupacion%>', '<%=desTitulacion%>', '<%=titulacion%>', '<%=cProfesionalidad%>', '<%=modalidadContrato%>', '<%=jornada%>', '<%=porcJornada%>', '<%=horasConv%>', '<%=fechaInicio%>',
        '<%=fechaFin%>', '<%=mesesContrato%>', '<%=grupoCotizacion%>', '<%=direccionCT%>', '<%=numSS%>', '<%=costeContrato%>', '<%=tipRetribucion%>', '<%=importeSub%>'];
    listaAccesosTabla[<%=indice%>] = ['<%=objectVO.getId()%>', '<%=oferta%>', '<%=idContrato1%>', '<%=idContrato2%>', '<%=dni%>',
        '<%=nombre%>', '<%=apellido1%>', '<%=apellido2%>', '<%=fechaNacimiento%>', '<%=edad%>', '<%=sexo%>', '<%=mayor55%>',
        '<%=finFormativa%>', '<%=codFormativa%>', '<%=denFormativa%>', '<%=puesto%>', '<%=codOcupacion%>', '<%=ocupacion%>', '<%=desTitulacion%>', '<%=titulacion%>', '<%=cProfesionalidad%>', '<%=modalidadContrato%>', '<%=jornada%>', '<%=porcJornada%>', '<%=horasConv%>', '<%=fechaInicio%>',
        '<%=fechaFin%>', '<%=mesesContrato%>', '<%=grupoCotizacion%>', '<%=direccionCT%>', '<%=numSS%>', '<%=costeContrato%>', '<%=tipRetribucion%>', '<%=importeSub%>'];
    <%
                }// for
            }// if
    %>

    tabaAccesos.lineas = listaAccesosTabla;
    tabaAccesos.displayTabla();
</script>
<div id="popupcalendar" class="text"></div>                

