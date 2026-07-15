`timescale 1ns/1ps

module testbench_alu;
logic[3:0] A;
logic[3:0] B;
logic Cin;
logic ADDSUB_CTRL;
logic[1:0] ALU_OPCODE;
logic[1:0] LOGIC_SEL; 
logic[1:0] SHIFT_SEL;
logic[7:0] RESULT;
logic FLAG_COUT;
logic error_flag;

localparam OP_ADDSUB = 0;
localparam OP_MUL = 1;
localparam OP_LOGIC = 2;
localparam OP_SHIFT = 3;
localparam OP_NOT = 0 ;
localparam OP_AND = 1;
localparam OP_OR = 2;
localparam OP_XOR = 3;

alu_main ALU(.A(A),.B(B),.Cin(Cin),.ADDSUB_CTRL(ADDSUB_CTRL),.ALU_OPCODE(ALU_OPCODE),.LOGIC_SEL(LOGIC_SEL),.SHIFT_SEL(SHIFT_SEL),.RESULT(RESULT),.FLAG_COUT(FLAG_COUT));
initial begin
error_flag = 1'b0;
ADDSUB_CTRL = '0;
//Addition

for(int i = 0; i<16; i++) begin
    for(int j = 0; j<16; j++) begin 
        for(int k = 0; k<2; k++) begin
            A = i;
            B = j;
            Cin = k;
            ALU_OPCODE = OP_ADDSUB;
            #2;
            if({FLAG_COUT,RESULT[3:0]}!==(A+B+Cin)) begin
                error_flag = 1'b1;
                $display("Error in addition of %0d , %0d & carry in  %0b. Got Sum as %0d , but expected %0d.",A,B,Cin,{FLAG_COUT,RESULT[3:0]},A+B+Cin);
            end
        end
    end
end

if(!error_flag) 
    $display("All addition test cases passed!");

#50;
//Subtraction
ADDSUB_CTRL = 1'b1; 
for(int i = 0; i<16; i++) begin
    for(int j = 0; j<16; j++) begin 
        for(int k = 0; k<2; k++) begin
            A = i;
            B = j;
            Cin = k;
            ALU_OPCODE = OP_ADDSUB;
            #2;
            if({FLAG_COUT,RESULT[3:0]}!==(A+(B^{4{ADDSUB_CTRL}})+Cin)) begin
                error_flag = 1'b1;
                $display("Error in subtraction of %0d , %0d & carry in  %0b. Got Difference as %0d , but expected %0d.",A,B,Cin,{FLAG_COUT,RESULT[3:0]},(A+(B^{4{ADDSUB_CTRL}})+Cin));
            end
        end
    end
end

if(!error_flag)
    $display("All subtraction test cases passed!");
error_flag='0;

#50;
//Multiplication
ADDSUB_CTRL=1'b0;
for(int i = 0; i<16; i++) begin
    for(int j = 0 ; j<16; j++) begin
        A=i;
        B=j;
        ALU_OPCODE=OP_MUL;
        #2;
        if(RESULT[7:0]!==A*B) begin
            error_flag = 1'b1;
            $display("Error in multiplication  of %0d and %0d. Got %0d but expected %0d ",A,B,RESULT,A*B);
        end
     end
end

if(!error_flag) 
    $display("All multiplication test cases passed!");

#50;
//Logic Operation - NOT
for(int i = 0 ;i<16; i++) begin
    A = i;
    LOGIC_SEL = OP_NOT;
    ALU_OPCODE = OP_LOGIC;
    #2;
    if(RESULT[3:0]!==(~A)) begin
        error_flag = 1'b1;
        $display("Error in logical NOT of %0b. Got  %0b but expected  %0b",A,RESULT[3:0],(~A));
    end
end
        
if(!error_flag) 
    $display("All logic NOT  test cases passed!");
error_flag='0;
#50;
//Logic Operation - AND
for(int i = 0 ;i<16; i++) begin
    for(int j = 0; j<16; j++) begin
        A = i;
        B = j;
        LOGIC_SEL = OP_AND;
        ALU_OPCODE = OP_LOGIC;
        #2;
        if(RESULT[3:0]!==(A&B)) begin
            error_flag = 1'b1;
            $display("Error in logical AND of %0b and %0b. Got  %0b but expected  %0b",A,B,RESULT[3:0],(A&B));
        end
    end
end
        
if(!error_flag) 
    $display("All logic AND  test cases passed!");
error_flag='0;
#50;
//Logic Operation - OR
for(int i = 0 ;i<16; i++) begin
    for(int j = 0; j<16; j++) begin
        A = i;
        B = j;
        LOGIC_SEL = OP_OR;
        ALU_OPCODE = OP_LOGIC;
        #2;
        if(RESULT[3:0]!==(A|B)) begin
            error_flag = 1'b1;
            $display("Error in logical OR of %0b and %0b. Got  %0b but expected  %0b",A,B,RESULT[3:0],(A|B));
        end
    end
end
        
if(!error_flag) 
    $display("All logic OR  test cases passed!");
error_flag='0;
#50;
//Logic Operation - XOR
for(int i = 0 ;i<16; i++) begin
    for(int j = 0; j<16; j++) begin
        A = i;
        B = j;
        LOGIC_SEL = OP_XOR;
        ALU_OPCODE = OP_LOGIC;
        #2;
        if(RESULT[3:0]!==(A^B)) begin
            error_flag = 1'b1;
            $display("Error in logical XOR of %0b and %0b. Got  %0b but expected  %0b",A,B,RESULT[3:0],(A^B));
        end
    end
end
        
if(!error_flag) 
    $display("All logic XOR  test cases passed!");
error_flag = '0;

#50;
//Right Shifting
for(int i = 0; i<16;i++) begin
    for(int j = 0; j<4;j++) begin
          A=i;
          SHIFT_SEL = j;
          ALU_OPCODE = OP_SHIFT;
          #2;
          if(RESULT[3:0]!==(A>>j)) begin
            error_flag = 1'b1;
            $display("Error in right shifting %0b by %0b bits. Got %0b but expected %0b",A,j,RESULT[3:0],(A>>j));
          end
    end
end

if(!error_flag)
    $display("All shifting test cases passed!");
error_flag='0;    
$finish;
end
endmodule