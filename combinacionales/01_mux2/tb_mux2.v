`timescale 1ns / 100ps

module tb_mux2;
    
    reg tb_x, tb_y, tb_s;
    wire tb_f;
    integer i;  //Variable para iterar

    // Instancia del circuito a ensayar
    //Genero una instancia de mux2 que se llama
    //uut "unit under test".
    mux2 uut (
        .x(tb_x),
        .y(tb_y),
        .s(tb_s),
        .f(tb_f)
    );

    // Bloque inicial para aplicar los estímulos
    // con bloque initial
    initial begin
        // Archivo para guardar la simulación
        $dumpfile("tb_mux2.vcd");   //Creo el archivo para las señales
        $dumpvars(0, tb_mux2);      //Todo lo generado por tb_mux2 al archivo vcd
        $monitor("x=%b y=%b s=%b => f=%b",tb_x, tb_y, tb_s, tb_f);

        // Aplicar todos los valores posibles
        for (i = 0; i < 8; i = i + 1) 
        begin    
            {tb_s, tb_x, tb_y} = i;
            #5; //Espero 5 unidades de tiempo
                //definido en timescale
        end
        $finish;    //Termino la simulacion
    end
endmodule