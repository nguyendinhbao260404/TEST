-- Traffic Light Controller (FSM)
-- Sequential Circuit 3
-- Máy trạng thái điều khiển đèn giao thông với 3 trạng thái: Xanh, Vàng, Đỏ

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traffic_light_fsm is
    Port (
        CLK       : in  STD_LOGIC;
        RESET     : in  STD_LOGIC;  -- Active high synchronous reset
        SENSOR    : in  STD_LOGIC;  -- Cảm biến phát hiện xe ở đường phụ
        RED_N     : out STD_LOGIC;  -- Đèn đỏ đường chính
        YELLOW_N  : out STD_LOGIC;  -- Đèn vàng đường chính
        GREEN_N   : out STD_LOGIC;  -- Đèn xanh đường chính
        RED_S     : out STD_LOGIC;  -- Đèn đỏ đường phụ
        YELLOW_S  : out STD_LOGIC;  -- Đèn vàng đường phụ
        GREEN_S   : out STD_LOGIC   -- Đèn xanh đường phụ
    );
end traffic_light_fsm;

architecture Behavioral of traffic_light_fsm is
    -- Định nghĩa các trạng thái
    type state_type is (MAIN_GREEN, MAIN_YELLOW, SIDE_GREEN, SIDE_YELLOW);
    signal current_state, next_state : state_type := MAIN_GREEN;
    
    -- Bộ đếm thời gian cho mỗi trạng thái
    signal timer : INTEGER range 0 to 9 := 0;
    constant MAIN_GREEN_TIME   : INTEGER := 5;
    constant MAIN_YELLOW_TIME  : INTEGER := 2;
    constant SIDE_GREEN_TIME   : INTEGER := 3;
    constant SIDE_YELLOW_TIME  : INTEGER := 2;
begin
    -- Process cập nhật trạng thái
    process(CLK, RESET)
    begin
        if RESET = '1' then
            current_state <= MAIN_GREEN;
            timer <= 0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
            
            -- Tăng bộ đếm hoặc reset tùy trạng thái
            case current_state is
                when MAIN_GREEN =>
                    if timer < MAIN_GREEN_TIME then
                        timer <= timer + 1;
                    else
                        timer <= 0;
                    end if;
                    
                when MAIN_YELLOW =>
                    if timer < MAIN_YELLOW_TIME then
                        timer <= timer + 1;
                    else
                        timer <= 0;
                    end if;
                    
                when SIDE_GREEN =>
                    if timer < SIDE_GREEN_TIME then
                        timer <= timer + 1;
                    else
                        timer <= 0;
                    end if;
                    
                when SIDE_YELLOW =>
                    if timer < SIDE_YELLOW_TIME then
                        timer <= timer + 1;
                    else
                        timer <= 0;
                    end if;
            end case;
        end if;
    end process;
    
    -- Process xác định trạng thái tiếp theo
    process(current_state, timer, SENSOR)
    begin
        next_state <= current_state;  -- Mặc định giữ nguyên trạng thái
        
        case current_state is
            when MAIN_GREEN =>
                if timer >= MAIN_GREEN_TIME and SENSOR = '1' then
                    next_state <= MAIN_YELLOW;
                end if;
                
            when MAIN_YELLOW =>
                if timer >= MAIN_YELLOW_TIME then
                    next_state <= SIDE_GREEN;
                end if;
                
            when SIDE_GREEN =>
                if timer >= SIDE_GREEN_TIME then
                    next_state <= SIDE_YELLOW;
                end if;
                
            when SIDE_YELLOW =>
                if timer >= SIDE_YELLOW_TIME then
                    next_state <= MAIN_GREEN;
                end if;
        end case;
    end process;
    
    -- Process tạo tín hiệu output cho đèn
    process(current_state)
    begin
        -- Mặc định tất cả đèn tắt
        RED_N <= '0'; YELLOW_N <= '0'; GREEN_N <= '0';
        RED_S <= '0'; YELLOW_S <= '0'; GREEN_S <= '0';
        
        case current_state is
            when MAIN_GREEN =>
                GREEN_N <= '1';
                RED_S <= '1';
                
            when MAIN_YELLOW =>
                YELLOW_N <= '1';
                RED_S <= '1';
                
            when SIDE_GREEN =>
                RED_N <= '1';
                GREEN_S <= '1';
                
            when SIDE_YELLOW =>
                RED_N <= '1';
                YELLOW_S <= '1';
        end case;
    end process;

end Behavioral;
