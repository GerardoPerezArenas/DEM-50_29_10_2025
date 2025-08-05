<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>

<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO" %>
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
            ContratacionVO datModif = new ContratacionVO();
            ContratacionVO objectVO = new ContratacionVO();
        
            String codOrganizacion = "";
            String nuevo = "";
        
            String expediente = "";
        
            String fechaNacimiento = "";
            String fechaInicio = "";
            String fechaFin = "";
        
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

                codOrganizacion  = request.getParameter("codOrganizacionModulo");
                nuevo = (String)request.getAttribute("nuevo");
                if(request.getAttribute("datModif") != null)
                {
                    datModif = (ContratacionVO)request.getAttribute("datModif");
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
                
                    if (datModif.getFechaNacimiento()!=null){
                        fechaNacimiento = formatoFecha.format(datModif.getFechaNacimiento());
                    }
                    if (datModif.getFechaInicio()!=null){
                        fechaInicio = formatoFecha.format(datModif.getFechaInicio());
                    }
                    if (datModif.getFechaFin()!=null){
                        fechaFin = formatoFecha.format(datModif.getFechaFin());
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
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/meLanbide11/JavaScriptUtil.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/meLanbide11/Parsers.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/meLanbide11/InputMask.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/extension/meLanbide11/lanbide.js"></script>
        <!-- listaComboBox modificado para que busque sin tener en cuenta las tildes -->
        <script type="text/javascript">
            var APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
///////////////////////////////////////////////////////////////////////////////////////////////////////
// INICIO OBJETO COMBOBOX
///////////////////////////////////////////////////////////////////////////////////////////////////////

            CB_RowHeight = 19;
            CB_Borde = 1;
            CB_Scroll = 15;

            var cursor;
            var operadorConsulta = "";
            if (document.all)
                cursor = 'hand';
            else if (document.getElemenById)
                cursor = 'pointer';

            function CB_OcultarCombo(combo) {
                var cmb = document.getElementById('desc' + combo);
                if (cmb && cmb.combo) {
                    cmb.combo.ocultar();
                } else if (window["combo" + combo] != undefined) {
                    window["combo" + combo].ocultar();
                }
            }

            function Combo(nombre, idiomaUsuario) {
                this.id = nombre;
                this.idioma = 0;
                if (idiomaUsuario != undefined && idiomaUsuario != null) {
                    this.idioma = idiomaUsuario;
                }
                //Referenciamos los inputs del codigo y la descripcion.  
                var codigos = document.getElementsByName("cod" + nombre);
                var descripciones = document.getElementsByName("desc" + nombre);
                var anchors = document.getElementsByName("anchor" + nombre);

                if (codigos != null && codigos[0] != null)
                    this.cod = codigos[0];
                else {
                    this.cod = document.getElementById("cod" + nombre);
                }

                if (descripciones != null && descripciones[0] != null)
                    this.des = descripciones[0];
                else {
                    this.des = document.getElementById("desc" + nombre);
                }

                if (anchors != null && anchors[0] != null) {
                    this.anchor = anchors[0];
                } else
                    this.anchor = document.getElementById("anchor" + nombre);
                var hijos = new Array();
                hijos = this.anchor.children;
                if (hijos != null && hijos.length >= 1)
                    this.boton = hijos[0];

                this.selectedIndex = -1;
                this.timer = null;

                this.des.introducido = "";
                this.original = null;

                this.codigos = new Array();
                this.items = new Array();
                this.auxItems = new Array();
                this.auxCodigos = new Array();
                this.i_codigos = new Array();
                this.i_items = new Array();

                //Creamos la vista del combo, que será un DIV que incluirá la tabla con los elementos de la lista.
                this.base = document.createElement("DIV");
                this.base.combo = this;
                this.base.style.position = 'absolute';
                this.base.style.display = "none";
                this.base.onblur = function (event) {
                    var event = (event) ? event : ((window.event) ? window.event : "");
                    this.combo.timer = setTimeout('CB_OcultarCombo("' + this.combo.id + '")', 150);
                };
                this.base.onkeydown = function (event) {
                    var event = (event) ? event : ((window.event) ? window.event : "");
                    var tecla = "";

                    if (event.keyCode)
                        tecla = event.keyCode;
                    else
                        tecla = event.which;

                    if (tecla == 8) {
                        this.combo.buscaItem("-1");
                    } else if (tecla == 40) {
                        this.combo.selectItem(this.combo.selectedIndex + 1);
                    } else if (tecla == 38) {
                        this.combo.selectItem(this.combo.selectedIndex - 1);
                    } else if (tecla == 13) {
                        this.combo.ocultar();
                        if (this.combo.cod)
                            this.combo.cod.select();
                        else
                            this.combo.des.select();
                    } else {
                        if (tecla > 95)
                            tecla = tecla - 48;
                        var letra = String.fromCharCode(tecla);
                        this.combo.buscaItem(letra);
                    }
                    if (window.event) {
                        event.cancelBubble = true;
                        event.returnValue = false;
                    } else {
                        event.stopPropagation();
                        event.preventDefault();
                    }
                    return false;
                };

                this.view = document.createElement("DIV");
                this.base.appendChild(this.view);
                this.view.combo = this;
                this.view.className = 'xC';
                this.view.style.overflowY = 'auto';
                this.view.style.position = 'relative';
                this.view.onselectstart = function () {
                    return false;
                };
                this.view.ondblclick = function () {
                    return false;
                };
                this.view.onclick = function (event) {
                    event = (event) ? event : ((window.event) ? window.event : "");

                    var padre = "";
                    if (window.event)
                        padre = event.srcElement;
                    else
                        padre = event.target;

                    if (padre.tagName != 'DIV')
                        return;
                    var rowID = 1;

                    if (!!navigator.userAgent.match(/Trident.*rv[ :]*11\./) || navigator.appName.indexOf("Internet Explorer") != -1) {
                        // Se calcula la posición de item del combo que ha sido seleccionado
                        var i = padre.parentElement.sourceIndex;
                        var j = padre.sourceIndex;
                        rowID = (j - i - 1);

                    } else {
                        // Firefox u otro navegador

                        /** Se obtiene el valor del item de menú seleccionado, para a partir de él, obtener la posición en el combo y seleccionar dicha fila **/
                        var hijos = padre.childNodes;
                        var valorFilaSeleccionada = "";
                        if (hijos != null) {
                            valorFilaSeleccionada = hijos[0].nodeValue;
                        }

                        var padreRaiz = padre.parentNode;
                        var hijosRaiz = padreRaiz.childNodes;
                        for (z = 0; z < hijosRaiz.length; z++) {
                            var nietos = hijosRaiz[z].childNodes;
                            if (nietos != null && nietos.length > 0) {
                                if (nietos[0].nodeValue == valorFilaSeleccionada) {
                                    break;
                                }
                            }
                        }
                        // En z está la posición de la fila seleccionada por el usuario
                        rowID = z;
                    }// else       

                    this.combo.selectItem(rowID);
                    this.combo.ocultar();
                    if (this.combo.cod)
                        this.combo.cod.select();
                    else
                        this.combo.des.select();
                    return false;
                };
                this.view.onfocus = function (event) {
                    event = (event) ? event : ((window.event) ? window.event : "");
                    if (this.combo.timer != null)
                        clearTimeout(this.combo.timer);
                    this.combo.timer = null;
                    this.combo.base.focus();
                };

                //*************************************************  
                this.resize = CB_resize;

                this.addItems = CB_addItems;
                this.addItems2 = CB_addItems2;
                this.clearItems = CB_clearItems;
                this.restoreIndex = CB_restoreIndex;
                this.selectItem = CB_selectItem;
                this.buscaCodigo = CB_buscaCodigo;
                this.buscaItem = CB_buscaItem;
                this.scroll = CB_scroll;
                this.display = CB_display;
                this.ocultar = CB_ocultar;
                this.init = CB_init;
                this.activate = CB_activate;
                this.deactivate = CB_deactivate;
                this.obligatorio = CB_obligatorio;
                this.buscaLinea = CB_buscaLinea;
                this.contieneOperadoresConsulta = CB_contieneOperadoresConsulta;
                this.clearSelected = CB_clearSelected;
                this.change = function () {};

                this.init();
            }

            function CB_init() {
                //Guardamos una referencia del combo en el imput de la descripcion
                if (this.cod) {
                    this.cod.combo = this;
                    this.cod.onfocus = function () {
                        this.select();
                    };
                    this.cod.onblur = function (event) {
                        if (!this.combo.contieneOperadoresConsulta(this))
                            this.combo.buscaCodigo(this.value);
                        else {
                            var codOld = this.value;
                            this.combo.selectItem(-1);
                            this.value = codOld;
                            this.combo.change();
                        }
                    };
                    this.cod.onkeydown = function (event) {
                        var event = (event) ? event : ((window.event) ? window.event : "");
                        var tecla = "";
                        if (event.keyCode)
                            tecla = event.keyCode;
                        else
                            tecla = event.which;
                        if (tecla == 40) {
                            this.combo.selectItem(this.combo.selectedIndex + 1);
                            if (window.event) {
                                event.cancelBubble = true;
                                event.returnValue = false;
                            } else {
                                event.stopPropagation = true;
                                event.preventDefault = false;
                            }
                        } else if (tecla == 38) {
                            this.combo.selectItem(this.combo.selectedIndex - 1);
                            if (window.event) {
                                event.cancelBubble = true;
                                event.returnValue = false;
                            } else {
                                event.stopPropagation = true;
                                event.preventDefault = false;
                            }
                        } else if (tecla == 13) {

                            this.combo.display();
                            if (window.event) {
                                event.cancelBubble = true;
                                event.returnValue = false;
                            } else {
                                event.stopPropagation = true;
                                event.preventDefault = false;
                            }
                        } else if (tecla == 9)
                        {
                            this.combo.ocultar();
                        }

                    };
                }

                if (this.des != null)
                    this.des.combo = this;

                this.des.onfocus = function () {
                    this.select();
                };
                this.des.onclick = function (event) {
                    this.introducido = "";
                    if (this.combo.auxCodigos.length > 0)
                        this.combo.addItems(this.combo.auxCodigos, this.combo.auxItems);

                    event = (event) ? event : ((window.event) ? window.event : "");

                    if (this.combo.cod) {

                        if (!this.combo.cod.readOnly) {

                            if (!this.combo.contieneOperadoresConsulta(this.combo.cod))
                                this.combo.display();
                        }
                    } else
                    {
                        this.combo.display();
                    }
                    event.stopPropagation();
                    return false;
                };

                this.des.onkeydown = function (event) {
                    event = (event) ? event : ((window.event) ? window.event : "");
                    var tecla = "";
                    if (event.keyCode)
                        tecla = event.keyCode;
                    else
                        tecla = event.which;

                    if (tecla == 8) {
                        this.combo.buscaItem("-1");
                        if (window.event) {
                            event.cancelBubble = true;
                            event.returnValue = false;
                        } else {
                            event.stopPropagation();
                            event.preventDefault();
                        }
                    } else if (tecla == 40) {
                        this.combo.selectItem(this.combo.selectedIndex + 1);
                        if (window.event) {
                            event.cancelBubble = true;
                            event.returnValue = false;
                        } else {
                            event.stopPropagation();
                            event.preventDefault();
                        }
                    } else if (tecla == 38) {
                        this.combo.selectItem(this.combo.selectedIndex - 1);
                        if (window.event) {
                            event.cancelBubble = true;
                            event.returnValue = false;
                        } else {
                            event.stopPropagation();
                            event.preventDefault();
                        }
                    } else if (tecla == 13) {
                        this.combo.display();
                        if (window.event) {
                            event.cancelBubble = true;
                            event.returnValue = false;
                        } else {
                            event.stopPropagation();
                            event.preventDefault();
                        }
                    } else if (tecla == 9) {
                        this.combo.ocultar();
                    }
                };

                this.des.onkeypress = function (event) {
                    var event = (event) ? event : ((window.event) ? window.event : "");
                    var tecla = "";
                    if (event.keyCode)
                        tecla = event.keyCode;
                    else
                        tecla = event.which;
                    var letra = String.fromCharCode(tecla);
                    if (this.readOnly)
                        this.combo.buscaItem(letra);
                };

                this.des.onblur = function (event) {
                    if (!this.readOnly && this.value.length != 0) {
                        if (this.combo.cod) {
                            if (!this.combo.contieneOperadoresConsulta(this))
                                this.combo.buscaCodigo(this.combo.cod.value);

                            else {
                                var codOld = this.value;
                                this.combo.selectItem(-1);
                                this.value = codOld;
                                this.combo.change();
                            }
                        }
                    }
                    var isChromium = window.chrome,
                            vendorName = window.navigator.vendor,
                            isOpera = window.navigator.userAgent.indexOf("OPR") > -1;
                    if (isChromium !== null && isChromium !== undefined && vendorName === "Google Inc." && isOpera == false) {
                        this.combo.timer = setTimeout('CB_OcultarCombo("' + this.combo.id + '")', 150);
                    } else if (navigator.userAgent.indexOf("Firefox") > 0) {
                        this.combo.timer = setTimeout('CB_OcultarCombo("' + this.combo.id + '")', 150);
                    }

                };

                if (this.anchor) {
                    this.anchor.combo = this;
                    this.anchor.onkeydown = function (event) {

                        var event = (event) ? event : ((window.event) ? window.event : "");
                        var tecla = "";
                        if (event.keyCode)
                            tecla = event.keyCode;
                        else
                            tecla = event.which;

                        //if(event.keyCode == 40){
                        if (tecla == 40) {
                            this.combo.selectItem(this.combo.selectedIndex + 1);
                            if (window.event) {
                                event.cancelBubble = true;
                                event.returnValue = false;
                            } else {
                                event.stopPropagation = true;
                                event.preventDefault = false;
                            }
                        } else if (tecla == 38) {
                            this.combo.selectItem(this.combo.selectedIndex - 1);
                            if (window.event) {
                                event.cancelBubble = true;
                                event.returnValue = false;
                            } else {
                                event.stopPropagation = true;
                                event.preventDefault = false;
                            }
                        } else if (tecla == 13) {

                            this.combo.display();
                            if (window.event) {
                                event.cancelBubble = true;
                                event.returnValue = false;
                            } else {
                                event.stopPropagation = true;
                                event.preventDefault = false;
                            }
                        } else if (tecla == 9)
                        {
                            this.combo.ocultar();
                        }
                    };
                    this.anchor.onclick = function (event) {
                        if (this.combo.cod) {
                            if (!this.combo.contieneOperadoresConsulta(this.combo.cod))
                                this.combo.display();
                        } else
                            this.combo.display();
                        event.stopPropagation();
                        return false;
                    };
                }
                document.getElementsByClassName("contenidoPantalla")[0].appendChild(this.base);
                this.addItems([], []);
            }

            function CB_buscaCodigo(cod) {
                if (cod == null || cod == undefined)
                    return true;
                var str = cod;
                if (str == '') {
                    this.selectItem(0);
                } else if (this.codigos[this.selectedIndex] != str) {
                    var i = this.i_codigos[str + ''];
                    if (i != null && i != undefined) {
                        this.selectItem(i);
                    } else {
                        if (this.des.readOnly)
                            jsp_alerta('A', 'Código inexistente');
                        this.selectItem(-1);
                        return false;
                    }
                }
                return true;
            }

            function CB_buscaLinea(cod) {
                if (cod == null || cod == 'undefined')
                    return true;
                var str = cod;

                if (this.selectedIndex >= 0 && this.selectedIndex < this.items.length) {
                    if (this.view.children[this.selectedIndex].className != 'xCDisabled') {
                        this.view.children[this.selectedIndex].className = 'xCSelected';
                    }
                }

                if (str == '') {
                    this.selectedIndex = 0;
                } else if (this.codigos[this.selectedIndex] != str) {
                    var i = this.i_codigos[str + ''];
                    if (i != null && i != undefined) {
                        this.selectedIndex = i;
                    } else {
                        this.selectedIndex = -1;
                    }
                }

                if (this.selectedIndex >= 0 && this.selectedIndex < this.items.length) {
                    if (this.view.children[this.selectedIndex].className != 'xCDisabled') {
                        this.view.children[this.selectedIndex].className = 'xCSelected';
                    }
                    this.scroll();
                    if (this.cod)
                        this.cod.value = this.codigos[this.selectedIndex];
                    this.des.value = this.items[this.selectedIndex];
                } else {
                    if (this.cod)
                        this.cod.value = "";
                    this.des.value = "";
                }

                return true;
            }

            function quitarTildes(st) {
                st = st.replace(new RegExp(/[àáâãäå]/g), "a");
                st = st.replace(new RegExp(/[èéêë]/g), "e");
                st = st.replace(new RegExp(/[ìíîï]/g), "i");
                st = st.replace(new RegExp(/[òóôõö]/g), "o");
                st = st.replace(new RegExp(/[ùúûü]/g), "u");

                return st;
            }

            function CB_buscaItem(letra) {

                //if (this.des.combo.id != 'ListaTitulacion'){
                if (letra) {
                    if (letra == "-1") {
                        if (this.des.introducido.length > 0)
                            this.des.introducido = this.des.introducido.substr(0, this.des.introducido.length - 1);
                        if (this.auxItems.length > 0) {
                            this.items = this.auxItems;
                            this.codigos = this.auxCodigos;
                        }
                    } else {
                        var regex = new RegExp("[a-z]");
                        if (regex.test(letra))
                            letra = letra.toUpperCase();
                        this.des.introducido += letra;
                    }
                }
                if (this.des.introducido == "") {
                    this.selectItem(0);
                    return true;
                }
                this.des.value = this.des.introducido;
                var novoItems = [];
                var novoCodigos = [];

                for (var i = 0; i < this.items.length; i++) {
                    // se fuerza a que sea string (en el pantallaCatalogacion.jsp de catalogación no hizo falta)
                    var itemTemp = this.items[i].toString().toLowerCase();
                    itemTemp = quitarTildes(itemTemp).toUpperCase();
                    //if (this.items[i].toString().toUpperCase().indexOf(this.des.introducido.toUpperCase()) >= 0) {
                    if (itemTemp.toUpperCase().indexOf(this.des.introducido.toUpperCase()) >= 0) {
                        novoItems.push(this.items[i]);
                        novoCodigos.push(this.codigos[i]);
                    }
                }
                if (this.auxItems.length == 0) {
                    this.auxItems = this.items;
                    this.auxCodigos = this.codigos;
                }
                this.addItems(novoCodigos, novoItems);

                //}

                return true;

            }

            function CB_display() {
                if (this.base.style.display != "") {
                    this.resize();
                    this.original = this.selectedIndex;
                    this.base.style.display = "";
                    if (this.cod)
                        this.buscaCodigo(this.cod.value);
                    else {
                        for (i = 0; i < this.items.length; i++) {
                            if (this.items[i].toUpperCase() == this.des.value.toUpperCase()) {
                                this.selectItem(i);
                                break;
                            }
                        }
                        if (this.selectedIndex < 0)
                            this.selectItem(0);
                    }
                    this.base.focus();
                } else
                    this.base.style.display = "none";
            }

            function CB_ocultar() {
                if (this.selectedIndex >= this.items.length)
                    this.selectedIndex = -1;
                this.base.style.display = "none";
                if (this.selectedIndex != this.original)
                    this.change();
                this.original = this.selectedIndex;
            }

//********************************************************** //
// Calculamos el tamaño y posicion que tendrá el Combo.      //
//***********************************************************//
            function CB_resize() {

                var alto = 0;
                var altoElemento = this.des.offsetHeight;
                var altoVentana = document.documentElement.clientHeight;// Para que funcione en IE9 document.body.height devuelve un valor incorrecto
                var altoEncima = getOffsetTop(this.des); //this.des.getBoundingClientRect().top;	
                var altoDebajo = altoVentana - (altoEncima + altoElemento);
                var altoMayor = (altoDebajo > altoEncima ? altoDebajo : altoEncima);
                var numItems = this.items.length;
                var maxi = ((10 * CB_RowHeight) + 1) + (2 * CB_Borde) + CB_Scroll;
                var maxDiv = (maxi < altoDebajo ? maxi : (maxi < altoEncima ? maxi : altoMayor));
                var ctrlMayor = (maxi < altoDebajo ? 1 : (maxi < altoEncima ? -1 : (altoDebajo > altoEncima ? 2 : -2)));

                if (numItems > 10)
                    numItems = 10;

                for (var i = 0; i < numItems; i++) {
                    if ((alto + CB_RowHeight) < maxDiv)
                        alto += CB_RowHeight;
                }
                if (numItems == 0)
                    alto = CB_RowHeight;
                pX = getOffsetLeft(this.des);
                pY = (((ctrlMayor == 1) || (ctrlMayor == 2)) ? altoEncima + altoElemento : altoEncima - (alto + 2 * CB_Borde + CB_Scroll));
                if (isTabPage(this.des)) {
                    pX++;
                    pY++;
                }


                if (typeof (this.base.style.posTop) !== "undefined") //es IE 9
                {
                    this.base.style.posLeft = pX;
                    this.base.style.posTop = pY - document.getElementsByClassName("contenidoPantalla")[0].getBoundingClientRect().top;
                    this.base.style.posHeight = this.view.style.posHeight = (alto + 2 * CB_Borde + CB_Scroll);
                    this.base.style.posWidth = this.view.style.posWidth = this.des.offsetWidth + ((this.view.scrollHeight == this.view.clientHeight) ? 0 : 16);
                } else {
                    this.base.style.left = +pX + "px";
                    this.base.style.top = pY - document.getElementsByClassName("contenidoPantalla")[0].getBoundingClientRect().top + "px";
                    this.base.style.height = this.view.style.height = (alto + 2 * CB_Borde + CB_Scroll) + "px";
                    this.base.style.width = this.view.style.width = this.des.offsetWidth + ((this.view.scrollHeight == this.view.clientHeight) ? 0 : 16) + "px";

                }

            }

//*******************************//
// Reinicia el item selecionado  //
//*******************************//
            function CB_restoreIndex() {
                this.selectedIndex = -1;
            }

            function CB_obligatorio(esObligatorio) {
                if (esObligatorio) {
                    if ('inputTextoObligatorio' != this.des.className) {
                        this.codigos.shift();
                        this.items.shift();
                        if (this.cod)
                            this.cod.className = 'inputTextoObligatorio';
                        this.des.className = 'inputTextoObligatorio';
                        if (this.selectedIndex > 0)
                            this.selectedIndex--;
                    } else {
                        return;
                    }
                } else {
                    if ('inputTextoObligatorio' == this.des.className) {
                        this.codigos = [""].concat(this.codigos);
                        this.items = [""].concat(this.items);
                        if (this.cod)
                            this.cod.className = 'inputTexto';
                        this.des.className = 'inputTexto';
                        if (this.selectedIndex >= 0)
                            this.selectedIndex++;
                    } else {
                        return;
                    }
                }
                var str = '';
                for (var i = 0; i < this.codigos.length; i++) {
                    this.i_codigos[this.codigos[i] + ''] = i;
                    str += '<DIV>' + ((this.items[i]) ? this.items[i] : '&nbsp;') + '</DIV>';
                }
                this.view.innerHTML = str;
                this.selectItem(this.selectedIndex);
                return;
            }

            function CB_addItems(listaCodigos, listaItems) {
                this.codigos = listaCodigos;
                this.items = listaItems;
                if (this.des.className.indexOf('inputTextoObligatorio') < 0) {
                    this.codigos = [""].concat(this.codigos);
                    this.items = [""].concat(this.items);
                } else if (this.codigos == null || this.codigos.length == 0) {
                    this.codigos = [""];
                    this.items = [""];
                }
                var str = '';
                for (var i = 0; i < this.codigos.length; i++) {
                    this.i_codigos[this.codigos[i] + ''] = i;

                    if (this.items[i]) {
                        var auxItem = (this.items[i]);
                        if (this.idioma > 1) {
                            if (auxItem.indexOf("|") > -1)
                                auxItem = auxItem.split("|")[1];
                        } else if (this.idioma == 1) {
                            auxItem = auxItem.split("|")[0];
                        }
                        this.items[i] = auxItem;
                    }
                    str += '<DIV>' + ((this.items[i]) ? this.items[i] : '&nbsp;') + '</DIV>';
                }
                this.view.innerHTML = str;
                this.selectedIndex = -1;
                return true;
            }


            function CB_addItems2(listaCodigos, listaItems, listaEstados) {
                this.codigos = listaCodigos;
                this.items = listaItems;
                this.estados = listaEstados;
                var estados = listaEstados;
                if (this.des.className.indexOf('inputTextoObligatorio') < 0) {
                    this.codigos = [""].concat(this.codigos);
                    this.items = [""].concat(this.items);
                    this.estados = [""].concat(this.estados);
                } else if (this.codigos == null || this.codigos.length == 0) {
                    this.codigos = [""];
                    this.items = [""];
                    this.estados = [""];
                }
                var str = '';
                for (var i = 0; i < this.codigos.length; i++) {
                    this.i_codigos[this.codigos[i] + ''] = i;
                    if (this.items[i]) {
                        var auxItem = (this.items[i]);
                        if (this.idioma > 1) {
                            if (auxItem.indexOf("|") > -1)
                                auxItem = auxItem.split("|")[1];
                        } else if (this.idioma == 1) {
                            auxItem = auxItem.split("|")[0];
                        }
                        this.items[i] = auxItem;
                    }
                    var est = estados[i];
                    if (this.estados[i] != "B") {
                        str += '<DIV>' + ((this.items[i]) ? this.items[i] : '&nbsp;') + '</DIV>';
                    } else {
                        str += '<DIV  class="xCDisabled">' + ((this.items[i]) ? this.items[i] : '&nbsp;') + '</DIV>';
                    }
                }
                this.view.innerHTML = str;
                this.selectedIndex = -1;
                return true;
            }

            function CB_clearItems() {
                this.addItems([""], [""]);
                if (this.cod)
                    this.cod.value = '';
                this.des.value = '';
            }

            function CB_selectItem(rowID) {
                arglen = arguments.length;
                var old = this.selectedIndex;
                var index = (arglen != 0) ? rowID : this.selectedIndex;
                if (this.selectedIndex >= 0 && this.selectedIndex < this.items.length) {
                    if (this.view.children[this.selectedIndex].className != 'xCDisabled') {
                        this.view.children[this.selectedIndex].className = 'xC';
                    } else {
                        var disabled = this.selectedIndex;
                    }
                }
                if (index >= 0 && index < this.items.length && this.view.children[index].className != 'xCDisabled') {
                    this.view.children[index].className = 'xCSelected';
                    this.selectedIndex = index;
                    this.scroll();
                    if (this.cod)
                        this.cod.value = this.codigos[index];
                    this.des.value = this.items[index];
                } else if (index >= 0 && this.view.children[index].className == 'xCDisabled') {
                    if (old > 0) {
                        this.selectedIndex = old;
                        this.scroll();
                        if (this.cod)
                            this.cod.value = this.codigos[old];
                        this.des.value = this.items[old];
                    } else {
                        this.selectedIndex = -1;
                        if (this.cod)
                            this.cod.value = "";
                        this.des.value = "";
                    }
                    if (this.view.children[this.selectedIndex].className != 'xCDisabled') {
                        this.view.children[this.selectedIndex].className = 'xCSelected';
                    }
                } else {
                    if (index < 0) {
                        this.selectedIndex = -1;
                    } else if (index >= this.items.length)
                        this.selectedIndex = this.items.length;
                    if (this.cod)
                        this.cod.value = "";
                    this.des.value = "";
                }
                if (this.selectedIndex != old && this.base.style.display != '' && this.selectedIndex != disabled)
                    this.change();
            }

            function CB_scroll() {
                var selRow = this.view.children[this.selectedIndex];
                var selDiv = this.view;

                if (selRow.offsetTop < selDiv.scrollTop)
                    selDiv.scrollTop = selRow.offsetTop;
                else if (selRow.offsetTop > (selDiv.scrollTop + selDiv.clientHeight - selRow.offsetHeight))
                    selDiv.scrollTop = (selRow.offsetTop - selDiv.clientHeight + selRow.offsetHeight);
            }

            function CB_activate() {
                var clase = new Array();
                if (this.cod) {
                    clase = this.cod.className.split(" ");
                    if (clase[clase.length - 1] == "inputTextoDeshabilitado") {
                        this.cod.disabled = false;
                        CB_removeClass(this.cod);
                    }
                }

                clase = this.des.className.split(" ");
                if (clase[clase.length - 1] == "inputTextoDeshabilitado") {
                    this.des.disabled = false;
                    CB_removeClass(this.des);
                }

                if (this.anchor) {
                    this.anchor.disabled = false;
                    this.anchor.onclick = function () {
                        this.combo.display();
                        return false;
                    };
                }

                if (this.boton) {
                    this.boton.style.cursor = 'hand';
                    this.boton.className = this.boton.className.replace(new RegExp('(?:^|\\s)' + 'faDeshabilitado' + '(?:\\s|$)'), "");
                }
            }

            function CB_deactivate() {
                var clase = new Array();
                if (this.cod) {
                    clase = this.cod.className.split(" ");
                    if (clase[clase.length - 1] != "inputTextoDeshabilitado") {
                        this.cod.disabled = true;
                        this.cod.className += " inputTextoDeshabilitado";
                    }
                }

                clase = this.des.className.split(" ");
                if (clase[clase.length - 1] != "inputTextoDeshabilitado") {
                    this.des.disabled = true;
                    this.des.className += " inputTextoDeshabilitado";
                }

                if (this.anchor) {
                    this.anchor.disabled = true;
                    this.anchor.onclick = function () {
                        return false;
                    };
                }

                if (this.boton) {
                    this.boton.style.cursor = 'default';
                    if (this.boton.className.indexOf("faDeshabilitado") < 0)
                        this.boton.className += " faDeshabilitado";
                }
            }

            function CB_removeClass(ele) {
                var clase = ele.className.split(" ");
                if (clase.length > 1) {
                    ele.className = "";
                    for (i = 0; i < clase.length - 1; i++) {
                        if (i == 0)
                            ele.className += clase[i];
                        else
                            ele.className += " " + clase[i];
                    }
                }
            }

            function CB_contieneOperadoresConsulta(campo) {
                var contiene = false;
                var v = campo.value;
                for (i = 0; i < v.length; i++) {
                    var c = v.charAt(i);
                    if (operadorConsulta.indexOf(c) != -1)
                        contiene = true;
                }
                return contiene;
            }

///////////////////////////////////////////////////////////////////////////////////////////////////////
// FIN OBJETO COMBO
///////////////////////////////////////////////////////////////////////////////////////////////////////
            function getOffsetLeft(el) {
                var ol = el.offsetLeft;
                while ((el = el.offsetParent) != null)
                    ol += el.offsetLeft;
                return ol;
            }

            function getOffsetTop(el) {
                var ot = el.offsetTop;
                while ((el = el.offsetParent) != null)
                    ot += el.offsetTop;
                return ot;
            }

            function isTabPage(el) {
                var pane = false;
                while ((el = el.parentElement) != null) {
                    if (el.className == 'tab-page')
                        pane = true;
                }
                return pane;
            }

            function CB_addElement(lista, elemento) {
                var i = lista.length;
                lista[i] = elemento;
            }

            function CB_deleteElement(lista, index) {
                if (index < 0 || index >= lista.length)
                    return null;
                var val = lista[index];
                var i, j;
                for (i = eval(index); i < (lista.length - 1); i++) {
                    j = i + 1;
                    lista[i] = lista[j];
                }
                lista.length--;
                return val;
            }

            function CB_clearSelected() {
                this.buscaLinea(-1);

                if (this.items) {
                    for (var i = 0; i < this.items.length; i++) {
                        this.view.children[i].className = '';
                    }
                }

                return true;
            }


        </script>    

        <script type="text/javascript">

            var mensajeValidacion = '';

            var comboListaSexo;
            var listaCodigosSexo = new Array();
            var listaDescripcionesSexo = new Array();
            function buscaCodigoSexo(codSexo) {
                comboListaSexo.buscaCodigo(codSexo);
            }
            function cargarDatosSexo() {
                var codSexoSeleccionado = document.getElementById("codListaSexo").value;
                buscaCodigoSexo(codSexoSeleccionado);
            }

            var comboListaMayor55;
            var listaCodigosMayor55 = new Array();
            var listaDescripcionesMayor55 = new Array();
            function buscaCodigoMayor55(codMayor55) {
                comboListaMayor55.buscaCodigo(codMayor55);
            }
            function cargarDatosMayor55() {
                var codMayor55Seleccionado = document.getElementById("codListaMayor55").value;
                buscaCodigoMayor55(codMayor55Seleccionado);
            }

            var comboListaFinFormativa;
            var listaCodigosFinFormativa = new Array();
            var listaDescripcionesFinFormativa = new Array();
            function buscaCodigoFinFormativa(codFinFormativa) {
                comboListaFinFormativa.buscaCodigo(codFinFormativa);
            }
            function cargarDatosFinFormativa() {
                var codFinFormativaSeleccionado = document.getElementById("codListaFinFormativa").value;
                buscaCodigoFinFormativa(codFinFormativaSeleccionado);
            }

            var comboListaOcupacion;
            var listaCodigosOcupacion = new Array();
            var listaDescripcionesOcupacion = new Array();
            function buscaCodigoOcupacion(codOcupacion) {
                comboListaOcupacion.buscaCodigo(codOcupacion);
            }
            function cargarDatosOcupacion() {
                var codOcupacionSeleccionado = document.getElementById("codListaOcupacion").value;
                buscaCodigoOcupacion(codOcupacionSeleccionado);
            }

            var comboListaTitulacion;
            var listaCodigosTitulacion = new Array();
            var listaDescripcionesTitulacion = new Array();
            function buscaCodigoTitulacion(codTitulacion) {
                comboListaTitulacion.buscaCodigo(codTitulacion);
            }
            function cargarDatosTitulacion() {
                var codTitulacionSeleccionado = document.getElementById("codListaTitulacion").value;
                buscaCodigoTitulacion(codTitulacionSeleccionado);
            }

            var comboListaCProfesionalidad;
            var listaCodigosCProfesionalidad = new Array();
            var listaDescripcionesCProfesionalidad = new Array();
            function buscaCodigoCProfesionalidad(codCProfesionalidad) {
                comboListaCProfesionalidad.buscaCodigo(codCProfesionalidad);
            }
            function cargarDatosCProfesionalidad() {
                var codCProfesionalidadSeleccionado = document.getElementById("codListaCProfesionalidad").value;
                buscaCodigoCProfesionalidad(codCProfesionalidadSeleccionado);
            }

            var comboListaJornada;
            var listaCodigosJornada = new Array();
            var listaDescripcionesJornada = new Array();
            function buscaCodigoJornada(codJornada) {
                comboListaJornada.buscaCodigo(codJornada);
            }
            function cargarDatosJornada() {
                var codJornadaSeleccionado = document.getElementById("codListaJornada").value;
                buscaCodigoJornada(codJornadaSeleccionado);
            }

            var comboListaGrupoCotizacion;
            var listaCodigosGrupoCotizacion = new Array();
            var listaDescripcionesGrupoCotizacion = new Array();
            function buscaCodigoGrupoCotizacion(codGrupoCotizacion) {
                comboListaGrupoCotizacion.buscaCodigo(codGrupoCotizacion);
            }
            function cargarDatosGrupoCotizacion() {
                var codGrupoCotizacionSeleccionado = document.getElementById("codListaGrupoCotizacion").value;
                buscaCodigoGrupoCotizacion(codGrupoCotizacionSeleccionado);
            }

            var comboListaTipRetribucion;
            var listaCodigosTipRetribucion = new Array();
            var listaDescripcionesTipRetribucion = new Array();
            function buscaCodigoTipRetribucion(codTipRetribucion) {
                comboListaTipRetribucion.buscaCodigo(codTipRetribucion);
            }
            function cargarDatosTipRetribucion() {
                var codTipRetribucionSeleccionado = document.getElementById("codListaTipRetribucion").value;
                buscaCodigoTipRetribucion(codTipRetribucionSeleccionado);
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
                    buscaCodigoSexo('<%=datModif.getSexo() != null ? datModif.getSexo() : ""%>');
                    buscaCodigoMayor55('<%=datModif.getMayor55() != null ? datModif.getMayor55() : ""%>');
                    buscaCodigoFinFormativa('<%=datModif.getFinFormativa() != null ? datModif.getFinFormativa() : ""%>');
                    buscaCodigoOcupacion('<%=datModif.getOcupacion() != null ? datModif.getOcupacion() : ""%>');
                    buscaCodigoTitulacion('<%=datModif.getTitulacion() != null ? datModif.getTitulacion() : ""%>');
                    buscaCodigoCProfesionalidad('<%=datModif.getcProfesionalidad() != null ? datModif.getcProfesionalidad() : ""%>');
                    buscaCodigoJornada('<%=datModif.getJornada() != null ? datModif.getJornada() : ""%>');
                    buscaCodigoGrupoCotizacion('<%=datModif.getGrupoCotizacion() != null ? datModif.getGrupoCotizacion() : ""%>');
                    buscaCodigoTipRetribucion('<%=datModif.getTipRetribucion() != null ? datModif.getTipRetribucion() : ""%>');
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
                    var nombre = "";
                    var apellido1 = "";
                    var apellido2 = "";
                    if (document.getElementById('nombre').value == null || document.getElementById('nombre').value == '') {
                        nombre = "";
                    } else {
                        nombre = document.getElementById('nombre').value.replace(/\'/g, "''");
                    }
                    if (document.getElementById('apellido1').value == null || document.getElementById('apellido1').value == '') {
                        apellido1 = "";
                    } else {
                        apellido1 = document.getElementById('apellido1').value.replace(/\'/g, "''");
                    }
                    if (document.getElementById('apellido2').value == null || document.getElementById('apellido2').value == '') {
                        apellido2 = "";
                    } else {
                        apellido2 = document.getElementById('apellido2').value.replace(/\'/g, "''");
                    }

                    if (nuevo != null && nuevo == "1") {
                        parametros = "tarea=preparar&modulo=MELANBIDE11&operacion=crearNuevaContratacion&tipo=0"
                                + "&expediente=<%=expediente%>"
                                + "&oferta=" + document.getElementById('oferta').value
                                + "&idContrato1=" + document.getElementById('idContrato1').value
                                + "&idContrato2=" + document.getElementById('idContrato2').value
                                + "&dni=" + document.getElementById('dni').value
                                + '&nombre=' + nombre
                                + '&apellido1=' + apellido1
                                + '&apellido2=' + apellido2
                                + "&fechaNacimiento=" + document.getElementById('fechaNacimiento').value
                                + "&edad=" + document.getElementById('edad').value
                                + "&sexo=" + document.getElementById('codListaSexo').value
                                + "&mayor55=" + document.getElementById('codListaMayor55').value
                                + "&finFormativa=" + document.getElementById('codListaFinFormativa').value
                                + "&codFormativa=" + document.getElementById('codFormativa').value
                                + "&denFormativa=" + document.getElementById('denFormativa').value
                                + "&puesto=" + document.getElementById('puesto').value
                                + "&ocupacion=" + document.getElementById('codListaOcupacion').value
                                + "&desOcupacionLibre=" + document.getElementById('desOcupacionLibre').value
                                + "&desTitulacionLibre=" + document.getElementById('desTitulacionLibre').value
                                + "&titulacion=" + document.getElementById('codListaTitulacion').value
                                + "&cProfesionalidad=" + document.getElementById('codListaCProfesionalidad').value
                                + "&modalidadContrato=" + document.getElementById('modalidadContrato').value
                                + "&jornada=" + document.getElementById('codListaJornada').value
                                + "&porcJornada=" + document.getElementById('porcJornada').value
                                + "&horasConv=" + document.getElementById('horasConv').value
                                + "&fechaInicio=" + document.getElementById('fechaInicio').value
                                + "&fechaFin=" + document.getElementById('fechaFin').value
                                + "&mesesContrato=" + document.getElementById('mesesContrato').value
                                + "&grupoCotizacion=" + document.getElementById('codListaGrupoCotizacion').value
                                + "&direccionCT=" + document.getElementById('direccionCT').value
                                + "&numSS=" + document.getElementById('numSS').value
                                + "&costeContrato=" + document.getElementById('costeContrato').value
                                + "&tipRetribucion=" + document.getElementById('codListaTipRetribucion').value
                                + "&importeSub=" + document.getElementById('importeSub').value
                                ;

                    } else {
                        parametros = "tarea=preparar&modulo=MELANBIDE11&operacion=modificarContratacion&tipo=0"
                                + "&id=<%=datModif != null && datModif.getId() != null ? datModif.getId().toString() : ""%>"
                                + "&oferta=" + document.getElementById('oferta').value
                                + "&idContrato1=" + document.getElementById('idContrato1').value
                                + "&idContrato2=" + document.getElementById('idContrato2').value
                                + "&dni=" + document.getElementById('dni').value
                                + '&nombre=' + nombre
                                + '&apellido1=' + apellido1
                                + '&apellido2=' + apellido2
                                + "&fechaNacimiento=" + document.getElementById('fechaNacimiento').value
                                + "&edad=" + document.getElementById('edad').value
                                + "&sexo=" + document.getElementById('codListaSexo').value
                                + "&mayor55=" + document.getElementById('codListaMayor55').value
                                + "&finFormativa=" + document.getElementById('codListaFinFormativa').value
                                + "&codFormativa=" + document.getElementById('codFormativa').value
                                + "&denFormativa=" + document.getElementById('denFormativa').value
                                + "&puesto=" + document.getElementById('puesto').value
                                + "&ocupacion=" + document.getElementById('codListaOcupacion').value
                                + "&desOcupacionLibre=" + document.getElementById('desOcupacionLibre').value
                                + "&desTitulacionLibre=" + document.getElementById('desTitulacionLibre').value
                                + "&titulacion=" + document.getElementById('codListaTitulacion').value
                                + "&cProfesionalidad=" + document.getElementById('codListaCProfesionalidad').value
                                + "&modalidadContrato=" + document.getElementById('modalidadContrato').value
                                + "&jornada=" + document.getElementById('codListaJornada').value
                                + "&porcJornada=" + document.getElementById('porcJornada').value
                                + "&horasConv=" + document.getElementById('horasConv').value
                                + "&fechaInicio=" + document.getElementById('fechaInicio').value
                                + "&fechaFin=" + document.getElementById('fechaFin').value
                                + "&mesesContrato=" + document.getElementById('mesesContrato').value
                                + "&grupoCotizacion=" + document.getElementById('codListaGrupoCotizacion').value
                                + "&direccionCT=" + document.getElementById('direccionCT').value
                                + "&numSS=" + document.getElementById('numSS').value
                                + "&costeContrato=" + document.getElementById('costeContrato').value
                                + "&tipRetribucion=" + document.getElementById('codListaTipRetribucion').value
                                + "&importeSub=" + document.getElementById('importeSub').value
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
                                }// for elementos de la fila
                                lista[j] = fila;
                                fila = new Array();
                            }
                        }//for(j=0;hijos!=null && j<hijos.length;j++)
                        if (codigoOperacion == "0") {
                            //jsp_alerta("A",'Correcto');
                            self.parent.opener.retornoXanelaAuxiliar(lista);
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

                if (document.getElementById('porcJornada').value == null || document.getElementById('porcJornada').value == '') {
                } else {
                    if (!validarNumericoDecimalPrecision(document.getElementById('porcJornada').value, 5, 2) || !validarNumericoPorcentaje70(document.getElementById('porcJornada').value)) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.porcJornada.errNumerico")%>';
                        return false;
                    }
                }

                if (document.getElementById('mesesContrato').value == null || document.getElementById('mesesContrato').value == '') {
                } else {
                    if (!validarNumerico(document.getElementById('mesesContrato'))) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.mesesContrato.errNumerico")%>';
                        return false;
                    }
                }

                if (document.getElementById('costeContrato').value == null || document.getElementById('costeContrato').value == '') {
                } else {
                    if (!validarNumericoDecimalPrecision(document.getElementById('costeContrato').value, 8, 2)) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.costeContrato.errNumerico")%>';
                        return false;
                    }
                }

                if (document.getElementById('importeSub').value == null || document.getElementById('importeSub').value == '') {
                } else {
                    if (!validarNumericoDecimalPrecision(document.getElementById('importeSub').value, 8, 2)) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.importeSub.errNumerico")%>';
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
                        //alert("TRUEEEEEEE");
                        return true;
                    }
                } catch (err) {
                    alert(err);
                    return false;
                }
            }

            function validarNumericoPorcentaje70(numero) {
                try {
                    if (numero < 70 || numero >= 100) {
                        return false;
                    } else {
                        return true;
                    }
                } catch (err) {
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
                var oferta = document.getElementById('oferta').value;
                var idCOferta = document.getElementById('idContrato1').value;
                var idCDirecto = document.getElementById('idContrato2').value;

                if (
                        ((idCOferta == null || idCOferta == '') && (idCDirecto == null || idCDirecto == ''))
                        ||
                        ((idCOferta != null && idCOferta != '') && (idCDirecto != null && idCDirecto != ''))
                        ||
                        ((idCOferta != null && idCOferta != '') && (oferta == null || oferta == ''))
                        ||
                        ((idCDirecto != null && idCDirecto != '') && (oferta != null && oferta != ''))
                        )
                {
                    mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.datosSeleccion")%>';
                    //return false;
                }

                var dni = document.getElementById('dni').value;
                /*if (dni == null || dni == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.dni")%>';
                 return false;
                 }*/
                var nombre = document.getElementById('nombre').value;
                /*if (nombre == null || nombre == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.nombre")%>';
                 return false;
                 }*/
                var apellido1 = document.getElementById('apellido1').value;
                /*if (apellido1 == null || apellido1 == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.apellido1")%>';
                 return false;
                 }*/
                var apellido2 = document.getElementById('apellido2').value;
                /*if (apellido2 == null || apellido2 == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.apellido2")%>';
                 return false;
                 }*/
                var fechaNacimiento = document.getElementById('fechaNacimiento').value;
                /*if (fechaNacimiento == null || fechaNacimiento == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.fecNac")%>';
                 return false;
                 }*/
                var edad = document.getElementById('edad').value;
                if (edad == null || edad == '') {
                    /*  mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.edad")%>';
                     return false;*/
                } else {
                    if (!validarNumerico(document.getElementById('edad'))) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.edad.errNumerico")%>';
                        return false;
                    }
                }
                var sexo = document.getElementById('codListaSexo').value;
                /*if (sexo == null || sexo == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.sexo")%>';
                 return false;
                 }*/
                var mayor55 = document.getElementById('codListaMayor55').value;
                /*if (mayor55 == null || mayor55 == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.may55")%>';
                 return false;
                 }*/
                var finFormativa = document.getElementById('codListaFinFormativa').value;
                /*if (finFormativa == null || finFormativa == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.finFormativa")%>';
                 return false;
                 }*/

                var puesto = document.getElementById('puesto').value;
                /*if (puesto == null || puesto == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.puesto")%>';
                 return false;
                 }*/
                var ocupacion = document.getElementById('codListaOcupacion').value;
                var desOcupacionLibre = document.getElementById('desOcupacionLibre').value;
                /*if ((ocupacion == null || ocupacion == '') && (desOcupacionLibre == null || desOcupacionLibre == '')) {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.ocupacion")%>';
                 return false;
                 }*/
                var modalidadContrato = document.getElementById('modalidadContrato').value;
                /*if (modalidadContrato == null || modalidadContrato == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.modalidad")%>';
                 return false;
                 }*/
                var jornada = document.getElementById('codListaJornada').value;
                /*if (jornada == null || jornada == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.jornada")%>';
                 return false;
                 }*/
                var porcJornada = document.getElementById('porcJornada').value;
                if (
                        ((jornada == 'PARC') && (porcJornada == null || porcJornada == ''))
                        ||
                        ((jornada != 'PARC') && (porcJornada != null && porcJornada != ''))
                        )
                {
                    mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.porcJornada")%>';
                    return false;
                }
                var horasConv = document.getElementById('horasConv').value;
                if (horasConv == null || horasConv == '') {

                } else {
                    if (!validarNumerico(document.getElementById('horasConv'))) {
                        mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.horasConv.errNumerico")%>';
                        return false;
                    }
                }
                var fechaInicio = document.getElementById('fechaInicio').value;
                /*if (fechaInicio == null || fechaInicio == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.fechInicio")%>';
                 return false;
                 }*/
                var grupoCotizacion = document.getElementById('codListaGrupoCotizacion').value;
                /*if (grupoCotizacion == null || grupoCotizacion == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.grupoCotizacion")%>';
                 return false;
                 }*/
                var direccionCT = document.getElementById('direccionCT').value;
                /*if (direccionCT == null || direccionCT == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.direccionCT")%>';
                 return false;
                 }*/
                var numSS = document.getElementById('numSS').value;
                /*if (numSS == null || numSS == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.nSS")%>';
                 return false;
                 }*/
                var costeContrato = document.getElementById('costeContrato').value;
                /*if (costeContrato == null || costeContrato == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.costeContrato")%>';
                 return false;
                 }*/
                var importeSub = document.getElementById('importeSub').value;
                /*if (importeSub == null || importeSub == '') {
                 mensajeValidacion = '<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.importeSub")%>';
                 return false;
                 }*/


                return correcto;
            }

            function comprobarFechaLanbide(inputFecha) {
                var formato = 'dd/mm/yyyy';
                if (Trim(inputFecha.value) != '') {
                    var D = ValidarFechaConFormatoLanbide(inputFecha.value, formato);
                    if (!D[0]) {
                        jsp_alerta("A", "<%=meLanbide11I18n.getMensaje(idiomaUsuario, "msg.fechaNoVal")%>");
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
            function mostrarCalFechaNacimiento(evento) {
                if (window.event)
                    evento = window.event;
                if (document.getElementById("calFechaNacimiento").src.indexOf("icono.gif") != -1)
                    showCalendar('forms[0]', 'fechaNacimiento', null, null, null, '', 'calFechaNacimiento', '', null, null, null, null, null, null, null, null, evento);

            }

            function mostrarCalFechaInicio(evento) {
                if (window.event)
                    evento = window.event;
                if (document.getElementById("calFechaInicio").src.indexOf("icono.gif") != -1)
                    showCalendar('forms[0]', 'fechaInicio', null, null, null, '', 'calFechaInicio', '', null, null, null, null, null, null, null, null, evento);

            }

            function mostrarCalFechaFin(evento) {
                if (window.event)
                    evento = window.event;
                if (document.getElementById("calFechaFin").src.indexOf("icono.gif") != -1)
                    showCalendar('forms[0]', 'fechaFin', null, null, null, '', 'calFechaFin', '', null, null, null, null, null, null, null, null, evento);

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
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.nuevaContratacion")%>
                        </span>
                    </div> 

                    <br><br>
                    <div  class="sub3titulo" style="clear: both; text-align: center; font-size: 12px;">
                        <span>
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.datosSeleccion")%>
                        </span>
                    </div> 

                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.nOferta")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="oferta" name="oferta" type="text" class="inputTexto" size="20" maxlength="20" 
                                       value="<%=datModif != null && datModif.getOferta() != null ? datModif.getOferta() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.idContratoOferta")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="idContrato1" name="idContrato1" type="text" class="inputTexto" size="20" maxlength="20" 
                                       value="<%=datModif != null && datModif.getIdContrato1() != null ? datModif.getIdContrato1() : ""%>"/>
                            </div>
                        </div>
                    </div> 

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.idContratoDirecto")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="idContrato2" name="idContrato2" type="text" class="inputTexto" size="20" maxlength="20" 
                                       value="<%=datModif != null && datModif.getIdContrato2() != null ? datModif.getIdContrato2() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div  class="sub3titulo" style="clear: both; text-align: center; font-size: 12px;">
                        <span>
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.datosPersonaContratada")%>
                        </span>
                    </div>        


                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.dni_nie")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="dni" name="dni" type="text" class="inputTexto" size="25" maxlength="15" 
                                       value="<%=datModif != null && datModif.getDni() != null ? datModif.getDni() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.nombre")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="nombre" name="nombre" type="text" class="inputTexto" size="100" maxlength="100" 
                                       value="<%=datModif != null && datModif.getNombre() != null ? datModif.getNombre() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.apellido1")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="apellido1" name="apellido1" type="text" class="inputTexto" size="100" maxlength="50" 
                                       value="<%=datModif != null && datModif.getApellido1() != null ? datModif.getApellido1() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.apellido2")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="apellido2" name="apellido2" type="text" class="inputTexto" size="100" maxlength="50" 
                                       value="<%=datModif != null && datModif.getApellido2() != null ? datModif.getApellido2() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.fechaNacimiento")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input type="text" class="inputTxtFecha" 
                                       id="fechaNacimiento" name="fechaNacimiento"
                                       maxlength="10"  size="10"
                                       value="<%=fechaNacimiento%>"
                                       onkeyup = "return SoloCaracteresFechaLanbide(this);"
                                       onblur = "javascript:return comprobarFechaLanbide(this);"
                                       onfocus="javascript:this.select();"/>
                                <A href="javascript:calClick(event);return false;" onClick="mostrarCalFechaNacimiento(event);return false;" style="text-decoration:none;">
                                    <IMG style="border: 0px solid" height="17" id="calFechaNacimiento" name="calFechaNacimiento" border="0" 
                                         src="<c:url value='/images/calendario/icono.gif'/>" > <!--width="25"-->
                                </A>
                            </div>
                        </div>
                    </div> 

                    <br><br>         
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.edad")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="edad" name="edad" type="text" class="inputTexto" size="5" maxlength="2" 
                                       value="<%=datModif != null && datModif.getEdad() != null ? datModif.getEdad() : ""%>"/>
                            </div>
                        </div>
                    </div> 

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.sexo")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaSexo" id="codListaSexo" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaSexo"  id="descListaSexo" size="60" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaSexo" name="anchorListaSexo">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.may55")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaMayor55" id="codListaMayor55" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaMayor55"  id="descListaMayor55" size="60" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaMayor55" name="anchorListaMayor55">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.finFormativa")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaFinFormativa" id="codListaFinFormativa" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaFinFormativa"  id="descListaFinFormativa" size="60" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaFinFormativa" name="anchorListaFinFormativa">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <br><br>      
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.codFormativa")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="codFormativa" name="codFormativa" type="text" class="inputTexto" size="100" maxlength="20" 
                                       value="<%=datModif != null && datModif.getCodFormativa() != null ? datModif.getCodFormativa() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.denFormativa")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="denFormativa" name="denFormativa" type="text" class="inputTexto" size="100" maxlength="20" 
                                       value="<%=datModif != null && datModif.getDenFormativa() != null ? datModif.getDenFormativa() : ""%>"/>
                            </div>
                        </div>
                    </div>
                    <br><br>

                    <div  class="sub3titulo" style="clear: both; text-align: center; font-size: 12px;">
                        <span>
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.datosPuestoTrabajo")%>
                        </span>
                    </div>    

                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.puesto")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="puesto" name="puesto" type="text" class="inputTexto" size="100" maxlength="100" 
                                       value="<%=datModif != null && datModif.getPuesto() != null ? datModif.getPuesto() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br><br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.ocupacion")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaOcupacion" id="codListaOcupacion" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaOcupacion"  id="descListaOcupacion" size="120" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaOcupacion" name="anchorListaOcupacion">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.desOcupacionLibre")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="desOcupacionLibre" name="desOcupacionLibre" type="text" class="inputTexto" size="120" maxlength="150" 
                                       value="<%=datModif != null && datModif.getDesOcupacionLibre() != null ? datModif.getDesOcupacionLibre() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br><br><br>

                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.desTitulacionLibre")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="desTitulacionLibre" name="desTitulacionLibre" type="text" class="inputTexto" size="120" maxlength="150" 
                                       value="<%=datModif != null && datModif.getDesTitulacionLibre() != null ? datModif.getDesTitulacionLibre() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.titulacion")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaTitulacion" id="codListaTitulacion" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaTitulacion"  id="descListaTitulacion" size="120" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaTitulacion" name="anchorListaTitulacion">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.cProfesionalidad")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaCProfesionalidad" id="codListaCProfesionalidad" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaCProfesionalidad"  id="descListaCProfesionalidad" size="120" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaCProfesionalidad" name="anchorListaCProfesionalidad">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.modalidadContrato")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="modalidadContrato" name="modalidadContrato" type="text" class="inputTexto" size="120" maxlength="150" 
                                       value="<%=datModif != null && datModif.getModalidadContrato() != null ? datModif.getModalidadContrato() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.jornada")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaJornada" id="codListaJornada" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaJornada"  id="descListaJornada" size="60" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaJornada" name="anchorListaJornada">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.porcJornada")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="porcJornada" name="porcJornada" type="text" class="inputTexto" size="5" maxlength="5" 
                                       value="<%=datModif != null && datModif.getPorcJornada() != null ? datModif.getPorcJornada().toString().replaceAll("\\.", ","): ""%>" onchange="reemplazarPuntos(this);"/>
                            </div>
                        </div>
                    </div>

                    <br><br>         
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.horasConv")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="horasConv" name="horasConv" type="text" class="inputTexto" size="5" maxlength="2" 
                                       value="<%=datModif != null && datModif.getHorasConv() != null ? datModif.getHorasConv() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.fechaInicio")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input type="text" class="inputTxtFecha" 
                                       id="fechaInicio" name="fechaInicio"
                                       maxlength="10"  size="10"
                                       value="<%=fechaInicio%>"
                                       onkeyup = "return SoloCaracteresFechaLanbide(this);"
                                       onblur = "javascript:return comprobarFechaLanbide(this);"
                                       onfocus="javascript:this.select();"/>
                                <A href="javascript:calClick(event);return false;" onClick="mostrarCalFechaInicio(event);return false;" style="text-decoration:none;">
                                    <IMG style="border: 0px solid" height="17" id="calFechaInicio" name="calFechaInicio" border="0" 
                                         src="<c:url value='/images/calendario/icono.gif'/>" > <!--width="25"-->
                                </A>
                            </div>
                        </div>
                    </div> 

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.fechaFin")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input type="text" class="inputTxtFecha" 
                                       id="fechaFin" name="fechaFin"
                                       maxlength="10"  size="10"
                                       value="<%=fechaFin%>"
                                       onkeyup = "return SoloCaracteresFechaLanbide(this);"
                                       onblur = "javascript:return comprobarFechaLanbide(this);"
                                       onfocus="javascript:this.select();"/>
                                <A href="javascript:calClick(event);return false;" onClick="mostrarCalFechaFin(event);return false;" style="text-decoration:none;">
                                    <IMG style="border: 0px solid" height="17" id="calFechaFin" name="calFechaFin" border="0" 
                                         src="<c:url value='/images/calendario/icono.gif'/>" > <!--width="25"-->
                                </A>
                            </div>
                        </div>
                    </div> 

                    <br><br>         
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.mesesContrato")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="mesesContrato" name="mesesContrato" type="text" class="inputTexto" size="5" maxlength="2" 
                                       value="<%=datModif != null && datModif.getMesesContrato() != null ? datModif.getMesesContrato() : ""%>"/>
                            </div>
                        </div>
                    </div> 

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.grupoCotizacion")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaGrupoCotizacion" id="codListaGrupoCotizacion" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaGrupoCotizacion"  id="descListaGrupoCotizacion" size="120" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaGrupoCotizacion" name="anchorListaGrupoCotizacion">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>


                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.direccionCT")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="direccionCT" name="direccionCT" type="text" class="inputTexto" size="120" maxlength="100" 
                                       value="<%=datModif != null && datModif.getDireccionCT() != null ? datModif.getDireccionCT() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.nSS")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="numSS" name="numSS" type="text" class="inputTexto" size="25" maxlength="20" 
                                       value="<%=datModif != null && datModif.getNumSS() != null ? datModif.getNumSS() : ""%>"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.costeContrato")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="costeContrato" name="costeContrato" type="text" class="inputTexto" size="25" maxlength="10" 
                                       value="<%=datModif != null && datModif.getCosteContrato() != null ? datModif.getCosteContrato().toString().replaceAll("\\.", ","): ""%>" onchange="reemplazarPuntos(this);"/>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div class="etiqueta" style="width: 250px; float: left;">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.tipoRetribucion")%>
                        </div>
                        <div>
                            <div>
                                <input type="text" name="codListaTipRetribucion" id="codListaTipRetribucion" size="12" class="inputTexto" value="" onkeyup="xAMayusculas(this);" />
                                <input type="text" name="descListaTipRetribucion"  id="descListaTipRetribucion" size="60" class="inputTexto" readonly="true" value="" />
                                <a href="" id="anchorListaTipRetribucion" name="anchorListaTipRetribucion">
                                    <span class="fa fa-chevron-circle-down" aria-hidden="true" id="botonAplicacion"
                                          name="botonAplicacion" style="cursor:pointer;"></span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <br><br>
                    <div class="lineaFormulario">
                        <div style="width: 250px; float: left;" class="etiqueta">
                            <%=meLanbide11I18n.getMensaje(idiomaUsuario,"label.importeSub")%>
                        </div>
                        <div>
                            <div style="float: left;">
                                <input id="importeSub" name="importeSub" type="text" class="inputTexto" size="25" maxlength="10" 
                                       value="<%=datModif != null && datModif.getImporteSub() != null ? datModif.getImporteSub().toString().replaceAll("\\.", ","): ""%>" onchange="reemplazarPuntos(this);"/>
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

                /*desplegable sexo*/
                listaCodigosSexo[0] = "";
                listaDescripcionesSexo[0] = "";
                contador = 0;
                <logic:iterate id="sexo" name="listaSexo" scope="request">
                listaCodigosSexo[contador] = ['<bean:write name="sexo" property="des_val_cod" />'];
                listaDescripcionesSexo[contador] = ['<bean:write name="sexo" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaSexo = new Combo("ListaSexo");
                comboListaSexo.addItems(listaCodigosSexo, listaDescripcionesSexo);
                comboListaSexo.change = cargarDatosSexo;

                /*desplegable mayor55*/
                listaCodigosMayor55[0] = "";
                listaDescripcionesMayor55[0] = "";
                contador = 0;
                <logic:iterate id="mayor55" name="listaMayor55" scope="request">
                listaCodigosMayor55[contador] = ['<bean:write name="mayor55" property="des_val_cod" />'];
                listaDescripcionesMayor55[contador] = ['<bean:write name="mayor55" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaMayor55 = new Combo("ListaMayor55");
                comboListaMayor55.addItems(listaCodigosMayor55, listaDescripcionesMayor55);
                comboListaMayor55.change = cargarDatosMayor55;

                /*desplegable finFormativa*/
                listaCodigosFinFormativa[0] = "";
                listaDescripcionesFinFormativa[0] = "";
                contador = 0;
                <logic:iterate id="finFormativa" name="listaFinFormativa" scope="request">
                listaCodigosFinFormativa[contador] = ['<bean:write name="finFormativa" property="des_val_cod" />'];
                listaDescripcionesFinFormativa[contador] = ['<bean:write name="finFormativa" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaFinFormativa = new Combo("ListaFinFormativa");
                comboListaFinFormativa.addItems(listaCodigosFinFormativa, listaDescripcionesFinFormativa);
                comboListaFinFormativa.change = cargarDatosFinFormativa;

                /*desplegable ocupacion*/
                listaCodigosOcupacion[0] = "";
                listaDescripcionesOcupacion[0] = "";
                contador = 0;
                <logic:iterate id="ocupacion" name="listaOcupacion" scope="request">
                listaCodigosOcupacion[contador] = ['<bean:write name="ocupacion" property="campoCodigo" />'];
                listaDescripcionesOcupacion[contador] = ['<bean:write name="ocupacion" property="campoValor" />'];
                contador++;
                </logic:iterate>
                comboListaOcupacion = new Combo("ListaOcupacion");
                comboListaOcupacion.addItems(listaCodigosOcupacion, listaDescripcionesOcupacion);
                comboListaOcupacion.change = cargarDatosOcupacion;

                /*desplegable titulacion*/
                listaCodigosTitulacion[0] = "";
                listaDescripcionesTitulacion[0] = "";
                contador = 0;
                <logic:iterate id="titulacion" name="listaTitulacion" scope="request">
                listaCodigosTitulacion[contador] = ['<bean:write name="titulacion" property="campoCodigo" />'];
                listaDescripcionesTitulacion[contador] = ['<bean:write name="titulacion" property="campoValor" />'];
                contador++;
                </logic:iterate>
                comboListaTitulacion = new Combo("ListaTitulacion");
                comboListaTitulacion.addItems(listaCodigosTitulacion, listaDescripcionesTitulacion);
                comboListaTitulacion.change = cargarDatosTitulacion;

                /*desplegable certificado profesionalidad*/
                listaCodigosCProfesionalidad[0] = "";
                listaDescripcionesCProfesionalidad[0] = "";
                contador = 0;
                <logic:iterate id="CProfesionalidad" name="listaCProfesionalidad" scope="request">
                listaCodigosCProfesionalidad[contador] = ['<bean:write name="CProfesionalidad" property="campoCodigo" />'];
                listaDescripcionesCProfesionalidad[contador] = ['<bean:write name="CProfesionalidad" property="campoValor" />'];
                contador++;
                </logic:iterate>
                comboListaCProfesionalidad = new Combo("ListaCProfesionalidad");
                comboListaCProfesionalidad.addItems(listaCodigosCProfesionalidad, listaDescripcionesCProfesionalidad);
                comboListaCProfesionalidad.change = cargarDatosCProfesionalidad;

                /*desplegable jornada*/
                listaCodigosJornada[0] = "";
                listaDescripcionesJornada[0] = "";
                contador = 0;
                <logic:iterate id="jornada" name="listaJornada" scope="request">
                listaCodigosJornada[contador] = ['<bean:write name="jornada" property="des_val_cod" />'];
                listaDescripcionesJornada[contador] = ['<bean:write name="jornada" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaJornada = new Combo("ListaJornada");
                comboListaJornada.addItems(listaCodigosJornada, listaDescripcionesJornada);
                comboListaJornada.change = cargarDatosJornada;

                /*desplegable grupoCotizacion*/
                listaCodigosGrupoCotizacion[0] = "";
                listaDescripcionesGrupoCotizacion[0] = "";
                contador = 0;
                <logic:iterate id="grupoCotizacion" name="listaGrupoCotizacion" scope="request">
                listaCodigosGrupoCotizacion[contador] = ['<bean:write name="grupoCotizacion" property="des_val_cod" />'];
                listaDescripcionesGrupoCotizacion[contador] = ['<bean:write name="grupoCotizacion" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaGrupoCotizacion = new Combo("ListaGrupoCotizacion");
                comboListaGrupoCotizacion.addItems(listaCodigosGrupoCotizacion, listaDescripcionesGrupoCotizacion);
                comboListaGrupoCotizacion.change = cargarDatosGrupoCotizacion;

                /*desplegable tipRetribucion*/
                listaCodigosTipRetribucion[0] = "";
                listaDescripcionesTipRetribucion[0] = "";
                contador = 0;
                <logic:iterate id="tipRetribucion" name="listaTipRetribucion" scope="request">
                listaCodigosTipRetribucion[contador] = ['<bean:write name="tipRetribucion" property="des_val_cod" />'];
                listaDescripcionesTipRetribucion[contador] = ['<bean:write name="tipRetribucion" property="des_nom" />'];
                contador++;
                </logic:iterate>
                comboListaTipRetribucion = new Combo("ListaTipRetribucion");
                comboListaTipRetribucion.addItems(listaCodigosTipRetribucion, listaDescripcionesTipRetribucion);
                comboListaTipRetribucion.change = cargarDatosTipRetribucion;

                var nuevo = "<%=nuevo%>";
                if (nuevo == 0) {
                    rellenardatModificar();
                }

            </script>
            <div id="popupcalendar" class="text"></div>        
        </div>
    </body>
</html> 
