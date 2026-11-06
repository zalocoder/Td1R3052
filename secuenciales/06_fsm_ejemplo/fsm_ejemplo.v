
module fsm_ejemplo 
(    
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire done,
    output reg  busy,
    output reg ready  
);
    //Defino constantes con los estados
    parameter[1:0]      S_IDLE = 2'b00,
                        S_WORK = 2'b01,
                        S_DONE = 2'b11;


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
                    estado_futuro = S_WORK;
                end else begin
                    estado_futuro = S_IDLE;
                end
            end
            S_WORK: begin
                if(done) begin
                    estado_futuro = S_DONE;
                end else begin
                    estado_futuro = S_WORK;
                end
            end
            S_DONE: begin
                estado_futuro = S_IDLE;
            end
        endcase
    end

    always @(estado_actual) begin
        case(estado_actual)
            S_IDLE: begin
                ready = 1'b1;
                busy  = 1'b0;
            end
            S_WORK: begin
                ready = 1'b0;
                busy  = 1'b1;
            end
            S_DONE: begin
                ready = 1'b0;
                busy  = 1'b0;
            end
        endcase
    end
endmodule
