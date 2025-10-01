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
<style>
/* Ajustes mínimos propios */
.m11-empty { text-align:center; font-style:italic; color:#555; }
.m11-loader { font-size:12px; color:#333; padding:6px 4px; }
.m11-actions-bar { padding:6px 0 8px 0; margin-top:8px; }
.m11-actions-bar button, .m11-actions-bar input[type="button"] { font-size:12px; min-width:120px; padding:8px 16px; margin:0 6px; }
.m11-input { font-size:11px; }
.m11-num { text-align:right; }
.m11-mini-btn { font-size:10px; }
.m11-title { text-align:center; font-weight:800; font-size:15px; padding:14px 0 12px 0; letter-spacing:0.3px; color:#1a3d6b; }
.m11-desglose-wrapper { width:100%; box-sizing:border-box; overflow:hidden; max-width:750px; }

/* ELIMINAR COMPLETAMENTE EL SCROLL HORIZONTAL */
#tablaDesgloseRSB, #tablaDesgloseRSB2,
#tablaDesgloseRSB .tablaContenido, #tablaDesgloseRSB2 .tablaContenido,
#tablaDesgloseRSB .tablaFija, #tablaDesgloseRSB2 .tablaFija,
#tablaDesgloseRSB div, #tablaDesgloseRSB2 div {
    overflow-x: hidden !important;
    overflow: hidden !important;
    max-width: 740px !important;
    width: 740px !important;
}

/* Forzar que las tablas no excedan el ancho */
table, .tablaContenido table, .tablaFija table {
    max-width: 740px !important;
    width: 740px !important;
    table-layout: fixed !important;
}

/* Permitir wrap solo en observaciones */
#tablaDesgloseRSB td:last-child, #tablaDesgloseRSB2 td:last-child { 
    white-space: normal !important; 
    word-wrap: break-word !important; 
    padding: 6px 8px; 
    vertical-align: top;
    line-height: 1.4;
}

/* Diálogo inline para alta/modificación de línea */
.m11-dialog-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.25); display:none; align-items:center; justify-content:center; z-index:9999; }
.m11-dialog { background:#fff; border:1px solid #999; border-radius:6px; min-width:640px; max-width:800px; box-shadow:0 6px 24px rgba(0,0,0,0.25); }
.m11-dialog header { padding:12px 16px; font-weight:bold; border-bottom:1px solid #e0e0e0; font-size:14px; }
.m11-dialog header.m11-title { 
    background: linear-gradient(135deg, #1a3d6b 0%, #2564a5 100%);
    color: white;
    text-align: center;
    font-weight: 800;
    font-size: 15px;
    padding: 14px 0 12px 0;
    letter-spacing: 0.3px;
    border-bottom: none;
    margin: 0;
    border-radius: 6px 6px 0 0;
}
.m11-dialog .body { padding:14px 16px 8px; }
.m11-dialog .row { display:flex; gap:12px; align-items:center; margin-bottom:10px; }
.m11-dialog .row label { display:inline-block; width:160px; text-align:left; font-size:13px; color:#222; font-weight:600; }
.m11-dialog .row input[type="text"], .m11-dialog .row textarea, .m11-dialog .row select { flex:1; font-size:13px; padding:6px 8px; border:1px solid #bbb; border-radius:4px; }
.m11-dialog .row textarea { min-height:90px; resize:vertical; }
.m11-dialog footer { display:flex; gap:12px; justify-content:flex-end; padding:12px 16px 14px; border-top:1px solid #e0e0e0; }
</style>
<!-- Usaremos la API Tabla/TablaEca como en justificaPreparadores23.jsp -->
<div class="m11-desglose-wrapper" style="padding:6px 8px 14px 8px;">
	<div class="m11-title" style="font-size:13px; padding:8px 0 12px 0;">
  <%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.titulo1") %>
</div>
	<div class="m11-loader" id="loaderDesgloseRSB"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.cargando") %></div>
	<div id="wrapperTablaDesgloseRSB" style="display:none; width:100%;">
		<div id="tablaDesgloseRSB" align="center"></div>
	</div>
	<!-- Botonera bajo la primera tabla -->
	<div class="m11-actions-bar" style="text-align:center; margin-top:4px;">
		<input type="button" id="btnNuevoT1" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.nuevo") %>" onclick="m11_nuevoLineaTipo1();" />
		<input type="button" id="btnModificarT1" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.modificar") %>" onclick="m11_modificarLineaTipo1();" />
		<input type="button" id="btnEliminarT1" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.eliminar") %>" onclick="m11_eliminarLineaTipo1();" />
	</div>
	<div id="mensajeVacioDesglose" class="m11-empty" style="display:none;">
		<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.sinLineas") %>
	</div>
	
	<!-- Segunda tabla para tipo 2 -->
	<div class="m11-title" style="font-size:13px; padding:16px 0 12px 0;">
  <%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.titulo2") %>
</div>
	<div class="m11-loader" id="loaderDesgloseRSB2" style="display:none;"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.cargando") %></div>
	<div id="wrapperTablaDesgloseRSB2" style="display:none; width:100%;">
		<div id="tablaDesgloseRSB2" align="center"></div>
	</div>
	<!-- Botonera bajo la segunda tabla -->
	<div class="m11-actions-bar" style="text-align:center; margin-top:6px;">
		<input type="button" id="btnNuevoT2" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.nuevo") %>" onclick="m11_nuevoLineaTipo2();" />
		<input type="button" id="btnModificarT2" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.modificar") %>" onclick="m11_modificarLineaTipo2();" />
		<input type="button" id="btnEliminarT2" class="botonGeneral" value="<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "btn.eliminar") %>" onclick="m11_eliminarLineaTipo2();" />
	</div>
	<div id="mensajeVacioDesglose2" class="m11-empty" style="display:none;">
		<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.sinLineas") %>
	</div>
	
	<!-- Botón Volver movido al JSP principal (m11Desglose.jsp) -->
	
	<!-- Log visual eliminado a petición. Mantengo función log solo a consola. -->
    
	<!-- Diálogo reutilizable para alta/modificación de línea -->
	
	<div id="m11DialogOverlay" class="m11-dialog-overlay" role="dialog" aria-modal="true" aria-labelledby="m11DialogTitle" style="display:none">

		<div class="m11-dialog">
			<header id="m11DialogTitle" class="m11-title">Editar l&iacute;nea</header>
			<div class="body">
				<div class="row">
					<label for="dlgImporte"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %></label>
					<input type="text" id="dlgImporte" class="inputTexto m11-num" placeholder="¤" />
				</div>
				<div class="row">
					<label for="dlgConcepto"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.concepto") %></label>
					<select id="dlgConcepto" class="inputTexto">
						<option value="">Seleccionar...</option>
						<option value="F">Fijo</option>
						<option value="V">Variable</option>
					</select>
				</div>
				<div class="row">
					<label for="dlgObserv"><%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.observ") %></label>
					<textarea id="dlgObserv" class="inputTexto" maxlength="500"></textarea>
				</div>
			</div>
			<footer style="justify-content:center;">
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
	
	// Variables de tabla - usar el mismo patrón que melanbide11.jsp
	var tablaDesgloseTipo1 = null; // FixedColumnTable para complementos salariales
	var tablaDesgloseTipo2 = null; // FixedColumnTable para complementos extrasalariales
	var listaLineasTipo1 = []; // datos para tabla tipo 1
	var listaLineasTipo2 = []; // datos para tabla tipo 2
	
	var dniCache = '';
	var lineasAllCache = []; // cache con todas las líneas [{tipo,importe,concepto,observ}]
	// loggerDiv eliminado (no se muestra log visual)
	function log(){ /* noop */ }

		// Saneado inicial: asegurar overlay oculto
		try{ var ov0 = document.getElementById('m11DialogOverlay'); if (ov0) ov0.style.display = 'none'; }catch(e){}

	function formateaImporte(v){
		if (v==null || v==='' || isNaN(v)) return '0,00';
		var n = parseFloat(v);
		return n.toFixed(2).replace('.', ',');
	}

	function parseImporte(texto){
		if(!texto) return 0;
		var clean = texto.replace(/\./g,'').replace(',', '.');
		var n = parseFloat(clean); return isNaN(n)?0:n;
	}

	function escapeHtml(str){
		if(!str) return '';
		return String(str)
			.replace(/&/g,'&amp;')
			.replace(/</g,'&lt;')
			.replace(/>/g,'&gt;')
			.replace(/'/g,'&#39;');
	}

	function muestraEstado(estado){
		document.getElementById('loaderDesgloseRSB').style.display = (estado==='cargando')? 'block':'none';
		document.getElementById('wrapperTablaDesgloseRSB').style.display = (estado==='tabla')? 'block':'none';
		document.getElementById('mensajeVacioDesglose').style.display = (estado==='vacio')? 'block':'none';
		
		// Segunda tabla
		document.getElementById('loaderDesgloseRSB2').style.display = (estado==='cargando')? 'block':'none';
		document.getElementById('wrapperTablaDesgloseRSB2').style.display = (estado==='tabla')? 'block':'none';
		document.getElementById('mensajeVacioDesglose2').style.display = (estado==='vacio')? 'block':'none';
	}

	function mostrarVacio(){ muestraEstado('vacio'); }

    function crearTablasDesglose(){
        // Crear tabla tipo 1 (Complementos Salariales) - ajustada a ancho del título
        tablaDesgloseTipo1 = new FixedColumnTable(document.getElementById('tablaDesgloseRSB'), 740, 740, 'tablaDesgloseRSB');
        tablaDesgloseTipo1.addColumna('110', 'right', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %>');
        tablaDesgloseTipo1.addColumna('130', 'left',  '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.concepto") %>');
        tablaDesgloseTipo1.addColumna('500', 'left', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.observ") %>');
        
        // Configurar propiedades igual que en melanbide11.jsp
        tablaDesgloseTipo1.displayCabecera = true;
        tablaDesgloseTipo1.height = 200;
        tablaDesgloseTipo1.altoCabecera = 30;
        tablaDesgloseTipo1.dblClkFunction = 'dblClckTablaDesgloseTipo1';

        // Crear tabla tipo 2 (Complementos Extrasalariales) - ajustada a ancho del título
        tablaDesgloseTipo2 = new FixedColumnTable(document.getElementById('tablaDesgloseRSB2'), 740, 740, 'tablaDesgloseRSB2');
        tablaDesgloseTipo2.addColumna('110', 'right', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %>');
        tablaDesgloseTipo2.addColumna('110', 'right', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.importe") %>');
        tablaDesgloseTipo2.addColumna('130', 'left',  '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.concepto") %>');
        tablaDesgloseTipo2.addColumna('500', 'left', '<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.col.observ") %>');
        
        // Configurar propiedades igual que en melanbide11.jsp
        tablaDesgloseTipo2.displayCabecera = true;
        tablaDesgloseTipo2.height = 200;
        tablaDesgloseTipo2.altoCabecera = 30;
        tablaDesgloseTipo2.dblClkFunction = 'dblClckTablaDesgloseTipo2';
    }	// TablaEca gestiona tamaños internamente.
	function recalcularAnchoTabla(){}

	function construirFilaSimple(d){
		var importe = (d && d.importe!=null)? d.importe:'';
		var concepto = (d && d.concepto)? d.concepto:'';
		var observ = (d && d.observ)? d.observ:'';
		
		// Convertir F/V a Fijo/Variable
		var conceptoMostrar = '';
		if (concepto === 'F' || concepto === 'f') {
			conceptoMostrar = 'Fijo';
		} else if (concepto === 'V' || concepto === 'v') {
			conceptoMostrar = 'Variable';
		} else {
			conceptoMostrar = concepto; // Mantener valor original si no es F/V
		}
		
		return [
			(importe!==''?formateaImporte(importe):'0,00'),
			(conceptoMostrar?escapeHtml(conceptoMostrar):''),
			(observ?escapeHtml(observ):'')
		];
	}

	function refrescarTabla(datos){
		muestraEstado('tabla');
		
		// Separar datos por tipo y construir arrays para las tablas
		listaLineasTipo1 = [];
		listaLineasTipo2 = [];
		lineasAllCache = [];
		
		for (var i=0;i<datos.length;i++){
			var d = datos[i] || {};
			lineasAllCache.push({
				tipo: (d.tipo!=null? String(d.tipo) : ''),
				importe: (d.importe!=null? Number(d.importe) : 0),
				concepto: (d.concepto||''),
				observ: (d.observ||'')
			});
			
			var fila = construirFilaSimple(d);
			var t = d.tipo;
			if(t==='1' || t===1){
				listaLineasTipo1.push(fila);
			}else if(t==='2' || t===2){
				listaLineasTipo2.push(fila);
			}
		}
		
		// Crear tablas si no existen
		if (!tablaDesgloseTipo1 || !tablaDesgloseTipo2) {
			crearTablasDesglose();
		}
		
		// Mostrar datos en las tablas usando el patrón de melanbide11.jsp
		if (tablaDesgloseTipo1) {
			tablaDesgloseTipo1.lineas = listaLineasTipo1;
			tablaDesgloseTipo1.displayTabla();
			tablaDesgloseTipo1.pack();
		}
		
		if (tablaDesgloseTipo2) {
			tablaDesgloseTipo2.lineas = listaLineasTipo2;
			tablaDesgloseTipo2.displayTabla();
			tablaDesgloseTipo2.pack();
		}
		
		actualizarEstadoBotones();
	}

	function actualizarEstadoBotones(){
		var enabled = !!dniCache && (dniCache+'').trim().length>0;
		['btnNuevoT1','btnModificarT1','btnEliminarT1','btnNuevoT2','btnModificarT2','btnEliminarT2']
			.forEach(function(id){ var el=document.getElementById(id); if(el){ el.disabled = !enabled; }});
	}

	// Diálogo inline para alta/modificación
	var _dlgOnOk = null, _dlgTipo = '1';
	function abrirDialogoLinea(tipo, def, onOk) {
		_dlgTipo = String(tipo || '1');
		_dlgOnOk = (typeof onOk === 'function') ? onOk : null;
		
		// Determinar si es nuevo (def es null) o modificar (def tiene datos previos)
		var esNuevo = (def === null || def === undefined);
		def = def || { importe: 0, concepto: '', observ: '' };
		
		// Cambiar el título del diálogo
		var titulo = document.getElementById('m11DialogTitle');
		if (titulo) {
			titulo.textContent = esNuevo ? 'Desglose retribución' : 'Editar línea';
		}
		
		var elImp = document.getElementById('dlgImporte');
		var elCon = document.getElementById('dlgConcepto');
		var elObs = document.getElementById('dlgObserv');
		if (elImp) {
			// Si es nuevo, dejar vacío; si es edición, mostrar el importe formateado
			if (esNuevo) {
				elImp.value = '';
			} else {
				elImp.value = formateaImporte(def.importe || 0);
			}
		}
		if (elCon) elCon.value = def.concepto || '';
		if (elObs) elObs.value = def.observ || '';
		var overlay = document.getElementById('m11DialogOverlay');
		if (overlay) {
			overlay.style.display = 'flex';
try { (document.body || document.documentElement).style.overflow = 'hidden'; } catch (e) {}
			setTimeout(function () { try { elImp && elImp.focus(); } catch (e) { } }, 10);
		}
	}
		
	function cerrarDialogo(){
	  var overlay = document.getElementById('m11DialogOverlay');
	  if(overlay){ overlay.style.display='none'; }
try{ (document.body || document.documentElement).style.overflow = ''; }catch(e){}
	  _dlgOnOk=null;
	  try { setTimeout(recalcularAnchoTabla, 60); } catch(e){}
	}

	document.getElementById('dlgCancelar').onclick = function(){ cerrarDialogo(); };
	document.getElementById('dlgAceptar').onclick = function(){
		var elImp = document.getElementById('dlgImporte');
		var elCon = document.getElementById('dlgConcepto');
		var elObs = document.getElementById('dlgObserv');
		var impNum = parseImporte((elImp && elImp.value)||'0');
		if(isNaN(impNum) || impNum<0){ jsp_alerta('A','Importe no válido'); try{ elImp && elImp.focus(); }catch(e){} return; }
		var datos = { importe: impNum, concepto: (elCon && elCon.value)||'', observ: (elObs && elObs.value)||'' };
		var cb = _dlgOnOk; cerrarDialogo(); try{ if(cb) cb(datos); }catch(e){ log('callback error: '+e); }
	};

	function sanitizarTexto(t){ if(!t) return ''; return String(t).replace(/[|;]/g,' ').trim(); }

	function construirRawDesdeCache(){
		var filas = [];
		for(var i=0;i<lineasAllCache.length;i++){
			var it = lineasAllCache[i]||{};
			var tipo = (it.tipo!=null? String(it.tipo):'');
			var imp = (it.importe!=null? Number(it.importe):0);
			var conc = sanitizarTexto(it.concepto);
			var obs = sanitizarTexto(it.observ);
			filas.push([tipo, String(imp), conc, obs].join('|'));
		}
		return filas.join(';;');
	}

	function guardarLineasDesglose(callback){
		if(!dniCache || (dniCache+'').trim()===''){
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>');
			return;
		}
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
							// Reaplicar recalculado tras guardar para evitar "volver" a tamaños por defecto
							setTimeout(function(){ try{ recalcularAnchoTabla(); }catch(e){} }, 150);
							// Segundo tick por si el repaint llega más tarde
							setTimeout(function(){ try{ recalcularAnchoTabla(); }catch(e){} }, 400);
							if(typeof callback==='function'){ callback(true); }
						}else if(cod==='3'){
							jsp_alerta('A','Parámetros insuficientes (DNI)');
							if(typeof callback==='function'){ callback(false); }
						}else{
							jsp_alerta('A','No se pudo guardar (código '+cod+')');
							if(typeof callback==='function'){ callback(false); }
						}
					}catch(e){ jsp_alerta('A','Respuesta no válida del servidor'); if(typeof callback==='function'){ callback(false); } }
				}else{ jsp_alerta('A','Error de comunicación ('+xhr.status+')'); if(typeof callback==='function'){ callback(false); } }
			}
		};
		xhr.send('lineas=' + encodeURIComponent(raw));
	}

	function obtenerSeleccion(tTabla){
		console.log('obtenerSeleccion llamada para tabla:', tTabla);
		console.log('tablaDesgloseTipo1:', tablaDesgloseTipo1);
		console.log('tablaDesgloseTipo2:', tablaDesgloseTipo2);
		
		var tabla = (tTabla===1? tablaDesgloseTipo1 : tablaDesgloseTipo2);
		if (!tabla) { 
			console.log('Tabla no existe para tipo:', tTabla);
			jsp_alerta('A','Tabla no inicializada'); 
			return {ok:false}; 
		}
		
		var idx = tabla.selectedIndex;
		console.log('selectedIndex obtenido:', idx);
		
		if(idx==null || idx<0){ 
			console.log('No hay fila seleccionada');
			jsp_alerta('A','Seleccione una fila'); 
			return {ok:false}; 
		}
		
		// Buscar el índice global en lineasAllCache
		var lineasDelTipo = lineasAllCache.filter(function(l){ return String(l.tipo) === String(tTabla); });
		if (idx >= lineasDelTipo.length) {
			console.log('Índice fuera de rango');
			jsp_alerta('A','Índice de fila inválido'); 
			return {ok:false}; 
		}
		
		var lineaSeleccionada = lineasDelTipo[idx];
		var globalIdx = -1;
		for (var i = 0; i < lineasAllCache.length; i++) {
			if (lineasAllCache[i] === lineaSeleccionada) {
				globalIdx = i;
				break;
			}
		}
		
		console.log('Índice global calculado:', globalIdx);
		
		if(globalIdx < 0){ 
			console.log('No se pudo localizar la fila seleccionada');
			jsp_alerta('A','No se pudo localizar la fila seleccionada'); 
			return {ok:false}; 
		}
		
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
		var r = jsp_alerta('', '¿Eliminar la línea seleccionada?');
		if(r!=1) return;
		lineasAllCache.splice(sel.idxGlobal,1);
		guardarLineasDesglose();
	}

	// Exponer manejadores a global para los botones - usando patrón de melanbide11.jsp
	window.m11_nuevoLineaTipo1 = function(){ 
		if(!dniCache){ 
			actualizarEstadoBotones(); 
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); 
			return; 
		} 
		agregarLinea(1); 
	};
	
	window.m11_modificarLineaTipo1 = function(){ 
		if(!dniCache){ 
			actualizarEstadoBotones(); 
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); 
			return; 
		} 
		if (typeof tablaDesgloseTipo1 === 'undefined' || tablaDesgloseTipo1.selectedIndex == -1){
			jsp_alerta('A','Seleccione una fila de la tabla de complementos salariales');
			return;
		}
		modificarLinea(1); 
	};
	
	window.m11_eliminarLineaTipo1 = function(){ 
		if(!dniCache){ 
			actualizarEstadoBotones(); 
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); 
			return; 
		} 
		if (typeof tablaDesgloseTipo1 === 'undefined' || tablaDesgloseTipo1.selectedIndex == -1){
			jsp_alerta('A','Seleccione una fila de la tabla de complementos salariales');
			return;
		}
		eliminarLinea(1); 
	};
	
	window.m11_nuevoLineaTipo2 = function(){ 
		if(!dniCache){ 
			actualizarEstadoBotones(); 
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); 
			return; 
		} 
		agregarLinea(2); 
	};
	
	window.m11_modificarLineaTipo2 = function(){ 
		if(!dniCache){ 
			actualizarEstadoBotones(); 
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); 
			return; 
		} 
		if (typeof tablaDesgloseTipo2 === 'undefined' || tablaDesgloseTipo2.selectedIndex == -1){
			jsp_alerta('A','Seleccione una fila de la tabla de complementos extrasalariales');
			return;
		}
		modificarLinea(2); 
	};
	
	window.m11_eliminarLineaTipo2 = function(){ 
		if(!dniCache){ 
			actualizarEstadoBotones(); 
			jsp_alerta('A','<%= i18nM11Tab2.getMensaje(idiomaUsuarioTab2, "tab2.desglose.alert.seleccione") %>'); 
			return; 
		} 
		if (typeof tablaDesgloseTipo2 === 'undefined' || tablaDesgloseTipo2.selectedIndex == -1){
			jsp_alerta('A','Seleccione una fila de la tabla de complementos extrasalariales');
			return;
		}
		eliminarLinea(2); 
	};

	// Doble click en filas - usar el patrón de melanbide11.jsp
	window.dblClckTablaDesgloseTipo1 = function(){ 
		if (tablaDesgloseTipo1 && tablaDesgloseTipo1.selectedIndex != -1) {
			m11_modificarLineaTipo1(); 
		}
	};
	window.dblClckTablaDesgloseTipo2 = function(){ 
		if (tablaDesgloseTipo2 && tablaDesgloseTipo2.selectedIndex != -1) {
			m11_modificarLineaTipo2(); 
		}
	};

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
						var json={};
						try{ json = JSON.parse(resp); }catch(e){ }
						var lineas = (json && json.lineas)? json.lineas : [];
						dniCache = (json && json.dni ? json.dni : '');
						// Siempre mostrar cabecera aunque no haya líneas
						refrescarTabla(lineas);
						// No cambiar a estado tabla hasta que refrescarTabla termine
						if(!lineas.length){ 
							setTimeout(function(){
								document.getElementById('mensajeVacioDesglose').style.display='block'; 
							}, 100);
						}
					}catch(e){ mostrarVacio(); }
				} else { mostrarVacio(); }
			}
		};
		xhr.send();
	}

	// Sin edición: no se recogen líneas

	// Sin guardado

// Sin listeners de edición

	window.refrescarDesgloseRSB = cargarDesgloseTabla;
	setTimeout(cargarDesgloseTabla, 60);
})();
</script>
