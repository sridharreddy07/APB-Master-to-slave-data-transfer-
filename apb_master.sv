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
        READ_ACCESS,
        READ_DONE,
        DONE
    } state_t;

    state_t state;
    logic [7:0] read_data_reg;
    logic done_printed;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            PSEL          <= 0;
            PENABLE       <= 0;
            PWRITE        <= 0;
            PADDR         <= 0;
            PWDATA        <= 0;
            read_data_reg <= 0;
            done_printed  <= 0;
        end else begin
            case (state)

                // -------- IDLE --------
                IDLE: begin
                    PSEL    <= 1;
                    PWRITE  <= 1;
                    PADDR   <= 8'h08;
                    PWDATA  <= 8'hA5;
                    PENABLE <= 0;
                    state   <= WRITE_SETUP;
                end

                // -------- WRITE SETUP --------
                WRITE_SETUP: begin
                    PENABLE <= 1;
                    state   <= WRITE_ACCESS;
                end

                // -------- WRITE ACCESS --------
                WRITE_ACCESS: begin
                    if (PREADY) begin
                        PSEL    <= 0;
                        PENABLE <= 0;
                        state   <= READ_SETUP;
                    end
                end

                // -------- READ SETUP --------
                READ_SETUP: begin
                    PSEL    <= 1;
                    PWRITE  <= 0;
                    PADDR   <= 8'h08;
                    PENABLE <= 0;
                    state   <= READ_ACCESS;
                end

                // -------- READ ACCESS --------
                READ_ACCESS: begin
                    PENABLE <= 1;

                    if (PREADY) begin
                        // ✅ Capture while signals still HIGH
                        read_data_reg <= PRDATA;
                        state <= READ_DONE;   // move to next cycle BEFORE deassert
                    end
                end

                // -------- HOLD ONE CYCLE --------
                READ_DONE: begin
                    // Keep PSEL & PENABLE HIGH for full valid cycle
                    PSEL    <= 1;
                    PENABLE <= 1;

                    state <= DONE;
                end

                // -------- DONE --------
                DONE: begin
                    // Now safely deassert
                    PSEL    <= 0;
                    PENABLE <= 0;

                    if (!done_printed) begin
                        $display("Time %0t : READ DATA = 0x%0h", $time, read_data_reg);
                        done_printed <= 1;
                    end
                end

            endcase
        end
    end

endmodule
