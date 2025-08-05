package es.altia.flexia.integracion.moduloexterno.melanbide11.util;

import java.util.ResourceBundle;

public class ConfigurationParameter {

    /**
     * M�todo que recupera la propiedad de que le indicamos como par�metro. Adem�s le enviamos el nombre del fichero de propiedades.
     * 
     * @param property
     * @param FICHERO_CONFIGURACION
     * @return 
     */
    public static String getParameter(String property,String FICHERO_CONFIGURACION){
        String valor = "";
        try{
            ResourceBundle bundle = ResourceBundle.getBundle(FICHERO_CONFIGURACION);
            valor = bundle.getString(property);
        }catch(Exception e){
            e.printStackTrace();
        }//try-catch
        return valor;
    }//getParameter
    
}//class