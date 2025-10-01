// Implementación de TablaEca compatible con justificaPreparadores23.jsp y otros procedimientos
TB_Fondo = '#FFFFFF';
TB_Fuente = '#000000';
TB_FondoActivo = '#E6E6E6';
TB_FondoObs = '#FFFFCC';

function isUndefined(a) {
    return ((typeof a == 'undefined') || (a == null));
}

var TB_NumEca = 100;
var consecutivo = 100;

if (document.all)
    cursor = 'hand';
else
    cursor = 'pointer';

function getNumIdTableSerie() {
    consecutivo = TB_NumEca++;
    if (document.getElementById('tb_tabla' + (consecutivo)) != null) {
        getNumIdTableSerie();
    }
    return consecutivo;
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
        column[3] = tipoDato;
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

function TablaEca(paginar, buscar, anterior, siguiente, mosFilasPag, msgNoResultBusq, mosPagDePags, noRegDisp, filtrDeTotal, primero, ultimo, par, anchoTabla, altoTabla) {
    this.id = 'tb_tabla' + (getNumIdTableSerie());
    this.parent = par;
    if (this.parent) this.parent.tabla = this;
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
    this.multiple = false;
    this.ordenar = false;
    this.ordenaColumna = true;
    this.ultimoTable = false;
    this.focusedIndex = -1;
    this.selectedIndex = -1;
    this.anchoTabla = (anchoTabla || 0);
    this.columnas = new Array();
    this.lineas = new Array();
    this.observaciones = new Array();
    this.displayCabecera = false;
    this.dataTable = null;
    this.estructuraColumnas = new GrupoColumnaEca(this);
    this.dblClkFunction = null;

    this.widthTabla = function() {
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
    };

    this.addColumna = function(ancho, align, nombre, tipoDato) {
        this.estructuraColumnas.addColumna(ancho, align, nombre, tipoDato);
    };

    this.restoreIndex = function() {
        this.selectedIndex = -1;
        this.focusedIndex = -1;
    };

    this.colorLinea = function (i) {
        if (this.observaciones.length > i)
            if (this.observaciones[i])
                return 'inactivaObs';
        return 'inactiva';
    };

    this.displayTablaConTooltips = function(tooltips) {
        this.restoreIndex();
        var ancho = this.widthTabla();
        var str = '<thead' + (this.displayCabecera ? '' : ' style="display:none"') + '>' + this.estructuraColumnas.toString() + '</thead>';
        str += '<tbody>';

        for (var i = 0; i < this.lineas.length; i++) {
            str += '<tr class="' + this.colorLinea(i) + '" indice=' + i + '>';
            var lin = this.lineas[i];
            var tool = tooltips ? tooltips[i] : [];
            for (var j = 0; j < lin.length; j++) {
                if (this.columnas[j][0] > 0) {
                    var anchoCol = (this.columnas[j][0]).indexOf('%') < 0 ? (this.columnas[j][0] / ancho) * 100 + '%' : this.columnas[j][0];
                    var title = (tool && tool[j] && tool[j] != '' && tool[j] != 'null') ? 'title="' + tool[j] + '"' : '';
                    str += '<td ' + title + ' style="text-align:' + this.columnas[j][2] + ';overflow: hidden; text-overflow: ellipsis;width:' + anchoCol + ';" onclick="selectRowEca(' + i + ',' +
                            this.id + ');" ondblclick="callFromTableToEca(' + i + ',\'' + this.id + '\');">' +
                            (lin[j] == '' ? '&nbsp;' : lin[j]) + '</td>';
                }
            }
            str += '</tr>';
        }
        str += '</tbody>';

        var temp = document.createElement("div");
        temp.innerHTML = "<table>" + str + "</table>";
        var tab = temp.firstChild;
        tab.id = this.id;
        tab.tabla = this;
        tab.style.width = '100%';
        tab.className = "xTabla compact";
        tab.onselectstart = "return false;";

        var oChild = null;
        try {
            if (this.parent) {
                var hijos = this.parent.children;
                if (hijos != null && hijos.length > 0)
                    oChild = hijos[0];
            }
        } catch (Err) {}

        if (oChild) {
            this.parent.removeChild(oChild);
        }
        this.parent.appendChild(tab);

        if (typeof jQuery !== 'undefined' && jQuery.fn.DataTable) {
            if (this.dataTable != null)
                this.dataTable.destroy();

            this.dataTable = jQuery("#" + this.id).DataTable({
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
    };

    this.displayTabla = function() {
        this.displayTablaConTooltips([]);
    };
}

// Funciones globales necesarias
function selectRowEca(rowIndex, tableId) {
    var tabla = document.getElementById(tableId).tabla;
    if (tabla) {
        tabla.selectedIndex = rowIndex;
        var rows = document.querySelectorAll('#' + tableId + ' tbody tr');
        for (var i = 0; i < rows.length; i++) {
            rows[i].className = rows[i].className.replace(/\bselected\b/g, '');
        }
        if (rows[rowIndex]) {
            rows[rowIndex].className += ' selected';
        }
    }
}

function callFromTableToEca(rowIndex, tableId) {
    var tabla = document.getElementById(tableId).tabla;
    if (tabla && tabla.dblClkFunction) {
        if (typeof window[tabla.dblClkFunction] === 'function') {
            window[tabla.dblClkFunction](rowIndex, tableId);
        }
    }
}
