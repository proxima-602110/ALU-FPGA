module alu_main#(parameter N = 4)(
    input logic[N-1:0] A,
    input logic[N-1:0] B,
    input logic Cin,
    input logic ADDSUB_CTRL,
    input logic[1:0] ALU_OPCODE,
    input logic[1:0] LOGIC_SEL,
    input logic[$clog2(N)-1:0] SHIFT_SEL,
    output logic[(2*N)-1:0] RESULT,
    output logic FLAG_COUT
    
);

localparam OP_ADDSUB = 2'd0;
localparam OP_MUL = 2'd1;
localparam OP_LOGIC = 2'd2;
localparam OP_SHIFT = 2'd3;

logic[N-1:0] addsub_out;
logic[(2*N)-1:0] multiplication_out;
logic[N-1:0] logic_out;
logic[N-1:0] shift_out;
logic addsub_cout;

adder_subtractor_unit #(.N(N)) U1(.A(A),.B(B),.Cin(Cin),.ctrl(ADDSUB_CTRL),.Sum(addsub_out),.Cout(addsub_cout));
multiplier_unit #(.N(N)) U2(.A(A),.B(B),.P(multiplication_out)); 
logic_unit #(.N(N)) U3(.A(A),.B(B),.OPCODE(LOGIC_SEL),.logic_out(logic_out));
barrel_shifter #(.N(N)) U4(.X(A),.sel(SHIFT_SEL),.result(shift_out));

always_comb begin
    RESULT = '0;
    FLAG_COUT = 1'b0;
    case(ALU_OPCODE)
        OP_ADDSUB : begin RESULT[N-1:0] = addsub_out; FLAG_COUT = addsub_cout; end
        OP_MUL : RESULT = multiplication_out;
        OP_LOGIC : RESULT[N-1:0] = logic_out;
        OP_SHIFT : RESULT[N-1:0] = shift_out;
        default : begin RESULT = '0; FLAG_COUT = 1'b0; end
    endcase
end
endmodule