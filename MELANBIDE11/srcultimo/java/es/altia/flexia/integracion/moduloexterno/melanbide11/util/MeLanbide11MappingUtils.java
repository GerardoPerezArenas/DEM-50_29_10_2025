
package es.altia.flexia.integracion.moduloexterno.melanbide11.util;

import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesgloseRSBVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DatosTablaDesplegableExtVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableExternoVO;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.log4j.Logger;

public class MeLanbide11MappingUtils {

    // Logger
    private static Logger log = Logger.getLogger(MeLanbide11MappingUtils.class);
    private static MeLanbide11MappingUtils instance = null;

    private MeLanbide11MappingUtils() {
    }

    public static MeLanbide11MappingUtils getInstance() {
        if (instance == null) {
            synchronized (MeLanbide11MappingUtils.class) {
                instance = new MeLanbide11MappingUtils();
            }
        }
        return instance;
    }

    public Object map(ResultSet rs, Class clazz) throws Exception {
        return mapVers2(rs, clazz, true);
    }

    public Object mapVers2(ResultSet rs, Class clazz, boolean completo) throws Exception {
        if (clazz == ContratacionVO.class) {
            return mapearContratacionVO(rs);
        } else if (clazz == DesplegableAdmonLocalVO.class) {
            return mapearDesplegableAdmonLocalVO(rs);
        } else if (clazz == DatosTablaDesplegableExtVO.class) {
            return mapearDatosTablaDesplegableExternoVO(rs);
        }

        return null;
    }

    public Object map3(ResultSet rs, String campoCodigo, String campoValor) throws Exception {
        return mapearDesplegableExternoVO(rs, campoCodigo, campoValor);
    }

    public Object mapMin(ResultSet rs, Class clazz) throws Exception {
        return mapVersMin(rs, clazz, true);
    }

    public Object mapVersMin(ResultSet rs, Class clazz, boolean completo) throws Exception {
        if (clazz == MinimisVO.class) {
            return mapearMinimisVO(rs);
        } else if (clazz == DesplegableAdmonLocalVO.class) {
            return mapearDesplegableAdmonLocalVO(rs);
        }

        return null;
    }

    public Object mapRSB(ResultSet rs, Class clazz) throws Exception {
        return mapVersRSB(rs, clazz, true);
    }

    public Object mapVersRSB(ResultSet rs, Class clazz, boolean completo) throws Exception {
        if (clazz == DesgloseRSBVO.class) {
            return mapearDesgloseRSBVO(rs);
        } else if (clazz == DesplegableAdmonLocalVO.class) {
            return mapearDesplegableAdmonLocalVO(rs);
        }
        return null;
    }

    /**
     * Comprueba de forma segura si el ResultSet contiene una columna con la
     * etiqueta dada. Evita lanzar SQLException en mapeos parciales cuando algunos
     * SELECT no incluyen columnas recién añadidas.
     */
    private boolean hasColumn(ResultSet rs, String columnLabel) {
        try {
            // Acceso por nombre; devolverá excepción si no existe la etiqueta.
            rs.findColumn(columnLabel);
            return true;
        } catch (SQLException ex) {
            return false;
        }
    }

    private Object mapearContratacionVO(ResultSet rs) throws SQLException {
        ContratacionVO contratacion = new ContratacionVO();

        contratacion.setNumExp(rs.getString("NUM_EXP"));

        contratacion.setId(rs.getInt("ID"));
        if (rs.wasNull()) {
            contratacion.setId(null);
        }

        contratacion.setOferta(rs.getString("NOFECONT"));
        contratacion.setIdContrato1(rs.getString("IDCONT1"));
        contratacion.setIdContrato2(rs.getString("IDCONT2"));

        contratacion.setDni(rs.getString("DNICONT"));
        contratacion.setNombre(rs.getString("NOMCONT"));
        contratacion.setApellido1(rs.getString("APE1CONT"));
        contratacion.setApellido2(rs.getString("APE2CONT"));
        if (rs.getDate("FECHNACCONT") != null) {
            contratacion.setFechaNacimiento(rs.getDate("FECHNACCONT"));
        }
        Integer aux1 = new Integer(rs.getInt("EDADCONT"));
        if (aux1 != 0) {
            contratacion.setEdad(aux1.intValue());
        }
        contratacion.setSexo(rs.getString("SEXOCONT"));
        contratacion.setMayor55(rs.getString("MAY55CONT"));
        contratacion.setFinFormativa(rs.getString("ACCFORCONT"));
        contratacion.setCodFormativa(rs.getString("CODFORCONT"));
        contratacion.setDenFormativa(rs.getString("DENFORCONT"));

        contratacion.setPuesto(rs.getString("PUESTOCONT"));
        contratacion.setOcupacion(rs.getString("CODOCUCONT"));
        contratacion.setDesOcupacionLibre(rs.getString("OCUCONT"));
        contratacion.setDesTitulacionLibre(rs.getString("DESTITULACION"));
        contratacion.setTitulacion(rs.getString("TITULACION"));
        contratacion.setcProfesionalidad(rs.getString("CPROFESIONALIDAD"));
        contratacion.setModalidadContrato(rs.getString("MODCONT"));
        contratacion.setJornada(rs.getString("JORCONT"));
        Double aux2 = new Double(rs.getDouble("PORCJOR"));
        if (aux2 != 0) {
            contratacion.setPorcJornada(aux2.doubleValue());
        }
        Integer aux6 = new Integer(rs.getInt("HORASCONV"));
        if (aux6 != 0) {
            contratacion.setHorasConv(aux6.intValue());
        }
        if (rs.getDate("FECHINICONT") != null) {
            contratacion.setFechaInicio(rs.getDate("FECHINICONT"));
        }
        if (rs.getDate("FECHFINCONT") != null) {
            contratacion.setFechaFin(rs.getDate("FECHFINCONT"));
        }
        contratacion.setMesesContrato(rs.getString("DURCONT"));
        contratacion.setGrupoCotizacion(rs.getString("GRSS"));
        contratacion.setDireccionCT(rs.getString("DIRCENTRCONT"));
        contratacion.setNumSS(rs.getString("NSSCONT"));
        Double aux4 = new Double(rs.getDouble("CSTCONT"));
        if (aux4 != 0) {
            contratacion.setCosteContrato(aux4.doubleValue());
        }
        contratacion.setTipRetribucion(rs.getString("TIPRSB"));

        Double aux5 = new Double(rs.getDouble("IMPSUBVCONT"));
        if (aux5 != 0) {
            contratacion.setImporteSub(aux5.doubleValue());
            log.info("*** MAPPING IMPSUBVCONT *** ID: " + contratacion.getId() + " - IMPSUBVCONT desde BD: " + aux5
                    + " - Asignado al VO");
        } else {
            log.info("*** MAPPING IMPSUBVCONT *** ID: " + contratacion.getId() + " - IMPSUBVCONT desde BD: " + aux5
                    + " (es 0 o NULL) - NO asignado al VO");
        }

        contratacion.setTitReqPuesto(rs.getString("TITREQPUESTO"));

        contratacion.setFunciones(rs.getString("FUNCIONES"));

        // Mapear campos RSB si existen en el ResultSet
        if (hasColumn(rs, "RSBSALBASE")) {
            Double rsbSalBase = new Double(rs.getDouble("RSBSALBASE"));
            if (!rs.wasNull() && rsbSalBase != 0) {
                contratacion.setRsbSalBase(rsbSalBase.doubleValue());
                log.info("*** MAPPING RSB *** Mapeado RSBSALBASE: " + rsbSalBase + " para contratación ID: "
                        + contratacion.getId());
            } else {
                log.info("*** MAPPING RSB *** RSBSALBASE es null o 0 para contratación ID: " + contratacion.getId());
            }
        } else {
            log.warn("*** MAPPING RSB *** Columna RSBSALBASE NO existe en ResultSet para contratación ID: "
                    + contratacion.getId());
        }

        if (hasColumn(rs, "RSBPAGEXTRA")) {
            Double rsbPagExtra = new Double(rs.getDouble("RSBPAGEXTRA"));
            if (!rs.wasNull() && rsbPagExtra != 0) {
                contratacion.setRsbPagExtra(rsbPagExtra.doubleValue());
                log.info("*** MAPPING RSB *** Mapeado RSBPAGEXTRA: " + rsbPagExtra + " para contratación ID: "
                        + contratacion.getId());
            } else {
                log.info("*** MAPPING RSB *** RSBPAGEXTRA es null o 0 para contratación ID: " + contratacion.getId());
            }
        } else {
            log.warn("*** MAPPING RSB *** Columna RSBPAGEXTRA NO existe en ResultSet para contratación ID: "
                    + contratacion.getId());
        }

        if (hasColumn(rs, "RSBCOMPCONV")) {
            Double rsbCompConv = new Double(rs.getDouble("RSBCOMPCONV"));
            if (!rs.wasNull() && rsbCompConv != 0) {
                contratacion.setRsbCompConv(rsbCompConv.doubleValue());
                log.info("*** MAPPING RSB *** Mapeado RSBCOMPCONV: " + rsbCompConv + " para contratación ID: "
                        + contratacion.getId());
                log.info("*** MAPPING RSB DETALLE *** ID: " + contratacion.getId() + " - RSBCOMPCONV desde BD: "
                        + rsbCompConv + " - getRsbComputableTotal(): " + contratacion.getRsbComputableTotal());
            } else {
                log.info("*** MAPPING RSB *** RSBCOMPCONV es null o 0 para contratación ID: " + contratacion.getId());
                log.info("*** MAPPING RSB DETALLE *** ID: " + contratacion.getId() + " - RSBCOMPCONV desde BD: "
                        + rsbCompConv + " (NULL/0)" + " - getRsbComputableTotal(): "
                        + contratacion.getRsbComputableTotal());
            }
        } else {
            log.warn("*** MAPPING RSB *** Columna RSBCOMPCONV NO existe en ResultSet para contratación ID: "
                    + contratacion.getId());
        }

        // Log final del mapeo completo
        log.info("*** MAPPING FINAL COMPLETO - ID: " + contratacion.getId() + " ***");
        log.info("- ImporteSub final: "
                + (contratacion.getImporteSub() != null ? contratacion.getImporteSub() : "NULL"));
        log.info("- RsbComputableTotal final: "
                + (contratacion.getRsbComputableTotal() != null ? contratacion.getRsbComputableTotal() : "NULL"));
        log.info("- RsbCompConv final: "
                + (contratacion.getRsbCompConv() != null ? contratacion.getRsbCompConv() : "NULL"));
        log.info("*** FIN MAPPING ***");

        return contratacion;
    }

    private Object mapearMinimisVO(ResultSet rs) throws SQLException {
        MinimisVO minimis = new MinimisVO();

        minimis.setNumExp(rs.getString("NUM_EXP"));

        minimis.setId(rs.getInt("ID"));
        if (rs.wasNull()) {
            minimis.setId(null);
        }

        minimis.setEstado(rs.getString("ESTADO"));
        minimis.setOrganismo(rs.getString("ORGANISMO"));
        minimis.setObjeto(rs.getString("OBJETO"));
        Double aux1 = new Double(rs.getDouble("IMPORTE"));
        if (aux1 != 0) {
            minimis.setImporte(aux1.doubleValue());
        }
        if (rs.getDate("FECHA") != null) {
            minimis.setFecha(rs.getDate("FECHA"));
        }

        return minimis;
    }

    private Object mapearDesgloseRSBVO(ResultSet rs) throws SQLException {
        DesgloseRSBVO rsb = new DesgloseRSBVO();

        // Claves comunes
        if (hasColumn(rs, "NUM_EXP")) {
            rsb.setNumExp(rs.getString("NUM_EXP"));
        }

        if (hasColumn(rs, "ID")) {
            rsb.setId(rs.getInt("ID"));
            if (rs.wasNull()) {
                rsb.setId(null);
            }
        }

        // Campos propios MELANBIDE11_DESGRSB
        if (hasColumn(rs, "DNICONTRSB")) {
            rsb.setDniConRSB(rs.getString("DNICONTRSB"));
        }
        if (hasColumn(rs, "RSBTIPO")) {
            rsb.setRsbTipo(rs.getString("RSBTIPO")); // 1|2
        }
        if (hasColumn(rs, "RSBIMPORTE")) {
            Double imp = new Double(rs.getDouble("RSBIMPORTE"));
            if (imp != 0) {
                rsb.setRsbImporte(imp.doubleValue()); // NUMBER(8,2)
            }
        }
        if (hasColumn(rs, "RSBCONCEPTO")) {
            rsb.setRsbConcepto(rs.getString("RSBCONCEPTO")); // F|V
        }
        if (hasColumn(rs, "RSBOBSERV")) {
            rsb.setRsbObserv(rs.getString("RSBOBSERV"));
        }

        return rsb;
    }

    private Object mapearDesplegableAdmonLocalVO(ResultSet rs) throws SQLException {
        DesplegableAdmonLocalVO valoresDesplegable = new DesplegableAdmonLocalVO();
        valoresDesplegable.setDes_cod(rs.getString("DES_COD"));
        valoresDesplegable.setDes_val_cod(rs.getString("DES_VAL_COD"));
        valoresDesplegable.setDes_nom(rs.getString("DES_NOM"));
        return valoresDesplegable;
    }

    private Object mapearDatosTablaDesplegableExternoVO(ResultSet rs) throws SQLException {
        DatosTablaDesplegableExtVO datosTablaDesplegable = new DatosTablaDesplegableExtVO();
        datosTablaDesplegable.setCodigoDesplegagle(rs.getString("CODIGO"));
        datosTablaDesplegable.setTabla(rs.getString("TABLA"));
        datosTablaDesplegable.setCampoCodigo(rs.getString("CAMPO_CODIGO"));
        datosTablaDesplegable.setCampoValor(rs.getString("CAMPO_VALOR"));
        return datosTablaDesplegable;
    }

    private Object mapearDesplegableExternoVO(ResultSet rs, String campoCodigo, String campoValor) throws SQLException {
        DesplegableExternoVO valoresDesplegable = new DesplegableExternoVO();
        valoresDesplegable.setCampoCodigo(rs.getString(campoCodigo));
        valoresDesplegable.setCampoValor(rs.getString(campoValor));
        return valoresDesplegable;
    }

}
