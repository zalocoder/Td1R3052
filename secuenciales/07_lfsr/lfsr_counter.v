
module lfsr_counter 
(    
    input  wire clk,
    input  wire rst,
    input  wire en,
    output wire tc,
    output reg[7:0] q  
);
    //x**8 + x**4 + x**3 + x**2 + 1.
    wire[7:0] d;
    wire xin;
    assign tc = (q == 8'h80)? 1'b1 : 1'b0;
    assign d[7:0] = {q[6:0],xin};
    assign    xin = q[7]^q[3]^q[2]^q[1];

    always@(posedge clk) begin
        if(rst) begin
            q <= 8'b00000001;
        end else if (en) begin
            q <= d;
        end
    end 
endmodule
