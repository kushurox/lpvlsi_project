`ifndef PTYPE_SVH
`define PTYPE_SVH

typedef enum logic [2:0] {MUL, ADD, SUB, GTE, LT, NOT1} operation_t;

typedef struct packed {
    logic carry;
} flags_t;
`endif