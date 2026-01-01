library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

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
            err          : out STD_LOGIC;
            test         : out STD_LOGIC;
            saveprog     : out STD_LOGIC;
            runprog      : out STD_LOGIC;
            readram      : out STD_LOGIC;
            savedins     : out STD_LOGIC;
            setdone      : out STD_LOGIC;
            setled       : out STD_LOGIC
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

    -- UUT Outputs
    signal o_reg_ad       : STD_LOGIC_VECTOR(3 downto 0);
    signal o_reg_wea      : STD_LOGIC;
    signal o_reg_ena      : STD_LOGIC;
    signal o_reg_clr      : STD_LOGIC;
    signal o_a_ad         : STD_LOGIC_VECTOR(10 downto 0);
    signal o_a_wea        : STD_LOGIC; 
    signal o_a_ena        : STD_LOGIC; 
    signal o_a_clr        : STD_LOGIC; 
    signal o_rom_din      : STD_LOGIC_VECTOR(31 downto 0);
    signal o_rom_ad       : STD_LOGIC_VECTOR(15 downto 0);
    signal o_rom_wea      : STD_LOGIC;
    signal o_rom_ena      : STD_LOGIC;
    signal o_rom_clr      : STD_LOGIC;
    signal o_ram_ad       : STD_LOGIC_VECTOR(15 downto 0);
    signal o_ram_wea      : STD_LOGIC;
    signal o_ram_ena      : STD_LOGIC;
    signal o_ram_clr      : STD_LOGIC; 
    signal o_opcode       : STD_LOGIC_VECTOR(3 downto 0); 
    signal o_inf_ena      : STD_LOGIC; 
    signal o_ir_enb       : STD_LOGIC; 
    signal o_ir_op        : STD_LOGIC_VECTOR(2 downto 0);
    signal o_divad        : STD_LOGIC;
    signal o_ir_sel       : STD_LOGIC;
    signal o_mux_en       : STD_LOGIC;
    signal o_flipflop_enb : STD_LOGIC;
    signal o_prog_done    : STD_LOGIC;
    signal o_err          : STD_LOGIC;
    signal o_test         : STD_LOGIC;
    signal o_saveprog     : STD_LOGIC;
    signal o_runprog      : STD_LOGIC;
    signal o_readram      : STD_LOGIC;
    signal o_savedins     : STD_LOGIC;
    signal o_setdone      : STD_LOGIC; 
    signal o_setled       : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: control_unit port map (
        regdata => i_regdata, irdata => i_irdata, ramdata => i_ramdata, adata => i_adata,
        ram_done => i_ram_done, rom_done => i_rom_done, reg_done => i_reg_done, a_done => i_a_done,
        ba => i_ba, runp => i_runp, savep => i_savep, readd => i_readd,
        pulse => i_pulse, enb => i_enb, rst => i_rst, clk => i_clk,
        
        -- Connect outputs
        reg_ad => o_reg_ad, reg_wea => o_reg_wea, reg_ena => o_reg_ena, reg_clr => o_reg_clr,
        a_ad => o_a_ad, a_wea => o_a_wea, a_ena => o_a_ena, a_clr => o_a_clr,
        rom_din => o_rom_din, rom_ad => o_rom_ad, rom_wea => o_rom_wea, rom_ena => o_rom_ena, rom_clr => o_rom_clr,
        ram_ad => o_ram_ad, ram_wea => o_ram_wea, ram_ena => o_ram_ena, ram_clr => o_ram_clr,
        opcode => o_opcode, inf_ena => o_inf_ena, ir_enb => o_ir_enb, ir_op => o_ir_op,
        divad => o_divad, ir_sel => o_ir_sel, mux_en => o_mux_en, flipflop_enb => o_flipflop_enb,
        prog_done => o_prog_done, err => o_err, test => o_test, saveprog => o_saveprog,
        runprog => o_runprog, readram => o_readram, savedins => o_savedins,
        setdone => o_setdone, setled => o_setled
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

        i_ba <= x"0000"; -- Program start address
        i_runp <= '1'; 
        wait for 10 ns; 
        -- i_runp <= '0';

        -- 3. Simulate program execution: SET0, then DONE
        wait until o_rom_ena = '1';
        i_irdata <= x"01"; wait for 30 ns;-- Provide SET0 opcode
        i_reg_done <= '1'; wait for 20 ns; i_reg_done <= '0';

        -- Now the CU is in the SET0 sequence (SET0 to SET8)
        wait for 20 ns; -- Wait for CU to change ir_op
        i_irdata <= x"00"; -- Provide base address byte
        -- State SET1 -> SET2: CU enables registry. We ACK it.
        i_reg_done <= '1'; wait for 20 ns; i_reg_done <= '0';
        
        -- State SET2 -> SET3: needs next byte
        wait for 20 ns;
        i_irdata <= x"10"; -- provide data for reg 0
        i_reg_done <= '1'; wait for 10 ns; i_reg_done <= '0';

        -- Continue this pattern for SET4-SET8
        wait for 20 ns; i_irdata <= x"20";
        i_reg_done <= '1'; wait for 10 ns; i_reg_done <= '0';
        wait for 20 ns; i_irdata <= x"30";
        i_reg_done <= '1'; wait for 10 ns; i_reg_done <= '0';

        -- After SET8, CU goes to S4 to fetch the next instruction.
        -- 4. Fetch the DONE instruction
        i_irdata <= x"0F"; -- Provide DONE opcode
        i_rom_done <= '1'; wait for 10 ns; i_rom_done <= '0';

        -- 5. Check for completion
        wait for 50 ns; -- Allow time for FSM to reach DONE state
        assert (o_prog_done = '1') report "Program did not complete successfully" severity failure;
        wait for 100 ns;

        wait;
    end process;
end Behavioral;