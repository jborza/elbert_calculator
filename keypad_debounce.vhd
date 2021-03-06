----------------------------------------------------------------------------------
-- keypad debouncer - must stay stable for N clocks
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity keypad_debounce is
    Port ( clk : in  STD_LOGIC;
           key_pressed_in : in  STD_LOGIC_VECTOR (3 downto 0);
           key_pressed_debounced : out  STD_LOGIC_VECTOR (3 downto 0);
			  output_stable : out STD_LOGIC;
			  reset : in STD_LOGIC
			  );
end keypad_debounce;

architecture Behavioral of keypad_debounce is

begin
	process(clk, reset) 
		--constant DEBOUNCE_CLK_PERIODS : integer := 12_000_000 / 1; --we want it to stay the same for 1 ms
		constant DEBOUNCE_CLK_PERIODS : integer := 8;
		variable prev_keypad_state : STD_LOGIC_VECTOR(3 downto 0) := "0000";
		variable debounce_count : integer range 0 to DEBOUNCE_CLK_PERIODS-1 := 0;
	begin
		if(reset = '1') then
			debounce_count := 0;
			output_stable <= '0';
			key_pressed_debounced <= "0000";
			prev_keypad_state := "0000";
		elsif rising_edge(clk) then
			if (key_pressed_in /= prev_keypad_state) then
				key_pressed_debounced <= "0000";
				prev_keypad_state := key_pressed_in;
				debounce_count := 0;
				output_stable <= '0';
			else 
				if (debounce_count /= DEBOUNCE_CLK_PERIODS-1) then
				  debounce_count := debounce_count + 1;
				  output_stable <= '0';
				else
				  key_pressed_debounced <= prev_keypad_state;
				  output_stable <= '1';
				end if;
			end if;
		end if;
	end process;

end Behavioral;

