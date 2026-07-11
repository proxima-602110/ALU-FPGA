`timescale 1ns/1ps
module shifter_testbench;
logic[3:0] X;
logic[1:0] sel;
logic[3:0] result;

barrel_shifter dut(.X(X),.sel(sel),.result(result));

initial begin
    $monitor("Time : %0t | X = %0b | sel = %0b | result = %0b",$time,X,sel,result);
    for(int i = 0; i<9; i++) begin
        for(int j = 0; j<4; j++) begin
                X = i; 
                sel = j;
                #10;
        end
    end
    #20;
    $finish;
end
endmodule