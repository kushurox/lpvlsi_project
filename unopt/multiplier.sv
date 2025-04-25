`timescale 1ns / 1ps

module multiplier(
    input logic [15:0] op1,
    input logic [15:0] op2,
    output logic [15:0]result
);
    assign result = op1 * op2;
endmodule
