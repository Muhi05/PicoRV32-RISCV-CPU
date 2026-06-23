module testbench;
  reg [3:0] a, b;
  wire [4:0] sum;
  
  assign sum = a + b;
  
  initial begin
    a = 4'd3;  b = 4'd5;  #10;
    $display("3 + 5 = %0d", sum);
    
    a = 4'd7;  b = 4'd8;  #10;
    $display("7 + 8 = %0d", sum);
    
    a = 4'd15; b = 4'd15; #10;
    $display("15 + 15 = %0d", sum);
    
    $finish;
  end
endmodule
