-- 4-bit Up/Down Counter with Enable and Reset
-- Sequential Circuit 1
-- Bộ đếm lên/xuống 4-bit có thể điều khiển hướng đếm

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_up_down is
    Port (
        CLK      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;  -- Active high synchronous reset
        ENABLE   : in  STD_LOGIC;  -- Enable counting
        UP_DOWN  : in  STD_LOGIC;  -- '0': Count Down, '1': Count Up
        LOAD     : in  STD_LOGIC;  -- Load preset value
        PRESET   : in  STD_LOGIC_VECTOR(3 downto 0);
        COUNT    : out STD_LOGIC_VECTOR(3 downto 0);
        OVERFLOW : out STD_LOGIC   -- Indicates when counter wraps around
    );
end counter_up_down;

architecture Behavioral of counter_up_down is
    signal count_reg : UNSIGNED(3 downto 0) := (others => '0');
    signal overflow_temp : STD_LOGIC := '0';
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            overflow_temp <= '0';  -- Reset overflow
            
            if RESET = '1' then
                count_reg <= (others => '0');
            elsif LOAD = '1' then
                count_reg <= UNSIGNED(PRESET);
            elsif ENABLE = '1' then
                if UP_DOWN = '1' then  -- Count Up
                    if count_reg = "1111" then
                        count_reg <= (others => '0');
                        overflow_temp <= '1';
                    else
                        count_reg <= count_reg + 1;
                    end if;
                else  -- Count Down
                    if count_reg = "0000" then
                        count_reg <= (others => '1');
                        overflow_temp <= '1';
                    else
                        count_reg <= count_reg - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    COUNT <= STD_LOGIC_VECTOR(count_reg);
    OVERFLOW <= overflow_temp;

end Behavioral;
