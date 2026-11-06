
module genreset 
#(parameter N = 2)(
    input  wire clk,
    input  wire rst_in,
    output wire rst_out
);
    reg [N-1:0] registro_reset;
    assign rst_out = registro_reset[N-1]; 

    always @(posedge clk or posedge rst_in) begin
        if(rst_in) begin
            registro_reset <= {N{1'b1}};
        end else begin
            registro_reset[N-1:1] <= registro_reset[N-2:0];
            registro_reset[0]     <= 1'b0;
        end
    end
endmodule
