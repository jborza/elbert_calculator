----------------------------------------------------------------------------------
-- keypad poller
-- whenever a keypad output comes, this component will store it in a register 
-- and rewrite only if:
--  - key is released
--  - a different key is pushed
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity keypad_poller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  key_pressed_in : in  STD_LOGIC_VECTOR (3 downto 0);			 
           keypad_key_pressed : in STD_LOGIC;
			  keypad_output_ready : in STD_LOGIC;
			  clear : in STD_LOGIC; --TODO isn't it the same as reset?
           poller_output : out  STD_LOGIC_VECTOR (3 downto 0);
           output_ready : out  STD_LOGIC);
end keypad_poller;

architecture Behavioral of keypad_poller is
	signal next_keypad_state : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
	process(clk, reset) 
		variable toggle_output_ready : STD_LOGIC := '0';
	begin
		  if reset = '1' then 
				next_keypad_state <= "0000"; --again - what about zero?
				toggle_output_ready := '0';
		  elsif rising_edge(clk) then
				if clear = '1' then
					toggle_output_ready := '0';
				elsif toggle_output_ready = '0' and keypad_key_pressed = '1' and keypad_output_ready = '1' then
					--read the first digit coming in and set the output flag
					if key_pressed_in /= next_keypad_state then					
						next_keypad_state <= key_pressed_in;
						
						toggle_output_ready := '1';
					end if;
				elsif toggle_output_ready = '1' then 
					-- do nothing, emit the same output
				end if;				
				output_ready <= toggle_output_ready;
				poller_output <= next_keypad_state;
		  end if;
	end process;
end Behavioral;