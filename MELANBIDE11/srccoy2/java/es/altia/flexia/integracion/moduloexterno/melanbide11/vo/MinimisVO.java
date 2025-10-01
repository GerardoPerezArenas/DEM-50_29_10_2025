
package es.altia.flexia.integracion.moduloexterno.melanbide11.vo;

import java.sql.Date;

/*
    ESTADO	MELANBIDE11_SUBSOLIC	MELANBIDE11	ESTADO DE LA AYUDA	VARCHAR	1		DESPLEGABLE DTSV 'S'(SOLICITADA), 'C'(CONCEDIDA)
    ORGANISMO	MELANBIDE11_SUBSOLIC	MELANBIDE11	ORGANISMO CONCEDENTE	VARCHAR	150		
    OBJETO	MELANBIDE11_SUBSOLIC	MELANBIDE11	DESCRIPCIÓN OBJETO DE LA AYUDA	VARCHAR	150		
    IMPORTE	MELANBIDE11_SUBSOLIC	MELANBIDE11	IMPORTE	NUMBER	8.2		
    FECHA	MELANBIDE11_SUBSOLIC	MELANBIDE11	FECHA SOLICITUD O CONCESIÓN	DATE			

*/

public class MinimisVO {
    
    private Integer id;
    private String numExp;
    
    private String estado;
    private String desEstado;
    private String organismo;
    private String objeto;
    private Double importe;
    private Date fecha;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNumExp() {
        return numExp;
    }

    public void setNumExp(String numExp) {
        this.numExp = numExp;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getDesEstado() {
        return desEstado;
    }

    public void setDesEstado(String desEstado) {
        this.desEstado = desEstado;
    }

    public String getOrganismo() {
        return organismo;
    }

    public void setOrganismo(String organismo) {
        this.organismo = organismo;
    }

    public String getObjeto() {
        return objeto;
    }

    public void setObjeto(String objeto) {
        this.objeto = objeto;
    }

    public Double getImporte() {
        return importe;
    }

    public void setImporte(Double importe) {
        this.importe = importe;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

}
