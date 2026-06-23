module decoder(
  input  [31:0] instruction,
  output reg [4:0] rs1, rs2, rd,
  output reg [2:0] funct3,
  output reg [6:0] opcode
);
  always @(*) begin
    opcode = instruction[6:0];
    rd     = instruction[11:7];
    funct3 = instruction[14:12];
    rs1    = instruction[19:15];
    rs2    = instruction[24:20];
  end
endmodule

module testbench;
  reg  [31:0] instruction;
  wire [4:0]  rs1, rs2, rd;
  wire [2:0]  funct3;
  wire [6:0]  opcode;

  decoder uut(.instruction(instruction),
    .rs1(rs1),.rs2(rs2),.rd(rd),
    .funct3(funct3),.opcode(opcode));

  initial begin
    instruction = 32'b0000000_00011_00010_000_00001_0110011; #10;
    $display("Opcode = %b", opcode);
    $display("RD     = x%0d", rd);
    $display("RS1    = x%0d", rs1);
    $display("RS2    = x%0d", rs2);
    $display("Funct3 = %b", funct3);
    $display("--- Instruction Decoded! ---");
    $finish;
  end
endmodule
