-- Testbench cho 4-bit Adder/Subtractor
-- Simulation test cho mạch tổ hợp 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_adder_subtractor is
end tb_adder_subtractor;

architecture Behavioral of tb_adder_subtractor is
    -- Component declaration
    component adder_subtractor
        Port (
            A       : in  STD_LOGIC_VECTOR(3 downto 0);
            B       : in  STD_LOGIC_VECTOR(3 downto 0);
            SUB     : in  STD_LOGIC;
            Result  : out STD_LOGIC_VECTOR(3 downto 0);
            Carry   : out STD_LOGIC;
            Overflow: out STD_LOGIC
        );
    end component;
    
    -- Signals
    signal A, B, Result : STD_LOGIC_VECTOR(3 downto 0);
    signal SUB, Carry, Overflow : STD_LOGIC;
    
begin
    -- Instantiate Unit Under Test (UUT)
    uut: adder_subtractor
        port map (
            A => A,
            B => B,
            SUB => SUB,
            Result => Result,
            Carry => Carry,
            Overflow => Overflow
        );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Addition 5 + 3 = 8
        A <= "0101"; B <= "0011"; SUB <= '0';
        wait for 20 ns;
        
        -- Test case 2: Subtraction 8 - 3 = 5
        A <= "1000"; B <= "0011"; SUB <= '1';
        wait for 20 ns;
        
        -- Test case 3: Addition with overflow 7 + 2 = 9 (overflow)
        A <= "0111"; B <= "0010"; SUB <= '0';
        wait for 20 ns;
        
        -- Test case 4: Subtraction with negative result 3 - 5 = -2
        A <= "0011"; B <= "0101"; SUB <= '1';
        wait for 20 ns;
        
        -- Test case 5: Addition 10 + 5 = 15
        A <= "1010"; B <= "0101"; SUB <= '0';
        wait for 20 ns;
        
        -- Test case 6: Subtraction 15 - 7 = 8
        A <= "1111"; B <= "0111"; SUB <= '1';
        wait for 20 ns;
        
        -- Test case 7: Addition 0 + 0 = 0
        A <= "0000"; B <= "0000"; SUB <= '0';
        wait for 20 ns;
        
        -- Test case 8: Subtraction 0 - 0 = 0
        A <= "0000"; B <= "0000"; SUB <= '1';
        wait for 20 ns;
        
        wait;
    end process;

end Behavioral;
