module fifomem #(
    parameter DATASIZE = 8,            
    parameter DEPTH = 16,               
    localparam ADDRSIZE = $clog2(DEPTH) 
)(
    input [DATASIZE-1:0] data_in,      
    input wr_en,                     
    input wr_clk,                   
    input full,                       
    input [DATASIZE-1:0] wr_addr,      
    input [DATASIZE-1:0] rd_addr,       
    output [DATASIZE-1:0] data_out      
);

    // Memory array to store FIFO data
    reg [DATASIZE-1:0] mem [DEPTH-1:0];

    // Write logic
    always @(posedge wr_clk) begin
        if (wr_en && !full) begin
            mem[wr_addr] <= data_in; // Write data_in to memory
        end
    end

    // Read logic
    assign data_out = mem[rd_addr];

endmodule
