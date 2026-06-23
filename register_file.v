module register_file(
  input        clk, write_en,
  input  [4:0] write_addr, read_addr,
  input  [7:0] write_data,
  output [7:0] read_data
);
  reg [7:0] regs [0:31];
  assign read_data = regs[read_addr];
  always @(posedge clk)
    if (write_en) regs[write_addr] <= write_data;
endmodule

module testbench;
  reg        clk=0, write_en;
  reg  [4:0] write_addr, read_addr;
  reg  [7:0] write_data;
  wire [7:0] read_data;

  register_file uut(.clk(clk),.write_en(write_en),
    .write_addr(write_addr),.read_addr(read_addr),
    .write_data(write_data),.read_data(read_data));

  always #5 clk = ~clk;

  initial begin
    write_en=1; write_addr=5'd1; write_data=8'd42; #10;
    write_addr=5'd2; write_data=8'd99; #10;
    write_addr=5'd5; write_data=8'd7;  #10;
    write_en=0;
    read_addr=5'd1; #10; $display("Register[1] = %0d", read_data);
    read_addr=5'd2; #10; $display("Register[2] = %0d", read_data);
    read_addr=5'd5; #10; $display("Register[5] = %0d", read_data);
    $finish;
  end
endmodule
