library ieee;
use ieee.std_logic_1164.all;

entity DFlipFlop is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        enb   : in  std_logic;
        Din   : in  std_logic_vector(7 downto 0);
        Do    : out std_logic_vector(7 downto 0)
    );
end DFlipFlop;

architecture behavioral of DFlipFlop is
begin
    process (clk, rst)
    begin
        if rst = '0' then
            Do <= "00000000";
        elsif rising_edge(clk) then
            if enb = '1' then
                Do <= Din;
            end if;
        end if;
    end process;
end behavioral;