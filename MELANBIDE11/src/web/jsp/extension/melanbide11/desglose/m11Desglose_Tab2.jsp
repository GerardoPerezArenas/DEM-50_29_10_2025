<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="es.altia.flexia.integracion.moduloexterno.melanbide11.i18n.MeLanbide11I18n" %>
<%@page import="es.altia.agora.business.escritorio.UsuarioValueObject" %>
<%
	UsuarioValueObject usuarioTab2 = new UsuarioValueObject();
	int idiomaUsuarioTab2 = 1; int aplTab2 = 5; String cssTab2 = "";
	if (session.getAttribute("usuario") != null){
		usuarioTab2 = (UsuarioValueObject) session.getAttribute("usuario");
		idiomaUsuarioTab2 = usuarioTab2.getIdioma();
		aplTab2 = usuarioTab2.getAppCod();
		cssTab2 = usuarioTab2.getCss();
	}
	MeLanbide11I18n i18nM11Tab2 = MeLanbide11I18n.getInstance();
	String numExpedienteTab2 = (String) request.getAttribute("numExp");
	String idContratoTab2 = (String) request.getAttribute("id");
%>
</style>


<div class="m11-desglose-wrapper">


  <div class="legendAzul"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.titulo1") %></div>

	<div class="m11-loader" id="loaderDesgloseRSB"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.cargando") %></div>
	<div id="wrapperTablaDesgloseRSB" class="m11-desglose-wrapper" style="display:none; width:100%;">
		<div id="tablaDesgloseRSB" align="center"></div>
	</div>


	<div class="botonera-centro">
		<input type="button" id="btnNuevoT1" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.nuevo") %>" onclick="m11_nuevoLineaTipo1();" />
		<input type="button" id="btnModificarT1" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.modificar") %>" onclick="m11_modificarLineaTipo1();" />
		<input type="button" id="btnEliminarT1" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.eliminar") %>" onclick="m11_eliminarLineaTipo1();" />
	</div>

	<div id="mensajeVacioDesglose" class="m11-empty" style="display:none;">
		<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.sinLineas") %>
	</div>
	
  <div class="legendAzul" style="margin-top:12px;"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.titulo2") %></div>

	<div class="m11-loader" id="loaderDesgloseRSB2" style="display:none;"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.cargando") %></div>
	<div id="wrapperTablaDesgloseRSB2" class="m11-desglose-wrapper" style="display:none; width:100%;">
		<div id="tablaDesgloseRSB2" align="center"></div>
	</div>

	
	<div class="botonera-centro">
		<input type="button" id="btnNuevoT2" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.nuevo") %>" onclick="m11_nuevoLineaTipo2();" />
		<input type="button" id="btnModificarT2" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.modificar") %>" onclick="m11_modificarLineaTipo2();" />
		<input type="button" id="btnEliminarT2" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.eliminar") %>" onclick="m11_eliminarLineaTipo2();" />
	</div>

	<div id="mensajeVacioDesglose2" class="m11-empty" style="display:none;">
		<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.sinLineas") %>
	</div>
	
	
	<div id="m11DialogOverlay" class="m11-dialog-overlay" role="dialog" aria-modal="true" aria-labelledby="m11DialogTitle" style="display:none">
		<div class="m11-dialog">
			<header id="m11DialogTitle" class="m11-title">Editar línea</header>
			<div class="body">
				<div class="lineaFormulario">
					<div class="etiqueta">
						<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %>
					</div>
					<input type="text" id="dlgImporte" class="inputTexto" placeholder="0,00" style="text-align: right;" />
				</div>
				
				<div class="lineaFormulario">
					<div class="etiqueta">
						<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.concepto") %>
					</div>
					<div class="dropdown-container">
						<input type="text" id="dlgConcepto" class="inputTexto dropdown-input" readonly="true" placeholder="Seleccionar concepto..." />
						<input type="hidden" id="dlgConceptoCodigo" value="" />
						<span class="dropdown-arrow">?</span>
					</div>
				</div>
				
				<div class="lineaFormulario">
					<div class="etiqueta">
						<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.observ") %>
					</div>
					<textarea id="dlgObserv" class="inputTexto" maxlength="500" rows="3" placeholder="Observaciones..."></textarea>
				</div>
			</div>
			<footer>
				<input type="button" id="dlgAceptar" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.aceptar") %>" />
				<input type="button" id="dlgCancelar" class="botonGeneral" value="Cancelar" />
			</footer>
		</div>
	</div>
</div>

<script type="text/javascript">
(function(){
	var ctx = '<%=request.getContextPath()%>';
	var numExp = '<%= (numExpedienteTab2!=null?numExpedienteTab2:"") %>';
	var idContrato = '<%= (idContratoTab2!=null?idContratoTab2:"") %>';
	
	// Variables de tabla
	var tablaDesgloseTipo1 = null;
	var tablaDesgloseTipo2 = null;
	var listaLineasTipo1 = [];
	var listaLineasTipo2 = [];
	
	var dniCache = '';
	var lineasAllCache = [];
	function log(){}

	try{ var ov0 = document.getElementById('m11DialogOverlay'); if (ov0) ov0.style.display = 'none'; }catch(e){}

	function formateaImporte(v){
		if (v==null || v==='' || isNaN(v)) return '0,00';
		var n = parseFloat(v);
		return n.toFixed(2).replace('.', ',');
	}
	function parseImporte(t){ if(!t) return 0; var c=t.replace(/\./g,'').replace(',', '.'); var n=parseFloat(c); return isNaN(n)?0:n; }
	function escapeHtml(s){ if(!s) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/'/g,'&#39;'); }

	function muestraEstado(st){
		document.getElementById('loaderDesgloseRSB').style.display = (st==='cargando')? 'block':'none';
		document.getElementById('wrapperTablaDesgloseRSB').style.display = (st==='tabla')? 'block':'none';
		document.getElementById('mensajeVacioDesglose').style.display = (st==='vacio')? 'block':'none';
		document.getElementById('loaderDesgloseRSB2').style.display = (st==='cargando')? 'block':'none';
		document.getElementById('wrapperTablaDesgloseRSB2').style.display = (st==='tabla')? 'block':'none';
		document.getElementById('mensajeVacioDesglose2').style.display = (st==='vacio')? 'block':'none';
	}
	function mostrarVacio(){ muestraEstado('vacio'); }

  function crearTablasDesglose(){
    // Crear con ancho dinámico para evitar scroll horizontal
    var anchoInicial = 600; // Ancho inicial conservador
    
    tablaDesgloseTipo1 = new FixedColumnTable(document.getElementById('tablaDesgloseRSB'), anchoInicial, anchoInicial, 'tablaDesgloseRSB');
    tablaDesgloseTipo1.addColumna('100', 'right', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %>');
    tablaDesgloseTipo1.addColumna('120', 'left',  '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.concepto") %>');
    tablaDesgloseTipo1.addColumna('380', 'left', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.observ") %>');
    tablaDesgloseTipo1.displayCabecera = true; tablaDesgloseTipo1.height = 200; tablaDesgloseTipo1.altoCabecera = 30;
    tablaDesgloseTipo1.dblClkFunction = 'dblClckTablaDesgloseTipo1';

    tablaDesgloseTipo2 = new FixedColumnTable(document.getElementById('tablaDesgloseRSB2'), anchoInicial, anchoInicial, 'tablaDesgloseRSB2');
    tablaDesgloseTipo2.addColumna('100', 'right', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %>');
    tablaDesgloseTipo2.addColumna('120', 'left',  '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.concepto") %>');
    tablaDesgloseTipo2.addColumna('380', 'left', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.observ") %>');
    tablaDesgloseTipo2.displayCabecera = true; tablaDesgloseTipo2.height = 200; tablaDesgloseTipo2.altoCabecera = 30;
    tablaDesgloseTipo2.dblClkFunction = 'dblClckTablaDesgloseTipo2';
  }
	function recalcularAnchoTabla(){
		// Eliminar scroll horizontal ajustando dinámicamente el ancho de las tablas
		try {
			var contenedor = document.getElementById('m11Container') || document.body;
			var anchoContenedor = contenedor.offsetWidth || 750;
			var anchoDisponible = Math.max(600, anchoContenedor - 100); // Más margen para evitar scrolls
			
			console.log('Recalculando ancho tabla:', anchoDisponible);
			
			// Actualizar propiedades de FixedColumnTable correctamente
			if (tablaDesgloseTipo1) {
				tablaDesgloseTipo1.anchoTabla = anchoDisponible;
				tablaDesgloseTipo1.parentWidth = anchoDisponible;
				tablaDesgloseTipo1.scrollWidth = anchoDisponible;
				tablaDesgloseTipo1.width = anchoDisponible;
			}
			if (tablaDesgloseTipo2) {
				tablaDesgloseTipo2.anchoTabla = anchoDisponible;
				tablaDesgloseTipo2.parentWidth = anchoDisponible;
				tablaDesgloseTipo2.scrollWidth = anchoDisponible;
				tablaDesgloseTipo2.width = anchoDisponible;
			}
			
			// Aplicar estilos CSS directamente a TODOS los elementos de scroll
			var selectors = [
				'#wrapperTablaDesgloseRSB, #wrapperTablaDesgloseRSB2',
				'#tablaDesgloseRSB, #tablaDesgloseRSB2',
				'.m11-desglose-wrapper',
				'[id*="scrollcontent_"]',
				'[id*="frozencontent_"]',
				'[id*="hScroll_"]'
			];
			
			selectors.forEach(function(selector) {
				var elementos = document.querySelectorAll(selector);
				for (var i = 0; i < elementos.length; i++) {
					// Solo aplicar estilos si el elemento no está oculto
					if (elementos[i].style.display !== 'none') {
						elementos[i].style.maxWidth = anchoDisponible + 'px';
						elementos[i].style.overflowX = 'hidden';
						// No forzar width: 100% en wrappers que podrían necesitar display específico
						if (!elementos[i].id || (elementos[i].id.indexOf('wrapper') === -1 && elementos[i].id.indexOf('tabla') === -1)) {
							elementos[i].style.width = '100%';
						}
					}
				}
			});
			
			// Forzar que NO aparezcan scrolls horizontales SOLO en divs del desglose
			setTimeout(function() {
				// Ocultar solo los scrolls horizontales específicos de FixedColumnTable EN EL DESGLOSE
				var modalDesglose = document.querySelector('.m11-desglose-wrapper');
				if (modalDesglose) {
					var scrollElements = modalDesglose.querySelectorAll('[id*="hScroll_"]:not([id*="wrapper"]):not([id*="tabla"])');
					for (var i = 0; i < scrollElements.length; i++) {
						scrollElements[i].style.display = 'none';
						scrollElements[i].style.visibility = 'hidden';
						scrollElements[i].style.width = '0px';
						scrollElements[i].style.height = '0px';
					}
					
					// Aplicar estilo directo a las tablas internas de FixedColumnTable EN EL DESGLOSE
					var tablasInternas = modalDesglose.querySelectorAll('table[id*="tbl_"], .FixedColumnTable table');
					for (var i = 0; i < tablasInternas.length; i++) {
						tablasInternas[i].style.width = '100%';
						tablasInternas[i].style.maxWidth = anchoDisponible + 'px';
						tablasInternas[i].style.tableLayout = 'fixed';
					}
				}
			}, 50);
			
			// Solo ocultar scrolls específicos EN EL DESGLOSE, no todos los elementos
			setTimeout(function() {
				var modalDesglose = document.querySelector('.m11-desglose-wrapper');
				if (modalDesglose) {
					var scrollsEspecificos = modalDesglose.querySelectorAll('[id^="hScroll_"], [id*="_hScroll"]');
					for (var i = 0; i < scrollsEspecificos.length; i++) {
						scrollsEspecificos[i].style.display = 'none';
					}
				}
			}, 200);
			
		} catch(e) {
			console.warn("Error recalculando ancho de tabla:", e);
		}
	}

	function construirFilaSimple(d){
		var importe = (d && d.importe!=null)? d.importe:'';
		var concepto = (d && d.concepto)? d.concepto:'';
		var observ = (d && d.observ)? d.observ:'';
		var conceptoMostrar = (concepto==='F'||concepto==='f')?'Fijo':(concepto==='V'||concepto==='v')?'Variable':concepto;
		return [(importe!==''?formateaImporte(importe):'0,00'), (conceptoMostrar?escapeHtml(conceptoMostrar):''), (observ?escapeHtml(observ):'')];
	}

	function refrescarTabla(datos){
		muestraEstado('tabla');
		listaLineasTipo1 = []; listaLineasTipo2 = []; lineasAllCache = [];
		for (var i=0;i<datos.length;i++){
			var d = datos[i] || {};
			lineasAllCache.push({ tipo: (d.tipo!=null? String(d.tipo) : ''), importe: (d.importe!=null? Number(d.importe) : 0), concepto: (d.concepto||''), observ: (d.observ||'') });
			var fila = construirFilaSimple(d);
			var t = d.tipo;
			if(t==='1' || t===1){ listaLineasTipo1.push(fila); }
			else if(t==='2' || t===2){ listaLineasTipo2.push(fila); }
		}
		if (!tablaDesgloseTipo1 || !tablaDesgloseTipo2) { crearTablasDesglose(); }
		if (tablaDesgloseTipo1) { tablaDesgloseTipo1.lineas = listaLineasTipo1; tablaDesgloseTipo1.displayTabla(); tablaDesgloseTipo1.pack(); }
		if (tablaDesgloseTipo2) { tablaDesgloseTipo2.lineas = listaLineasTipo2; tablaDesgloseTipo2.displayTabla(); tablaDesgloseTipo2.pack(); }
		
		// Llamadas adicionales para eliminar scrolls horizontales
		setTimeout(recalcularAnchoTabla, 100);
		setTimeout(recalcularAnchoTabla, 300);
		setTimeout(recalcularAnchoTabla, 500);
		
		actualizarEstadoBotones();
	}

	function actualizarEstadoBotones(){
		var enabled = !!dniCache && (dniCache+'').trim().length>0;
		['btnNuevoT1','btnModificarT1','btnEliminarT1','btnNuevoT2','btnModificarT2','btnEliminarT2']
			.forEach(function(id){ var el=document.getElementById(id); if(el){ el.disabled = !enabled; }});
	}

	// Dilogo inline
	var _dlgOnOk = null, _dlgTipo = '1';
	function abrirDialogoLinea(tipo, def, onOk) {
		_dlgTipo = String(tipo || '1'); _dlgOnOk = (typeof onOk === 'function') ? onOk : null;
		var esNuevo = (def == null); def = def || { importe: 0, concepto: '', observ: '' };
		var titulo = document.getElementById('m11DialogTitle'); 
		if (titulo) { 
			titulo.textContent = esNuevo ? 'Alta retribución' : 'Modificar retribución'; 
		}
		var elImp = document.getElementById('dlgImporte'); 
		var elCon = document.getElementById('dlgConcepto'); 
		var elConCod = document.getElementById('dlgConceptoCodigo');
		var elObs = document.getElementById('dlgObserv');
		if (elImp) { elImp.value = esNuevo ? '' : formateaImporte(def.importe || 0); }
		if (elCon) {
			var textoConcepto = '';
			var codigoConcepto = def.concepto || '';
			if (codigoConcepto === 'F') textoConcepto = 'Fijo';
			else if (codigoConcepto === 'V') textoConcepto = 'Variable';
			else textoConcepto = codigoConcepto;
			elCon.value = textoConcepto;
		}
		if (elConCod) elConCod.value = def.concepto || '';
		if (elObs) elObs.value = def.observ || '';
		var overlay = document.getElementById('m11DialogOverlay'); 
		if (overlay) { 
			overlay.style.display = 'flex'; 
			try { (document.body||document.documentElement).style.overflow='hidden'; }catch(e){} 
			setTimeout(function(){ try{ elImp && elImp.focus(); }catch(e){} },10); 
		}
	}
	function cerrarDialogo(){ var o=document.getElementById('m11DialogOverlay'); if(o){o.style.display='none';} try{ (document.body||document.documentElement).style.overflow=''; }catch(e){} _dlgOnOk=null; try{ setTimeout(recalcularAnchoTabla,60);}catch(e){} }
	document.getElementById('dlgCancelar').onclick = function(){ cerrarDialogo(); };
	document.getElementById('dlgAceptar').onclick = function(){
		var elImp=document.getElementById('dlgImporte'), elCon=document.getElementById('dlgConceptoCodigo'), elObs=document.getElementById('dlgObserv');
		var impNum = parseImporte((elImp && elImp.value)||'0');
		if(isNaN(impNum) || impNum<0){ jsp_alerta('A','Importe no válido'); try{ elImp && elImp.focus(); }catch(e){} return; }
		var codigoConcepto = (elCon && elCon.value) || '';
		if(!codigoConcepto){ jsp_alerta('A','Debe seleccionar un concepto'); return; }
		var datos = { importe: impNum, concepto: codigoConcepto, observ: (elObs && elObs.value)||'' };
		var cb=_dlgOnOk; cerrarDialogo(); try{ if(cb) cb(datos); }catch(e){}
	};

	// Manejo del desplegable de concepto
	document.getElementById('dlgConcepto').onclick = function() {
		mostrarOpcionesConcepto();
	};
	
	// También manejar click en el contenedor dropdown
	document.addEventListener('click', function(event) {
		var dropdown = document.querySelector('.dropdown-container');
		if (dropdown && dropdown.contains(event.target)) {
			mostrarOpcionesConcepto();
		}
	});

	function mostrarOpcionesConcepto() {
		// Cerrar dropdown existente si está abierto
		cerrarDropdownConcepto();
		
		var opciones = [
			{ codigo: 'F', texto: 'Fijo' },
			{ codigo: 'V', texto: 'Variable' }
		];
		
		// Crear el menú dropdown
		var menuHtml = '<div class="dropdown-menu">';
		for (var i = 0; i < opciones.length; i++) {
			menuHtml += '<div class="dropdown-option" data-codigo="' + opciones[i].codigo + '" data-texto="' + opciones[i].texto + '">' + 
						opciones[i].texto + '</div>';
		}
		menuHtml += '</div>';
		
		// Agregar el menú al contenedor
		var contenedorDropdown = document.querySelector('.dropdown-container');
		if (contenedorDropdown) {
			contenedorDropdown.insertAdjacentHTML('beforeend', menuHtml);
			
			// Agregar eventos a las opciones
			var opciones = contenedorDropdown.querySelectorAll('.dropdown-option');
			for (var i = 0; i < opciones.length; i++) {
				opciones[i].addEventListener('click', function(e) {
					e.stopPropagation();
					var codigo = this.getAttribute('data-codigo');
					var texto = this.getAttribute('data-texto');
					seleccionarConcepto(codigo, texto);
				});
			}
			
			// Cerrar dropdown si se hace clic fuera
			setTimeout(function() {
				document.addEventListener('click', manejarClickFuera);
			}, 100);
		}
	}

	function seleccionarConcepto(codigo, texto) {
		document.getElementById('dlgConcepto').value = texto;
		document.getElementById('dlgConceptoCodigo').value = codigo;
		cerrarDropdownConcepto();
	}

	function cerrarDropdownConcepto() {
		var menu = document.querySelector('.dropdown-menu');
		if (menu) {
			menu.remove();
		}
		document.removeEventListener('click', manejarClickFuera);
	}
	
	function manejarClickFuera(event) {
		var contenedorDropdown = document.querySelector('.dropdown-container');
		if (contenedorDropdown && !contenedorDropdown.contains(event.target)) {
			cerrarDropdownConcepto();
		}
	}

	function sanitizarTexto(t){ if(!t) return ''; return String(t).replace(/[|;]/g,' ').trim(); }
	function construirRawDesdeCache(){
		var filas = [];
		for(var i=0;i<lineasAllCache.length;i++){
			var it = lineasAllCache[i]||{};
			var tipo = (it.tipo!=null? String(it.tipo):''); var imp = (it.importe!=null? Number(it.importe):0);
			var conc = sanitizarTexto(it.concepto); var obs = sanitizarTexto(it.observ);
			filas.push([tipo, String(imp), conc, obs].join('|'));
		}
		return filas.join(';;');
	}

	function guardarLineasDesglose(callback){
		if(!dniCache || (dniCache+'').trim()===''){ jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; }
		var raw = construirRawDesdeCache();
		var xhr = new XMLHttpRequest();
		var url = ctx + '/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=guardarLineasDesgloseRSB&tipo=0&numExp=' + encodeURIComponent(numExp) + '&dni=' + encodeURIComponent(dniCache);
		xhr.open('POST', url, true);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=UTF-8');
		xhr.onreadystatechange=function(){
			if(xhr.readyState===4){
				if(xhr.status===200){
					try{
						var resp = JSON.parse(xhr.responseText||'{}');
						var cod = resp && resp.resultado ? (resp.resultado.codigoOperacion+'') : '4';
						if(cod==='0' || cod==='2'){
							jsp_alerta('I','Guardado correcto');
							cargarDesgloseTabla();
							setTimeout(function(){ try{ recalcularAnchoTabla(); }catch(e){} }, 150);
							setTimeout(function(){ try{ recalcularAnchoTabla(); }catch(e){} }, 400);
							if(typeof callback==='function'){ callback(true); }
						}else if(cod==='3'){ jsp_alerta('A','Parmetros insuficientes (DNI)'); if(typeof callback==='function'){ callback(false); }
						}else{ jsp_alerta('A','No se pudo guardar (cdigo '+cod+')'); if(typeof callback==='function'){ callback(false); } }
					}catch(e){ jsp_alerta('A','Respuesta no vlida del servidor'); if(typeof callback==='function'){ callback(false); } }
				}else{ jsp_alerta('A','Error de comunicacin ('+xhr.status+')'); if(typeof callback==='function'){ callback(false); } }
			}
		};
		xhr.send('lineas=' + encodeURIComponent(raw));
	}

	function obtenerSeleccion(tTabla){
		var tabla = (tTabla===1? tablaDesgloseTipo1 : tablaDesgloseTipo2);
		if (!tabla) { jsp_alerta('A','Tabla no inicializada'); return {ok:false}; }
		var idx = tabla.selectedIndex;
		if(idx==null || idx<0){ jsp_alerta('A','Seleccione una fila'); return {ok:false}; }
		var lineasDelTipo = lineasAllCache.filter(function(l){ return String(l.tipo) === String(tTabla); });
		if (idx >= lineasDelTipo.length) { jsp_alerta('A','ndice de fila invlido'); return {ok:false}; }
		var lineaSeleccionada = lineasDelTipo[idx], globalIdx = -1;
		for (var i = 0; i < lineasAllCache.length; i++) { if (lineasAllCache[i] === lineaSeleccionada) { globalIdx = i; break; } }
		if(globalIdx < 0){ jsp_alerta('A','No se pudo localizar la fila seleccionada'); return {ok:false}; }
		return {ok:true, idxTabla: idx, idxGlobal: globalIdx};
	}

	function agregarLinea(tipo){
		abrirDialogoLinea(tipo, null, function(datos){
			lineasAllCache.push({ tipo: String(tipo), importe: Number(datos.importe), concepto: datos.concepto, observ: datos.observ });
			guardarLineasDesglose();
		});
	}
	function modificarLinea(tipo){
		var sel = obtenerSeleccion(tipo); if(!sel.ok) return;
		var item = lineasAllCache[sel.idxGlobal] || {tipo:String(tipo), importe:0, concepto:'', observ:''};
		abrirDialogoLinea(tipo, item, function(datos){
			lineasAllCache[sel.idxGlobal] = { tipo: String(tipo), importe: Number(datos.importe), concepto: datos.concepto, observ: datos.observ };
			guardarLineasDesglose();
		});
	}
	function eliminarLinea(tipo){
		var sel = obtenerSeleccion(tipo); if(!sel.ok) return;
		var r = jsp_alerta('', 'Eliminar la lnea seleccionada?'); if(r!=1) return;
		lineasAllCache.splice(sel.idxGlobal,1); guardarLineasDesglose();
	}

	// Exponer manejadores
	window.m11_nuevoLineaTipo1 = function(){ if(!dniCache){ actualizarEstadoBotones(); jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; } agregarLinea(1); };
	window.m11_modificarLineaTipo1 = function(){ if(!dniCache){ actualizarEstadoBotones(); jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; } if (!tablaDesgloseTipo1 || tablaDesgloseTipo1.selectedIndex == -1){ jsp_alerta('A','Seleccione una fila de la tabla de complementos salariales'); return; } modificarLinea(1); };
	window.m11_eliminarLineaTipo1 = function(){ if(!dniCache){ actualizarEstadoBotones(); jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; } if (!tablaDesgloseTipo1 || tablaDesgloseTipo1.selectedIndex == -1){ jsp_alerta('A','Seleccione una fila de la tabla de complementos salariales'); return; } eliminarLinea(1); };
	window.m11_nuevoLineaTipo2 = function(){ if(!dniCache){ actualizarEstadoBotones(); jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; } agregarLinea(2); };
	window.m11_modificarLineaTipo2 = function(){ if(!dniCache){ actualizarEstadoBotones(); jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; } if (!tablaDesgloseTipo2 || tablaDesgloseTipo2.selectedIndex == -1){ jsp_alerta('A','Seleccione una fila de la tabla de complementos extrasalariales'); return; } modificarLinea(2); };
	window.m11_eliminarLineaTipo2 = function(){ if(!dniCache){ actualizarEstadoBotones(); jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); return; } if (!tablaDesgloseTipo2 || tablaDesgloseTipo2.selectedIndex == -1){ jsp_alerta('A','Seleccione una fila de la tabla de complementos extrasalariales'); return; } eliminarLinea(2); };

	// Doble click
	window.dblClckTablaDesgloseTipo1 = function(){ if (tablaDesgloseTipo1 && tablaDesgloseTipo1.selectedIndex != -1) { m11_modificarLineaTipo1(); } };
	window.dblClckTablaDesgloseTipo2 = function(){ if (tablaDesgloseTipo2 && tablaDesgloseTipo2.selectedIndex != -1) { m11_modificarLineaTipo2(); } };

	function cargarDesgloseTabla(){
		if(!numExp){ mostrarVacio(); return; }
		muestraEstado('cargando');
		var xhr = new XMLHttpRequest();
		var url = ctx + '/PeticionModuloIntegracion.do?tarea=preparar&modulo=MELANBIDE11&operacion=listarLineasDesgloseRSB&tipo=0&numExp=' + encodeURIComponent(numExp) + (idContrato?('&id='+encodeURIComponent(idContrato)):'' );
		xhr.open('GET', url, true);
		xhr.onreadystatechange=function(){
			if(xhr.readyState===4){
				if(xhr.status===200){
					try{
						var resp = xhr.responseText || '';
						var json={}; try{ json = JSON.parse(resp); }catch(e){}
						var lineas = (json && json.lineas)? json.lineas : [];
						dniCache = (json && json.dni ? json.dni : '');
						refrescarTabla(lineas);
						if(!lineas.length){ setTimeout(function(){ document.getElementById('mensajeVacioDesglose').style.display='block'; }, 100); }
					}catch(e){ mostrarVacio(); }
				} else { mostrarVacio(); }
			}
		};
		xhr.send();
	}

	window.refrescarDesgloseRSB = cargarDesgloseTabla;
	
	// Funcin global para guardar desde la pestaa Tab2
	window.guardarDesglose = function() {
		console.log('=== GUARDAR DESGLOSE TAB2 ===');
		if (typeof guardarLineasDesglose === 'function') {
			guardarLineasDesglose(function(resultado) {
				console.log('Guardado completado en Tab2:', resultado);
				if (resultado && resultado.success) {
					console.log('Datos guardados correctamente, cerrando ventana');
					window.close();
				} else {
					console.warn('Error al guardar datos en Tab2');
				}
			});
		} else {
			console.warn('Funcin guardarLineasDesglose no disponible');
			window.close();
		}
	};
	
	setTimeout(cargarDesgloseTabla, 60);

	// =============== FUNCIONES DE DEBUG ===============
	window.debugTablas = function() {
		console.log('=== DEBUG TABLAS ===');
		console.log('tablaDesgloseTipo1:', tablaDesgloseTipo1);
		console.log('tablaDesgloseTipo2:', tablaDesgloseTipo2);
		console.log('dniCache:', dniCache);
		console.log('numExp:', numExp);
		console.log('idContrato:', idContrato);
		console.log('lineasAllCache:', lineasAllCache);
		console.log('listaLineasTipo1:', listaLineasTipo1);
		console.log('listaLineasTipo2:', listaLineasTipo2);
		
		if (tablaDesgloseTipo1) {
			console.log('Tabla1 selectedIndex:', tablaDesgloseTipo1.selectedIndex);
			console.log('Tabla1 lineas:', tablaDesgloseTipo1.lineas);
		}
		if (tablaDesgloseTipo2) {
			console.log('Tabla2 selectedIndex:', tablaDesgloseTipo2.selectedIndex);
			console.log('Tabla2 lineas:', tablaDesgloseTipo2.lineas);
		}
	};

	window.debugModal = function() {
		console.log('=== DEBUG MODAL ===');
		var overlay = document.getElementById('m11DialogOverlay');
		console.log('Modal overlay:', overlay);
		console.log('Modal display:', overlay ? overlay.style.display : 'no existe');
		console.log('dlgImporte:', document.getElementById('dlgImporte'));
		console.log('dlgConcepto:', document.getElementById('dlgConcepto'));
		console.log('dlgObserv:', document.getElementById('dlgObserv'));
	};

	window.testModal = function() {
		console.log('=== TEST MODAL ===');
		abrirDialogoLinea(1, null, function(datos) {
			console.log('Callback recibido:', datos);
		});
	};

	window.testCRUD = function() {
		console.log('=== TEST CRUD ===');
		console.log('Probando crear lnea tipo 1...');
		try { m11_nuevoLineaTipo1(); } catch(e) { console.error('Error nuevo T1:', e); }
		
		setTimeout(function() {
			console.log('Probando crear lnea tipo 2...');
			try { m11_nuevoLineaTipo2(); } catch(e) { console.error('Error nuevo T2:', e); }
		}, 1000);
	};

	console.log('=== SISTEMA DESGLOSE CARGADO ===');
	console.log('Funciones disponibles: debugTablas(), debugModal(), testModal(), testCRUD()');
	
	// Event listeners para eliminar scrolls horizontales
	window.addEventListener('resize', function() {
		setTimeout(recalcularAnchoTabla, 100);
	});
	
	window.addEventListener('load', function() {
		setTimeout(recalcularAnchoTabla, 200);
	});
})();
</script>
