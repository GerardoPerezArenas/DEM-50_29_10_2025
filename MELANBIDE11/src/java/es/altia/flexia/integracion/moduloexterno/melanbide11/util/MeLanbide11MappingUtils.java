
package es.altia.flexia.integracion.moduloexterno.melanbide11.util;

import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DatosTablaDesplegableExtVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableExternoVO;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MeLanbide11MappingUtils {

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
        }
        
        
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
