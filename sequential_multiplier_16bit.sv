
module sequential_multiplier_16bit (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [15:0] a,
    input  logic [15:0] b,
    output logic [15:0] product,
    output logic done,
    output logic bsy
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
            state <= IDLE;
            acc <= 0;
            count <= 0;
            done <= 0;
            bsy <= 0;
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
                        bsy <= 1;
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
                    bsy <= 0;
                end
            endcase
        end
    end

    assign product = acc[15: 0];

endmodule