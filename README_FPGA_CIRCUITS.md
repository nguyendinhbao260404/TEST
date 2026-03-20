# FPGA Digital Circuits - Combinational and Sequential

Bộ sưu tập các mạch số dùng cho simulation trong ModelSim và có thể nạp xuống kit FPGA.

## Cấu trúc thư mục

```
/workspace
├── comb_circuits/          # Mạch tổ hợp (Combinational Circuits)
│   ├── adder_subtractor.vhd      # Bộ cộng/trừ 4-bit
│   ├── mux_8to1.vhd              # Bộ chọn kênh 8-to-1
│   ├── alu_4bit.vhd              # ALU 4-bit
│   └── tb_adder_subtractor.vhd   # Testbench cho adder/subtractor
│
└── seq_circuits/           # Mạch tuần tự (Sequential Circuits)
    ├── counter_up_down.vhd         # Bộ đếm lên/xuống 4-bit
    ├── shift_register.vhd          # Thanh ghi dịch 4-bit
    ├── traffic_light_fsm.vhd       # FSM điều khiển đèn giao thông
    └── tb_counter_up_down.vhd      # Testbench cho counter
```

## Danh sách mạch

### Mạch Tổ Hợp (3 circuits)

1. **Adder/Subtractor 4-bit** (`adder_subtractor.vhd`)
   - Thực hiện phép cộng hoặc trừ 2 số 4-bit
   - Tín hiệu điều khiển SUB: '0' = cộng, '1' = trừ
   - Output: Result (4-bit), Carry, Overflow
   - Sử dụng phép bù 2 cho phép trừ

2. **Multiplexer 8-to-1** (`mux_8to1.vhd`)
   - Chọn 1 trong 8 ngõ vào dựa trên tín hiệu chọn 3-bit
   - Thiết kế đơn giản, dễ mở rộng

3. **ALU 4-bit** (`alu_4bit.vhd`)
   - Thực hiện 8 phép toán: AND, OR, XOR, ADD, SUB, NOT, INC, DEC
   - Có cờ Zero và Carry
   - Điều khiển bằng tín hiệu 3-bit ALU_Sel

### Mạch Tuần Tự (3 circuits)

1. **Up/Down Counter 4-bit** (`counter_up_down.vhd`)
   - Đếm lên/xuống với điều khiển hướng
   - Có enable, reset synchronous, load preset
   - Output overflow khi wrap around

2. **Shift Register 4-bit** (`shift_register.vhd`)
   - Dịch trái/phải với điều khiển hướng
   - Nạp song song (parallel load)
   - Có serial input/output

3. **Traffic Light Controller FSM** (`traffic_light_fsm.vhd`)
   - Máy trạng thái hữu hạn điều khiển đèn giao thông
   - 4 trạng thái: MAIN_GREEN, MAIN_YELLOW, SIDE_GREEN, SIDE_YELLOW
   - Có cảm biến phát hiện xe ở đường phụ
   - Timer điều khiển thời gian mỗi trạng thái

## Hướng dẫn sử dụng với ModelSim

### Bước 1: Tạo project mới
```tcl
vlib work
vmap work work
```

### Bước 2: Biên dịch file VHDL
```tcl
# Cho mạch tổ hợp
vcom -93 comb_circuits/adder_subtractor.vhd
vcom -93 comb_circuits/mux_8to1.vhd
vcom -93 comb_circuits/alu_4bit.vhd

# Cho mạch tuần tự
vcom -93 seq_circuits/counter_up_down.vhd
vcom -93 seq_circuits/shift_register.vhd
vcom -93 seq_circuits/traffic_light_fsm.vhd

# Biên dịch testbench
vcom -93 comb_circuits/tb_adder_subtractor.vhd
vcom -93 seq_circuits/tb_counter_up_down.vhd
```

### Bước 3: Chạy simulation
```tcl
vsim work.tb_adder_subtractor
# hoặc
vsim work.tb_counter_up_down

# Thêm sóng vào waveform
add wave *

# Chạy simulation
run 200ns
```

### Bước 4: Xem kết quả
- Kiểm tra waveform để xác minh hoạt động đúng
- Export waveform nếu cần

## Hướng dẫn nạp xuống FPGA

### Yêu cầu phần cứng
- Kit FPGA (Xilinx Basys 3, Nexys 4, Altera DE10-Lite, v.v.)
- Phần mềm tổng hợp tương ứng (Vivado, Quartus)

### Các bước chung:

1. **Tạo project mới** trong Vivado/Quartus
2. **Thêm file VHDL** vào project
3. **Gán chân (Pin Assignment)** tùy theo kit FPGA:
   - CLK: Gán vào clock onboard (thường 100MHz)
   - RESET: Gán vào nút nhấn
   - Input switches: Gán vào DIP switches
   - Output LEDs: Gán vào LEDs
   - Output 7-segment: Gán vào display (nếu cần)

4. **Tổng hợp (Synthesize)** và triển khai (Implement)
5. **Tạo bitstream** và nạp xuống FPGA

### Ví dụ gán chân cho Xilinx Basys 3:
```xdc
# Clock 100MHz
set_property PACKAGE_PIN W5 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]

# Reset button
set_property PACKAGE_PIN U18 [get_ports RESET]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

# Input switches
set_property PACKAGE_PIN V17 [get_ports {A[0]}]
set_property PACKAGE_PIN V16 [get_ports {A[1]}]
set_property PACKAGE_PIN W16 [get_ports {A[2]}]
set_property PACKAGE_PIN W17 [get_ports {A[3]}]
# ... tiếp tục cho các input khác

# Output LEDs
set_property PACKAGE_PIN U16 [get_ports {Result[0]}]
set_property PACKAGE_PIN E19 [get_ports {Result[1]}]
# ... tiếp tục cho các output khác
```

## Lưu ý

- Tất cả các mạch đều sử dụng chuẩn IEEE STD_LOGIC_1164
- Tương thích với hầu hết các kit FPGA phổ biến
- Có thể mở rộng độ rộng bit bằng cách thay đổi kích thước vector
- Testbench mẫu đã bao gồm các trường hợp kiểm tra cơ bản

## Tác giả
Generated for FPGA learning and experimentation.
