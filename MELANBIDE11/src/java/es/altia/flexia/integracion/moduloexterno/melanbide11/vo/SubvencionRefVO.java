package es.altia.flexia.integracion.moduloexterno.melanbide11.vo;

import java.io.Serializable;

public class SubvencionRefVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private int anioConvocatoria;
    private String titReqPuestoCod;
    private String titReqPuestoDesc;
    private Double impBaseTemp6m;
    private Double impBaseIndef;
    private Double impInc15Temp6mMujerO55;
    private Double impInc15IndefMujerO55;
    private Double impInc10IndCurso2224Cmp;
    private Double impInc20IndM55YCurso2224Cmp;

    public int getAnioConvocatoria() {
        return anioConvocatoria;
    }

    public void setAnioConvocatoria(int anioConvocatoria) {
        this.anioConvocatoria = anioConvocatoria;
    }

    public String getTitReqPuestoCod() {
        return titReqPuestoCod;
    }

    public void setTitReqPuestoCod(String titReqPuestoCod) {
        this.titReqPuestoCod = titReqPuestoCod;
    }

    public String getTitReqPuestoDesc() {
        return titReqPuestoDesc;
    }

    public void setTitReqPuestoDesc(String titReqPuestoDesc) {
        this.titReqPuestoDesc = titReqPuestoDesc;
    }

    public Double getImpBaseTemp6m() {
        return impBaseTemp6m;
    }

    public void setImpBaseTemp6m(Double impBaseTemp6m) {
        this.impBaseTemp6m = impBaseTemp6m;
    }

    public Double getImpBaseIndef() {
        return impBaseIndef;
    }

    public void setImpBaseIndef(Double impBaseIndef) {
        this.impBaseIndef = impBaseIndef;
    }

    public Double getImpInc15Temp6mMujerO55() {
        return impInc15Temp6mMujerO55;
    }

    public void setImpInc15Temp6mMujerO55(Double impInc15Temp6mMujerO55) {
        this.impInc15Temp6mMujerO55 = impInc15Temp6mMujerO55;
    }

    public Double getImpInc15IndefMujerO55() {
        return impInc15IndefMujerO55;
    }

    public void setImpInc15IndefMujerO55(Double impInc15IndefMujerO55) {
        this.impInc15IndefMujerO55 = impInc15IndefMujerO55;
    }

    public Double getImpInc10IndCurso2224Cmp() {
        return impInc10IndCurso2224Cmp;
    }

    public void setImpInc10IndCurso2224Cmp(Double impInc10IndCurso2224Cmp) {
        this.impInc10IndCurso2224Cmp = impInc10IndCurso2224Cmp;
    }

    public Double getImpInc20IndM55YCurso2224Cmp() {
        return impInc20IndM55YCurso2224Cmp;
    }

    public void setImpInc20IndM55YCurso2224Cmp(Double impInc20IndM55YCurso2224Cmp) {
        this.impInc20IndM55YCurso2224Cmp = impInc20IndM55YCurso2224Cmp;
    }
}
