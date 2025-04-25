`include "ptype.svh"
module ALU ( 
    input logic [15:0] op1, 
    input logic [15:0] op2,
    input operation_t op,
    output logic [15:0]result,
    output flags_t fls
);

    logic [16:0]temp;
    // could have used case here but forgot it existed
    always_comb begin
        if(op == ADD) begin
            temp = {1'b0, op1} + {1'b0, op2};
            fls.carry = temp[16];
            result = temp[15:0];
        end
        else if(op == SUB) begin
            temp = {1'b0, op1} - {1'b0, op2};
            fls.carry = temp[16];
            result = temp[15:0];
        end
        else if(op == GTE) begin
            temp = {1'b0, op1} - {1'b0, op2};
            fls.carry = temp[16];
            result = temp[15:0];
        end
        else if(op == LT) begin
            temp = {1'b0, op1} - {1'b0, op2};
            fls.carry = temp[16];
            result = temp[15:0];
        end
        else if(op == NOT1) begin
            result = ~op1;
        end
        else begin
            result = 0;
        end
    end

endmodule