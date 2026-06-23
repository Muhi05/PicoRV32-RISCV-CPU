module alu(
  input  [3:0] a, b,
  input  [2:0] op,
  output reg [3:0] result
);
  always @(*) begin
    case(op)
      3'd0: result = a + b;
      3'd1: result = a - b;
      3'd2: result = a & b;
      3'd3: result = a | b;
      3'd4: result = a ^ b;
      3'd5: result = a << 1;
      default: result = 4'd0;
    endcase
  end
endmodule

module testbench;
  reg  [3:0] a, b;
  reg  [2:0] op;
  wire [3:0] result;

  alu uut(.a(a), .b(b), .op(op), .result(result));

  initial begin
    a=4'd9;  b=4'd3; op=3'd0; #10; $display("ADD  9+3   = %0d", result);
    a=4'd9;  b=4'd3; op=3'd1; #10; $display("SUB  9-3   = %0d", result);
    a=4'd6;  b=4'd3; op=3'd2; #10; $display("AND  6&3   = %0d", result);
    a=4'd6;  b=4'd3; op=3'd3; #10; $display("OR   6|3   = %0d", result);
    a=4'd6;  b=4'd3; op=3'd4; #10; $display("XOR  6^3   = %0d", result);
    a=4'd3;  b=4'd0; op=3'd5; #10; $display("SHL  3<<1  = %0d", result);
    $finish;
  end
endmodule
