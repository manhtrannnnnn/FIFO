module asyn_fifo #(
    parameter DEPTH = 8,
    parameter DATASIZE = 4
)(
    //write domain
    input wr_clk, wr_rst, wr_en,
    input [DATASIZE-1:0] data_in,
    output full,

    //Read domain
    input rd_clk, rd_rst, rd_en,
    output [DATASIZE-1:0] data_out,
    output empty
);
    localparam ADDRSIZE = $clog2(DEPTH);

    wire[ADDRSIZE:0] wr_gray_ptr, rd_ptr_sync, wr_ptr_sync, rd_gray_ptr;
    wire[ADDRSIZE-1:0] wr_addr, rd_addr;
    
//----------------------------------------------------------------------
// Write domain logic
//----------------------------------------------------------------------
    wrptr_full#(.ADDRSIZE(ADDRSIZE)) wrptr_handle(
        .wr_clk(wr_clk),
        .wr_rst(wr_rst),
        .wr_en(wr_en),
        .rd_ptr_sync(rd_ptr_sync),
        .wr_addr(wr_addr),
        .wr_gray_ptr(wr_gray_ptr),
        .full(full)
    );
    //Synchronizer from read domain to write domain
    sync_2flops #(.DATASIZE(ADDRSIZE+1)) sync_rd2wr(
        .clk(wr_clk),
        .rst(wr_rst),
        .data_in(rd_gray_ptr),
        .data_out(rd_ptr_sync)
    );

//----------------------------------------------------------------------
// Read domain logic
//----------------------------------------------------------------------
    rdptr_empty #(.ADDRSIZE(ADDRSIZE)) rdptr_handle(
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .rd_en(rd_en),
        .wr_ptr_sync(wr_ptr_sync),
        .rd_addr(rd_addr),
        .rd_gray_ptr(rd_gray_ptr),
        .empty(empty)
    );
     //Synchronizer from write domain to read domain
    sync_2flops #(.DATASIZE(ADDRSIZE+1)) sync_rd2wr(
        .clk(rd_clk),
        .rst(rd_rst),
        .data_in(wr_gray_ptr),
        .data_out(wr_ptr_sync)
    );
//----------------------------------------------------------------------
// FIFO memory logic
//----------------------------------------------------------------------
    fifomem #(.DATASIZE(DATASIZE), .DEPTH(DEPTH)) mem(
        .data_in(data_in),
        .wr_en(wr_en),
        .wr_clk(wr_clk),
        .full(full),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .data_out(data_out)
    );
endmodule