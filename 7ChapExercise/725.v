module shift_register_8stage_16bit (
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] A, B, C, D, E, F, G, H
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 16'b0;
            B <= 16'b0;
            C <= 16'b0;
            D <= 16'b0;
            E <= 16'b0;
            F <= 16'b0;
            G <= 16'b0;
            H <= 16'b0;
        end
        else begin
            A <= data_in;
            B <= A;
            C <= B;
            D <= C;
            E <= D;
            F <= E;
            G <= F;
            H <= G;
        end
    end

endmodule


`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg reset;
    reg [15:0] data_in;
    wire [15:0] A, B, C, D, E, F, G, H;

    // Instantiate the shift register module
    shift_register_8stage_16bit dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .H(H)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Initial values
    initial begin
        clk = 0;
        reset = 1;
        data_in = 16'hABCD; // Input data
        #10 reset = 0; // De-assert reset
        #100 $finish; // End simulation
    end

endmodule