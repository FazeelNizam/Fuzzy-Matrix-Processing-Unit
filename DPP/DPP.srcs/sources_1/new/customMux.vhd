library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity customMux is
    Port ( I0 : in  STD_LOGIC_VECTOR(7 downto 0);
           I1 : in  STD_LOGIC_VECTOR(7 downto 0);
           Y  : out STD_LOGIC_VECTOR(7 downto 0);
           S0 : in  STD_LOGIC;
           S1 : in  STD_LOGIC);
end customMux;

architecture Behavioral of customMux is
begin

    process(I0, I1, S0, S1)
    begin
        if S0 = '0' and S1 = '1' then
            Y <= I1;
        else
            Y <= I0;
        end if;
    end process;

end Behavioral;
