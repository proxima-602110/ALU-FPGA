module multiplier_testbench;
logic[3:0] A;
logic[3:0] B;
logic[7:0] P;
logic err_flag;

multiplier_unit dut(.A(A),.B(B),.P(P));

initial begin
err_flag = 1'b0;
$monitor("Time  :  %0t | A  :  %0d | B : %0d | P : %0d",$time,A,B,P);
for(int a=0; a<16; a++) begin
    for(int b=0; b<16; b++) begin
        A=a;
        B=15-b;
        #2;
        if(P!==A*B) 
            $display("Error in multiplication  of %0d and %0d. Got %0d but expected %0d ",A,B,P,A*B);
    end
end
#5;
if(!err_flag) 
    $display("All tests passed!");
#10;
$finish;
end
endmodule