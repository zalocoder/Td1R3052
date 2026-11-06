
module inverter 
(    
    input  wire clk,
    input  wire rst,
    input  wire en,
    output wire tc,
    output reg[5:0] s  
);
    reg[2:0] cnt;    
    assign tc = (cnt == 3'b111)? 1'b1: 1'b0;

    always@(posedge clk) begin
        if(rst) begin
            cnt <= 3'b000;
        end else if (en) begin
            cnt <= cnt + 1;
        end
    end
    
    always @(cnt) begin
        case(cnt)
            3'b000: s = 6'b110001;
            3'b001: s = 6'b100011;
            3'b010: s = 6'b000111;
            3'b011: s = 6'b001110;
            3'b100: s = 6'b011100;
            3'b101: s = 6'b111000;
            3'b110: s = 6'b110001;
            3'b111: s = 6'b100011; 
        endcase
    end
endmodule
