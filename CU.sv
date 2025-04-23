`timescale 1ns / 1ps
`include "ptype.svh"

module CU (
    input logic clk, rst,
    input logic [15:0] op1,
    input logic [15:0] op2,
    input operation_t op,
    input powermode_t pmode,
    output logic [15:0]result,
    output flags_t fls
);
    logic sysclk;
    ClockGater cg1(.rst(rst), .p(pmode), .clk(clk), .oclk(sysclk));

    logic is_mul;
    logic is_div;
    logic is_alu;

    logic mul_clk;
    logic div_clk;

    and2 _andm(.a(is_mul), .b(sysclk), .c(mul_clk));
    and2 _andd(.a(is_div), .b(sysclk), .c(div_clk));

//    logic [15:0] rop1;
//    logic [15:0] rop2;
//    dflop opreg1(.d(op1), .clk(sysclk), .q(rop1));
//    dflop opreg2(.d(op2), .clk(sysclk), .q(rop2)); 

    logic [15: 0] alu_res;
    flags_t alu_fls;
    ALU alu1(.en(is_alu), .op1(op1), .op2(op2), .op(op), .result(alu_res), .fls(alu_fls));

    logic [15: 0] mul_res;
    logic mul_bsy;
    logic mul_start;
    logic mul_done;
    logic [15: 0] mul_result;
    sequential_multiplier_16bit mul1(.clk(mul_clk), .rst(rst), .start(mul_start), .a(op1), .b(op2), .product(mul_result), .done(mul_done), .bsy(mul_bsy));

    always_comb begin
        if(is_mul) result = mul_result;
        else if(is_alu) begin
            result = alu_res;
            fls = alu_fls;
        end
    end
    always_comb begin
        if(rst) begin
            is_alu = 0;
            is_mul = 0;
            is_div = 0;
            result = 0;
        end
        else if (!mul_bsy) begin
            case (op)
                MUL: begin is_mul = 1; is_alu = 0; mul_start = 1; end
                ADD, SUB, GTE, LT, NOT1: begin is_alu = 1; is_mul = 0;end
                default: begin
                    is_alu = 0;
                    is_mul = 0;
                end
            endcase
        end
        else if (mul_done) begin
            mul_start = 0;
        end
    end
    always_ff @( posedge clk or posedge rst) begin  
    end
endmodule