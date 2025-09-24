/**
 * Suite de Pruebas para MELANBIDE11 - DEM50 Anexo A
 * Casos de prueba para cálculo de subvención y RSB
 * Basado en las reglas de negocio proporcionadas
 */

// Funciones de cálculo de subvención
function calcularSubvencion(nivelEducacion, tipoContrato, esMujer, esMenor30, esMayor45, esMayor55) {
    let baseAmount = 0;
    let multiplier = 1;

    // Establecer monto base según nivel educativo
    switch(nivelEducacion) {
        case 'ESO':
            baseAmount = 3200;
            break;
        case 'FP_MEDIO':
            baseAmount = 3700;
            break;
        case 'BACH':
            baseAmount = 4200;
            break;
        case 'FP_SUPERIOR':
            baseAmount = 4700;
            break;
        case 'UNIVERSITARIO':
            baseAmount = 5200;
            break;
        default:
            throw new Error(`Nivel educativo no válido: ${nivelEducacion}`);
    }

    // Aplicar multiplicador según tipo de contrato
    switch(tipoContrato) {
        case 'INDEFINIDO':
            multiplier = 1.0;
            break;
        case 'TEMPORAL':
            multiplier = 0.5;
            break;
        default:
            throw new Error(`Tipo de contrato no válido: ${tipoContrato}`);
    }

    let subvencionBase = baseAmount * multiplier;

    // Aplicar bonificaciones adicionales
    let bonificacionTotal = 0;

    if (esMujer) {
        bonificacionTotal += subvencionBase * 0.15; // 15% adicional
    }

    if (esMenor30) {
        bonificacionTotal += subvencionBase * 0.10; // 10% adicional
    }

    if (esMayor45) {
        bonificacionTotal += subvencionBase * 0.12; // 12% adicional
    }

    if (esMayor55) {
        bonificacionTotal += subvencionBase * 0.20; // 20% adicional
    }

    const subvencionTotal = subvencionBase + bonificacionTotal;
    
    // Redondear a 2 decimales
    return Math.round(subvencionTotal * 100) / 100;
}

// Función para calcular RSB
function calcularRSB(salarioBruto, tipoContrato, meses = 12) {
    if (salarioBruto <= 0 || meses <= 0) {
        throw new Error('Salario bruto y meses deben ser mayores a 0');
    }

    const salarioAnual = salarioBruto * meses;
    let porcentajeRSB = 0;

    // Determinar porcentaje según tipo de contrato
    switch(tipoContrato) {
        case 'INDEFINIDO':
            porcentajeRSB = 0.235; // 23.5%
            break;
        case 'TEMPORAL':
            porcentajeRSB = 0.28; // 28%
            break;
        default:
            throw new Error(`Tipo de contrato no válido para RSB: ${tipoContrato}`);
    }

    const rsbComputable = salarioAnual * porcentajeRSB;
    const rsbTotal = rsbComputable * 1.06; // 6% adicional para total

    return {
        computable: Math.round(rsbComputable * 100) / 100,
        total: Math.round(rsbTotal * 100) / 100
    };
}

// Casos de prueba para subvención
const testCasesSubvencion = [
    {
        id: 1,
        descripcion: "Hombre, ESO, indefinido, 35 años",
        input: {
            nivelEducacion: 'ESO',
            tipoContrato: 'INDEFINIDO',
            esMujer: false,
            esMenor30: false,
            esMayor45: false,
            esMayor55: false
        },
        expected: 3200.00
    },
    {
        id: 2,
        descripcion: "Mujer, FP Medio, indefinido, 28 años",
        input: {
            nivelEducacion: 'FP_MEDIO',
            tipoContrato: 'INDEFINIDO',
            esMujer: true,
            esMenor30: true,
            esMayor45: false,
            esMayor55: false
        },
        expected: 4625.00 // 3700 + 15% + 10% = 3700 + 555 + 370 = 4625
    },
    {
        id: 3,
        descripcion: "Hombre, Bachillerato, temporal, 40 años",
        input: {
            nivelEducacion: 'BACH',
            tipoContrato: 'TEMPORAL',
            esMujer: false,
            esMenor30: false,
            esMayor45: false,
            esMayor55: false
        },
        expected: 2100.00 // 4200 * 0.5 = 2100
    },
    {
        id: 4,
        descripcion: "Mujer, FP Superior, indefinido, 50 años",
        input: {
            nivelEducacion: 'FP_SUPERIOR',
            tipoContrato: 'INDEFINIDO',
            esMujer: true,
            esMenor30: false,
            esMayor45: true,
            esMayor55: false
        },
        expected: 5969.00 // 4700 + 15% + 12% = 4700 + 705 + 564 = 5969
    },
    {
        id: 5,
        descripcion: "Hombre, Universitario, temporal, 58 años",
        input: {
            nivelEducacion: 'UNIVERSITARIO',
            tipoContrato: 'TEMPORAL',
            esMujer: false,
            esMenor30: false,
            esMayor45: false,
            esMayor55: true
        },
        expected: 3120.00 // 5200 * 0.5 + 20% = 2600 + 520 = 3120
    },
    {
        id: 6,
        descripcion: "Mujer, ESO, temporal, 26 años",
        input: {
            nivelEducacion: 'ESO',
            tipoContrato: 'TEMPORAL',
            esMujer: true,
            esMenor30: true,
            esMayor45: false,
            esMayor55: false
        },
        expected: 2000.00 // 3200 * 0.5 + 15% + 10% = 1600 + 240 + 160 = 2000
    },
    {
        id: 7,
        descripcion: "Mujer, Universitario, indefinido, 60 años",
        input: {
            nivelEducacion: 'UNIVERSITARIO',
            tipoContrato: 'INDEFINIDO',
            esMujer: true,
            esMenor30: false,
            esMayor45: false,
            esMayor55: true
        },
        expected: 7020.00 // 5200 + 15% + 20% = 5200 + 780 + 1040 = 7020
    },
    {
        id: 8,
        descripcion: "Hombre, FP Medio, indefinido, 48 años",
        input: {
            nivelEducacion: 'FP_MEDIO',
            tipoContrato: 'INDEFINIDO',
            esMujer: false,
            esMenor30: false,
            esMayor45: true,
            esMayor55: false
        },
        expected: 4144.00 // 3700 + 12% = 3700 + 444 = 4144
    },
    {
        id: 9,
        descripcion: "Mujer, Bachillerato, temporal, 47 años",
        input: {
            nivelEducacion: 'BACH',
            tipoContrato: 'TEMPORAL',
            esMujer: true,
            esMenor30: false,
            esMayor45: true,
            esMayor55: false
        },
        expected: 2667.00 // 4200 * 0.5 + 15% + 12% = 2100 + 315 + 252 = 2667
    },
    {
        id: 10,
        descripcion: "Hombre, FP Superior, temporal, 29 años",
        input: {
            nivelEducacion: 'FP_SUPERIOR',
            tipoContrato: 'TEMPORAL',
            esMujer: false,
            esMenor30: true,
            esMayor45: false,
            esMayor55: false
        },
        expected: 2585.00 // 4700 * 0.5 + 10% = 2350 + 235 = 2585
    }
];

// Casos de prueba para RSB
const testCasesRSB = [
    {
        id: 1,
        descripcion: "Contrato indefinido, salario 2500¤/mes",
        input: {
            salarioBruto: 2500,
            tipoContrato: 'INDEFINIDO',
            meses: 12
        },
        expected: {
            computable: 7050.00, // 30000 * 0.235 = 7050
            total: 7473.00 // 7050 * 1.06 = 7473
        }
    },
    {
        id: 2,
        descripcion: "Contrato temporal, salario 2000¤/mes",
        input: {
            salarioBruto: 2000,
            tipoContrato: 'TEMPORAL',
            meses: 12
        },
        expected: {
            computable: 6720.00, // 24000 * 0.28 = 6720
            total: 7123.20 // 6720 * 1.06 = 7123.20
        }
    },
    {
        id: 3,
        descripcion: "Contrato indefinido, salario 3000¤/mes, 6 meses",
        input: {
            salarioBruto: 3000,
            tipoContrato: 'INDEFINIDO',
            meses: 6
        },
        expected: {
            computable: 4230.00, // 18000 * 0.235 = 4230
            total: 4483.80 // 4230 * 1.06 = 4483.80
        }
    }
];

// Función para ejecutar las pruebas
function ejecutarPruebas() {
    console.log('=== SUITE DE PRUEBAS MELANBIDE11 - DEM50 Anexo A ===\n');

    let totalTests = 0;
    let passedTests = 0;
    let failedTests = 0;

    // Pruebas de subvención
    console.log('?? PRUEBAS DE CÁLCULO DE SUBVENCIÓN\n');
    
    testCasesSubvencion.forEach(testCase => {
        totalTests++;
        try {
            const resultado = calcularSubvencion(
                testCase.input.nivelEducacion,
                testCase.input.tipoContrato,
                testCase.input.esMujer,
                testCase.input.esMenor30,
                testCase.input.esMayor45,
                testCase.input.esMayor55
            );

            if (Math.abs(resultado - testCase.expected) < 0.01) {
                console.log(`? Caso ${testCase.id}: ${testCase.descripcion}`);
                console.log(`   Resultado: ¤${resultado} (Esperado: ¤${testCase.expected})\n`);
                passedTests++;
            } else {
                console.log(`? Caso ${testCase.id}: ${testCase.descripcion}`);
                console.log(`   Resultado: ¤${resultado} (Esperado: ¤${testCase.expected})`);
                console.log(`   Diferencia: ¤${Math.abs(resultado - testCase.expected)}\n`);
                failedTests++;
            }
        } catch (error) {
            console.log(`? Caso ${testCase.id}: ${testCase.descripcion}`);
            console.log(`   Error: ${error.message}\n`);
            failedTests++;
        }
    });

    // Pruebas de RSB
    console.log('?? PRUEBAS DE CÁLCULO DE RSB\n');

    testCasesRSB.forEach(testCase => {
        totalTests++;
        try {
            const resultado = calcularRSB(
                testCase.input.salarioBruto,
                testCase.input.tipoContrato,
                testCase.input.meses
            );

            const computeMatch = Math.abs(resultado.computable - testCase.expected.computable) < 0.01;
            const totalMatch = Math.abs(resultado.total - testCase.expected.total) < 0.01;

            if (computeMatch && totalMatch) {
                console.log(`? Caso ${testCase.id}: ${testCase.descripcion}`);
                console.log(`   Computable: ¤${resultado.computable} (Esperado: ¤${testCase.expected.computable})`);
                console.log(`   Total: ¤${resultado.total} (Esperado: ¤${testCase.expected.total})\n`);
                passedTests++;
            } else {
                console.log(`? Caso ${testCase.id}: ${testCase.descripcion}`);
                console.log(`   Computable: ¤${resultado.computable} (Esperado: ¤${testCase.expected.computable})`);
                console.log(`   Total: ¤${resultado.total} (Esperado: ¤${testCase.expected.total})`);
                if (!computeMatch) {
                    console.log(`   Diferencia Computable: ¤${Math.abs(resultado.computable - testCase.expected.computable)}`);
                }
                if (!totalMatch) {
                    console.log(`   Diferencia Total: ¤${Math.abs(resultado.total - testCase.expected.total)}`);
                }
                console.log('');
                failedTests++;
            }
        } catch (error) {
            console.log(`? Caso ${testCase.id}: ${testCase.descripcion}`);
            console.log(`   Error: ${error.message}\n`);
            failedTests++;
        }
    });

    // Resumen final
    console.log('=== RESUMEN DE PRUEBAS ===');
    console.log(`Total de pruebas ejecutadas: ${totalTests}`);
    console.log(`Pruebas exitosas: ${passedTests} ?`);
    console.log(`Pruebas fallidas: ${failedTests} ?`);
    console.log(`Tasa de éxito: ${((passedTests / totalTests) * 100).toFixed(1)}%`);

    if (failedTests === 0) {
        console.log('\n?? ¡TODAS LAS PRUEBAS PASARON! El sistema de cálculo funciona correctamente.');
    } else {
        console.log(`\n??  ${failedTests} prueba(s) requieren atención.`);
    }

    return {
        total: totalTests,
        passed: passedTests,
        failed: failedTests,
        successRate: (passedTests / totalTests) * 100
    };
}

// Función para pruebas de validación de errores
function pruebasValidacion() {
    console.log('\n?? PRUEBAS DE VALIDACIÓN DE ERRORES\n');

    const pruebasError = [
        {
            descripcion: "Nivel educativo inválido",
            func: () => calcularSubvencion('NIVEL_INEXISTENTE', 'INDEFINIDO', false, false, false, false),
            errorEsperado: "Nivel educativo no válido"
        },
        {
            descripcion: "Tipo de contrato inválido para subvención",
            func: () => calcularSubvencion('ESO', 'TIPO_INEXISTENTE', false, false, false, false),
            errorEsperado: "Tipo de contrato no válido"
        },
        {
            descripcion: "Salario bruto cero para RSB",
            func: () => calcularRSB(0, 'INDEFINIDO', 12),
            errorEsperado: "Salario bruto y meses deben ser mayores a 0"
        },
        {
            descripcion: "Tipo de contrato inválido para RSB",
            func: () => calcularRSB(2500, 'TIPO_INEXISTENTE', 12),
            errorEsperado: "Tipo de contrato no válido para RSB"
        }
    ];

    let validacionesPasadas = 0;

    pruebasError.forEach((prueba, index) => {
        try {
            prueba.func();
            console.log(`? Validación ${index + 1}: ${prueba.descripcion} - No se lanzó error`);
        } catch (error) {
            if (error.message.includes(prueba.errorEsperado)) {
                console.log(`? Validación ${index + 1}: ${prueba.descripcion} - Error correctamente capturado`);
                validacionesPasadas++;
            } else {
                console.log(`? Validación ${index + 1}: ${prueba.descripcion} - Error incorrecto: ${error.message}`);
            }
        }
    });

    console.log(`\nValidaciones de error pasadas: ${validacionesPasadas}/${pruebasError.length}`);
}

// Ejecutar todas las pruebas si el archivo se ejecuta directamente
if (typeof require !== 'undefined' && require.main === module) {
    const resultados = ejecutarPruebas();
    pruebasValidacion();
    
    // Salir con código de error si alguna prueba falló
    if (resultados.failed > 0) {
        process.exit(1);
    }
}

// Exportar funciones para uso en browser o Node.js
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        calcularSubvencion,
        calcularRSB,
        ejecutarPruebas,
        pruebasValidacion,
        testCasesSubvencion,
        testCasesRSB
    };
} else if (typeof window !== 'undefined') {
    window.MELANBIDE11Tests = {
        calcularSubvencion,
        calcularRSB,
        ejecutarPruebas,
        pruebasValidacion,
        testCasesSubvencion,
        testCasesRSB
    };
}