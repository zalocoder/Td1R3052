// =========================================================================
// Problema: Diseñar un módulo combinacional en Verilog que cuente la
// cantidad de unos ('1') presentes en un vector de entrada de N bits.
// =========================================================================

module bit_cnt2 #(
    parameter N = 4                     // N representa el ancho genérico del vector de entrada
)(
    input  [N-1:0]           entrada,   // Vector binario bajo análisis
    // El tamaño de la salida se calcula dinámicamente. 
    // Para poder representar el valor máximo (que es N), se requieren $clog2(N+1) bits.
    output [$clog2(N+1)-1:0] salida     
);

    // localparam se usa para constantes internas que calculan la arquitectura del circuito.
    // Evita recalcular la fórmula de bits en múltiples partes del código.
    localparam NBITS = $clog2(N+1);

    // Se declara 'automatic' para que las variables internas (como el índice 'i') 
    // se creen y destruyan dinámicamente en cada llamada, evitando colisiones de memoria.
    function automatic [NBITS-1:0] suma_unos;
        input [N-1:0] bits_entrada;     // Argumento local que recibe el valor de la entrada
        integer i;                      // Variable de control para el bucle (no genera hardware)
    begin
        suma_unos = 0;                  // IMPORTANTE: Inicializar el acumulador para evitar lógica residual o 'X'
        
        // El bucle 'for' se desenrolla en tiempo de compilación para generar un árbol de sumadores en hardware.
        // Debe iterar exactamente N veces para evaluar cada posición del vector (desde 0 hasta N-1).
        for (i = 0; i < N; i = i + 1)   
        begin
            // Suma posicional: se extrae el bit 'i' y se acumula aritméticamente en el resultado.
            suma_unos = suma_unos + bits_entrada[i];      
        end
    end
    endfunction

    // Asignación combinacional continua: ante cualquier cambio en 'entrada', 
    // la función se ejecuta instantáneamente actualizando la 'salida'.
    assign salida = suma_unos(entrada);
endmodule
