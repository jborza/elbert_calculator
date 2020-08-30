----------------------------------------------------------------------------------
-- 16 digit keypad encoder module
-- 
-- 1 2 3 A
-- 4 5 6 B
-- 7 8 9 C
-- * 0 # D	

-- let's treat special characters: 
-- * = 0xE and # = 0xF
-- pins 1-4 from the keypad are column (output) pins
-- pins 5-8 from the keypad are the row (input) pins
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity keypad_decoder is 
	Port ( clk : in STD_LOGIC;
		row_pins : in STD_LOGIC_VECTOR (3 downto 0);
		column_pins : in STD_LOGIC_VECTOR (3 downto 0); --with PULLUP
		keycode_output : out STD_LOGIC_VECTOR (3 downto 0);
		is_key_pressed : out STD_LOGIC;
		--key_type_digit : out STD_LOGIC; --1 for digit, 0 for special keys
		reset : in STD_LOGIC
		); 
end keypad_decoder;

architecture Behavioral of keypad_decoder is	
	constant col1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";	
	constant col2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";	
	constant col3 : STD_LOGIC_VECTOR(3 downto 0) := "0100";	
	constant col4 : STD_LOGIC_VECTOR(3 downto 0) := "1000";

	constant row1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";	
	constant row2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";	
	constant row3 : STD_LOGIC_VECTOR(3 downto 0) := "0100";	
   constant row4 : STD_LOGIC_VECTOR(3 downto 0) := "1000";
   
   constant KEY_NONE : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin
process(clk, reset)
	variable key_read : STD_LOGIC_VECTOR(3 downto 0) := KEY_NONE;
	variable valid_key : STD_LOGIC := '0';
begin
	if reset = '1' then
		keycode_output <= KEY_NONE;
		is_key_pressed <= '0';
	elsif rising_edge(clk) then
		valid_key := '1';
		case column_pins is
			when col1 => 
				case row_pins is				
					when row1 => key_read := x"1"; 
					when row2 => key_read := x"4"; 
					when row3 => key_read := x"7"; 
					when row4 => key_read := x"e"; --* or E
					when others => key_read := KEY_NONE; valid_key := '0';  --no key							
				end case;
			when col2 => 
				case row_pins is				
					when row1 => key_read := x"2";
					when row2 => key_read := x"5";
					when row3 => key_read := x"8";
					when row4 => key_read := x"0";
					when others => key_read := KEY_NONE; valid_key := '0'; --no key							
				end case;			
			when col3 => 
				case row_pins is				
					when row1 => key_read := x"3";
					when row2 => key_read := x"6";
					when row3 => key_read := x"9";
					when row4 => key_read := x"f"; -- # or F
					when others => key_read := KEY_NONE; valid_key := '0';  --no key							
				end case;
			when col4 => 
				case row_pins is				
					when row1 => key_read := x"a";
					when row2 => key_read := x"b";
					when row3 => key_read := x"c";
					when row4 => key_read := x"d";
					when others => key_read := KEY_NONE; valid_key := '0'; --no key							
				end case;
			when others =>
				keycode_output <= KEY_NONE;
				is_key_pressed <= '0';
		end case;
		
		if (valid_key = '0') then
			is_key_pressed <= '0';
			keycode_output <= KEY_NONE;
		else
			is_key_pressed <= '1';
			keycode_output <= key_read;
		end if;					
			
	end if; --rising_edge(clk)
end process;
end Behavioral;