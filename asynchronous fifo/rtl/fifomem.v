module fifomem #(
    parameter DATASIZE = 8,            
    parameter DEPTH = 16               
)(
    input [DATASIZE-1:0] data_in,      
    input wr_en,                     
    input wr_clk,                   
    input full,                       
    input [ADDRSIZE-1:0] wr_addr,      
    input [ADDRSIZE-1:0] rd_addr, 
    input rd_clk,
    input rd_en,
    input empty,      
    output reg [DATASIZE-1:0] data_out      
);
    localparam ADDRSIZE = $clog2(DEPTH);
    // Memory array to store FIFO data
    reg [DATASIZE-1:0] mem [DEPTH-1:0];

    // Write logic
    always @(posedge wr_clk) begin
        if (wr_en && !full) begin
            mem[wr_addr] <= data_in; // Write data_in to memory
        end
    end

    // Read logic
    always @(posedge rd_clk) begin
        if (rd_en && !empty) begin
            data_out <= mem[rd_addr]; // Write data_in to memory
        end
    end

endmodule
