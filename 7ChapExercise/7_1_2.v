/*
7.1.2 question
*/
module DFlipFlop_en (
    input wire clk, reset, D,        
    output reg Q         
);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;  // Reset the output to 0
    else if (en)
        q <= d;     // Capture the input data if enable is high
end

endmodule