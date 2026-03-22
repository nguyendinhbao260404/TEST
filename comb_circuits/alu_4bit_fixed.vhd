library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port ( 
        A       : in  STD_LOGIC_VECTOR (3 downto 0);
        B       : in  STD_LOGIC_VECTOR (3 downto 0);
        ALU_Sel : in  STD_LOGIC_VECTOR (2 downto 0);
        Result  : out STD_LOGIC_VECTOR (3 downto 0);
        Zero    : out STD_LOGIC;
        Carry   : out STD_LOGIC;
        Overflow: out STD_LOGIC
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
    -- Convert inputs to unsigned for arithmetic
    signal A_u : unsigned(3 downto 0);
    signal B_u : unsigned(3 downto 0);
    
    -- Intermediate results (5 bits to handle carry/borrow)
    signal res_add : unsigned(4 downto 0);
    signal res_sub : unsigned(4 downto 0);
    signal res_inc : unsigned(4 downto 0);
    signal res_dec : unsigned(4 downto 0);
    
    -- Final 4-bit result and flags
    signal res_final : unsigned(3 downto 0);
    signal c_out     : std_logic;
    signal o_out     : std_logic;
    
begin
    A_u <= unsigned(A);
    B_u <= unsigned(B);

    -- Arithmetic operations calculated concurrently
    res_add <= ('0' & A_u) + ('0' & B_u);
    res_sub <= ('0' & A_u) - ('0' & B_u);
    res_inc <= ('0' & A_u) + 1;
    res_dec <= ('0' & A_u) - 1;

    process(A_u, B_u, ALU_Sel, res_add, res_sub, res_inc, res_dec)
    begin
        -- Defaults
        res_final <= (others => '0');
        c_out     <= '0';
        o_out     <= '0';
        
        case ALU_Sel is
            when "000" => -- AND
                res_final <= A_u and B_u;
            
            when "001" => -- OR
                res_final <= A_u or B_u;
            
            when "010" => -- NOT A
                res_final <= not A_u;
            
            when "011" => -- ADD
                res_final <= res_add(3 downto 0);
                c_out     <= res_add(4);
                -- Overflow: Signs same, result sign different
                if (A_u(3) = B_u(3)) and (res_add(3) /= A_u(3)) then
                    o_out <= '1';
                end if;

            when "100" => -- SUB
                res_final <= res_sub(3 downto 0);
                c_out     <= not res_sub(4); -- Borrow = not CarryOut
                -- Overflow: Signs different, result sign different from A
                if (A_u(3) /= B_u(3)) and (res_sub(3) /= A_u(3)) then
                    o_out <= '1';
                end if;

            when "101" => -- INC
                res_final <= res_inc(3 downto 0);
                c_out     <= res_inc(4);
                if (A_u = "0111") then -- 7 + 1 overflows signed 4-bit
                    o_out <= '1';
                end if;

            when "110" => -- DEC
                res_final <= res_dec(3 downto 0);
                c_out     <= not res_dec(4);
                if (A_u = "1000") then -- -8 - 1 overflows signed 4-bit
                    o_out <= '1';
                end if;
            
            when others => -- PASS A
                res_final <= A_u;
        end case;
    end process;

    Result   <= std_logic_vector(res_final);
    Zero     <= '1' when res_final = "0000" else '0';
    Carry    <= c_out;
    Overflow <= o_out;

end Behavioral;
