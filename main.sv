typedef enum logic [2:0] {MUL, DIV, ADD, SUB, GTE, LT, NOT} operation_t;
typedef enum logic [1:0] {SHUTDOWN, LP, NORMAL} powermode_t;


typedef struct packed {
    logic carry;
    logic overflow;
    logic zero;
    logic sign;
} flags_t;


module CU (
    input logic clk, rst,
    input logic [15:0] op1,
    input logic [15:0] op2,
    input operation_t op,
    input powermode_t pmode,
    output logic [15:0]result,
    output flags_t fls
);

    logic is_mul;
    logic is_div;
    logic is_alu;

    logic mul_clk;
    logic div_clk;

    and2 _andm(.a(is_mul), .b(clk), .c(mul_clk));
    and2 _andd(.a(is_div), .b(clk), .c(div_clk));

    logic [15:0] rop1;
    logic [15:0] rop2;
    dflop opreg1(.d(op1), .clk(clk), .q(rop1));
    dflop opreg2(.d(op2), .clk(clk), .q(rop2)); 

    always_ff @( posedge clk or posedge rst) begin
        if(rst) begin
            is_alu <= 0;
            is_mul <= 0;
            is_div <= 0;
        end
        else begin
            case (op)
                MUL: is_mul <= 1;
                DIV: is_div <= 1;
                ADD, SUB, GTE, LT, NOT: is_alu <= 1;
                default: begin
                    is_alu <= 0;
                    is_div <= 0;
                    is_mul <= 0;
                end
            endcase
        end
    end



endmodule


module ALU (
    input logic en, 
    input logic [15:0] op1, 
    input logic [15:0] op2,
    input operation_t op,
    output logic [15:0]result,
    output flags_t fls
);

    logic [16:0]temp;

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
    else if(op == NOT) begin
        result = ~op1;
    end
    else begin
        result = 0;
    end
end

endmodule

module sequential_multiplier_16bit (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,
    input  logic [15:0]  a,
    input  logic [15:0]  b,
    output logic [31:0]  product,
    output logic         done
);

    typedef enum logic [1:0] {
        IDLE,
        CALCULATE,
        FINISH
    } state_t;

    state_t state;

    logic [15:0] temp_a;
    logic [15:0] temp_b;
    logic [31:0] acc;
    logic [4:0]  count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            acc     <= 0;
            count   <= 0;
            done    <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        temp_a <= a;
                        temp_b <= b;
                        acc    <= 0;
                        count  <= 0;
                        state  <= CALCULATE;
                    end
                end

                CALCULATE: begin
                    if (temp_b[0])
                        acc <= acc + {{16{1'b0}}, temp_a};

                    temp_a <= temp_a << 1;
                    temp_b <= temp_b >> 1;
                    count  <= count + 1;

                    if (count == 15)
                        state <= FINISH;
                end

                FINISH: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

    assign product = acc;

endmodule
   

module dflop(
    input logic [15:0] d,
    input logic clk,
    output logic [15:0] q
);
   always_ff @(posedge clk) begin
    q <= d;
   end 
endmodule


module and2 (
    input logic a, b,
    output logic c
);
   assign c = a & b; 
endmodule