`timescale 1ns/1ps

module not_gate(input a, output b);
    assign b = ~a;
endmodule


module not_tb;
    reg a;
    wire b;

    not_gate uut (
        .a(a),
        .b(b)
    );

    initial begin
        a = 0;
        #10;
        $display("a=%b, b=%b", a, b);

        a=1;
        #10;
        $display("a=%b, b=%b", a, b);

        $finish;
    end
endmodule

module mux4x1s (
    input [3:0] in, input [1:0] s, output out
);
    wire [1:0] sbar;
    wire [3:0] t;
    not (sbar[1], s[1]), (sbar[0], s[0]);
    and (t[3], in[3], sbar[1], sbar[0]), 
        (t[2], in[2], sbar[1], s[0]), 
        (t[1], in[1], s[1], sbar[0]), 
        (t[0], in[0], s[1], s[0]);
    or (out, t[3], t[2], t[1], t[0]);
endmodule


module mux4x1b(
    input [3:0] in, input [1:0] s, output reg out
);
    always @(*) begin
        case (s)
            2'b00: out <= in[3];
            2'b01: out <= in[2];
            2'b10: out <= in[1];
            2'b11: out <= in[0];
        endcase
    end
endmodule


module mux4x1_tb;
    reg [3:0] in;
    reg [1:0] s;
    wire out;

    mux4x1s uut (
        .in(in),
        .s(s),
        .out(out)
    );

    initial begin
        in = 4'b0011; 
        for (integer i = 0; i < 4; i = i + 1) begin
            s = i[1:0];
            #10
            $display("in=%b, s=%b, out=%b", in, s, out);
        end
        $finish;
    end
endmodule