library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FMU is
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
            ext_err          : out STD_LOGIC;
            ext_test         : out STD_LOGIC;
            ext_runprog          : out STD_LOGIC;
            ext_saveprog         : out STD_LOGIC;
            ext_setled         : out STD_LOGIC;
            ext_savedins         : out STD_LOGIC;
            ext_setdone         : out STD_LOGIC;
            ext_readram          : out STD_LOGIC       
         );
end FMU;

architecture arch_FMU of FMU is
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
                clk          : in  STD_LOGIC;

                --Outputs
                reg_ad       : out STD_LOGIC_VECTOR(3 downto 0);
                reg_wea      : out STD_LOGIC;
                reg_ena      : out STD_LOGIC;
                reg_clr      : out STD_LOGIC;
                a_ad         : out STD_LOGIC_VECTOR(10 downto 0);
                a_wea        : out STD_LOGIC;
                a_ena        : out STD_LOGIC;
                a_clr        : out STD_LOGIC;
                rom_din      :out STD_LOGIC_VECTOR(31 downto 0);
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
                setled       : out STD_LOGIC;
                savedins       : out STD_LOGIC;
                setdone       : out STD_LOGIC;
                readram      : out STD_LOGIC       
            );
    end component;

    component rom_top
        Port ( 
                din : in  STD_LOGIC_VECTOR(31 downto 0);
                addr : in  STD_LOGIC_VECTOR(15 downto 0);
                nrst : in std_logic;
                enb : in std_logic;
                op : in std_logic;
                clr : in std_logic;
                done : out std_logic;
                clk_100MHz : in std_logic;
                dout : out STD_LOGIC_VECTOR(31 downto 0)
            );
    end component;

    component ram_top
        Port ( 
                din : in  STD_LOGIC_VECTOR(7 downto 0);
                addr : in  STD_LOGIC_VECTOR(15 downto 0);
                nrst : in std_logic;
                enb : in std_logic;
                op : in std_logic;
                clr : in std_logic;
                done : out std_logic;
                clk_100MHz : in std_logic;
                dout : out STD_LOGIC_VECTOR(7 downto 0)
            );
    end component;

    component reg_a_top
        Port ( 
                din : in  STD_LOGIC_VECTOR(7 downto 0);
                addr : in  STD_LOGIC_VECTOR(10 downto 0);
                nrst : in std_logic;
                enb : in std_logic;
                op : in std_logic;
                clr : in std_logic;
                done : out std_logic;
                clk_100MHz : in std_logic;
                dout : out STD_LOGIC_VECTOR(7 downto 0)
            );
    end component;

    component registry_bank_top
        Port ( 
                din : in  STD_LOGIC_VECTOR(7 downto 0);
                addr : in  STD_LOGIC_VECTOR(3 downto 0);
                nrst : in std_logic;
                enb : in std_logic;
                op : in std_logic;
                clr : in std_logic;
                done : out std_logic;
                clk_100MHz : in std_logic;
                dout : out STD_LOGIC_VECTOR(7 downto 0)
            );
    end component;

    component inference_unit
        Port (
                Da : in STD_LOGIC_VECTOR (7 downto 0);
                Db : in STD_LOGIC_VECTOR (7 downto 0);
                opcode : in STD_LOGIC_VECTOR (3 downto 0);
                ena : in STD_LOGIC;
                sig : out STD_LOGIC;
                Do : out STD_LOGIC_VECTOR (7 downto 0)
            );
    end component;

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

    component demux
        port (
                din  : in  std_logic_vector(7 downto 0);
                sel  : in  std_logic;
                ena  : in  std_logic;
                y0   : out std_logic_vector(7 downto 0);
                y1   : out std_logic_vector(7 downto 0) 
            );
    end component;

    component dflipflop
        Port (
                clk   : in  std_logic;
                rst   : in  std_logic;
                enb   : in  std_logic;
                Din   : in  std_logic_vector(7 downto 0);
                Do    : out std_logic_vector(7 downto 0)
            );
    end component;

    component customMux
        Port ( 
                I0 : in  STD_LOGIC_VECTOR(7 downto 0);
                I1 : in  STD_LOGIC_VECTOR(7 downto 0);
                Y  : out STD_LOGIC_VECTOR(7 downto 0);
                S0 : in  STD_LOGIC;
                S1 : in  STD_LOGIC
            );
    end component;

    -- Internal signals
    signal clksig, rstsig   : STD_LOGIC;

    -- Instruction register signals
    signal inr_enb          : STD_LOGIC;
    signal inr_op           : STD_LOGIC_VECTOR(2 downto 0);
    signal inr_div          : STD_LOGIC;
    signal inr_out          : STD_LOGIC_VECTOR(7 downto 0);
    signal ro_dout          : STD_LOGIC_VECTOR(31 downto 0);

    -- Demux signals
    signal dm_sel, dm_enb   : STD_LOGIC;

    signal datasig_dmux0    : STD_LOGIC_VECTOR(7 downto 0);
    signal datasig_dmux1    : STD_LOGIC_VECTOR(7 downto 0);

    -- Flip flop
    signal dff_enb          : STD_LOGIC;

    -- Inference unit
    signal inu_op           : STD_LOGIC_VECTOR(3 downto 0);
    signal inu_enb          : STD_LOGIC;

    -- A Register
    signal ar_addr          : STD_LOGIC_VECTOR(10 downto 0);
    signal ar_enb, ar_op, ar_clr, ar_d : STD_LOGIC;
    signal ar_do            : STD_LOGIC_VECTOR(7 downto 0);

    -- Registry bank
    signal re_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal re_enb, re_op, re_clr, re_d : STD_LOGIC;
    signal re_do            : STD_LOGIC_VECTOR(7 downto 0);

    -- RAM
    signal ra_addr          : STD_LOGIC_VECTOR(15 downto 0);
    signal ra_enb, ra_op, ra_clr, ra_d : STD_LOGIC;
    signal ra_dout          : STD_LOGIC_VECTOR(7 downto 0);

    -- ROM
    signal ro_din           : STD_LOGIC_VECTOR(31 downto 0);
    signal ro_addr          : STD_LOGIC_VECTOR(15 downto 0);
    signal ro_wea, ro_op, ro_enb, ro_clr, ro_d : STD_LOGIC;

    --Custom Mux
    signal cmI0, cmI1, cmY  : STD_LOGIC_VECTOR(7 downto 0);
    signal cmS0, cmS1       : STD_LOGIC;


begin

    -- clksig <= ext_clk;
    -- rstsig <= ext_rst;

    -- Instruction Register
    IR: instruction_register
        port map (
            clk    => ext_clk,
            nrst   => ext_rst,
            en     => inr_enb,
            din    => ro_dout,
            op     => inr_op,
            divad  => inr_div,
            iout   => inr_out
        );

    -- Demux
    dmux: demux
        port map (
            din  => inr_out,
            sel  => dm_sel,
            ena  => dm_enb,
            y0   => datasig_dmux0,
            y1   => cmI0
        );

    -- Flip Flop
    dff: dflipflop
        port map (
            clk   => ext_clk,
            rst   => ext_rst,
            enb   => dff_enb,
            Din   => datasig_dmux0,
            Do    => ext_do
        );

    -- Inference Unit
    IU: inference_unit
        port map (
            Da     => ar_do,
            Db     => re_do,
            opcode => inu_op,
            ena    => inu_enb,
            sig    => cmS1,
            Do     => cmI1
        );

    CM: customMux
        port map (
            I0 => cmI0,
            I1 => cmI1,
            Y => datasig_dmux1,
            S0 => '0',
            S1 => cmS1
        );

    -- A Register
    a_register: reg_a_top
        port map (
            din        => datasig_dmux1,
            addr       => ar_addr,
            nrst       => ext_rst,
            enb        => ar_enb,
            op         => ar_op,
            clr        => ar_clr,
            done       => ar_d,
            clk_100MHz => ext_clk,
            dout       => ar_do
        );

    -- Registry Bank
    registry_bank: registry_bank_top
        port map (
            din        => datasig_dmux0,
            addr       => re_addr,
            nrst       => ext_rst,
            enb        => re_enb,
            op         => re_op,
            clr        => re_clr,
            done       => re_d,
            clk_100MHz => ext_clk,
            dout       => re_do
        );

    -- RAM
    data_memory: ram_top
        port map (
            din        => datasig_dmux1,
            addr       => ra_addr,
            nrst       => ext_rst,
            enb        => ra_enb,
            op         => ra_op,
            clr        => ra_clr,
            done       => ra_d,
            clk_100MHz => ext_clk,
            dout       => ra_dout
        );

    -- ROM
    program_memory: rom_top
        port map (
            din        => ro_din,
            addr       => ro_addr,
            nrst       => ext_rst,
            enb        => ro_enb,
            op         => ro_op,
            clr        => ro_clr,
            done       => ro_d,
            clk_100MHz => ext_clk,
            dout       => ro_dout
        );

    -- Control Unit
    CU: control_unit
        port map (
            -- Inputs
            regdata   => re_do,
            irdata    => inr_out,
            ramdata   => ra_dout,
            adata     => ar_do,
            ram_done  => ra_d,
            rom_done  => ro_d,
            reg_done  => re_d,
            a_done    => ar_d,
            ba        => ext_data,
            runp      => ext_runp,
            savep     => ext_savep,
            readd     => ext_readd,
            pulse     => ext_pulse,
            enb       => ext_enb,
            rst       => ext_rst,
            clk       => ext_clk,

            -- Outputs
            reg_ad    => re_addr,
            reg_wea   => re_op,
            reg_ena   => re_enb,
            reg_clr   => re_clr,

            a_ad      => ar_addr,
            a_wea     => ar_op,
            a_ena     => ar_enb,
            a_clr     => ar_clr,

            rom_din   => ro_din,
            rom_ad    => ro_addr,
            rom_wea   => ro_wea,
            rom_ena   => ro_enb,
            rom_clr   => ro_clr,

            ram_ad    => ra_addr,
            ram_wea   => ra_op,
            ram_ena   => ra_enb,
            ram_clr   => ra_clr,

            opcode    => inu_op,
            inf_ena   => inu_enb,
            ir_enb    => inr_enb,
            ir_op     => inr_op,
            divad     => inr_div,
            ir_sel    => dm_sel,
            mux_en    => dm_enb,
            flipflop_enb => dff_enb,
            prog_done => ext_prog_done,
            err       => ext_err,
            test      => ext_test,
            saveprog  => ext_saveprog,
            runprog   => ext_runprog,
            setled   => ext_setled,
            savedins   => ext_savedins,
            setdone   => ext_setdone,
            readram   => ext_readram
        );

end arch_FMU;