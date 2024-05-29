module shift_register_8_stage (
    input wire clk,       // Clock input
    input wire reset,     // Reset input (active high)
    input wire [15:0] d,  // 16-bit Data input
    output reg [15:0] A,  // Stage 1 output
    output reg [15:0] B,  // Stage 2 output
    output reg [15:0] C,  // Stage 3 output
    output reg [15:0] D,  // Stage 4 output
    output reg [15:0] E,  // Stage 5 output
    output reg [15:0] F,  // Stage 6 output
    output reg [15:0] G,  // Stage 7 output
    output reg [15:0] H   // Stage 8 output
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
    end else begin
        H <= G;
        G <= F;
        F <= E;
        E <= D;
        D <= C;
        C <= B;
        B <= A;
        A <= d;
    end
end

endmodule