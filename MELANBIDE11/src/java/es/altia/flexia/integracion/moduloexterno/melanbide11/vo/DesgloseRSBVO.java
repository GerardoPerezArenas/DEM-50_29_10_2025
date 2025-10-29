package es.altia.flexia.integracion.moduloexterno.melanbide11.vo;

import java.sql.Date;

/**
 * Value Object para la tabla MELANBIDE11_DESGRSB
 * Representa el desglose detallado de RSB (Prestaciones por Desempleo)
 * segun el DDL oficial proporcionado
 * Compatible con Java 6
 */
public class DesgloseRSBVO {
    
    // Campos segun DDL MELANBIDE11_DESGRSB
    private Integer id;                    // ID NUMERIC(38) PRIMARY KEY
    private String numExp;                // NUM_EXP VARCHAR2(50) - Numero de expediente
    private String dniConRSB;            // DNI_CON_RSB VARCHAR2(20) - DNI del contrato con RSB
    private String rsbTipo;              // RSB_TIPO CHAR(2) - Codigo de tipo RSB
    private String desRsbTipo;           // DES_RSB_TIPO VARCHAR2(100) - Descripcion tipo RSB
    private Double rsbImporte;           // RSB_IMPORTE NUMERIC(15,2) - Importe del RSB (Double para Java 6)
    private String rsbConcepto;          // RSB_CONCEPTO CHAR(2) - Codigo de concepto
    private String desRsbConcepto;       // DES_RSB_CONCEPTO VARCHAR2(100) - Descripcion concepto
    private String rsbObserv;            // RSB_OBSERV VARCHAR2(500) - Observaciones

    // Constructores
    public DesgloseRSBVO() {}

    public DesgloseRSBVO(String numExp, String dniConRSB) {
        this.numExp = numExp;
        this.dniConRSB = dniConRSB;
    }

    // Getters y Setters
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

    public String getDniConRSB() {
        return dniConRSB;
    }

    public void setDniConRSB(String dniConRSB) {
        this.dniConRSB = dniConRSB;
    }

    public String getRsbTipo() {
        return rsbTipo;
    }

    public void setRsbTipo(String rsbTipo) {
        this.rsbTipo = rsbTipo;
    }

    public String getDesRsbTipo() {
        return desRsbTipo;
    }

    public void setDesRsbTipo(String desRsbTipo) {
        this.desRsbTipo = desRsbTipo;
    }

    public Double getRsbImporte() {
        return rsbImporte;
    }

    public void setRsbImporte(Double rsbImporte) {
        this.rsbImporte = rsbImporte;
    }

    public String getRsbConcepto() {
        return rsbConcepto;
    }

    public void setRsbConcepto(String rsbConcepto) {
        this.rsbConcepto = rsbConcepto;
    }

    public String getDesRsbConcepto() {
        return desRsbConcepto;
    }

    public void setDesRsbConcepto(String desRsbConcepto) {
        this.desRsbConcepto = desRsbConcepto;
    }

    public String getRsbObserv() {
        return rsbObserv;
    }

    public void setRsbObserv(String rsbObserv) {
        this.rsbObserv = rsbObserv;
    }

    // Metodos de negocio compatibles con Java 6
    public boolean isImporteValido() {
        return rsbImporte != null && rsbImporte.doubleValue() > 0;
    }

    public boolean isCompletoCamposObligatorios() {
        return numExp != null && numExp.trim().length() > 0 &&
               dniConRSB != null && dniConRSB.trim().length() > 0 &&
               rsbTipo != null && rsbTipo.trim().length() > 0;
    }

    public String getImporteFormateado() {
        return rsbImporte != null ? rsbImporte.toString() + " ¤" : "0,00 ¤";
    }

    public boolean isTipoSubsidio() {
        return "SB".equals(rsbTipo);
    }

    public boolean isTipoPrestacion() {
        return "PE".equals(rsbTipo);
    }

    // Metodos estandar compatibles con Java 6
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DesgloseRSBVO that = (DesgloseRSBVO) o;
        
        if (id != null ? !id.equals(that.id) : that.id != null) return false;
        if (numExp != null ? !numExp.equals(that.numExp) : that.numExp != null) return false;
        return dniConRSB != null ? dniConRSB.equals(that.dniConRSB) : that.dniConRSB == null;
    }

    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (numExp != null ? numExp.hashCode() : 0);
        result = 31 * result + (dniConRSB != null ? dniConRSB.hashCode() : 0);
        return result;
    }

    public String toString() {
        return "DesgloseRSBVO{" +
               "id=" + id +
               ", numExp='" + numExp + '\'' +
               ", dniConRSB='" + dniConRSB + '\'' +
               ", rsbTipo='" + rsbTipo + '\'' +
               ", rsbImporte=" + rsbImporte +
               ", rsbConcepto='" + rsbConcepto + '\'' +
               '}';
    }
}