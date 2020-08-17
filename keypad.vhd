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

entity keypad is 
	Port ( clk : in STD_LOGIC;
		row_pins : in  STD_LOGIC_VECTOR (3 downto 0);
		column_pins : out STD_LOGIC_VECTOR (3 downto 0); --with PULLUP
		output : out STD_LOGIC_VECTOR (3 downto 0);
		output_ready : out STD_LOGIC;
		key_pressed : out STD_LOGIC;
		--key_type_digit : out STD_LOGIC; --1 for digit, 0 for special keys
		reset : in STD_LOGIC
		); 
end keypad;

architecture Behavioral of keypad is
	COMPONENT keypad_clock_divider
	PORT(
		clk : IN std_logic;          
		clk_slow : OUT std_logic
		);
	END COMPONENT;
	
	constant col1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";	
	constant col2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";	
	constant col3 : STD_LOGIC_VECTOR(3 downto 0) := "0100";	
	constant col4 : STD_LOGIC_VECTOR(3 downto 0) := "1000";

	constant row1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";	
	constant row2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";	
	constant row3 : STD_LOGIC_VECTOR(3 downto 0) := "0100";	
    constant row4 : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    
    constant KEY_NONE : STD_LOGIC_VECTOR(3 downto 0) := "0000";
		
	type scanner_state_type is (scan_start, scan_c1, scan_c2, scan_c3, scan_c4, scan_done);
	signal scanner_state 	: scanner_state_type;

	signal zero_read : STD_LOGIC;
	signal key_read : STD_LOGIC_VECTOR (3 downto 0);

	signal refresh_signal : STD_LOGIC;
	
begin
	Inst_keypad_clock_divider: keypad_clock_divider PORT MAP(
		clk => clk,
		clk_slow => refresh_signal
	);
	--strobe the columns sequentially
process(refresh_signal, reset)
begin
	if reset = '1' then
		scanner_state <= scan_start;
	elsif rising_edge(refresh_signal) then
		case scanner_state is
			when scan_start =>
				column_pins <= col1;
				scanner_state <= scan_c1;
				output_ready <= '0';
				zero_read <= '0';
				key_read <= KEY_NONE;
			
			when scan_c1 => 
				case row_pins is				
					when row1 => key_read <= x"1"; 
					when row2 => key_read <= x"4"; 
					when row3 => key_read <= x"7"; 
					when row4 => key_read <= x"e"; --* or E
					when others => null;  --no key							
				end case;
				column_pins <= col2;
				scanner_state <= scan_c2;
			
			when scan_c2 => 
				case row_pins is				
					when row1 => key_read <= x"2";
					when row2 => key_read <= x"5";
					when row3 => key_read <= x"8";
					when row4 => key_read <= x"0";
						zero_read <= '1'; --special flag to let us know we read zero
					when others => null;  --no key							
				end case;			
				column_pins <= col3;
				scanner_state <= scan_c3;
			
			when scan_c3 => 
				case row_pins is				
					when row1 => key_read <= x"3";
					when row2 => key_read <= x"6";
					when row3 => key_read <= x"9";
					when row4 => key_read <= x"f"; -- # or F
					when others => null;  --no key							
				end case;
				column_pins <= col4;
				scanner_state <= scan_c4;
			
			when scan_c4 => 
				case row_pins is				
					when row1 => key_read <= x"a";
					when row2 => key_read <= x"b";
					when row3 => key_read <= x"c";
					when row4 => key_read <= x"d";
					when others => null;  --no key							
                end case;
                scanner_state <= scan_done;
			when scan_done =>
				output <= key_read;
				output_ready <= '1';
				--output key_pressed signal if anything was pressed
				if (key_read = KEY_NONE and zero_read = '0') then
					key_pressed <= '0';
				else
					key_pressed <= '1';
				end if;					
				scanner_state <= scan_start;
			when others => 
				scanner_state <= scan_start;
		end case;
	end if;
end process;

end Behavioral;

