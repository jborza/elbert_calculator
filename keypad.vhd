----------------------------------------------------------------------------------
-- 16 digit keypad module
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keypad is 
	Port ( Clk : in STD_LOGIC;
		RowPins : in  STD_LOGIC_VECTOR (3 downto 0);
		ColumnPins : out STD_LOGIC_VECTOR (3 downto 0); --with PULLUP
		Output : out STD_LOGIC_VECTOR (3 downto 0);
		OutputReady : out STD_LOGIC;
		Reset : in STD_LOGIC
		); 
end keypad;

architecture Behavioral of keypad is
	COMPONENT keypad_clock_divider
	PORT(
		Clk : IN std_logic;          
		Clk_slow : OUT std_logic
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
		
	type scanner_state_type is (scan_start, scan_c1, scan_c2, scan_c3, scan_c4, scan_output);
	signal scanner_state 	: scanner_state_type;

	signal key_read : STD_LOGIC_VECTOR (3 downto 0);
	--signal output : unsigned (3 downto 0);

	signal refresh_signal : STD_LOGIC;
begin
	Inst_keypad_clock_divider: keypad_clock_divider PORT MAP(
		Clk => Clk,
		Clk_slow => refresh_signal
	);
	--strobe the columns sequentially
process(Clk, reset)
begin
	if reset = '1' then
		scanner_state <= scan_start;
	elsif rising_edge(Clk) then
		case scanner_state is
			when scan_start =>
				ColumnPins <= col1;
				scanner_state <= scan_c1;
			
			when scan_c1 => 
				case RowPins is
					
					when row1 => key_read <= std_logic_vector(to_unsigned(1, 4));--1
					when row2 => key_read <= std_logic_vector(to_unsigned(4, 4)); --4
					when row3 => key_read <= std_logic_vector(to_unsigned(7, 4)); ----7
					when row4 => key_read <= std_logic_vector(to_unsigned(16#E#, 4));--*/E
					when others => null;  --no key
					
					
				end case;
				ColumnPins <= col2;
				scanner_state <= scan_c2;
			
			when scan_c2 => 
			
				ColumnPins <= col3;
				scanner_state <= scan_c3;
			
			when scan_c3 => 
			
				ColumnPins <= col4;
				scanner_state <= scan_c4;
			
			when scan_c4 => 
			
				scanner_state <= scan_output;
			
			when scan_output =>
				
				Output <= key_read;
				OutputReady <= '1';
				scanner_state <= scan_start;
			when others => 
				scanner_state <= scan_start;
		end case;
	end if;
end process;

end Behavioral;

