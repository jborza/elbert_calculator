----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module_playground is
Port ( Clk : in STD_LOGIC;
           SevenSegment : out  STD_LOGIC_VECTOR (7 downto 0);
			  Enable : out STD_LOGIC_VECTOR(2 downto 0); --7-segment enable bits
			  IO_P4_ROW : in STD_LOGIC_VECTOR(3 downto 0);
			  IO_P4_COL : out STD_LOGIC_VECTOR(3 downto 0);
           LED : out STD_LOGIC_VECTOR(7 downto 0);
			  reset : in STD_LOGIC --TODO map reset signal to a button
			  ); 
end top_module_playground;

architecture Behavioral of top_module_playground is

	COMPONENT keypad_debounce
	PORT(
		clk : IN std_logic;
		key_pressed_in : IN std_logic_vector(3 downto 0);          
		key_pressed_debounced : OUT std_logic_vector(3 downto 0);
		output_stable : OUT std_logic;
		reset : IN std_logic
		);
		END COMPONENT;

	COMPONENT keypad_row_synchronizer
	PORT(
		clk : IN std_logic;
		row_pins_async : IN std_logic_vector(3 downto 0);          
		row_out_sync : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT keypad_decoder
	PORT(
		clk : IN std_logic;
		row_pins : IN std_logic_vector(3 downto 0);
		column_pins : IN std_logic_vector(3 downto 0);
		reset : IN std_logic;          
		keycode_output : OUT std_logic_vector(3 downto 0);
		is_key_pressed : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT seven_seg_driver
	PORT(
		A : IN std_logic_vector(7 downto 0);
		B : IN std_logic_vector(7 downto 0);
		C : IN std_logic_vector(7 downto 0);
		Clk12Mhz : IN std_logic;          
		SevenSegment : OUT std_logic_vector(7 downto 0);
		Enable : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT seven_seg_4bit
	PORT(
		Number : IN std_logic_vector(3 downto 0);          
		SevenSegment : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	signal rows_sync : std_logic_vector(3 downto 0);
	signal rows_debounced : std_logic_vector(3 downto 0);
	
	

	constant col1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";	
	constant col2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";	
	constant col3 : STD_LOGIC_VECTOR(3 downto 0) := "0100";	
	constant col4 : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	type scanner_state_type is (scan_start, scan_c1, scan_c2, scan_c3, scan_c4, scan_done);
	signal scanner_state 	: scanner_state_type := scan_start;
	
	signal keypad_out : std_logic_vector(3 downto 0);
	signal keypad_decoder_out : std_logic_vector(3 downto 0);
	
	signal keypad_row_stable : std_logic;
	signal debounce_reset : std_logic;
	
	signal keypad_rows_read : std_logic_vector(3 downto 0);
	signal column_pins : std_logic_vector(3 downto 0);
	
	signal ones : std_logic_vector(3 downto 0);
	
	signal is_key_pressed : std_logic;
	
begin

	Inst_keypad_debounce: keypad_debounce PORT MAP(
		clk => Clk,
		key_pressed_in => rows_sync,
		key_pressed_debounced => rows_debounced,
		output_stable => keypad_row_stable,
		reset => debounce_reset
	);
	
	Inst_keypad_row_synchronizer: keypad_row_synchronizer PORT MAP(
		clk => Clk,
		row_pins_async => IO_P4_ROW,
		row_out_sync => rows_sync
	);

	Inst_keypad_decoder: keypad_decoder PORT MAP(
		clk => Clk,
		row_pins => keypad_rows_read,
		column_pins => column_pins,
		keycode_output => keypad_decoder_out, --LED(3 downto 0),
		is_key_pressed => is_key_pressed,
		reset => reset
	);
	
	-- 7-seg
--	Inst_seven_seg_4bit_hundreds: seven_seg_4bit PORT MAP(
--		Number => hundreds,
--		SevenSegment => SSeg_A
--	);
--	Inst_seven_seg_4bit_tens: seven_seg_4bit PORT MAP(
--		Number => tens,
--		SevenSegment => SSeg_B
--	);
	Inst_seven_seg_4bit_ones: seven_seg_4bit PORT MAP(
		Number => ones,
		SevenSegment => SevenSegment
	);
	
--	Inst_seven_seg_driver: seven_seg_driver PORT MAP(
--		A => SSeg_A,
--		B => SSeg_B,
--		C => SSeg_C,
--		SevenSegment => SevenSegment,
--		Enable => Enable,
--		Clk12Mhz => Clk
--	);
	
--	Inst_bin2bcd: bin2bcd_10bit PORT MAP(
--		binIN => std_logic_vector(display_number),
--		ones => ones,
--		tens => tens,
--		hundreds => hundreds
--	);
	
	
	process(clk,reset)		
	begin	
		if(reset = '1') then
			scanner_state <= scan_start;
		elsif rising_edge(clk) then
			case scanner_state is
				when scan_start =>
					column_pins <= col1;
					scanner_state <= scan_c1;
					debounce_reset <= '1';					
					ones <= x"0";				
				when scan_c1 => 
					ones <= x"1";
					debounce_reset <= '0';
					if keypad_row_stable = '1' then
						--check if debounced row is one-hot (valid signal)
						if rows_debounced = "0001" or rows_debounced = "0010" or rows_debounced = "0100" or rows_debounced = "1000" then
							keypad_rows_read <= rows_debounced;
							scanner_state <= scan_done;
						else
							column_pins <= col2;
							scanner_state <= scan_c2;
							debounce_reset <= '1';
						end if;
					end if;
				when scan_c2 => 
					ones <= x"2";
					debounce_reset <= '0';
					if keypad_row_stable = '1' then
						--check if debounced row is one-hot (valid signal)
						if rows_debounced = "0001" or rows_debounced = "0010" or rows_debounced = "0100" or rows_debounced = "1000" then
							keypad_rows_read <= rows_debounced;
							scanner_state <= scan_done;
						else
							column_pins <= col3;
							scanner_state <= scan_c3;
							debounce_reset <= '1';
						end if;
					end if;
				when scan_c3 => 
					ones <= x"3";
					debounce_reset <= '0';
					if keypad_row_stable = '1' then
						--check if debounced row is one-hot (valid signal)
						if rows_debounced = "0001" or rows_debounced = "0010" or rows_debounced = "0100" or rows_debounced = "1000" then
							keypad_rows_read <= rows_debounced;
							scanner_state <= scan_done;
						else
							column_pins <= col4;
							scanner_state <= scan_c4;
							debounce_reset <= '1';
						end if;
					end if;
				when scan_c4 => 
					ones <= x"4";
					debounce_reset <= '0';
					if keypad_row_stable = '1' then
						--check if debounced row is one-hot (valid signal)
						if rows_debounced = "0001" or rows_debounced = "0010" or rows_debounced = "0100" or rows_debounced = "1000" then
							keypad_rows_read <= rows_debounced;
							scanner_state <= scan_done;
						else
							--transition back to beginning
							scanner_state <= scan_start;
							keypad_rows_read <= "0000";
						end if;
					end if;
				when scan_done =>
					ones <= x"5";
					--display the number					
					--if is_key_pressed = '1' then
						keypad_out <= keypad_decoder_out;
					--end if;
					scanner_state <= scan_start;
			end case;
			--ones <= std_logic_vector(to_unsigned(scanner_state, 8));
		end if; --rising_edge(clk)
	end process;
	
	Enable <= "110";
	
	IO_P4_COL <= column_pins;
	--SevenSegment <= "00000000";
	LED(3 downto 0) <= keypad_out;
	--LED(4) <= debounce_reset;
	--LED(5) <= reset;
	--LED(7) <= keypad_row_stable;
	--LED(6) <= reset;
	
	
	--LED(7 downto 4) <= rows_sync;
	LED(7) <= is_key_pressed;
	LED(6) <= keypad_row_stable;
	LED(5) <= '0';
	LED(4) <= '0';
	

end Behavioral;

