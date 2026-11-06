
`timescale 1ns/1ps

module tb_lfsr_counter;
    parameter CLK_PERIOD = 10;
    reg     clk;
    reg     rst;
    reg     en;
    wire    tc;
    wire[7:0] q;

    // Instancia del registro
    lfsr_counter uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .tc(tc),
        .q(q));

    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Verificacion
    initial begin

        $dumpfile("tb_lfsr_counter.vcd");
        $dumpvars(0, tb_lfsr_counter);
        $monitor("tiempo[ns]: %08d q: %08b",$time,q);
       
        rst = 1; 
        en  = 1;
        #(CLK_PERIOD*2);
        rst = 0;

        #(260*CLK_PERIOD);
        
        $finish;
    end
endmodule