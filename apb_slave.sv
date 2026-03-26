module apb_slave (
    input  logic        PCLK,
    input  logic        PRESETn,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,
    input  logic [7:0]  PADDR,
    input  logic [7:0]  PWDATA,
    output logic [7:0]  PRDATA,
    output logic        PREADY
);

    logic [7:0] reg0;

    // Always ready
    assign PREADY = 1'b1;

    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            reg0   <= 8'h00;
            PRDATA <= 8'h00;
        end else begin

            // -------- WRITE --------
            if (PSEL && PENABLE && PWRITE) begin
                if (PADDR == 8'h08)
                    reg0 <= PWDATA;
            end

            // -------- READ --------
            if (PSEL && PENABLE && !PWRITE) begin
                if (PADDR == 8'h08)
                    PRDATA <= reg0;
                else
                    PRDATA <= 8'h00;
            end

            // ❗ No update outside ACCESS
        end
    end

endmodule
