package es.altia.flexia.integracion.moduloexterno.melanbide11.vo;

import java.sql.Date;

public class DesgloseRSBVO {
    private Integer id;
    private String numExp;
    private String dniConRSB;
    private String rsbTipo;
    private String desRsbTipo; // SB, PE, CS, ES
    private Double rsbImporte;
    private String rsbConcepto;
    private String desRsbConcepto; // FI, VA
    private String rsbObserv;

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

    public String getRsbObserv() {
        return rsbObserv;
    }

    public void setRsbObserv(String rsbObserv) {
        this.rsbObserv = rsbObserv;
    }

    public String getDesRsbTipo() {
        return desRsbTipo;
    }

    public void setDesRsbTipo(String desRsbTipo) {
        this.desRsbTipo = desRsbTipo;
    }

    public String getDesRsbConcepto() {
        return desRsbConcepto;
    }

    public void setDesRsbConcepto(String desRsbConcepto) {
        this.desRsbConcepto = desRsbConcepto;
    }
}