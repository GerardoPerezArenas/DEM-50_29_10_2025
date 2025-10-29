package es.altia.flexia.integracion.moduloexterno.melanbide11.bean;

import java.math.BigDecimal;

public class ComplementoSalarial {
    private Long id;
    private Long idContratacion;
    private String concepto;
    private BigDecimal importe;
    private String tipo;
    private String observaciones;

    // Campos adicionales para sumas
    private BigDecimal sumaFijos;
    private BigDecimal sumaVariables;
    private BigDecimal sumaExtrasalarial;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getIdContratacion() {
        return idContratacion;
    }

    public void setIdContratacion(Long idContratacion) {
        this.idContratacion = idContratacion;
    }

    public String getConcepto() {
        return concepto;
    }

    public void setConcepto(String concepto) {
        this.concepto = concepto;
    }

    public BigDecimal getImporte() {
        return importe;
    }

    public void setImporte(BigDecimal importe) {
        this.importe = importe;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public BigDecimal getSumaFijos() {
        return sumaFijos;
    }

    public void setSumaFijos(BigDecimal sumaFijos) {
        this.sumaFijos = sumaFijos;
    }

    public BigDecimal getSumaVariables() {
        return sumaVariables;
    }

    public void setSumaVariables(BigDecimal sumaVariables) {
        this.sumaVariables = sumaVariables;
    }

    public BigDecimal getSumaExtrasalarial() {
        return sumaExtrasalarial;
    }

    public void setSumaExtrasalarial(BigDecimal sumaExtrasalarial) {
        this.sumaExtrasalarial = sumaExtrasalarial;
    }
}
