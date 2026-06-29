`timescale 1ns / 1ps
module logic_unit#(parameter N = 4,
                   parameter OPCODE_COUNT = 4)(
    input logic[N-1:0] A,
    input logic[N-1:0] B,
    input logic[($clog2(OPCODE_COUNT)-1):0] OPCODE,
    output logic[N-1:0] logic_out
    );
    
localparam OP_NOT = 0;
localparam OP_AND = 1;
localparam OP_OR = 2;
localparam OP_XOR = 3;

always_comb begin
    logic_out = '0;
    case(OPCODE)
        OP_NOT : logic_out = ~A; 
        OP_AND : logic_out = A&B; 
        OP_OR : logic_out = A|B; 
        OP_XOR : logic_out = A^B; 
        default : logic_out = '0;
    endcase
end
endmodule
