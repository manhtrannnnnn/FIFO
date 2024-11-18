module sync_2flops #(
    parameter DATASIZE = 8
)(
    input clk, rst,
    input [DATASIZE-1:0] data_in,
    output reg [DATASIZE-1:0] data_out
);
    reg [DATASIZE-1:0] data_tmp;
    always @(posedge clk) begin
        if(!rst) begin
            data_tmp <= 0;
            data_out <= 0;
        end
        else begin
            data_tmp <= data_in;
            data_out <= data_tmp;
        end
    end
endmodule
