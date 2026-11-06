/*module tres_unos (
    input wire [7:0] x,
    output wire y);

    wire [5:0] unos;
    assign unos[0] = (x[7:5]==3'b111)? 1'b1 : 1'b0;
    assign unos[1] = (x[6:4]==3'b111)? 1'b1 : 1'b0;
    assign unos[2] = (x[5:3]==3'b111)? 1'b1 : 1'b0;
    assign unos[3] = (x[4:2]==3'b111)? 1'b1 : 1'b0;
    assign unos[4] = (x[3:1]==3'b111)? 1'b1 : 1'b0;
    assign unos[5] = (x[2:0]==3'b111)? 1'b1 : 1'b0;
    assign y = (unos!=6'd0)? 1'b1: 1'b0;

endmodule
*/

/*
module tres_unos (
    input  wire [7:0] x,
    output reg  y
);
    always @(x) begin
        if (x[7:5] == 3'b111)
            y = 1'b1;
        else if (x[6:4] == 3'b111)
            y = 1'b1;
        else if (x[5:3] == 3'b111)
            y = 1'b1;
        else if (x[4:2] == 3'b111)
            y = 1'b1;
        else if (x[3:1] == 3'b111)
            y = 1'b1;
        else if (x[2:0] == 3'b111)
            y = 1'b1;
        else
            y = 1'b0;
    end
endmodule
*/


module tres_unos (
    input  wire [7:0] x,
    output reg  y
);
    integer i;
    always @(*) begin
        y = 1'b0;
        for (i = 0; i <= 5; i = i + 1) begin
            if (x[i +: 3] == 3'b111)
                y = 1'b1;
        end
    end
endmodule

