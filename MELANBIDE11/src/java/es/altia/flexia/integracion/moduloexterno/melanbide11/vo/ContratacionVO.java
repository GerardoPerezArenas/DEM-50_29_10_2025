
package es.altia.flexia.integracion.moduloexterno.melanbide11.vo;

import java.sql.Date;

/*
    CONTRATACIÓN: DATOS SELECCIÓN														
                    NOFECONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Nº de oferta de Tipo1(excluyente): Selección mediante oferta (art. 6.1.a)	VARCHAR	10							
                    IDCONT1	MELANBIDE11_CONTRATACION	MELANBIDE11	Id. Contrato de Tipo1(excluyente): Selección mediante oferta (art. 6.1.a)	VARCHAR	10							
                    IDCONT2	MELANBIDE11_CONTRATACION	MELANBIDE11	Identificación de Contrato de Tipo2(excluyente): Selección directa de empresa (art. 6.1.b)	VARCHAR	10							

    CONTRATACIÓN: DATOS DE LA PERSONA CONTRATADA														
                    DNICONT	MELANBIDE11_CONTRATACION	MELANBIDE11	DNI/NIE	VARCHAR	15	OBLIGATORIO						
                    NOMCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Nombre	VARCHAR	100	OBLIGATORIO						
                    APE1CONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Apellido1	VARCHAR	50	OBLIGATORIO						
                    APE2CONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Apellido2	VARCHAR	50	OBLIGATORIO						
                    FECHNACCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Fecha nacimiento	DATE		OBLIGATORIO						
                    EDADCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Edad	NUMBER	2	OBLIGATORIO						
                    SEXOCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Sexo (Desplegable)	VARCHAR	1	OBLIGATORIO	DESPLEGABLE SEXO					Valores posibles: 1: Hombre, 2: Mujer
                    MAY55CONT	MELANBIDE11_CONTRATACION	MELANBIDE11	¿ Mayores de 55 años ? (Desplegable) SI=S, NO=N	VARCHAR	1	OBLIGATORIO	BOOLEANO (S/N)					Valores posibles: S N
                    ACCFORCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	¿ Ha finalizado en 2019 una acción formativa con compromiso de contratación ? )Desplegable SI=S, NO=N	VARCHAR	1	OBLIGATORIO	BOOLEANO (S/N)					Valores posibles: S N

    CONTRATACIÓN: DATOS DEL PUESTO DE TRABAJO														
                    PUESTOCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Nombre del puesto	VARCHAR	100	OBLIGATORIO						
                    OCUCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Nombre de ocupación	VARCHAR	150	OBLIGATORIO						
                    CODOCUCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Código de ocupación (Desplegable Intermediación)	VARCHAR	8	OBLIGATORIO	DESPLEGABLE EXTERNO OCIN					
                    TITULACION	MELANBIDE11_CONTRATACION	MELANBIDE11	Titulación (Desplegable Intermediación)	VARCHAR	12	OBLIGATORIO	DESPLEGABLE EXTERNO TIIN					
                    CPROFESIONALIDAD	MELANBIDE11_CONTRATACION	MELANBIDE11	Cert.Profesionalidad (Desplegable Intermediación)	VARCHAR	10	DESPLEGABLE EXTERNO CPIN
                    MODCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Modalidad de contrato	VARCHAR	100	OBLIGATORIO						
                    JORCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Jornada: Completa ó Parcial(mínimo 70%) (Desplegable)	VARCHAR	4	OBLIGATORIO	DESPLEGABLE JORN					
                    PORCJOR	MELANBIDE11_CONTRATACION	MELANBIDE11	Porcentaje de Jornada Parcial(mínimo 70%) (en caso de Jornada Parcial)	NUMBER	5,2							
                    FECHINICONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Fecha inicio del contrato	DATE		OBLIGATORIO						
                    FECHFINCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Fecha fin del contrato prevista(si procede)	DATE								
                    DURCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Duración del contrato: en meses(excepto indefinido)	VARCHAR	6							
                    GRSS	MELANBIDE11_CONTRATACION	MELANBIDE11	Grupo de cotización de la S.S. (Desplegable del 1 al 10)	VARCHAR	2	OBLIGATORIO	DESPLEGABLE GCOT					
                    DIRCENTRCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Dirección de centro de trabajo de destino	VARCHAR	100	OBLIGATORIO						
                    NSSCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Número de cuenta de cotización de la S.S.	VARCHAR	22	OBLIGATORIO						
                    CSTCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Coste contrato: salario bruto anual, pagas incluidas, excluidos los costes a la S.S.	NUMBER	8,2	OBLIGATORIO						

    CONTRATACIÓN: IMPORTE DE LA SUBVENCIÓN SOLICITADA PARA EL PUESTO														
                    IMPSUBVCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Importe de la Subvención solicitada para el puesto	NUMBER	8,2	OBLIGATORIO						

*/

/*
  Se añaden campos convocatoria 2022
    CONTRATACIÓN: DATOS DE LA PERSONA CONTRATADA
        CODFORCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Código de la acción formativa finalizada	VARCHAR	20	NO
        DENFORCONT	MELANBIDE11_CONTRATACION	MELANBIDE11	Denominación de la acción formativa finalizada	VARCHAR	150	NO

    CONTRATACIÓN: DATOS DEL PUESTO DE TRABAJO
        HORASCONV	MELANBIDE11_CONTRATACION	MELANBIDE11	Horas convenio (en caso de Jornada Parcial)	        NUMBER	4	SI
        TIPRSB	        MELANBIDE11_CONTRATACION	MELANBIDE11	Tipo de retribución salarial bruta (coste contrato)	VARCHAR	10	NO	DESPLEGABLE DTRT 'A'(ANUAL), 'M'(MENSUAL)

*/

/*
  Se añade nuevo campo DESTITULACION - Titulación solicitud
    CONTRATACIÓN: DATOS DEL PUESTO DE TRABAJO
        DESTITULACION	MELANBIDE11_CONTRATACION	MELANBIDE11	Titulación solicitud	VARCHAR	200	NO
*/

public class ContratacionVO {
    
    private Integer id;
    private String numExp;
    
    private String oferta;
    private String idContrato1;
    private String idContrato2;
    
    private String dni;
    private String nombre;
    private String apellido1;
    private String apellido2;
    private Date fechaNacimiento;
    private Integer edad;
    private String sexo;
    private String desSexo;
    private String mayor55;
    private String finFormativa;
    private String codFormativa;
    private String denFormativa;
    
    private String puesto;
    private String ocupacion;
    private String desOcupacion;
    private String desOcupacionLibre;
    private String titulacion;
    private String desTitulacionLibre;
    private String desTitulacion;
    private String cProfesionalidad;
    private String desCProfesionalidad;
    private String modalidadContrato;
    private String jornada;
    private String desJornada;
    private Double porcJornada;
    private Integer horasConv;
    private Date fechaInicio;
    private Date fechaFin;
    private String mesesContrato;
    private String grupoCotizacion;
    private String desGrupoCotizacion;
    private String direccionCT;
    private String numSS;
    private Double costeContrato;
    private String tipRetribucion;
    private String desTipRetribucion;
    
    private Double importeSub;

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

    public String getOferta() {
        return oferta;
    }

    public void setOferta(String oferta) {
        this.oferta = oferta;
    }

    public String getIdContrato1() {
        return idContrato1;
    }

    public void setIdContrato1(String idContrato1) {
        this.idContrato1 = idContrato1;
    }

    public String getIdContrato2() {
        return idContrato2;
    }

    public void setIdContrato2(String idContrato2) {
        this.idContrato2 = idContrato2;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido1() {
        return apellido1;
    }

    public void setApellido1(String apellido1) {
        this.apellido1 = apellido1;
    }

    public String getApellido2() {
        return apellido2;
    }

    public void setApellido2(String apellido2) {
        this.apellido2 = apellido2;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public Integer getEdad() {
        return edad;
    }

    public void setEdad(Integer edad) {
        this.edad = edad;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public String getDesSexo() {
        return desSexo;
    }

    public void setDesSexo(String desSexo) {
        this.desSexo = desSexo;
    }

    public String getMayor55() {
        return mayor55;
    }

    public void setMayor55(String mayor55) {
        this.mayor55 = mayor55;
    }

    public String getFinFormativa() {
        return finFormativa;
    }

    public void setFinFormativa(String finFormativa) {
        this.finFormativa = finFormativa;
    }

    public String getCodFormativa() {
        return codFormativa;
    }

    public void setCodFormativa(String codFormativa) {
        this.codFormativa = codFormativa;
    }

    public String getDenFormativa() {
        return denFormativa;
    }

    public void setDenFormativa(String denFormativa) {
        this.denFormativa = denFormativa;
    }

    public String getPuesto() {
        return puesto;
    }

    public void setPuesto(String puesto) {
        this.puesto = puesto;
    }

    public String getOcupacion() {
        return ocupacion;
    }

    public void setOcupacion(String ocupacion) {
        this.ocupacion = ocupacion;
    }

    public String getDesOcupacion() {
        return desOcupacion;
    }

    public void setDesOcupacion(String desOcupacion) {
        this.desOcupacion = desOcupacion;
    }

    public String getDesOcupacionLibre() {
        return desOcupacionLibre;
    }

    public void setDesOcupacionLibre(String desOcupacionLibre) {
        this.desOcupacionLibre = desOcupacionLibre;
    }
    
    public String getDesTitulacionLibre() {
        return desTitulacionLibre;
    }

    public void setDesTitulacionLibre(String desTitulacionLibre) {
        this.desTitulacionLibre = desTitulacionLibre;
    }

    public String getTitulacion() {
        return titulacion;
    }

    public void setTitulacion(String titulacion) {
        this.titulacion = titulacion;
    }

    public String getDesTitulacion() {
        return desTitulacion;
    }

    public void setDesTitulacion(String desTitulacion) {
        this.desTitulacion = desTitulacion;
    }

    public String getcProfesionalidad() {
        return cProfesionalidad;
    }

    public void setcProfesionalidad(String cProfesionalidad) {
        this.cProfesionalidad = cProfesionalidad;
    }

    public String getDesCProfesionalidad() {
        return desCProfesionalidad;
    }

    public void setDesCProfesionalidad(String desCProfesionalidad) {
        this.desCProfesionalidad = desCProfesionalidad;
    }

    public String getModalidadContrato() {
        return modalidadContrato;
    }

    public void setModalidadContrato(String modalidadContrato) {
        this.modalidadContrato = modalidadContrato;
    }

    public String getJornada() {
        return jornada;
    }

    public void setJornada(String jornada) {
        this.jornada = jornada;
    }

    public String getDesJornada() {
        return desJornada;
    }

    public void setDesJornada(String desJornada) {
        this.desJornada = desJornada;
    }

    public Double getPorcJornada() {
        return porcJornada;
    }

    public void setPorcJornada(Double porcJornada) {
        this.porcJornada = porcJornada;
    }

    public Integer getHorasConv() {
        return horasConv;
    }

    public void setHorasConv(Integer horasConv) {
        this.horasConv = horasConv;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public String getMesesContrato() {
        return mesesContrato;
    }

    public void setMesesContrato(String mesesContrato) {
        this.mesesContrato = mesesContrato;
    }

    public String getGrupoCotizacion() {
        return grupoCotizacion;
    }

    public void setGrupoCotizacion(String grupoCotizacion) {
        this.grupoCotizacion = grupoCotizacion;
    }

    public String getDesGrupoCotizacion() {
        return desGrupoCotizacion;
    }

    public void setDesGrupoCotizacion(String desGrupoCotizacion) {
        this.desGrupoCotizacion = desGrupoCotizacion;
    }

    public String getDireccionCT() {
        return direccionCT;
    }

    public void setDireccionCT(String direccionCT) {
        this.direccionCT = direccionCT;
    }

    public String getNumSS() {
        return numSS;
    }

    public void setNumSS(String numSS) {
        this.numSS = numSS;
    }

    public Double getCosteContrato() {
        return costeContrato;
    }

    public void setCosteContrato(Double costeContrato) {
        this.costeContrato = costeContrato;
    }

    public String getTipRetribucion() {
        return tipRetribucion;
    }

    public void setTipRetribucion(String tipRetribucion) {
        this.tipRetribucion = tipRetribucion;
    }

    public String getDesTipRetribucion() {
        return desTipRetribucion;
    }

    public void setDesTipRetribucion(String desTipRetribucion) {
        this.desTipRetribucion = desTipRetribucion;
    }

    public Double getImporteSub() {
        return importeSub;
    }

    public void setImporteSub(Double importeSub) {
        this.importeSub = importeSub;
    }

    
}
