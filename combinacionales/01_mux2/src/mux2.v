//Declaración del módulo
module mux2
(   input  wire x,
    input  wire y,
    input  wire s,
    output wire f
);

//Cuerpo del módulo, resuelvo la lógica.
/*wire xns, ys;
assign f = xns | ys;
assign xns = x & (~s);
assign ys =  y & s;*/
//assign f = (s == 1'b0)? x : y;
assign f = (s)? y : x;



endmodule