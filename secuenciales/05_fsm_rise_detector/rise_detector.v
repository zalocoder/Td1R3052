
module rise_detector 
(    
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire dout
);
    parameter [1:0] WAIT_ZERO = 2'b00,
                    WAIT_ONE  = 2'b01,
                    ACTIVE    = 2'b11;

    reg [1:0] estado_actual, estado_futuro;

    always @(posedge clk) begin
        if (rst) begin
            estado_actual <= WAIT_ZERO;
        end else begin
            estado_actual <= estado_futuro; 
        end  
    end

    always@(estado_actual, din) begin
        case (estado_actual) 
            WAIT_ZERO: begin
                if (din == 1'b0) begin
                    estado_futuro = WAIT_ONE;
                end else begin
                    estado_futuro = WAIT_ZERO;
                end
            end  
            WAIT_ONE: begin
                if (din == 1'b1) begin
                    estado_futuro = ACTIVE;
                end else begin
                    estado_futuro = WAIT_ONE;
                end 
            end
            
            ACTIVE: begin
                if (din == 1'b1) begin
                    estado_futuro = WAIT_ZERO;
                end else begin
                    estado_futuro = WAIT_ONE;
                end 
            end
        endcase
    end 

    assign dout = (estado_actual == ACTIVE)? 1'b1 : 1'b0;
endmodule
