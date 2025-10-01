<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>

<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO" %>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO" %>
<%@page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11" %>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat" %>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            MinimisVO datModif = new MinimisVO();
            MinimisVO objectVO = new MinimisVO();
        
            String codOrganizacion = "";
            String nuevo = "";
        
            String expediente = "";
        
            String fecha = "";
        
            MeLanbide11I18n meLanbide11I18n = MeLanbide11I18n.getInstance();

            expediente = (String)request.getAttribute("numExp");
            int idiomaUsuario = 1;
            int apl = 5;
            String css = "";
            try
            {
                UsuarioValueObject usuario = new UsuarioValueObject();
                try
                {
                    if (session != null) 
                    {
                        if (usuario != null) 
                        {
                            usuario = (UsuarioValueObject) session.getAttribute("usuario");
                            idiomaUsuario = usuario.getIdioma();
                            apl = usuario.getAppCod();
                            css = usuario.getCss();
                        }
                    }
                }
                catch(Exception ex)
                {

                }

                // Compatibilidad: intentar primero "codOrganizacionModulo" y si no viene, usar "codOrganizacion"
                codOrganizacion  = request.getParameter("codOrganizacionModulo");
                if (codOrganizacion == null || "".equals(codOrganizacion)) {
                    codOrganizacion = request.getParameter("codOrganizacion");
                }
                nuevo = (String)request.getAttribute("nuevo");
                if(request.getAttribute("datModif") != null)
                {
                    datModif = (MinimisVO)request.getAttribute("datModif");
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
                
                    if (datModif.getFecha()!=null){
                        fecha = formatoFecha.format(datModif.getFecha());
                    }
                }
            }
            catch(Exception ex)
            {
            }
        %>

        <jsp:useBean id="descriptor" scope="request" class="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean"  type="es.altia.agora.interfaces.user.web.util.TraductorAplicacionBean" />
        <jsp:setProperty name="descriptor"  property="idi_cod" value="<%=idiomaUsuario%>" />
        <jsp:setProperty name="descriptor"  property="apl_cod" value="<%=apl%>" />
        <link rel="StyleSheet" media="screen" type="text/css" href="<%=request.getContextPath()%><%=css%>">
        <link rel="stylesheet" type="text/css" href="<c:url value='/css/font-awesome-4.6.2/css/font-awesome.min.css'/>" media="screen">
        <link rel="stylesheet" type="text/css" href="<c:url value='/css/font-awesome-4.6.2/less/animated.less'/>" media="screen">
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/jquery/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.js"></script>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/scripts/DataTables/datatables.min.css"/>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/extension/melanbide11/melanbide11.css"/>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/general.js"></script>
        <script type="text/javascript" src="<c:url value='/scripts/listaComboBox.js'/>"></script>
        <script type="text/javascript" src="<c:url value='/scripts/calendario.js'/>"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/validaciones.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/popup.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/JavaScriptUtil.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/Parsers.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/InputMask.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/melanbide11/lanbide.js"></script>        
        <script type="text/javascript">
            var APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
            var mensajeValidacion = '';

            var comboListaEstado;
            var listaCodigosEstado = new Array();
            var listaDescripcionesEstado = new Array();
            function buscaCodigoEstado(codEstado) {
                comboListaEstado.buscaCodigo(codEstado);
            }
            function cargarDatosEstado() {
                var codEstadoSeleccionado = document.getElementById("codListaEstado").value;
                buscaCodigoEstado(codEstadoSeleccionado);
            }


            function reemplazarPuntos(campo) {
                try {
                    var valor = campo.value;
                    if (valor != null && valor != '') {
                        valor = valor.replace(/\./g, ',');
                        campo.value = valor;
                    }
                } catch (err) {
                }
            }

            function rellenardatModificar() {
                if ('<%=datModif%>' != null) {
                    buscaCodigoEstado('<%=datModif.getEstado() != null ? datModif.getEstado() : ""%>');
                } else
                    alert('No hemos podido cargar los datos para modificar');
            }

            function getXMLHttpRequest() {
                var aVersions = ["MSXML2.XMLHttp.5.0",
                    "MSXML2.XMLHttp.4.0", "MSXML2.XMLHttp.3.0",
                    "MSXML2.XMLHttp", "Microsoft.XMLHttp"
                ];

                if (window.XMLHttpRequest) {
                    // para IE7, Mozilla, Safari, etc: que usen el objeto nativo
                    return new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    // de lo contrario utilizar el control ActiveX para IE5.x y IE6.x
                    for (var i = 0; i < aVersions.length; i++) {
                        try {
                            var oXmlHttp = new ActiveXObject(aVersions[i]);
                            return oXmlHttp;
                        } catch (error) {
                            //no necesitamos hacer nada especial
                        }
                    }
                } else {
                    return null;
                }
            }

            function guardarDatos() {

                if (validarDatosNumericosVacios() && validarDatos()) {
                    var ajax = getXMLHttpRequest();
                    var nodos = null;
                    var url = APP_CONTEXT_PATH + "/PeticionModuloIntegracion.do";
                    var parametros = "";
                    var nuevo = "<%=nuevo%>";
                    var organismo = "";
                    var objeto = "";
                    if (document.getElementById('organismo').value == null || document.getElementById('organismo').value == '') {
                        organismo = "";
                    } else {
                        organismo = document.getElementById('organismo').value.replace(/\'/g, "''");
                    }
                    if (document.getElementById('objeto').value == null || document.getElementById('objeto').value == '') {
                        objeto = "";
                    } else {
                        objeto = document.getElementById('objeto').value.replace(/\'/g, "''");
                    }

                    if (nuevo != null && nuevo == "1") {
                        parametros = "tarea=preparar&modulo=MELANBIDE11&operacion=crearNuevaMinimis&tipo=0"
                                + "&expediente=<%=expediente%>"
                                + "&estado=" + document.getElementById('codListaEstado').value
                                + '&organismo=' + organismo
                                + '&objeto=' + objeto
                                + "&importe=" + document.getElementById('importe').value
                                + "&fecha=" + document.getElementById('fecha').value
                                ;
                    } else {
            var idRegistroMinimis = '<%= (datModif != null && datModif.getId() != null) ? datModif.getId() : "" %>';
            parametros = "tarea=preparar&modulo=MELANBIDE11&operacion=modificarMinimis&tipo=0"
                + "&id=" + encodeURIComponent(idRegistroMinimis)
                + "&estado=" + document.getElementById('codListaEstado').value
                                + '&organismo=' + organismo
                                + '&objeto=' + objeto
                                + "&importe=" + document.getElementById('importe').value
                                + "&fecha=" + document.getElementById('fecha').value
                                ;
                    }
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
                        var elemento = nodos[0];
                        var hijos = elemento.childNodes;
                        var codigoOperacion = null;
                        var lista = new Array();
                        var fila = new Array();
                        var nodoFila;
                        var hijosFila;
                        for (j = 0; hijos != null && j < hijos.length; j++) {
                            if (hijos[j].nodeName == "CODIGO_OPERACION") {
                                codigoOperacion = hijos[j].childNodes[0].nodeValue;
                                lista[j] = codigoOperacion;
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
                                        if (hijosFila[cont].childNodes.length > 0) {
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
                                }// for elementos de la fila
                                lista[j] = fila;
                                fila = new Array();
                            }
                        }//for(j=0;hijos!=null && j<hijos.length;j++)
                        if (codigoOperacion == "0") {
                            //jsp_alerta("A",'Correcto');
                            // Desacople: usar callback específico si existe
                            try {
                                if (self.parent && self.parent.opener) {
                                    if (typeof self.parent.opener.retornoMinimis === 'function') {
                                        self.parent.opener.retornoMinimis(lista);
                                    } else if (typeof self.parent.opener.retornoXanelaAuxiliar === 'function') {
                                        // fallback legacy
                                        self.parent.opener.retornoXanelaAuxiliar(lista);
                                    } else {
                                        console.warn('No se encontró retornoMinimis ni retornoXanelaAuxiliar en opener');
                                    }
                                }
                            } catch(cbErr){
                                console.error('Error invocando callback de retorno minimis', cbErr);
                            }
                            cerrarVentana();
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
                    }//try-catch
                } else {
                    jsp_alerta("A", mensajeValidacion);
                }
            }

            function cancelar() {
                var resultado = jsp_alerta('', '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.preguntaCancelar")%>');
                if (resultado == 1) {
                    cerrarVentana();
                }
            }

            function cerrarVentana() {
                if (navigator.appName == "Microsoft Internet Explorer") {
                    window.parent.window.opener = null;
                    window.parent.window.close();
                } else if (navigator.appName == "Netscape") {
                    top.window.opener = top;
                    top.window.open('', '_parent', '');
                    top.window.close();
                } else {
                    window.close();
                }
            }

            function validarDatosNumericosVacios() {
                mensajeValidacion = "";
                var correcto = true;
                if (document.getElementById('importe').value == null || document.getElementById('importe').value == '') {
                } else {
                    if (!validarNumericoDecimalPrecision(document.getElementById('importe').value, 8, 2)) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.importe.errNumerico")%>';
                        return false;
                    }
                }
                return correcto;
            }

            function validarNumericoDecimalPrecision(numero, longTotal, longParteDecimal) {
                try {
                    var longParteEntera = parseInt(longTotal) - parseInt(longParteDecimal);
                    if (Trim(numero) != '') {
                        var valor = numero;
                        var pattern = '^[0-9]{1,' + longParteEntera + '}(,[0-9]{1,' + longParteDecimal + '})?$';
                        var regex = new RegExp(pattern);
                        var result = regex.test(valor);
                        return result;
                    } else {
                        return true;
                    }
                } catch (err) {
                    alert(err);
                    return false;
                }
            }

            function validarNumerico(numero) {
                try {
                    if (Trim(numero.value) != '') {
                        return /^([0-9])*$/.test(numero.value);
                    }
                } catch (err) {
                    return false;
                }
            }

            function validarDatos() {
                mensajeValidacion = "";
                var correcto = true;
                return correcto;
            }

            function comprobarFechaLanbide(inputFecha) {
                var formato = 'dd/mm/yyyy';
                if (Trim(inputFecha.value) != '') {
                    var D = ValidarFechaConFormatoLanbide(inputFecha.value, formato);
                    if (!D[0]) {
                        jsp_alerta("A", "<%=meLanbide11I18n.getMensaje(idiomaUsuario, \"msg.fechaNoVal\")%>");
                        document.getElementById(inputFecha.name).focus();
                        document.getElementById(inputFecha.name).select();
                        return false;
                    } else {
                        inputFecha.value = D[1];
                        return true;
                    }//if (!D[0])
                }//if (Trim(inputFecha.value)!='')
                return true;
            }//comprobarFechaLanbide

            //Funcion para el calendario de fecha 
            function mostrarCalFecha(evento) {
                if (window.event)
                    evento = window.event;
                if (document.getElementById("calFecha").src.indexOf("icono.gif") != -1)
                    showCalendar('forms[0]', 'fecha', null, null, null, '', 'calFecha', '', null, null, null, null, null, null, null, null, evento);
            }

            function compruebaTamanoCampo(elemento, maxTex) {
                var texto = elemento.value;
                if (texto.length > maxTex) {
                    jsp_alerta("A", '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.errExcdTexto")%>');
                    elemento.focus();
                    return false;
                }
                return true;
            }

        </script>
    </head>
    <body>
        <div class="contenidoPantalla">
            <form><!--    action="/PeticionModuloIntegracion.do" method="POST" -->
                <div style="width: 100%; padding: 10px; text-align: left;">
                    <div  class="sub3titulo" style="clear: both; text-align: center; font-size: 14px;">
                        <span>
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.nuevaSubvencion")%>
                        </span>
                    </div> 

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.estado")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaEstado" id="codListaEstado" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaEstado"  id="descListaEstado" size="60" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaEstado" name="anchorListaEstado">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.organismo")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="organismo" name="organismo" type="text" class="inputTexto" size="100" maxlength="100" 
                                       value="<%=datModif != null && datModif.getOrganismo() != null ? datModif.getOrganismo() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.objeto")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="objeto" name="objeto" type="text" class="inputTexto" size="100" maxlength="50" 
                                       value="<%=datModif != null && datModif.getObjeto() != null ? datModif.getObjeto() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.importe")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="importe" name="importe" type="text" class="inputTexto" size="25" maxlength="10" 
                                       value="<%=datModif != null && datModif.getImporte() != null ? datModif.getImporte().toString().replaceAll("\\.", ","): ""%>" onchange="reemplazarPuntos(this);"/>
                            </div>
                        </div>
                    </div>        

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.fecha")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input type="text" class="inputTxtFecha" 
                                       id="fecha" name="fecha"
                                       maxlength="10"  size="10"
                                       value="<%=fecha%>"
                                       onkeyup = "return SoloCaracteresFechaLanbide(this);"
                                       onblur = "javascript:return comprobarFechaLanbide(this);"
                                       onfocus="javascript:this.select();"/>
                                <A href="javascript:calClick(event);return false;" onClick="mostrarCalFecha(event);
                                        return false;" style="text-decoration:none;">
                                    <IMG style="border: 0px solid" height="17" id="calFecha" name="calFecha" border="0" 
                                         src="<c:url value='/images/calendario/icono.gif'/>" > <!--width="25"-->
                                </A>
                            </div>
                        </div>
                    </div> 


                    <br><br>
                    <div class="lineaFormulario" style="margin-top: 25px;">
                        <div class="botonera" style="text-align: center;">
                            <input type="button" id="btnAceptar" name="btnAceptar" class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.aceptar")%>" onclick="guardarDatos();"/>
                            <input type="button" id="btnCancelar" name="btnCancelar" class="botonGeneral" value="<%=meLanbide11I18n.getMensaje(idiomaUsuario, "btn.cancelar")%>" onclick="cancelar();"/>
                        </div>
                    </div>
                </div>
                <div id="reloj" style="font-size:20px;"></div>
            </form>
            <script type="text/javascript">

                /*desplegable estado*/
                listaCodigosEstado[0] = "";
                listaDescripcionesEstado[0] = "";
                contador = 0;
                <logic:iterate id="estado" name="listaEstado" scope="request">
                listaCodigosEstado[contador] = ['<bean:write name="estado" property="des_val_cod" />'];
                listaDescripcionesEstado[contador] = ['<bean:write name="estado" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaEstado = new Combo("ListaEstado");
                comboListaEstado.addItems(listaCodigosEstado, listaDescripcionesEstado);
                comboListaEstado.change = cargarDatosEstado;

                var nuevo = "<%=nuevo%>";
                if (nuevo == 0) {
                    rellenardatModificar();
                }

            </script>
            <div id="popupcalendar" class="text"></div>        
        </div>
        <!-- Fallback defensivo: en algunos contextos (carga parcial vía popup/ajax) el bloque <head> puede no ejecutarse
             y la función reemplazarPuntos no quedar definida antes de los onChange inline. -->
        <script type="text/javascript">
            if (typeof window.reemplazarPuntos !== 'function') {
                window.reemplazarPuntos = function(campo){
                    try {
                        if (campo && campo.value) {
                            campo.value = campo.value.replace(/\./g, ',');
                        }
                    } catch(e) {
                        if (window.console && console.warn) {
                            console.warn('Fallback reemplazarPuntos capturó un error:', e);
                        }
                    }
                };
            }
        </script>
    </body>
</html> 
