//half adder using data flow modeling
module half_adder_d (
    input a,b,
    output sum,carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule

module half_adder_tb;
reg a,b;
wire sum,carry;

half_adder_d uut(a,b,sum,carry);

initial begin
a = 0; b = 0;
#10
b = 0; b = 1;
#10
a = 1; b = 0;
#10
b = 1; b = 1;
#10
$finish();
end
                
endmodule