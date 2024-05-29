module andGate (
    a, b, out
);
input a, b;
output out;

assign out = a & b;
    
endmodule


`timescale 1ns / 1ps

module andGate_tb;
    // Inputs
    reg a;
    reg b;

    // Output
    wire out;

    // Instantiate the Unit Under Test (UUT)
    andGate uut (
        .a(a), 
        .b(b), 
        .out(out)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;

        // Wait for global reset
        #10;
        
        // Test case 1: a = 0, b = 0
        #10 a = 0; b = 0;
        #10 $display("Test case 1: a = %b, b = %b, out = %b", a, b, out);
        
        // Test case 2: a = 0, b = 1
        #10 a = 0; b = 1;
        #10 $display("Test case 2: a = %b, b = %b, out = %b", a, b, out);
        
        // Test case 3: a = 1, b = 0
        #10 a = 1; b = 0;
        #10 $display("Test case 3: a = %b, b = %b, out = %b", a, b, out);
        
        // Test case 4: a = 1, b = 1
        #10 a = 1; b = 1;
        #10 $display("Test case 4: a = %b, b = %b, out = %b", a, b, out);
        
        // Finish simulation
        #10 $finish;
    end
      
endmodule
