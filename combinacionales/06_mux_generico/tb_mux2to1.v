`timescale 1ns / 1ps

module tb_mux2to1();
    localparam N1 = 5;
    localparam N2 = 8;
    wire [N1-1:0] X11;
    wire [N1-1:0] X21;
    wire [N1-1:0] Y1;
    wire [N2-1:0] X12;
    wire [N2-1:0] X22;
    wire [N2-1:0] Y2;
    reg s;

    assign X11 = 5'b10101;
    assign X21 = 5'b01010;
    assign X12 = 8'h55;
    assign X22 = 8'haa;

    mux2to1 #(.N(N1)) mux5
    (.x1(X11),.x2(X21),.s(s),.y(Y1));

    mux2to1 #(.N(N2)) mux8
    (.x1(X12),.x2(X22),.s(s),.y(Y2));
    
initial begin
    
    $dumpfile("tb_mux2to1.vcd");
    $dumpvars(0, tb_mux2to1);

    s = 1'b0; #2;
    s = 1'b1; #2;
    s = 1'b0; #2;
    s = 1'b1; #2;
    $finish;
end

endmodule