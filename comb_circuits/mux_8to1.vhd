-- 8-to-1 Multiplexer
-- Combinational Circuit 2
-- Chọn 1 trong 8 ngõ vào dựa trên tín hiệu chọn 3-bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8to1 is
    Port (
        I0, I1, I2, I3, I4, I5, I6, I7 : in  STD_LOGIC;
        S                              : in  STD_LOGIC_VECTOR(2 downto 0);
        Y                              : out STD_LOGIC
    );
end mux_8to1;

architecture Behavioral of mux_8to1 is
begin
    process(S, I0, I1, I2, I3, I4, I5, I6, I7)
    begin
        case S is
            when "000" => Y <= I0;
            when "001" => Y <= I1;
            when "010" => Y <= I2;
            when "011" => Y <= I3;
            when "100" => Y <= I4;
            when "101" => Y <= I5;
            when "110" => Y <= I6;
            when "111" => Y <= I7;
            when others => Y <= '0';
        end case;
    end process;
end Behavioral;
