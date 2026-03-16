`timescale 1ns/1ps
module apb_master (
    input  logic clk,
    input  logic rst,

    output logic       PSEL,
    output logic       PENABLE,
    output logic       PWRITE,
    output logic [7:0] PADDR,
    output logic [7:0] PWDATA,

    input  logic [7:0] PRDATA,
    input  logic       PREADY
);

    typedef enum logic [2:0] {
        IDLE,
        WRITE_SETUP,
        WRITE_ACCESS,
        READ_SETUP,
        READ_ACCESS
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            PSEL    <= 0;
            PENABLE <= 0;
            PWRITE  <= 0;
            PADDR   <= 0;
            PWDATA  <= 0;
        end else begin
            case (state)

                // ---------------- IDLE ----------------
                IDLE: begin
                    PSEL    <= 1;
                    PWRITE  <= 1;
                    PADDR   <= 8'h08;
                    PWDATA  <= 8'hA5;
                    PENABLE <= 0;          // SETUP
                    state   <= WRITE_SETUP;
                end

                // ---------------- WRITE SETUP ----------------
                WRITE_SETUP: begin
                    PENABLE <= 1;          // ACCESS
                    state   <= WRITE_ACCESS;
                end

                // ---------------- WRITE ACCESS ----------------
                WRITE_ACCESS: begin
                    if (PREADY) begin
                        PSEL    <= 0;
                        PENABLE <= 0;
                        state   <= READ_SETUP;
                    end
                end

                // ---------------- READ SETUP ----------------
                READ_SETUP: begin
                    PSEL    <= 1;
                    PWRITE  <= 0;
                    PADDR   <= 8'h08;
                    PENABLE <= 1;          // <-- assert PENABLE here
                    state   <= READ_ACCESS;
                end

                // ---------------- READ ACCESS ----------------
                READ_ACCESS: begin
                    // PENABLE already 1 from previous cycle
                    if (PREADY) begin
                        $display("Time %0t : Read Data = %h", $time, PRDATA);
                        PSEL    <= 0;
                        PENABLE <= 0;
                        state   <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
