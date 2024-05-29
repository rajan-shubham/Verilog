/*
How does a Verilog model for a D-flip-flop handle treating reset as the highest priority input?
*/

module DFlipFlop (
    input wire clk, reset, D,        
    output reg Q         
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 1'b0;       
    end else begin
        Q <= D;          
    end
end

endmodule