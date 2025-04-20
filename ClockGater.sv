`include "ptype.svh"
module ClockGater (
    input logic rst, input powermode_t p, input logic clk, output logic oclk
);
    logic [1: 0] cnt;
    logic [2: 0]divider;

    always_comb begin
        case(p)
            SHUTDOWN: divider = 5; // casue cnt can never reach here oclk will always be 0
            LP: divider = 1;    // cuts the frequency by half
            NORMAL: divider = 0;
            default: divider = 0;
        endcase
    end

    always_ff @( posedge rst or posedge clk) begin
        if (rst) begin
            cnt <= 0;
            oclk <= 0;
        end
        else begin
            if(cnt == divider) begin
                oclk <= ~oclk;
                cnt <= 0;
            end
            else if(p==SHUTDOWN) oclk <= clk;
            else cnt <= cnt + 1;
        end
    end
    
endmodule