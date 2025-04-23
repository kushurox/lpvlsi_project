`ifndef PTYPE_SVH
`define PTYPE_SVH

typedef enum logic [2:0] {MUL, ADD, SUB, GTE, LT, NOT1} operation_t;
typedef enum logic [1:0] {SHUTDOWN, LP, NORMAL} powermode_t;

typedef struct packed {
    logic carry;
} flags_t;
`endif