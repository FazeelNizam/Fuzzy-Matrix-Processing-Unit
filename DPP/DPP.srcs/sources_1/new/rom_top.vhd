library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_top is
    generic(C_SIMULATION : string := "FALSE");
    Port ( din : in  STD_LOGIC_VECTOR(31 downto 0);
           addr : in  STD_LOGIC_VECTOR(15 downto 0);
           nrst : in std_logic;
           enb : in std_logic;
           op : in std_logic;
           clr : in std_logic;
           done : out std_logic;
           clk_100MHz : in std_logic;
           dout : out STD_LOGIC_VECTOR(31 downto 0));
end rom_top;

architecture arch_rom of rom_top is
    component clock_div_model
        Port ( clkin : in STD_LOGIC;
               clkout : out STD_LOGIC);
    end component;

    component rom
        Port ( clka : in STD_LOGIC;
               ena : in STD_LOGIC;
               wea : in STD_LOGIC_VECTOR(0 downto 0);
               addra : in STD_LOGIC_VECTOR(15 downto 0);
               dina : in STD_LOGIC_VECTOR(31 downto 0);
               douta : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component rom_fsm
        Port ( nrst : in STD_LOGIC;
               clk: in std_logic;
               enb: in std_logic;
               clr: in std_logic;
               op: in std_logic;
               done: out std_logic;
               mx: out std_logic;
               wea: out std_logic);
    end component;

    signal clk_1Hz : STD_LOGIC;
    signal smux_out : STD_LOGIC_VECTOR(31 downto 0);
    signal swea : STD_LOGIC_VECTOR(0 downto 0);
    signal mx : STD_LOGIC;
    -- signal ena : STD_LOGIC;

begin

    -- Clock divider logic
    clk_unit : if (C_SIMULATION /= "TRUE") generate
        clock_divider : clock_div_model
            port map (clkin => clk_100MHz, clkout => clk_1Hz);
    end generate;

    non_clk_unit : if (C_SIMULATION = "TRUE") generate
        clk_1Hz <= clk_100MHz;
    end generate;

    -- MUX
    smux_out <= din when mx = '0' else x"00000000";

    -- FSM instantiation
    CU: rom_fsm
        port map (
            nrst => nrst,
            clk => clk_1Hz,
            enb => enb,
            clr => clr,
            op => op,
            done => done,
            mx => mx,
            wea => swea(0)
        );

    -- BRAM instantiation
    rom_1: rom
        port map (
            clka => clk_1Hz,
            wea => swea,
            ena => enb,
            addra => addr,
            dina => smux_out,
            douta => dout
        );

end arch_rom;
