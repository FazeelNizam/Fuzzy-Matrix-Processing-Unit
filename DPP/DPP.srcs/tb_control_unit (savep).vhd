library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_control_unit is
end tb_control_unit;

architecture Behavioral of tb_control_unit is

    -- Component Declaration for the Unit Under Test (UUT)
    component control_unit
        Port (
            --Inputs
            regdata      : in STD_LOGIC_VECTOR(7 downto 0);
            irdata       : in STD_LOGIC_VECTOR(7 downto 0);
            ramdata      : in STD_LOGIC_VECTOR(7 downto 0);
            adata        : in STD_LOGIC_VECTOR(7 downto 0);
            ram_done     : in STD_LOGIC;
            rom_done     : in STD_LOGIC;
            reg_done     : in STD_LOGIC;
            a_done       : in STD_LOGIC;
            ba           : in STD_LOGIC_VECTOR(15 downto 0);
            runp         : in STD_LOGIC;
            savep        : in STD_LOGIC;
            readd        : in STD_LOGIC;
            pulse        : in STD_LOGIC;
            enb          : in STD_LOGIC;
            rst          : in STD_LOGIC;
            clk          : in STD_LOGIC;
            --Outputs
            reg_ad       : out STD_LOGIC_VECTOR(3 downto 0);
            reg_wea      : out STD_LOGIC;
            reg_ena      : out STD_LOGIC;
            reg_clr      : out STD_LOGIC;
            a_ad         : out STD_LOGIC_VECTOR(10 downto 0);
            a_wea        : out STD_LOGIC;
            a_ena        : out STD_LOGIC;
            a_clr        : out STD_LOGIC;
            rom_din      : out STD_LOGIC_VECTOR(31 downto 0);
            rom_ad       : out STD_LOGIC_VECTOR(15 downto 0);
            rom_wea      : out STD_LOGIC;
            rom_ena      : out STD_LOGIC;
            rom_clr      : out STD_LOGIC;
            ram_ad       : out STD_LOGIC_VECTOR(15 downto 0);
            ram_wea      : out STD_LOGIC;
            ram_ena      : out STD_LOGIC;
            ram_clr      : out STD_LOGIC;
            opcode       : out STD_LOGIC_VECTOR(3 downto 0);
            inf_ena      : out STD_LOGIC;
            ir_enb       : out STD_LOGIC;
            ir_op        : out STD_LOGIC_VECTOR(2 downto 0);
            divad        : out STD_LOGIC;
            ir_sel       : out STD_LOGIC;
            mux_en       : out STD_LOGIC;
            flipflop_enb : out STD_LOGIC;
            prog_done    : out STD_LOGIC;
            err          : out STD_LOGIC
        );
    end component;

    -- UUT Inputs
    signal i_regdata      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal i_irdata       : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal i_ramdata      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal i_adata        : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal i_ram_done     : STD_LOGIC := '0';
    signal i_rom_done     : STD_LOGIC := '0';
    signal i_reg_done     : STD_LOGIC := '0';
    signal i_a_done       : STD_LOGIC := '0';
    signal i_ba           : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal i_runp         : STD_LOGIC := '0';
    signal i_savep        : STD_LOGIC := '0';
    signal i_readd        : STD_LOGIC := '0';
    signal i_pulse        : STD_LOGIC := '0';
    signal i_enb          : STD_LOGIC := '0';
    signal i_rst          : STD_LOGIC := '1';
    signal i_clk          : STD_LOGIC := '0';

    -- UUT Outputs (can be monitored)
    signal o_rom_din      : STD_LOGIC_VECTOR(31 downto 0);
    signal o_rom_ad       : STD_LOGIC_VECTOR(15 downto 0);
    signal o_rom_wea      : STD_LOGIC;
    signal o_rom_ena      : STD_LOGIC;
    signal o_prog_done    : STD_LOGIC;
    signal o_err          : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: control_unit port map (
        regdata => i_regdata, irdata => i_irdata, ramdata => i_ramdata, adata => i_adata,
        ram_done => i_ram_done, rom_done => i_rom_done, reg_done => i_reg_done, a_done => i_a_done,
        ba => i_ba, runp => i_runp, savep => i_savep, readd => i_readd,
        pulse => i_pulse, enb => i_enb, rst => i_rst, clk => i_clk,
        -- Connect outputs
        rom_din => o_rom_din, rom_ad => o_rom_ad, rom_wea => o_rom_wea, rom_ena => o_rom_ena,
        prog_done => o_prog_done, err => o_err
    );

    -- Clock process
    clk_process: process
    begin
        i_clk <= '0'; wait for clk_period/2;
        i_clk <= '1'; wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- 1. Reset
        i_rst <= '1';
        wait for 20 ns;
        i_rst <= '0';
        wait for clk_period;

        -- 2. Enable the unit and start save mode
        i_enb <= '1';
        i_savep <= '1';
        wait for 10ns;

        -- 3. Save first instruction (e.g., SET0 opcode: 0001, data: 0000 0001)
        -- The FSM waits for the first pulse in S5
        i_pulse <= '1';
        wait for 10ns;
        i_pulse <= '0'; -- Enter S5_1
        -- In S5_1, set the program counter base address (pc)
        i_ba <= x"0003";
        wait for 10ns;
        i_pulse <= '1'; wait for clk_period; i_pulse <= '0'; -- Enter S6
        -- In S6, set the high part of the instruction
        i_ba <= x"0001"; -- prog_H
        wait for 10ns;
        i_pulse <= '1'; wait for clk_period; i_pulse <= '0'; -- Enter S6_2
        -- In S6_2, set the low part of the instruction
        i_ba <= x"0001"; -- prog_L
        wait for 10ns;
        i_pulse <= '1';
        wait for 10ns;
        i_pulse <= '0'; -- Enter S7_1
        wait for 10ns;
        -- Now CU should assert rom_ena. We simulate ROM being done.
        i_rom_done <= '1';
        wait for 20ns;
        i_rom_done <= '0';

        -- -- 4. Save second instruction (FSM is back in S5)
        -- wait for clk_period*2;
        -- i_pulse <= '1'; wait for clk_period; i_pulse <= '0'; -- S5_1
        -- -- PC is auto-incremented, so we don't set it.
        -- i_pulse <= '1'; wait for clk_period; i_pulse <= '0'; -- S6
        -- i_ba <= x"000F"; -- prog_H (DONE instruction)
        -- wait for clk_period;
        -- i_pulse <= '1'; wait for clk_period; i_pulse <= '0'; -- S6_2
        -- i_ba <= x"0000"; -- prog_L
        -- wait for clk_period;
        -- i_pulse <= '1'; wait for clk_period; i_pulse <= '0'; -- S7_1
        -- wait until o_rom_ena = '1';
        -- i_rom_done <= '1'; wait for clk_period; i_rom_done <= '0';

        -- -- 5. End save process
        -- i_savep <= '0';
        wait for 100 ns;

        wait;
    end process;
end Behavioral;