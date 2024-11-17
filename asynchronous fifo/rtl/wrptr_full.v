module wrptr_full #(
    parameter ADDRSIZE = 8 // Width of the address pointers
)(
    input wr_clk,               // Write clock
    input wr_rst,               // Asynchronous reset (active low)
    input wr_en,                // Write enable signal
    input [ADDRSIZE:0] rd_ptr_sync, // Read pointer synchronized to the write clock domain
    output [ADDRSIZE-1:0] wr_addr,  // Write address (binary format)
    output reg [ADDRSIZE:0] wr_gray_ptr, // Write pointer in Gray code format
    output reg full              // Full flag
);

    //------------------------------------------------------------------
    // Binary Write Pointer (wr_bin)
    //------------------------------------------------------------------
    reg [ADDRSIZE:0] wr_bin;       
    wire [ADDRSIZE:0] wr_bin_next;
    // Increment write pointer if write is enabled and FIFO is not full
    assign wr_bin_next = wr_bin + (wr_en && !full);

    // Extract the lower WIDTH bits of the binary write pointer as the write address
    assign wr_addr = wr_bin[ADDRSIZE-1:0];
    always @(posedge wr_clk or negedge wr_rst) begin
        if (!wr_rst) begin
            wr_bin <= 0; 
        end else begin
            wr_bin <= wr_bin_next; 
        end
    end

    //------------------------------------------------------------------
    // Convert Binary to Gray Code
    //------------------------------------------------------------------
    wire [ADDRSIZE:0] wr_gray_next; 

    // Generate Gray code from the next binary write pointer
    assign wr_gray_next = wr_bin_next ^ (wr_bin_next >> 1);

    always @(posedge wr_clk or negedge wr_rst) begin
        if (!wr_rst) begin
            wr_gray_ptr <= 0; // Reset to 0
        end else begin
            wr_gray_ptr <= wr_gray_next; 
        end
    end

    //--------------------------------------------------------------------
    // Full Flag Generation
    //--------------------------------------------------------------------
    wire full_tmp; 
    assign full_tmp = (wr_gray_next == {~rd_ptr_sync[ADDRSIZE:ADDRSIZE-1], rd_ptr_sync[ADDRSIZE-2:0]});

    // Update the full flag based on the temporary value
    always @(posedge wr_clk or negedge wr_rst) begin
        if (!wr_rst) begin
            full <= 0; 
        end else begin
            full <= full_tmp;
        end
    end

endmodule
