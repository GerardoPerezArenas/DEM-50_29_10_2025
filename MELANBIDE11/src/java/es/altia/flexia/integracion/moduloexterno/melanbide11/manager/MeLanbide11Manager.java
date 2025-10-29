package es.altia.flexia.integracion.moduloexterno.melanbide11.manager;

import com.google.gson.Gson;
import com.lanbide.lan6.errores.bean.ErrorBean;
import com.lanbide.lan6.registro.error.RegistroErrores;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.dao.MeLanbide11DAO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.dao.MeLanbide11DAO.ComplementosPorTipo;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DatosTablaDesplegableExtVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableExternoVO;
import es.altia.util.conexion.AdaptadorSQLBD;
import es.altia.util.conexion.BDException;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesgloseRSBVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.SubvencionRefVO;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class MeLanbide11Manager {

    // Logger
    private static Logger log = Logger.getLogger(MeLanbide11Manager.class);
    private AdaptadorSQLBD adaptador;
    private MeLanbide11DAO melanbide11DAO;

    // ThreadLocal para mantener una instancia por hilo
    private static ThreadLocal<MeLanbide11Manager> threadLocalInstance = new ThreadLocal<MeLanbide11Manager>();

    public MeLanbide11Manager(AdaptadorSQLBD adaptador) {
        this.adaptador = adaptador;
        this.melanbide11DAO = MeLanbide11DAO.getInstance(adaptador);
    }

    /**
     * Método getInstance() para compatibilidad con código legacy. Retorna una
     * instancia vacía que debe ser configurada con setAdaptador() o usar los
     * métodos que reciben AdaptadorSQLBD como parámetro.
     */
    public static MeLanbide11Manager getInstance() {
        MeLanbide11Manager instance = threadLocalInstance.get();
        if (instance == null) {
            // Retornamos una instancia sin adaptador para compatibilidad
            // Los métodos que la usen deberán recibir el adaptador como parámetro
            instance = new MeLanbide11Manager(null);
            threadLocalInstance.set(instance);
        }
        return instance;
    }

    /**
     * Establece el adaptador para esta instancia
     */
    public void setAdaptador(AdaptadorSQLBD adaptador) {
        this.adaptador = adaptador;
        this.melanbide11DAO = MeLanbide11DAO.getInstance(adaptador);
    }

    public static void grabarError(ErrorBean error, String excepError, String traza, String numExp) {
        try {
            log.error("grabando el error");
            error.setMensajeExcepError(excepError);
            error.setTraza(excepError);
            error.setCausa(traza);
            log.error("causa: " + traza);
            log.error("numExp: " + numExp);
            if ("".equals(numExp)) {
                numExp = "0000/ERRMISGEST/000000";
            }

            String idProcedimiento = "DEM50";
            log.error("procedimiento: " + idProcedimiento);
            error.setIdProcedimiento(idProcedimiento);
            error.setIdClave("");
            error.setSistemaOrigen("REGEXLAN");
            error.setErrorLog("flexia_debug");
            error.setIdFlexia(numExp);
            log.error("Vamos a registrar el error");

            RegistroErrores.registroError(error);
        } catch (Exception ex) {
            log.error("Error al grabarError" + ex);
        }
    }

    public Map<String, Object> obtenerCuantiasSubvencion() throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.obtenerCuantiasSubvencion(con);
        } catch (Exception e) {
            log.error("Error obteniendo cuantías de subvención", e);
            throw e;
        } finally {
            if (con != null) {
                adaptador.devolverConexion(con);
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public Map<String, Object> obtenerCuantiasSubvencion(AdaptadorSQLBD adapt) throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return obtenerCuantiasSubvencion();
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return obtenerCuantiasSubvencion();
    }

    public List<ContratacionVO> getDatosContratacion(String numExp, int codOrganizacion) throws Exception {
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        Connection con = null;
        try {
            con = adaptador.getConnection();
            lista = melanbide11DAO.getDatosContratacion(numExp, codOrganizacion, con);
            // recuperamos los cod y desc de desplegables para traducir en la tabla
            // principal
            List<DesplegableAdmonLocalVO> listaSexo = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_SEXO,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaMayor55 = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaFinFormativa = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaJornada = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_JORN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaGrupoCotizacion = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_GCOT,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaTipRetribucion = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTRT,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaTitReqPuesto = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_TITREQPUESTO,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            // desplegables externos
            DatosTablaDesplegableExtVO datosTablaDesplegableOcupaciones = this.getDatosMapeoDesplegableExterno(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_OCIN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            String tablaOcupaciones = datosTablaDesplegableOcupaciones.getTabla();
            String campoCodigoOcupaciones = datosTablaDesplegableOcupaciones.getCampoCodigo();
            String campoValorOcupaciones = datosTablaDesplegableOcupaciones.getCampoValor();
            List<DesplegableExternoVO> listaOcupacion = this.getValoresDesplegablesExternos(tablaOcupaciones,
                    campoCodigoOcupaciones, campoValorOcupaciones);

            DatosTablaDesplegableExtVO datosTablaDesplegableTitulaciones = this.getDatosMapeoDesplegableExterno(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_TIIN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            String tablaTitulaciones = datosTablaDesplegableTitulaciones.getTabla();
            String campoCodigoTitulaciones = datosTablaDesplegableTitulaciones.getCampoCodigo();
            String campoValorTitulaciones = datosTablaDesplegableTitulaciones.getCampoValor();
            List<DesplegableExternoVO> listaTitulacion = this.getValoresDesplegablesExternos(tablaTitulaciones,
                    campoCodigoTitulaciones, campoValorTitulaciones);

            DatosTablaDesplegableExtVO datosTablaDesplegableCProfesionales = this.getDatosMapeoDesplegableExterno(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_CPIN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            String tablaCProfesionales = datosTablaDesplegableCProfesionales.getTabla();
            String campoCodigoCProfesionales = datosTablaDesplegableCProfesionales.getCampoCodigo();
            String campoValorCProfesionales = datosTablaDesplegableCProfesionales.getCampoValor();
            List<DesplegableExternoVO> listaCProfesionalidad = this.getValoresDesplegablesExternos(tablaCProfesionales,
                    campoCodigoCProfesionales, campoValorCProfesionales);

            for (ContratacionVO cont : lista) {
                for (DesplegableAdmonLocalVO valordesp : listaSexo) {
                    if (valordesp.getDes_val_cod().equals(cont.getSexo())) {
                        cont.setDesSexo(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaMayor55) {
                    if (valordesp.getDes_val_cod().equals(cont.getMayor55())) {
                        cont.setMayor55(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaFinFormativa) {
                    if (valordesp.getDes_val_cod().equals(cont.getFinFormativa())) {
                        cont.setFinFormativa(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaJornada) {
                    if (valordesp.getDes_val_cod().equals(cont.getJornada())) {
                        cont.setDesJornada(valordesp.getDes_nom());
                        break;
                    }
                }
                // Traducción de TitReqPuesto usando desplegable INTERNO (listaTitReqPuesto)
                for (DesplegableAdmonLocalVO valordesp : listaTitReqPuesto) {
                    if (valordesp.getDes_val_cod().equals(cont.getTitReqPuesto())) {
                        cont.setDesTitReqPuesto(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaGrupoCotizacion) {
                    if (valordesp.getDes_val_cod().equals(cont.getGrupoCotizacion())) {
                        cont.setDesGrupoCotizacion(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaTipRetribucion) {
                    if (valordesp.getDes_val_cod().equals(cont.getTipRetribucion())) {
                        cont.setDesTipRetribucion(valordesp.getDes_nom());
                        break;
                    }
                }

                // desplegables externos
                for (DesplegableExternoVO valordesp : listaOcupacion) {
                    if (valordesp.getCampoCodigo().equals(cont.getOcupacion())) {
                        cont.setDesOcupacion(valordesp.getCampoValor());
                        break;
                    }
                }
                // Inicializar desTitulacion con el código original como fallback
                if (cont.getTitulacion() != null && !"".equals(cont.getTitulacion().trim())) {
                    cont.setDesTitulacion(cont.getTitulacion()); // fallback al código
                }
                // Intentar traducir con el desplegable externo
                for (DesplegableExternoVO valordesp : listaTitulacion) {
                    if (valordesp.getCampoCodigo().equals(cont.getTitulacion())) {
                        cont.setDesTitulacion(valordesp.getCampoValor());
                        break;
                    }
                }
                for (DesplegableExternoVO valordesp : listaCProfesionalidad) {
                    if (valordesp.getCampoCodigo().equals(cont.getcProfesionalidad())) {
                        cont.setDesCProfesionalidad(valordesp.getCampoValor());
                        break;
                    }
                }
            }

            return lista;
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos sobre las contrataciones ", e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos sobre las contrataciones ", ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public List<ContratacionVO> getDatosContratacion(String numExp, int codOrganizacion, AdaptadorSQLBD adapt)
            throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getDatosContratacion(numExp, codOrganizacion);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getDatosContratacion(numExp, codOrganizacion);
    }

    public ContratacionVO getContratacionPorID(String id) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getContratacionPorID(id, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepcion en la BBDD recuperando datos sobre una contratación:  " + id, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepcion en la BBDD recuperando datos sobre una contratación:  " + id, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexion a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public ContratacionVO getContratacionPorID(String id, AdaptadorSQLBD adapt) throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getContratacionPorID(id);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getContratacionPorID(id);
    }

    public int eliminarContratacion(String id) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.eliminarContratacion(id, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD al eliminar una contratación:  " + id, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD al eliminar una contratación:   " + id, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    public List<ContratacionVO> getContrataciones(String numExp) throws Exception {
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        Connection con = null;
        try {
            con = adaptador.getConnection();
            lista = melanbide11DAO.getContratacion(numExp, con);

            // recuperamos los cod y desc de desplegables para traducir en la tabla
            // principal
            List<DesplegableAdmonLocalVO> listaSexo = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_SEXO,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaMayor55 = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaFinFormativa = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaJornada = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_JORN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaGrupoCotizacion = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_GCOT,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaTipRetribucion = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTRT,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            List<DesplegableAdmonLocalVO> listaTitReqPuesto = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_TITREQPUESTO,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            // desplegables externos
            DatosTablaDesplegableExtVO datosTablaDesplegableOcupaciones = this.getDatosMapeoDesplegableExterno(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_OCIN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            String tablaOcupaciones = datosTablaDesplegableOcupaciones.getTabla();
            String campoCodigoOcupaciones = datosTablaDesplegableOcupaciones.getCampoCodigo();
            String campoValorOcupaciones = datosTablaDesplegableOcupaciones.getCampoValor();
            List<DesplegableExternoVO> listaOcupacion = this.getValoresDesplegablesExternos(tablaOcupaciones,
                    campoCodigoOcupaciones, campoValorOcupaciones);

            DatosTablaDesplegableExtVO datosTablaDesplegableTitulaciones = this.getDatosMapeoDesplegableExterno(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_TIIN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            String tablaTitulaciones = datosTablaDesplegableTitulaciones.getTabla();
            String campoCodigoTitulaciones = datosTablaDesplegableTitulaciones.getCampoCodigo();
            String campoValorTitulaciones = datosTablaDesplegableTitulaciones.getCampoValor();
            List<DesplegableExternoVO> listaTitulacion = this.getValoresDesplegablesExternos(tablaTitulaciones,
                    campoCodigoTitulaciones, campoValorTitulaciones);

            DatosTablaDesplegableExtVO datosTablaDesplegableCProfesionales = this.getDatosMapeoDesplegableExterno(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_CPIN,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));
            String tablaCProfesionales = datosTablaDesplegableCProfesionales.getTabla();
            String campoCodigoCProfesionales = datosTablaDesplegableCProfesionales.getCampoCodigo();
            String campoValorCProfesionales = datosTablaDesplegableCProfesionales.getCampoValor();
            List<DesplegableExternoVO> listaCProfesionalidad = this.getValoresDesplegablesExternos(tablaCProfesionales,
                    campoCodigoCProfesionales, campoValorCProfesionales);

            for (ContratacionVO cont : lista) {
                for (DesplegableAdmonLocalVO valordesp : listaSexo) {
                    if (valordesp.getDes_val_cod().equals(cont.getSexo())) {
                        cont.setDesSexo(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaMayor55) {
                    if (valordesp.getDes_val_cod().equals(cont.getMayor55())) {
                        cont.setMayor55(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaFinFormativa) {
                    if (valordesp.getDes_val_cod().equals(cont.getFinFormativa())) {
                        cont.setFinFormativa(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaJornada) {
                    if (valordesp.getDes_val_cod().equals(cont.getJornada())) {
                        cont.setDesJornada(valordesp.getDes_nom());
                        break;
                    }
                }
                // NUEVO: descripción TITREQPUESTO
                for (DesplegableAdmonLocalVO valordesp : listaTitReqPuesto) {
                    if (valordesp.getDes_val_cod().equals(cont.getTitReqPuesto())) {
                        cont.setDesTitReqPuesto(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaGrupoCotizacion) {
                    if (valordesp.getDes_val_cod().equals(cont.getGrupoCotizacion())) {
                        cont.setDesGrupoCotizacion(valordesp.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO valordesp : listaTipRetribucion) {
                    if (valordesp.getDes_val_cod().equals(cont.getTipRetribucion())) {
                        cont.setDesTipRetribucion(valordesp.getDes_nom());
                        break;
                    }
                }

                // desplegables externos
                for (DesplegableExternoVO valordesp : listaOcupacion) {
                    if (valordesp.getCampoCodigo().equals(cont.getOcupacion())) {
                        cont.setDesOcupacion(valordesp.getCampoValor());
                        break;
                    }
                }
                // Inicializar desTitulacion con el código original como fallback
                if (cont.getTitulacion() != null && !"".equals(cont.getTitulacion().trim())) {
                    cont.setDesTitulacion(cont.getTitulacion()); // fallback al código
                }
                // Intentar traducir con el desplegable externo
                for (DesplegableExternoVO valordesp : listaTitulacion) {
                    if (valordesp.getCampoCodigo().equals(cont.getTitulacion())) {
                        cont.setDesTitulacion(valordesp.getCampoValor());
                        break;
                    }
                }
                for (DesplegableExternoVO valordesp : listaCProfesionalidad) {
                    if (valordesp.getCampoCodigo().equals(cont.getcProfesionalidad())) {
                        cont.setDesCProfesionalidad(valordesp.getCampoValor());
                        break;
                    }
                }

                // Log detallado de campos RSB después del mapeo
                log.info("*** MANAGER RSB DEBUG *** Contratación ID: " + cont.getId());
                log.info("*** MANAGER RSB *** rsbSalBase: "
                        + (cont.getRsbSalBase() != null ? cont.getRsbSalBase() : "NULL"));
                log.info("*** MANAGER RSB *** rsbPagExtra: "
                        + (cont.getRsbPagExtra() != null ? cont.getRsbPagExtra() : "NULL"));
                log.info("*** MANAGER RSB *** rsbCompConv: "
                        + (cont.getRsbCompConv() != null ? cont.getRsbCompConv() : "NULL"));
                log.info("*** MANAGER RSB *** rsbComputableTotal calculado: "
                        + (cont.getRsbComputableTotal() != null ? cont.getRsbComputableTotal() : "NULL"));
            }

            return lista;
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando las contrataciones:  " + e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción general en la BBDD recuperando las contrataciones:   " + ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    public boolean crearNuevaContratacion(ContratacionVO nuevaContratacion) throws Exception {
        Connection con = null;
        boolean insertOK;
        try {
            con = adaptador.getConnection();
            insertOK = melanbide11DAO.crearNuevaContratacion(nuevaContratacion, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD creando una contratación : " + e.getMessage(), e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD creando una contratación : " + ex.getMessage(), ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
        return insertOK;
    }

    public boolean modificarContratacion(ContratacionVO datModif) throws Exception {
        Connection con = null;
        boolean insertOK;
        try {
            con = adaptador.getConnection();
            insertOK = melanbide11DAO.modificarContratacion(datModif, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD actualizando una contratación : " + e.getMessage(), e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD actualizando una contratación : " + ex.getMessage(),
                    ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
        return insertOK;
    }

    public List<MinimisVO> getDatosMinimis(String numExp, int codOrganizacion) throws Exception {
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        Connection con = null;
        try {
            con = adaptador.getConnection();
            lista = melanbide11DAO.getDatosMinimis(numExp, codOrganizacion, con);
            // recuperamos los cod y desc de desplegables para traducir en la tabla
            // principal
            List<DesplegableAdmonLocalVO> listaEstado = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTSV,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            for (MinimisVO cont : lista) {
                for (DesplegableAdmonLocalVO valordesp : listaEstado) {
                    if (valordesp.getDes_val_cod().equals(cont.getEstado())) {
                        cont.setDesEstado(valordesp.getDes_nom());
                        break;
                    }
                }
            }

            return lista;
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos sobre las minimis ", e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos sobre las minimis ", ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public List<MinimisVO> getDatosMinimis(String numExp, int codOrganizacion, AdaptadorSQLBD adapt) throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getDatosMinimis(numExp, codOrganizacion);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getDatosMinimis(numExp, codOrganizacion);
    }

    public MinimisVO getMinimisPorID(String id) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getMinimisPorID(id, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepcion en la BBDD recuperando datos sobre una minimis:  " + id, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepcion en la BBDD recuperando datos sobre una minimis:  " + id, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexion a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public MinimisVO getMinimisPorID(String id, AdaptadorSQLBD adapt) throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getMinimisPorID(id);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getMinimisPorID(id);
    }

    public int eliminarMinimis(String id) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.eliminarMinimis(id, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD al eliminar una minimis:  " + id, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD al eliminar una minimis:   " + id, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    public List<MinimisVO> getMinimis(String numExp) throws Exception {
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        Connection con = null;
        try {
            con = adaptador.getConnection();
            lista = melanbide11DAO.getMinimis(numExp, con);

            // recuperamos los cod y desc de desplegables para traducir en la tabla
            // principal
            List<DesplegableAdmonLocalVO> listaEstado = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTSV,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            for (MinimisVO cont : lista) {
                for (DesplegableAdmonLocalVO valordesp : listaEstado) {
                    if (valordesp.getDes_val_cod().equals(cont.getEstado())) {
                        cont.setDesEstado(valordesp.getDes_nom());
                        break;
                    }
                }
            }

            return lista;
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando las minimis:  " + e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción general en la BBDD recuperando las minimis:   " + ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    public boolean crearNuevaMinimis(MinimisVO nuevaMinimis) throws Exception {
        Connection con = null;
        boolean insertOK;
        try {
            con = adaptador.getConnection();
            insertOK = melanbide11DAO.crearNuevaMinimis(nuevaMinimis, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD creando una minimis : " + e.getMessage(), e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD creando una minimis : " + ex.getMessage(), ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
        return insertOK;
    }

    public boolean modificarMinimis(MinimisVO datModif) throws Exception {
        Connection con = null;
        boolean insertOK;
        try {
            con = adaptador.getConnection();
            insertOK = melanbide11DAO.modificarMinimis(datModif, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD actualizando una minimis : " + e.getMessage(), e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD actualizando una minimis : " + ex.getMessage(), ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
        return insertOK;
    }

    public List<DesgloseRSBVO> getDatosDesgloseRSB(String numExp, int codOrganizacion) throws Exception {
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        Connection con = null;
        try {
            con = adaptador.getConnection();
            lista = melanbide11DAO.getDatosDesgloseRSB(numExp, codOrganizacion, con);

            // Recupera cod/desc de desplegables para traducir en la tabla principal
            List<DesplegableAdmonLocalVO> listaTipo = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_RSBT,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            List<DesplegableAdmonLocalVO> listaConcepto = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_RSBC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            for (DesgloseRSBVO det : lista) {
                // RSBTIPO -> desTipo
                for (DesplegableAdmonLocalVO val : listaTipo) {
                    if (val.getDes_val_cod().equals(det.getRsbTipo())) {
                        det.setDesRsbTipo(val.getDes_nom());
                        break;
                    }
                }
                // RSBCONCEPTO -> desConcepto
                for (DesplegableAdmonLocalVO val : listaConcepto) {
                    if (val.getDes_val_cod().equals(det.getRsbConcepto())) {
                        det.setDesRsbConcepto(val.getDes_nom());
                        break;
                    }
                }
            }

            return lista;
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos del desglose RSB ", e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos del desglose RSB ", ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Versión filtrada por DNI: evita traer todas las líneas y filtrar en memoria.
     */
    public List<DesgloseRSBVO> getDatosDesgloseRSBPorDni(String numExp, String dni, int codOrganizacion)
            throws Exception {
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        Connection con = null;
        try {
            con = adaptador.getConnection();
            lista = melanbide11DAO.getDatosDesgloseRSBPorDni(numExp, dni, codOrganizacion, con);

            // Traducción de desplegables igual que en método general
            List<DesplegableAdmonLocalVO> listaTipo = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_RSBT,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            List<DesplegableAdmonLocalVO> listaConcepto = this.getValoresDesplegablesAdmonLocalxdes_cod(
                    ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_RSBC,
                            ConstantesMeLanbide11.FICHERO_PROPIEDADES));

            for (DesgloseRSBVO det : lista) {
                for (DesplegableAdmonLocalVO val : listaTipo) {
                    if (val.getDes_val_cod().equals(det.getRsbTipo())) {
                        det.setDesRsbTipo(val.getDes_nom());
                        break;
                    }
                }
                for (DesplegableAdmonLocalVO val : listaConcepto) {
                    if (val.getDes_val_cod().equals(det.getRsbConcepto())) {
                        det.setDesRsbConcepto(val.getDes_nom());
                        break;
                    }
                }
            }
            return lista;
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos del desglose RSB (por DNI)", e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando datos del desglose RSB (por DNI)", ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD (por DNI): " + e.getMessage());
            }
        }
    }

    /**
     * Guarda los valores básicos del desglose RSB (salario base, pagas extra y suma
     * de complementos salariales) en la contratación indicada recalculando
     * RSBCOMPCONV. No gestiona todavía el detalle de líneas de la pestaña 2.
     *
     * @param idRegistro     ID de la contratación (tabla principal)
     * @param salarioBase    Salario base
     * @param pagasExtra     Pagas extraordinarias
     * @param compSalariales Complementos salariales (importe total)
     * @return true si la actualización fue correcta
     * @throws Exception
     */
    public boolean guardarDesgloseBasico(String idRegistro, Double salarioBase, Double pagasExtra,
            Double compSalariales) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.actualizarDesgloseBasico(idRegistro, salarioBase, pagasExtra, compSalariales, con);
        } catch (BDException e) {
            log.error("Excepción BBDD guardando desglose básico RSB id=" + idRegistro, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Excepción guardando desglose básico RSB id=" + idRegistro, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Nueva versión que incluye rsbTipo (1 = salarial, 2 = extrasalarial). El
     * importe compSalariales se guarda siempre en RSBIMPORTE y el tipo en RSBTIPO.
     */
    public boolean guardarDesgloseBasico(String idRegistro, Double salarioBase, Double pagasExtra,
            Double compSalariales, String rsbTipo) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.actualizarDesgloseBasico(idRegistro, salarioBase, pagasExtra, compSalariales, rsbTipo,
                    con);
        } catch (BDException e) {
            log.error("Excepción BBDD guardando desglose básico RSB (tipo) id=" + idRegistro, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Excepción guardando desglose básico RSB (tipo) id=" + idRegistro, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Obtiene los complementos salariales y extrasalariales por separado
     * 
     * @param numExp Número de expediente
     * @param dni    DNI del contratado
     * @return ComplementosPorTipo con las sumas separadas
     * @throws Exception
     */
    public ComplementosPorTipo getSumaComplementosPorTipo(String numExp, String dni) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getSumaComplementosPorTipo(numExp, dni, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando complementos por tipo", e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando complementos por tipo", ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public ComplementosPorTipo getSumaComplementosPorTipo(String numExp, String dni, AdaptadorSQLBD adapt)
            throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getSumaComplementosPorTipo(numExp, dni);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getSumaComplementosPorTipo(numExp, dni);
    }

    /**
     * Obtiene solo la suma de complementos salariales FIJOS (excluye VARIABLES). Se
     * usa para calcular la RSB Computable para la Convocatoria.
     * 
     * @param numExp
     * @param dni
     * @param adapt
     * @return suma de complementos salariales FIJOS
     * @throws Exception
     */
    public double getSumaComplementosFijos(String numExp, String dni, AdaptadorSQLBD adapt) throws Exception {
        Connection con = null;
        try {
            if (adapt != null) {
                con = adapt.getConnection();
            } else {
                con = adaptador.getConnection();
            }
            return melanbide11DAO.getSumaComplementosFijos(numExp, dni, con);
        } catch (BDException e) {
            log.error("Excepción BBDD obteniendo suma de complementos fijos", e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Excepción obteniendo suma de complementos fijos", ex);
            throw new Exception(ex);
        } finally {
            try {
                if (adapt != null) {
                    adapt.devolverConexion(con);
                } else {
                    adaptador.devolverConexion(con);
                }
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    public DesgloseRSBVO getDesgloseRSBPorID(String id) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getDesgloseRSBPorID(id, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepcion en la BBDD recuperando un registro de desglose RSB: " + id, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepcion en la BBDD recuperando un registro de desglose RSB: " + id, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexion a la BBDD: " + e.getMessage());
            }
        }
    }

    /*
     * Método comentado temporalmente: dependía de un DAO inexistente
     * getDniDesdeDesglosePorExpediente(String, Connection). Si se necesita en el
     * futuro deberá implementarse primero en MeLanbide11DAO (SELECT DISTINCT
     * DNICONT ...) y ajustar el tipo de retorno (String o lista). Mientras tanto se
     * elimina para permitir la compilación.
     */
    // public String getDniDesdeDesglosePorExpediente(String numExp, AdaptadorSQLBD
    // adapt) throws Exception {
    // Connection con = null;
    // try {
    // con = adapt.getConnection();
    // MeLanbide11DAO dao = MeLanbide11DAO.getInstance();
    // return dao.getDniDesdeDesglosePorExpediente(numExp, con);
    // } catch (BDException e) {
    // log.error("Excepción BBDD obteniendo DNI desde desglose por expediente
    // numExp=" + numExp, e);
    // throw new Exception(e);
    // } catch (Exception ex) {
    // log.error("Excepción obteniendo DNI desde desglose por expediente numExp=" +
    // numExp, ex);
    // throw new Exception(ex);
    // } finally {
    // try { adapt.devolverConexion(con); } catch (Exception e) { log.error("Error
    // al cerrar conexión a la BBDD: " + e.getMessage()); }
    // }
    // }

    /**
     * Reemplaza (borrando e insertando) las líneas del desglose RSB para un
     * expediente + DNI, y recalcula automáticamente RSBCOMPCONV.
     */
    public boolean reemplazarDesgloseRSB(String numExp, String dni, List<DesgloseRSBVO> lineas) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.reemplazarDesgloseRSB(numExp, dni, lineas, con);
        } catch (BDException e) {
            log.error("Excepción BBDD reemplazando desglose RSB numExp=" + numExp + ", dni=" + dni, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Excepción reemplazando desglose RSB numExp=" + numExp + ", dni=" + dni, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Obtiene una contratación específica por número de expediente y DNI.
     * Útil para recuperar valores actualizados tras recálculos automáticos.
     */
    public ContratacionVO getContratacion(String numExp, String dni) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getContratacionByExpDni(numExp, dni, con);
        } catch (BDException e) {
            log.error("Excepción BBDD obteniendo contratación numExp=" + numExp + ", dni=" + dni, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Excepción obteniendo contratación numExp=" + numExp + ", dni=" + dni, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    public List<DesplegableAdmonLocalVO> getValoresDesplegablesAdmonLocalxdes_cod(String des_cod) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getValoresDesplegablesAdmonLocalxdes_cod(des_cod, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando valores de desplegable : " + des_cod, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando valores de desplegable :  " + des_cod, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public List<DesplegableAdmonLocalVO> getValoresDesplegablesAdmonLocalxdes_cod(String des_cod, AdaptadorSQLBD adapt)
            throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            // Si se pasa un adaptador diferente, usarlo temporalmente
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getValoresDesplegablesAdmonLocalxdes_cod(des_cod);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getValoresDesplegablesAdmonLocalxdes_cod(des_cod);
    }

    public DatosTablaDesplegableExtVO getDatosMapeoDesplegableExterno(String des_cod) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getDatosMapeoDesplegableExterno(des_cod, con);
        } catch (BDException e) {
            log.error(
                    "Se ha producido una excepción en la BBDD recuperando valores de datos de tabla de desplegable externo : "
                            + des_cod,
                    e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error(
                    "Se ha producido una excepción en la BBDD recuperando valores de datos de tabla de desplegable externo :  "
                            + des_cod,
                    ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public DatosTablaDesplegableExtVO getDatosMapeoDesplegableExterno(String des_cod, AdaptadorSQLBD adapt)
            throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getDatosMapeoDesplegableExterno(des_cod);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getDatosMapeoDesplegableExterno(des_cod);
    }

    public List<DesplegableExternoVO> getValoresDesplegablesExternos(String tablaDesplegable, String campoCodigo,
            String campoValor) throws Exception {
        Connection con = null;
        try {
            con = adaptador.getConnection();
            return melanbide11DAO.getValoresDesplegablesExternos(tablaDesplegable, campoCodigo, campoValor, con);
        } catch (BDException e) {
            log.error("Se ha producido una excepción en la BBDD recuperando valores de desplegable externo de tabla : "
                    + tablaDesplegable, e);
            throw new Exception(e);
        } catch (Exception ex) {
            log.error("Se ha producido una excepción en la BBDD recuperando valores de desplegable externo de tabla :  "
                    + tablaDesplegable, ex);
            throw new Exception(ex);
        } finally {
            try {
                adaptador.devolverConexion(con);
            } catch (Exception e) {
                log.error("Error al cerrar conexión a la BBDD: " + e.getMessage());
            }
        }
    }

    /**
     * Sobrecarga para compatibilidad con código legacy que pasa el adaptador
     */
    public List<DesplegableExternoVO> getValoresDesplegablesExternos(String tablaDesplegable, String campoCodigo,
            String campoValor, AdaptadorSQLBD adapt) throws Exception {
        if (adapt != null && adapt != this.adaptador) {
            AdaptadorSQLBD oldAdapt = this.adaptador;
            try {
                this.adaptador = adapt;
                this.melanbide11DAO = MeLanbide11DAO.getInstance(adapt);
                return getValoresDesplegablesExternos(tablaDesplegable, campoCodigo, campoValor);
            } finally {
                this.adaptador = oldAdapt;
                if (oldAdapt != null) {
                    this.melanbide11DAO = MeLanbide11DAO.getInstance(oldAdapt);
                }
            }
        }
        return getValoresDesplegablesExternos(tablaDesplegable, campoCodigo, campoValor);
    }

    /**
     * Obtiene todas las contrataciones de un expediente específico. Método adaptado
     * para AJAX CRUD.
     */
    public List<ContratacionVO> getContratacionesByExpediente(String numExpediente) throws Exception {
        log.debug("getContratacionesByExpediente (AJAX) - numExp: " + numExpediente);
        return this.getContrataciones(numExpediente);
    }

    /**
     * Elimina una contratación por ID. Método adaptado para AJAX CRUD.
     */
    public boolean eliminarContratacionAJAX(String idStr) throws Exception {
        log.debug("eliminarContratacionAJAX (AJAX) - id: " + idStr);
        int resultado = this.eliminarContratacion(idStr);
        return resultado > 0;
    }

    /**
     * Obtiene una contratación específica por ID. Método adaptado para AJAX CRUD.
     */
    public ContratacionVO getContratacionById(String idStr) throws Exception {
        log.debug("getContratacionById (AJAX) - id: " + idStr);
        return this.getContratacionPorID(idStr);
    }
}
