`timescale 1ns/1ps

module tb_multiplicador;

    localparam N = 12;
    localparam CLK_PERIOD = 10;

    reg clk, rst, start;
    wire ready;
    reg [N-1:0] a, b;
    wire[N-1:0] p;
    

    multiplicador #(.N(N)) uut
    (   .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .p(p),
        .ready(ready)
    );

    task producto; 
        input integer a_val;
        input integer b_val;
        begin
            a = a_val;
            b = b_val;
            @(posedge clk);
            #CLK_PERIOD;
            start = 1;
            #CLK_PERIOD;
            start = 0;
            @(posedge ready);
            #CLK_PERIOD;
        end
    endtask

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("tb_multiplicador.vcd");
        $dumpvars(0,tb_multiplicador);
        $monitor("t: %08d\tp: %03d\tready: %b",$time,p,ready);
        rst = 1;
        start = 0;
        #(CLK_PERIOD*2);
        rst = 0;
        
        producto(3,4);
        producto(7,5);
        producto(4,3);
        producto(5,7);
        producto(11,2);
        producto(0,2);
        producto(3,0);
        
        #(CLK_PERIOD*10);
        $finish;
    end

endmodule