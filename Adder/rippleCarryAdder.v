module full_adder1b(
    input a, b, c,
    output sum, cout
);
    wire w1, w2;
    xor(w1, a, b);
    xor(sum, w1, c);
    assign cout = ((a & b) | (b & c) | (c & a));
endmodule

module parallel_adder4b (
    input [3:0]x, y,
    input cin,
    output [3:0] sum,
    output carry
);
    wire cout1, cout2, cout3;
    full_adder1b FA1 (x[0], y[0], cin, sum[0], cout1);
    full_adder1b FA2 (x[1], y[1], cout1, sum[1], cout2);
    full_adder1b FA3 (x[2], y[2], cout2, sum[2], cout3);
    full_adder1b FA4 (x[3], y[3], cout3, sum[3], carry);
endmodule

module tb_adder4b(
	output reg [3:0] bin1, bin2,
    output reg cin,
	input [3:0]sum,
    input carry
);
	initial begin
		$monitor("%t, When bin1=%b, bin2=%b cin=%b then Result is =%b , Carry =%b",$time,bin1,bin2,cin,sum,carry);
		   {bin1,bin2,cin} = 9'b010110100;
		#5 {bin1,bin2,cin} = 9'b001111101;
		#5 {bin1,bin2,cin} = 9'b111100110;
		#5 {bin1,bin2,cin} = 9'b011100011;
		#5 {bin1,bin2,cin} = 9'b000000011;
		#5 {bin1,bin2,cin} = 9'b111100000;
		#5 {bin1,bin2,cin} = 9'b011100011;
		#5 {bin1,bin2,cin} = 9'b011100010;
        #5 $finish;
	end
endmodule

module wb;
    wire [3:0] bin1, bin2, sum;
    wire cin, carry;
    initial begin
        $dumpfile("parallel_adder.vcd");
        $dumpvars(0, wb);
    end
    parallel_adder4b dut (bin1, bin2, cin, sum, carry);
    tb_adder4b tb (bin1, bin2, cin, sum, carry);
endmodule