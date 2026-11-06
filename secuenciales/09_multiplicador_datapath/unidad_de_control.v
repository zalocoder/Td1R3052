
module unidad_de_control 
(    
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire done,
    output reg  en,
    output reg ready  
);
    //Defino constantes con los estados
    parameter[1:0]      S_IDLE = 2'b00,
                        S_CHECK= 2'b10,
                        S_WORK = 2'b11;


    reg [1:0]  estado_actual, estado_futuro;

    //Bloque secuencial con reset asincrónico
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_actual <= S_IDLE;
        end else begin
            estado_actual <= estado_futuro;
        end
    end

    //Lógica de estado futuro (combinacional)
    always @(estado_actual, start, done) begin
        case (estado_actual)
            S_IDLE: begin
                if(start) begin
                    estado_futuro = S_CHECK;
                end else begin
                    estado_futuro = S_IDLE;
                end
            end
            S_CHECK: begin
                if(done) begin
                    estado_futuro = S_IDLE;
                end else begin
                    estado_futuro = S_WORK;
                end
            end
            S_WORK: begin
                estado_futuro = S_CHECK;
            end
        endcase
    end

    always @(estado_actual) begin
        case(estado_actual)
            S_IDLE: begin
                en    = 1'b0;
                ready = 1'b1;
            end
            S_CHECK: begin
                en    = 1'b0;
                ready = 1'b0;
            end
            S_WORK: begin
                en    = 1'b1;
                ready = 1'b0;
            end
        endcase
    end
endmodule
