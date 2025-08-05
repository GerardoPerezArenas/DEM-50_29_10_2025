
package es.altia.flexia.integracion.moduloexterno.melanbide11.dao;

import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.MeLanbide11MappingUtils;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DatosTablaDesplegableExtVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableExternoVO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;

public class MeLanbide11DAO {

    //Logger
    private static Logger log = Logger.getLogger(MeLanbide11DAO.class);
    //Instancia
    private static MeLanbide11DAO instance = null;

    // Constructor
    private MeLanbide11DAO() {

    }

    public static MeLanbide11DAO getInstance() {
        if (instance == null) {
            synchronized (MeLanbide11DAO.class) {
                instance = new MeLanbide11DAO();
            }
        }
        return instance;
    }

    public List<ContratacionVO> getDatosContratacion(String numExp, int codOrganizacion, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        ContratacionVO contratacion = new ContratacionVO();
        try {
            String query = null;
            query = "SELECT * FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE NUM_EXP ='" + numExp + "'"
                    + " ORDER BY ID";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                contratacion = (ContratacionVO) MeLanbide11MappingUtils.getInstance().map(rs, ContratacionVO.class);
                //Cargamos en el request los valores de los desplegables
                lista.add(contratacion);
                contratacion = new ContratacionVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Contrataciones ", ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return lista;
    }

    public List<ContratacionVO> getContratacion(String numExp, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        ContratacionVO contratacion = new ContratacionVO();
        try {
            String query = null;
            query = "Select * From " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES) + " A "
                    + "Where A.Num_Exp= '" + numExp + "' Order By A.Id";
            if (log.isDebugEnabled()) {
                log.debug("sql getContratacion= " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                contratacion = (ContratacionVO) MeLanbide11MappingUtils.getInstance().map(rs, ContratacionVO.class);
                //Cargamos en el request los valores de los desplegables
                lista.add(contratacion);
                contratacion = new ContratacionVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Contrataci�n ", ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return lista;
    }

    public ContratacionVO getContratacionPorID(String id, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        ContratacionVO contratacion = new ContratacionVO();
        try {
            String query = null;
            query = "SELECT * FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE ID=" + (id != null && !id.equals("") ? id : "null");
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                contratacion = (ContratacionVO) MeLanbide11MappingUtils.getInstance().map(rs, ContratacionVO.class);
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando una Contrataci�n : " + id, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return contratacion;
    }

    public int eliminarContratacion(String id, Connection con) throws Exception {
        Statement st = null;
        try {
            String query = null;
            query = "DELETE FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE ID=" + (id != null && !id.equals("") ? id : "null");
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            return st.executeUpdate(query);
        } catch (Exception ex) {
            log.error("Se ha producido un error Eliminando Contrataci�n ID : " + id, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
        }
    }

    public boolean crearNuevaContratacion(ContratacionVO nuevaContratacion, Connection con) throws Exception {
        Statement st = null;
        //boolean opeCorrecta = true;
        String query = "";
        String fechaNacimiento = "";
        String fechaInicio = "";
        String fechaFin = "";
        if (nuevaContratacion != null && nuevaContratacion.getFechaNacimiento()!= null && !nuevaContratacion.getFechaNacimiento().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaNacimiento = formatoFecha.format(nuevaContratacion.getFechaNacimiento());
        }
        if (nuevaContratacion != null && nuevaContratacion.getFechaInicio()!= null && !nuevaContratacion.getFechaInicio().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaInicio = formatoFecha.format(nuevaContratacion.getFechaInicio());
        }
        if (nuevaContratacion != null && nuevaContratacion.getFechaFin()!= null && !nuevaContratacion.getFechaFin().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaFin = formatoFecha.format(nuevaContratacion.getFechaFin());
        }
        try {

            int id = recogerIDInsertar(ConfigurationParameter.getParameter(ConstantesMeLanbide11.SEQ_MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES), con);
            query = "INSERT INTO " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + "(ID,NUM_EXP,NOFECONT,IDCONT1,IDCONT2,DNICONT,NOMCONT,"
                    + "APE1CONT,APE2CONT,FECHNACCONT,EDADCONT,SEXOCONT,MAY55CONT,ACCFORCONT,CODFORCONT,DENFORCONT,"
                    + "PUESTOCONT,CODOCUCONT,OCUCONT,DESTITULACION,TITULACION,CPROFESIONALIDAD,MODCONT,JORCONT,PORCJOR,HORASCONV,FECHINICONT,FECHFINCONT,DURCONT,GRSS,DIRCENTRCONT,NSSCONT,CSTCONT,TIPRSB,IMPSUBVCONT) "
                    + " VALUES (" + id
                    + ", '" + nuevaContratacion.getNumExp()
                    + "', '" + nuevaContratacion.getOferta()
                    + "', '" + nuevaContratacion.getIdContrato1()
                    + "', '" + nuevaContratacion.getIdContrato2()
                    + "', '" + nuevaContratacion.getDni()
                    + "', '" + nuevaContratacion.getNombre()
                    + "', '" + nuevaContratacion.getApellido1()
                    + "', '" + nuevaContratacion.getApellido2()
                    + "' , TO_DATE('" + fechaNacimiento + "','dd/mm/yyyy')"
                    + " , " + nuevaContratacion.getEdad()
                    + " , '" + nuevaContratacion.getSexo()
                    + "' , '" + nuevaContratacion.getMayor55()
                    + "' , '" + nuevaContratacion.getFinFormativa()
                    + "' , '" + nuevaContratacion.getCodFormativa()
                    + "' , '" + nuevaContratacion.getDenFormativa()
                    + "', '" + nuevaContratacion.getPuesto()
                    + "', '" + nuevaContratacion.getOcupacion()
                    + "', '" + nuevaContratacion.getDesOcupacionLibre()
                    + "', '" + nuevaContratacion.getDesTitulacionLibre()
                    + "', '" + nuevaContratacion.getTitulacion()
                    + "', '" + nuevaContratacion.getcProfesionalidad()
                    + "', '" + nuevaContratacion.getModalidadContrato()
                    + "', '" + nuevaContratacion.getJornada()
                    + "', " + nuevaContratacion.getPorcJornada()
                    + " , " + nuevaContratacion.getHorasConv()
                    + " , TO_DATE('" + fechaInicio + "','dd/mm/yyyy')"
                    + " , TO_DATE('" + fechaFin + "','dd/mm/yyyy')"
                    + " , '" + nuevaContratacion.getMesesContrato()
                    + "', '" + nuevaContratacion.getGrupoCotizacion()
                    + "', '" + nuevaContratacion.getDireccionCT()
                    + "', '" + nuevaContratacion.getNumSS()
                    + "', " + nuevaContratacion.getCosteContrato()
                    + ", '" + nuevaContratacion.getTipRetribucion()
                    + "'," + nuevaContratacion.getImporteSub()
                    + ")";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            int insert = st.executeUpdate(query);
            if (insert > 0) {
                return true;
            } else {
                log.debug("No Se ha podido guardar una nueva Contrataci�n ");
                return false;
            }

        } catch (Exception ex) {
            //opeCorrecta = false;
            log.debug("Se ha producido un error al insertar una nueva Contrataci�n" + ex.getMessage());
            throw new Exception(ex);
            //return opeCorrecta;
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement");
            }
            if (st != null) {
                st.close();
            }
        }
    }

    public boolean modificarContratacion(ContratacionVO datModif, Connection con) throws Exception {
        Statement st = null;
        String query = "";
        String fechaNacimiento = "";
        String fechaInicio = "";
        String fechaFin = "";
        if (datModif != null && datModif.getFechaNacimiento()!= null && !datModif.getFechaNacimiento().toString().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaNacimiento = formatoFecha.format(datModif.getFechaNacimiento());
        }
        if (datModif != null && datModif.getFechaInicio()!= null && !datModif.getFechaInicio().toString().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaInicio = formatoFecha.format(datModif.getFechaInicio());
        }
        if (datModif != null && datModif.getFechaFin()!= null && !datModif.getFechaFin().toString().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaFin = formatoFecha.format(datModif.getFechaFin());
        }
        
        
        try {
            query = "UPDATE " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " SET NOFECONT='" + datModif.getOferta() + "'"
                    + ", IDCONT1='" + datModif.getIdContrato1() + "'"
                    + ", IDCONT2='" + datModif.getIdContrato2() + "'"
                    + ", DNICONT='" + datModif.getDni() + "'"
                    + ", NOMCONT='" + datModif.getNombre() + "'"
                    + ", APE1CONT='" + datModif.getApellido1() + "'"
                    + ", APE2CONT='" + datModif.getApellido2() + "'"
                    + ", FECHNACCONT=TO_DATE('" + fechaNacimiento + "','dd/mm/yyyy')"
                    + ", EDADCONT=" + datModif.getEdad()
                    + ", SEXOCONT='" + datModif.getSexo() + "'"
                    + ", MAY55CONT='" + datModif.getMayor55() + "'"
                    + ", ACCFORCONT='" + datModif.getFinFormativa() + "'"
                    + ", CODFORCONT='" + datModif.getCodFormativa() + "'"
                    + ", DENFORCONT='" + datModif.getDenFormativa() + "'"
                    + ", PUESTOCONT='" + datModif.getPuesto() + "'"
                    + ", CODOCUCONT='" + datModif.getOcupacion() + "'"
                    + ", OCUCONT='" + datModif.getDesOcupacionLibre() + "'"
                    + ", DESTITULACION='" + datModif.getDesTitulacionLibre()+ "'"
                    + ", TITULACION='" + datModif.getTitulacion()+ "'"
                    + ", CPROFESIONALIDAD='" + datModif.getcProfesionalidad()+ "'"
                    + ", MODCONT='" + datModif.getModalidadContrato() + "'"
                    + ", JORCONT='" + datModif.getJornada() + "'"
                    + ", PORCJOR=" + datModif.getPorcJornada()
                    + ", HORASCONV=" + datModif.getHorasConv()
                    + ", FECHINICONT=TO_DATE('" + fechaInicio + "','dd/mm/yyyy')"
                    + ", FECHFINCONT=TO_DATE('" + fechaFin + "','dd/mm/yyyy')"
                    + ", DURCONT='" + datModif.getMesesContrato() + "'"
                    + ", GRSS='" + datModif.getGrupoCotizacion() + "'"
                    + ", DIRCENTRCONT='" + datModif.getDireccionCT() + "'"
                    + ", NSSCONT='" + datModif.getNumSS() + "'"
                    + ", CSTCONT=" + datModif.getCosteContrato()
                    + ", TIPRSB='" + datModif.getTipRetribucion()+ "'"
                    + ", IMPSUBVCONT=" + datModif.getImporteSub()
                    + " WHERE ID=" + datModif.getId();
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            int insert = st.executeUpdate(query);
            if (insert > 0) {
                return true;
            } else {
                return false;
            }

        } catch (Exception ex) {
            log.debug("Se ha producido un error al modificar una contrataci�n - "
                    + datModif.getId() + " - " + ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement");
            }
            if (st != null) {
                st.close();
            }
        }
    }
    
    public List<MinimisVO> getDatosMinimis(String numExp, int codOrganizacion, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        MinimisVO minimis = new MinimisVO();
        try {
            String query = null;
            query = "SELECT * FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE NUM_EXP ='" + numExp + "'"
                    + " ORDER BY ID";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                minimis = (MinimisVO) MeLanbide11MappingUtils.getInstance().mapMin(rs, MinimisVO.class);
                //Cargamos en el request los valores de los desplegables
                lista.add(minimis);
                minimis = new MinimisVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Minimis ", ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return lista;
    }

    public List<MinimisVO> getMinimis(String numExp, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        MinimisVO minimis = new MinimisVO();
        try {
            String query = null;
            query = "Select * From " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES) + " A "
                    + "Where A.Num_Exp= '" + numExp + "' Order By A.Id";
            if (log.isDebugEnabled()) {
                log.debug("sql getMinimis= " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                minimis = (MinimisVO) MeLanbide11MappingUtils.getInstance().mapMin(rs, MinimisVO.class);
                //Cargamos en el request los valores de los desplegables
                lista.add(minimis);
                minimis = new MinimisVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Minimis ", ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return lista;
    }

    public MinimisVO getMinimisPorID(String id, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        MinimisVO minimis = new MinimisVO();
        try {
            String query = null;
            query = "SELECT * FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE ID=" + (id != null && !id.equals("") ? id : "null");
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                minimis = (MinimisVO) MeLanbide11MappingUtils.getInstance().mapMin(rs, MinimisVO.class);
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando una Minimis : " + id, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return minimis;
    }

    public int eliminarMinimis(String id, Connection con) throws Exception {
        Statement st = null;
        try {
            String query = null;
            query = "DELETE FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE ID=" + (id != null && !id.equals("") ? id : "null");
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            return st.executeUpdate(query);
        } catch (Exception ex) {
            log.error("Se ha producido un error Eliminando Minimis ID : " + id, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
        }
    }

    public boolean crearNuevaMinimis(MinimisVO nuevaMinimis, Connection con) throws Exception {
        Statement st = null;
        String query = "";
        String fechaSub = "";
        if (nuevaMinimis != null && nuevaMinimis.getFecha()!= null && !nuevaMinimis.getFecha().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaSub = formatoFecha.format(nuevaMinimis.getFecha());
        }
        try {

            int id = recogerIDInsertar(ConfigurationParameter.getParameter(ConstantesMeLanbide11.SEQ_MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES), con);
            query = "INSERT INTO " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + "(ID,NUM_EXP,ESTADO,ORGANISMO,OBJETO,IMPORTE,FECHA) "
                    + " VALUES (" + id
                    + ", '" + nuevaMinimis.getNumExp()
                    + "', '" + nuevaMinimis.getEstado()
                    + "', '" + nuevaMinimis.getOrganismo()
                    + "', '" + nuevaMinimis.getObjeto()
                    + "', " + nuevaMinimis.getImporte()
                    + " , TO_DATE('" + fechaSub + "','dd/mm/yyyy')"
                    + ")";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            int insert = st.executeUpdate(query);
            if (insert > 0) {
                return true;
            } else {
                log.debug("No Se ha podido guardar una nueva Minimis ");
                return false;
            }

        } catch (Exception ex) {
            //opeCorrecta = false;
            log.debug("Se ha producido un error al insertar una nueva Minimis" + ex.getMessage());
            throw new Exception(ex);
            //return opeCorrecta;
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement");
            }
            if (st != null) {
                st.close();
            }
        }
    }

    public boolean modificarMinimis(MinimisVO datModif, Connection con) throws Exception {
        Statement st = null;
        String query = "";
        String fechaSub = "";
        if (datModif != null && datModif.getFecha()!= null && !datModif.getFecha().toString().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaSub = formatoFecha.format(datModif.getFecha());
        }
        
        
        try {
            query = "UPDATE " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " SET ESTADO='" + datModif.getEstado()+ "'"
                    + ", ORGANISMO='" + datModif.getOrganismo()+ "'"
                    + ", OBJETO='" + datModif.getObjeto()+ "'"
                    + ", IMPORTE=" + datModif.getImporte()
                    + ", FECHA=TO_DATE('" + fechaSub + "','dd/mm/yyyy')"
                    + " WHERE ID=" + datModif.getId();
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            int insert = st.executeUpdate(query);
            if (insert > 0) {
                return true;
            } else {
                return false;
            }

        } catch (Exception ex) {
            log.debug("Se ha producido un error al modificar una Minimis - "
                    + datModif.getId() + " - " + ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement");
            }
            if (st != null) {
                st.close();
            }
        }
    }

    private int recogerIDInsertar(String sequence, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        int id = 0;
        try {
            String query = "SELECT " + sequence + ".NextVal AS PROXID FROM DUAL ";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            if (rs.next()) {
                id = rs.getInt("PROXID");
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando el n�mero de ID para inserci�n al llamar la secuencia " + sequence + " : ", ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return id;
    }

    public List<DesplegableAdmonLocalVO> getValoresDesplegablesAdmonLocalxdes_cod(String des_cod, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesplegableAdmonLocalVO> lista = new ArrayList<DesplegableAdmonLocalVO>();
        DesplegableAdmonLocalVO valoresDesplegable = new DesplegableAdmonLocalVO();
        try {
            String query = null;
            query = "SELECT * FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.TABLA_VALORES_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE DES_COD='" + des_cod + "' order by DES_NOM";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                valoresDesplegable = (DesplegableAdmonLocalVO) MeLanbide11MappingUtils.getInstance().map(rs, DesplegableAdmonLocalVO.class);
                lista.add(valoresDesplegable);
                valoresDesplegable = new DesplegableAdmonLocalVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando valores de desplegable : " + des_cod, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return lista;
    }
    
    public DatosTablaDesplegableExtVO getDatosMapeoDesplegableExterno(String codDes, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        DatosTablaDesplegableExtVO datosMapeoDesplegableExterno = new DatosTablaDesplegableExtVO();
        try {
            String query = null;
            query = "SELECT CODIGO,TABLA,CAMPO_CODIGO,CAMPO_VALOR FROM " + ConfigurationParameter.getParameter(ConstantesMeLanbide11.TABLA_CODIGOS_DESPLEGABLES_EXTERNOS, ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE CODIGO='" + (codDes != null && !codDes.equals("") ? codDes : "null") + "'";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                datosMapeoDesplegableExterno = (DatosTablaDesplegableExtVO) MeLanbide11MappingUtils.getInstance().map(rs, DatosTablaDesplegableExtVO.class);
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando datos para mapeo de desplegable externo de c�digo : " + codDes, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return datosMapeoDesplegableExterno;
    }

    public List<DesplegableExternoVO> getValoresDesplegablesExternos(String tablaDesplegable, String campoCodigo, String campoValor, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesplegableExternoVO> lista = new ArrayList<DesplegableExternoVO>();
        DesplegableExternoVO valoresDesplegable = new DesplegableExternoVO();
        try {
            String query = null;
            query = "SELECT " + campoCodigo + ", " + campoValor + " FROM " + tablaDesplegable + " order by " + campoValor;
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                valoresDesplegable = (DesplegableExternoVO) MeLanbide11MappingUtils.getInstance().map3(rs, campoCodigo, campoValor);
                lista.add(valoresDesplegable);
                valoresDesplegable = new DesplegableExternoVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando valores de desplegable externo de tabla: " + tablaDesplegable, ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset");
            }
            if (st != null) {
                st.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return lista;
    }
    
    
}
