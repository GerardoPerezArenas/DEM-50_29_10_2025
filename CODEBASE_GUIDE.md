# MELANBIDE11 – DEM50 Codebase Guide

## Arquitectura General

### Descripción del Sistema
Aplicación web Java EE legacy sobre el framework **Flexia**, utilizada en el sistema de gestión de subvenciones de empleo **Lanbide DEM50** (Anexo A – Contrataciones).

### Stack Tecnológico

#### Versión de Java
- **Java 1.6** (JDK 6)
- El código debe mantener compatibilidad completa con Java 1.6
- No se pueden utilizar características introducidas en versiones posteriores de Java

#### Framework Principal
- **Flexia Framework** - Framework legacy para aplicaciones Java EE

### Características Críticas del Proyecto

#### ⚠️ CRÍTICO: Codificación de Archivos
```
encoding="ISO-8859-1"
```

**IMPORTANTE**: 
- **TODOS los archivos del proyecto utilizan codificación ISO-8859-1**
- **NO utilizar UTF-8**
- Configurar el IDE para trabajar con ISO-8859-1:
  - Eclipse: Project Properties → Resource → Text file encoding → Other: ISO-8859-1
  - IntelliJ IDEA: Settings → Editor → File Encodings → Project Encoding: ISO-8859-1
  - NetBeans: Project Properties → Sources → Encoding: ISO-8859-1

### Dominio de Negocio

#### Lanbide DEM50
Sistema de gestión de subvenciones de empleo del Servicio Vasco de Empleo (Lanbide).

**Anexo A – Contrataciones**:
- Gestión de contrataciones relacionadas con subvenciones de empleo
- Procesamiento de solicitudes
- Control y seguimiento de expedientes

## Requisitos del Entorno de Desarrollo

### Software Necesario
1. **JDK 1.6** (Java Development Kit 6)
2. **Servidor de aplicaciones Java EE** compatible con Java 6
   - Apache Tomcat 6.x/7.x (Nota: Versiones EOL, evaluar riesgos de seguridad)
   - JBoss AS 5.x/6.x
   - Oracle WebLogic (versión compatible)
   - **Importante**: Considerar uso en entornos aislados debido a limitaciones de seguridad de versiones antiguas
3. **IDE** configurado con encoding ISO-8859-1
4. **Maven** o **Ant** (según la configuración del proyecto)

### Configuración del Proyecto

#### Encoding en el IDE
Asegurarse de que todos los archivos se abren y guardan con encoding **ISO-8859-1**:

```properties
# Configuración recomendada para archivos de propiedades
file.encoding=ISO-8859-1
```

#### Compilación
El proyecto debe compilarse con las siguientes opciones:
```bash
javac -encoding ISO-8859-1 -source 1.6 -target 1.6 [archivos]
```

## Estructura del Proyecto

### Organización del Código
El proyecto sigue la estructura típica de una aplicación Java EE legacy:

```
/
├── src/
│   ├── main/
│   │   ├── java/          # Código fuente Java
│   │   ├── resources/     # Recursos de la aplicación
│   │   └── webapp/        # Recursos web (JSP, HTML, CSS, JS)
│   └── test/
│       └── java/          # Tests unitarios
├── lib/                   # Librerías externas
└── build/                 # Archivos compilados
```

## Mejores Prácticas

### 1. Compatibilidad Java 1.6
- No utilizar try-with-resources (introducido en Java 7) → Usar bloques finally explícitos para gestión de recursos
- No utilizar diamond operator <> (Java 7) → Especificar tipos genéricos completos: `new ArrayList<String>()`
- No utilizar String en switch statements (Java 7) → Usar if-else o Map para despacho
- No utilizar métodos de APIs introducidos después de Java 6

### 2. Manejo de Encoding
- **SIEMPRE** verificar que los archivos se guarden en ISO-8859-1
- Al crear nuevos archivos, configurar explícitamente el encoding
- Tener especial cuidado con caracteres especiales del español (ñ, á, é, í, ó, ú, ü)

### 3. Framework Flexia
- Seguir las convenciones y patrones establecidos por el framework
- Consultar la documentación oficial de Flexia para el desarrollo

### 4. Gestión de Dependencias
- Verificar compatibilidad de todas las librerías con Java 1.6
- Mantener las versiones de dependencias estables y probadas

## Notas Importantes

### Limitaciones del Sistema Legacy
- Este es un sistema **legacy** en mantenimiento
- Priorizar la estabilidad sobre nuevas características
- Cualquier cambio debe ser exhaustivamente probado
- Mantener compatibilidad con versiones anteriores

### Documentación Adicional
- Consultar el Anexo A para detalles específicos sobre Contrataciones
- Revisar documentación interna de Lanbide para procesos de negocio
- Mantener actualizada la documentación técnica con cada cambio significativo

## Contacto y Soporte

Para dudas o problemas con el desarrollo:
1. Consultar la documentación del framework Flexia
2. Revisar los comentarios en el código legacy
3. Contactar con el equipo de mantenimiento de Lanbide

---

**Última actualización**: Octubre 2025  
**Versión del documento**: 1.0
