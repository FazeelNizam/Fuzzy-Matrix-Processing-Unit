library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_unit is
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
         readram      : out STD_LOGIC;
         savedins      : out STD_LOGIC;
         setdone      : out STD_LOGIC;
         setled       : out STD_LOGIC
      );
end control_unit;

architecture Behavioral of control_unit is
  type state_type is ( S0, S1, S2, S2_1, S3, S3_1, S4, S4_1, S5, S5_1, S5_2, S6, S6_1, S6_2, S7, S7_1, S8, S8_1, S9, S9_1, S10, S10_1, S10_2, S10_3, S11, S12, S12_1, S12_2, S13, ERROR, DONE,
                       MV0, MV1, MV1_1, MV2, MV3, MV4, MV5, MV6, MV7, MV8,
                       LD0, LD1, LD2, LD3, LD4, LD5, LD5_1, LD6, LD7, LD8, LD9, LD10, LD11, LD12, LD13, LD13_1, LD14, LD15, LD16, LD16_1, LD17, LD17_1, LD18, LD18_1, LD19, LD19_1, LD_STR_F,
                       CM0, CM1, CM2, CM3, CM4, CM5, CM6, CM7, CM8, CM9, CM10,
                       CR0, CR1, CR2, CR3, CR4, CR5, CR6, CR7, CR8, CR9, CR10, CR11, CR12,
                       INF0, INF1, INF1_1, INF1_2, INF2, INF2_1, INF3, INF3_1, INF4, INF4_1, INF5, INF6, INF7, INF8, INF9, INF9_1, INF10, INF11, INF12,
                       STR0, STR1, STR2, STR3, STR3_1, STR4, STR5, STR5_1, STR6, STR7, STR7_1, STR8, STR8_1,
                       SET0, SET1, SET2, SET3, SET4, SET5, SET6, SET7, SET8, SET8_1
                      );
  signal state, next_state : state_type;
  -- signal out_reg : STD_LOGIC_VECTOR(7 downto 0);
--  variable i : std_logic_vector(10 downto 0);
--  signal i : STD_LOGIC_VECTOR(9 downto 0);  
  --Signals to detect and synchronyze 'pulse' pin rising edge
  signal pulse_sync1, pulse_sync2 : std_logic; -- sync registers
  signal pulse_prev               : std_logic; -- store previous state
  signal pulse_edge               : std_logic; -- one-clock pulse

begin

  process(clk, rst)
  begin
      if rst = '0' then
        state <= S0;
        pulse_sync1 <= '0';
        pulse_sync2 <= '0';
        pulse_prev  <= '0';
      elsif rising_edge(clk) then
        state <= next_state;
        pulse_sync1 <= pulse;       -- first sync
        pulse_sync2 <= pulse_sync1; -- second sync
        pulse_prev  <= pulse_sync2; -- store previous value
      end if;
  end process;

  -- Rising edge detection
  pulse_edge <= '1' when (pulse_sync2 = '1' and pulse_prev = '0') else '0';

  -- Next state logic
  process(state, enb, ba, irdata, pulse, readd, savep, runp, a_done, reg_done, rom_done, ram_done, adata, regdata)
    variable row : unsigned(4 downto 0);
    variable col : unsigned(4 downto 0);
    variable RAM_H : unsigned(7 downto 0);
    variable RAM_L : unsigned(7 downto 0);
    variable regad : unsigned(3 downto 0);
    variable basead : unsigned(7 downto 0);
    variable i : unsigned(9 downto 0);
    variable Aad : unsigned(10 downto 0);
    variable RAMad : unsigned(15 downto 0);
    variable prog_H : unsigned(15 downto 0);
    variable prog_L : unsigned(15 downto 0);
    variable pc : unsigned(15 downto 0);
    variable ROMdin : unsigned(31 downto 0);
  begin
    next_state <= state;
    case state is
      when S0 =>
        prog_done <= '0';
        err <= '0';
        test <= '0';
        saveprog <= '0';
        runprog <= '0';
        readram <= '0';
        setled <= '0';
        savedins <= '0';
        if enb = '1' then
          next_state <= S1;
        else
          next_state <= S0;
        end if;

      when S1 =>
        test <= '1';
        if runp = '1' then
          next_state <= S2;
        elsif savep = '1' then
          next_state <= S5;
        elsif readd = '1' then
          next_state <= S9;
        else
          next_state <= S1;
        end if;

      --Opcode Process (Run program)
      when S2 => 
        runprog <= '1';        
        ir_enb <= '1';
        rom_wea <= '0';
        rom_ena <= '1';
        mux_en <= '0';
        rom_ad <= ba;
        pc := unsigned(ba);
        next_state <= S3;

      when S2_1 => 
        if rom_done = '1' then
          next_state <= S3;
        else 
          next_state <= S2_1;
        end if;

      when S3 =>
        runprog <= '1';
        rom_ena <= '0';
        ir_op <= "001";
        next_state <= S3_1;

      when S3_1 =>
        opcode <= irdata(3 downto 0);
        case irdata is
          when "00000000" => next_state <= S3;
          when "00000001" => next_state <= SET0; --Set matrix meta data
          when "00000010" => next_state <= MV0; --Move values to matrix elements
          when "00000011" => next_state <= LD0; --Load matrix in to registers
          when "00000100" => next_state <= STR0; --Store matrix in A in to RAM
          when "00000101" | "00000110" | "00000111" => --Fuzzy addition, substraction, multiplication
            next_state <= INF0;
          when "00001000" => next_state <= CR0; --Clear registers
          when "00001001" => next_state <= CM0; --Clear RAM
          when "00001111" => next_state <= DONE;
          when others => next_state <= ERROR;
        end case;

      when S4 => 
        setdone <= '0';
        setled <= '0';
        if runp = '1' then
          next_state <= S4_1;
        else
          next_state <= S1;
        end if; 

      when S4_1 =>
        pc := pc + 1;
        rom_ad <= std_logic_vector(pc);
        rom_ena <= '1';
        next_state <= S2_1;
      
      --Set metrix meta data
      when SET0 =>
        setled <= '1';
        ir_op <= "010";
        reg_wea <= '1';
        next_state <= SET1;
        -- if pulse_edge = '1' then
          next_state <= SET1;
        -- else
        --   next_state <= SET0;
        -- end if;

      when SET1 =>
        setled <= '0';
        basead := unsigned(irdata);
        divad <= '1';
        ir_sel <= '0';
        mux_en <= '1';
        reg_ad <= std_logic_vector(basead (3 downto 0));
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= SET2;
        else
          next_state <= SET1;
        end if;

      when SET2 => 
        reg_ena <= '0';
        ir_op <= "011";
        basead := basead + 1;
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= SET3;

      when SET3 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= SET4;
        else
          next_state <= SET3;
        end if;

      when SET4 => 
        reg_ena <= '0';
        divad <= '0';
        ir_op <= "100";
        basead := basead + 1;
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= SET5;

      when SET5 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= SET6;
        else
          next_state <= SET5;
        end if;

      when SET6 =>
        reg_ena <= '0';
        ir_op <= "101";
        basead := basead + 1;
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= SET7;

      when SET7 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= SET8;
        else
          next_state <= SET7;
        end if;
        
      when SET8 =>
        reg_ena <= '0';
        reg_wea <= '0';
        mux_en <= '0';
        ir_op <= "000";
        basead := "00000000";
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= SET8_1;

      when SET8_1 =>
        setdone <= '1';
        -- if pulse_edge = '1' then
          next_state <= S4;
        -- else
        --   next_state <= SET8_1;
        -- end if;

      --Move values to matrix elements
      when MV0 => 
        ir_op <= "010";
        reg_wea <= '0';
        reg_ena <= '1';
        next_state <= MV1;

      when MV1 =>
        reg_ad <= irdata(3 downto 0);
        if reg_done = '1' then
          next_state <= MV1_1;
        else
          next_state <= MV1;
        end if;
      
      when MV1_1 =>
        reg_ad <= std_logic_vector(unsigned(irdata(3 downto 0)) + 1);
        next_state <= MV2;

      when MV2 =>
        RAM_H := unsigned(regdata);
        if reg_done = '1' then
          next_state <= MV3;
        else
          next_state <= MV2;
        end if;

      when MV3 => 
        RAM_L := unsigned(regdata);
        RAMad := RAM_H & RAM_L;
        reg_ena <= '0';
        ir_op  <= "011";
        next_state <= MV4;

      when MV4 =>
        row := unsigned(irdata(4 downto 0));
        ir_op <= "100";
        next_state <= MV5;

      when MV5 =>
        col := unsigned(irdata(4 downto 0));
        ir_op <= "101";
        next_state <= MV6;

      when MV6 =>
        ram_ad <= std_logic_vector(RAMad + (row * col));
        ram_wea <= '1';
        ir_op <= "011";
        ir_sel <= '1';
        mux_en <= '1';
        next_state <= MV7;
      
      when MV7 =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= MV8;
        else
          next_state <= MV7;
        end if;

      when MV8 => 
        ram_ena <= '0';
        ram_ad <= x"0000";
        RAMad := x"0000";
        row := "00000";
        col := "00000";
        RAM_H := x"00";
        RAM_L := x"00";
        ram_wea <= '0';
        ir_op <= "000";
        mux_en <= '0';
        ir_sel <= '0';
        next_state <= S4;

      --Load matrix in to registers
      when LD0 =>
        ir_op <= "010";
        case irdata is
          when "00000000" | "00000100" | "00001000" | "00001100"  => 
            next_state <= LD1;
          when"00010000" =>
            next_state <= LD10;
          when others => next_state <= ERROR; 
        end case;
      when LD1 =>
        basead := unsigned(irdata);
        reg_wea <= '1';
        divad <= '1';
        ir_sel <= '0';
        mux_en <= '1';
        reg_ad <= std_logic_vector(basead(3 downto 0));
        next_state <= LD2;

      when LD2 =>
        reg_ena <= '1';
        RAM_H := unsigned(irdata);
        if reg_done = '1' then
          next_state <= LD3;
        else
          next_state <= LD2;
        end if;

      when LD3 =>
        reg_ena <= '0';
        ir_op <= "011";
        basead := basead + 1;
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= LD4;

      when LD4 =>
        reg_ena <= '1';
        RAM_L := unsigned(irdata);
        RAMad := RAM_H & RAM_L;
        if reg_done = '1' then
          next_state <= LD5;
        else
          next_state <= LD4;
        end if;

      when LD5 =>
        ram_ad <= std_logic_vector(RAMad);
        reg_ena <= '0';
        divad <= '0';
        ram_wea <= '0';
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= LD5_1;
        else
          next_state <= LD5;
        end if;

      when LD5_1 =>
        basead := basead + 1;
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= LD6;

      when LD6 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= LD7;
        else
          next_state <= LD6;
        end if;

      when LD7 =>
        reg_ena <= '1';
        basead := basead + 1;
        ram_ad <= std_logic_vector(RAMad + 1);
        reg_ad <= std_logic_vector(basead (3 downto 0));
        next_state <= LD8;

      when LD8 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= LD9;
        else
          next_state <= LD8;
        end if;

      when LD9 =>
        reg_ena <= '0';
        ram_ena <= '0';
        basead := "00000000";
        ram_ad <= "0000000000000000";
        reg_ad <= "0000";
        RAMad := x"0000";
        RAM_H := x"00";
        RAM_L := x"00";
        next_state <= S4;

      when LD10 =>
        Aad := "00000000000";
        a_ad <= std_logic_vector(Aad);
        a_wea  <= '1';
        divad  <= '1';
        ir_sel <= '1';
        mux_en <= '1'; 
        opcode <= "1011";
        next_state <= LD11;

      when LD11 =>
        a_ena <= '1';
        RAM_H := unsigned(irdata);
        if a_done = '1' then
          next_state <= LD12;
        else
          next_state <= LD11;
        end if;

      when LD12 =>
        a_ena <= '0';
        ir_op <= "011";
        Aad := Aad + 1;
        a_ad <= std_logic_vector(Aad);
        next_state <= LD13;

      when LD13 =>
        a_ena <= '1';
        RAM_L := unsigned(irdata);
        RAMad := RAM_H & RAM_L;
        if a_done = '1' then
          next_state <= LD13_1;
        else
          next_state <= LD13;
        end if;

      when LD13_1 =>
        ram_ad <= std_logic_vector(RAMad);
        Aad := Aad + 1;
        a_ad <= std_logic_vector(Aad);
        a_ena <= '0';
        divad <= '0';
        ram_wea <= '0';
        mux_en <= '0';
        next_state <= LD14;
        

      when LD14 => 
        ram_ena <= '1';
        inf_ena <= '1';
        if ram_done = '1' then
          next_state <= LD15;
        else
          next_state <= LD14;
        end if;

      when LD15 =>
        ram_ena <= '0';
        row := unsigned(ramdata(4 downto 0));
        a_ena <= '1';
        if a_done = '1' then
          next_state <= LD16;
        else
          next_state <= LD15;
        end if;

      when LD16 =>
        a_ena <= '0';
        Aad := Aad + 1;
        RAMad := RAMad + 1;
        ram_ad <= std_logic_vector(RAMad);
        a_ad <= std_logic_vector(Aad);
        next_state <= LD16_1;

        when LD16_1  =>
          ram_ena <= '1';
          if ram_done = '1' then
            next_state <= LD17;
          else
            next_state <= LD16_1;
          end if;

      when LD17 =>
        ram_ena <= '0';
        col := unsigned(ramdata(4 downto 0));
        a_ena <= '1';
        if a_done = '1' then
          next_state <= LD17_1;
        else
          next_state <= LD17;
        end if;

      when LD17_1  => 
        i := row * col;
        next_state <= LD18;

      when LD18  => 
        a_ena <= '0';
        Aad := Aad + 1;
        RAMad := RAMad + 1;
        ram_ad <= std_logic_vector(RAMad);
        a_ad <= std_logic_vector(Aad);
        next_state <= LD18_1;

      when LD18_1  =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= LD19;
        else
          next_state <= LD18_1;
        end if;

      when LD19 =>
        ram_ena <= '0';
        a_ena <= '1';
        if i > "0000000000" then
          if a_done = '1' then
            next_state <= LD19_1;
          else
            next_state <= LD19;
          end if;
        else
          if a_done = '1' then
            next_state <= LD_STR_F;
          else
            next_state <= LD19;
          end if;
        end if;

      when LD19_1 =>
        i := (i - 1);
        next_state <= LD18;

      when LD_STR_F =>
        a_ena <= '0';
        ram_ena <= '0';
        inf_ena <= '0'; 
        Aad := "00000000000";
        ram_ad <= x"0000";
        a_ad <= "00000000000";
        RAMad := "0000000000000000";
        RAM_H := "00000000";
        RAM_L := "00000000";
        row := "00000";
        col := "00000";
        opcode <= "0000";
        next_state <= S4;

      --Store matrix in A in to RAM
      when STR0 =>
        divad <= '1';
        ir_op <= "010";
        next_state <= STR1;

      when STR1 =>
        RAM_H := unsigned(irdata);
        ir_op <= "011";
        Aad := "00000000010";
        a_wea <= '0';
        a_ena <= '0';
        ram_wea <= '1';
        ram_ena <= '0';
        opcode <= "1010";
        next_state <= STR2;

      when STR2 =>
        RAM_L := unsigned(irdata);
        divad <= '0';
        ir_enb <= '0';
        ir_op <= "000";
        RAMad := RAM_H & RAM_L;
        inf_ena <= '1';
        a_ad <= std_logic_vector(Aad);
        ram_ad <= std_logic_vector(RAMad);
        next_state <= STR3;

      when STR3 =>
        a_ena <= '1';
        if a_done = '1' then
          next_state <= STR3_1;
        else
          next_state <= STR3;
        end if;

      when STR3_1 =>
        a_ena <= '0';
        row := unsigned(adata(4 downto 0));
        Aad := Aad + 1;
        RAMad := RAMad + 1;
        a_ad <= std_logic_vector(Aad);
        next_state <= STR4;
        
      when STR4 =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= STR5;
        else
          next_state <= STR4;
        end if;

      when STR5 =>
        ram_ena <= '0';
        a_ena <= '1';
        ram_ad <= std_logic_vector(RAMad);
        if a_done = '1' then
          next_state <= STR5_1;
        else
          next_state <= STR5;
        end if;

      when STR5_1 =>
        a_ena <= '0';
        col := unsigned(adata(4 downto 0));
        i := row * col;
        next_state <= STR6;
        
      when STR6 =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= STR7;
        else
          next_state <= STR6;
        end if;

      when STR7 =>
        ram_ena <= '0';
        Aad := Aad + 1;
        RAMad := RAMad + 1;
        a_ad <= std_logic_vector(Aad);
        ram_ad <= std_logic_vector(RAMad);
        next_state <= STR7_1;

      when STR7_1 =>
        a_ena <= '1';
        if a_done = '1' then
          next_state <= STR8;
        else
          next_state <= STR7_1;
        end if;

      when STR8 =>
        a_ena <= '0';
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= STR8_1;
        else
          next_state <= STR8;
        end if;
        
      when STR8_1 =>
        i := (i - 1);
        if i > "0000000000" then
          next_state <= STR7;
        else
          next_state <= LD_STR_F;
        end if;

      --Fuzzy addition, substraction, multiplication
      when INF0 => 
        opcode <= irdata(3 downto 0);
        ir_op <= "011";
        reg_wea <= '0';
        reg_ena <= '0';
        a_wea <= '0';
        a_ena <= '0';
        next_state <= INF1;

      when INF1 =>
        regad := unsigned(irdata(3 downto 0));
        Aad := "00000000000";
        reg_ad <= std_logic_vector(regad + 2);
        a_ad <= std_logic_vector(Aad + 2);
        next_state <= INF1_1;

      when INF1_1 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= INF1_2;
        else
          next_state <= INF1_1;
        end if;

      when INF1_2 =>
        reg_ena <= '0';
        a_ena <= '1';
        if a_done = '1' then
          next_state <= INF2;
        else
          next_state <= INF1_2;
        end if;

      when INF2 =>
        a_ena <= '0';
        if not(regdata = adata) then
          next_state <= ERROR;
        else
          row := unsigned(regdata(4 downto 0));
          next_state <= INF2_1;
        end if;

      when INF2_1 =>
        reg_ad <= std_logic_vector(regad + 3);
        a_ad <= std_logic_vector(Aad + 3);
        ir_op <= "000";
        next_state <= INF3;

      when INF3 =>
        reg_ena <= '1';
        if reg_done = '1'then
          next_state <= INF3_1;
        else
          next_state <= INF3;
        end if;

      when INF3_1 =>
        reg_ena <= '0';
        a_ena <= '1';
        if a_done = '1' then
          next_state <= INF4;
        else
          next_state <= INF3_1;
        end if;

      when INF4 =>
        a_ena <= '0';
        if not(regdata = adata) then
          next_state <= ERROR;
        else
          col := unsigned(regdata(4 downto 0));
          next_state <= INF4_1;
        end if;
      
      when INF4_1 => 
        i := row * col;
        reg_ad <= std_logic_vector(regad);
        next_state <= INF5;

      when INF5 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= INF6;
        else
          next_state <= INF5;
        end if;

      when INF6 =>
        reg_ena <= '0';
        reg_ad <= std_logic_vector(regad + 1);
        RAM_H := unsigned(regdata);
        next_state <= INF7;

      when INF7 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= INF8;
          else
          next_state <= INF7;
          end if;
          
      when INF8 => 
        reg_ena <= '0';
        RAM_L := unsigned(regdata);
        RAMad := RAM_H & RAM_L;
        reg_ad <= "0000";
        inf_ena <= '0';
        Aad := "00000000010";
        RAMad := RAMad + 2;
        ram_wea <= '0';
        next_state <= INF9;

      when INF9 =>
        inf_ena <= '1';
        a_ad <= std_logic_vector(Aad);
        a_ena <= '1';
        if a_done = '1' then
          next_state <= INF9_1;
        else
          next_state <= INF9;
        end if;

      when INF9_1 =>
        a_ena <= '0';
        ram_ad <= std_logic_vector(RAMad);
        ram_ena <= '1';
        if ram_done = '1'then
          next_state <= INF10;
        else
          next_state <= INF9_1;
        end if;

      when INF10 =>
        ram_ena <= '0';
        inf_ena <= '0';
        a_wea <= '1';
        next_state <= INF11;
        
      when INF11 =>
        a_ena <= '1';
        if a_done = '1' then
          next_state <= INF12;
        else
          next_state <= INF11;
        end if;

      when INF12 =>
        a_ena <= '0';
        a_wea <= '0';
        i := i - 1;
        Aad := Aad + 1;
        RAMad := RAMad + 1;
        if i > "0000000000" then
          next_state <= INF9;
        else
          next_state <= LD_STR_F;
        end if; 
      
      --Clear registers
      when CR0 => 
        ir_op <= "010";
        reg_ena <= '0';
        a_ena <= '0';
        case irdata is
          when "00000000" | "00000100" | "00001000" | "00001100"  => 
            next_state <= CR1;
          when"00010000" =>
            next_state <= CR4;
          when others => next_state <= ERROR; 
        end case;

      when CR1 => 
        regad := unsigned(irdata(3 downto 0));
        reg_ad <= std_logic_vector(regad);
        i := "0000000100";
        reg_clr <= '1';
        next_state <= CR2;

      when CR2 =>
        reg_ena <= '1';
        if reg_done = '1' then
          next_state <= CR3;
        else
          next_state <= CR2;
        end if;
        
      when CR3 =>
        reg_ena <= '0';
        i := i - 1;
        regad := regad + 1;
        reg_ad <= std_logic_vector(regad(3 downto 0) + 1);
        if i < "0000000000" then
          next_state <= CR2;
        else
          next_state <= CR11;
        end if;

      when CR4 => 
        i := "0000000000";
        Aad := "00000000000";
        a_ad <= std_logic_vector(Aad + 2);
        next_state <= CR5;

      when CR5 =>
        a_ena <= '1';
        if a_done = '1' then
          next_state <= CR6;
        else
          next_state <= CR5;
        end if;

      when CR6 => 
        a_ena <= '0';
        row := unsigned(adata(4 downto 0));
        a_ad <= std_logic_vector(Aad + 3);
        next_state <= CR7;

      when CR7 =>
        a_ena <= '1';
        if a_done = '1' then
          next_state <= CR8;
        else
          next_state <= CR7;
        end if;

      when CR8 =>
        a_ena <= '0';
        a_clr <= '1';
        col := unsigned(adata(4 downto 0));
        i := (row * col) + 4;
        a_ad <= std_logic_vector(Aad);
        next_state <= CR9;

      when CR9 =>
        a_ena <= '1';
        if a_done = '1' then
          next_state <= CR10;
        else
          next_state <= CR9;
        end if;

      when CR10 =>
        a_ena <= '0';
        i := i - 1;
        Aad := Aad + 1;
        a_ad <= std_logic_vector(Aad);
        if i > "0000000000" then
          next_state <= CR10;
        else
          next_state <= CR11;
        end if;

      when CR11 =>
        a_ena <= '0';
        reg_ena <= '0';
        a_clr <= '0';
        reg_clr <= '0';
        Aad := "00000000000";
        reg_ad <= "0000";
        a_ad <= "00000000000";
        row := "00000";
        col := "00000";
        next_state <= S4;

      --Clear RAM
      when CM0 =>
        divad <= '1';
        ir_op <= "010";
        next_state <= CM1;

      when CM1 =>
        RAM_H := unsigned(irdata);
        ir_op <= "011";
        next_state <= CM2;

      when CM2 =>
        RAM_L := unsigned(irdata);
        RAMad := RAM_H & RAM_L;
        next_state <= CM3;

      when CM3 => 
        divad <= '0';
        ram_clr <= '1';
        ram_ad <= std_logic_vector(RAMad);
        next_state <= CM4;

      when CM4 =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= CM5;
        else
          next_state <= CM4;
        end if;

      when CM5 =>
        ram_ena <= '0';
        row := unsigned(ramdata(4 downto 0));
        ram_ad <= std_logic_vector(RAMad + 1);
        next_state <= CM6;

      when CM6 =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= CM7;
        else
          next_state <= CM6;
        end if;

      when CM7 => 
        ram_ena <= '0';
        col := unsigned(ramdata(4 downto 0));
        i := (row * col) + 2;
        next_state <= CM8;

      when CM8 =>
        ram_ad <= std_logic_vector(RAMad);
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= CM9;
        else
          next_state <= CM8;
        end if;

      when CM9 =>
        ram_ena <= '0';
        RAMad := RAMad + 1;
        i := i - 1;
        if i > "0000000000" then
          next_state <= CM8;
        else
          next_state <= CM10;
        end if;

      when CM10 =>
        ram_ena <= '0';
        ram_clr <= '0';
        ram_ad <= x"0000";
        RAMad := "0000000000000000";
        RAM_H := "00000000";
        RAM_L := "00000000";
        row := "00000";
        col := "00000";
        next_state <= S4;

      --Save program process
      when S5 =>
        saveprog <= '1';
        rom_wea <= '1';
        rom_ena <= '0';
        rom_din <= x"00000000";
        if pulse_edge = '1' then
          next_state <= S5_1;
        else
          next_state <= S5;
        end if;

      when S5_1 =>
        pc := unsigned(ba);
        next_state <= S5_2;

      when S5_2 =>
        if pulse_edge = '1' then
          next_state <= S6;
        else
          next_state <= S5_2;
        end if;

      when S6 =>
        prog_H := unsigned(ba);
        next_state <= S6_1;  
        if pulse_edge = '1' then
          next_state <= S6_2;
        else
          next_state <= S6;
        end if;

      -- when S6_1 =>
      --   if pulse_edge = '1' then
      --     next_state <= S6_2;
      --   else
      --     next_state <= S6_1;
      --   end if;

      when S6_2 =>
        prog_L := unsigned(ba);
        if pulse_edge = '1' then
          next_state <= S7;   
        else
          next_state <= S6_2;
        end if;
          
      when S7 =>
        rom_din <= std_logic_vector(prog_H & prog_L);
        rom_ad <= std_logic_vector(pc);
        if pulse_edge = '1' then
          next_state <= S7_1;
        else
          next_state <= S7;
        end if;

      when S7_1 =>
        rom_ena <= '1';
        if rom_done = '1' then
          next_state <= S8;
        else
          next_state <= S7_1;
        end if;
      
      when S8 =>
        rom_ena <= '0';
        pc := pc + 1;
        savedins <= '1';
        if pulse_edge = '1' then
          next_state <= S8_1;
        else
          next_state <= S8;
        end if;
      
      when S8_1 =>
        savedins <= '0';
        if savep = '1' then
          next_state <= S5;
        else
          next_state <= S0;
        end if;
      
      --Read RAM process
      when S9 => 
        readram <= '1';
        ram_wea <= '0';
        ram_ena <= '0';
        ram_ad <= "0000000000000000";
        if pulse_edge = '1' then
          next_state <= S9_1;
        else
          next_state <= S9;
        end if;

      when S9_1 =>
        RAMad := unsigned(ba);
        next_state <= S10;  
      
      when S10 =>
        if pulse_edge = '1' then
          next_state <= S10_1;
        else
          next_state <= S10;
        end if;

      when S10_1 =>
        row := unsigned(ba(4 downto 0));
        next_state <= S10_2;  

      when S10_2 =>
        if pulse_edge = '1' then
          next_state <= S10_3;
        else
          next_state <= S10_2;
        end if;

      when S10_3 =>
        col := unsigned(ba(4 downto 0));
        i := row * col;
        next_state <= S11; 

      when S11 =>
        flipflop_enb <= '1';
        ram_ad <= std_logic_vector(RAMad);
        next_state <= S12;
      
      when S12 =>
        ram_ena <= '1';
        if ram_done = '1' then
          next_state <= S12_1;
        else 
          next_state <= S12;
        end if;
      
      when S12_1 =>
        ram_ena <= '0';
        RAMad := RAMad + 1;
        i := i -1;
        next_state <= S12_2;
      
      when S12_2 =>
        if pulse_edge = '1' then
          next_state <= S13;
        end if;

      when S13 =>
        flipflop_enb <= '0';
        if i > "0000000000" then
          next_state <= S11;
        else
          next_state <= S0;
        end if; 

      when DONE =>
        prog_done <= '1';
        if pulse_edge = '1' then
          next_state <= S0;
        end if; 

      when ERROR => 
        prog_done <= '0';
        test <= '0';
        saveprog <= '0';
        runprog <= '0';
        readram <= '0';
        setled <= '0';
        savedins <= '0';
        err <= '1';
        next_state <= ERROR;

      when others =>
          next_state <= S0;
        
      end case;
  end process;

end Behavioral;
