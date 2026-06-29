`timescale 1ns / 1ps
module barrel_shifter#(parameter N = 4)(
    input logic[N-1:0] X,
    input logic[($clog2(N))-1:0] sel,
    output[N-1:0] result);

logic[N-1:0] X_shifted[N-1:0];
genvar i;
generate
for(i = 0; i < N; i++) begin : generate_shift
    assign X_shifted[i] = X>>i;
end
endgenerate

assign result = X_shifted[sel];
endmodule