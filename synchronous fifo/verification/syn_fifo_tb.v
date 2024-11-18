module syn_fifo_tb;

  parameter WIDTH = 16;
  parameter DEPTH = 16;
  parameter clkp = 40;

  // Inputs
  reg clk, rst;
  reg [WIDTH-1:0] data_in;
  reg write_en, read_en;

  // Outputs
  wire [WIDTH-1:0] data_out;
  wire full, empty;

  // Memory for data comparison
  reg [WIDTH-1:0] mem[0:DEPTH-1]; // Fixed-size array
  integer mem_head = 0; // Pointer for writing to the array
  integer mem_tail = 0; // Pointer for reading from the array

  // FIFO instance
  syn_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) s_fifo (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out),  
    .write_en(write_en),
    .read_en(read_en),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #(clkp / 2) clk = ~clk;

  // Test procedure
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    data_in = 0;
    write_en = 0;
    read_en = 0;

    // Apply reset
    repeat(5) @(posedge clk);
    rst = 1;

    // Write data to FIFO
    @(negedge clk) write_en = 1;
    for (integer i = 0; i < 30; i = i + 1) begin
      @(posedge clk);
      data_in = $urandom % 50;
      if(i == 10) write_en = ~write_en;
      else write_en = 1;
      #1;
      if (!full && write_en) begin
        mem[mem_head] = data_in; // Store data in memory
        mem_head = (mem_head + 1) % DEPTH;
      end
    end
    write_en = 0;

    // Read data from FIFO
    repeat(5) @(posedge clk);
    read_en = 1;
    for (integer j = 0; j < 30; j = j + 1) begin
      @(posedge clk);
      if (!empty && read_en) begin
        if (mem[mem_tail] == data_out)
          $display("Time = %0t: Comparison Passed: wr_data = %d and rd_data = %d", $time, mem[mem_tail], data_out);
        else
          $display("Time = %0t: Comparison Failed: expected wr_data = %d, rd_data = %d", $time, mem[mem_tail], data_out);
        mem_tail = (mem_tail + 1) % DEPTH;
      end
    end
    #1000;
    $finish;
  end

  // Dump waveforms
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, syn_fifo_tb);
  end

endmodule
