module syn_fifo #(
    parameter WIDTH = 16,
    parameter DEPTH = 12
)(
    input clk, rst,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    input write_en,
    input read_en,
    output full,
    output empty
);
    localparam SIZE = $clog2(DEPTH);  

    reg [WIDTH-1:0] mem[DEPTH-1:0];
    reg [SIZE:0] write_ptr;
    reg [SIZE:0] read_ptr;

    // Reset state
    always @(posedge clk) begin
        if (!rst) begin
            data_out <= 0;
            write_ptr <= 0;
            read_ptr <= 0;
        end else begin
            // Write State
            if (write_en && !full) begin
                mem[write_ptr[SIZE-1:0]] <= data_in;
                write_ptr <= write_ptr + 1;
            end
            // Read State
            if (read_en && !empty) begin
                data_out <= mem[read_ptr[SIZE-1:0]];
                read_ptr <= read_ptr + 1;
            end
        end
    end

    // Full and empty flag logic
    assign empty = (write_ptr == read_ptr);
    assign full = (write_ptr[SIZE-1:0] == read_ptr[SIZE-1:0] && write_ptr[SIZE] != read_ptr[SIZE]);

endmodule
