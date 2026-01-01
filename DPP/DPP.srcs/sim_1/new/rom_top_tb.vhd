library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_top_tb is
end rom_top_tb;

architecture behavior of rom_top_tb is

    component rom_top
        Port (
            din : in std_logic_vector(31 downto 0);
            addr : in std_logic_vector(15 downto 0);
            nrst : in std_logic;
            enb : in std_logic;
            op : in std_logic;
            clr : in std_logic;
            done : out std_logic;
            clk_100MHz : in std_logic;
            dout : out std_logic_vector(31 downto 0)
        );
    end component;

    signal din, dout : std_logic_vector(31 downto 0) := (others => '0');
    signal addr : std_logic_vector(15 downto 0) := (others => '0');
    signal nrst, enb, op, clr, clk_100MHz, done : std_logic := '0';

    constant clk_100MHz_period : time := 100 ns;

begin

    uut: rom_top
        port map (
            din => din,
            addr => addr,
            nrst => nrst,
            enb => enb,
            op => op,
            clr => clr,
            done => done,
            clk_100MHz => clk_100MHz,
            dout => dout
        );

    clk_process: process
    begin
        clk_100MHz <= '0';
        wait for clk_100MHz_period / 2;
        clk_100MHz <= '1';
        wait for clk_100MHz_period / 2;
    end process;

    stim_proc: process
    begin
        wait for 100 ns;
        din <= x"00101101";
        addr <= x"0001";
        nrst <= '1';
        enb <= '0';
        op <= '0';
        clr <= '0';
        wait for clk_100MHz_period;
        enb <= '1';
        wait for clk_100MHz_period;
        nrst <= '0';
        enb <= '0';
        wait for clk_100MHz_period;
        nrst <= '1';
        enb <= '1';
        wait for clk_100MHz_period;
        enb <= '0';
        wait for clk_100MHz_period * 3;
        enb <= '1';
        wait for clk_100MHz_period;
        op <= '1';
        enb <= '0';
        wait for clk_100MHz_period * 3;
        clr <= '1';
        addr <= x"0011";
        wait for clk_100MHz_period;
        clr <= '0';
        wait;
    end process;

end behavior;