module alu(
  input  [7:0] a, b,
  input  [2:0] op,
  output reg [7:0] result
);
  always @(*) begin
    case(op)
      3'd0: result = a + b;
      3'd1: result = a - b;
      3'd2: result = a & b;
      3'd3: result = a | b;
      default: result = 8'd0;
    endcase
  end
endmodule

module register_file(
  input        clk, write_en,
  input  [4:0] write_addr, read_addr1, read_addr2,
  input  [7:0] write_data,
  output [7:0] read_data1, read_data2
);
  reg [7:0] regs [0:31];
  assign read_data1 = regs[read_addr1];
  assign read_data2 = regs[read_addr2];
  always @(posedge clk)
    if (write_en) regs[write_addr] <= write_data;
endmodule

module program_counter(
  input        clk, reset,
  output reg [7:0] pc
);
  always @(posedge clk) begin
    if (reset) pc <= 8'd0;
    else       pc <= pc + 8'd4;
  end
endmodule

module decoder(
  input  [31:0] instr,
  output [4:0]  rs1, rs2, rd,
  output [2:0]  funct3,
  output [6:0]  opcode
);
  assign opcode = instr[6:0];
  assign rd     = instr[11:7];
  assign funct3 = instr[14:12];
  assign rs1    = instr[19:15];
  assign rs2    = instr[24:20];
endmodule

module testbench;
  reg clk=0, reset;
  always #5 clk = ~clk;

  wire [7:0] pc;
  program_counter PC(.clk(clk),.reset(reset),.pc(pc));

  reg        write_en;
  reg  [4:0] waddr, raddr1, raddr2;
  reg  [7:0] wdata;
  wire [7:0] rdata1, rdata2;
  register_file RF(.clk(clk),.write_en(write_en),
    .write_addr(waddr),.read_addr1(raddr1),.read_addr2(raddr2),
    .write_data(wdata),.read_data1(rdata1),.read_data2(rdata2));

  reg  [2:0] op;
  wire [7:0] alu_out;
  alu ALU(.a(rdata1),.b(rdata2),.op(op),.result(alu_out));

  reg  [31:0] instr;
  wire [4:0]  rs1,rs2,rd;
  wire [2:0]  funct3;
  wire [6:0]  opcode;
  decoder DEC(.instr(instr),.rs1(rs1),.rs2(rs2),
    .rd(rd),.funct3(funct3),.opcode(opcode));

  initial begin
    reset=1; write_en=0; #10; reset=0;
    $display("=== PicoRV32 CPU SIMULATION ===");
    $display("PC starts at: %0d", pc);

    write_en=1;
    waddr=5'd1; wdata=8'd15; #10;
    waddr=5'd2; wdata=8'd10; #10;
    waddr=5'd3; wdata=8'd6;  #10;
    write_en=0;

    raddr1=5'd1; raddr2=5'd2; #10;
    $display("\n-- Register File --");
    $display("x1 = %0d", rdata1);
    $display("x2 = %0d", rdata2);

    $display("\n-- ALU Operations --");
    op=3'd0; #10; $display("x1 + x2 = %0d", alu_out);
    op=3'd1; #10; $display("x1 - x2 = %0d", alu_out);
    op=3'd2; #10; $display("x1 & x2 = %0d", alu_out);
    op=3'd3; #10; $display("x1 | x2 = %0d", alu_out);

    instr = 32'b0000000_00011_00010_000_00001_0110011; #10;
    $display("\n-- Instruction Decoder --");
    $display("Opcode = %b", opcode);
    $display("RD=x%0d RS1=x%0d RS2=x%0d", rd, rs1, rs2);

    $display("\n-- Program Counter --");
    $display("PC = %0d", pc);
    #10; $display("PC = %0d", pc);
    #10; $display("PC = %0d", pc);

    $display("\n=== CPU SIMULATION COMPLETE ===");
    $finish;
  end
endmodule
