----------------------------------------------------------------------------------
-- This unit should take care of keypad bounce by checking every transition
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity keypad_debouncer is
    Port ( clk : in  STD_LOGIC; -- 12 mhz clock
           reset : in  STD_LOGIC;
           row_pins : in  STD_LOGIC_VECTOR (3 downto 0); --row signals from the keypad
           col_pins : out  STD_LOGIC_VECTOR (3 downto 0); --column signals to the keypad
           row_out : out  STD_LOGIC_VECTOR (3 downto 0)); --detected active row
end keypad_debouncer;

architecture Behavioral of keypad_debouncer is
	signal clk_1ms : STD_LOGIC;
	type debouncer_state_type is (scan_start);
	signal debouncer_state 	: debouncer_state_type;
	constant KEY_NONE : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin

--clk_1ms_process : process(clk) 
--	constant CLK_DIVIDER_1MS_LIMIT : integer := 12_000_000 / 1000;
--	variable clk_divider_1ms : integer range 0 to CLK_DIVIDER_1MS_LIMIT;
--begin
--	if rising_edge(clk) then
--		if clk_divider_1ms = 0 then
--			clk_divider_1ms := CLK_DIVIDER_1MS_LIMIT - 1;
--			clk_1ms <= '1';
--		else
--			clk_divider_1ms := clk_divider_1ms - 1;
--			clk_1ms <= '0';
--		end if;
--	end if;
--end process;

process(clk, reset)
	variable col_pins_out : STD_LOGIC_VECTOR (3 downto 0);
begin
	if reset = '1' then
		col_pins <= "0001";
		row_out <= "0000";
	elsif rising_edge(clk) then
		case debouncer_state is
			when scan_row =>
			
			
				
		end case; --debouncer_state
		row_out <= "0000";
		col_pins_out := col_pins_out(2 downto 0) & col_pins_out (3);  --rotate column signal
		--col_pins <= col_pins(2 downto 0) & col_pins(3); 
		--wait 1 ms
		
		
		col_pins <= col_pins_out;
	end if;
end process;
--	Reset: row_out <= "0000"; keypad_col_out <= "0001";
--
--1. row_out <= "0000";
--2. col_pins <= col_pins(2 downto 0) & col_pins(3); --rotate column signal
--3. WAIT 1 ms;
--4. IF(keypad_row_in = 1111) THEN GOTO 1;
--5. row_out <= NOT keypad_row_in;
--6. WAIT 1 ms;
--7. IF(keypad_row_in != 1111) THEN GOTO 6;
--8. GOTO 1; 

--rewritten algorithm:
-- reset
-- set (rotate) next column
--  read column

end Behavioral;

