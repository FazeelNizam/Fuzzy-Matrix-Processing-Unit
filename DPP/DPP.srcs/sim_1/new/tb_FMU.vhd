library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_FMU is
end tb_FMU;

architecture Behavioral of tb_FMU is

    -- Component Declaration for the Unit Under Test (UUT)
    component FMU
        Port ( 
            ext_data         : in STD_LOGIC_VECTOR(15 downto 0);
            ext_runp         : in STD_LOGIC;
            ext_savep        : in STD_LOGIC;
            ext_readd        : in STD_LOGIC;
            ext_pulse        : in STD_LOGIC;
            ext_enb          : in STD_LOGIC;
            ext_rst          : in STD_LOGIC;
            ext_clk          : in  STD_LOGIC;
            ext_do           : out STD_LOGIC_VECTOR(7 downto 0);      
            ext_prog_done    : out STD_LOGIC;      
            ext_err          : out STD_LOGIC
        );
    end component;

    --Inputs
    signal tb_data         : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal tb_runp         : STD_LOGIC := '0';
    signal tb_savep        : STD_LOGIC := '0';
    signal tb_readd        : STD_LOGIC := '0';
    signal tb_pulse        : STD_LOGIC := '0';
    signal tb_enb          : STD_LOGIC := '0';
    signal tb_rst          : STD_LOGIC := '0';
    signal tb_clk          : STD_LOGIC := '0';

    --Outputs
    signal tb_do           : STD_LOGIC_VECTOR(7 downto 0);
    signal tb_prog_done    : STD_LOGIC;
    signal tb_err          : STD_LOGIC;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: FMU
        port map (
            ext_data        => tb_data,
            ext_runp        => tb_runp,
            ext_savep       => tb_savep,
            ext_readd       => tb_readd,
            ext_pulse       => tb_pulse,
            ext_enb         => tb_enb,
            ext_rst         => tb_rst,
            ext_clk         => tb_clk,
            ext_do          => tb_do,
            ext_prog_done   => tb_prog_done,
            ext_err         => tb_err
        );

    -- Clock process definition
    clk_process :process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        tb_clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        tb_rst <= '1';
        wait for 20 ns;
        tb_rst <= '0';
        wait for 10 ns;

        -- Enable the FMU
        tb_enb <= '1';        
        -- Start the save process
         tb_savep <= '1';
         wait for 10 ns;

         tb_pulse <= '1';
         wait for 10 ns;
         tb_pulse <= '0'; -- Enter S5_1
         -- In S5_1, set the program counter base address (pc)
         tb_data <= x"0003";
         wait for 10 ns;
         tb_pulse <= '1'; wait for clk_period; tb_pulse <= '0'; -- Enter S6
         -- In S6, set the high part of the instruction
         tb_data <= x"0001"; -- prog_H
         wait for 10 ns;
         tb_pulse <= '1'; wait for clk_period; tb_pulse <= '0'; -- Enter S6_2
         -- In S6_2, set the low part of the instruction
         tb_data <= x"0001"; -- prog_L
         wait for 10 ns;
         tb_pulse <= '1';
         wait for 10 ns;
         tb_pulse <= '0'; -- Enter S7
         wait for 10 ns;
         tb_pulse <= '1';
         wait for 10 ns;
         tb_pulse <= '0'; -- Enter S7_1       
         tb_savep <= '0';
         wait for 50 ns;

        tb_data <= x"0000"; 
        wait for 20 ns;
        tb_runp <= '1';
        wait for 40 ns;
        tb_runp <= '0';
        
        -- -- Instruction 2: Base Address for Registers
        -- tb_data <= x"0000"; 
        -- tb_pulse <= '1';
        -- wait for clk_period;
        -- tb_pulse <= '0';
        -- wait for clk_period;
        
        -- -- Instruction 3: Value to store in register
        -- tb_data <= x"1234";
        -- tb_pulse <= '1';
        -- wait for clk_period;
        -- tb_pulse <= '0';
        -- wait for clk_period;
        
        -- -- Instruction 4: MV0
        -- tb_data <= x"0002";
        -- tb_pulse <= '1';
        -- wait for clk_period;
        -- tb_pulse <= '0';
        -- wait for clk_period;

        -- -- Add more instructions as needed following the pattern above

        -- -- End the save process
        -- tb_savep <= '0';
        -- tb_enb <= '0';

        wait;
    end process;

end Behavioral;