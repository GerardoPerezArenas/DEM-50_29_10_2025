package es.altia.flexia.integracion.moduloexterno.melanbide11.util;

import java.util.ArrayList;
import java.util.List;

import es.altia.flexia.integracion.moduloexterno.melanbide11.vo.DesgloseRSBVO;

/**
 * Parser utilitario para las lineas de desglose RSB. Formato esperado: filas
 * separadas por ';;' y columnas por '|' Cada fila: tipo|importe|concepto|observ
 * - tipo: '1' (salarial) o '2' (extrasalarial). Se permiten otros códigos; se
 * almacenan tal cual. - importe: double (se aceptan comas decimales) -
 * concepto: texto libre - observ: texto libre; se duplican comillas simples
 * para prevenir SQL rudimentario (legacy)
 */
public final class DesgloseRSBParser {

    private DesgloseRSBParser() {
    }

    public static List<DesgloseRSBVO> parse(String raw) {
        List<DesgloseRSBVO> lista = new ArrayList<DesgloseRSBVO>();
        if (raw == null || raw.trim().isEmpty()) {
            return lista; // vacío => solo borrado
        }
        String[] filas = raw.split(";;");
        for (String fila : filas) {
            if (fila == null || fila.trim().isEmpty())
                continue;
            String[] cols = fila.split("\\|");
            DesgloseRSBVO vo = new DesgloseRSBVO();
            if (cols.length > 0 && cols[0].trim().length() > 0)
                vo.setRsbTipo(cols[0].trim());
            if (cols.length > 1 && cols[1].trim().length() > 0) {
                try {
                    vo.setRsbImporte(Double.valueOf(cols[1].replace(',', '.')));
                } catch (Exception ign) {
                }
            }
            if (cols.length > 2 && cols[2].trim().length() > 0)
                vo.setRsbConcepto(cols[2].trim());
            if (cols.length > 3 && cols[3].trim().length() > 0)
                vo.setRsbObserv(cols[3].replace("'", "''").trim());
            lista.add(vo);
        }
        return lista;
    }
}
