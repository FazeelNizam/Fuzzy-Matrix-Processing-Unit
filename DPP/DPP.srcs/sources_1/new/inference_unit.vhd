library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;

entity inference_unit is
    Port (
        Da : in STD_LOGIC_VECTOR (7 downto 0);
        Db : in STD_LOGIC_VECTOR (7 downto 0);
        opcode : in STD_LOGIC_VECTOR (3 downto 0);
        ena : in STD_LOGIC;
        sig : out STD_LOGIC;
        Do : out STD_LOGIC_VECTOR (7 downto 0));
End inference_unit;

architecture arch_inference_unit of inference_unit is
    begin
        process(ena, Da, Db ,opcode)
            begin
                if ena = '1' then
                    sig  <= '0';
                    case opcode is
                        when "0000" => --output 0x00
                            sig  <= '1';
                            Do <= x"00"; 
                        when "0101" => --FADD
                            sig  <= '1';
                            if (Da > Db) then 
                                Do <= Da;
                            else
                                Do <= Db;
                            end if;
                        when "0110" => --FSUB
                            sig  <= '1';
                            if (Da > Db) then 
                                Do <= Da;
                            else
                                Do <= x"00";
                            end if;
                        when "0111" => --FMUL
                            sig  <= '1';
                            if (Da < Db) then 
                                Do <= Da;
                            else
                                Do <= Db;
                            end if;
                        when "1010" => --output Da
                            sig  <= '1';
                            Do <= Da;
                        when "1011" =>--output Db
                            sig  <= '1';
                            Do <= Db;
                        when others =>
                            sig  <= '0';
                            NULL;
                    end case;
                else
                    sig  <= '0';
                    Do <= x"00"; 
                end if;    
            end process; 
End arch_inference_unit;