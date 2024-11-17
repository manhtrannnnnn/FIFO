module bin2gray_tb;

    parameter WIDTH = 6;
    parameter clkp = 5;
    integer i;

    reg [WIDTH-1:0] data_bin;
    wire [WIDTH-1:0] data_gray;
    reg [WIDTH-1:0] expected_gray; 

    // Instantiation of DUT
    bin2gray #(.WIDTH(WIDTH)) dut (
        .data_bin(data_bin),
        .data_gray(data_gray)
    );

    initial begin
        data_bin = 0;
        for (i = 0; i < (1 << WIDTH); i = i + 1) begin
            #clkp;
            data_bin = i;
            #1;
            expected_gray = data_bin ^ (data_bin >> 1);
            if (data_gray !== expected_gray) begin
                $display("ERROR: At time %t, data_bin=%b, data_gray=%b, expected=%b", 
                          $time, data_bin, data_gray, expected_gray);
            end else begin
                $display("PASS: At time %t, data_bin=%b, data_gray=%b", 
                          $time, data_bin, data_gray);
            end
        end
        #100;
        $finish;
    end

    // Dump waveforms
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, bin2gray_tb);
    end
endmodule
