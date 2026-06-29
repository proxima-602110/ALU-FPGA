`timescale 1ns / 1ps

module half_adder(
    input logic A,
    input logic B,
    output logic Sum,
    output logic Cout
);

assign Sum = A^B;
assign Cout = A&B;
endmodule

module full_adder(
    input logic A,
    input logic B,
    input logic Cin,
    output logic Sum,
    output logic Cout
);

assign Sum = A^B^Cin;
assign Cout = (A&B)|(Cin&(A^B));
endmodule

module rc_adder(
    input[5:0] A,
    input[5:0] B,
    input Cin,
    output[5:0] Sum,
    output Cout
);

logic[4:0] carry_stage; 

full_adder A1(.A(A[0]),.B(B[0]),.Cin(Cin),.Sum(Sum[0]),.Cout(carry_stage[0])); 
full_adder A2(.A(A[1]),.B(B[1]),.Cin(carry_stage[0]),.Sum(Sum[1]),.Cout(carry_stage[1]));
full_adder A3(.A(A[2]),.B(B[2]),.Cin(carry_stage[1]),.Sum(Sum[2]),.Cout(carry_stage[2]));
full_adder A4(.A(A[3]),.B(B[3]),.Cin(carry_stage[2]),.Sum(Sum[3]),.Cout(carry_stage[3]));
full_adder A5(.A(A[4]),.B(B[4]),.Cin(carry_stage[3]),.Sum(Sum[4]),.Cout(carry_stage[4]));
full_adder A6(.A(A[5]),.B(B[5]),.Cin(carry_stage[4]),.Sum(Sum[5]),.Cout(Cout));
endmodule

module multiplier_unit#(parameter N = 4)(
    input logic[N-1:0] A,
    input logic[N-1:0] B,
    output logic[(2*N)-1:0] P
    );

logic[((N*N)-1):0] and_term;    
logic[5:0] S;
logic[5:0] C;

genvar i,j,k,l;
generate
for(i = 0; i < N; i = i+1) begin : gen_and_terms1
    assign and_term[i] = A[i]&B[0]; //A0B0, A1B0, A2B0, A3B0
end
endgenerate

generate
for(j = N; j < 2*N; j = j+1) begin : gen_and_terms2
    assign and_term[j] = A[j-N]&B[1]; //A0B1, A1B1, A2B1, A3B1
end
endgenerate

generate
for(k = 2*N; k < 3*N; k = k+1) begin : gen_and_terms3
    assign and_term[k] = A[k-(2*N)]&B[2]; //A0B2, A1B2, A2B2, A3B2
end
endgenerate

generate
for(l = 3*N; l < 4*N; l = l+1) begin : gen_and_terms4
    assign and_term[l] = A[l-(3*N)]&B[3]; //A0B3, A1B3, A2B3, A3B3
end
endgenerate

full_adder FA1(.A(and_term[6]),.B(and_term[9]),.Cin(and_term[12]),.Sum(S[0]),.Cout(C[0])); //A2B1 + A1B2 + A0B3 -> S1, C1
half_adder HA1(.A(and_term[10]),.B(and_term[13]),.Sum(S[1]),.Cout(C[1])); //A2B2+A1B3 -> S2,C2
half_adder HA2(.A(and_term[5]),.B(and_term[8]),.Sum(S[2]),.Cout(C[2])); //A1B1+A0B2 -> S3,C3
full_adder FA2(.A(C[2]),.B(S[0]),.Cin(and_term[3]),.Sum(S[3]),.Cout(C[3])); //C3 + S1 + A3B0 -> S4,C4
full_adder FA3(.A(C[0]),.B(S[1]),.Cin(and_term[7]),.Sum(S[4]),.Cout(C[4])); //C1 + S2 + A3B1 -> S5,C5
full_adder FA4(.A(C[1]),.B(and_term[11]),.Cin(and_term[14]),.Sum(S[5]),.Cout(C[5])); //C2 + A3B2 + A2B3 -> S6,C6
rc_adder RCA(.A({C[4],C[3],C[5],S[5],and_term[2],and_term[1]}),.B({and_term[15],S[4],S[3],1'b0,S[2],and_term[4]}),.Cin(1'b0),.Sum(P[6:1]),.Cout(P[7]));

assign P[0] = and_term[0];

endmodule
