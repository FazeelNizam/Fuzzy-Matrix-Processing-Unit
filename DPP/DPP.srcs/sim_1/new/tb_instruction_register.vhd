library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_instruction_register is
end tb_instruction_register;

architecture sim of tb_instruction_register is

    -- DUT component declaration
    component instruction_register
        Port (
            clk   : in  STD_LOGIC;
            nrst  : in  STD_LOGIC;
            en    : in  STD_LOGIC;
            din   : in  STD_LOGIC_VECTOR(31 downto 0);
            op    : in  STD_LOGIC_VECTOR(2 downto 0);
            divad : in  STD_LOGIC;
            iout  : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Signals for testbench
    signal clk_tb   : STD_LOGIC := '0';
    signal nrst_tb  : STD_LOGIC := '0';
    signal en_tb    : STD_LOGIC := '0';
    signal din_tb   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal op_tb    : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal divad_tb : STD_LOGIC := '0';
    signal iout_tb  : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Clock generation
    clk_proc : process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Instantiate DUT
    uut: instruction_register
        port map (
            clk   => clk_tb,
            nrst  => nrst_tb,
            en    => en_tb,
            din   => din_tb,
            op    => op_tb,
            divad => divad_tb,
            iout  => iout_tb
        );

    -- Stimulus
    stim_proc: process
    begin
        -- Apply reset
        nrst_tb <= '0';
        wait for 20 ns;
        nrst_tb <= '1';
        wait for CLK_PERIOD;

        -- Enable FSM
        en_tb <= '1';

        -- Prepare din with a pattern: bits = position value
        -- Example: din = 0x12345678 so that byte/bit extraction is obvious
        din_tb <= x"12345678";

        -- Test op = "001" ? should go to S2, output lower 4 bits of din
        op_tb <= "001";
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- let FSM reach S2

        -- Test op = "010" divad=0 ? should go to S3
        op_tb <= "010"; divad_tb <= '0';
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- reach S3

        -- Test op = "010" divad=1 ? should go to S4
        op_tb <= "010"; divad_tb <= '1';
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- reach S4

        -- Test op = "011" divad=0 ? should go to S5
        op_tb <= "011"; divad_tb <= '0';
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- reach S5

        -- Test op = "011" divad=1 ? should go to S6
        op_tb <= "011"; divad_tb <= '1';
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- reach S6

        -- Test op = "100" ? S7
        op_tb <= "100";
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- reach S7

        -- Test op = "101" ? S8
        op_tb <= "101";
        wait for CLK_PERIOD;
        wait for CLK_PERIOD; -- reach S8

        -- Finish simulation
        wait for 50 ns;
        wait;
    end process;

end sim;
