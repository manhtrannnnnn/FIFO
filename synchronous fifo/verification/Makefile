# Makefile để biên dịch và mô phỏng qadd và qadd_tb

# Tên của file mô phỏng đầu ra
OUT = simulation
# Các file nguồn Verilog
SRC_FILES = ../rtl/syn_fifo.v
TB_FILE = syn_fifo_tb.v
# File sóng để dùng trong GTKWave
WAVEFORM = wave.vcd

# Luật chính: biên dịch và chạy mô phỏng
all: run

# Biên dịch các file Verilog thành một file mô phỏng
compile:
	@echo "Compiling Verilog files..."
	iverilog -o $(OUT) $(SRC_FILES) $(TB_FILE)

# Chạy mô phỏng và sinh file sóng VCD
simulate: compile
	@echo "Running simulation..."
	./$(OUT)

# Lệnh để hiển thị file sóng với GTKWave
view:
	@echo "Opening waveform in GTKWave..."
	gtkwave $(WAVEFORM)

# Lệnh chạy cả mô phỏng và mở GTKWave
run: simulate view

# Xóa các file tạm
clean:
	@echo "Cleaning up..."
	rm -f $(OUT) $(WAVEFORM)