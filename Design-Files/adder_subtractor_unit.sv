`timescale 1ns / 1ps

module adder_subtractor_unit#(parameter N = 4)( //Not exactly parametrized but it keeps some logic neater
    input logic[N-1:0] A,
    input logic[N-1:0] B,
    input logic Cin,
    input logic ctrl,
    output logic[N-1:0] Sum,
    output logic Cout
);

logic[N-1:0] B_xor;
logic[N-1:0] G;
logic[N-1:0] P;
logic[N:0] C;

genvar j;
generate
    for(j = 0; j<N; j++) begin : generate_propagate
        assign B_xor[j] = B[j]^ctrl;
        assign G[j] = A[j]&B_xor[j];
        assign P[j] = A[j]^B_xor[j];
    end
endgenerate

assign C[0] = Cin;
assign C[1] = G[0]|(P[0]&C[0]);
assign C[2] = G[1]|(P[1]&G[0])|(P[1]&P[0]&C[0]);
assign C[3] = G[2]|(P[2]&G[1])|(P[2]&P[1]&G[0])|(P[2]&P[1]&P[0]&C[0]);
assign C[4] = G[3]|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0])|(P[3]&P[2]&P[1]&P[0]&C[0]);

genvar k;
generate
    for(k = 0; k<N; k++) begin : sum_terms
        assign Sum[k] = P[k]^C[k];
    end
endgenerate

assign Cout = C[4];
endmodule