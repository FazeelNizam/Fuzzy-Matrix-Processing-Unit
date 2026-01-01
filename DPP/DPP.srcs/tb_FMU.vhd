library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_FMU is
end tb_FMU;

architecture sim of tb_FMU is

    -- DUT component
    component FMU
        Port ( 
            ext_data      : in  STD_LOGIC_VECTOR(15 downto 0);
            ext_runp      : in  STD_LOGIC;
            ext_savep     : in  STD_LOGIC;
            ext_readd     : in  STD_LOGIC;
            ext_pulse     : in  STD_LOGIC;
            ext_enb       : in  STD_LOGIC;
            ext_rst       : in  STD_LOGIC;
            ext_clk       : in  STD_LOGIC;
            ext_do        : out STD_LOGIC_VECTOR(7 downto 0);      
            ext_prog_done : out STD_LOGIC;      
            ext_err       : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal tb_ext_data      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal tb_ext_runp      : STD_LOGIC := '0';
    signal tb_ext_savep     : STD_LOGIC := '0';
    signal tb_ext_readd     : STD_LOGIC := '0';
    signal tb_ext_pulse     : STD_LOGIC := '0';
    signal tb_ext_enb       : STD_LOGIC := '0';
    signal tb_ext_rst       : STD_LOGIC := '0';
    signal tb_ext_clk       : STD_LOGIC := '0';

    signal tb_ext_do        : STD_LOGIC_VECTOR(7 downto 0);
    signal tb_ext_prog_done : STD_LOGIC;
    signal tb_ext_err       : STD_LOGIC;

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- DUT instance
    UUT: FMU
        port map (
            ext_data      => tb_ext_data,
            ext_runp      => tb_ext_runp,
            ext_savep     => tb_ext_savep,
            ext_readd     => tb_ext_readd,
            ext_pulse     => tb_ext_pulse,
            ext_enb       => tb_ext_enb,
            ext_rst       => tb_ext_rst,
            ext_clk       => tb_ext_clk,
            ext_do        => tb_ext_do,
            ext_prog_done => tb_ext_prog_done,
            ext_err       => tb_ext_err
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            tb_ext_clk <= '0';
            wait for clk_period/2;
            tb_ext_clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        tb_ext_rst <= '1';
        wait for 50 ns;
        tb_ext_rst <= '0';
        wait for 50 ns;

        -- Enable FMU
        tb_ext_enb <= '1';

        -- Send first instruction/data
        tb_ext_data <= x"1234";
        tb_ext_runp <= '1';
        wait for 20 ns;
        tb_ext_runp <= '0';

        -- Trigger save operation
        tb_ext_savep <= '1';
        wait for 20 ns;
        tb_ext_savep <= '0';

        -- Read operation
        tb_ext_readd <= '1';
        wait for 30 ns;
        tb_ext_readd <= '0';

        -- Pulse signal (some event trigger)
        tb_ext_pulse <= '1';
        wait for 10 ns;
        tb_ext_pulse <= '0';

        -- Let simulation run
        wait for 500 ns;

        wait;
    end process;

end sim;
