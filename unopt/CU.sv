`include "ptype.svh"

module CU(
    input logic [15:0] op1,
    input logic [15:0] op2,
    input operation_t op,
    output logic [15:0]result,
    output flags_t fls
);
    logic [15:0] alu_res;
    ALU alu1(.op1(op1), .op2(op2), .op(op), .result(alu_res), .fls(fls));
    
    logic [15:0] mul_res;
    multiplier mul1(.op1(op1), .op2(op2), .result(mul_res));
    
    always_comb begin
        if(op==MUL) result = mul_res;
        else result = alu_res;
    end

endmodule