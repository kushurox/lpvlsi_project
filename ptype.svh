`ifndef PTYPE_SVH
`define PTYPE_SVH

typedef enum logic [2:0] {MUL, DIV, ADD, SUB, GTE, LT, NOT} operation_t;
typedef enum logic [1:0] {SHUTDOWN, LP, NORMAL} powermode_t;

typedef struct packed {
    logic carry;
    logic overflow;
    logic zero;
    logic sign;
} flags_t;
`endif