-- 4-bit Adder/Subtractor
-- Combinational Circuit 1
-- Có thể thực hiện phép cộng hoặc trừ tùy theo điều khiển sub

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_subtractor is
    Port (
        A       : in  STD_LOGIC_VECTOR(3 downto 0);
        B       : in  STD_LOGIC_VECTOR(3 downto 0);
        SUB     : in  STD_LOGIC;  -- '0': Addition, '1': Subtraction
        Result  : out STD_LOGIC_VECTOR(3 downto 0);
        Carry   : out STD_LOGIC;
        Overflow: out STD_LOGIC
    );
end adder_subtractor;

architecture Behavioral of adder_subtractor is
    signal B_modified : STD_LOGIC_VECTOR(3 downto 0);
    signal carry_in   : STD_LOGIC;
    signal sum_temp   : UNSIGNED(4 downto 0);
begin
    -- Khi SUB = '1', đảo B và thêm 1 vào carry_in (phép bù 2)
    B_modified <= B xor (SUB & SUB & SUB & SUB);
    carry_in   <= SUB;
    
    -- Thực hiện phép cộng
    sum_temp <= UNSIGNED('0' & A) + UNSIGNED(B_modified) + UNSIGNED(carry_in & "0000");
    
    Result <= STD_LOGIC_VECTOR(sum_temp(3 downto 0));
    Carry  <= sum_temp(4);
    
    -- Phát hiện overflow: xảy ra khi hai số cùng dấu nhưng kết quả khác dấu
    Overflow <= (A(3) and not B_modified(3) and not sum_temp(3)) or
                (not A(3) and B_modified(3) and sum_temp(3));

end Behavioral;
