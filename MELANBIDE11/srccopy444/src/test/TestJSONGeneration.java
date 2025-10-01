
/**
 * Test unitario simple para validar la funcionalidad JSON del sistema CRUD
 */
import java.lang.reflect.Method;

public class TestJSONGeneration {

    public static void main(String[] args) {
        System.out.println("=== TEST GENERACIÓN JSON ===");

        try {
            testEscapeJson();
            testAppendJsonCampo();
            testContratacionVOFields();

            System.out.println("\n[SUCCESS] Todas las validaciones JSON pasaron correctamente");
            System.out.println("El sistema genera JSON válido y maneja caracteres especiales");

        } catch (Exception e) {
            System.err.println("\n[FAILURE] Test falló: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void testEscapeJson() throws Exception {
        System.out.println("\n1. Verificando función escapeJson...");

        Class<?> servletClass = Class.forName("es.altia.flexia.integracion.moduloexterno.melanbide11.MELANBIDE11");
        Method escapeMethod = servletClass.getDeclaredMethod("escapeJson", String.class);
        escapeMethod.setAccessible(true);

        // Test casos básicos
        String result1 = (String) escapeMethod.invoke(null, "texto normal");
        if (!"texto normal".equals(result1)) {
            throw new Exception("escapeJson falla con texto normal");
        }
        System.out.println("   [OK] Texto normal preservado");

        // Test comillas dobles
        String result2 = (String) escapeMethod.invoke(null, "texto con \"comillas\"");
        if (!result2.contains("\\\"")) {
            throw new Exception("escapeJson no escapa comillas dobles");
        }
        System.out.println("   [OK] Comillas dobles escapadas");

        // Test null
        String result3 = (String) escapeMethod.invoke(null, (String) null);
        if (!"".equals(result3)) {
            throw new Exception("escapeJson no maneja null correctamente");
        }
        System.out.println("   [OK] Valor null manejado");
    }

    private static void testAppendJsonCampo() throws Exception {
        System.out.println("\n2. Verificando función appendJsonCampo...");

        Class<?> servletClass = Class.forName("es.altia.flexia.integracion.moduloexterno.melanbide11.MELANBIDE11");

        // Crear una instancia para llamar método no estático
        Object servletInstance = servletClass.newInstance();
        Method appendMethod = servletClass.getDeclaredMethod("appendJsonCampo", StringBuilder.class, String.class,
                String.class, boolean.class);
        appendMethod.setAccessible(true);

        // Test campo básico
        StringBuilder json1 = new StringBuilder();
        appendMethod.invoke(servletInstance, json1, "nombre", "Juan", false);
        String result1 = json1.toString();
        if (!result1.equals("\"nombre\":\"Juan\",")) {
            throw new Exception("appendJsonCampo formato incorrecto: " + result1);
        }
        System.out.println("   [OK] Campo básico formateado: " + result1);

        // Test campo null
        StringBuilder json2 = new StringBuilder();
        appendMethod.invoke(servletInstance, json2, "campo", null, true);
        String result2 = json2.toString();
        if (!result2.equals("\"campo\":null")) {
            throw new Exception("appendJsonCampo no maneja null: " + result2);
        }
        System.out.println("   [OK] Campo null manejado: " + result2);

        // Test último campo (sin coma)
        StringBuilder json3 = new StringBuilder();
        appendMethod.invoke(servletInstance, json3, "ultimo", "valor", true);
        String result3 = json3.toString();
        if (!result3.equals("\"ultimo\":\"valor\"")) {
            throw new Exception("appendJsonCampo último campo incorrecto: " + result3);
        }
        System.out.println("   [OK] Último campo sin coma: " + result3);
    }

    private static void testContratacionVOFields() throws Exception {
        System.out.println("\n3. Verificando campos de ContratacionVO...");

        Class<?> voClass = Class.forName("es.altia.flexia.integracion.moduloexterno.melanbide11.vo.ContratacionVO");
        Object contratacion = voClass.newInstance();

        // Test campos críticos para JSON
        String[] camposCriticos = { "Id", "Dni", "Nombre", "Apellido1", "Apellido2", "Puesto", "RsbSalBase",
                "RsbPagExtra", "RsbCompConv" };

        for (String campo : camposCriticos) {
            try {
                Method getter = voClass.getMethod("get" + campo);
                Method setter = voClass.getMethod("set" + campo, getter.getReturnType());

                System.out.println("   [OK] " + campo + " - getter/setter disponibles");
            } catch (NoSuchMethodException e) {
                throw new Exception("Campo crítico " + campo + " no tiene getter/setter");
            }
        }

        // Test tipos de datos específicos
        Method getIdMethod = voClass.getMethod("getId");
        if (!getIdMethod.getReturnType().equals(Integer.class)) {
            throw new Exception("getId debe retornar Integer, retorna: " + getIdMethod.getReturnType());
        }
        System.out.println("   [OK] Id es Integer");

        Method getRsbSalBaseMethod = voClass.getMethod("getRsbSalBase");
        if (!getRsbSalBaseMethod.getReturnType().equals(Double.class)) {
            throw new Exception("getRsbSalBase debe retornar Double, retorna: " + getRsbSalBaseMethod.getReturnType());
        }
        System.out.println("   [OK] RsbSalBase es Double");
    }
}