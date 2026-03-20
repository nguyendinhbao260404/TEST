-- 4-bit Shift Register with Parallel Load
-- Sequential Circuit 2
-- Thanh ghi dịch 4-bit có thể dịch trái/phải và nạp song song

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
    Port (
        CLK       : in  STD_LOGIC;
        RESET     : in  STD_LOGIC;  -- Active high synchronous reset
        LOAD      : in  STD_LOGIC;  -- Load parallel data
        SHIFT_EN  : in  STD_LOGIC;  -- Enable shifting
        DIR       : in  STD_LOGIC;  -- '0': Shift Left, '1': Shift Right
        SERIAL_IN : in  STD_LOGIC;  -- Serial input
        PARALLEL_IN : in STD_LOGIC_VECTOR(3 downto 0);
        Q         : out STD_LOGIC_VECTOR(3 downto 0);
        SERIAL_OUT: out STD_LOGIC   -- Serial output
    );
end shift_register;

architecture Behavioral of shift_register is
    signal reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                reg <= (others => '0');
            elsif LOAD = '1' then
                reg <= PARALLEL_IN;
            elsif SHIFT_EN = '1' then
                if DIR = '0' then  -- Shift Left
                    reg(3 downto 1) <= reg(2 downto 0);
                    reg(0) <= SERIAL_IN;
                else  -- Shift Right
                    reg(2 downto 0) <= reg(3 downto 1);
                    reg(3) <= SERIAL_IN;
                end if;
            end if;
        end if;
    end process;
    
    Q <= reg;
    
    -- Serial output depends on shift direction
    SERIAL_OUT <= reg(3) when DIR = '0' else reg(0);

end Behavioral;
