
package es.altia.flexia.integracion.moduloexterno.melanbide11.dao;

import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.MeLanbide11MappingUtils;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesgloseRSBVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DatosTablaDesplegableExtVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableExternoVO;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
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

    // Logger
    private static Logger log = Logger.getLogger(MeLanbide11DAO.class);
    // Instancia
    private static MeLanbide11DAO instance = null;

    private static Double normalizaImporteSub(Double rsbTotal, String tipRsb) {
        double tot = (rsbTotal != null) ? rsbTotal : 0.0;
        String t = (tipRsb != null) ? tipRsb.trim().toUpperCase() : "A"; // A=anual, M=mensual
        return "M".equals(t) ? tot / 14.0 : tot;
    }

    private static double nz(Double v) {
        return v == null ? 0d : v;
    }

    private double calculaRsbTotal(String numExp, String dni, Double salBase, Double pagExtra, Connection con)
            throws Exception {
        Double comp = getSumaComplementosSalariales(numExp, dni, con); // ya normaliza DNI/NUM_EXP
        return nz(salBase) + nz(pagExtra) + nz(comp);
    }

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

    public List<ContratacionVO> getDatosContratacion(String numExp, int codOrganizacion, Connection con)
            throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        ContratacionVO contratacion = new ContratacionVO();
        try {
            String query = null;
            query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE NUM_EXP ='" + numExp + "'" + " ORDER BY ID";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                contratacion = (ContratacionVO) MeLanbide11MappingUtils.getInstance().map(rs, ContratacionVO.class);
                // Cargamos en el request los valores de los desplegables
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
            query = "Select * From "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " A " + "Where A.Num_Exp= '" + numExp + "' Order By A.Id";
            if (log.isDebugEnabled()) {
                log.debug("sql getContratacion= " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                contratacion = (ContratacionVO) MeLanbide11MappingUtils.getInstance().map(rs, ContratacionVO.class);
                // Cargamos en el request los valores de los desplegables
                lista.add(contratacion);
                contratacion = new ContratacionVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Contrataciï¿½n ", ex);
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

    /**
     * Obtiene solo el DNI (DNICONT) de una contratación concreta por ID y número de
     * expediente. Evita cargar la lista completa de contrataciones cuando
     * únicamente se necesita resolver el filtro para la tabla de desglose RSB.
     * 
     * @param numExp     Número de expediente
     * @param idContrato ID de la fila en MELANBIDE11_CONTRATACION
     * @param con        Conexión
     * @return DNI sin normalizar (tal cual en tabla) o null si no existe
     */
    public String getDniContratacionById(String numExp, String idContrato, Connection con) throws Exception {
        if (numExp == null || numExp.trim().isEmpty() || idContrato == null || idContrato.trim().isEmpty()) {
            return null;
        }
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            String tabla = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            String sql = "SELECT DNICONT FROM " + tabla + " WHERE NUM_EXP = ? AND ID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, numExp);
            ps.setString(2, idContrato);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("DNICONT");
            }
            return null;
        } catch (Exception e) {
            log.error("Error obteniendo DNI por ID de contratación", e);
            throw new Exception(e);
        } finally {
            if (rs != null)
                try {
                    rs.close();
                } catch (Exception ignore) {
                }
            if (ps != null)
                try {
                    ps.close();
                } catch (Exception ignore) {
                }
        }
    }

    public ContratacionVO getContratacionPorID(String id, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        ContratacionVO contratacion = new ContratacionVO();

        try {
            String tablaContr = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            String tablaDesg = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);

            // NOTA: Separamos ahora la suma de complementos salariales (RSBTIPO='1') de la
            // de extrasalariales (RSBTIPO='2').
            // Solo la suma salarial (tipo=1) se asignará a rsbImporte para la pestaña 1.
            String query = "SELECT c.*, " + "       NVL(c.RSBSALBASE,0) RSBSALBASE_CALC, "
                    + "       NVL(c.RSBPAGEXTRA,0) RSBPAGEXTRA_CALC, "
                    + "       NVL((SELECT SUM(NVL(d.RSBIMPORTE,0)) FROM " + tablaDesg + " d "
                    + "             WHERE TRIM(d.NUM_EXP)=TRIM(c.NUM_EXP) "
                    + "               AND UPPER(REPLACE(REPLACE(TRIM(d.DNICONTRSB),' ',''),'-','')) = UPPER(REPLACE(REPLACE(TRIM(c.DNICONT),' ',''),'-','')) "
                    + "               AND d.RSBTIPO='1'),0) AS IMP_COMP_SAL, "
                    + "       NVL((SELECT SUM(NVL(d2.RSBIMPORTE,0)) FROM " + tablaDesg + " d2 "
                    + "             WHERE TRIM(d2.NUM_EXP)=TRIM(c.NUM_EXP) "
                    + "               AND UPPER(REPLACE(REPLACE(TRIM(d2.DNICONTRSB),' ',''),'-','')) = UPPER(REPLACE(REPLACE(TRIM(c.DNICONT),' ',''),'-','')) "
                    + "               AND d2.RSBTIPO='2'),0) AS IMP_COMP_EXTRA " + "  FROM " + tablaContr
                    + " c WHERE c.ID=" + (id != null && !id.equals("") ? id : "null");

            if (log.isDebugEnabled()) {
                log.debug("*** QUERY GETCONTRATACION (correlacionada) ***");
                log.debug("sql = " + query);
            }

            st = con.createStatement();
            rs = st.executeQuery(query);
            if (rs.next()) {
                contratacion = (ContratacionVO) MeLanbide11MappingUtils.getInstance().map(rs, ContratacionVO.class);

                Double complementosSalariales = rs.getDouble("IMP_COMP_SAL");
                if (rs.wasNull())
                    complementosSalariales = 0.0;
                Double complementosExtras = rs.getDouble("IMP_COMP_EXTRA");
                if (rs.wasNull())
                    complementosExtras = 0.0;
                // Solo guardamos en VO los salariales (requerimiento pestaña 1)
                contratacion.setRsbImporte(complementosSalariales);

                if (log.isDebugEnabled()) {
                    log.debug("*** CARGA COMPLEMENTOS SALARIALES (CORRELACIONADA) ***");
                    log.debug("ID Contratación: " + contratacion.getId());
                    log.debug("Salario Base: " + contratacion.getRsbSalBase());
                    log.debug("Pagas Extra: " + contratacion.getRsbPagExtra());
                    log.debug("Complementos Salariales (tipo=1) calculados: " + complementosSalariales);
                    log.debug("Complementos Extrasalariales (tipo=2) calculados: " + complementosExtras);
                    log.debug("RSB Computable: " + contratacion.getRsbCompConv());
                }
            }
            return contratacion;

        } catch (Exception ex) {
            log.error("Error recuperando Contratación : " + id, ex);
            throw new Exception(ex);
        } finally {
            if (st != null)
                st.close();
            if (rs != null)
                rs.close();
        }
    }

    public int eliminarContratacion(String id, Connection con) throws Exception {
        Statement st = null;
        try {
            String query = null;
            query = "DELETE FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE ID=" + (id != null && !id.equals("") ? id : "null");
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            return st.executeUpdate(query);
        } catch (Exception ex) {
            log.error("Se ha producido un error Eliminando Contrataciï¿½n ID : " + id, ex);
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
        String query = "";
        String fechaNacimiento = "";
        String fechaInicio = "";
        String fechaFin = "";
        if (nuevaContratacion != null && nuevaContratacion.getFechaNacimiento() != null
                && !nuevaContratacion.getFechaNacimiento().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaNacimiento = formatoFecha.format(nuevaContratacion.getFechaNacimiento());
        }
        if (nuevaContratacion != null && nuevaContratacion.getFechaInicio() != null
                && !nuevaContratacion.getFechaInicio().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaInicio = formatoFecha.format(nuevaContratacion.getFechaInicio());
        }
        if (nuevaContratacion != null && nuevaContratacion.getFechaFin() != null
                && !nuevaContratacion.getFechaFin().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaFin = formatoFecha.format(nuevaContratacion.getFechaFin());
        }
        String titReq = nuevaContratacion.getTitReqPuesto();
        titReq = (titReq != null) ? titReq.replace("'", "''") : null;
        String funciones = nuevaContratacion.getFunciones();
        funciones = (funciones != null) ? funciones.replace("'", "''") : null;

        try {
            if (log.isDebugEnabled())
                log.debug("FLUJO RSB - Paso 6: Calculando RSB total para inserción");

            // RSB total = base + extras + complementos (SOLO SUMA)
            Double rsbTotal = calculaRsbTotal(nuevaContratacion.getNumExp(), nuevaContratacion.getDni(),
                    nuevaContratacion.getRsbSalBase(), nuevaContratacion.getRsbPagExtra(), con);
            nuevaContratacion.setRsbCompConv(rsbTotal);

            // *** NO MODIFICAR IMPSUBVCONT - preservar valor original del usuario ***
            // El importe de subvención es independiente del cálculo RSB

            if (log.isDebugEnabled()) {
                log.debug("FLUJO RSB (INSERT): total=" + rsbTotal + " - IMPSUBVCONT preservado: "
                        + nuevaContratacion.getImporteSub());
            }

            int id = recogerIDInsertar(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.SEQ_MELANBIDE11_CONTRATACION,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                    con);

            query = "INSERT INTO "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + "(ID,NUM_EXP,NOFECONT,IDCONT1,IDCONT2,DNICONT,NOMCONT,"
                    + "APE1CONT,APE2CONT,FECHNACCONT,EDADCONT,SEXOCONT,MAY55CONT,ACCFORCONT,CODFORCONT,DENFORCONT,"
                    + "PUESTOCONT,CODOCUCONT,OCUCONT,DESTITULACION,TITULACION,CPROFESIONALIDAD,MODCONT,JORCONT,PORCJOR,HORASCONV,FECHINICONT,FECHFINCONT,DURCONT,GRSS,DIRCENTRCONT,NSSCONT,CSTCONT,TIPRSB,IMPSUBVCONT,"
                    + "TITREQPUESTO,FUNCIONES,RSBSALBASE,RSBPAGEXTRA,RSBCOMPCONV) " + " VALUES (" + id + ", '"
                    + nuevaContratacion.getNumExp() + "', '" + nuevaContratacion.getOferta() + "', '"
                    + nuevaContratacion.getIdContrato1() + "', '" + nuevaContratacion.getIdContrato2() + "', '"
                    + nuevaContratacion.getDni() + "', '" + nuevaContratacion.getNombre() + "', '"
                    + nuevaContratacion.getApellido1() + "', '" + nuevaContratacion.getApellido2() + "' , TO_DATE('"
                    + fechaNacimiento + "','dd/mm/yyyy')" + " , " + nuevaContratacion.getEdad() + " , '"
                    + nuevaContratacion.getSexo() + "' , '" + nuevaContratacion.getMayor55() + "' , '"
                    + nuevaContratacion.getFinFormativa() + "' , '" + nuevaContratacion.getCodFormativa() + "' , '"
                    + nuevaContratacion.getDenFormativa() + "', '" + nuevaContratacion.getPuesto() + "', '"
                    + nuevaContratacion.getOcupacion() + "', '" + nuevaContratacion.getDesOcupacionLibre() + "', '"
                    + nuevaContratacion.getDesTitulacionLibre() + "', '" + nuevaContratacion.getTitulacion() + "', '"
                    + nuevaContratacion.getcProfesionalidad() + "', '" + nuevaContratacion.getModalidadContrato()
                    + "', '" + nuevaContratacion.getJornada() + "', " + nuevaContratacion.getPorcJornada() + " , "
                    + nuevaContratacion.getHorasConv() + " , TO_DATE('" + fechaInicio + "','dd/mm/yyyy')"
                    + " , TO_DATE('" + fechaFin + "','dd/mm/yyyy')" + " , '" + nuevaContratacion.getMesesContrato()
                    + "', '" + nuevaContratacion.getGrupoCotizacion() + "', '" + nuevaContratacion.getDireccionCT()
                    + "', '" + nuevaContratacion.getNumSS() + "', " + nuevaContratacion.getCosteContrato() + ", '"
                    + nuevaContratacion.getTipRetribucion() + "',"
                    + (nuevaContratacion.getImporteSub() != null ? nuevaContratacion.getImporteSub() : "null") + ", "
                    + (titReq != null ? "'" + titReq + "'" : "null") + ", "
                    + (funciones != null ? "'" + funciones + "'" : "null") + ", "
                    + (nuevaContratacion.getRsbSalBase() != null ? nuevaContratacion.getRsbSalBase() : "null") + ", "
                    + (nuevaContratacion.getRsbPagExtra() != null ? nuevaContratacion.getRsbPagExtra() : "null") + ", "
                    + (nuevaContratacion.getRsbCompConv() != null ? nuevaContratacion.getRsbCompConv() : "null") + ")";

            if (log.isDebugEnabled())
                log.debug("sql = " + query);

            st = con.createStatement();
            int insert = st.executeUpdate(query);
            if (insert > 0) {
                actualizarRsbCompConv(nuevaContratacion.getNumExp(), nuevaContratacion.getDni(), con);
                return true;
            } else {
                log.debug("No se ha podido guardar una nueva Contratación");
                return false;
            }

        } catch (Exception ex) {
            log.debug("Error al insertar una nueva Contratación: " + ex.getMessage());
            throw new Exception(ex);
        } finally {
            if (st != null)
                st.close();
        }
    }

    // === modificarContratacion (reemplaza tu método por este) ===
    public boolean modificarContratacion(ContratacionVO datModif, Connection con) throws Exception {
        Statement st = null;
        String query = "";
        String fechaNacimiento = "";
        String fechaInicio = "";
        String fechaFin = "";

        if (datModif != null && datModif.getFechaNacimiento() != null
                && !datModif.getFechaNacimiento().toString().equals("")) {
            SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy");
            fechaNacimiento = f.format(datModif.getFechaNacimiento());
        }
        if (datModif != null && datModif.getFechaInicio() != null && !datModif.getFechaInicio().toString().equals("")) {
            SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy");
            fechaInicio = f.format(datModif.getFechaInicio());
        }
        if (datModif != null && datModif.getFechaFin() != null && !datModif.getFechaFin().toString().equals("")) {
            SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy");
            fechaFin = f.format(datModif.getFechaFin());
        }
        String titReq = datModif.getTitReqPuesto();
        titReq = (titReq != null) ? titReq.replace("'", "''") : null;
        String funciones = datModif.getFunciones();
        funciones = (funciones != null) ? funciones.replace("'", "''") : null;

        try {
            if (log.isDebugEnabled())
                log.debug("FLUJO RSB - Paso 6: Calculando RSB total para actualización");

            // RSB total = base + extras + complementos (SOLO SUMA)
            Double rsbTotal = calculaRsbTotal(datModif.getNumExp(), datModif.getDni(), datModif.getRsbSalBase(),
                    datModif.getRsbPagExtra(), con);
            datModif.setRsbCompConv(rsbTotal);

            // *** NO MODIFICAR IMPSUBVCONT - preservar valor original del usuario ***
            // El importe de subvención es independiente del cálculo RSB

            if (log.isDebugEnabled()) {
                log.debug("FLUJO RSB (UPDATE): total=" + rsbTotal + " - IMPSUBVCONT preservado: "
                        + datModif.getImporteSub());
            }

            query = "UPDATE "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " SET NOFECONT='" + datModif.getOferta() + "'" + ", IDCONT1='" + datModif.getIdContrato1() + "'"
                    + ", IDCONT2='" + datModif.getIdContrato2() + "'" + ", DNICONT='" + datModif.getDni() + "'"
                    + ", NOMCONT='" + datModif.getNombre() + "'" + ", APE1CONT='" + datModif.getApellido1() + "'"
                    + ", APE2CONT='" + datModif.getApellido2() + "'" + ", FECHNACCONT=TO_DATE('" + fechaNacimiento
                    + "','dd/mm/yyyy')" + ", EDADCONT=" + datModif.getEdad() + ", SEXOCONT='" + datModif.getSexo() + "'"
                    + ", MAY55CONT='" + datModif.getMayor55() + "'" + ", ACCFORCONT='" + datModif.getFinFormativa()
                    + "'" + ", CODFORCONT='" + datModif.getCodFormativa() + "'" + ", DENFORCONT='"
                    + datModif.getDenFormativa() + "'" + ", PUESTOCONT='" + datModif.getPuesto() + "'"
                    + ", CODOCUCONT='" + datModif.getOcupacion() + "'" + ", OCUCONT='" + datModif.getDesOcupacionLibre()
                    + "'" + ", DESTITULACION='" + datModif.getDesTitulacionLibre() + "'" + ", TITULACION='"
                    + datModif.getTitulacion() + "'" + ", CPROFESIONALIDAD='" + datModif.getcProfesionalidad() + "'"
                    + ", MODCONT='" + datModif.getModalidadContrato() + "'" + ", JORCONT='" + datModif.getJornada()
                    + "'" + ", PORCJOR=" + datModif.getPorcJornada() + ", HORASCONV=" + datModif.getHorasConv()
                    + ", FECHINICONT=TO_DATE('" + fechaInicio + "','dd/mm/yyyy')" + ", FECHFINCONT=TO_DATE('" + fechaFin
                    + "','dd/mm/yyyy')" + ", DURCONT='" + datModif.getMesesContrato() + "'" + ", GRSS='"
                    + datModif.getGrupoCotizacion() + "'" + ", DIRCENTRCONT='" + datModif.getDireccionCT() + "'"
                    + ", NSSCONT='" + datModif.getNumSS() + "'" + ", CSTCONT=" + datModif.getCosteContrato()
                    + ", TIPRSB='" + datModif.getTipRetribucion() + "'" + ", IMPSUBVCONT="
                    + (datModif.getImporteSub() != null ? datModif.getImporteSub() : "null") + ", TITREQPUESTO="
                    + (titReq != null ? "'" + titReq + "'" : "null") + ", FUNCIONES="
                    + (funciones != null ? "'" + funciones + "'" : "null") + ", RSBSALBASE="
                    + (datModif.getRsbSalBase() != null ? datModif.getRsbSalBase() : "null") + ", RSBPAGEXTRA="
                    + (datModif.getRsbPagExtra() != null ? datModif.getRsbPagExtra() : "null") + ", RSBCOMPCONV="
                    + (datModif.getRsbCompConv() != null ? datModif.getRsbCompConv() : "null") + " WHERE ID="
                    + datModif.getId();

            if (log.isDebugEnabled()) {
                log.debug("*** DAO UPDATE RSB DEBUG ***");
                log.debug("sql = " + query);
            }

            st = con.createStatement();
            int update = st.executeUpdate(query);
            if (update > 0) {
                actualizarRsbCompConv(datModif.getNumExp(), datModif.getDni(), con);
                return true;
            } else {
                return false;
            }

        } catch (Exception ex) {
            log.debug("Se ha producido un error al modificar una contratacion - " + datModif.getId() + " - " + ex);
            throw new Exception(ex);
        } finally {
            if (st != null)
                st.close();
        }
    }

    public List<MinimisVO> getDatosMinimis(String numExp, int codOrganizacion, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        MinimisVO minimis = new MinimisVO();
        try {
            String query = null;
            query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE NUM_EXP ='" + numExp + "'" + " ORDER BY ID";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                minimis = (MinimisVO) MeLanbide11MappingUtils.getInstance().mapMin(rs, MinimisVO.class);
                // Cargamos en el request los valores de los desplegables
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
            query = "Select * From "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " A " + "Where A.Num_Exp= '" + numExp + "' Order By A.Id";
            if (log.isDebugEnabled()) {
                log.debug("sql getMinimis= " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                minimis = (MinimisVO) MeLanbide11MappingUtils.getInstance().mapMin(rs, MinimisVO.class);
                // Cargamos en el request los valores de los desplegables
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
            query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
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
            query = "DELETE FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
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
        if (nuevaMinimis != null && nuevaMinimis.getFecha() != null && !nuevaMinimis.getFecha().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaSub = formatoFecha.format(nuevaMinimis.getFecha());
        }
        try {

            int id = recogerIDInsertar(ConfigurationParameter.getParameter(
                    ConstantesMeLanbide11.SEQ_MELANBIDE11_SUBSOLIC, ConstantesMeLanbide11.FICHERO_PROPIEDADES), con);
            query = "INSERT INTO "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + "(ID,NUM_EXP,ESTADO,ORGANISMO,OBJETO,IMPORTE,FECHA) " + " VALUES (" + id + ", '"
                    + nuevaMinimis.getNumExp() + "', '" + nuevaMinimis.getEstado() + "', '"
                    + nuevaMinimis.getOrganismo() + "', '" + nuevaMinimis.getObjeto() + "', "
                    + nuevaMinimis.getImporte() + " , TO_DATE('" + fechaSub + "','dd/mm/yyyy')" + ")";
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
            // opeCorrecta = false;
            log.debug("Se ha producido un error al insertar una nueva Minimis" + ex.getMessage());
            throw new Exception(ex);
            // return opeCorrecta;
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
        if (datModif != null && datModif.getFecha() != null && !datModif.getFecha().toString().equals("")) {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            fechaSub = formatoFecha.format(datModif.getFecha());
        }

        try {
            query = "UPDATE "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_SUBSOLIC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " SET ESTADO='" + datModif.getEstado() + "'" + ", ORGANISMO='" + datModif.getOrganismo() + "'"
                    + ", OBJETO='" + datModif.getObjeto() + "'" + ", IMPORTE=" + datModif.getImporte()
                    + ", FECHA=TO_DATE('" + fechaSub + "','dd/mm/yyyy')" + " WHERE ID=" + datModif.getId();
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
            log.debug("Se ha producido un error al modificar una Minimis - " + datModif.getId() + " - " + ex);
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

    public List<DesgloseRSBVO> getDatosDesgloseRSB(String numExp, int codOrganizacion, Connection con)
            throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        DesgloseRSBVO det = new DesgloseRSBVO();
        try {
            String query = null;
            query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE NUM_EXP ='" + numExp + "'" + " ORDER BY ID";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                det = (DesgloseRSBVO) MeLanbide11MappingUtils.getInstance().mapRSB(rs, DesgloseRSBVO.class);
                lista.add(det);
                det = new DesgloseRSBVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Desglose RSB ", ex);
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

    /**
     * Recupera las líneas de desglose RSB filtradas por expediente y DNI del
     * contratado. Si no existen resultados devuelve lista vacía.
     */
    public List<DesgloseRSBVO> getDatosDesgloseRSBPorDni(String numExp, String dni, int codOrganizacion, Connection con)
            throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        DesgloseRSBVO det = new DesgloseRSBVO();
        if (dni == null || dni.trim().isEmpty()) {
            return lista; // nada que buscar
        }
        try {
            String query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE NUM_EXP ='" + numExp + "' AND DNICONTRSB='" + dni.replace("'", "''") + "' ORDER BY ID";
            if (log.isDebugEnabled()) {
                log.debug("sql (por DNI) = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                det = (DesgloseRSBVO) MeLanbide11MappingUtils.getInstance().mapRSB(rs, DesgloseRSBVO.class);
                lista.add(det);
                det = new DesgloseRSBVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Desglose RSB por DNI ", ex);
            throw new Exception(ex);
        } finally {
            if (log.isDebugEnabled()) {
                log.debug("Procedemos a cerrar el statement y el resultset (por DNI)");
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

    public List<DesgloseRSBVO> getDesgloseRSB(String numExp, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        DesgloseRSBVO det = new DesgloseRSBVO();
        try {
            String query = null;
            query = "Select * From "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " A " + "Where A.Num_Exp= '" + numExp + "' Order By A.Id";
            if (log.isDebugEnabled()) {
                log.debug("sql getDesgloseRSB= " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                det = (DesgloseRSBVO) MeLanbide11MappingUtils.getInstance().mapRSB(rs, DesgloseRSBVO.class);
                lista.add(det);
                det = new DesgloseRSBVO();
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando Desglose RSB ", ex);
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

    public DesgloseRSBVO getDesgloseRSBPorID(String id, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        DesgloseRSBVO det = new DesgloseRSBVO();
        try {
            String query = null;
            query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE ID=" + (id != null && !id.equals("") ? id : "null");
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                det = (DesgloseRSBVO) MeLanbide11MappingUtils.getInstance().mapRSB(rs, DesgloseRSBVO.class);
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando un Desglose RSB : " + id, ex);
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
        return det;
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
            log.error("Se ha producido un error recuperando el numero de ID para insercion al llamar la secuencia "
                    + sequence + " : ", ex);
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

    /**
     * Actualiza los campos basicos del RSB en la tabla de contratacion y recalcula
     * RSBCOMPCONV = NVL(RSBSALBASE,0)+NVL(RSBPAGEXTRA,0)+NVL(RSBCOMPIMPORT,0). Se
     * usa para persistir los valores de la pestaña 1 (salario base, pagas extra y
     * complementos salariales calculados en pantalla). No altera otros campos.
     *
     * @param idRegistro     ID de la contratacion
     * @param salarioBase    salario base (nullable)
     * @param pagasExtra     pagas extraordinarias (nullable)
     * @param compSalariales complementos salariales (nullable)
     * @return true si se actualizó alguna fila
     */
    public boolean actualizarDesgloseBasico(String idRegistro, Double salarioBase, Double pagasExtra,
            Double compSalariales, Connection con) throws Exception {
        if (idRegistro == null || idRegistro.trim().length() == 0) {
            return false;
        }
        PreparedStatement ps = null;
        try {
            String tablaContr = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            String sql = "UPDATE " + tablaContr + " SET RSBSALBASE=?, RSBPAGEXTRA=?, RSBCOMPCONV=? WHERE ID=?";
            double total = (salarioBase == null ? 0d : salarioBase) + (pagasExtra == null ? 0d : pagasExtra)
                    + (compSalariales == null ? 0d : compSalariales);
            ps = con.prepareStatement(sql);
            if (salarioBase != null)
                ps.setDouble(1, salarioBase);
            else
                ps.setNull(1, Types.DOUBLE);
            if (pagasExtra != null)
                ps.setDouble(2, pagasExtra);
            else
                ps.setNull(2, Types.DOUBLE);
            ps.setDouble(3, total);
            ps.setInt(4, Integer.parseInt(idRegistro));
            int res = ps.executeUpdate();
            if (log.isDebugEnabled()) {
                log.debug("*** actualizarDesgloseBasico (PS) *** ID=" + idRegistro + " total=" + total);
            }
            return res > 0;
        } catch (Exception e) {
            log.error("Error en actualizarDesgloseBasico ID=" + idRegistro, e);
            throw new Exception(e);
        } finally {
            if (ps != null)
                ps.close();
        }
    }

    /** Nueva versión con RSBTIPO y RSBIMPORTE */
    public boolean actualizarDesgloseBasico(String idRegistro, Double salarioBase, Double pagasExtra,
            Double compImporte, String rsbTipo, Connection con) throws Exception {
        if (idRegistro == null || idRegistro.trim().length() == 0) {
            return false;
        }
        PreparedStatement ps = null;
        try {
            String tablaContr = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_CONTRATACION,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            String sql = "UPDATE " + tablaContr
                    + " SET RSBSALBASE=?, RSBPAGEXTRA=?, RSBIMPORTE=?, RSBTIPO=?, RSBCOMPCONV=? WHERE ID=?";
            double total = (salarioBase == null ? 0d : salarioBase) + (pagasExtra == null ? 0d : pagasExtra)
                    + (compImporte == null ? 0d : compImporte);
            ps = con.prepareStatement(sql);
            if (salarioBase != null)
                ps.setDouble(1, salarioBase);
            else
                ps.setNull(1, Types.DOUBLE);
            if (pagasExtra != null)
                ps.setDouble(2, pagasExtra);
            else
                ps.setNull(2, Types.DOUBLE);
            if (compImporte != null)
                ps.setDouble(3, compImporte);
            else
                ps.setNull(3, Types.DOUBLE);
            if (rsbTipo != null && rsbTipo.trim().length() > 0)
                ps.setString(4, rsbTipo);
            else
                ps.setNull(4, Types.VARCHAR);
            ps.setDouble(5, total);
            ps.setInt(6, Integer.parseInt(idRegistro));
            int res = ps.executeUpdate();
            if (log.isDebugEnabled()) {
                log.debug("*** actualizarDesgloseBasico (PS+TIPO) *** ID=" + idRegistro + " total=" + total + " tipo="
                        + rsbTipo);
            }
            return res > 0;
        } catch (Exception e) {
            log.error("Error en actualizarDesgloseBasico (TIPO) ID=" + idRegistro, e);
            throw new Exception(e);
        } finally {
            if (ps != null)
                ps.close();
        }
    }

    public List<DesplegableAdmonLocalVO> getValoresDesplegablesAdmonLocalxdes_cod(String des_cod, Connection con)
            throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesplegableAdmonLocalVO> lista = new ArrayList<DesplegableAdmonLocalVO>();
        DesplegableAdmonLocalVO valoresDesplegable = new DesplegableAdmonLocalVO();
        try {
            String query = null;
            query = "SELECT * FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.TABLA_VALORES_DESPLEGABLES,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE DES_COD='" + des_cod + "' order by DES_NOM";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                valoresDesplegable = (DesplegableAdmonLocalVO) MeLanbide11MappingUtils.getInstance().map(rs,
                        DesplegableAdmonLocalVO.class);
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
            query = "SELECT CODIGO,TABLA,CAMPO_CODIGO,CAMPO_VALOR FROM "
                    + ConfigurationParameter.getParameter(ConstantesMeLanbide11.TABLA_CODIGOS_DESPLEGABLES_EXTERNOS,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES)
                    + " WHERE CODIGO='" + (codDes != null && !codDes.equals("") ? codDes : "null") + "'";
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                datosMapeoDesplegableExterno = (DatosTablaDesplegableExtVO) MeLanbide11MappingUtils.getInstance()
                        .map(rs, DatosTablaDesplegableExtVO.class);
            }
        } catch (Exception ex) {
            log.error("Se ha producido un error recuperando datos para mapeo de desplegable externo de codigo : "
                    + codDes, ex);
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

    public List<DesplegableExternoVO> getValoresDesplegablesExternos(String tablaDesplegable, String campoCodigo,
            String campoValor, Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        List<DesplegableExternoVO> lista = new ArrayList<DesplegableExternoVO>();
        DesplegableExternoVO valoresDesplegable = new DesplegableExternoVO();
        try {
            String query = null;
            query = "SELECT " + campoCodigo + ", " + campoValor + " FROM " + tablaDesplegable + " order by "
                    + campoValor;
            if (log.isDebugEnabled()) {
                log.debug("sql = " + query);
            }
            st = con.createStatement();
            rs = st.executeQuery(query);
            while (rs.next()) {
                valoresDesplegable = (DesplegableExternoVO) MeLanbide11MappingUtils.getInstance().map3(rs, campoCodigo,
                        campoValor);
                lista.add(valoresDesplegable);
                valoresDesplegable = new DesplegableExternoVO();
            }
        } catch (Exception ex) {
            log.error(
                    "Se ha producido un error recuperando valores de desplegable externo de tabla: " + tablaDesplegable,
                    ex);
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

    /**
     * Obtiene la suma de complementos salariales de la tabla MELANBIDE11_DESGRSB
     * para un DNI específico en un expediente
     * 
     * @param numExp Número de expediente
     * @param dni    DNI del contratado
     * @param con    Conexión a base de datos
     * @return Suma total de complementos salariales
     * @throws Exception
     */
    public Double getSumaComplementosSalariales(String numExp, String dni, Connection con) throws Exception {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            String tabla = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);

            String sql = "SELECT NVL(SUM(NVL(RSBIMPORTE,0)),0) " + "FROM " + tabla + " "
                    + "WHERE TRIM(NUM_EXP)=TRIM(?) "
                    + "  AND UPPER(REPLACE(REPLACE(TRIM(DNICONTRSB),' ',''),'-','')) = "
                    + "      UPPER(REPLACE(REPLACE(TRIM(?),' ',''),'-',''))";

            ps = con.prepareStatement(sql);
            ps.setString(1, numExp);
            ps.setString(2, dni);
            rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
        }
    }

    /**
     * Obtiene las sumas de complementos salariales y extrasalariales por separado
     * basándose en el campo RSBTIPO de la tabla MELANBIDE11_DESGRSB
     * 
     * @param numExp Número de expediente
     * @param dni    DNI del contratado
     * @param con    Conexión a la base de datos
     * @return ComplementosPorTipo con las sumas separadas
     * @throws Exception
     */
    public ComplementosPorTipo getSumaComplementosPorTipo(String numExp, String dni, Connection con) throws Exception {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            String tabla = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);

            String sql = "SELECT "
                    + "  NVL(SUM(CASE WHEN RSBTIPO = '1' THEN NVL(RSBIMPORTE,0) ELSE 0 END),0) AS SALARIALES, "
                    + "  NVL(SUM(CASE WHEN RSBTIPO = '2' THEN NVL(RSBIMPORTE,0) ELSE 0 END),0) AS EXTRASALARIALES "
                    + "FROM " + tabla + " " + "WHERE TRIM(NUM_EXP)=TRIM(?) "
                    + "  AND UPPER(REPLACE(REPLACE(TRIM(DNICONTRSB),' ',''),'-','')) = "
                    + "      UPPER(REPLACE(REPLACE(TRIM(?),' ',''),'-',''))";

            ps = con.prepareStatement(sql);
            ps.setString(1, numExp);
            ps.setString(2, dni);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new ComplementosPorTipo(rs.getDouble("SALARIALES"), rs.getDouble("EXTRASALARIALES"));
            } else {
                return new ComplementosPorTipo(0.0, 0.0);
            }
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
        }
    }

    /**
     * Clase auxiliar para devolver los complementos separados por tipo
     */
    public static class ComplementosPorTipo {
        private double salariales;
        private double extrasalariales;

        public ComplementosPorTipo(double salariales, double extrasalariales) {
            this.salariales = salariales;
            this.extrasalariales = extrasalariales;
        }

        public double getSalariales() {
            return salariales;
        }

        public double getExtrasalariales() {
            return extrasalariales;
        }
    }

    /**
     * Actualiza automáticamente el campo RSBCOMPCONV calculando la suma de:
     * RSBSALBASE + RSBPAGEXTRA + suma de RSBIMPORTE de MELANBIDE11_DESGRSB Solo
     * actualiza si el cálculo es diferente al valor actual
     */
    public boolean actualizarRsbCompConv(String numExp, String dni, Connection con) throws Exception {
        Statement st = null;
        int filasActualizadas = 0;

        if (log.isDebugEnabled()) {
            log.debug("*** INICIO ACTUALIZACION AUTOMATICA RSBCOMPCONV ***");
            log.debug("NumExp: " + numExp + ", DNI: " + dni);
        }

        try {
            st = con.createStatement();

            String tablaContratacion = ConfigurationParameter.getParameter(
                    ConstantesMeLanbide11.MELANBIDE11_CONTRATACION, ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            String tablaDesgRsb = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);

            // Consulta que actualiza RSBCOMPCONV con la suma calculada
            String updateQuery = "UPDATE " + tablaContratacion + " c " + "SET RSBCOMPCONV = " + "  NVL(c.RSBSALBASE,0) "
                    + "  + NVL(c.RSBPAGEXTRA,0) " + "  + NVL((" + "    SELECT SUM(NVL(d.RSBIMPORTE,0)) " + "    FROM "
                    + tablaDesgRsb + " d " + "    WHERE TRIM(d.NUM_EXP)=TRIM(c.NUM_EXP) "
                    + "      AND UPPER(REPLACE(REPLACE(TRIM(d.DNICONTRSB),' ',''),'-','')) "
                    + "          = UPPER(REPLACE(REPLACE(TRIM(c.DNICONT),' ',''),'-','')) " + "  ),0) "
                    + "WHERE TRIM(c.NUM_EXP)=TRIM('" + numExp + "') "
                    + "  AND UPPER(REPLACE(REPLACE(TRIM(c.DNICONT),' ',''),'-','')) "
                    + "      = UPPER(REPLACE(REPLACE(TRIM('" + dni + "'),' ',''),'-','')) " + "  AND ("
                    + "    NVL(c.RSBSALBASE,0) + NVL(c.RSBPAGEXTRA,0) " + "    + NVL(("
                    + "      SELECT SUM(NVL(d.RSBIMPORTE,0)) " + "      FROM " + tablaDesgRsb + " d "
                    + "      WHERE TRIM(d.NUM_EXP)=TRIM(c.NUM_EXP) "
                    + "        AND UPPER(REPLACE(REPLACE(TRIM(d.DNICONTRSB),' ',''),'-','')) "
                    + "            = UPPER(REPLACE(REPLACE(TRIM(c.DNICONT),' ',''),'-','')) " + "    ),0)"
                    + "  ) <> NVL(c.RSBCOMPCONV,0)";

            if (log.isDebugEnabled()) {
                log.debug("*** QUERY ACTUALIZACION RSBCOMPCONV ***");
                log.debug(updateQuery);
            }

            filasActualizadas = st.executeUpdate(updateQuery);

            if (log.isDebugEnabled()) {
                log.debug("*** RESULTADO ACTUALIZACION ***");
                log.debug("Filas actualizadas: " + filasActualizadas);
                log.debug("*** FIN ACTUALIZACION AUTOMATICA RSBCOMPCONV ***");
            }

        } catch (Exception ex) {
            log.error("Error al actualizar RSBCOMPCONV automáticamente", ex);
            throw new Exception(ex);
        } finally {
            if (st != null) {
                st.close();
            }
        }

        return filasActualizadas > 0;
    }

    /**
     * Obtiene el siguiente ID para la tabla DESGRSB mediante MAX(ID)+1. (Se evita
     * depender de una secuencia que no está definida en constantes).
     */
    private int getNextIdDesglose(Connection con) throws Exception {
        Statement st = null;
        ResultSet rs = null;
        try {
            String tabla = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            st = con.createStatement();
            rs = st.executeQuery("SELECT NVL(MAX(ID),0)+1 AS NEXTID FROM " + tabla);
            if (rs.next()) {
                return rs.getInt("NEXTID");
            }
            return 1;
        } catch (Exception e) {
            log.error("Error calculando siguiente ID desglose", e);
            throw new Exception(e);
        } finally {
            if (rs != null)
                rs.close();
            if (st != null)
                st.close();
        }
    }

    /**
     * Reemplaza (borrando e insertando) las líneas de desglose RSB para un
     * expediente + DNI. Después recalcula RSBCOMPCONV en la tabla principal.
     *
     * @param numExp Número de expediente
     * @param dni    DNI contratado
     * @param lineas Lista de líneas (puede ser vacía o null -&gt; implica borrar
     *               todo)
     * @param con    Conexión
     * @return true si la operación global finaliza sin errores
     * @throws Exception
     */
    public boolean reemplazarDesgloseRSB(String numExp, String dni, List<DesgloseRSBVO> lineas, Connection con)
            throws Exception {
        if (numExp == null || numExp.trim().isEmpty() || dni == null || dni.trim().isEmpty()) {
            return false;
        }
        PreparedStatement psDelete = null;
        PreparedStatement psInsert = null;
        try {
            String tabla = ConfigurationParameter.getParameter(ConstantesMeLanbide11.MELANBIDE11_DESGRSB,
                    ConstantesMeLanbide11.FICHERO_PROPIEDADES);
            String deleteSql = "DELETE FROM " + tabla
                    + " WHERE TRIM(NUM_EXP)=TRIM(?) AND UPPER(REPLACE(REPLACE(TRIM(DNICONTRSB),' ',''),'-','')) = UPPER(REPLACE(REPLACE(TRIM(?),' ',''),'-',''))";
            psDelete = con.prepareStatement(deleteSql);
            psDelete.setString(1, numExp);
            psDelete.setString(2, dni);
            psDelete.executeUpdate();

            if (lineas != null && !lineas.isEmpty()) {
                String insertSql = "INSERT INTO " + tabla
                        + " (ID, NUM_EXP, DNICONTRSB, RSBTIPO, RSBIMPORTE, RSBCONCEPTO, RSBOBSERV) VALUES (?,?,?,?,?,?,?)";
                psInsert = con.prepareStatement(insertSql);
                for (DesgloseRSBVO vo : lineas) {
                    int nextId = getNextIdDesglose(con);
                    psInsert.setInt(1, nextId);
                    psInsert.setString(2, numExp);
                    psInsert.setString(3, dni);
                    if (vo.getRsbTipo() != null)
                        psInsert.setString(4, vo.getRsbTipo());
                    else
                        psInsert.setNull(4, Types.VARCHAR);
                    if (vo.getRsbImporte() != null)
                        psInsert.setDouble(5, vo.getRsbImporte());
                    else
                        psInsert.setNull(5, Types.DOUBLE);
                    if (vo.getRsbConcepto() != null)
                        psInsert.setString(6, vo.getRsbConcepto());
                    else
                        psInsert.setNull(6, Types.VARCHAR);
                    if (vo.getRsbObserv() != null)
                        psInsert.setString(7, vo.getRsbObserv());
                    else
                        psInsert.setNull(7, Types.VARCHAR);
                    psInsert.executeUpdate();
                }
            }
            actualizarRsbCompConv(numExp, dni, con);
            return true;
        } catch (Exception e) {
            log.error("Error reemplazando desglose RSB numExp=" + numExp + ", dni=" + dni, e);
            throw new Exception(e);
        } finally {
            if (psInsert != null)
                psInsert.close();
            if (psDelete != null)
                psDelete.close();
        }
    }

    /**
     * Obtiene todas las contrataciones de un expediente específico.
     */
    public List<ContratacionVO> getContratacionesByExpediente(String numExpediente, Connection con) throws Exception {
        log.debug("getContratacionesByExpediente - numExp: " + numExpediente);

        List<ContratacionVO> contrataciones = new ArrayList<ContratacionVO>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT ID, EXPEDIENTE, OFERTA, ID_CONTRATO_1, ID_CONTRATO_2, DNI, NOMBRE, APELLIDO_1, APELLIDO_2, "
                    + "FECHA_NACIMIENTO, EDAD, SEXO, MAYOR_55, FIN_FORMATIVA, COD_FORMATIVA, DEN_FORMATIVA, PUESTO, "
                    + "OCUPACION, DES_OCUPACION_LIBRE, DES_TITULACION_LIBRE, TITULACION, C_PROFESIONALIDAD, "
                    + "MODALIDAD_CONTRATO, JORNADA, PORC_JORNADA, HORAS_CONV, FECHA_INICIO, FECHA_FIN, MESES_CONTRATO, "
                    + "GRUPO_COTIZACION, DIRECCION_CT, NUM_SS, COSTE_CONTRATO, TIP_RETRIBUCION, RSB_SAL_BASE, "
                    + "RSB_PAG_EXTRA, RSB_IMPORTE, RSB_COMP_CONV, IMPORTE_SUB, TIT_REQ_PUESTO, FUNCIONES "
                    + "FROM MELANBIDE11_CONTRATACION " + "WHERE EXPEDIENTE = ? " + "ORDER BY ID";

            ps = con.prepareStatement(sql);
            ps.setString(1, numExpediente);
            rs = ps.executeQuery();

            while (rs.next()) {
                ContratacionVO contratacion = new ContratacionVO();
                contratacion.setId(Integer.valueOf((int) rs.getLong("ID")));
                contratacion.setNumExp(rs.getString("EXPEDIENTE"));
                contratacion.setOferta(rs.getString("OFERTA"));
                contratacion.setIdContrato1(rs.getString("ID_CONTRATO_1"));
                contratacion.setIdContrato2(rs.getString("ID_CONTRATO_2"));
                contratacion.setDni(rs.getString("DNI"));
                contratacion.setNombre(rs.getString("NOMBRE"));
                contratacion.setApellido1(rs.getString("APELLIDO_1"));
                contratacion.setApellido2(rs.getString("APELLIDO_2"));
                contratacion.setFechaNacimiento(rs.getDate("FECHA_NACIMIENTO"));

                // Conversión segura de edad String a Integer
                String edadStr = rs.getString("EDAD");
                if (edadStr != null && !edadStr.trim().isEmpty()) {
                    try {
                        contratacion.setEdad(Integer.parseInt(edadStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setEdad(null);
                    }
                } else {
                    contratacion.setEdad(null);
                }
                contratacion.setSexo(rs.getString("SEXO"));
                contratacion.setMayor55(rs.getString("MAYOR_55"));
                contratacion.setFinFormativa(rs.getString("FIN_FORMATIVA"));
                contratacion.setCodFormativa(rs.getString("COD_FORMATIVA"));
                contratacion.setDenFormativa(rs.getString("DEN_FORMATIVA"));
                contratacion.setPuesto(rs.getString("PUESTO"));
                contratacion.setOcupacion(rs.getString("OCUPACION"));
                contratacion.setDesOcupacionLibre(rs.getString("DES_OCUPACION_LIBRE"));
                contratacion.setDesTitulacionLibre(rs.getString("DES_TITULACION_LIBRE"));
                contratacion.setTitulacion(rs.getString("TITULACION"));
                contratacion.setcProfesionalidad(rs.getString("C_PROFESIONALIDAD"));
                contratacion.setModalidadContrato(rs.getString("MODALIDAD_CONTRATO"));
                contratacion.setJornada(rs.getString("JORNADA"));
                // Conversión segura de PORC_JORNADA String a Double
                String porcJornadaStr = rs.getString("PORC_JORNADA");
                if (porcJornadaStr != null && !porcJornadaStr.trim().isEmpty()) {
                    try {
                        contratacion.setPorcJornada(Double.parseDouble(porcJornadaStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setPorcJornada(null);
                    }
                } else {
                    contratacion.setPorcJornada(null);
                }
                // Conversión segura de HORAS_CONV String a Integer
                String horasConvStr = rs.getString("HORAS_CONV");
                if (horasConvStr != null && !horasConvStr.trim().isEmpty()) {
                    try {
                        contratacion.setHorasConv(Integer.parseInt(horasConvStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setHorasConv(null);
                    }
                } else {
                    contratacion.setHorasConv(null);
                }
                contratacion.setFechaInicio(rs.getDate("FECHA_INICIO"));
                contratacion.setFechaFin(rs.getDate("FECHA_FIN"));
                contratacion.setMesesContrato(rs.getString("MESES_CONTRATO"));
                contratacion.setGrupoCotizacion(rs.getString("GRUPO_COTIZACION"));
                contratacion.setDireccionCT(rs.getString("DIRECCION_CT"));
                contratacion.setNumSS(rs.getString("NUM_SS"));
                // Conversión segura de COSTE_CONTRATO String a Double
                String costeContratoStr = rs.getString("COSTE_CONTRATO");
                if (costeContratoStr != null && !costeContratoStr.trim().isEmpty()) {
                    try {
                        contratacion.setCosteContrato(Double.parseDouble(costeContratoStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setCosteContrato(null);
                    }
                } else {
                    contratacion.setCosteContrato(null);
                }
                contratacion.setTipRetribucion(rs.getString("TIP_RETRIBUCION"));

                // Campos RSB (pueden ser null)
                Double rsbSalBase = rs.getDouble("RSB_SAL_BASE");
                if (!rs.wasNull())
                    contratacion.setRsbSalBase(rsbSalBase);

                Double rsbPagExtra = rs.getDouble("RSB_PAG_EXTRA");
                if (!rs.wasNull())
                    contratacion.setRsbPagExtra(rsbPagExtra);

                Double rsbImporte = rs.getDouble("RSB_IMPORTE");
                if (!rs.wasNull())
                    contratacion.setRsbImporte(rsbImporte);

                Double rsbCompConv = rs.getDouble("RSB_COMP_CONV");
                if (!rs.wasNull())
                    contratacion.setRsbCompConv(rsbCompConv);

                Double importeSub = rs.getDouble("IMPORTE_SUB");
                if (!rs.wasNull())
                    contratacion.setImporteSub(importeSub);

                contratacion.setTitReqPuesto(rs.getString("TIT_REQ_PUESTO"));
                contratacion.setFunciones(rs.getString("FUNCIONES"));

                contrataciones.add(contratacion);
            }

            log.debug("getContratacionesByExpediente - Encontradas " + contrataciones.size() + " contrataciones");

        } catch (SQLException e) {
            log.error("Error SQL en getContratacionesByExpediente", e);
            throw new Exception(e);
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
        }

        return contrataciones;
    }

    /**
     * Obtiene una contratación específica por su ID.
     */
    public ContratacionVO getContratacionById(String id, Connection con) throws Exception {
        log.debug("getContratacionById - id: " + id);

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT ID, EXPEDIENTE, OFERTA, ID_CONTRATO_1, ID_CONTRATO_2, DNI, NOMBRE, APELLIDO_1, APELLIDO_2, "
                    + "FECHA_NACIMIENTO, EDAD, SEXO, MAYOR_55, FIN_FORMATIVA, COD_FORMATIVA, DEN_FORMATIVA, PUESTO, "
                    + "OCUPACION, DES_OCUPACION_LIBRE, DES_TITULACION_LIBRE, TITULACION, C_PROFESIONALIDAD, "
                    + "MODALIDAD_CONTRATO, JORNADA, PORC_JORNADA, HORAS_CONV, FECHA_INICIO, FECHA_FIN, MESES_CONTRATO, "
                    + "GRUPO_COTIZACION, DIRECCION_CT, NUM_SS, COSTE_CONTRATO, TIP_RETRIBUCION, RSB_SAL_BASE, "
                    + "RSB_PAG_EXTRA, RSB_IMPORTE, RSB_COMP_CONV, IMPORTE_SUB, TIT_REQ_PUESTO, FUNCIONES "
                    + "FROM MELANBIDE11_CONTRATACION " + "WHERE ID = ?";

            ps = con.prepareStatement(sql);
            ps.setLong(1, Long.parseLong(id));
            rs = ps.executeQuery();

            if (rs.next()) {
                ContratacionVO contratacion = new ContratacionVO();
                contratacion.setId(Integer.valueOf((int) rs.getLong("ID")));
                contratacion.setNumExp(rs.getString("EXPEDIENTE"));
                contratacion.setOferta(rs.getString("OFERTA"));
                contratacion.setIdContrato1(rs.getString("ID_CONTRATO_1"));
                contratacion.setIdContrato2(rs.getString("ID_CONTRATO_2"));
                contratacion.setDni(rs.getString("DNI"));
                contratacion.setNombre(rs.getString("NOMBRE"));
                contratacion.setApellido1(rs.getString("APELLIDO_1"));
                contratacion.setApellido2(rs.getString("APELLIDO_2"));
                contratacion.setFechaNacimiento(rs.getDate("FECHA_NACIMIENTO"));

                // Conversión segura de edad String a Integer (método getContratacionById)
                String edadStr2 = rs.getString("EDAD");
                if (edadStr2 != null && !edadStr2.trim().isEmpty()) {
                    try {
                        contratacion.setEdad(Integer.parseInt(edadStr2.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setEdad(null);
                    }
                } else {
                    contratacion.setEdad(null);
                }
                contratacion.setSexo(rs.getString("SEXO"));
                contratacion.setMayor55(rs.getString("MAYOR_55"));
                contratacion.setFinFormativa(rs.getString("FIN_FORMATIVA"));
                contratacion.setCodFormativa(rs.getString("COD_FORMATIVA"));
                contratacion.setDenFormativa(rs.getString("DEN_FORMATIVA"));
                contratacion.setPuesto(rs.getString("PUESTO"));
                contratacion.setOcupacion(rs.getString("OCUPACION"));
                contratacion.setDesOcupacionLibre(rs.getString("DES_OCUPACION_LIBRE"));
                contratacion.setDesTitulacionLibre(rs.getString("DES_TITULACION_LIBRE"));
                contratacion.setTitulacion(rs.getString("TITULACION"));
                contratacion.setcProfesionalidad(rs.getString("C_PROFESIONALIDAD"));
                contratacion.setModalidadContrato(rs.getString("MODALIDAD_CONTRATO"));
                contratacion.setJornada(rs.getString("JORNADA"));
                // Conversión segura de PORC_JORNADA String a Double
                String porcJornadaStr = rs.getString("PORC_JORNADA");
                if (porcJornadaStr != null && !porcJornadaStr.trim().isEmpty()) {
                    try {
                        contratacion.setPorcJornada(Double.parseDouble(porcJornadaStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setPorcJornada(null);
                    }
                } else {
                    contratacion.setPorcJornada(null);
                }
                // Conversión segura de HORAS_CONV String a Integer
                String horasConvStr = rs.getString("HORAS_CONV");
                if (horasConvStr != null && !horasConvStr.trim().isEmpty()) {
                    try {
                        contratacion.setHorasConv(Integer.parseInt(horasConvStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setHorasConv(null);
                    }
                } else {
                    contratacion.setHorasConv(null);
                }
                contratacion.setFechaInicio(rs.getDate("FECHA_INICIO"));
                contratacion.setFechaFin(rs.getDate("FECHA_FIN"));
                contratacion.setMesesContrato(rs.getString("MESES_CONTRATO"));
                contratacion.setGrupoCotizacion(rs.getString("GRUPO_COTIZACION"));
                contratacion.setDireccionCT(rs.getString("DIRECCION_CT"));
                contratacion.setNumSS(rs.getString("NUM_SS"));
                // Conversión segura de COSTE_CONTRATO String a Double
                String costeContratoStr = rs.getString("COSTE_CONTRATO");
                if (costeContratoStr != null && !costeContratoStr.trim().isEmpty()) {
                    try {
                        contratacion.setCosteContrato(Double.parseDouble(costeContratoStr.trim()));
                    } catch (NumberFormatException e) {
                        contratacion.setCosteContrato(null);
                    }
                } else {
                    contratacion.setCosteContrato(null);
                }
                contratacion.setTipRetribucion(rs.getString("TIP_RETRIBUCION"));

                // Campos RSB (pueden ser null)
                Double rsbSalBase = rs.getDouble("RSB_SAL_BASE");
                if (!rs.wasNull())
                    contratacion.setRsbSalBase(rsbSalBase);

                Double rsbPagExtra = rs.getDouble("RSB_PAG_EXTRA");
                if (!rs.wasNull())
                    contratacion.setRsbPagExtra(rsbPagExtra);

                Double rsbImporte = rs.getDouble("RSB_IMPORTE");
                if (!rs.wasNull())
                    contratacion.setRsbImporte(rsbImporte);

                Double rsbCompConv = rs.getDouble("RSB_COMP_CONV");
                if (!rs.wasNull())
                    contratacion.setRsbCompConv(rsbCompConv);

                Double importeSub = rs.getDouble("IMPORTE_SUB");
                if (!rs.wasNull())
                    contratacion.setImporteSub(importeSub);

                contratacion.setTitReqPuesto(rs.getString("TIT_REQ_PUESTO"));
                contratacion.setFunciones(rs.getString("FUNCIONES"));

                log.debug("getContratacionById - Contratación encontrada");
                return contratacion;
            } else {
                log.debug("getContratacionById - Contratación no encontrada");
                return null;
            }

        } catch (SQLException e) {
            log.error("Error SQL en getContratacionById", e);
            throw new Exception(e);
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
        }
    }

    /**
     * Elimina una contratación por ID
     * 
     * @param id  ID de la contratación
     * @param con Conexión a la base de datos
     * @return true si se eliminó correctamente
     * @throws Exception
     */
    public boolean eliminarContratacionAJAX(String id, Connection con) throws Exception {
        log.debug("eliminarContratacionAJAX - id: " + id);

        PreparedStatement ps = null;
        try {
            String sql = "DELETE FROM MELANBIDE11_CONTRATACION WHERE ID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, id);

            int rowsAffected = ps.executeUpdate();
            boolean deleted = rowsAffected > 0;

            if (deleted) {
                log.debug("eliminarContratacionAJAX - Contratación eliminada: " + id);
            } else {
                log.debug("eliminarContratacionAJAX - No se encontró contratación con ID: " + id);
            }

            return deleted;
        } catch (SQLException e) {
            log.error("Error SQL en eliminarContratacionAJAX", e);
            throw new Exception("Error al eliminar contratación: " + e.getMessage());
        } finally {
            if (ps != null)
                ps.close();
        }
    }

}
