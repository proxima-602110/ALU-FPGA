`timescale 1ns/1ps
module adder_testbench;

logic[3:0] A;
logic[3:0] B;
logic Cin;
logic ctrl;
logic[3:0] Sum;
logic Cout;
logic err_flag;
adder_subtractor_unit DUT(.A(A),.B(B),.Cin(Cin),.ctrl(ctrl),.Sum(Sum),.Cout(Cout));
//Adder simulation (CTRL = 0)
initial begin 
err_flag = 1'b0;
$monitor("A= %0d | B = %0d | Cin = %0b | ctrl = %0b | Sum = %0d | Cout = %0b",A,B,Cin,ctrl,Sum,Cout);
ctrl = 1'b0;
for(int a = 0; a<16; a++) begin
    for(int b=0; b<16; b++) begin
        for(int c=0 ;c<2; c++) begin
            A=a; 
            B=15-b;
            Cin = c;
            #2;
            if({Cout,Sum}!==(A+B+Cin)) begin 
                err_flag = 1'b1;
                $display("Error in addition of %0d and %0d with carry in %0b. Got %0d with a carry out of %0d, but expected %0d",A,B,Cin,Sum,Cout,A+B+Cin);
            
            end
         end
    end
end
                
if(!err_flag)
    $display("All cases passed!");
#10;
$finish;
end
endmodule