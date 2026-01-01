library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux is
    port (
        din  : in  std_logic_vector(7 downto 0);
        sel  : in  std_logic;
        ena  : in  std_logic;
        y0   : out std_logic_vector(7 downto 0);
        y1   : out std_logic_vector(7 downto 0) 
    );
end demux;

architecture archi_dmux of demux is
begin
    process(din, sel, ena)
    begin
        if ena = '1' then
            if sel = '0' then
                y0 <= din;
                y1 <= "00000000";
            else
                y0 <= "00000000";
                y1 <= din;
            end if;
        else
            y0 <= "00000000";
            y1 <= "00000000";
        end if;
    end process;
end archi_dmux;
