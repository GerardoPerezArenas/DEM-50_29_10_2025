//var TB_ImgPath = APP_CONTEXT_PATH + "/images/";
var TB_Num = 0;

TB_Padding = 3;
TB_Borde = 1;
TB_Fondo = '#FFFFFF';
TB_Fuente = '#000000';
TB_FondoActivo = '#E6E6E6';
TB_FuenteActivo ='#000000';
TB_FondoObs='#FFFFCC';
TB_ColorCabecera = '#DCDCCC';

function isUndefined(a) { 
    return ((typeof a == 'undefined') || (a==null)); 
}


if(document.all) 
    cursor = 'hand';
else 
    cursor = 'pointer';


document.writeln('<style type="text/css">');
document.writeln('table.main');
document.writeln('{');
document.writeln('table-layout: fixed;');
document.writeln('}');
document.writeln('table.root');
document.writeln('{');
document.writeln('table-layout: fixed;');
document.writeln('}');
document.writeln('table.content');
document.writeln('{');
document.writeln('table-layout: fixed;');
document.writeln('}');
document.writeln('table.head');
document.writeln('{');
document.writeln('table-layout: fixed;');
document.writeln('}');
document.writeln('table.frozen');
document.writeln('{');
document.writeln('table-layout: fixed;');
document.writeln('}');
document.writeln('div.horizontal-scroll');
document.writeln('{');
document.writeln('overflow: hidden;');
document.writeln('overflow-x: scroll;');
document.writeln('}');
document.writeln('div.horizontal-scroll div');
document.writeln('{');
document.writeln('height: 0.1px;');
document.writeln('}');
document.writeln('div.vertical-scroll');
document.writeln('{');
document.writeln('width: 22px;');
document.writeln('overflow: hidden;');
document.writeln('overflow-y: scroll;');
document.writeln('}');
document.writeln('div.vertical-scroll div');
document.writeln('{');
document.writeln('width: 1px;');
document.writeln('}');
document.writeln('td.inner');
document.writeln('{');
document.writeln('border-left: 1px solid #666;');
document.writeln('border-bottom: 1px solid #666;');
document.writeln('padding: 3px;');
document.writeln('height: 28px;');
document.writeln('overflow: hidden;');
document.writeln('}');
document.writeln('td.frozencol');
document.writeln('{');
document.writeln('border-right: 1px double #666;');
document.writeln('}');
document.writeln('td.col1');
document.writeln('{');
document.writeln('border-left: none;');
document.writeln('width: 100px;');
document.writeln('}');
document.writeln('td.bottomcol');
document.writeln('{');
document.writeln('/*border-bottom: 1px solid #666;*/');
document.writeln('}');
document.writeln('.scrollCol');
document.writeln('{');
//document.writeln('overflow: hidden;');
//document.writeln('text-overflow: ellipses;');
document.writeln('white-space: nowrap;');
document.writeln('}');
document.writeln('td.head');
document.writeln('{');
document.writeln('/*border-bottom: 1px solid #666;*/');
document.writeln('background-color: #efefef;');
document.writeln('border-top: 1px solid #666;');
document.writeln('}');
document.writeln('.rightcol');
document.writeln('{');
document.writeln('border-right: 1px solid #666;');
document.writeln('}');
document.writeln('.toprow');
document.writeln('{');
document.writeln('border-top: 0px;');
document.writeln('}');
document.writeln('div.root');
document.writeln('{');
document.writeln('margin-left: 0px;');
document.writeln('overflow: hidden;');
document.writeln('width: auto;');
document.writeln('border-bottom: 1px solid #666;');
document.writeln('}');
document.writeln('div.frozen');
document.writeln('{');
document.writeln('overflow: hidden;');
document.writeln('width: auto;');
document.writeln('}');
document.writeln('div.divhead');
document.writeln('{');
document.writeln('overflow: hidden;');
document.writeln('width: 500px;');
document.writeln('border-left: 1px solid #666;');
document.writeln('border-right: 1px solid #666; /*border-bottom: 0px solid #666;*/');
document.writeln('border-bottom: 1px solid #666;');
document.writeln('}');
document.writeln('div.content');
document.writeln('{');
document.writeln('overflow: hidden;');
document.writeln('width: 500px;');
document.writeln('border-left: 1px solid #666;');
document.writeln('}');
document.writeln('td.tablefrozencolumn');
document.writeln('{');
document.writeln('border-right: 3px solid #666;');
document.writeln('border-left: 1px solid #999999;');
document.writeln('border-top: 1px solid #999999;');
document.writeln('}');
document.writeln('td.tablecontent');
document.writeln('{');
document.writeln('border-top: 1px solid #999999;');
document.writeln('}');
document.writeln('td.tableverticalscroll');
document.writeln('{');
document.writeln('width: 24px;');
document.writeln('vertical-align: top;');
document.writeln('}');
document.writeln('div.ff-fill');
document.writeln('{');
document.writeln('height: 23px;');
document.writeln('width: 23px;');
//document.writeln('background-color: #FFF;');
document.writeln('border-right: 1px solid #FFF;');
document.writeln('border-bottom: 1px solid #FFF;');
document.writeln('}');
document.writeln('tr.horizontal-scroll');
document.writeln('{');
document.writeln('line-height: 22px;');
document.writeln('}');
document.writeln('</style>');



function fctb_addElement(lista,elemento) {
    var i = lista.length;
    lista[i] = elemento;
}

function fctb_deleteElement(lista,index){
  if(index<0 || index >= lista.length) 
      return null;
  var val = lista[index];
  var i, j;
  for (i=eval(index);i < (lista.length-1);i++){
    j = i + 1;
    lista[i] = lista[j];
  }
  lista.length--;
  return val;
}

function Fctb_Lista(){
	this.items = new Array();
	this.pop = function(item){
		var newItems = new Array();
		for(var i=0; i < this.items.length; i++){
			if(this.items[i]!=item) newItems[newItems.length] = this.items[i];
		}
		this.items = newItems;
	}
	this.push = function(item){
		for(var i=0; i < this.items.length; i++){
			if(this.items[i]==item) return;
		}
		this.items[this.items.length] = item;
	}
}

function FixedColumnTable(par,anchoTabla,pWidth,nomT){
  this.id = 'tbl_'+nomT;
  this.nombreTabla = nomT || par.getAttribute('id');
  this.parent = par;
  this.parent.tabla = this;
  this.parentWidth = pWidth;

  this.height = '100';
  this.selectedIndex = -1;

  this.anchoTabla = (anchoTabla||0);
  
  this.scrollWidth = -1;
  this.scrollHeight = -1;

  this.columnas = new Array();
  this.titulosColumnas = new Array();
  this.lineas = new Array();
  this.tooltipLineas = new Array();
  this.estilosLineas = new Array();
  this.numColumnasFijas = 0;
  
  this.altoCabecera = 30;
  
  this.dblClkFunction = '';
    
    //Create an property on the top frame for later calling the table
    top["_" + this.id + "_"] = this;
  
  this.addColumna = function(ancho, align, nombre, titulo, tipoDato){
		var column = new Array();
		column[0] = ancho;
		column[1] = nombre;
		column[2] = (align || 'left');
		if(!tipoDato ||(tipoDato != 'String' && tipoDato != 'Number' && tipoDato != 'Date' && tipoDato != 'Binary'))
			tipoDato = 'String';
		column[3] = tipoDato; //Puede ser String,Number,Date,Binary.
		column[4] = 0; //Orden.
                if(titulo != undefined){
                    column[5] = titulo;
                }else{
                    column[5] = nombre;
                }
		this.columnas[this.columnas.length] = column;
	};
        
    this.addFila = function (datos, tooltips){
        this.lineas[this.lineas.length] = datos;
        this.tooltipLineas[this.tooltipLineas.length] = tooltips;
    }
        
    this.addFilaConFormato = function (datos, tooltips, estilo){
        this.lineas[this.lineas.length] = datos;
        this.tooltipLineas[this.tooltipLineas.length] = tooltips;
        this.estilosLineas[this.estilosLineas.length] = estilo;
    }

    this.displayTabla = function(){
            if(this.tooltipLineas == undefined){
                this.tooltipLineas = this.lineas;
            }
            var str = '';
            str += '<table border="0" id="tbl_'+this.nombreTabla+'" cellpadding="0" cellspacing="0" class="main" height="'+this.height+'" width="'+this.anchoTabla+'" onmousewheel="forwardEvent(event, \''+this.nombreTabla+'\');"  onselectstart="return false;" onclick="fctb_selectRow(event, \''+this.nombreTabla+'\');" '+(this.dblClkFunction != '' ? 'ondblclick="'+this.dblClkFunction+'();"' : '')+'>';
            
            str += '<tr>';
            //Solo habra que escribir este codigo si hay columnas fijas
            var anchoColumnasFijas = 0;
            var altoFila = 0;
            
            var altoScroll = (this.lineas.length*36)+30;
            if(this.scrollHeight < 0){
                this.scrollHeight = altoScroll;
            }
            
            //Antes
            /*str += '<td class="tableverticalscroll" rowspan="2">';
                str += '<div id="vScroll_'+this.nombreTabla+'" class="vertical-scroll" style="height: '+(parseInt(this.height)+2)+'px; width: '+(this.parentWidth + 20)+';" onscroll="reposVertical(this, \''+this.nombreTabla+'\');">';
                    str += '<div style="height: '+this.scrollHeight+'px;">';
                    str += '</div>';
                str += '</div>';
                str += '<div class="ff-fill">';
                str += '</div>';
            str += '</td>';*/
            
            //ahora
            //se ha cambiado porque en ie9 se veia sin scroll
            str += '<td class="tableverticalscroll" rowspan="2">';
            if(navigator.appName.indexOf("Internet Explorer") != -1){
				//No funciona IE9
                //str += '<div id="vScroll_'+this.nombreTabla+'" class="vertical-scroll" style="height: '+(parseInt(this.height)+2)+'px; width: '+(this.parentWidth + 20)+'; display: inline-block; position: relative;" onscroll="reposVertical(this, \''+this.nombreTabla+'\');">';
				str += '<div id="vScroll_'+this.nombreTabla+'" class="vertical-scroll" style="height: '+(parseInt(this.height)+2)+'px; width: '+(this.parentWidth + 20)+'; display: inline-flex; position: relative;" onscroll="reposVertical(this, \''+this.nombreTabla+'\');">';
            }else{
                str += '<div id="vScroll_'+this.nombreTabla+'" class="vertical-scroll" style="height: '+(parseInt(this.height)+2)+'px; width: '+(this.parentWidth + 20)+';" onscroll="reposVertical(this, \''+this.nombreTabla+'\');">';
            }
                    str += '<div style="height: '+this.scrollHeight+'px;">';
                    str += '</div>';
                str += '</div>';
                str += '<div id="ff-vertical-fill" class="ff-fill contenidoPantalla">';
                str += '</div>';
            str += '</td>';
            if(this.numColumnasFijas > 0){
                anchoColumnasFijas = calcularAnchoColumnas(this.columnas, 0, this.numColumnasFijas);
                str += '<td class="tablefrozencolumn" width="'+anchoColumnasFijas+'" style="vertical-align: top;">';
                    str += '<div id="divroot_'+this.nombreTabla+'" class="root" style="height: '+this.altoCabecera+'px;">';
                        str += '<table border="0" cellpadding="0" cellspacing="0" width="auto" class="root">';
                            str += '<tr>';
                            
                            for(var i = 0; i < this.numColumnasFijas; i++){
                                /*if(i == 0){
                                    str += '<td class="inner frozencol toprow xCabecera" width="'+this.columnas[i][0]+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 1px solid #ffffff;" title="'+this.columnas[i][1]+'">';
                                }
                                else if(i == this.numColumnasFijas - 1){
                                    str += '<td class="inner frozencol toprow xCabecera" width="'+this.columnas[i][0]+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 1px solid #ffffff;" title="'+this.columnas[i][1]+'">';
                                }else{
                                    str += '<td class="inner frozencol toprow xCabecera" width="'+this.columnas[i][0]+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 1px solid #ffffff;" title="'+this.columnas[i][1]+'">';
                                }*/
                                if(i == this.numColumnasFijas - 1){
                                    str += '<td class="inner frozencol toprow xCabecera" width="'+this.columnas[i][0]+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 1px solid #ffffff;" title="'+this.columnas[i][5]+'">';
                                }else{
                                    str += '<td class="inner frozencol toprow xCabecera" width="'+this.columnas[i][0]+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 1px solid #ffffff;" title="'+this.columnas[i][5]+'">';
                                }
                                    str += this.columnas[i][1];
                                str += '</td>';
                            }
                            
                            str += '</tr>';
                        str += '</table>';
                    str += '</div>';
                    
                    str += '<div id="divfrozen_'+this.nombreTabla+'" class="frozen" style="height: '+(this.height - this.altoCabecera)+'px;" onscroll="reposHead(this, \''+this.nombreTabla+'\');">';
                        str += '<table id="frozencontent_'+this.nombreTabla+'" border="0" cellpadding="0" cellspacing="0" class="frozen xTabla" width="auto" style="white-space: nowrap;">';
                            var estiloAct = '';
                            var titleAct = '';
                            for(var i = 0; i < this.lineas.length; i++){
                                altoFila = calcularAltoFila(i, this.lineas);
                                str += '<tr style="height: '+altoFila+'px;" onmouseout="mouseOut(this, \'frozencontent_'+this.nombreTabla+'\', \'innercontent_'+this.nombreTabla+'\', \''+this.id+'\');" onmouseover="mouseOver(this, \'frozencontent_'+this.nombreTabla+'\', \'innercontent_'+this.nombreTabla+'\');">';
                                for(var j = 0; j < this.numColumnasFijas; j++){
                                    titleAct = this.tooltipLineas != undefined && i < this.tooltipLineas.length && j < this.tooltipLineas[i].length && this.tooltipLineas[i][j] != undefined ? this.tooltipLineas[i][j] : this.lineas[i][j];
                                    estiloAct = this.estilosLineas != undefined && i < this.estilosLineas.length && this.estilosLineas[i] != undefined ? this.estilosLineas[i][j] : '';
                                    if(i == 0){
                                        if(j == this.numColumnasFijas-1){
                                            str += '<td class="inner toprow rightcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-right: 0px solid #666;'+estiloAct+'">';
                                        }else if(j == 0){
                                            str += '<td class="inner frozencol toprow" width="'+(parseFloat(this.columnas[j][0])+2)+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-left: 0px solid #666;'+estiloAct+'">';
                                        }
                                        else{
                                            str += '<td class="inner frozencol toprow" width="'+(parseFloat(this.columnas[j][0])+1)+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-left: 0px solid #666;'+estiloAct+'">';
                                        }
                                    }else if(i == this.lineas.length - 1){
                                        if(j == this.numColumnasFijas-1){
                                            str += '<td class="inner bottomcol rightcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-right: 0px solid #666;'+estiloAct+'">';
                                        }else if(j == 0){
                                            str += '<td class="inner frozencol bottomcol" width="'+(parseFloat(this.columnas[j][0])+2)+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-left: 0px solid #666;'+estiloAct+'">';
                                        }else{
                                            str += '<td class="inner frozencol bottomcol" width="'+(parseFloat(this.columnas[j][0])+1)+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-left: 0px solid #666;'+estiloAct+'">';
                                        }
                                    }else{
                                        if(j == this.numColumnasFijas-1){
                                            str += '<td class="inner rightcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-right: 0px solid #666;'+estiloAct+'">';
                                        }else if(i == 0){
                                            str += '<td class="inner frozencol" width="'+(parseFloat(this.columnas[j][0])+2)+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-left: 0px solid #666;'+estiloAct+'">';
                                        }else{
                                            str += '<td class="inner frozencol" width="'+(parseFloat(this.columnas[j][0])+1)+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="border-left: 0px solid #666;'+estiloAct+'">';
                                        }
                                    }
                                            str += this.lineas[i][j];
                                        str += '</td>';
                                }
                                str += '</tr>';
                            }
                        str += '</table>';
                    str += '</div>';
                str += '</td>';
            }else{
                str += '<div id="divfrozen_'+this.nombreTabla+'" class="frozen" style="height: 0px;" onscroll="reposHead(this, \''+this.nombreTabla+'\');"></div>';
            }
                var anchoColumnasScroll = calcularAnchoColumnas(this.columnas, this.numColumnasFijas, this.columnas.length);     
                var anchoTDScroll = this.anchoTabla - anchoColumnasFijas;
                str += '<td class="tablecontent" width="'+anchoTDScroll+'" style="vertical-align: top;">';
                    str += '<div id="headscroll_'+this.nombreTabla+'" class="divhead" style="width: 100%; height:'+this.altoCabecera+'px;">';
                        str += '<table border="0" cellpadding="0" cellspacing="0" class="head" width="'+anchoColumnasScroll+'">';
                            str += '<tr>';
                            for(var i = this.numColumnasFijas; i < this.columnas.length; i++){
                                if(i == this.numColumnasFijas){
                                    str += '<td class="inner scrollCol xCabecera" width="'+(parseFloat(this.columnas[i][0])+1)+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 0px; text-align: center;" title="'+this.columnas[i][5]+'">';
                                }else{
                                    str += '<td class="inner scrollCol xCabecera" width="'+this.columnas[i][0]+'" style="height: '+this.altoCabecera+'px; white-space: normal; border-right: 0px; border-left: 1px solid #ffffff; text-align: center;" title="'+this.columnas[i][5]+'">';
                                }
                                    str += this.columnas[i][1];
                                str += '</td>';
                            }
                            str += '</tr>';
                        str += '</table>';
                    str += '</div>';
                    str += '<div id="contentscroll_'+this.nombreTabla+'" class="content" onscroll="reposHead(this, \''+this.nombreTabla+'\');" style="height: '+(this.height - this.altoCabecera)+'px; width: 100%;">';
                        str += '<table border="0" cellpadding="0" cellspacing="0" class="content xTabla" id="innercontent_'+this.nombreTabla+'" width="'+anchoColumnasScroll+'" style="white-space: nowrap;">';
                            for(var i = 0; i < this.lineas.length; i++){
                                altoFila = calcularAltoFila(i, this.lineas);
                                str += '<tr style="height: '+altoFila+'px;" onmouseout="mouseOut(this, \'frozencontent_'+this.nombreTabla+'\', \'innercontent_'+this.nombreTabla+'\', \''+this.id+'\');" onmouseover="mouseOver(this, \'frozencontent_'+this.nombreTabla+'\', \'innercontent_'+this.nombreTabla+'\');">';
                                for(var j = this.numColumnasFijas; j < this.columnas.length; j++){
                                    titleAct = this.tooltipLineas != undefined && i < this.tooltipLineas.length && j < this.tooltipLineas[i].length && this.tooltipLineas[i][j] != undefined ? this.tooltipLineas[i][j] : this.lineas[i][j];
                                    estiloAct = this.estilosLineas != undefined && i < this.estilosLineas.length && this.estilosLineas[i] != undefined ? this.estilosLineas[i][j] : '';
                                    if(i == 0){
                                        if(j == this.numColumnasFijas){
                                            str += '<td class="inner scrollCol toprow" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }else if(j == this.columnas.length - 1){
                                            str += '<td class="inner scrollCol rightcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }else{
                                            str += '<td class="inner scrollCol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }
                                    }else if(i == this.lineas.length - 1){
                                        if(j == this.numColumnasFijas){
                                            str += '<td class="inner scrollCol bottomcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }else if(j == this.columnas.length - 1){
                                            str += '<td class="inner bottomcol rightcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }else{
                                            str += '<td class="inner bottomcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }
                                    }else{
                                        if(j == this.numColumnasFijas){
                                            str += '<td class="inner scrollCol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }else if(j == this.columnas.length - 1){
                                            str += '<td class="inner rightcol" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }else{
                                            str += '<td class="inner" width="'+this.columnas[j][0]+'" title="'+titleAct+'" align="'+this.columnas[j][2]+'" style="'+estiloAct+'">';
                                        }
                                    }
                                    str += this.lineas[i][j];
                                    str += '</td>';
                                }
                                str += '</tr>';
                            }
                        str += '</table>';
                    str += '</div>';
                str += '</td>';
                
                /*str += '<td class="tableverticalscroll" rowspan="2" style="vertical-align: top;">';
                    str += '<div class="vertical-scroll" style="height: '+this.height+'px;" onscroll="reposVertical(this, \''+this.nombreTabla+'\');">';
                        var altoScroll = (this.lineas.length*36)+30;
                        str += '<div style="height: '+altoScroll+';">';
                        str += '</div>';
                    str += '</div>';
                    str += '<div class="ff-fill">';
                    str += '</div>';
                str += '</td>';*/
            
            str += '</tr>';
            
            var anchoTotal = anchoColumnasFijas + anchoColumnasScroll;
            
            if(this.scrollWidth < 0){
                this.scrollWidth = anchoTotal+((anchoTotal*7)/100);
            }
            
            //Antes
            /*str += '<tr class="horizontal-scroll">';
                str += '<td colspan="2" width="'+anchoTotal+'" valign="top" height="22">';
                    str += '<div id="hScroll_'+this.nombreTabla+'" class="horizontal-scroll" onscroll="reposHorizontal(this, \''+this.nombreTabla+'\');">';
                        str += '<div style="width: '+this.scrollWidth+'px;">';
                        str += '</div>';
                    str += '</div>';
                    str += '<div class="ff-fill"/>';
                str += '</td>';
            str += '</tr>';*/
        
            //Ahora
            //se ha cambiado porque en ie9 se veia sin scroll
            str += '<tr class="horizontal-scroll">';
                str += '<td colspan="2" width="'+anchoTotal+'" valign="top" height="22">';
                if(navigator.appName.indexOf("Internet Explorer") != -1){
                    //str += '<div id="hScroll_'+this.nombreTabla+'" class="horizontal-scroll" style="display: inline-block; position: relative; width: '+anchoTabla+'; margin-top: -22px;" onscroll="reposHorizontal(this, \''+this.nombreTabla+'\');">';
					str += '<div id="hScroll_'+this.nombreTabla+'" class="horizontal-scroll" style="display: inline-flex; position: relative; width: '+anchoTabla+'; margin-top: -15px;" onscroll="reposHorizontal(this, \''+this.nombreTabla+'\');">';
                }else{
                    str += '<div id="hScroll_'+this.nombreTabla+'" class="horizontal-scroll" onscroll="reposHorizontal(this, \''+this.nombreTabla+'\');">';
                }
                        str += '<div style="width: '+this.scrollWidth+'px;">';
                        str += '</div>';
                    str += '</div>';
                    str += '<div id="ff-horizontal-fill" class="ff-fill"/>';
                str += '</td>';
            str += '</tr>';
            
            str += '</table>';
            var div = document.getElementById(this.parent.getAttribute('id'));
            div.tabla = this;
            div.innerHTML = str;
            try{
				var tabla = document.getElementById('tbl_'+this.nombreTabla);
				//tabla.addEventListener('mousewheel', forwardEvent(event, this.nombreTabla), false);
				
				var mousewheelevt=(/Firefox/i.test(navigator.userAgent))? "DOMMouseScroll" : "mousewheel" //FF doesn't recognize mousewheel as of FF3.x
				if (document.attachEvent){ //if IE (and Opera depending on user setting)
                                        tabla.attachEvent("on"+mousewheelevt, function () {forwardEvent(event, this.nombreTabla)})
                                }
				else if (document.addEventListener){ //WC3 browsers
                                        tabla.addEventListener(mousewheelevt, function () {forwardEvent(event, this.nombreTabla)}, false)
                                }	
				
            }catch(err){
			//alert(err.message);
			}
        };

    this.pack = function(){
		try{
            var div = document.getElementById(this.parent.getAttribute('id'));
            var vScroll = document.getElementById('vScroll_'+this.nombreTabla);
            vScroll.offsetWidth = this.parentWidth + 20;   
            
            var frozenContent = document.getElementById('frozencontent_'+this.nombreTabla);
            var scrollContent = document.getElementById('innercontent_'+this.nombreTabla);
            var ancho1 = 0;
            var ancho2 = 0;
            for(var i = 0; i < this.lineas.length; i++){
                ancho1 = frozenContent.children[0].children[i].children[0].offsetHeight;
                ancho2 = scrollContent.children[0].children[i].children[0].offsetHeight;
                if(ancho1 > ancho2){
                    scrollContent.children[0].children[i].children[0].offsetHeight = ancho1;
                }else if(ancho2 > ancho1){
                    frozenContent.children[0].children[i].children[0].offsetHeight = ancho2;
                }
            }
		}catch(err){
		}
    }
    
    /*document.body.onpageshow = function(){
        var div = document.getElementById(this.parent.getAttribute('id'));
            var vScroll = document.getElementById('vScroll_'+this.nombreTabla);
            vScroll.offsetWidth = div.offsetWidth + 7;   
            
            var frozenContent = document.getElementById('frozencontent_'+this.nombreTabla);
            var scrollContent = document.getElementById('innercontent_'+this.nombreTabla);
            var ancho1 = 0;
            var ancho2 = 0;
            for(var i = 0; i < this.lineas.length; i++){
                ancho1 = frozenContent.children[0].children[i].children[0].offsetHeight;
                ancho2 = scrollContent.children[0].children[i].children[0].offsetHeight;
                if(ancho1 > ancho2){
                    scrollContent.children[0].children[i].children[0].offsetHeight = ancho1;
                }else if(ancho2 > ancho1){
                    frozenContent.children[0].children[i].children[0].offsetHeight = ancho2;
                }
            }
    }*/
}   

function reposHead(e, nombreTabla) {
    var h = document.getElementById('headscroll_'+nombreTabla);
    h.scrollLeft = e.scrollLeft;
    var f = document.getElementById('divfrozen_'+nombreTabla);
    f.scrollTop = e.scrollTop;
}

function reposHorizontal(e, nombreTabla) {
    var h = document.getElementById('headscroll_'+nombreTabla);
    var c = document.getElementById('contentscroll_'+nombreTabla);
    h.scrollLeft = e.scrollLeft;
    c.scrollLeft = e.scrollLeft;
}

function reposVertical(e, nombreTabla) {
    var h = document.getElementById('divfrozen_'+nombreTabla);
    var c = document.getElementById('contentscroll_'+nombreTabla);
    if(h){
        h.scrollTop = e.scrollTop;
    }
    if(c){
        c.scrollTop = e.scrollTop;
    }
}

function calcularAnchoColumnas(columnas, from, to){
    var ancho = 0;
    var offset = 7 * to;
    for(var i = from; i < to; i++){
        ancho += parseInt(columnas[i][0]);
    }
    //antes
    //ancho += offset;

    //ahora
    //if añadido porque en ie9 se veia mal
    if(navigator.appName.indexOf("Internet Explorer") == -1){
        ancho += offset;
    }
    return ancho;
}

function forwardEvent(ev, nombreTabla) {
	try{
            if(ev != null && ev != undefined){
                if(nombreTabla != undefined && nombreTabla != null && nombreTabla != ''){
                    var div = document.getElementById('vScroll_'+nombreTabla);
                    var h = document.getElementById('divfrozen_'+nombreTabla);
                    var c = document.getElementById('contentscroll_'+nombreTabla);
                    var top1 = h.scrollTop;
                    top1 = top1 - ev.wheelDelta;
                    if(top1 < 0)
                            top1 = 0;

                    var top2 = c.scrollTop;
                    top2 = top2 - ev.wheelDelta;
                    if(top2 < 0)
                            top2 = 0;

                    var top3 = div.scrollTop;
                    top3 = top3 - ev.wheelDelta;
                    if(top3 < 0)
                            top3 = 0;
                    h.scrollTop = top1;
                    c.scrollTop = top2;
                    div.scrollTop = top3;
                }
            }
	}catch(err){
	}
}


function fctb_selectRow(event, tableName){
    var rowID = -1;
    try{
        if(window.event)  {
            if(window.event.srcElement.tagName=='TD'){ 
                rowID = window.event.srcElement.parentElement.rowIndex;
            }else if(window.event.srcElement.parentElement.parentElement.parentElement.parentElement.id == 'frozencontent_'+tableName){
                rowID = window.event.srcElement.parentElement.parentElement.rowIndex;
            }else{
                return false;
            }
            //tableName = window.event.srcElement.parentElement.parentElement.parentElement.id;
        }else{
             if(event.target.tagName == 'TD'){
                rowID = event.target.parentNode.rowIndex;
             }else if(event.target.parentNode.tagName == 'TD'){
                rowID = event.target.parentNode.parentNode.rowIndex;
             }
             //tableName = event.target.parentNode.parentNode.parentNode.id;
             
         }
    }catch(err){
        
    }
    
    return seleccionarFila(rowID, tableName);
}


function fctb_callFromTableTo(event, tableName){
    if(window.event) { //IE
        if(window.event.srcElement.tagName!='TD') 
            return false;
        rowID = window.event.srcElement.parentElement.rowIndex;
        //tableName = window.event.srcElement.parentElement.parentElement.parentElement.id;
        return dblClk(rowID,tableName);
    }else{ // FF
        if(event.target.tagName!='TD') 
            return false;
        rowID = event.target.parentNode.rowIndex;
        //tableName = event.target.parentNode.parentNode.parentNode.id;
        return dblClk(rowID,tableName);
    }
}


function seleccionarFila(rowID,tableName){
  var tabla = top["_tbl_" + tableName + "_"];
  var indiceAnt = tabla.selectedIndex;
  if(indiceAnt != rowID){
    tabla.selectedIndex = rowID;
    if (document.all){
      with(eval('document.all.tbl_'+tableName+'.parentElement.parentElement.parentElement')){
        //tabla.selectLinea(rowID);
        if(document.getElementById('frozencontent_'+tableName)){
            if(document.getElementById('frozencontent_'+tableName).children[0]){
                if(document.getElementById('frozencontent_'+tableName).children[0].children[rowID]){
                    document.getElementById('frozencontent_'+tableName).children[0].children[rowID].className = 'JSTHighlited';
                    if(document.getElementById('frozencontent_'+tableName).children[0].children[indiceAnt]){
                        document.getElementById('frozencontent_'+tableName).children[0].children[indiceAnt].className = 'pendienteEstaUnidad';
                    }
                }
            }
        }
        
        if(document.getElementById('innercontent_'+tableName)){
            if(document.getElementById('innercontent_'+tableName).children[0]){
                if(document.getElementById('innercontent_'+tableName).children[0].children[rowID]){
                    document.getElementById('innercontent_'+tableName).children[0].children[rowID].className = 'JSTHighlited';
                    if(document.getElementById('innercontent_'+tableName).children[0].children[indiceAnt]){
                        document.getElementById('innercontent_'+tableName).children[0].children[indiceAnt].className = 'pendienteEstaUnidad';
                    }
                }
            }
        }
      }
    }else if (document.getElementById){
      with(document.getElementById('tbl_'+tableName).parentNode.parentNode.parentNode){
        //tabla.selectLinea(rowID);
        if(document.getElementById('frozencontent_'+tableName)){
            if(document.getElementById('frozencontent_'+tableName).children[0]){
                if(document.getElementById('frozencontent_'+tableName).children[0].children[rowID]){
                  document.getElementById('frozencontent_'+tableName).children[0].children[rowID].className = 'JSTHighlited';
                }
                if(document.getElementById('frozencontent_'+tableName).children[0].children[indiceAnt]){
                  document.getElementById('frozencontent_'+tableName).children[0].children[indiceAnt].className = 'pendienteEstaUnidad';
                }
            }
        }

        if(document.getElementById('innercontent_'+tableName)){
            if(document.getElementById('innercontent_'+tableName).children[0].children[rowID]){
              document.getElementById('innercontent_'+tableName).children[0].children[rowID].className = 'JSTHighlited';
            }
            if(document.getElementById('innercontent_'+tableName).children[0].children[indiceAnt]){
              document.getElementById('innercontent_'+tableName).children[0].children[indiceAnt].className = 'pendienteEstaUnidad';
            }
        }
      }
    }
  }
  //callClick(rowID,tableName);
  return false;
}

/*function mouseOut(row, scrollableTableName, idTab){
    if(document.getElementById(scrollableTableName)){
        var tabla = top["_" + idTab + "_"];
        if (tabla.selectedIndex != row.rowIndex) {
            row.className='pendienteEstaUnidad';
            var row2 = document.getElementById(scrollableTableName).children[0].children[row.rowIndex];
            row2.className='pendienteEstaUnidad';
        }
    }
}

function mouseOver(row, scrollableTableName){
    if(document.getElementById(scrollableTableName)){
        row.className='JSTHighlited';
        var row2 = document.getElementById(scrollableTableName).children[0].children[row.rowIndex];
        row2.className='JSTHighlited';
    }
}*/

function mouseOut(row, fixedTableName, scrollableTableName, idTab){
    if(document.getElementById(scrollableTableName)){
        var tabla = top["_" + idTab + "_"];
        if (tabla.selectedIndex != row.rowIndex) {
            if(document.getElementById(fixedTableName)){
                var row1 = document.getElementById(fixedTableName).children[0].children[row.rowIndex];
                row1.className='pendienteEstaUnidad';
            }
            if(document.getElementById(scrollableTableName)){
                var row2 = document.getElementById(scrollableTableName).children[0].children[row.rowIndex];
                row2.className='pendienteEstaUnidad';
            }
        }
    }
}

function mouseOver(row, fixedTableName, scrollableTableName){
    if(document.getElementById(fixedTableName)){
        var fixedRow = document.getElementById(fixedTableName).children[0].children[row.rowIndex];
        fixedRow.className='JSTHighlited';
    }
    if(document.getElementById(scrollableTableName)){
        var scrollRow = document.getElementById(scrollableTableName).children[0].children[row.rowIndex];
        scrollRow.className='JSTHighlited';
    }
}

function calcularAltoFila(numFila, lineas){
    var nc = lineas[numFila].length;
    var valor = '';
    var partes;
    var alto = 0;
    var maxLineas = 0;
    for(var j = 0; j < nc; j++){
        valor = lineas[numFila][j];
        if(valor != undefined){
            if(typeof valor == "string"){
                valor = valor.toUpperCase();
                partes = valor.split('<BR');
                if(partes != undefined && partes.length > maxLineas){
                    maxLineas = partes.length;
                    alto = maxLineas * 15;
                }
            }
        }
    }
    return alto;
}

// Funciones a redefinir en la jsp.

function callFromTableTo(rowID,tableName){}	//Se ejecuta en el evento onDbClick.

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////



/*function reposHead(e, nombreTabla) {
    var h = document.getElementById('headscroll_'+nombreTabla);
    h.scrollLeft = e.scrollLeft;
    var f = document.getElementById('divfrozen_'+nombreTabla);
    f.scrollTop = e.scrollTop;
}

function reposHorizontal(e, nombreTabla) {
    var h = document.getElementById('headscroll_'+nombreTabla);
    var c = document.getElementById('contentscroll_'+nombreTabla);
    h.scrollLeft = e.scrollLeft;
    c.scrollLeft = e.scrollLeft;
}

function reposVertical(e, nombreTabla) {
    var h = document.getElementById('divfrozen_'+nombreTabla);
    var c = document.getElementById('contentscroll_'+nombreTabla);
    h.scrollTop = e.scrollTop;
    c.scrollTop = e.scrollTop;

}*/