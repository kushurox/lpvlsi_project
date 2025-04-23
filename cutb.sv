`include "ptype.svh"

module cutb();
    logic clk;
    logic rst;
    logic [15:0] op1;
    logic [15:0] op2;
    operation_t op;
    powermode_t pmode;
    logic [15:0] result;
    flags_t fls;

    always #1 clk = ~clk;
    CU dut(
        .clk(clk),
        .rst(rst),
        .op1(op1),
        .op2(op2),
        .op(op),
        .pmode(pmode),
        .result(result),
        .fls(fls)
    );
    initial begin
        clk = 0;
        rst = 1;
        op1 = 0;
        op2 = 0;
        pmode = LP;
        op = ADD;
        #3
        rst = 0;
        op1 = 2;
        op2 = 4;
        #5
        op1 = 2;
        op2 = 5;
        op = MUL;        
        #30
        rst = 1;
        #20
        $finish;
    end
endmodule
`include "ptype.svh"

module cutb()
    
    logic clk, rst;
    logic [15:0] op1;
    logic [15:0] op2;
    operation_t op;
    powermode_t pmode;
    logic [15:0] result
    flags_t fls;

    always #5 clk = ~clk;
    CU dut(
        .clk(clk),
        .rst(rst),
        .op1(op1),
        .op2(op2),
        .pmode(pmode),
        .result(result),
        .fls(fls)
    )
    initial begin
        clk = 0;
        rst = 1;
        op1 = 0;
        op2 = 0;
        pmode = NORMAL;
        op = ADD;
        #5
        rst = 0;
        op1 = 2;
        op2 = 4;
        #5
        op1 = 2;
        op2 = 3;
        op = MUL;        
        #18
        $finish
    end

endmodule