<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld"  prefix="bean"  %>
<%@ taglib uri="/WEB-INF/tlds/c.tld"       prefix="c"     %>

<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@ page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@ page import="es.altia.common.service.config.Config" %>
<%@ page import="es.altia.common.service.config.ConfigServiceHelper" %>
<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO" %>
<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter" %>
<%@ page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%!
private static String escJS(Object v){
    if (v == null) return "-";
    String s = v.toString().trim();
    if (s.isEmpty()) return "-";
    s = s.replace("\\", "\\\\")
         .replace("'", "\\'")
         .replace("\"", "\\\"")
         .replace("\r\n", "\n").replace("\r", "\n").replace("\n", "\\n")
         .replace("</script>", "<\\/script>");
    return s;
}
%>

<%
    int idiomaUsuario = 1;
    if(request.getParameter("idioma") != null) {
        try { idiomaUsuario = Integer.parseInt(request.getParameter("idioma")); } catch(Exception ex){}
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

    // I18n
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
    var __modalCallback = null;

    function abrirModal(url, height, width, scrollbars, resizable, callback) {
        window.__modalCallback = callback;
        lanzarPopUpModal(url, height, width, scrollbars, resizable, callback);
    }

    function normalizarImporteModal(valor) {
        if (valor === undefined || valor === null) {
            return null;
        }
        var numero = valor;
        if (typeof numero === 'string') {
            var tmp = numero.replace(/\s+/g, '');
            if (tmp.indexOf(',') !== -1) {
                tmp = tmp.replace(/\./g, '').replace(',', '.');
            }
            numero = parseFloat(tmp);
        } else if (typeof numero !== 'number') {
            numero = parseFloat(numero);
        }
        if (isNaN(numero)) {
            return null;
        }
        return numero;
    }

    function formatearImporteModal(valor) {
        if (valor === null || valor === undefined || isNaN(valor)) {
            return null;
        }
        var numero = parseFloat(valor);
        if (isNaN(numero)) {
            return null;
        }
        return numero.toFixed(2).replace('.', ',');
    }

    function actualizarImportesContratacion(payload) {
        try {
            if (!payload) {
                return;
            }
            var indiceSeleccionado = (typeof tabaAccesos !== 'undefined' && tabaAccesos && typeof tabaAccesos.selectedIndex === 'number')
                ? tabaAccesos.selectedIndex
                : -1;
            if (indiceSeleccionado < 0) {
                return;
            }
            var rsbValor = normalizarImporteModal(payload.rsbCompConv);
            var costeValor = normalizarImporteModal(payload.cstCont);
            var rsbFormateado = formatearImporteModal(rsbValor);
            var costeFormateado = formatearImporteModal(costeValor);

            console.log('Actualizando importes sin recarga. Índice:', indiceSeleccionado, 'RSB:', rsbFormateado, 'Coste:', costeFormateado);

            if (listaAccesos && listaAccesos[indiceSeleccionado]) {
                if (costeFormateado !== null) {
                    listaAccesos[indiceSeleccionado][31] = costeFormateado;
                }
                if (rsbFormateado !== null) {
                    listaAccesos[indiceSeleccionado][33] = rsbFormateado;
                }
            }
            if (listaAccesosTabla && listaAccesosTabla[indiceSeleccionado]) {
                if (costeFormateado !== null) {
                    listaAccesosTabla[indiceSeleccionado][31] = costeFormateado;
                }
                if (rsbFormateado !== null) {
                    listaAccesosTabla[indiceSeleccionado][33] = rsbFormateado;
                }
            }

            if (typeof tabaAccesos !== 'undefined' && tabaAccesos) {
                var indiceAnterior = tabaAccesos.selectedIndex;
                tabaAccesos.lineas = listaAccesosTabla;
                tabaAccesos.displayTabla();
                if (indiceAnterior >= 0 && typeof seleccionarFila === 'function') {
                    tabaAccesos.selectedIndex = indiceAnterior;
                    seleccionarFila(indiceAnterior, 'listaAccesos');
                }
            }
        } catch (err) {
            console.log('No se pudo actualizar importes sin recargar:', err);
        }
    }

    window.onModalClosed = function (result) {
        try {
            if (result && result.length >= 3 && result[2] === 'DESGLOSE_RSB') {
                actualizarImportesContratacion({
                    rsbCompConv: result.length > 3 ? result[3] : null,
                    cstCont: result.length > 4 ? result[4] : null,
                    idRegistro: result.length > 5 ? result[5] : null
                });
            }
        } catch (errorModal) {
            console.log('Error procesando resultado modal:', errorModal);
        }

        var callback = window.__modalCallback;
        window.__modalCallback = null;
        if (typeof callback === 'function') {
            try {
                callback(result);
            } catch (callbackError) {
                console.log('Error ejecutando callback modal:', callbackError);
            }
        }
    };

    function pulsarNuevaContratacion() {
        abrirModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarNuevaContratacion&tipo=0&numExp=<%=numExpediente%>&nuevo=1', 750, 1200, 'no', 'no', function (result) {
            if (result != undefined) {
                if (result[0] == '0') {
                    recargarTablaContrataciones(result);
                }
            }
        });
    }

    // Navegación a Desglose RSB con selección obligatoria
    function irDesgloseRSB(){
        if (typeof tabaAccesos === 'undefined' || tabaAccesos.selectedIndex == -1){
            jsp_alerta('A','<%=meLanbide11I18n.getMensaje(idiomaUsuario,"msg.msjNoSelecFila")%>');
            return;
        }
        var idLinea = listaAccesos[tabaAccesos.selectedIndex][0];
        var numExp  = '<%=numExpediente%>';
        var url = '<%=request.getContextPath()%>/PeticionModuloIntegracion.do'
                + '?tarea=preparar&modulo=MELANBIDE11&operacion=cargarDesgloseRSB'
                + '&tipo=0&numExp=' + encodeURIComponent(numExp)
                + '&id=' + encodeURIComponent(idLinea);

        abrirModal(url, 900, 1200, 'no', 'no', function(result){
            if (result != undefined) {
                if (result[0] == '0') {
                    console.log("Desglose RSB completado exitosamente");
                    // Nota: tabla CRUD de contrataciones removida, no hay que recargar nada
                }
            }
        });
    }

    function pulsarModificarContratacion() {
        if (tabaAccesos.selectedIndex != -1) {
            abrirModal('<%=request.getContextPath()%>/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=cargarModificarContratacion&tipo=0&nuevo=0&numExp=<%=numExpediente%>&id=' + listaAccesos[tabaAccesos.selectedIndex][0], 750, 1200, 'no', 'no', function (result) {
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
                            var text = ajax.responseText;
                            xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                            xmlDoc.async = "false";
                            xmlDoc.loadXML(text);
                        } else {
                            xmlDoc = ajax.responseXML;
                        }
                    }

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
                    }
                } catch (Err) {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"error.errorGen")%>');
                }
            }
        } else {
            jsp_alerta('A', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.msjNoSelecFila")%>');
        }
    }

    function extraerListaContrataciones(nodos) {
        var elemento = nodos[0];
        var hijos = elemento ? elemento.childNodes : null;
        var listaNueva = ['0']; // [0] = CODIGO_OPERACION

        if (!hijos) return listaNueva;

        for (var j = 0; j < hijos.length; j++) {
            var nodo = hijos[j];

            if (nodo.nodeName === "CODIGO_OPERACION") {
                if (nodo.childNodes.length > 0 && nodo.childNodes[0].nodeValue != null) {
                    listaNueva[0] = nodo.childNodes[0].nodeValue;
                }
            } else if (nodo.nodeName === "FILA") {
                var hijosFila = nodo.childNodes;

                var fila = new Array(37);
                for (var i = 0; i < 37; i++) fila[i] = '-';

                for (var cont = 0; cont < hijosFila.length; cont++) {
                    var celda = hijosFila[cont];
                    var hasVal = celda.childNodes.length > 0 && celda.childNodes[0].nodeValue != null && celda.childNodes[0].nodeValue !== "null";
                    var val = hasVal ? celda.childNodes[0].nodeValue : '-';

                    if (celda.nodeName === "ID") { fila[0] = val;
                    } else if (celda.nodeName === "NOFECONT") { fila[1] = val;
                    } else if (celda.nodeName === "IDCONT1") { fila[2] = val;
                    } else if (celda.nodeName === "IDCONT2") { fila[3] = val;
                    } else if (celda.nodeName === "DNICONT") { fila[4] = val;
                    } else if (celda.nodeName === "NOMCONT") { fila[5] = val;
                    } else if (celda.nodeName === "APE1CONT") { fila[6] = val;
                    } else if (celda.nodeName === "APE2CONT") { fila[7] = val;
                    } else if (celda.nodeName === "FECHNACCONT") { fila[8] = val;
                    } else if (celda.nodeName === "EDADCONT") { fila[9] = val;
                    } else if (celda.nodeName === "SEXOCONT") { fila[10] = val;
                    } else if (celda.nodeName === "MAY55CONT") { fila[11] = val;
                    } else if (celda.nodeName === "ACCFORCONT") { fila[12] = val;
                    } else if (celda.nodeName === "CODFORCONT") { fila[13] = val;
                    } else if (celda.nodeName === "DENFORCONT") { fila[14] = val;
                    } else if (celda.nodeName === "PUESTOCONT") { fila[15] = val;
                    } else if (celda.nodeName === "CODOCUCONT") { fila[16] = val;
                    } else if (celda.nodeName === "OCUCONT") { fila[17] = val;
                    } else if (celda.nodeName === "TITREQPUESTO") { fila[18] = val;
                    } else if (celda.nodeName === "FUNCIONES") { fila[19] = val;
                    } else if (celda.nodeName === "CPROFESIONALIDAD") { fila[20] = val;
                    } else if (celda.nodeName === "MODCONT") { fila[21] = val;
                    } else if (celda.nodeName === "JORCONT") { fila[22] = val;
                    } else if (celda.nodeName === "PORCJOR") { fila[23] = hasVal ? (val.toString().replace(".", ",")) : '-';
                    } else if (celda.nodeName === "HORASCONV") { fila[24] = val;
                    } else if (celda.nodeName === "FECHINICONT") { fila[25] = val;
                    } else if (celda.nodeName === "FECHFINCONT") { fila[26] = val;
                    } else if (celda.nodeName === "DURCONT") { fila[27] = val;
                    } else if (celda.nodeName === "GRSS") { fila[28] = val;
                    } else if (celda.nodeName === "DIRCENTRCONT") { fila[29] = val;
                    } else if (celda.nodeName === "NSSCONT") { fila[30] = val;
                    } else if (celda.nodeName === "CSTCONT") { fila[31] = hasVal ? (val.toString().replace(".", ",")) : '-';
                    } else if (celda.nodeName === "TIPRSB") { fila[32] = val;
                    } else if (celda.nodeName === "RSBCOMPUTABLE") { fila[33] = hasVal ? (val.toString().replace(".", ",")) : '-';
                    } else if (celda.nodeName === "IMPSUBVCONT") { fila[34] = hasVal ? (val.toString().replace(".", ",")) : '-';
                    } else if (celda.nodeName === "DESTITULACION") { fila[35] = val;
                    } else if (celda.nodeName === "TITULACION") { fila[36] = val; }
                }
                listaNueva.push(fila);
            }
        }
        return listaNueva;
    }

    function pulsarListasxProyecto() {
        jsp_alerta('I', 'Funcionalidad de Listas por Proyecto en desarrollo');
    }

    function recargarTablaContrataciones(result) {
        var fila;
        listaAccesos = new Array();
        listaAccesosTabla = new Array();
        for (var i = 1; i < result.length; i++) {
            fila = result[i];
            listaAccesos[i - 1] = [
                fila[0], fila[1], fila[2], fila[3], fila[4], fila[5], fila[6], fila[7], fila[8], fila[9],
                fila[10], fila[11], fila[12], fila[13], fila[14], fila[15], fila[16], fila[17], fila[18], fila[19],
                fila[20], fila[21], fila[22], fila[23], fila[24], fila[25], fila[26], fila[27], fila[28], fila[29],
                fila[30], fila[31], fila[32], fila[33], fila[34], fila[36], fila[35]
            ];
            listaAccesosTabla[i - 1] = [
                fila[0], fila[1], fila[2], fila[3], fila[4], fila[5], fila[6], fila[7], fila[8], fila[9],
                fila[10], fila[11], fila[12], fila[13], fila[14], fila[15], fila[16], fila[17], fila[18], fila[19],
                fila[20], fila[21], fila[22], fila[23], fila[24], fila[25], fila[26], fila[27], fila[28], fila[29],
                fila[30], fila[31], fila[32], fila[33], fila[34], fila[36], fila[35]
            ];
        }

        inicializarTablaContrataciones();
        tabaAccesos.lineas = listaAccesosTabla;
        tabaAccesos.displayTabla();
    }

    function dblClckTablaContrataciones(rowID, tableName) {
        pulsarModificarContratacion();
    }

    function inicializarTablaContrataciones() {
        tabaAccesos = new FixedColumnTable(document.getElementById('listaAccesos'), 1600, 1650, 'listaAccesos');

        tabaAccesos.addColumna('50',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.id")%>');
        tabaAccesos.addColumna('80', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.nOferta")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.idContratoOferta")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.idContratoDirecto")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.dni_nie")%>');
        tabaAccesos.addColumna('150', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.nombre")%>');
        tabaAccesos.addColumna('150', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.apellido1")%>');
        tabaAccesos.addColumna('150', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.apellido2")%>');
        tabaAccesos.addColumna('100',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.fechaNacimiento")%>');
        tabaAccesos.addColumna('60',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.edad")%>');
        tabaAccesos.addColumna('80', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.sexo")%>');
        tabaAccesos.addColumna('80', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.may55")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.finFormativa")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.codFormativa")%>');
        tabaAccesos.addColumna('120', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.denFormativa")%>');
        tabaAccesos.addColumna('180', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.puesto")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.codOcupacion")%>');
        tabaAccesos.addColumna('200', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.ocupacion")%>');

        // Nuevas columnas intermedias
        tabaAccesos.addColumna('180', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.titreqpuesto")%>');
        tabaAccesos.addColumna('200', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.funciones")%>');

        tabaAccesos.addColumna('180', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.cProfesionalidad")%>');
        tabaAccesos.addColumna('130', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.modalidadContrato")%>');
        tabaAccesos.addColumna('90', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.jornada")%>');
        tabaAccesos.addColumna('70',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.porcJornada")%>');
        tabaAccesos.addColumna('90',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.horasConv")%>');
        tabaAccesos.addColumna('100',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.fechaInicio")%>');
        tabaAccesos.addColumna('100',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.fechaFin")%>');
        tabaAccesos.addColumna('70',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.mesesContrato")%>');
        tabaAccesos.addColumna('180', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.grupoCotizacion")%>');
        tabaAccesos.addColumna('150', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.direccionCT")%>');
        tabaAccesos.addColumna('100', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.nSS")%>');
        tabaAccesos.addColumna('100',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.costeContrato")%>');
        tabaAccesos.addColumna('110',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.tipRetribucion")%>');

        // RSB total computable
        tabaAccesos.addColumna('150', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.rsbTotal")%>');

        tabaAccesos.addColumna('150',  'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.importeSub")%>');

        // Históricos al final
        tabaAccesos.addColumna('180', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.titulacion")%>');
        tabaAccesos.addColumna('180', 'center', '<%=meLanbide11I18n.getMensaje(idiomaUsuario,"contratacion.tablaContrataciones.desTitulacion")%>');

        tabaAccesos.displayCabecera = true;
        tabaAccesos.height = 360;
        tabaAccesos.altoCabecera = 40;
        tabaAccesos.scrollWidth = 6070;
        tabaAccesos.dblClkFunction = 'dblClckTablaContrataciones';
        tabaAccesos.displayTabla();
        tabaAccesos.pack();
    }

    /**
     * Función para refrescar la tabla de contrataciones recargando la página completa
     * Llamada desde ventanas modales (ej: m11Desglose_Tab1.jsp) después de guardar
     * 
     * Usamos reload en lugar de AJAX porque:
     * 1. Garantiza que todos los datos estén actualizados
     * 2. Evita problemas de sincronización
     * 3. El servidor ya renderiza la lista completa en el JSP inicial
     */
    function refrescarDatosContratacion() {
        try {
            console.log("Refrescando tabla de contrataciones...");
            // Recargar la página completa para obtener datos frescos del servidor
            window.location.reload();
        } catch (e) {
            console.log("Error al refrescar datos de contrataciones: " + e.message);
        }
    }
    
    /**
     * Función alternativa que recarga solo la tabla sin refrescar toda la página
     * (requiere que exista la función cargarDatosContratacion que haga la petición AJAX)
     */
    function recargarTabla() {
        try {
            console.log("Recargando solo la tabla de contrataciones...");
            if (typeof cargarDatosContratacion === 'function') {
                cargarDatosContratacion();
            } else {
                // Fallback: recargar página completa
                refrescarDatosContratacion();
            }
        } catch (e) {
            console.log("Error al recargar tabla: " + e.message);
            // Fallback: recargar página completa
            refrescarDatosContratacion();
        }
    }
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/jquery/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.js"></script>
<link  rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.css"/>
<link  rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/extension/melanbide11/melanbide11.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/validaciones.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/popup.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/FixedColumnsTable.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/JavaScriptUtil.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/Parsers.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/InputMask.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/lanbide.js"></script>
<script type="text/javascript">
    var APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
</script>

<div class="tab-page" id="tabPage111" style="height:520px; width: 100%;">
    <h2 class="tab" id="pestana111"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.titulo.pestana")%></h2>
    <script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage111"));</script>
    <br/>
    <h2 class="legendAzul" id="pestanaPrinc"><%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.tituloPrincipal")%></h2>
    <div>
        <br>
        <div id="divGeneral">
            <div id="listaAccesos" align="center"></div>
        </div>
        <br/><br>
        <div class="botonera" style="text-align: center;">
            <input type="button" id="btnNuevoAcceso"     name="btnNuevoAcceso"     class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.nuevo")%>"     onclick="pulsarNuevaContratacion();">
            <input type="button" id="btnModificarAcceso" name="btnModificarAcceso" class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.modificar")%>" onclick="pulsarModificarContratacion();">
            <input type="button" id="btnEliminarAcceso"  name="btnEliminarAcceso"  class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.eliminar")%>"  onclick="pulsarEliminarContratacion();">
            <input type="button" id="btnDesgloseRSB" name="btnDesgloseRSB" class="botonEnorme" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "mel11.btn.desgloseRSB")%>" onclick="irDesgloseRSB();">
        </div>
    </div>
</div>

<script type="text/javascript">
    var tabaAccesos;
    var listaAccesos = new Array();
    var listaAccesosTabla = new Array();
    inicializarTablaContrataciones();
</script>


<%
    ContratacionVO objectVO = null;
    List<ContratacionVO> List = null;
    if(request.getAttribute("listaAccesos")!=null){
        List = (List<ContratacionVO>)request.getAttribute("listaAccesos");
    }
    if (List!= null && List.size() >0){
        for (int indice=0;indice<List.size();indice++) {
            objectVO = List.get(indice);
            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

            String oferta = (objectVO.getOferta()!=null) ? objectVO.getOferta() : "-";
            String idContrato1 = (objectVO.getIdContrato1()!=null) ? objectVO.getIdContrato1() : "-";
            String idContrato2 = (objectVO.getIdContrato2()!=null) ? objectVO.getIdContrato2() : "-";
            String dni = (objectVO.getDni()!=null) ? objectVO.getDni() : "-";
            String nombre = (objectVO.getNombre()!=null) ? objectVO.getNombre() : "-";
            String apellido1 = (objectVO.getApellido1()!=null) ? objectVO.getApellido1() : "-";
            String apellido2 = (objectVO.getApellido2()!=null) ? objectVO.getApellido2() : "-";
            String fechaNacimiento = (objectVO.getFechaNacimiento()!=null) ? dateFormat.format(objectVO.getFechaNacimiento()) : "-";
            String edad = (objectVO.getEdad()!=null && !"".equals(objectVO.getEdad())) ? Integer.toString(objectVO.getEdad()) : "-";

            String sexo = "-";
            if (objectVO.getDesSexo() != null) {
                String descripcion = objectVO.getDesSexo();
                String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] descripcionDobleIdioma = (descripcion != null ? descripcion.split(barraSeparadoraDobleIdiomaDesple) : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (idiomaUsuario == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) {
                        descripcion = descripcionDobleIdioma[1];
                    } else {
                        descripcion = descripcionDobleIdioma[0];
                    }
                }
                sexo = descripcion;
            }

             String mayor55 = "-";
            if (objectVO.getMayor55() != null) {
                String descripcion = objectVO.getMayor55();
                // Separar por idiomas si contiene el separador
                String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] descripcionDobleIdioma = (descripcion != null ? descripcion.split(barraSeparadoraDobleIdiomaDesple) : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (idiomaUsuario == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) {
                        descripcion = descripcionDobleIdioma[1];
                    } else {
                        descripcion = descripcionDobleIdioma[0];
                    }
                }
                mayor55 = descripcion;
            }
            
            String finFormativa = "-";
            if (objectVO.getFinFormativa() != null) {
                String descripcion = objectVO.getFinFormativa();
                String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] descripcionDobleIdioma = (descripcion != null ? descripcion.split(barraSeparadoraDobleIdiomaDesple) : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (idiomaUsuario == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) {
                        descripcion = descripcionDobleIdioma[1];
                    } else {
                        descripcion = descripcionDobleIdioma[0];
                    }
                }
                finFormativa = descripcion;
            }
           
            String codFormativa = (objectVO.getCodFormativa()!=null) ? objectVO.getCodFormativa() : "-";
            String denFormativa = (objectVO.getDenFormativa()!=null) ? objectVO.getDenFormativa() : "-";

            String puesto = (objectVO.getPuesto()!=null) ? objectVO.getPuesto() : "-";
            String codOcupacion = (objectVO.getOcupacion()!=null) ? objectVO.getOcupacion() : "-";
            String ocupacion = "-";
            if(objectVO.getDesOcupacionLibre()!=null){
                ocupacion = objectVO.getDesOcupacionLibre();
            }else if(objectVO.getDesOcupacion()!=null){
                ocupacion = objectVO.getDesOcupacion();
                        }else{
                            ocupacion="-";
            }

            // Mostrar la descripción de la titulación solicitada en lugar del código
            String titReqPuesto = (objectVO.getDesTitReqPuesto()!=null && !"".equals(objectVO.getDesTitReqPuesto().trim())) ? objectVO.getDesTitReqPuesto() : "-";

            String funcionesJS = "-";
            if (objectVO.getFunciones()!=null && !objectVO.getFunciones().trim().isEmpty()){
                funcionesJS = objectVO.getFunciones()
                    .replace("\\", "\\\\")
                    .replace("'", "\\'")
                    .replace("</script>", "<\\/script>")
                    .replace("\r\n", "\\n")
                    .replace("\n", "\\n")
                    .replace("\r", "\\n");
            }

            String cProfesionalidad = (objectVO.getDesCProfesionalidad()!=null) ? objectVO.getDesCProfesionalidad() : "-";

            String modalidadContrato = (objectVO.getModalidadContrato()!=null) ? objectVO.getModalidadContrato() : "-";

            String jornada = "-";
            if (objectVO.getDesJornada() != null) {
                String descripcion = objectVO.getDesJornada();
                String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] descripcionDobleIdioma = (descripcion != null ? descripcion.split(barraSeparadoraDobleIdiomaDesple) : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (idiomaUsuario == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) descripcion = descripcionDobleIdioma[1];
                    else descripcion = descripcionDobleIdioma[0];
                }
                jornada = descripcion;
                    }else{
                        jornada="-";
            }

            String porcJornada = (objectVO.getPorcJornada()!=null) ? String.valueOf((objectVO.getPorcJornada().toString()).replace(".",",")) : "-";
            String horasConv   = (objectVO.getHorasConv()!=null && !"".equals(objectVO.getHorasConv())) ? Integer.toString(objectVO.getHorasConv()) : "-";
            String fechaInicio = (objectVO.getFechaInicio()!=null) ? dateFormat.format(objectVO.getFechaInicio()) : "-";
            String fechaFin    = (objectVO.getFechaFin()!=null) ? dateFormat.format(objectVO.getFechaFin()) : "-";
            String mesesContrato = (objectVO.getMesesContrato()!=null && !"".equals(objectVO.getMesesContrato()) && !"0".equals(objectVO.getMesesContrato())) ? objectVO.getMesesContrato() : "-";

            String grupoCotizacion = "-";
            if (objectVO.getDesGrupoCotizacion() != null) {
                String descripcion = objectVO.getDesGrupoCotizacion();
                String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] descripcionDobleIdioma = (descripcion != null ? descripcion.split(barraSeparadoraDobleIdiomaDesple) : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (idiomaUsuario == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) descripcion = descripcionDobleIdioma[1];
                    else descripcion = descripcionDobleIdioma[0];
                }
                grupoCotizacion = descripcion;
                    }else{
                        grupoCotizacion="-";
            }

            String direccionCT = (objectVO.getDireccionCT()!=null) ? objectVO.getDireccionCT() : "-";
            String numSS       = (objectVO.getNumSS()!=null) ? objectVO.getNumSS() : "-";
            String costeContrato = (objectVO.getCosteContrato()!=null) ? String.valueOf((objectVO.getCosteContrato().toString()).replace(".",",")) : "-";

            String tipRetribucion = "-";
            if (objectVO.getDesTipRetribucion() != null) {
                String descripcion = objectVO.getDesTipRetribucion();
                String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
                String[] descripcionDobleIdioma = (descripcion != null ? descripcion.split(barraSeparadoraDobleIdiomaDesple) : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (idiomaUsuario == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) descripcion = descripcionDobleIdioma[1];
                    else descripcion = descripcionDobleIdioma[0];
                }
                tipRetribucion = descripcion;
                    }else{
                        tipRetribucion="-";
            }
            
            

            
            String importeSub = (objectVO.getImporteSub()!=null) ? String.valueOf((objectVO.getImporteSub().toString()).replace(".",",")) : "-";
            String desTitulacion = (objectVO.getDesTitulacionLibre()!=null) ? objectVO.getDesTitulacionLibre() : "-";
            String titulacion    = (objectVO.getDesTitulacion()!=null) ? objectVO.getDesTitulacion() : "-";

            String rsbTotal = (objectVO.getRsbCompConv()!=null)
                ? objectVO.getRsbCompConv().toString().replace(".", ",")
                : "-";
%>
<script type="text/javascript">
    // Fila <%=indice%>
    listaAccesos.push([
        '<%=objectVO.getId()%>', '<%=escJS(oferta)%>', '<%=escJS(idContrato1)%>', '<%=escJS(idContrato2)%>', '<%=escJS(dni)%>',
        '<%=escJS(nombre)%>', '<%=escJS(apellido1)%>', '<%=escJS(apellido2)%>', '<%=escJS(fechaNacimiento)%>', '<%=escJS(edad)%>',
        '<%=escJS(sexo)%>', '<%=escJS(mayor55)%>', '<%=escJS(finFormativa)%>', '<%=escJS(codFormativa)%>', '<%=escJS(denFormativa)%>',
        '<%=escJS(puesto)%>', '<%=escJS(codOcupacion)%>', '<%=escJS(ocupacion)%>', '<%=escJS(titReqPuesto)%>', '<%= escJS(objectVO.getFunciones()) %>',
        '<%=escJS(cProfesionalidad)%>', '<%=escJS(modalidadContrato)%>', '<%=escJS(jornada)%>', '<%=escJS(porcJornada)%>',
        '<%=escJS(horasConv)%>', '<%=escJS(fechaInicio)%>', '<%=escJS(fechaFin)%>', '<%=escJS(mesesContrato)%>',
        '<%=escJS(grupoCotizacion)%>', '<%=escJS(direccionCT)%>', '<%=escJS(numSS)%>', '<%=escJS(costeContrato)%>',
        '<%=escJS(tipRetribucion)%>', '<%=escJS(rsbTotal)%>', '<%=escJS(importeSub)%>', '<%=escJS(desTitulacion)%>', '<%=escJS(titulacion)%>'
    ]);

    listaAccesosTabla.push([
        '<%=objectVO.getId()%>', '<%=escJS(oferta)%>', '<%=escJS(idContrato1)%>', '<%=escJS(idContrato2)%>', '<%=escJS(dni)%>',
        '<%=escJS(nombre)%>', '<%=escJS(apellido1)%>', '<%=escJS(apellido2)%>', '<%=escJS(fechaNacimiento)%>', '<%=escJS(edad)%>',
        '<%=escJS(sexo)%>', '<%=escJS(mayor55)%>', '<%=escJS(finFormativa)%>', '<%=escJS(codFormativa)%>', '<%=escJS(denFormativa)%>',
        '<%=escJS(puesto)%>', '<%=escJS(codOcupacion)%>', '<%=escJS(ocupacion)%>', '<%=escJS(titReqPuesto)%>', '<%= escJS(objectVO.getFunciones()) %>',
        '<%=escJS(cProfesionalidad)%>', '<%=escJS(modalidadContrato)%>', '<%=escJS(jornada)%>', '<%=escJS(porcJornada)%>',
        '<%=escJS(horasConv)%>', '<%=escJS(fechaInicio)%>', '<%=escJS(fechaFin)%>', '<%=escJS(mesesContrato)%>',
        '<%=escJS(grupoCotizacion)%>', '<%=escJS(direccionCT)%>', '<%=escJS(numSS)%>', '<%=escJS(costeContrato)%>',
        '<%=escJS(tipRetribucion)%>', '<%=escJS(rsbTotal)%>', '<%=escJS(importeSub)%>', '<%=escJS(desTitulacion)%>', '<%=escJS(titulacion)%>'
    ]);
</script>
<%      } // for
    } // if
%>

<script type="text/javascript">
    tabaAccesos.lineas = listaAccesosTabla;
    tabaAccesos.displayTabla();
</script>
<div id="popupcalendar" class="text"></div>
