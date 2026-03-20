-- 4-bit ALU (Arithmetic Logic Unit)
-- Combinational Circuit 3
-- Thực hiện các phép toán: AND, OR, XOR, ADD, SUB

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port (
        A       : in  STD_LOGIC_VECTOR(3 downto 0);
        B       : in  STD_LOGIC_VECTOR(3 downto 0);
        ALU_Sel : in  STD_LOGIC_VECTOR(2 downto 0);
        Result  : out STD_LOGIC_VECTOR(3 downto 0);
        Zero    : out STD_LOGIC;
        Carry   : out STD_LOGIC
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
    signal result_temp : UNSIGNED(4 downto 0);
    signal and_result  : STD_LOGIC_VECTOR(3 downto 0);
    signal or_result   : STD_LOGIC_VECTOR(3 downto 0);
    signal xor_result  : STD_LOGIC_VECTOR(3 downto 0);
begin
    -- Các phép logic
    and_result <= A and B;
    or_result  <= A or B;
    xor_result <= A xor B;
    
    process(A, B, ALU_Sel)
    begin
        case ALU_Sel is
            when "000" =>  -- AND
                result_temp <= ("0" & and_result);
            when "001" =>  -- OR
                result_temp <= ("0" & or_result);
            when "010" =>  -- XOR
                result_temp <= ("0" & xor_result);
            when "011" =>  -- ADD
                result_temp <= ("0" & A) + ("0" & B);
            when "100" =>  -- SUB (A - B)
                result_temp <= ("0" & A) - ("0" & B);
            when "101" =>  -- NOT A
                result_temp <= ("0" & not A);
            when "110" =>  -- A + 1
                result_temp <= ("0" & A) + 1;
            when "111" =>  -- A - 1
                result_temp <= ("0" & A) - 1;
            when others =>
                result_temp <= (others => '0');
        end case;
    end process;
    
    Result <= STD_LOGIC_VECTOR(result_temp(3 downto 0));
    Carry  <= result_temp(4);
    
    -- Zero flag: kết quả bằng 0
    Zero <= '1' when result_temp(3 downto 0) = "0000" else '0';

end Behavioral;
