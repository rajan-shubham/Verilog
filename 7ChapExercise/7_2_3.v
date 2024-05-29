module register32b(output reg [31:0] Data_out,
		    input wire Clock,Reset,En,
            input wire [31:0] Data_in);
       
    always @ (posedge Clock or negedge Reset)
        begin
          if (!Reset)
            Data_out <= 32'd0;
           else 
              if (En)
                Data_out <= Data_in;
       end
endmodule

module testbench;
    reg [31:0] Data_in;
    reg Clock, Reset, En;
    wire [31:0] Data_out;
    register32b DUT(Data_out, Clock, Reset, En, Data_in);

    initial begin
        $monitor ($time, " Data_in = %b, Clock = %b, Reset = %b, En = %b, Data_out = %b", Data_in, Clock, Reset, En, Data_out);
        Clock = 1'b0;
        Reset = 1'b1;
        En = 1'b1;

        #10 Data_in = 32'd8;
        #10 Data_in = 32'd16;
        
        #10 Data_in = 32'd10;
        #10 Data_in = 32'd6;
        #10 $finish;
    end


    always #5 Clock = ~Clock;

endmodule

