library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_register is
    Port (
        clk   : in  STD_LOGIC;
        nrst  : in  STD_LOGIC;
        en    : in  STD_LOGIC;
        din   : in  STD_LOGIC_VECTOR(31 downto 0);
        op    : in  STD_LOGIC_VECTOR(2 downto 0);
        divad : in  STD_LOGIC;
        iout  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end instruction_register;

architecture Behavioral of instruction_register is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
    signal state, next_state : state_type;
    signal iout_reg : STD_LOGIC_VECTOR(7 downto 0);
begin

    iout <= iout_reg;

    -- State register
    process(clk, nrst)
    begin
        if nrst = '0' then
            state <= S0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Next state logic
    process(state, en, op, divad)
    begin
        next_state <= state;
        case state is
            when S0 =>
                if en = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            when S1 =>
                case op is
                    when "001" => next_state <= S2;
                    when "010" =>
                        if divad = '0' then
                            next_state <= S3;
                        else
                            next_state <= S4;
                        end if;
                    when "011" =>
                        if divad = '0' then
                            next_state <= S5;
                        else
                            next_state <= S6;
                        end if;
                    when "100" => next_state <= S7;
                    when "101" => next_state <= S8;
                    when others => next_state <= S1;
                end case;

            -- After output states, return to S1
            when S2 | S3 | S4 | S5 | S6 | S7 | S8 =>
                next_state <= S1;

            when others =>
                next_state <= S0;
        end case;
    end process;

    -- Output logic
    process(state, din)
    begin
        case state is
            when S0 =>
                iout_reg <= x"00";                      -- all zeros
            when S2 =>
                iout_reg <= "0000" & din(3 downto 0);   -- 4 bits opcode
            when S3 =>
                iout_reg <= "000" & din(8 downto 4);     -- 5 bits first operand / destination
            when S4 =>
                iout_reg <= din(16 downto 9);           -- 8 bits high byte of the RAM address
            when S5 =>
                iout_reg <= "000" & din(13 downto 9);   -- 5 bits second operand
            when S6 =>
                iout_reg <= din(24 downto 17);          -- 8 bits lower byte os the RAM address
            when S7 =>
                iout_reg <= "000" & din(18 downto 14);  -- 5 bits data
            when S8 =>
                iout_reg <= din(26 downto 19);          -- 8 bits data value
            when others =>
                iout_reg <= x"00";
        end case;
    end process;

end Behavioral;