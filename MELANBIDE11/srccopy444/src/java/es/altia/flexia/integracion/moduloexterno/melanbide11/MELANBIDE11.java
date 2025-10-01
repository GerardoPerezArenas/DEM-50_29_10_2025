
package es.altia.flexia.integracion.moduloexterno.melanbide11;

import es.altia.agora.business.escritorio.UsuarioValueObject;

import es.altia.agora.technical.ConstantesDatos;
import es.altia.common.exception.TechnicalException;

import es.altia.flexia.integracion.moduloexterno.melanbide11.manager.MeLanbide11Manager;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConfigurationParameter;
import es.altia.flexia.integracion.moduloexterno.melanbide11.util.ConstantesMeLanbide11;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.MinimisVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DatosTablaDesplegableExtVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableAdmonLocalVO;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesplegableExternoVO;
import es.altia.flexia.integracion.moduloexterno.plugin.ModuloIntegracionExterno;
import es.altia.technical.PortableContext;
import es.altia.util.conexion.AdaptadorSQLBD;
import es.altia.util.conexion.BDException;
import es.altia.flexia.integracion.moduloexterno.melanbide11.dao.MeLanbide11DAO.ComplementosPorTipo;
import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesgloseRSBVO;
import java.util.List;
import java.util.ArrayList;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ResourceBundle;
import java.util.logging.Level;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import org.apache.log4j.Logger;

public class MELANBIDE11 extends ModuloIntegracionExterno {

    private static Logger log = Logger.getLogger(MELANBIDE11.class);
    private static DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    ResourceBundle m_Conf = ResourceBundle.getBundle("common");

    public void cargarExpedienteExtension(int codigoOrganizacion, String numeroExpediente, String xml)
            throws Exception {
        final Class cls = Class.forName("es.altia.flexia.integracion.moduloexterno.melanbide42.MELANBIDE42");
        final Object me42Class = cls.newInstance();
        final Class[] types = { int.class, String.class, String.class };
        final Method method = cls.getMethod("cargarExpedienteExtension", types);

        method.invoke(me42Class, codigoOrganizacion, numeroExpediente, xml);
    }

    public String cargarPantallaPrincipal(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        AdaptadorSQLBD adapt = null;
        try {
            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
        } catch (Exception ex) {
            log.error(this.getClass().getName() + " Error al recuperar el adaptador getAdaptSQLBD ", ex);
        }
        String url = "/jsp/extension/melanbide11/melanbide11.jsp";
        request.setAttribute("numExp", numExpediente);
        if (adapt != null) {
            try {
                List<ContratacionVO> listaAccesos = MeLanbide11Manager.getInstance().getDatosContratacion(numExpediente,
                        codOrganizacion, adapt);
                if (listaAccesos.size() > 0) {
                    request.setAttribute("listaAccesos", listaAccesos);
                }

                List<DesplegableAdmonLocalVO> listaSexo = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesAdmonLocalxdes_cod(ConfigurationParameter.getParameter(
                                ConstantesMeLanbide11.COD_DES_SEXO, ConstantesMeLanbide11.FICHERO_PROPIEDADES), adapt);
                if (listaSexo.size() > 0) {
                    listaSexo = traducirDesplegable(request, listaSexo);
                    request.setAttribute("listaSexo", listaSexo);
                }

                List<DesplegableAdmonLocalVO> listaMayor55 = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesAdmonLocalxdes_cod(ConfigurationParameter.getParameter(
                                ConstantesMeLanbide11.COD_DES_BOOL, ConstantesMeLanbide11.FICHERO_PROPIEDADES), adapt);
                if (listaMayor55.size() > 0) {
                    listaMayor55 = traducirDesplegable(request, listaMayor55);
                    request.setAttribute("listaMayor55", listaMayor55);
                }

                List<DesplegableAdmonLocalVO> listaFinFormativa = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesAdmonLocalxdes_cod(ConfigurationParameter.getParameter(
                                ConstantesMeLanbide11.COD_DES_BOOL, ConstantesMeLanbide11.FICHERO_PROPIEDADES), adapt);
                if (listaFinFormativa.size() > 0) {
                    listaFinFormativa = traducirDesplegable(request, listaFinFormativa);
                    request.setAttribute("listaFinFormativa", listaFinFormativa);
                }

                List<DesplegableAdmonLocalVO> listaJornada = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesAdmonLocalxdes_cod(ConfigurationParameter.getParameter(
                                ConstantesMeLanbide11.COD_DES_JORN, ConstantesMeLanbide11.FICHERO_PROPIEDADES), adapt);
                if (listaJornada.size() > 0) {
                    listaJornada = traducirDesplegable(request, listaJornada);
                    request.setAttribute("listaJornada", listaJornada);
                }

                List<DesplegableAdmonLocalVO> listaGrupoCotizacion = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesAdmonLocalxdes_cod(ConfigurationParameter.getParameter(
                                ConstantesMeLanbide11.COD_DES_GCOT, ConstantesMeLanbide11.FICHERO_PROPIEDADES), adapt);
                if (listaGrupoCotizacion.size() > 0) {
                    listaGrupoCotizacion = traducirDesplegable(request, listaGrupoCotizacion);
                    request.setAttribute("listaGrupoCotizacion", listaGrupoCotizacion);
                }

                List<DesplegableAdmonLocalVO> listaTipRetribucion = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesAdmonLocalxdes_cod(ConfigurationParameter.getParameter(
                                ConstantesMeLanbide11.COD_DES_DTRT, ConstantesMeLanbide11.FICHERO_PROPIEDADES), adapt);
                if (listaTipRetribucion.size() > 0) {
                    listaTipRetribucion = traducirDesplegable(request, listaTipRetribucion);
                    request.setAttribute("listaTipRetribucion", listaTipRetribucion);
                }

                DatosTablaDesplegableExtVO datosTablaDesplegableOcupaciones = MeLanbide11Manager.getInstance()
                        .getDatosMapeoDesplegableExterno(
                                ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_OCIN,
                                        ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                                adapt);
                String tablaOcupaciones = datosTablaDesplegableOcupaciones.getTabla();
                String campoCodigoOcupaciones = datosTablaDesplegableOcupaciones.getCampoCodigo();
                String campoValorOcupaciones = datosTablaDesplegableOcupaciones.getCampoValor();
                List<DesplegableExternoVO> listaOcupacion = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesExternos(tablaOcupaciones, campoCodigoOcupaciones, campoValorOcupaciones,
                                adapt);
                if (listaOcupacion.size() > 0) {
                    request.setAttribute("listaOcupacion", listaOcupacion);
                }

                DatosTablaDesplegableExtVO datosTablaDesplegableTitulaciones = MeLanbide11Manager.getInstance()
                        .getDatosMapeoDesplegableExterno(
                                ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_TIIN,
                                        ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                                adapt);
                String tablaTitulaciones = datosTablaDesplegableTitulaciones.getTabla();
                String campoCodigoTitulaciones = datosTablaDesplegableTitulaciones.getCampoCodigo();
                String campoValorTitulaciones = datosTablaDesplegableTitulaciones.getCampoValor();
                List<DesplegableExternoVO> listaTitulacion = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesExternos(tablaTitulaciones, campoCodigoTitulaciones,
                                campoValorTitulaciones, adapt);
                if (listaTitulacion.size() > 0) {
                    request.setAttribute("listaTitulacion", listaTitulacion);
                }

                DatosTablaDesplegableExtVO datosTablaDesplegableCProfesionales = MeLanbide11Manager.getInstance()
                        .getDatosMapeoDesplegableExterno(
                                ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_CPIN,
                                        ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                                adapt);
                String tablaCProfesionales = datosTablaDesplegableCProfesionales.getTabla();
                String campoCodigoCProfesionales = datosTablaDesplegableCProfesionales.getCampoCodigo();
                String campoValorCProfesionales = datosTablaDesplegableCProfesionales.getCampoValor();
                List<DesplegableExternoVO> listaCProfesionalidad = MeLanbide11Manager.getInstance()
                        .getValoresDesplegablesExternos(tablaCProfesionales, campoCodigoCProfesionales,
                                campoValorCProfesionales, adapt);
                if (listaCProfesionalidad.size() > 0) {
                    request.setAttribute("listaCProfesionalidad", listaCProfesionalidad);
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                log.error("Error al recuperar los datos de contrataciones - MELANBIDE11 - cargarPantallaPrincipal", ex);
            }
        }

        return url;
    }

    public String cargarPantallaMinimis(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        AdaptadorSQLBD adapt = null;
        try {
            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
        } catch (Exception ex) {
            log.error(this.getClass().getName() + " Error al recuperar el adaptador getAdaptSQLBD ", ex);
        }
        String url = "/jsp/extension/melanbide11/minimis.jsp";
        request.setAttribute("numExp", numExpediente);
        if (adapt != null) {
            try {
                List<MinimisVO> listaMinimis = MeLanbide11Manager.getInstance().getDatosMinimis(numExpediente,
                        codOrganizacion, adapt);
                if (listaMinimis.size() > 0) {
                    request.setAttribute("listaMinimis", listaMinimis);
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                log.error("Error al recuperar los datos de minimis - MELANBIDE11 - cargarPantallaMinimis", ex);
            }
        }

        return url;
    }

    public String cargarListaDesglose(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        // Compatibilidad hacia atrás: esta operación antigua mostraba un listado
        // simple.
        // Ahora redirigimos al nuevo flujo de Desglose RSB (modal con pestañas).
        try {
            if (request.getAttribute("numExp") == null) {
                request.setAttribute("numExp", numExpediente);
            }
        } catch (Exception ignore) {
        }
        return cargarDesgloseRSB(codOrganizacion, codTramite, ocurrenciaTramite, numExpediente, request, response);
    }

    public String irDesgloseRSB(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("numExp", numExpediente);
        return "/jsp/extension/melanbide11/desglose/m11Desglose.jsp";
    }

    private List<DesplegableAdmonLocalVO> traducirDesplegable(HttpServletRequest request,
            List<DesplegableAdmonLocalVO> desplegable) {

        for (DesplegableAdmonLocalVO d : desplegable) {
            if (d.getDes_nom() != null && !d.getDes_nom().equals("")) {
                d.setDes_nom(getDescripcionDesplegable(request, d.getDes_nom()));
            }
        }

        return desplegable;
    }

    public String cargarNuevaContratacion(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        String nuevo = "1";
        String numExp = "";
        String urlnuevaContratacion = "/jsp/extension/melanbide11/nuevaContratacion.jsp?codOrganizacion="
                + codOrganizacion;
        try {
            if (request.getAttribute("nuevo") != null) {
                if (request.getAttribute("nuevo").toString().equals("0")) {
                    request.setAttribute("nuevo", nuevo);
                }
            } else {
                request.setAttribute("nuevo", nuevo);
            }
            if (request.getParameter("numExp") != null) {
                numExp = request.getParameter("numExp").toString();
                request.setAttribute("numExp", numExp);
            }
            // Cargamos en el request los valores de los desplegables
            List<DesplegableAdmonLocalVO> listaSexo = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_SEXO,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaSexo.size() > 0) {
                listaSexo = traducirDesplegable(request, listaSexo);
                request.setAttribute("listaSexo", listaSexo);
            }
            List<DesplegableAdmonLocalVO> listaMayor55 = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaMayor55.size() > 0) {
                listaMayor55 = traducirDesplegable(request, listaMayor55);
                request.setAttribute("listaMayor55", listaMayor55);
            }
            List<DesplegableAdmonLocalVO> listaFinFormativa = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaFinFormativa.size() > 0) {
                listaFinFormativa = traducirDesplegable(request, listaFinFormativa);
                request.setAttribute("listaFinFormativa", listaFinFormativa);
            }
            List<DesplegableAdmonLocalVO> listaJornada = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_JORN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaJornada.size() > 0) {
                listaJornada = traducirDesplegable(request, listaJornada);
                request.setAttribute("listaJornada", listaJornada);
            }
            List<DesplegableAdmonLocalVO> listaGrupoCotizacion = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_GCOT,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaGrupoCotizacion.size() > 0) {
                listaGrupoCotizacion = traducirDesplegable(request, listaGrupoCotizacion);
                request.setAttribute("listaGrupoCotizacion", listaGrupoCotizacion);
            }
            List<DesplegableAdmonLocalVO> listaTipRetribucion = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTRT,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaTipRetribucion.size() > 0) {
                listaTipRetribucion = traducirDesplegable(request, listaTipRetribucion);
                request.setAttribute("listaTipRetribucion", listaTipRetribucion);
            }
            List<DesplegableAdmonLocalVO> listaTitReqPuesto = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_TITREQPUESTO,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaTitReqPuesto != null && listaTitReqPuesto.size() > 0) {
                listaTitReqPuesto = traducirDesplegable(request, listaTitReqPuesto);
            } else {
                listaTitReqPuesto = new ArrayList<DesplegableAdmonLocalVO>();
            }
            request.setAttribute("listaTitReqPuesto", listaTitReqPuesto);

            DatosTablaDesplegableExtVO datosTablaDesplegableOcupaciones = MeLanbide11Manager.getInstance()
                    .getDatosMapeoDesplegableExterno(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_OCIN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            String tablaOcupaciones = datosTablaDesplegableOcupaciones.getTabla();
            String campoCodigoOcupaciones = datosTablaDesplegableOcupaciones.getCampoCodigo();
            String campoValorOcupaciones = datosTablaDesplegableOcupaciones.getCampoValor();
            List<DesplegableExternoVO> listaOcupacion = MeLanbide11Manager.getInstance().getValoresDesplegablesExternos(
                    tablaOcupaciones, campoCodigoOcupaciones, campoValorOcupaciones,
                    this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaOcupacion.size() > 0) {
                request.setAttribute("listaOcupacion", listaOcupacion);
            }
            DatosTablaDesplegableExtVO datosTablaDesplegableTitulaciones = MeLanbide11Manager.getInstance()
                    .getDatosMapeoDesplegableExterno(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_TIIN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            String tablaTitulaciones = datosTablaDesplegableTitulaciones.getTabla();
            String campoCodigoTitulaciones = datosTablaDesplegableTitulaciones.getCampoCodigo();
            String campoValorTitulaciones = datosTablaDesplegableTitulaciones.getCampoValor();
            List<DesplegableExternoVO> listaTitulacion = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesExternos(tablaTitulaciones, campoCodigoTitulaciones, campoValorTitulaciones,
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaTitulacion.size() > 0) {
                request.setAttribute("listaTitulacion", listaTitulacion);
            }
            DatosTablaDesplegableExtVO datosTablaDesplegableCProfesionales = MeLanbide11Manager.getInstance()
                    .getDatosMapeoDesplegableExterno(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_CPIN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            String tablaCProfesionales = datosTablaDesplegableCProfesionales.getTabla();
            String campoCodigoCProfesionales = datosTablaDesplegableCProfesionales.getCampoCodigo();
            String campoValorCProfesionales = datosTablaDesplegableCProfesionales.getCampoValor();
            List<DesplegableExternoVO> listaCProfesionalidad = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesExternos(tablaCProfesionales, campoCodigoCProfesionales,
                            campoValorCProfesionales, this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaCProfesionalidad.size() > 0) {
                request.setAttribute("listaCProfesionalidad", listaCProfesionalidad);
            }
        } catch (Exception ex) {
            log.error("Error al intentar preparar la jsp de una nueva contratacion: " + ex.getMessage(), ex);
        }
        return urlnuevaContratacion;
    }

    public String cargarModificarContratacion(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        String nuevo = "0";
        String urlnuevaContratacion = "/jsp/extension/melanbide11/nuevaContratacion.jsp?codOrganizacion="
                + codOrganizacion;
        try {
            if (request.getAttribute("nuevo") != null) {
                if (!request.getAttribute("nuevo").toString().equals("0")) {
                    request.setAttribute("nuevo", nuevo);
                }
            } else {
                request.setAttribute("nuevo", nuevo);
            }
            String id = request.getParameter("id");
            // Recuperramos datos e Acceso a modificar y cargamos en el request
            if (id != null && !id.equals("")) {
                ContratacionVO datModif = MeLanbide11Manager.getInstance().getContratacionPorID(id,
                        this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
                if (datModif != null) {
                    request.setAttribute("datModif", datModif);
                }
            }
            // Cargamos el el request los valores de los desplegables
            List<DesplegableAdmonLocalVO> listaSexo = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_SEXO,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaSexo.size() > 0) {
                listaSexo = traducirDesplegable(request, listaSexo);
                request.setAttribute("listaSexo", listaSexo);
            }
            List<DesplegableAdmonLocalVO> listaMayor55 = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaMayor55.size() > 0) {
                listaMayor55 = traducirDesplegable(request, listaMayor55);
                request.setAttribute("listaMayor55", listaMayor55);
            }
            List<DesplegableAdmonLocalVO> listaFinFormativa = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_BOOL,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaFinFormativa.size() > 0) {
                listaFinFormativa = traducirDesplegable(request, listaFinFormativa);
                request.setAttribute("listaFinFormativa", listaFinFormativa);
            }
            List<DesplegableAdmonLocalVO> listaJornada = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_JORN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaJornada.size() > 0) {
                listaJornada = traducirDesplegable(request, listaJornada);
                request.setAttribute("listaJornada", listaJornada);
            }
            List<DesplegableAdmonLocalVO> listaGrupoCotizacion = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_GCOT,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaGrupoCotizacion.size() > 0) {
                listaGrupoCotizacion = traducirDesplegable(request, listaGrupoCotizacion);
                request.setAttribute("listaGrupoCotizacion", listaGrupoCotizacion);
            }
            List<DesplegableAdmonLocalVO> listaTipRetribucion = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTRT,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaTipRetribucion.size() > 0) {
                listaTipRetribucion = traducirDesplegable(request, listaTipRetribucion);
                request.setAttribute("listaTipRetribucion", listaTipRetribucion);
            }
            List<DesplegableAdmonLocalVO> listaTitReqPuesto = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_TITREQPUESTO,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaTitReqPuesto != null && listaTitReqPuesto.size() > 0) {
                listaTitReqPuesto = traducirDesplegable(request, listaTitReqPuesto);
            } else {
                listaTitReqPuesto = new ArrayList<DesplegableAdmonLocalVO>();
            }
            request.setAttribute("listaTitReqPuesto", listaTitReqPuesto);

            // Desplegables externos
            DatosTablaDesplegableExtVO datosTablaDesplegableOcupaciones = MeLanbide11Manager.getInstance()
                    .getDatosMapeoDesplegableExterno(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_OCIN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            String tablaOcupaciones = datosTablaDesplegableOcupaciones.getTabla();
            String campoCodigoOcupaciones = datosTablaDesplegableOcupaciones.getCampoCodigo();
            String campoValorOcupaciones = datosTablaDesplegableOcupaciones.getCampoValor();
            List<DesplegableExternoVO> listaOcupacion = MeLanbide11Manager.getInstance().getValoresDesplegablesExternos(
                    tablaOcupaciones, campoCodigoOcupaciones, campoValorOcupaciones,
                    this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaOcupacion.size() > 0) {
                request.setAttribute("listaOcupacion", listaOcupacion);
            }
            DatosTablaDesplegableExtVO datosTablaDesplegableTitulaciones = MeLanbide11Manager.getInstance()
                    .getDatosMapeoDesplegableExterno(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_TIIN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            String tablaTitulaciones = datosTablaDesplegableTitulaciones.getTabla();
            String campoCodigoTitulaciones = datosTablaDesplegableTitulaciones.getCampoCodigo();
            String campoValorTitulaciones = datosTablaDesplegableTitulaciones.getCampoValor();
            List<DesplegableExternoVO> listaTitulacion = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesExternos(tablaTitulaciones, campoCodigoTitulaciones, campoValorTitulaciones,
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaTitulacion.size() > 0) {
                request.setAttribute("listaTitulacion", listaTitulacion);
            }
            DatosTablaDesplegableExtVO datosTablaDesplegableCProfesionales = MeLanbide11Manager.getInstance()
                    .getDatosMapeoDesplegableExterno(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_EXT_CPIN,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            String tablaCProfesionales = datosTablaDesplegableCProfesionales.getTabla();
            String campoCodigoCProfesionales = datosTablaDesplegableCProfesionales.getCampoCodigo();
            String campoValorCProfesionales = datosTablaDesplegableCProfesionales.getCampoValor();
            List<DesplegableExternoVO> listaCProfesionalidad = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesExternos(tablaCProfesionales, campoCodigoCProfesionales,
                            campoValorCProfesionales, this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaCProfesionalidad.size() > 0) {
                request.setAttribute("listaCProfesionalidad", listaCProfesionalidad);
            }
        } catch (Exception ex) {
            log.error("Error al tratar de preparar los datos para modificar y llamar la jsp de modificacion: "
                    + ex.getMessage(), ex);
        }
        return urlnuevaContratacion;

    }

    public void eliminarContratacion(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String codigoOperacion = "0";
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        String numExp = "";
        try {
            String id = (String) request.getParameter("id");
            if (id == null || id.equals("")) {
                codigoOperacion = "3";
            } else {
                numExp = request.getParameter("numExp").toString();
                AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
                int result = MeLanbide11Manager.getInstance().eliminarContratacion(id, adapt);
                if (result <= 0) {
                    codigoOperacion = "1";
                } else {
                    codigoOperacion = "0";
                    try {
                        lista = MeLanbide11Manager.getInstance().getDatosContratacion(numExp, codOrganizacion, adapt);
                    } catch (Exception ex) {
                        log.error("Error al recuperar la lista de contratación después de eliminar una contratación",
                                ex);
                    }
                }
            }
        } catch (Exception ex) {
            log.error("Error eliminando una contratación: " + ex.getMessage(), ex);
            codigoOperacion = "2";
        }
        String xmlSalida = null;
        xmlSalida = obtenerXmlSalidaContratacion(request, codigoOperacion, lista);
        retornarXML(xmlSalida, response);
    }

    public void crearNuevaContratacion(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String codigoOperacion = "0";
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();
        ContratacionVO nuevaContratacion = new ContratacionVO();
        try {
            AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));

            String numExp = (String) request.getParameter("expediente");

            String oferta = (String) request.getParameter("oferta");
            String idContrato1 = (String) request.getParameter("idContrato1");
            String idContrato2 = (String) request.getParameter("idContrato2");

            String dni = (String) request.getParameter("dni");
            String nombre = (String) request.getParameter("nombre");
            String apellido1 = (String) request.getParameter("apellido1");
            String apellido2 = (String) request.getParameter("apellido2");
            String fechaNacimiento = (String) request.getParameter("fechaNacimiento");
            String edad = (String) request.getParameter("edad");
            String sexo = (String) request.getParameter("sexo");
            String mayor55 = (String) request.getParameter("mayor55");
            String finFormativa = (String) request.getParameter("finFormativa");
            String codFormativa = (String) request.getParameter("codFormativa");
            String denFormativa = (String) request.getParameter("denFormativa");

            String puesto = (String) request.getParameter("puesto");
            String ocupacion = (String) request.getParameter("ocupacion");
            String desOcupacion = (String) request.getParameter("desOcupacion");
            String desOcupacionLibre = (String) request.getParameter("desOcupacionLibre");
            String desTitulacionLibre = (String) request.getParameter("desTitulacionLibre");
            String titulacion = (String) request.getParameter("titulacion");

            String cProfesionalidad = (String) request.getParameter("cProfesionalidad");
            String modalidadContrato = (String) request.getParameter("modalidadContrato");
            String jornada = (String) request.getParameter("jornada");
            String porcJornada = (String) request.getParameter("porcJornada").replace(",", ".");
            String horasConv = (String) request.getParameter("horasConv");
            String fechaInicio = (String) request.getParameter("fechaInicio");
            String fechaFin = (String) request.getParameter("fechaFin");
            String mesesContrato = (String) request.getParameter("mesesContrato");
            String grupoCotizacion = (String) request.getParameter("grupoCotizacion");
            String direccionCT = (String) request.getParameter("direccionCT");
            String numSS = (String) request.getParameter("numSS");
            String costeContrato = (String) request.getParameter("costeContrato").replace(",", ".");
            String tipRetribucion = (String) request.getParameter("tipRetribucion");

            String importeSub = (String) request.getParameter("importeSub").replace(",", ".");

            // === NUEVOS CAMPOS ===
            String titReqPuesto = (String) request.getParameter("titReqPuesto");
            String funciones = (String) request.getParameter("funciones");

            // === NUEVOS CAMPOS RSB ===
            String rsbSalBase = (String) request.getParameter("rsbSalBase");
            if (rsbSalBase != null)
                rsbSalBase = rsbSalBase.replace(",", ".");

            String rsbPagExtra = (String) request.getParameter("rsbPagExtra");
            if (rsbPagExtra != null)
                rsbPagExtra = rsbPagExtra.replace(",", ".");

            String rsbImporte = (String) request.getParameter("rsbImporte");
            if (rsbImporte != null)
                rsbImporte = rsbImporte.replace(",", ".");

            String rsbCompConv = (String) request.getParameter("rsbCompConv"); // Este contiene el TOTAL calculado
            if (rsbCompConv != null)
                rsbCompConv = rsbCompConv.replace(",", ".");

            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

            nuevaContratacion.setNumExp(numExp);

            nuevaContratacion.setOferta(oferta);
            nuevaContratacion.setIdContrato1(idContrato1);
            nuevaContratacion.setIdContrato2(idContrato2);

            nuevaContratacion.setDni(dni);
            nuevaContratacion.setNombre(nombre);
            nuevaContratacion.setApellido1(apellido1);
            nuevaContratacion.setApellido2(apellido2);
            if (fechaNacimiento != null && !"".equals(fechaNacimiento)) {
                nuevaContratacion.setFechaNacimiento(new java.sql.Date(formatoFecha.parse(fechaNacimiento).getTime()));
            }
            if (edad != null && !"".equals(edad)) {
                nuevaContratacion.setEdad(Integer.parseInt(edad));
            }
            nuevaContratacion.setSexo(sexo);
            nuevaContratacion.setMayor55(mayor55);
            nuevaContratacion.setFinFormativa(finFormativa);
            nuevaContratacion.setCodFormativa(codFormativa);
            nuevaContratacion.setDenFormativa(denFormativa);

            nuevaContratacion.setPuesto(puesto);
            nuevaContratacion.setOcupacion(ocupacion);
            nuevaContratacion.setDesOcupacion(desOcupacion);
            nuevaContratacion.setDesOcupacionLibre(desOcupacionLibre);

            // Mejorar manejo de campos de titulación para nueva contratación

            // Si desTitulacionLibre viene vacío, establecer como null
            if (desTitulacionLibre != null && !desTitulacionLibre.trim().equals("")) {
                nuevaContratacion.setDesTitulacionLibre(desTitulacionLibre.trim());
            } else {
                nuevaContratacion.setDesTitulacionLibre(null);
            }

            // Si titulacion viene vacío, establecer como null
            if (titulacion != null && !titulacion.trim().equals("")) {
                nuevaContratacion.setTitulacion(titulacion.trim());
            } else {
                nuevaContratacion.setTitulacion(null);
                nuevaContratacion.setFechaFin(new java.sql.Date(formatoFecha.parse(fechaFin).getTime()));
            }
            nuevaContratacion.setMesesContrato(mesesContrato);
            nuevaContratacion.setGrupoCotizacion(grupoCotizacion);
            nuevaContratacion.setDireccionCT(direccionCT);
            nuevaContratacion.setNumSS(numSS);
            if (costeContrato != null && !"".equals(costeContrato)) {
                nuevaContratacion.setCosteContrato(Double.parseDouble(costeContrato));
            }
            nuevaContratacion.setTipRetribucion(tipRetribucion);

            if (importeSub != null && !"".equals(importeSub)) {
                nuevaContratacion.setImporteSub(Double.parseDouble(importeSub));
            }

            // === SETEAR NUEVOS CAMPOS ===
            nuevaContratacion.setTitReqPuesto(titReqPuesto);
            nuevaContratacion.setFunciones(funciones);

            // === SETEAR CAMPOS RSB INDIVIDUALES ===

            if (rsbSalBase != null && !"".equals(rsbSalBase)) {
                nuevaContratacion.setRsbSalBase(Double.parseDouble(rsbSalBase));
            }

            if (rsbPagExtra != null && !"".equals(rsbPagExtra)) {
                nuevaContratacion.setRsbPagExtra(Double.parseDouble(rsbPagExtra));
            }

            if (rsbImporte != null && !"".equals(rsbImporte)) {
                nuevaContratacion.setRsbImporte(Double.parseDouble(rsbImporte));
            }

            // rsbCompConv ahora contiene el TOTAL calculado que se debe guardar en la BD
            if (rsbCompConv != null && !"".equals(rsbCompConv)) {
                nuevaContratacion.setRsbCompConv(Double.parseDouble(rsbCompConv));

                // Verificar que coincida con el cálculo interno
                Double totalCalculado = nuevaContratacion.getRsbComputableTotal();
                if (totalCalculado != null && Math.abs(Double.parseDouble(rsbCompConv) - totalCalculado) > 0.01) {
                    log.warn("ADVERTENCIA: Discrepancia entre total enviado (" + rsbCompConv + ") y total calculado ("
                            + totalCalculado + ")");
                }
            }

            MeLanbide11Manager meLanbide11Manager = MeLanbide11Manager.getInstance();
            boolean insertOK = meLanbide11Manager.crearNuevaContratacion(nuevaContratacion, adapt);
            if (insertOK) {
                lista = meLanbide11Manager.getDatosContratacion(numExp, codOrganizacion, adapt);
            } else {
                codigoOperacion = "1";
            }
        } catch (Exception ex) {
            log.error("Error al parsear los parametros recibidos del jsp al objeto ContratacionVO: " + ex.getMessage(),
                    ex);
            codigoOperacion = "2";
        }

        String xmlSalida = null;
        xmlSalida = obtenerXmlSalidaContratacion(request, codigoOperacion, lista);
        retornarXML(xmlSalida, response);
    }

    public void modificarContratacion(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String codigoOperacion = "0";
        List<ContratacionVO> lista = new ArrayList<ContratacionVO>();

        try {
            AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
            // Recojo los parametros
            String id = (String) request.getParameter("id");

            String numExp = (String) request.getParameter("expediente");

            String oferta = (String) request.getParameter("oferta");
            String idContrato1 = (String) request.getParameter("idContrato1");
            String idContrato2 = (String) request.getParameter("idContrato2");

            String dni = (String) request.getParameter("dni");
            String nombre = (String) request.getParameter("nombre");
            String apellido1 = (String) request.getParameter("apellido1");
            String apellido2 = (String) request.getParameter("apellido2");
            String fechaNacimiento = (String) request.getParameter("fechaNacimiento");
            String edad = (String) request.getParameter("edad");
            String sexo = (String) request.getParameter("sexo");
            String mayor55 = (String) request.getParameter("mayor55");
            String finFormativa = (String) request.getParameter("finFormativa");
            String codFormativa = (String) request.getParameter("codFormativa");
            String denFormativa = (String) request.getParameter("denFormativa");

            String puesto = (String) request.getParameter("puesto");
            String ocupacion = (String) request.getParameter("ocupacion");
            String desOcupacion = (String) request.getParameter("desOcupacion");
            String desOcupacionLibre = (String) request.getParameter("desOcupacionLibre");
            String desTitulacionLibre = (String) request.getParameter("desTitulacionLibre");
            String titulacion = (String) request.getParameter("titulacion");

            String cProfesionalidad = (String) request.getParameter("cProfesionalidad");
            String modalidadContrato = (String) request.getParameter("modalidadContrato");
            String jornada = (String) request.getParameter("jornada");
            String porcJornada = (String) request.getParameter("porcJornada").replace(",", ".");
            String horasConv = (String) request.getParameter("horasConv");
            String fechaInicio = (String) request.getParameter("fechaInicio");
            String fechaFin = (String) request.getParameter("fechaFin");
            String mesesContrato = (String) request.getParameter("mesesContrato");
            String grupoCotizacion = (String) request.getParameter("grupoCotizacion");
            String direccionCT = (String) request.getParameter("direccionCT");
            String numSS = (String) request.getParameter("numSS");
            String costeContrato = (String) request.getParameter("costeContrato").replace(",", ".");
            String tipRetribucion = (String) request.getParameter("tipRetribucion");

            String importeSub = (String) request.getParameter("importeSub").replace(",", ".");

            // === NUEVOS CAMPOS ===
            String titReqPuesto = (String) request.getParameter("titReqPuesto");
            String funciones = (String) request.getParameter("funciones");

            // === NUEVOS CAMPOS RSB ===
            String rsbSalBase = (String) request.getParameter("rsbSalBase");
            if (rsbSalBase != null)
                rsbSalBase = rsbSalBase.replace(",", ".");

            String rsbPagExtra = (String) request.getParameter("rsbPagExtra");
            if (rsbPagExtra != null)
                rsbPagExtra = rsbPagExtra.replace(",", ".");

            String rsbImporte = (String) request.getParameter("rsbImporte");
            if (rsbImporte != null)
                rsbImporte = rsbImporte.replace(",", ".");

            String rsbCompConv = (String) request.getParameter("rsbCompConv"); // Este contiene el TOTAL calculado
            if (rsbCompConv != null)
                rsbCompConv = rsbCompConv.replace(",", ".");

            if (id == null || id.equals("")) {
                codigoOperacion = "3";
            } else {
                log.info("========== INICIO OPERACION MODIFICAR CONTRATACION ==========");
                log.info("TIMESTAMP: " + new java.util.Date());
                log.info("PARAMETROS RECIBIDOS:");
                log.info("- id: " + id);
                log.info("- dni: " + dni);
                log.info("- nombre: " + nombre);
                log.info("- rsbCompConv (TOTAL): " + rsbCompConv);
                log.info("- titulacion: " + titulacion);
                log.info("- desTitulacionLibre: " + desTitulacionLibre);
                log.info("===============================================================");

                ContratacionVO datModif = MeLanbide11Manager.getInstance().getContratacionPorID(id, adapt);

                numExp = datModif.getNumExp();
                datModif.setId(Integer.parseInt(id));

                SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

                datModif.setNumExp(numExp);

                datModif.setOferta(oferta);
                datModif.setIdContrato1(idContrato1);
                datModif.setIdContrato2(idContrato2);

                datModif.setDni(dni);
                datModif.setNombre(nombre);
                datModif.setApellido1(apellido1);
                datModif.setApellido2(apellido2);
                datModif.setFechaNacimiento(null);
                if (fechaNacimiento != null && !"".equals(fechaNacimiento)) {
                    datModif.setFechaNacimiento(new java.sql.Date(formatoFecha.parse(fechaNacimiento).getTime()));
                }
                if (edad != null && !"".equals(edad)) {
                    datModif.setEdad(Integer.parseInt(edad));
                }
                datModif.setSexo(sexo);
                datModif.setMayor55(mayor55);
                datModif.setFinFormativa(finFormativa);
                datModif.setCodFormativa(codFormativa);
                datModif.setDenFormativa(denFormativa);

                datModif.setPuesto(puesto);
                datModif.setOcupacion(ocupacion);
                datModif.setDesOcupacion(desOcupacion);
                datModif.setDesOcupacionLibre(desOcupacionLibre);

                // Mejorar manejo de campos de titulación
                log.info("*** FLUJO RSB - PASO 2: SETEANDO CAMPOS DE TITULACION ***");

                // Si desTitulacionLibre viene vacío, mantener el valor original o null
                if (desTitulacionLibre != null && !desTitulacionLibre.trim().equals("")) {
                    datModif.setDesTitulacionLibre(desTitulacionLibre.trim());
                } else {
                    datModif.setDesTitulacionLibre(null);
                }

                // Si titulacion viene vacío, mantener el valor original o null
                if (titulacion != null && !titulacion.trim().equals("")) {
                    datModif.setTitulacion(titulacion.trim());
                } else {
                    datModif.setTitulacion(null);
                }

                // *** DATOS RSB COMPLETADOS ***
                log.info("Los datos RSB han sido procesados correctamente en la sección anterior.");
                log.info("*** FIN PASO 2 ***");

                datModif.setcProfesionalidad(cProfesionalidad);
                datModif.setModalidadContrato(modalidadContrato);
                datModif.setJornada(jornada);
                datModif.setPorcJornada(null);
                if (porcJornada != null && !"".equals(porcJornada)) {
                    datModif.setPorcJornada(Double.parseDouble(porcJornada));
                }
                if (horasConv != null && !"".equals(horasConv)) {
                    datModif.setHorasConv(Integer.parseInt(horasConv));
                }
                datModif.setFechaInicio(null);
                if (fechaInicio != null && !"".equals(fechaInicio)) {
                    datModif.setFechaInicio(new java.sql.Date(formatoFecha.parse(fechaInicio).getTime()));
                }
                datModif.setFechaFin(null);
                if (fechaFin != null && !"".equals(fechaFin)) {
                    datModif.setFechaFin(new java.sql.Date(formatoFecha.parse(fechaFin).getTime()));
                }
                datModif.setMesesContrato(mesesContrato);
                datModif.setGrupoCotizacion(grupoCotizacion);
                datModif.setDireccionCT(direccionCT);
                datModif.setNumSS(numSS);
                datModif.setCosteContrato(null);
                if (costeContrato != null && !"".equals(costeContrato)) {
                    datModif.setCosteContrato(Double.parseDouble(costeContrato));
                }
                datModif.setTipRetribucion(tipRetribucion);

                log.info("*** FLUJO RSB - PASO 1.5: ASIGNACION IMPSUBVCONT ***");
                log.info("Parámetro importeSub recibido: '" + importeSub + "'");
                log.info("IMPSUBVCONT ORIGINAL en datModif: "
                        + (datModif.getImporteSub() != null ? datModif.getImporteSub() : "NULL"));

                datModif.setImporteSub(null);
                if (importeSub != null && !"".equals(importeSub)) {
                    Double importeSubParsed = Double.parseDouble(importeSub);
                    datModif.setImporteSub(importeSubParsed);
                    log.info("IMPSUBVCONT ASIGNADO: " + importeSubParsed);
                } else {
                    log.info("IMPSUBVCONT ASIGNADO: NULL (parámetro vacío o null)");
                }

                log.info("IMPSUBVCONT FINAL en datModif: "
                        + (datModif.getImporteSub() != null ? datModif.getImporteSub() : "NULL"));
                log.info("*** FIN PASO 1.5 ***");

                // === SETEAR NUEVOS CAMPOS ===
                datModif.setTitReqPuesto(titReqPuesto);
                datModif.setFunciones(funciones);

                // === SETEAR CAMPOS RSB INDIVIDUALES ===

                if (rsbSalBase != null && !"".equals(rsbSalBase)) {
                    datModif.setRsbSalBase(Double.parseDouble(rsbSalBase));
                } else {
                    datModif.setRsbSalBase(null);
                }

                if (rsbPagExtra != null && !"".equals(rsbPagExtra)) {
                    datModif.setRsbPagExtra(Double.parseDouble(rsbPagExtra));
                } else {
                    datModif.setRsbPagExtra(null);
                }

                if (rsbImporte != null && !"".equals(rsbImporte)) {
                    datModif.setRsbImporte(Double.parseDouble(rsbImporte));
                } else {
                    datModif.setRsbImporte(null);
                }

                // rsbCompConv ahora contiene el TOTAL calculado que se debe guardar en la BD
                if (rsbCompConv != null && !"".equals(rsbCompConv)) {
                    datModif.setRsbCompConv(Double.parseDouble(rsbCompConv));

                    // Verificar que coincida con el cálculo interno
                    Double totalCalculado = datModif.getRsbComputableTotal();
                    if (totalCalculado != null && Math.abs(Double.parseDouble(rsbCompConv) - totalCalculado) > 0.01) {
                        log.warn("ADVERTENCIA: Discrepancia entre total enviado (" + rsbCompConv
                                + ") y total calculado (" + totalCalculado + ")");
                    }
                } else {
                    datModif.setRsbCompConv(null);
                }

                log.info("*** VERIFICACION IMPSUBVCONT DESPUES DE RSB ***");
                log.info("datModif.getImporteSub(): "
                        + (datModif.getImporteSub() != null ? datModif.getImporteSub() : "NULL"));
                log.info("datModif.getRsbComputableTotal(): "
                        + (datModif.getRsbComputableTotal() != null ? datModif.getRsbComputableTotal() : "NULL"));
                log.info("¿SON IGUALES ImporteSub y RsbTotal?: "
                        + (datModif.getImporteSub() != null && datModif.getRsbComputableTotal() != null
                                ? datModif.getImporteSub().equals(datModif.getRsbComputableTotal())
                                : "ALGUNO ES NULL"));
                log.info("*** FIN VERIFICACION ***");

                // *** FLUJO RSB - PASO 3: ANTES DE LLAMAR AL MANAGER ***
                log.info("*** FLUJO RSB - PASO 3: ANTES DE PERSISTIR EN BD ***");

                log.info("*** VERIFICACION FINAL ANTES DE PERSISTIR ***");
                log.info("ImporteSub FINAL: " + (datModif.getImporteSub() != null ? datModif.getImporteSub() : "NULL"));
                log.info("RsbComputableTotal FINAL: "
                        + (datModif.getRsbComputableTotal() != null ? datModif.getRsbComputableTotal() : "NULL"));
                log.info("*** FIN VERIFICACION FINAL ***");

                log.info("*** FIN PASO 3 ***");

                MeLanbide11Manager meLanbide11Manager = MeLanbide11Manager.getInstance();
                boolean modOK = meLanbide11Manager.modificarContratacion(datModif, adapt);

                // *** FLUJO RSB - PASO 4: DESPUES DE PERSISTIR ***
                log.info("*** FLUJO RSB - PASO 4: DESPUES DE PERSISTIR EN BD ***");
                if (!modOK) {
                    log.error("ERROR: La modificación en BD falló!");
                }
                log.info("*** FIN PASO 4 ***");

                if (modOK) {
                    try {
                        // *** FLUJO RSB - PASO 5: ANTES DE RECUPERAR LISTA ***
                        log.info("*** FLUJO RSB - PASO 5: ANTES DE RECUPERAR LISTA ACTUALIZADA ***");
                        lista = meLanbide11Manager.getDatosContratacion(numExp, codOrganizacion, adapt);

                        // *** FLUJO RSB - PASO 6: DESPUES DE RECUPERAR LISTA ***
                        log.info("*** FLUJO RSB - PASO 6: LISTA RECUPERADA DE BD ***");
                        if (lista != null && !lista.isEmpty()) {
                            for (ContratacionVO item : lista) {
                                if (item.getId().toString().equals(id)) {
                                    log.info("=== CONTRATACION ENCONTRADA PARA XML ===");
                                    break;
                                }
                            }
                        } else {
                            log.error("ERROR: Lista recuperada está vacía o es NULL!");
                        }
                        log.info("*** FIN PASO 6 ***");
                    } catch (BDException bde) {
                        codigoOperacion = "1";
                    } catch (Exception ex) {
                        codigoOperacion = "2";
                    }
                } else {
                    codigoOperacion = "2";
                }
            }

        } catch (Exception ex) {
            codigoOperacion = "2";
        }

        // *** FLUJO RSB - PASO 7: ANTES DE CONSTRUIR XML ***
        log.info("*** FLUJO RSB - PASO 7: ANTES DE CONSTRUIR XML DE RESPUESTA ***");
        if (lista != null && !lista.isEmpty()) {
            // Lista cargada correctamente
        } else {
            // Lista vacía o null
        }
        log.info("*** FIN PASO 7 ***");

        String xmlSalida = null;
        xmlSalida = obtenerXmlSalidaContratacion(request, codigoOperacion, lista);

        // *** FLUJO RSB - PASO 8: XML CONSTRUIDO ***
        log.info("*** FLUJO RSB - PASO 8: XML DE RESPUESTA CONSTRUIDO ***");
        if (xmlSalida != null && xmlSalida.contains("RSBCOMPUTABLE")) {
            // XML contiene campos RSBCOMPUTABLE
        } else {
            // XML no contiene campos RSBCOMPUTABLE o es NULL
        }
        log.info("*** FIN PASO 8 ***");

        log.info("========== FIN OPERACION MODIFICAR CONTRATACION ==========");
        log.info("RESULTADO FINAL - Código: " + codigoOperacion);
        log.info("==============================================================");

        retornarXML(xmlSalida, response);

    }

    public String cargarNuevaMinimis(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String nuevo = "1";
        String numExp = "";
        String urlnuevaMinimis = "/jsp/extension/melanbide11/nuevoMinimis.jsp?codOrganizacion=" + codOrganizacion;
        try {
            if (request.getAttribute("nuevo") != null) {
                if (request.getAttribute("nuevo").toString().equals("0")) {
                    request.setAttribute("nuevo", nuevo);
                }
            } else {
                request.setAttribute("nuevo", nuevo);
            }
            if (request.getParameter("numExp") != null) {
                numExp = request.getParameter("numExp").toString();
                request.setAttribute("numExp", numExp);
            }
            // Cargamos en el request los valores de los desplegables
            List<DesplegableAdmonLocalVO> listaEstado = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTSV,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaEstado.size() > 0) {
                listaEstado = traducirDesplegable(request, listaEstado);
                request.setAttribute("listaEstado", listaEstado);
            }

        } catch (Exception ex) {
            // Error al preparar nueva minimis
        }
        return urlnuevaMinimis;
    }

    public String cargarModificarMinimis(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        String nuevo = "0";
        String urlnuevaMinimis = "/jsp/extension/melanbide11/nuevoMinimis.jsp?codOrganizacion=" + codOrganizacion;
        try {
            if (request.getAttribute("nuevo") != null) {
                if (!request.getAttribute("nuevo").toString().equals("0")) {
                    request.setAttribute("nuevo", nuevo);
                }
            } else {
                request.setAttribute("nuevo", nuevo);
            }
            String id = request.getParameter("id");
            // Recuperramos datos e Acceso a modificar y cargamos en el request
            if (id != null && !id.equals("")) {
                MinimisVO datModif = MeLanbide11Manager.getInstance().getMinimisPorID(id,
                        this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
                if (datModif != null) {
                    request.setAttribute("datModif", datModif);
                }
            }
            // Cargamos el el request los valores de los desplegables
            List<DesplegableAdmonLocalVO> listaEstado = MeLanbide11Manager.getInstance()
                    .getValoresDesplegablesAdmonLocalxdes_cod(
                            ConfigurationParameter.getParameter(ConstantesMeLanbide11.COD_DES_DTSV,
                                    ConstantesMeLanbide11.FICHERO_PROPIEDADES),
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
            if (listaEstado.size() > 0) {
                listaEstado = traducirDesplegable(request, listaEstado);
                request.setAttribute("listaEstado", listaEstado);
            }
        } catch (Exception ex) {
            // Error al cargar modificar minimis
        }
        return urlnuevaMinimis;

    }

    public void eliminarMinimis(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String codigoOperacion = "0";
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        String numExp = "";
        try {
            String id = (String) request.getParameter("id");
            if (id == null || id.equals("")) {
                codigoOperacion = "3";
            } else {
                numExp = request.getParameter("numExp").toString();
                AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
                int result = MeLanbide11Manager.getInstance().eliminarMinimis(id, adapt);
                if (result <= 0) {
                    codigoOperacion = "1";
                } else {
                    codigoOperacion = "0";
                    try {
                        lista = MeLanbide11Manager.getInstance().getDatosMinimis(numExp, codOrganizacion, adapt);
                    } catch (Exception ex) {
                    }
                }
            }
        } catch (Exception ex) {
            codigoOperacion = "2";
        }
        String xmlSalida = null;
        xmlSalida = obtenerXmlSalidaMinimis(request, codigoOperacion, lista);
        retornarXML(xmlSalida, response);
    }

    public void crearNuevaMinimis(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String codigoOperacion = "0";
        List<MinimisVO> lista = new ArrayList<MinimisVO>();
        MinimisVO nuevaMinimis = new MinimisVO();
        try {
            AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));

            String numExp = (String) request.getParameter("expediente");

            String estado = (String) request.getParameter("estado");
            String organismo = (String) request.getParameter("organismo");
            String objeto = (String) request.getParameter("objeto");
            String importe = (String) request.getParameter("importe").replace(",", ".");
            String fecha = (String) request.getParameter("fecha");

            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

            nuevaMinimis.setNumExp(numExp);

            nuevaMinimis.setEstado(estado);
            nuevaMinimis.setOrganismo(organismo);
            nuevaMinimis.setObjeto(objeto);
            if (importe != null && !"".equals(importe)) {
                nuevaMinimis.setImporte(Double.parseDouble(importe));
            }
            if (fecha != null && !"".equals(fecha)) {
                nuevaMinimis.setFecha(new java.sql.Date(formatoFecha.parse(fecha).getTime()));
            }

            MeLanbide11Manager meLanbide11Manager = MeLanbide11Manager.getInstance();
            boolean insertOK = meLanbide11Manager.crearNuevaMinimis(nuevaMinimis, adapt);
            if (insertOK) {
                lista = meLanbide11Manager.getDatosMinimis(numExp, codOrganizacion, adapt);

            } else {
                codigoOperacion = "1";
            }
        } catch (Exception ex) {
            codigoOperacion = "2";
        }

        String xmlSalida = null;
        xmlSalida = obtenerXmlSalidaMinimis(request, codigoOperacion, lista);
        retornarXML(xmlSalida, response);
    }

    public void modificarMinimis(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String codigoOperacion = "0";
        List<MinimisVO> lista = new ArrayList<MinimisVO>();

        try {
            AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
            // Recojo los parametros
            String id = (String) request.getParameter("id");

            String numExp = (String) request.getParameter("expediente");

            String estado = (String) request.getParameter("estado");
            String organismo = (String) request.getParameter("organismo");
            String objeto = (String) request.getParameter("objeto");
            String importe = (String) request.getParameter("importe").replace(",", ".");
            String fecha = (String) request.getParameter("fecha");

            if (id == null || id.equals("")) {
                codigoOperacion = "3";
            } else {
                MinimisVO datModif = MeLanbide11Manager.getInstance().getMinimisPorID(id, adapt);
                numExp = datModif.getNumExp();
                datModif.setId(Integer.parseInt(id));

                SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

                datModif.setNumExp(numExp);

                datModif.setEstado(estado);
                datModif.setOrganismo(organismo);
                datModif.setObjeto(objeto);
                if (importe != null && !"".equals(importe)) {
                    datModif.setImporte(Double.parseDouble(importe));
                }
                if (fecha != null && !"".equals(fecha)) {
                    datModif.setFecha(new java.sql.Date(formatoFecha.parse(fecha).getTime()));
                }

                MeLanbide11Manager meLanbide11Manager = MeLanbide11Manager.getInstance();
                boolean modOK = meLanbide11Manager.modificarMinimis(datModif, adapt);
                if (modOK) {
                    try {
                        lista = meLanbide11Manager.getDatosMinimis(numExp, codOrganizacion, adapt);
                    } catch (BDException bde) {
                        codigoOperacion = "1";
                    } catch (Exception ex) {
                        codigoOperacion = "2";
                    }
                } else {
                    codigoOperacion = "2";
                }
            }

        } catch (Exception ex) {
            codigoOperacion = "2";
        }

        String xmlSalida = null;
        xmlSalida = obtenerXmlSalidaMinimis(request, codigoOperacion, lista);
        retornarXML(xmlSalida, response);

    }

    // Funciones Privadas
    private AdaptadorSQLBD getAdaptSQLBD(String codOrganizacion) throws SQLException {
        if (log.isDebugEnabled()) {
        }
        ResourceBundle config = ResourceBundle.getBundle("techserver");
        String gestor = config.getString("CON.gestor");
        String jndiGenerico = config.getString("CON.jndi");
        Connection conGenerico = null;
        Statement st = null;
        ResultSet rs = null;
        String[] salida = null;
        Connection con = null;

        if (log.isDebugEnabled()) {
        } // if(log.isDebugEnabled())

        DataSource ds = null;
        AdaptadorSQLBD adapt = null;
        synchronized (this) {
            try {
                PortableContext pc = PortableContext.getInstance();
                if (log.isDebugEnabled()) {
                }
                ds = (DataSource) pc.lookup(jndiGenerico, DataSource.class);
                // Conexiï¿½n al esquema genï¿½rico
                conGenerico = ds.getConnection();

                String sql = "SELECT EEA_BDE FROM A_EEA WHERE EEA_APL=" + ConstantesDatos.APP_GESTION_EXPEDIENTES
                        + " AND AAE_ORG=" + codOrganizacion;
                st = conGenerico.createStatement();
                rs = st.executeQuery(sql);
                String jndi = null;
                while (rs.next()) {
                    jndi = rs.getString("EEA_BDE");
                } // while(rs.next())

                st.close();
                rs.close();
                conGenerico.close();

                if (jndi != null && gestor != null && !"".equals(jndi) && !"".equals(gestor)) {
                    salida = new String[7];
                    salida[0] = gestor;
                    salida[1] = "";
                    salida[2] = "";
                    salida[3] = "";
                    salida[4] = "";
                    salida[5] = "";
                    salida[6] = jndi;
                    adapt = new AdaptadorSQLBD(salida);
                } // if(jndi!=null && gestor!=null && !"".equals(jndi) && !"".equals(gestor))
            } catch (TechnicalException te) {
                te.printStackTrace();
                log.error("*** AdaptadorSQLBD: " + te.toString());
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (st != null) {
                    st.close();
                }
                if (rs != null) {
                    rs.close();
                }
                if (conGenerico != null && !conGenerico.isClosed()) {
                    conGenerico.close();
                }
            } // finally
            if (log.isDebugEnabled()) {
            }
        } // synchronized
        return adapt;
    }// getConnection

    private String getDescripcionDesplegable(HttpServletRequest request, String descripcionCompleta) {
        String descripcion = descripcionCompleta;

        String barraSeparadoraDobleIdiomaDesple = ConfigurationParameter.getParameter(
                ConstantesMeLanbide11.BARRA_SEPARADORA_IDIOMA_DESPLEGABLES, ConstantesMeLanbide11.FICHERO_PROPIEDADES);

        try {
            if (!descripcion.isEmpty()) {

                String[] descripcionDobleIdioma = (descripcion != null
                        ? descripcion.split(barraSeparadoraDobleIdiomaDesple)
                        : null);
                if (descripcionDobleIdioma != null && descripcionDobleIdioma.length > 1) {
                    if (getIdioma(request) == ConstantesMeLanbide11.CODIGO_IDIOMA_EUSKERA) {
                        descripcion = descripcionDobleIdioma[1];
                    } else {
                        // Cogemos la primera posicion que deberia ser castellano
                        descripcion = descripcionDobleIdioma[0];
                    }
                }

            } else {
                descripcion = "-";
            }
            return descripcion;
        } catch (Exception e) {
            return descripcion;
        }

    }

    private int getIdioma(HttpServletRequest request) {
        // Recuperamos el Idioma de la request para la gestion de Desplegables
        UsuarioValueObject usuario = new UsuarioValueObject();
        int idioma = ConstantesMeLanbide11.CODIGO_IDIOMA_CASTELLANO; // Por Defecto 1 Castellano
        try {

            if (request != null && request.getSession() != null) {
                usuario = (UsuarioValueObject) request.getSession().getAttribute("usuario");
                if (usuario != null) {
                    idioma = usuario.getIdioma();
                }
            }
        } catch (Exception ex) {
            log.error("Error al recuperar el idioma del usuario de la request, asignamos por defecto 1 Castellano", ex);
            idioma = ConstantesMeLanbide11.CODIGO_IDIOMA_CASTELLANO;
        }

        return idioma;
    }

    private String bytesToHex(byte[] bytes) {
        char[] hexArray = "0123456789ABCDEF".toCharArray();

        char[] hexChars = new char[bytes.length * 2];

        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    // ----------------------------------------------------------------------------------------------------------
    // --------------- XML
    // --------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------------
    private void retornarXML(String salida, HttpServletResponse response) {
        try {
            if (salida != null) {
                response.setContentType("text/xml");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(salida);
                out.flush();
                out.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String obtenerXmlSalidaContratacion(HttpServletRequest request, String codigoOperacion,
            List<ContratacionVO> lista) {
        StringBuffer xmlSalida = new StringBuffer();
        xmlSalida.append("<RESPUESTA>");
        xmlSalida.append("<CODIGO_OPERACION>");
        xmlSalida.append(codigoOperacion);
        xmlSalida.append("</CODIGO_OPERACION>");
        for (ContratacionVO fila : lista) {
            xmlSalida.append("<FILA>");
            xmlSalida.append("<ID>");
            xmlSalida.append(fila.getId() != null ? fila.getId().toString() : "");
            xmlSalida.append("</ID>");

            xmlSalida.append("<NOFECONT>");
            xmlSalida.append(fila.getOferta());
            xmlSalida.append("</NOFECONT>");
            xmlSalida.append("<IDCONT1>");
            xmlSalida.append(fila.getIdContrato1());
            xmlSalida.append("</IDCONT1>");
            xmlSalida.append("<IDCONT2>");
            xmlSalida.append(fila.getIdContrato2());
            xmlSalida.append("</IDCONT2>");

            xmlSalida.append("<DNICONT>");
            xmlSalida.append(fila.getDni());
            xmlSalida.append("</DNICONT>");
            xmlSalida.append("<NOMCONT>");
            xmlSalida.append(fila.getNombre());
            xmlSalida.append("</NOMCONT>");
            xmlSalida.append("<APE1CONT>");
            xmlSalida.append(fila.getApellido1());
            xmlSalida.append("</APE1CONT>");
            xmlSalida.append("<APE2CONT>");
            xmlSalida.append(fila.getApellido2());
            xmlSalida.append("</APE2CONT>");
            xmlSalida.append("<FECHNACCONT>");
            if (fila.getFechaNacimiento() != null) {
                xmlSalida.append(dateFormat.format(fila.getFechaNacimiento()));
            } else {
                xmlSalida.append("");
            }
            xmlSalida.append("</FECHNACCONT>");
            xmlSalida.append("<EDADCONT>");
            if (fila.getEdad() != null && !"".equals(fila.getEdad())) {
                xmlSalida.append(fila.getEdad());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</EDADCONT>");
            xmlSalida.append("<SEXOCONT>");
            xmlSalida.append(getDescripcionDesplegable(request, fila.getDesSexo()));
            xmlSalida.append("</SEXOCONT>");
            xmlSalida.append("<MAY55CONT>");
            xmlSalida.append(fila.getMayor55());
            xmlSalida.append("</MAY55CONT>");
            xmlSalida.append("<ACCFORCONT>");
            xmlSalida.append(fila.getFinFormativa());
            xmlSalida.append("</ACCFORCONT>");
            xmlSalida.append("<CODFORCONT>");
            xmlSalida.append(fila.getCodFormativa());
            xmlSalida.append("</CODFORCONT>");
            xmlSalida.append("<DENFORCONT>");
            xmlSalida.append(fila.getDenFormativa());
            xmlSalida.append("</DENFORCONT>");

            xmlSalida.append("<PUESTOCONT>");
            xmlSalida.append(fila.getPuesto());
            xmlSalida.append("</PUESTOCONT>");
            xmlSalida.append("<CODOCUCONT>");
            xmlSalida.append(fila.getOcupacion());
            xmlSalida.append("</CODOCUCONT>");
            xmlSalida.append("<OCUCONT>");
            if (fila.getDesOcupacionLibre() != null && !"".equals(fila.getDesOcupacionLibre())) {
                xmlSalida.append(fila.getDesOcupacionLibre());
            } else {
                xmlSalida.append(fila.getDesOcupacion());
            }
            xmlSalida.append("</OCUCONT>");
            xmlSalida.append("<CPROFESIONALIDAD>");
            xmlSalida.append(fila.getDesCProfesionalidad());
            xmlSalida.append("</CPROFESIONALIDAD>");
            xmlSalida.append("<MODCONT>");
            xmlSalida.append(fila.getModalidadContrato());
            xmlSalida.append("</MODCONT>");
            xmlSalida.append("<JORCONT>");
            xmlSalida.append(getDescripcionDesplegable(request, fila.getDesJornada()));
            xmlSalida.append("</JORCONT>");
            xmlSalida.append("<PORCJOR>");
            if (fila.getPorcJornada() != null && !"".equals(fila.getPorcJornada())) {
                xmlSalida.append(fila.getPorcJornada());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</PORCJOR>");
            xmlSalida.append("<HORASCONV>");
            if (fila.getHorasConv() != null && !"".equals(fila.getHorasConv())) {
                xmlSalida.append(fila.getHorasConv());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</HORASCONV>");
            xmlSalida.append("<FECHINICONT>");
            if (fila.getFechaInicio() != null) {
                xmlSalida.append(dateFormat.format(fila.getFechaInicio()));
            } else {
                xmlSalida.append("");
            }
            xmlSalida.append("</FECHINICONT>");
            xmlSalida.append("<FECHFINCONT>");
            if (fila.getFechaFin() != null) {
                xmlSalida.append(dateFormat.format(fila.getFechaFin()));
            } else {
                xmlSalida.append("");
            }
            xmlSalida.append("</FECHFINCONT>");
            xmlSalida.append("<DURCONT>");
            if (fila.getMesesContrato() != null && !"".equals(fila.getMesesContrato())) {
                xmlSalida.append(fila.getMesesContrato());
            } else {
                xmlSalida.append("-");
            }
            xmlSalida.append("</DURCONT>");
            xmlSalida.append("<GRSS>");
            xmlSalida.append(getDescripcionDesplegable(request, fila.getDesGrupoCotizacion()));
            xmlSalida.append("</GRSS>");
            xmlSalida.append("<DIRCENTRCONT>");
            xmlSalida.append(fila.getDireccionCT());
            xmlSalida.append("</DIRCENTRCONT>");
            xmlSalida.append("<NSSCONT>");
            xmlSalida.append(fila.getNumSS());
            xmlSalida.append("</NSSCONT>");
            xmlSalida.append("<CSTCONT>");
            if (fila.getCosteContrato() != null && !"".equals(fila.getCosteContrato())) {
                xmlSalida.append(fila.getCosteContrato());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</CSTCONT>");
            xmlSalida.append("<TIPRSB>");
            xmlSalida.append(getDescripcionDesplegable(request, fila.getDesTipRetribucion()));
            xmlSalida.append("</TIPRSB>");

            // Añadir campos RSB antes del importe de subvención
            xmlSalida.append("<RSBSALBASE>");
            if (fila.getRsbSalBase() != null && !"".equals(fila.getRsbSalBase())) {
                xmlSalida.append(fila.getRsbSalBase());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</RSBSALBASE>");

            xmlSalida.append("<RSBPAGEXTRA>");
            if (fila.getRsbPagExtra() != null && !"".equals(fila.getRsbPagExtra())) {
                xmlSalida.append(fila.getRsbPagExtra());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</RSBPAGEXTRA>");

            xmlSalida.append("<RSBCOMPCONV>");
            if (fila.getRsbCompConv() != null && !"".equals(fila.getRsbCompConv())) {
                xmlSalida.append(fila.getRsbCompConv());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</RSBCOMPCONV>");

            // Campo calculado - Retribución salarial bruta computable total
            xmlSalida.append("<RSBCOMPUTABLE>");
            if (fila.getRsbComputableTotal() != null) {
                xmlSalida.append(fila.getRsbComputableTotal());
                log.info("*** XML RSB *** RSBCOMPUTABLE CALCULADO para ID " + fila.getId() + ": "
                        + fila.getRsbComputableTotal());
            } else {
                xmlSalida.append("null");
                log.warn("*** XML RSB *** RSBCOMPUTABLE es NULL para ID " + fila.getId());
            }
            xmlSalida.append("</RSBCOMPUTABLE>");

            log.info("*** COMPARACION VALORES ANTES DE IMPSUBVCONT - ID " + fila.getId() + " ***");
            log.info("- RSBCOMPUTABLE (RSB Total): "
                    + (fila.getRsbComputableTotal() != null ? fila.getRsbComputableTotal() : "NULL"));
            log.info("- IMPSUBVCONT (Importe Sub): " + (fila.getImporteSub() != null ? fila.getImporteSub() : "NULL"));
            log.info("- SON IGUALES?: " + (fila.getRsbComputableTotal() != null && fila.getImporteSub() != null
                    ? fila.getRsbComputableTotal().equals(fila.getImporteSub())
                    : "ALGUNO ES NULL"));

            xmlSalida.append("<IMPSUBVCONT>");
            if (fila.getImporteSub() != null && !"".equals(fila.getImporteSub())) {
                xmlSalida.append(fila.getImporteSub());
                log.info("*** XML *** IMPSUBVCONT para ID " + fila.getId() + ": " + fila.getImporteSub()
                        + " (ENVIADO AL XML)");
            } else {
                xmlSalida.append("null");
                log.warn("*** XML *** IMPSUBVCONT para ID " + fila.getId() + ": NULL/VACIO - ENVIANDO 'null'");
            }
            xmlSalida.append("</IMPSUBVCONT>");

            // === CAMPOS DE TITULACION ===
            xmlSalida.append("<DESTITULACION>");
            if (fila.getDesTitulacionLibre() != null && !"".equals(fila.getDesTitulacionLibre())) {
                xmlSalida.append(fila.getDesTitulacionLibre());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</DESTITULACION>");

            xmlSalida.append("<TITULACION>");
            if (fila.getTitulacion() != null && !"".equals(fila.getTitulacion())) {
                xmlSalida.append(fila.getTitulacion());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</TITULACION>");

            xmlSalida.append("</FILA>");
        }
        xmlSalida.append("</RESPUESTA>");
        return xmlSalida.toString();
    }

    private String obtenerXmlSalidaMinimis(HttpServletRequest request, String codigoOperacion, List<MinimisVO> lista) {
        StringBuffer xmlSalida = new StringBuffer();
        xmlSalida.append("<RESPUESTA>");
        xmlSalida.append("<CODIGO_OPERACION>");
        xmlSalida.append(codigoOperacion);
        xmlSalida.append("</CODIGO_OPERACION>");
        for (MinimisVO fila : lista) {
            xmlSalida.append("<FILA>");
            xmlSalida.append("<ID>");
            xmlSalida.append(fila.getId() != null ? fila.getId().toString() : "");
            xmlSalida.append("</ID>");

            xmlSalida.append("<ESTADO>");
            xmlSalida.append(fila.getEstado());
            xmlSalida.append("</ESTADO>");
            xmlSalida.append("<ORGANISMO>");
            xmlSalida.append(fila.getOrganismo());
            xmlSalida.append("</ORGANISMO>");
            xmlSalida.append("<OBJETO>");
            xmlSalida.append(fila.getObjeto());
            xmlSalida.append("</OBJETO>");
            xmlSalida.append("<IMPORTE>");
            if (fila.getImporte() != null && !"".equals(fila.getImporte())) {
                xmlSalida.append(fila.getImporte());
            } else {
                xmlSalida.append("null");
            }
            xmlSalida.append("</IMPORTE>");

            xmlSalida.append("<FECHA>");
            if (fila.getFecha() != null) {
                xmlSalida.append(dateFormat.format(fila.getFecha()));
            } else {
                xmlSalida.append("");
            }
            xmlSalida.append("</FECHA>");

            xmlSalida.append("</FILA>");
        }
        xmlSalida.append("</RESPUESTA>");
        return xmlSalida.toString();
    }

    /**
     * Obtiene los complementos salariales y extrasalariales por separado para un
     * expediente y DNI
     */
    public String getComplementosPorTipo(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        try {
            String dni = request.getParameter("dni");
            String numExp = request.getParameter("numExp");

            if (numExp == null) {
                numExp = numExpediente;
            }

            AdaptadorSQLBD adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
            ComplementosPorTipo complementos = null;
            try {
                complementos = MeLanbide11Manager.getInstance().getSumaComplementosPorTipo(numExp, dni, adapt);
            } catch (Exception daoEx) {
                log.error("[getComplementosPorTipo] Error DAO obteniendo complementos", daoEx);
            }
            if (complementos == null) {
                log.warn("[getComplementosPorTipo] complementos es null -> se devuelven 0,0");
                // Crear dummy para evitar NPE
                complementos = new ComplementosPorTipo(0d, 0d);
            }

            // Crear respuesta JSON simple
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"salariales\":").append(complementos.getSalariales()).append(",");
            json.append("\"extrasalariales\":").append(complementos.getExtrasalariales());
            json.append("}");

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            PrintWriter out = response.getWriter();
            out.print(json.toString()); // no cerramos explícitamente para que el contenedor gestione
            out.flush();
            // No navegamos a JSP: respuesta directa JSON
            return null;
        } catch (Exception ex) {
            log.error("Error al obtener complementos por tipo", ex);
            try {
                response.setContentType("application/json; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Expires", "0");
                PrintWriter out = response.getWriter();
                out.print("{\"salariales\":0,\"extrasalariales\":0,\"error\":\"Error interno del servidor\"}");
                out.flush();
                return null;
            } catch (Exception e) {
                log.error("Error al enviar respuesta de error", e);
            }
        }
        return null;
    }

    /**
     * Nueva acción para la pantalla de Desglose RSB (modal con pestañas). Alineada
     * con la llamada usando parametro operacion=cargarDesgloseRSB. Coloca en
     * request los atributos necesarios y define las URLs de las pestañas.
     */
    public String cargarDesgloseRSB(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String numExp = null;
        String idProyecto = null;
        String idContrato = null;
        try {
            numExp = request.getParameter("numExp");
            if (numExp == null || numExp.trim().isEmpty()) {
                numExp = numExpediente;
            }
            idProyecto = request.getParameter("idProyecto");
            idContrato = request.getParameter("id");

            request.setAttribute("numExp", numExp);
            request.setAttribute("idProyecto", idProyecto);
            if (idContrato != null && idContrato.trim().length() > 0) {
                request.setAttribute("id", idContrato); // Necesario para Tab1
            }

            try {
                if (idContrato != null && idContrato.trim().length() > 0) {
                    ContratacionVO vo = MeLanbide11Manager.getInstance().getContratacionPorID(idContrato,
                            this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
                    if (vo != null) {
                        if (vo.getRsbSalBase() != null) {
                            request.setAttribute("salarioBase", String.valueOf(vo.getRsbSalBase()).replace('.', ','));
                        }
                        if (vo.getRsbPagExtra() != null) {
                            request.setAttribute("pagasExtra", String.valueOf(vo.getRsbPagExtra()).replace('.', ','));
                        }
                        // El campo RSBIMPORTE en tabla contratacion lo usamos como "Complementos
                        // salariales" persistidos
                        if (vo.getRsbImporte() != null) {
                            request.setAttribute("compImporte", String.valueOf(vo.getRsbImporte()).replace('.', ','));
                        }
                        // Complementos extrasalariales: SIEMPRE se calculan desde la tabla de desglose
                        // por RSBTIPO=2
                        try {
                            String dni = vo.getDni();
                            if (dni != null && !dni.trim().isEmpty()) {
                                ComplementosPorTipo comp = MeLanbide11Manager.getInstance().getSumaComplementosPorTipo(
                                        numExp, dni, this.getAdaptSQLBD(String.valueOf(codOrganizacion)));
                                if (comp != null) {
                                    // Salariales (tipo 1) se usan solo como referencia para comparar con RSBIMPORTE
                                    // si se quisiera.
                                    double extras = comp.getExtrasalariales();
                                    request.setAttribute("compExtra", String.valueOf(extras).replace('.', ','));
                                    if (log.isDebugEnabled()) {
                                        // Debug de complementos
                                    }
                                } else {
                                    request.setAttribute("compExtra", "0");
                                }
                            }
                        } catch (Exception calcEx) {
                            log.warn("[cargarDesgloseRSB] No se pudieron calcular complementos extrasalariales",
                                    calcEx);
                        }
                    }
                }
            } catch (Exception inner) {
                log.warn("[cargarDesgloseRSB] Error cargando datos iniciales de contratación para pestaña 1", inner);
            }

            request.setAttribute("urlPestanaResumen", "/jsp/extension/melanbide11/desglose/m11Desglose_Tab1.jsp");
            request.setAttribute("urlPestanaComplementos", "/jsp/extension/melanbide11/desglose/m11Desglose_Tab2.jsp");
        } catch (Exception e) {
            log.error("Error en cargarDesgloseRSB", e);
        }
        return "/jsp/extension/melanbide11/desglose/m11Desglose.jsp";
    }

    /**
     * Operación AJAX invocada desde la pestaña 1 para guardar los campos básicos
     * del RSB (salario base, pagas extra y total complementos salariales). Recibe
     * parámetros: idRegistro (ID de la contratación), rsbSalBase, rsbPagasExtra,
     * rsbCompImporte. Devuelve JSON mínimo con codigoOperacion 0 si OK.
     */
    public String guardarDesgloseRSB(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        AdaptadorSQLBD adapt = null;
        try {
            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
        } catch (Exception ex) {
            log.error("Error obteniendo adaptador BBDD", ex);
        }
        String idRegistro = request.getParameter("idRegistro"); // ID de la contratación
        String sSalBase = request.getParameter("rsbSalBase");
        String sPagas = request.getParameter("rsbPagasExtra");
        String sComp = request.getParameter("rsbCompImporte"); // Complementos salariales (principal)
        // Extrasalariales solo informativos: no se persisten aquí (vienen del detalle)

        Double vSalBase = parseDoubleSafe(sSalBase);
        Double vPagas = parseDoubleSafe(sPagas);
        Double vComp = parseDoubleSafe(sComp);

        int codigoOperacion = 0; // 0 OK,1=BD,2=Sin filas,3=Parámetros,4=Genérico
        double salariales = 0d;
        double extrasalariales = 0d;
        if (adapt == null) {
            codigoOperacion = 4; // sin adaptador
        } else if (idRegistro == null || idRegistro.trim().isEmpty()) {
            codigoOperacion = 3; // parámetros
        } else {
            try {
                boolean ok = MeLanbide11Manager.getInstance().guardarDesgloseBasico(idRegistro, vSalBase, vPagas, vComp,
                        adapt);
                if (!ok) {
                    codigoOperacion = 2; // no se actualizó ninguna fila (ID inexistente?)
                } else {
                    // Recuperar totales detallados para refresco rápido (si tenemos numExp/dni se
                    // podría ampliar)
                }
            } catch (Exception e) {
                log.error("[guardarDesgloseRSB] Error BD", e);
                codigoOperacion = 1; // error BD
            }
        }
        try {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            PrintWriter out = response.getWriter();
            String json = new StringBuilder().append("{\"resultado\":{\"codigoOperacion\":\"").append(codigoOperacion)
                    .append("\",\"salariales\":").append(salariales).append(",\"extrasalariales\":")
                    .append(extrasalariales).append("}}").toString();
            out.print(json);
            out.flush();
            return null;
        } catch (Exception e) {
            log.error("Error enviando respuesta JSON guardarDesgloseRSB", e);
        }
        return null;
    }

    private Double parseDoubleSafe(String val) {
        try {
            if (val == null || val.trim().length() == 0)
                return null;
            return new Double(val.replace(',', '.'));
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Operación AJAX para reemplazar las líneas del desglose (pestaña 2).
     * Parámetros esperados: - numExp - dni - lineas: formato CSV simplificado por
     * filas separado con ';;' y columnas con '|' =&gt; tipo|importe|concepto|observ
     * Ej: 1|1234.56|F|Observación línea 1;;2|100|V|Obs 2. Devuelve JSON:
     * {"resultado":{"codigoOperacion":X,"salariales":n,"extrasalariales":m,"totalComputable":t}}
     */
    public String guardarLineasDesgloseRSB(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        String numExp = request.getParameter("numExp");
        if (numExp == null || numExp.trim().isEmpty()) {
            numExp = numExpediente; // fallback
        }
        String dni = request.getParameter("dni");
        String raw = request.getParameter("lineas");

        int codigoOperacion = 0; // 0 OK,1 BD,2 Sin filas (todo borrado ok),3 Parámetros,4 Genérico
        double salariales = 0d;
        double extrasalariales = 0d;
        double totalComputable = 0d; // RSBCOMPCONV derivado (no lo recalculamos aquí salvo sumar)

        AdaptadorSQLBD adapt = null;
        try {
            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
        } catch (Exception e) {
            log.error("[guardarLineasDesgloseRSB] Error obteniendo adaptador", e);
        }

        if (adapt == null || numExp == null || dni == null || dni.trim().isEmpty()) {
            codigoOperacion = 3; // parámetros/adaptador
        } else {
            try {
                List<DesgloseRSBVO> lista = parseLineasDesglose(raw);
                boolean ok = MeLanbide11Manager.getInstance().reemplazarDesgloseRSB(numExp, dni, lista, adapt);
                if (!ok) {
                    codigoOperacion = 2; // no se insertó nada (pudo ser solo borrado o fallo silencioso)
                }
                // Recuperar sumas por tipo para devolver
                try {
                    ComplementosPorTipo comp = MeLanbide11Manager.getInstance().getSumaComplementosPorTipo(numExp, dni,
                            adapt);
                    if (comp != null) {
                        salariales = comp.getSalariales();
                        extrasalariales = comp.getExtrasalariales();
                    }
                    totalComputable = salariales; // se sumará con salario base y pagas en otra llamada si aplica
                } catch (Exception sumEx) {
                    log.warn("[guardarLineasDesgloseRSB] No se pudieron recuperar sumas por tipo", sumEx);
                }
            } catch (Exception e) {
                log.error("[guardarLineasDesgloseRSB] Error BD reemplazando líneas", e);
                codigoOperacion = 1; // BD
            }
        }

        try {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            String json = new StringBuilder().append("{\"resultado\":{\"codigoOperacion\":").append(codigoOperacion)
                    .append(",\"salariales\":").append(salariales).append(",\"extrasalariales\":")
                    .append(extrasalariales).append(",\"totalComputable\":").append(totalComputable).append("}}")
                    .toString();
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
            return null;
        } catch (Exception ex) {
            log.error("[guardarLineasDesgloseRSB] Error enviando JSON", ex);
        }
        return null;
    }

    private List<DesgloseRSBVO> parseLineasDesglose(String raw) {
        // Delegamos en la utilidad para permitir pruebas unitarias independientes.
        return es.altia.flexia.integracion.moduloexterno.melanbide11.util.DesgloseRSBParser.parse(raw);
    }

    /**
     * Acción AJAX (pestaña 2) que devuelve las líneas del desglose RSB en formato
     * JSON. Respuesta:
     * {"lineas":[{"tipo":"1","importe":123.45,"concepto":"X","observ":"Y"},...]}
     */
    public String listarLineasDesgloseRSB(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        AdaptadorSQLBD adapt = null;
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        String numExp = request.getParameter("numExp");
        if (numExp == null || numExp.trim().isEmpty()) {
            numExp = numExpediente; // fallback
        }
        // Parámetro id de la contratación seleccionada (opcional)
        String idSeleccion = request.getParameter("id");
        String dniSeleccion = null; // Se resolverá si llega id
        try {
            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));
            if (adapt != null && numExp != null && numExp.trim().length() > 0) {
                boolean usarFiltro = (idSeleccion != null && idSeleccion.trim().length() > 0);
                if (usarFiltro) {
                    try {
                        // Optimización: resolver sólo el DNI de la contratación sin cargar toda la
                        // lista
                        java.sql.Connection con = null;
                        try {
                            con = adapt.getConnection();
                            dniSeleccion = es.altia.flexia.integracion.moduloexterno.melanbide11.dao.MeLanbide11DAO
                                    .getInstance().getDniContratacionById(numExp, idSeleccion, con);
                        } finally {
                            try {
                                if (con != null)
                                    adapt.devolverConexion(con);
                            } catch (Exception ignore) {
                            }
                        }
                        if (dniSeleccion != null && dniSeleccion.trim().length() > 0) {
                            lista = MeLanbide11Manager.getInstance().getDatosDesgloseRSBPorDni(numExp, dniSeleccion,
                                    codOrganizacion, adapt);
                            if (log.isDebugEnabled()) {
                                // Debug optimizado
                            }
                        } else {
                            lista = MeLanbide11Manager.getInstance().getDatosDesgloseRSB(numExp, codOrganizacion,
                                    adapt);
                            if (log.isDebugEnabled()) {
                                // Debug sin DNI asociado
                            }
                        }
                    } catch (Exception exId) {
                        log.warn("[listarLineasDesgloseRSB] Error optimizado resolviendo DNI por ID=" + idSeleccion
                                + ": " + exId.getMessage(), exId);
                        lista = MeLanbide11Manager.getInstance().getDatosDesgloseRSB(numExp, codOrganizacion, adapt);
                    }
                } else {
                    lista = MeLanbide11Manager.getInstance().getDatosDesgloseRSB(numExp, codOrganizacion, adapt);
                }
            }
        } catch (Exception e) {
            log.error("[listarLineasDesgloseRSB] Error recuperando datos", e);
        }

        StringBuilder sb = new StringBuilder();
        sb.append("{\"dni\":\"").append(escapeJson(dniSeleccion != null ? dniSeleccion : "")).append("\",\"lineas\":[");
        for (int i = 0; i < lista.size(); i++) {
            DesgloseRSBVO vo = lista.get(i);
            if (i > 0)
                sb.append(',');
            sb.append('{');
            sb.append("\"tipo\":\"").append(escapeJson(nvlStr(vo.getRsbTipo()))).append("\",");
            Double imp = vo.getRsbImporte();
            sb.append("\"importe\":").append(imp == null ? 0 : imp.doubleValue()).append(',');
            sb.append("\"concepto\":\"").append(escapeJson(nvlStr(vo.getRsbConcepto()))).append("\",");
            sb.append("\"observ\":\"").append(escapeJson(nvlStr(vo.getRsbObserv()))).append("\"}");
        }
        sb.append("]}");

        try {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            PrintWriter out = response.getWriter();
            out.print(sb.toString());
            out.flush();
        } catch (Exception ioe) {
            log.error("[listarLineasDesgloseRSB] Error enviando respuesta", ioe);
        }
        return null; // respuesta directa
    }

    private static String nvlStr(String v) {
        return v == null ? "" : v;
    }

    private static String escapeJson(String s) {
        if (s == null)
            return "";
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
            case '"':
                out.append("\\\"");
                break;
            case '\\':
                out.append("\\\\");
                break;
            case '\n':
                out.append("\\n");
                break;
            case '\r':
                out.append("\\r");
                break;
            case '\t':
                out.append("\\t");
                break;
            default:
                if (c < 32) {
                    out.append(String.format("\\u%04x", (int) c));
                } else {
                    out.append(c);
                }
            }
        }
        return out.toString();
    }

    /**
     * Método auxiliar para construir campos JSON de forma segura.
     */
    private void appendJsonCampo(StringBuilder json, String campo, String valor, boolean esUltimo) {
        json.append("\"").append(campo).append("\":");
        if (valor == null) {
            json.append("null");
        } else {
            json.append("\"").append(escapeJson(valor)).append("\"");
        }
        if (!esUltimo) {
            json.append(",");
        }
    }

    /**
     * Operación AJAX para listar todas las contrataciones de un expediente.
     * Invocada desde el CRUD de la pestaña 1.
     */
    public String listarContratacionesAJAX(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {

        AdaptadorSQLBD adapt = null;
        try {
            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));

            MeLanbide11Manager manager = MeLanbide11Manager.getInstance();
            List<ContratacionVO> contrataciones = manager.getContratacionesByExpediente(numExpediente, adapt);

            // Construir JSON manualmente
            StringBuilder json = new StringBuilder();
            json.append("{\"contrataciones\":[");

            for (int i = 0; i < contrataciones.size(); i++) {
                if (i > 0)
                    json.append(",");
                ContratacionVO c = contrataciones.get(i);

                json.append("{");
                appendJsonCampo(json, "id", c.getId() != null ? c.getId().toString() : "", false);
                appendJsonCampo(json, "dni", c.getDni(), false);
                appendJsonCampo(json, "nombre", c.getNombre(), false);
                appendJsonCampo(json, "apellido1", c.getApellido1(), false);
                appendJsonCampo(json, "apellido2", c.getApellido2(), false);
                appendJsonCampo(json, "puesto", c.getPuesto(), false);
                appendJsonCampo(json, "rsbSalBase", c.getRsbSalBase() != null ? c.getRsbSalBase().toString() : "",
                        false);
                appendJsonCampo(json, "rsbPagExtra", c.getRsbPagExtra() != null ? c.getRsbPagExtra().toString() : "",
                        false);
                appendJsonCampo(json, "rsbCompConv", c.getRsbCompConv() != null ? c.getRsbCompConv().toString() : "",
                        true);
                json.append("}");
            }

            json.append("]}");

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            log.error("[listarContratacionesAJAX] Error", e);
            try {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter()
                        .write("{\"error\":\"Error cargando contrataciones: " + escapeJson(e.getMessage()) + "\"}");
            } catch (Exception ex) {
                log.error("Error escribiendo respuesta de error", ex);
            }
        } finally {
            if (adapt != null) {
                try {
                    // No existe método close, no necesitamos cerrar explícitamente
                } catch (Exception e) {
                    log.error("Error cerrando adaptador", e);
                }
            }
        }

        return null; // No JSP, solo respuesta JSON
    }

    /**
     * Operación AJAX para eliminar una contratación específica. Invocada desde el
     * CRUD de la pestaña 1.
     */
    public String eliminarContratacionAJAX(int codOrganizacion, int codTramite, int ocurrenciaTramite,
            String numExpediente, HttpServletRequest request, HttpServletResponse response) {
        String idStr = request.getParameter("id");

        AdaptadorSQLBD adapt = null;
        try {
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new Exception("ID de contratación requerido");
            }

            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));

            MeLanbide11Manager manager = MeLanbide11Manager.getInstance();
            boolean eliminado = manager.eliminarContratacionAJAX(idStr, adapt);

            StringBuilder json = new StringBuilder();
            json.append("{\"resultado\":{");
            appendJsonCampo(json, "codigoOperacion", eliminado ? "0" : "1", false);
            appendJsonCampo(json, "mensajeOperacion", eliminado ? "Eliminado correctamente" : "No se pudo eliminar",
                    true);
            json.append("}}");

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            log.error("[eliminarContratacionAJAX] Error", e);
            try {
                StringBuilder json = new StringBuilder();
                json.append("{\"resultado\":{");
                appendJsonCampo(json, "codigoOperacion", "1", false);
                appendJsonCampo(json, "mensajeOperacion", "Error eliminando: " + escapeJson(e.getMessage()), true);
                json.append("}}");

                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write(json.toString());
            } catch (Exception ex) {
                log.error("Error escribiendo respuesta de error", ex);
            }
        } finally {
            if (adapt != null) {
                try {
                    // No existe método close, no necesitamos cerrar explícitamente
                } catch (Exception e) {
                    log.error("Error cerrando adaptador", e);
                }
            }
        }

        return null; // No JSP, solo respuesta JSON
    }

    /**
     * Operación AJAX para obtener una contratación específica por ID. Invocada
     * desde el CRUD de la pestaña 1.
     */
    public String getContratacionAJAX(int codOrganizacion, int codTramite, int ocurrenciaTramite, String numExpediente,
            HttpServletRequest request, HttpServletResponse response) {
        String idStr = request.getParameter("id");

        AdaptadorSQLBD adapt = null;
        try {
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new Exception("ID de contratación requerido");
            }

            adapt = this.getAdaptSQLBD(String.valueOf(codOrganizacion));

            MeLanbide11Manager manager = MeLanbide11Manager.getInstance();
            ContratacionVO contratacion = manager.getContratacionById(idStr, adapt);

            if (contratacion == null) {
                throw new Exception("Contratación no encontrada");
            }

            StringBuilder json = new StringBuilder();
            json.append("{\"contratacion\":{");
            appendJsonCampo(json, "id", contratacion.getId() != null ? contratacion.getId().toString() : "", false);
            appendJsonCampo(json, "dni", contratacion.getDni(), false);
            appendJsonCampo(json, "nombre", contratacion.getNombre(), false);
            appendJsonCampo(json, "apellido1", contratacion.getApellido1(), false);
            appendJsonCampo(json, "apellido2", contratacion.getApellido2(), false);
            appendJsonCampo(json, "puesto", contratacion.getPuesto(), false);
            appendJsonCampo(json, "rsbSalBase",
                    contratacion.getRsbSalBase() != null ? contratacion.getRsbSalBase().toString() : "", false);
            appendJsonCampo(json, "rsbPagExtra",
                    contratacion.getRsbPagExtra() != null ? contratacion.getRsbPagExtra().toString() : "", false);
            appendJsonCampo(json, "rsbCompConv",
                    contratacion.getRsbCompConv() != null ? contratacion.getRsbCompConv().toString() : "", true);
            json.append("}}");

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            log.error("[getContratacionAJAX] Error", e);
            try {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter()
                        .write("{\"error\":\"Error obteniendo contratación: " + escapeJson(e.getMessage()) + "\"}");
            } catch (Exception ex) {
                log.error("Error escribiendo respuesta de error", ex);
            }
        } finally {
            if (adapt != null) {
                try {
                    // No existe método close, no necesitamos cerrar explícitamente
                } catch (Exception e) {
                    log.error("Error cerrando adaptador", e);
                }
            }
        }

        return null; // No JSP, solo respuesta JSON
    }
}
