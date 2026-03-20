-- Testbench cho 4-bit Up/Down Counter
-- Simulation test cho mạch tuần tự 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_counter_up_down is
end tb_counter_up_down;

architecture Behavioral of tb_counter_up_down is
    -- Component declaration
    component counter_up_down
        Port (
            CLK      : in  STD_LOGIC;
            RESET    : in  STD_LOGIC;
            ENABLE   : in  STD_LOGIC;
            UP_DOWN  : in  STD_LOGIC;
            LOAD     : in  STD_LOGIC;
            PRESET   : in  STD_LOGIC_VECTOR(3 downto 0);
            COUNT    : out STD_LOGIC_VECTOR(3 downto 0);
            OVERFLOW : out STD_LOGIC
        );
    end component;
    
    -- Signals
    signal CLK, RESET, ENABLE, UP_DOWN, LOAD : STD_LOGIC := '0';
    signal PRESET, COUNT : STD_LOGIC_VECTOR(3 downto 0);
    signal OVERFLOW : STD_LOGIC;
    
    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- Instantiate Unit Under Test (UUT)
    uut: counter_up_down
        port map (
            CLK => CLK,
            RESET => RESET,
            ENABLE => ENABLE,
            UP_DOWN => UP_DOWN,
            LOAD => LOAD,
            PRESET => PRESET,
            COUNT => COUNT,
            OVERFLOW => OVERFLOW
        );
    
    -- Clock generation
    clk_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        loop
            CLK <= not CLK;
            wait for CLK_PERIOD/2;
        end loop;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize
        RESET <= '1';
        ENABLE <= '0';
        LOAD <= '0';
        UP_DOWN <= '0';
        PRESET <= "0000";
        wait for 20 ns;
        
        -- Release reset
        RESET <= '0';
        wait for 20 ns;
        
        -- Test count up from 0
        ENABLE <= '1';
        UP_DOWN <= '1';  -- Count up
        wait for 200 ns;  -- Let it count to overflow
        
        -- Change direction to count down
        UP_DOWN <= '0';  -- Count down
        wait for 200 ns;
        
        -- Disable counting
        ENABLE <= '0';
        wait for 50 ns;
        
        -- Load preset value
        LOAD <= '1';
        PRESET <= "1010";  -- Load 10
        wait for 20 ns;
        LOAD <= '0';
        wait for 20 ns;
        
        -- Enable and count up again
        ENABLE <= '1';
        UP_DOWN <= '1';
        wait for 150 ns;
        
        -- Reset during operation
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';
        wait for 20 ns;
        
        wait;
    end process;

end Behavioral;
