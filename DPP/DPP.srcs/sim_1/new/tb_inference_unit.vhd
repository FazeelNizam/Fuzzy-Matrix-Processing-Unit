library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_inference_unit is
end tb_inference_unit;

architecture behavior of tb_inference_unit is

    -- Component Declaration for the Unit Under Test (UUT)
    component inference_unit
        Port (
            Da     : in  STD_LOGIC_VECTOR(7 downto 0);
            Db     : in  STD_LOGIC_VECTOR(7 downto 0);
            opcode : in  STD_LOGIC_VECTOR(3 downto 0);
            Do     : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Testbench signals
    signal Da_tb, Db_tb : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal opcode_tb    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Do_tb        : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: inference_unit
        Port map (
            Da     => Da_tb,
            Db     => Db_tb,
            opcode => opcode_tb,
            Do     => Do_tb
        );

    -- Stimulus Process
    stim_proc: process
    begin
        -- Test 1: Opcode "0000" ? Output 0x00
        Da_tb <= x"12"; Db_tb <= x"34"; opcode_tb <= "0000";
        wait for 10 ns;
        report "0000 ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        -- Test 2: Opcode "0101" (FADD) ? Larger of Da, Db
        Da_tb <= x"20"; Db_tb <= x"10"; opcode_tb <= "0101";
        wait for 10 ns;
        report "0101 (Da>Db) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        Da_tb <= x"05"; Db_tb <= x"30"; opcode_tb <= "0101";
        wait for 10 ns;
        report "0101 (Da<Db) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        -- Test 3: Opcode "0110" (FSUB) ? Da if Da>Db else 0x00
        Da_tb <= x"40"; Db_tb <= x"20"; opcode_tb <= "0110";
        wait for 10 ns;
        report "0110 (Da>Db) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        Da_tb <= x"10"; Db_tb <= x"50"; opcode_tb <= "0110";
        wait for 10 ns;
        report "0110 (Da<Db) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        -- Test 4: Opcode "0111" (FMUL) ? Smaller of Da, Db
        Da_tb <= x"08"; Db_tb <= x"10"; opcode_tb <= "0111";
        wait for 10 ns;
        report "0111 (Da<Db) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        Da_tb <= x"50"; Db_tb <= x"20"; opcode_tb <= "0111";
        wait for 10 ns;
        report "0111 (Da>Db) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        -- Test 5: Opcode "1010" ? Output Da
        Da_tb <= x"77"; Db_tb <= x"99"; opcode_tb <= "1010";
        wait for 10 ns;
        report "1010 ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        -- Test 6: Opcode "1011" ? Output Db
        Da_tb <= x"77"; Db_tb <= x"99"; opcode_tb <= "1011";
        wait for 10 ns;
        report "1011 ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        -- Test 7: Others (unimplemented opcodes)
        Da_tb <= x"12"; Db_tb <= x"34"; opcode_tb <= "1111";
        wait for 10 ns;
        report "1111 (others) ? Do = " & integer'image(to_integer(unsigned(Do_tb)));

        wait;
    end process;

end behavior;
