(function(global){
  // Implementación ligera sin dependencias: paginación, selección y doble click
  function TablaEca(conPaginador, txtBuscar, txtAnterior, txtSiguiente, txtMostrarFilas, txtSinResultados, txtPaginaDe, txtNoReg, txtFiltradosDe, txtPrimero, txtUltimo, contenedor){
    this.contenedor = contenedor;
    this.columns = [];
    this.lineas = [];
    this.displayCabecera = true;
    this.selectedIndex = -1; // índice global (sobre lineaTB_Fondo = '#FFFFFF';
TB_Fuente = '#000000';
TB_FondoActivo = '#E6E6E6';
TB_FondoObs = '#FFFFCC';
function isUndefined(a) {
    return ((typeof a == 'undefined') || (a == null));
}
// var TB_Num = 0;
var TB_NumEca = 100;
// Esto hay que revisarlo, si se inicia con cero hay problemas con las demas tablas de a pagina
//  Tramites, Etc. Contador js TablaNueva
// Se muestran varias veces las herramientas de navegacion/paginacion o no se deja seleccionar las filas
var consecutivo = 100;
if (document.all)
    cursor = 'hand';
else
    cursor = 'pointer';
document.writeln('<style>');
document.writeln('</style>');

function tb_deleteElementEca(lista, index) {
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

function ListaEca() {
    this.items = new Array();
    this.pop = function (item) {
        var newItems = new Array();
        for (var i = 0; i < this.items.length; i++) {
            if (this.items[i] != item)
                newItems[newItems.length] = this.items[i];
        }
        this.items = newItems;
    };
    this.push = function (item) {
        for (var i = 0; i < this.items.length; i++) {
            if (this.items[i] == item)
                return;
        }
        this.items[this.items.length] = item;
    };
}

function GrupoColumnaEca(tabla, nombre, padre) {
    this.nivel = 1;
    this.grupoPadre = (padre || null);
    this.tabla = tabla;
    this.nombre = nombre;
    this.items = new Array();
    this.addColumna = function (ancho, align, nombre, tipoDato) {
        var column = new Array();
        column[0] = ancho;
        column[1] = nombre;
        column[2] = (align || 'left');
        if (!tipoDato || (tipoDato != 'String' && tipoDato != 'Number' && tipoDato != 'Date' && tipoDato != 'Binary'))
            tipoDato = 'String';
        column[3] = tipoDato; //Puede ser String,Number,Date,Binary.
        tabla.columnas[tabla.columnas.length] = column;
        this.items[this.items.length] = column;
    };
    this.addGrupoColumna = function (nombre) {
        var grupo = new GrupoColumnaEca(this.tabla, nombre, this);
        this.items[this.items.length] = grupo;
        this.addNivel();

        return grupo;
    };
    this.addNivel = function () {
        this.nivel++;
        if (this.grupoPadre)
            this.grupoPadre.addNivel();
    };
    this.numColumnas = function () {
        var numCols = 0;
        for (var i = 0; i < this.items.length; i++) {
            if (this.items[i].nombre)
                numCols += this.items[i].numColumnas();
            else if (this.items[i][0] > 0)
                numCols += 1;
        }
        return numCols;
    };
    this.toString = function () {
        var str = '';
        var subStr = '<tr>';
        var ancho = this.tabla.widthTabla();
        for (var i = 0; i < this.items.length; i++) {
            if (!this.items[i].nombre) {
                if (this.items[i][0] > 0) {
                    var anchoCol = (String(this.items[i][0])).indexOf('%') < 0 ? (this.items[i][0] / ancho) * 100 + '%' : this.items[i][0];
                    var texto = this.items[i][1];
                    if (texto == '')
                        texto = '&nbsp;';
                    str += '<th style="width:' + anchoCol + '"';
                    if (this.nivel > 1)
                        str += ' rowspan="' + this.nivel + '"';
                    str += '>' + this.items[i][1] + '</th>';
                }
            } else {
                var anchoCol = (String(this.items[i][0])).indexOf('%') < 0 ? (this.items[i][0] / ancho) * 100 + '%' : this.items[i][0];
                str += '<th style="width:' + anchoCol + '"';
                str += ' colspan="' + this.items[i].numColumnas() + '"';
                str += '>' + this.items[i].nombre + '</th>';
                subStr += this.items[i].toString();
            }
        }
        subStr += '</tr>';

        if (subStr == '<tr></tr>')
            return str;
        else
            return str + '</tr>' + subStr;
    };
}

function getNumIdTableSerie() {
    consecutivo = TB_NumEca++;
    if (document.getElementById('tb_tabla' + (consecutivo)) != null) {
        // MIentras exista un tabla con el mismo ID vaya aumentando la serie para hacerla unica.
        getNumIdTableSerie();
    }
    return consecutivo;
}

/**
 * Constructor de Tabla al que se le pasa un objeto con todos los parametros necesarios para llamar al otro constructor
 */
function TablaEca(datos) {
    var paginar = datos.paginar;
    var buscar = datos.buscar;
    var anterior = datos.anterior;
    var siguiente = datos.siguiente;
    var mosFilasPag = datos.mosFilasPag;
    var msgNoResultBusq = datos.msgNoResultBusq;
    var mosPagDePags = datos.mosPagDePags;
    var noRegDisp = datos.noRegDisp;
    var filtrDeTotal = datos.filtrDeTotal;
    var primero = datos.primero;
    var ultimo = datos.ultimo;
    var par = datos.par;
    var anchoTabla = datos.anchoTabla;
    var altoTabla = datos.altoTabla;

    TablaEca(paginar, buscar, anterior, siguiente, mosFilasPag, msgNoResultBusq, mosPagDePags, noRegDisp, filtrDeTotal, primero, ultimo, par, anchoTabla, altoTabla);
}

/**
 * Constructor de Tabla al que se le pasan todos los parametros como variables individuales
 */
function TablaEca(paginar, buscar, anterior, siguiente, mosFilasPag, msgNoResultBusq, mosPagDePags, noRegDisp, filtrDeTotal, primero, ultimo, par, anchoTabla, altoTabla) {
    this.id = 'tb_tabla' + (getNumIdTableSerie()); // Para evitar que cree tablas con el mimo nombre y no funcione paginacion , nro lineas por pagina y/o seleccion de lineas
    this.parent = par;
    this.parent.tabla = this;
    this.paginar = paginar;
    this.buscar = buscar;
    this.anterior = anterior;
    this.siguiente = siguiente;
    this.mosFilasPag = mosFilasPag;
    this.msgNoResultBusq = msgNoResultBusq;
    this.mosPagDePags = mosPagDePags;
    this.noRegDisp = noRegDisp;
    this.filtrDeTotal = filtrDeTotal;
    this.primero = primero;
    this.ultimo = ultimo;
    this.height = '100%';
    this.multiple = false;   //Si se permite seleccionar más de una fila.
    this.ordenar = false;
    this.ordenaColumna = true; //Para que ordene por la columna sobre la que se haga click.
    this.ultimoTable = false;
    this.focusedIndex = -1;
    this.selectedIndex = -1;

    this.selectedItems = new ListaEca();
    this.estructuraColumnas = new GrupoColumnaEca(this);

    this.anchoTabla = (anchoTabla || 0);

    this.columnas = new Array();
    this.lineas = new Array();
    // Este array de booleanos se usa para resaltar las filas con observaciones
    this.observaciones = new Array();

    this.displayCabecera = false;
    this.dataTable = null;

    this.widthTabla = TB_widthTablaEca;
    this.addGrupoColumna = TB_addGrupoColumnaEca;
    this.addColumna = TB_addColumnaEca;
    this.addLinea = TB_addLineaEca;
    this.getLinea = TB_getLineaEca;
    this.setLinea = TB_setLineaEca;
    this.removeLinea = TB_removeLineaEca;
    this.selectLinea = TB_selectLineaEca;
    this.restoreIndex = TB_restoreIndexEca;
    this.activaRow = TB_activaRowEca;
    this.desactivaRow = TB_desactivaRowEca;
    this.clearTabla = TB_clearTablaEca;
    this.readOnly = false;
    this.litMultiidioma = new Array();
    // Se redefine esta funcion (antes no hacia nada) para que tenga en cuenta
    // el array 'observaciones' a la hora de asignar un estilo a la linea
    this.colorLinea = function (i) {
        if (this.observaciones.length > i)
            if (this.observaciones[i])
                return 'inactivaObs';

        return 'inactiva';
    };

    if (altoTabla != undefined) {
        this.altoScroll = altoTabla;
    } else {
        this.altoScroll = "";
    }
    this.displayTabla = TB_displayTablaEca;
    this.displayTablaConContenido = TB_displayTablaConContenidoEca;
    this.displayTablaConTooltips = TB_displayTablaConTooltipsEca;
    this.displayDatos = function (datos) {};
    this.setLineas = TB_setLineasEca;
}

function TB_widthTablaEca() {
    var anchoTotal = this.anchoTabla;
    if (anchoTotal <= 0) {
        for (var i = 0; i < this.columnas.length; i++) {
            var col = Number(this.columnas[i][0]);
            if (col != 0)
                anchoTotal += col;
        }
        this.anchoTabla = anchoTotal;
    }
    return anchoTotal;
}

function TB_restoreIndexEca() {
    if (this.multiple) {
        this.selectedIndex = new Array(this.lineas.length);
        this.selectedItems = new Lista();
    } else {
        this.selectedIndex = -1;
    }
    this.focusedIndex = -1;
}

function TB_addGrupoColumnaEca(nombre) {
    return this.estructuraColumnas.addGrupoColumna(nombre);
}

function TB_addColumnaEca(ancho, align, nombre, tipoDato) {
    this.estructuraColumnas.addColumna(ancho, align, nombre, tipoDato);
}

function TB_addLineaEca(datos) {
    if (datos.length != this.columnas.length)
        return false;
    else {
        var i = this.lineas.length;
        this.lineas[i] = datos;
        this.focusedIndex = -1;
        this.selectedIndex = -1;
        this.displayTabla();
        return true;
    }
}

function TB_getLineaEca(rowID) {
    if (TB_getLineaEca.arguments.length == 0)
        rowID = this.selectedIndex;
    if (rowID < 0 || rowID >= this.lineas.length)
        return false;
    return this.lineas[rowID];
}

function TB_setLineaEca(datos, rowID) {
    if (datos.length != this.columnas.length)
        return false;
    if (TB_setLineaEca.arguments.length == 1)
        rowID = this.selectedIndex;
    if (rowID < 0 || rowID >= this.lineas.length)
        return false;
    this.lineas[rowID] = datos;
    this.displayTabla();
    return true;
}

function TB_removeLineaEca(rowID) {
    if (TB_removeLineaEca.arguments.length == 0)
        rowID = this.selectedIndex;
    if (rowID < 0 || rowID >= this.lineas.length)
        return false;
    else {
        var i, j;
        for (i = eval(rowID); i < (this.lineas.length - 1); i++) {
            j = i + 1;
            this.lineas[i] = this.lineas[j];
        }
        this.lineas.length--;
        this.focusedIndex = -1;
        this.selectedIndex = -1;
        this.displayTabla();
        return true;
    }
}

function TB_clearTablaEca() {
    this.lineas = new Array();
    this.displayTabla();
    return true;
}

function TB_displayTablaEca() {
    this.restoreIndex();
    TB_NumEca += 1;
    var ancho = this.widthTabla();

    var str = '<thead' + (this.displayCabecera ? '' : ' style="display:none"') + '>' + this.estructuraColumnas.toString() + '</thead>';

    str += '<tbody>';

    for (var i = 0; i < this.lineas.length; i++) {
        // La funcion this.colorLinea se declara en el constructor Tabla() pero
        // OJO en algunas jsp se redefine, por ej. listadoAsientosHistorico.jsp
        str += '<tr class="' + this.colorLinea(i) + '" indice=' + i + '>';
        var lin = this.lineas[i];
        for (var j = 0; j < lin.length; j++) {
            if (this.columnas[j][0] > 0) {
                var anchoCol = (this.columnas[j][0]).indexOf('%') < 0 ? (this.columnas[j][0] / ancho) * 100 + '%' : this.columnas[j][0];
                str += '<td style="text-align:' + this.columnas[j][2] + ';width:' + anchoCol + ';" onclick="selectRowEca(' + i + ',' +
                        this.id + ');" ondblclick="callFromTableToEca(' + i + ',\'' + this.id + '\');">' +
                        (lin[j] == '' ? '&nbsp;' : lin[j]) + '</td>';
            }
        }
        str += '</tr>';
    }
    str += '</tbody>';
    var oChild = null;

    var temp = document.createElement("div");
    temp.innerHTML = "<table>" + str + "</table>";
    var tab = temp.firstChild;
    tab.id = this.id;
    tab.tabla = this;
    tab.style.width = '100%';
    tab.className = "xTabla compact tablaDatos";
    tab.onselectstart = "return false;";

    try {
        if (this.parent) {
            var hijos = new Array();
            hijos = this.parent.children;
            if (hijos != null && hijos.length > 0)
                oChild = hijos[0];
        }//if
    } catch (Err) {
        alert(Err);
    }

    if (oChild) {
        this.parent.removeChild(oChild);
    }
    this.parent.appendChild(tab);

    if (this.dataTable != null)
        this.dataTable.destroy();

    this.dataTable = $("#" + this.id).DataTable({
        "info": this.paginar,
        "paginate": this.paginar,
        "lengthMenu": [10, 25, 50, 100],
        "autoWidth": false,
        "aaSorting": [],
        "scrollY": this.altoScroll,
        "scrollCollapse": true,
        "language": {
            "search": this.buscar,
            "previous": this.anterior,
            "next": this.siguiente,
            "lengthMenu": this.mosFilasPag,
            "zeroRecords": this.msgNoResultBusq,
            "info": this.mosPagDePags,
            "infoEmpty": this.noRegDisp,
            "infoFiltered": this.filtrDeTotal,
            "paginate": {
                "first": this.primero,
                "last": this.ultimo,
                "next": this.siguiente,
                "previous": this.anterior
            }
        }
    });
}

function TB_displayTablaConTooltipsEca(tooltips) {
    this.restoreIndex();
    TB_Num += 1;
    var ancho = this.widthTabla();

    var str = '<thead' + (this.displayCabecera ? '' : ' style="display:none"') + '>' + this.estructuraColumnas.toString() + '</thead>';

    str += '<tbody>';

    for (var i = 0; i < this.lineas.length; i++) {
        // La funcion this.colorLinea se declara en el constructor Tabla() pero
        // OJO en algunas jsp se redefine, por ej. listadoAsientosHistorico.jsp
        str += '<tr class="' + this.colorLinea(i) + '" indice=' + i + '>';
        var lin = this.lineas[i];
        var tool = tooltips[i];
        for (var j = 0; j < lin.length; j++) {
            if (this.columnas[j][0] > 0) {
                var anchoCol = (this.columnas[j][0]).indexOf('%') < 0 ? (this.columnas[j][0] / ancho) * 100 + '%' : this.columnas[j][0];

                title = tool[j] == undefined || tool[j] == '' || tool[j] == 'null' ? '' : 'title="' + tool[j] + '"';
                str += '<td ' + title + ' style="text-align:' + this.columnas[j][2] + ';overflow: hidden; text-overflow: ellipsis;width:' + anchoCol + ';" onclick="selectRowEca(' + i + ',' +
                        this.id + ');" ondblclick="callFromTableToEca(' + i + ',\'' + this.id + '\');">' +
                        (lin[j] == '' ? '&nbsp;' : lin[j]) + '</td>';


            }
        }
        str += '</tr>';
    }
    str += '</tbody>';
    var oChild = null;

    var temp = document.createElement("div");
    temp.innerHTML = "<table>" + str + "</table>";
    var tab = temp.firstChild;
    tab.id = this.id;
    tab.tabla = this;
    tab.style.width = '100%';
    tab.className = "xTabla compact";
    tab.onselectstart = "return false;";

    try {
        if (this.parent) {
            var hijos = new Array();
            hijos = this.parent.children;
            if (hijos != null && hijos.length > 0)
                oChild = hijos[0];
        }//if
    } catch (Err) {
        alert(Err);
    }

    if (oChild) {
        this.parent.removeChild(oChild);
    }
    this.parent.appendChild(tab);

    if (this.dataTable != null)
        this.dataTable.destroy();

    this.dataTable = $("#" + this.id).DataTable({
        "info": this.paginar,
        "paginate": this.paginar,
        "lengthMenu": [10, 25, 50, 100],
        "autoWidth": false,
        "aaSorting": [],
        "language": {
            "search": this.buscar,
            "previous": this.anterior,
            "next": this.siguiente,
            "lengthMenu": this.mosFilasPag,
            "zeroRecords": this.msgNoResultBusq,
            "info": this.mosPagDePags,
            "infoEmpty": this.noRegDisp,
            "infoFiltered": this.filtrDeTotal,
            "paginate": {
                "first": this.primero,
                "last": this.ultimo,
                "next": this.siguiente,
                "previous": this.anterior
            }
        }
    });
}

function TB_displayTablaConContenidoEca() {
    this.restoreIndex();
    TB_NumEca += 1;
    var ancho = this.widthTabla();

    var str = '<thead' + (this.displayCabecera ? '' : ' style="display:none"') + '>' + this.estructuraColumnas.toString() + '</thead>';

    str += '<tbody>';

    for (var i = 0; i < this.lineas.length; i++) {
        // La funcion this.colorLinea se declara en el constructor Tabla() pero
        // OJO en algunas jsp se redefine, por ej. listadoAsientosHistorico.jsp
        str += '<tr class="' + this.colorLinea(i) + '" indice=' + i + '>';
        var lin = this.lineas[i];
        for (var j = 0; j < lin.length; j++) {
            if (this.columnas[j][0] > 0) {
                var anchoCol = (this.columnas[j][0]).indexOf('%') < 0 ? (this.columnas[j][0] / ancho) * 100 + '%' : this.columnas[j][0];
                str += '<td style="text-align:' + this.columnas[j][2] + ';width:' + anchoCol + ';" ondblclick="callFromTableToEca(' + i + ',\'' + this.id + '\');">' +
                        (lin[j] == '' ? '&nbsp;' : lin[j]) + '</td>';
            }
        }
        str += '</tr>';
    }
    str += '</tbody>';
    var oChild = null;

    var temp = document.createElement("div");
    temp.innerHTML = "<table>" + str + "</table>";
    var tab = temp.firstChild;
    tab.id = this.id;
    tab.tabla = this;
    tab.style.width = '100%';
    tab.className = "xTabla compact tablaDatos";
    tab.onselectstart = "return false;";

    try {
        if (this.parent) {
            var hijos = new Array();
            hijos = this.parent.children;
            if (hijos != null && hijos.length > 0)
                oChild = hijos[0];
        }//if
    } catch (Err) {
        alert(Err);
    }

    if (oChild) {
        this.parent.removeChild(oChild);
    }
    this.parent.appendChild(tab);

    if (this.dataTable != null)
        this.dataTable.destroy();

    this.dataTable = $("#" + this.id).DataTable({
        "info": this.paginar,
        "paginate": this.paginar,
        "lengthMenu": [10, 25, 50, 100],
        "autoWidth": false,
        "aaSorting": [],
        "language": {
            "search": this.buscar,
            "previous": this.anterior,
            "next": this.siguiente,
            "lengthMenu": this.mosFilasPag,
            "zeroRecords": this.msgNoResultBusq,
            "info": this.mosPagDePags,
            "infoEmpty": this.noRegDisp,
            "infoFiltered": this.filtrDeTotal,
            "paginate": {
                "first": this.primero,
                "last": this.ultimo,
                "next": this.siguiente,
                "previous": this.anterior
            }
        }
    });
}

function TB_selectLineaEca(rowID) {
    if (this.readOnly)
        return;
    if (!this.multiple && this.selectedIndex >= 0) {
        this.desactivaRow(this.selectedIndex);
    }
    var isSelected = false;
    if (this.multiple) {
        isSelected = (this.selectedIndex[rowID]);
    } else {
        isSelected = (this.selectedIndex == rowID);
    }

    if (isSelected) {
        this.desactivaRow(rowID);
        if (this.multiple) {
            this.selectedIndex[rowID] = false;
            this.selectedItems.pop(rowID);
        } else {
            this.selectedIndex = -1;
            this.focusedIndex = -1;
        }
        var datos = new Array();
        for (i = 0; i < this.columnas.length; i++) {
            datos[i] = '';
        }
        this.displayDatos(datos);
    } else {
        this.activaRow(rowID);

        if (this.multiple) {
            this.selectedIndex[rowID] = true;
            this.selectedItems.push(rowID);
        } else {
            this.selectedIndex = rowID;
            this.focusedIndex = rowID;
        }

        this.displayDatos(this.lineas[rowID]);
    }
}

function TB_activaRowEca(rowID) {
    if (this.readOnly)
        return;
    if (rowID < 0 || rowID >= this.lineas.length)
        return;
    $('#' + this.id + ' > tbody > tr[indice=' + rowID + ']').removeClass('inactiva').addClass('activa');
}

function TB_desactivaRowEca(rowID) {
    if (this.readOnly)
        return;
    if (rowID < 0 || rowID >= this.lineas.length)
        return;
    $('#' + this.id + ' > tbody > tr[indice=' + rowID + ']').removeClass('activa').addClass('inactiva');
}

function selectRowEca(rowID, tab) {
    if (tab.tabla) {
        tab.tabla.selectLinea(rowID);
        callClickEca(rowID, tab.tabla);
    } else if (tab.length != undefined && tab.length > 0) {
        tab = tab[0];
        tab.tabla.selectLinea(rowID);
        callClickEca(rowID, tab.tabla);
    }
    return false;
}

function TB_setLineasEca(datos) {
    this.lineas = new Array();
    for (var k = 0; k < datos.length; k++) {
        this.lineas[k] = new Array();
        for (var m = 0; m < datos[k].length; m++) {
            this.lineas[k][m] = datos[k][m];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                      //
//                Funciones que gestionan los eventos del teclado y del ratón                                     //
//                                                                                                                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////////////

function pushEnterTableEca(tableName, listName) {
    if (tableName.multiple) {
        if ((tableName.focusedIndex > -1) && (tableName.focusedIndex < listName.length)) {
            tableName.selectLinea(tableName.focusedIndex);
            desactiveFocusTableEca(tableName, tableName.focusedIndex);

            tableName.focusedIndex++;
            if (tableName.focusedIndex == listName.length) {
                tableName.focusedIndex = 0;
            }
            rellenarDatosMultipleEca(tableName, tableName.focusedIndex); //No es general.
        }
    } else {
        callFromTableToEca(tableName.focusedIndex, tableName.id); //No es general.
    }
}

function upDownTableEca(tableObject, listName, tecla) {
    var fila = $('#' + tableObject.id + ' > tbody > tr[indice=' + tableObject.focusedIndex + ']').get(0);
    var posicion = fila.rowIndex - 1;

    if (tableObject.multiple) {
        desactiveFocusTableEca(tableObject, tableObject.focusedIndex);
    } else {
        if (tableObject.focusedIndex != -1)
            tableObject.desactivaRow(tableObject.focusedIndex);
    }

    if (tecla == 40) {
        posicion++;

        if (posicion == listName.length)
            posicion = 0;
    }
    if (tecla == 38) {
        posicion--;

        if (posicion < 0)
            posicion = listName.length - 1;
    }

    if (!tableObject.multiple)
        selectRowEca(document.getElementById(tableObject.id).tBodies[0].rows[posicion].getAttribute('indice'), document.getElementById(tableObject.id));
}

function callClickEca(rowID, tableObject) {
    window.focus();

    if (tableObject.multiple) {
        desactiveFocusTableEca(tableObject, tableObject.focusedIndex);
        if (!event.ctrlKey)
            desactiveSelectedRowsEca(tableObject, rowID);
        if (event.shiftKey)
            activeSelectedRowsEca(tableObject, rowID);
        tableObject.focusedIndex = rowID;
        rellenarDatosMultipleEca(tableObject, rowID);// No es general
    } else {
        rellenarDatosEca(tableObject, rowID); //No es general.
    }
}

function desactiveFocusTableEca(tableName, rowID) {
    if (rowID > -1) {
        var selRow = $('#' + tableName.id + ' > tbody > tr[indice=' + rowID + ']').get(0);
        var selRowUp = (rowID > 0) ? $('#' + tableName.id + ' > tbody > tr[indice=' + (rowID - 1) + ']').get(0) : null;
        for (var i = 0; i < selRow.cells.length; i++) {
            selRow.cells(i).className = '';
            if (selRowUp)
                selRowUp.cells(i).className = '';
        }
    }
}

function activeSelectedRowsEca(tableObject, rowID) {
    var inicio = $('#' + tableObject.id + ' > tbody > tr[indice=' + tableObject.focusedIndex + ']').rowIndex;
    var fin = $('#' + tableObject.id + ' > tbody > tr[indice=' + rowID + ']').get(0).rowIndex;
    if (rowID < tableObject.focusedIndex) {
        inicio = $('#' + tableObject.id + ' > tbody > tr[indice=' + rowID + ']').get(0).rowIndex;
        fin = $('#' + tableObject.id + ' > tbody > tr[indice=' + tableObject.focusedIndex + ']').get(0).rowIndex;
    }
    var items = tableObject.selectedItems.items;
    for (var i = 0; i < items.length; i++) {
        tableObject.desactivaRow(items[i]);
    }
    tableObject.selectedIndex = new Array(tableObject.lineas.length);
    tableObject.selectedItems = new ListaEca();

    for (var i = inicio; i <= fin; i++) {
        var k = $('#' + tableObject.id + ' > tbody').rows[i].indice;
        tableObject.activaRow(k);
        tableObject.selectedIndex[k] = true;
        tableObject.selectedItems.push(k);
    }
}

function desactiveSelectedRowsEca(tableObject, rowID) {
    var items = tableObject.selectedItems.items;
    for (var i = 0; i < items.length; i++) {
        if (items[i] != rowID) {
            tableObject.desactivaRow(items[i]);
            tableObject.selectedIndex[items[i]] = false;
            tableObject.selectedItems.pop(items[i]);
        }
    }
}

// INI - Funciones a redefinir en la jsp.
function callFromTableToEca(rowID, tableName) {}	//Se ejecuta en el evento onDbClick.

function rellenarDatosEca(tableName, rowID) {}	//Se ejecuta al cambiar la selección en una Tabla Simple.
function rellenarDatosMultipleEca(tableName, rowID) {}	//Se ejecuta al cambiar la selección en una Tabla Múltiple.
// FIN - Funciones a redefinir en la jsp.

function enlacesPaginacionEca(litMosPagDePags, litAnterior, litSiguiente, numPaginaActual, numeroPaginas, nombreFuncionCarga, litMosResultados, numResultados) {
    var htmlString = " ";
    var desactivada = false;
    numPaginaActual = Number(numPaginaActual);
    numeroPaginas = Number(numeroPaginas);
    if (nombreFuncionCarga == null || nombreFuncionCarga == '')
        desactivada = true;

    htmlString += '<div class="dataTables_info" style="width:30%;">' + litMosPagDePags + '</div>';
    if (numeroPaginas > 7) {
        htmlString = htmlString.replace('_PAGE_', '<span> <input type="text" id="input_paginate" size="3" value=' + numPaginaActual + ' onkeypress=" if(event.which == 13){if (/^([0-9])*$/.test(this.value))' + nombreFuncionCarga + '(this.value)};"></span>');
    } else {
        htmlString = htmlString.replace('_PAGE_', numPaginaActual);
    }
    if (litMosResultados != undefined) {
        htmlString = htmlString.replace('_PAGES_', numeroPaginas + '<p>' + litMosResultados + ' ' + numResultados + '</p>');
    } else {
        htmlString = htmlString.replace('_PAGES_', numeroPaginas);
    }
    htmlString += '<div class="dataTables_paginate paging_simple_numbers" style="width:70%">';
    if (desactivada)
        htmlString += '<a disabled class="paginate_button previous disabled" target="_self">' + litAnterior + '</a>';
    else
        htmlString += '<a ' + (numPaginaActual > 1 ? 'onclick="' + nombreFuncionCarga + '(' + (numPaginaActual - 1) + ');" class="paginate_button previous"' : 'disabled class="paginate_button previous disabled"') + ' target="_self">' + litAnterior + '</a>';
    htmlString += '<span>';
    if (desactivada)
        htmlString += '<a ' + (numPaginaActual > 1 ? ' class="paginate_button disabled"' : 'disabled class="paginate_button current"') + ' target="_self">1</a>';
    else
        htmlString += '<a ' + (numPaginaActual > 1 ? 'onclick="' + nombreFuncionCarga + '(1);" class="paginate_button"' : 'disabled class="paginate_button current"') + ' target="_self">1</a>';
    if (numeroPaginas > 1) {
        var comezo = 2;
        var fin = numeroPaginas;

        if (numeroPaginas > 7)
            if (numPaginaActual < 5)
                fin = 6;
            else if ((numeroPaginas - numPaginaActual) < 4) {
                comezo = numeroPaginas - 4;
                htmlString += '  ...  ';
            } else {
                comezo = numPaginaActual - 1;
                fin = numPaginaActual + 2;
                htmlString += '  ...  ';
            }

        for (var i = comezo; i < fin; i++) {
            if (desactivada)
                htmlString += '<a ' + (numPaginaActual != i ? ' disabled class="paginate_button disabled"' : 'disabled class="paginate_button current"') + ' target="_self">' + i + '</a>';
            else
                htmlString += '<a ' + (numPaginaActual != i ? 'onclick="' + nombreFuncionCarga + '(' + i + ');" class="paginate_button"' : 'disabled class="paginate_button current"') + ' target="_self">' + i + '</a>';
        }

        if ((numeroPaginas - numPaginaActual) > 3 && numeroPaginas > 7) {
            htmlString += '  ...  ';
        }

        if (desactivada)
            htmlString += '<a ' + (numPaginaActual < numeroPaginas ? 'class="paginate_button disabled' : 'disabled class="paginate_button current"') + ' target="_self">' + numeroPaginas + '</a>';
        else
            htmlString += '<a ' + (numPaginaActual < numeroPaginas ? 'onclick="' + nombreFuncionCarga + '(' + numeroPaginas + ');" class="paginate_button' : 'disabled class="paginate_button current"') + ' target="_self">' + numeroPaginas + '</a>';
    }
    htmlString += '</span>';
    if (desactivada)
        htmlString += '<a disabled class="paginate_button next disabled" target="_self">' + litSiguiente + '</a>';
    else
        htmlString += '<a ' + (numPaginaActual < numeroPaginas ? 'onclick="' + nombreFuncionCarga + '(' + (numPaginaActual + 1) + ');" class="paginate_button next"' : 'disabled class="paginate_button next disabled"') + ' target="_self">' + litSiguiente + '</a>';
    htmlString += '</div>';

    return htmlString;
}
s)
    this.dblClkFunction = null;
    this._page = 1;
    this._pageSize = 10;
    this._withPager = !!conPaginador;
    this._i18n = {
      buscar: (txtBuscar || 'Buscar'),
      anterior: (txtAnterior || 'Anterior'),
      siguiente: (txtSiguiente || 'Siguiente'),
      mostrarFilas: (txtMostrarFilas || 'Mostrar filas/página'),
      sinResultados: (txtSinResultados || 'Sin resultados'),
      paginaDe: (txtPaginaDe || 'Página {0} de {1}'),
      noReg: (txtNoReg || 'No hay registros'),
      primero: (txtPrimero || 'Primero'),
      ultimo: (txtUltimo || 'Último')
    };
  }
  TablaEca.prototype.addColumna = function(width, align, titulo){
    this.columns.push({ width: width, align: align, title: titulo });
  };
  TablaEca.prototype.displayTablaConTooltips = function(){
    this._render();
  };
  TablaEca.prototype._render = function(){
    var idBase = this.contenedor.id || ('tabla_' + Math.random().toString(36).slice(2));
    this.contenedor.id = idBase;
    var pagerId = idBase + '_pager';
    var tableId = idBase + '_inner';
    var psId = idBase + '_ps';
    var total = this.lineas.length;
    var totalPages = Math.max(1, Math.ceil(total / this._pageSize));
    if(this._page > totalPages) this._page = totalPages;
    var start = (this._page - 1) * this._pageSize;
    var end = Math.min(total, start + this._pageSize);

    var html = '';
    html += '<div class="tablaeca-container" style="width:100%">';
    html += '  <table id="'+tableId+'" style="width:100%;border-collapse:collapse;font-size:12px">';
    if(this.displayCabecera){
      html += '    <thead><tr>';
      for(var c=0;c<this.columns.length;c++){
        var col = this.columns[c];
        var ta = (col.align==='right'?'right':(col.align==='center'?'center':'left'));
        html += '      <th style="border-bottom:1px solid #ccc;text-align:'+ta+';padding:6px 8px;width:'+col.width+'px">'+(col.title||'')+'</th>';
      }
      html += '    </tr></thead>';
    }
    html += '    <tbody>';
    if(total===0){
      html += '<tr><td colspan="'+this.columns.length+'" style="padding:10px;text-align:center;color:#666">'+this._i18n.noReg+'</td></tr>';
    } else {
      for(var i=start;i<end;i++){
        var row = this.lineas[i] || [];
        html += '<tr data-gidx="'+i+'">';
        for(var k=0;k<this.columns.length;k++){
          var col2 = this.columns[k];
          var ta2 = (col2.align==='right'?'right':(col2.align==='center'?'center':'left'));
          var val = (row[k]!=null? String(row[k]) : '');
          html += '<td style="border-bottom:1px solid #eee;text-align:'+ta2+';padding:6px 8px">'+ val +'</td>';
        }
        html += '</tr>';
      }
    }
    html += '    </tbody>';
    html += '  </table>';
    if(this._withPager){
      html += '  <div id="'+pagerId+'" style="display:flex;gap:8px;align-items:center;justify-content:flex-end;padding:8px 0">';
      html += '    <span>'+this._i18n.mostrarFilas+': </span>';
      html += '    <select id="'+psId+'" style="font-size:12px"><option value="10">10</option><option value="25">25</option><option value="50">50</option></select>';
      html += '    <button type="button" data-act="first">'+this._i18n.primero+'</button>';
      html += '    <button type="button" data-act="prev">'+this._i18n.anterior+'</button>';
      html += '    <span style="min-width:120px;text-align:center">'+this._format(this._i18n.paginaDe, this._page, totalPages)+'</span>';
      html += '    <button type="button" data-act="next">'+this._i18n.siguiente+'</button>';
      html += '    <button type="button" data-act="last">'+this._i18n.ultimo+'</button>';
      html += '  </div>';
    }
    html += '</div>';
    this.contenedor.innerHTML = html;

    // Seleccionar pageSize
    var ps = document.getElementById(psId);
    if(ps){ ps.value = String(this._pageSize); }

    // Eventos filas
    var self = this;
    var tbody = document.querySelector('#'+tableId+' tbody');
    if(tbody){
      tbody.onclick = function(ev){
        var tr = ev.target.closest('tr'); if(!tr) return;
        var gidx = parseInt(tr.getAttribute('data-gidx'),10);
        self.selectedIndex = isNaN(gidx)?-1:gidx;
        // highlight
        var trs = tbody.querySelectorAll('tr');
        for(var i=0;i<trs.length;i++){ trs[i].className = trs[i].className.replace(/\browSelected\b/g,'').trim(); }
        tr.className = (tr.className+' rowSelected').trim();
      };
      tbody.ondblclick = function(ev){
        var tr = ev.target.closest('tr'); if(!tr) return;
        var gidx = parseInt(tr.getAttribute('data-gidx'),10);
        self.selectedIndex = isNaN(gidx)?-1:gidx;
        if(self.dblClkFunction && typeof global[self.dblClkFunction] === 'function'){
          global[self.dblClkFunction](gidx);
        }
      };
    }

    // Eventos paginación
    if(this._withPager){
      var pager = document.getElementById(pagerId);
      if(pager){
        pager.onclick = function(ev){
          var act = ev.target && ev.target.getAttribute('data-act'); if(!act) return;
          if(act==='first'){ self._page = 1; }
          else if(act==='prev'){ self._page = Math.max(1, self._page-1); }
          else if(act==='next'){ self._page = Math.min(totalPages, self._page+1); }
          else if(act==='last'){ self._page = totalPages; }
          self._render();
        };
        if(ps){
          ps.onchange = function(){
            var val = parseInt(ps.value,10); if(isNaN(val)||val<=0) val=10; self._pageSize = val; self._page = 1; self._render();
          };
        }
      }
    }
  };
  TablaEca.prototype._format = function(t){
    var args = Array.prototype.slice.call(arguments,1);
    return t.replace(/\{(\d+)\}/g,function(_,i){ return (typeof args[i]!=='undefined')? args[i] : _; });
  };
  // Exponer
  global.TablaEca = TablaEca;
})(window);
