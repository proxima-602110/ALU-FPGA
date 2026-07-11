`timescale 1ns/1ps
module logic_testbench;
parameter OPCODE_COUNT = 4;
logic[3:0] A;
logic[3:0] B;
logic[($clog2(OPCODE_COUNT)-1):0] OPCODE;
logic[3:0] logic_out;

localparam OP_NOT = 0;
localparam OP_AND = 1;
localparam OP_OR = 2;
localparam OP_XOR = 3;

logic_unit dut(.A(A),.B(B),.OPCODE(OPCODE),.logic_out(logic_out));
initial begin
$monitor("Time = %0t | A = %0b | B = %0b | OPCODE = %0d | out = %0b",$time,A,B,OPCODE,logic_out);
A=4'd1; B=4'bx;OPCODE = OP_NOT; #10;
A=4'd2; B=4'd5; OPCODE = OP_AND; #10;
A=4'd10; B=4'd7; OPCODE = OP_OR; #10;
A=4'hb; B=4'hF; OPCODE = OP_XOR; 
#20;
$finish;
end
endmodule