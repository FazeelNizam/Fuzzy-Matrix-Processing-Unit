library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_fsm is
    Port ( nrst : in  STD_LOGIC;
           clk: in std_logic;
           enb: in std_logic;
           clr: in std_logic;
           op: in std_logic;
           done: out std_logic;
           mx: out std_logic;
           wea: out std_logic);
end ram_fsm;

architecture Behavioral of ram_fsm is
    type state_type is (Idle, Clear, Decode, Mwrite, DoneState);
    signal state, next_state: state_type;
begin
    process(clk, nrst)
    begin
        if nrst = '0' then
            state <= Idle;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, enb, clr, op)
    begin
        case state is
            when Idle =>
                done <= '0';
                mx <= '0';
                wea <= '0';
                if clr = '1' then
                    next_state <= Clear;
                elsif enb = '1' then
                    next_state <= Decode;
                else
                    next_state <= Idle;
                end if;

            when Clear =>
                mx <= '1';
                wea <= '1';
                done <= '0';
                next_state <= DoneState;

            when Decode =>
                mx <= '0';
                wea <= '0';
                done <= '0';
                if op = '1' then
                    next_state <= Mwrite;
                else
                    next_state <= DoneState;
                end if;

            when Mwrite =>
                mx <= '0';
                wea <= '1';
                done <= '0';
                next_state <= DoneState;

            when DoneState =>
                mx <= '0';
                wea <= '0';
                done <= '1';
                next_state <= Idle;

            when others =>
                next_state <= Idle;
        end case;
    end process;
end Behavioral;
