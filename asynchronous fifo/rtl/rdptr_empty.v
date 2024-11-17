module rdptr_empty #(
    parameter ADDRSIZE = 8 
)(
    input rd_clk,              // Read clock
    input rd_rst,              // Asynchronous reset (active low)
    input rd_en,               // Read enable signal
    input [ADDRSIZE:0] wr_ptr_sync, // Write pointer synchronized to the read clock domain
    output [ADDRSIZE-1:0] rd_addr,  // Read address (binary format)
    output reg [ADDRSIZE:0] rd_gray_ptr, // Read pointer in Gray code format
    output reg empty            // Empty flag
);

    //------------------------------------------------------------------
    // Binary Read Pointer (rd_bin)
    //------------------------------------------------------------------
    reg [ADDRSIZE:0] rd_bin;         // Read pointer in binary format
    wire [ADDRSIZE:0] rd_bin_next;   // Next state of the binary read pointer

    assign rd_bin_next = rd_bin + (rd_en && !empty);
    assign rd_addr = rd_bin[ADDRSIZE-1:0]; 

    always @(posedge rd_clk or negedge rd_rst) begin
        if (!rd_rst) begin
            rd_bin <= 0; 
        end else begin
            rd_bin <= rd_bin_next; 
        end
    end
    

    //------------------------------------------------------------------
    // Convert Binary to Gray Code
    //------------------------------------------------------------------
    wire [ADDRSIZE:0] rd_gray_next; // Next state of the Gray code pointer

    // Generate Gray code from the next binary read pointer
    assign rd_gray_next = rd_bin_next ^ (rd_bin_next >> 1);
    always @(posedge rd_clk or negedge rd_rst) begin
        if (!rd_rst) begin
            rd_gray_ptr <= 0;
        end else begin
            rd_gray_ptr <= rd_gray_next; 
        end
    end

    //--------------------------------------------------------------------
    // Empty Flag Generation
    //--------------------------------------------------------------------
    wire empty_tmp; 
    assign empty_tmp = (wr_ptr_sync == rd_gray_next);

    // Update the empty flag based on the temporary value
    always @(posedge rd_clk or negedge rd_rst) begin
        if (!rd_rst) begin
            empty <= 1; 
        end else begin
            empty <= empty_tmp; 
        end
    end

endmodule
