----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity calc_top_module is
	Port ( Clk : in STD_LOGIC;
           SevenSegment : out  STD_LOGIC_VECTOR (7 downto 0);
			  Enable : out STD_LOGIC_VECTOR(2 downto 0); --7-segment enable bits
			  IO_P4_ROW : in STD_LOGIC_VECTOR(3 downto 0);
			  IO_P4_COL : out STD_LOGIC_VECTOR(3 downto 0);
           LED : out STD_LOGIC_VECTOR(7 downto 0);
			  reset : in STD_LOGIC --TODO map reset signal to a button
			  ); 
end calc_top_module;

architecture Behavioral of calc_top_module is
	COMPONENT keypad
	PORT(
		clk : IN std_logic;
		row_pins : IN std_logic_vector(3 downto 0);
		reset : IN std_logic;          
		column_pins : OUT std_logic_vector(3 downto 0);
		output : OUT std_logic_vector(3 downto 0);
		output_ready : OUT std_logic;
		key_pressed : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT seven_seg_4bit
	PORT(
		Number : IN std_logic_vector(3 downto 0);          
		SevenSegment : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT bin2bcd_12bit
	PORT(
		binIN : IN std_logic_vector(11 downto 0);          
		ones : OUT std_logic_vector(3 downto 0);
		tens : OUT std_logic_vector(3 downto 0);
		hundreds : OUT std_logic_vector(3 downto 0);
		thousands : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT bin2bcd_10bit
	PORT(
		binIN : IN std_logic_vector(9 downto 0);          
		ones : OUT std_logic_vector(3 downto 0);
		tens : OUT std_logic_vector(3 downto 0);
		hundreds : OUT std_logic_vector(3 downto 0)
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
	
	signal output_ready : STD_LOGIC;
	signal keypad_output : STD_LOGIC_VECTOR(3 downto 0);
	signal key_pressed : STD_LOGIC;
	
	signal ones : std_logic_vector(3 downto 0);
	signal tens : std_logic_vector(3 downto 0);
	signal hundreds : std_logic_vector(3 downto 0);
	
	signal SSeg_A : STD_LOGIC_VECTOR(7 downto 0);
	signal SSeg_B : STD_LOGIC_VECTOR(7 downto 0);
	signal SSeg_C : STD_LOGIC_VECTOR(7 downto 0); 
	
	--signal counter : unsigned(9 downto 0);
	
	--constant tick_counter_limit : integer := 1000000; --counter limit before number is incremented
	--signal tick_counter : unsigned (23 downto 0); -- 25 bit counter (going to 33M)
	
	
    
    --calculator internals
	type calculator_state_type is (calculator_reset, read_digit, digit_pressed, plus_pressed, minus_pressed, calculate, display_result);
    type operation_type is (plus, minus);
    
    signal calculator_state : calculator_state_type;
    signal current_operation : operation_type;
	 signal next_operation : operation_type;
    signal reg_arg : unsigned(9 downto 0);
    signal reg_result : unsigned (9 downto 0);
	 
	 signal display_number : unsigned (9 downto 0);
	 
	 signal calculator_state_pos : integer;
begin
-- module instances
	Inst_keypad: keypad PORT MAP(
		clk => Clk,
		row_pins => IO_P4_ROW,
		column_pins => IO_P4_COL,
		output => keypad_output,
		output_ready => output_ready,
		key_pressed => key_pressed,
		reset => reset
	);
	
	Inst_seven_seg_4bit_hundreds: seven_seg_4bit PORT MAP(
		Number => hundreds,
		SevenSegment => SSeg_A
	);
	Inst_seven_seg_4bit_tens: seven_seg_4bit PORT MAP(
		Number => tens,
		SevenSegment => SSeg_B
	);
	Inst_seven_seg_4bit_ones: seven_seg_4bit PORT MAP(
		Number => ones,
		SevenSegment => SSeg_C
	);
	
	Inst_seven_seg_driver: seven_seg_driver PORT MAP(
		A => SSeg_A,
		B => SSeg_B,
		C => SSeg_C,
		SevenSegment => SevenSegment,
		Enable => Enable,
		Clk12Mhz => Clk
	);
	
	Inst_bin2bcd: bin2bcd_10bit PORT MAP(
		binIN => std_logic_vector(display_number),
		ones => ones,
		tens => tens,
		hundreds => hundreds
	);

process(Clk, reset)
begin
    if reset = '1' then 
        calculator_state <= calculator_reset;
    elsif rising_edge(Clk) then
        case(calculator_state) is
        
            when calculator_reset =>
                reg_arg <= to_unsigned(3, reg_arg'length);
                reg_result <= to_unsigned(0, reg_result'length);
                current_operation <= plus;
					 display_number <= to_unsigned(0, display_number'length);
					 calculator_state <= read_digit;

				when read_digit => 
					display_number <= reg_arg;
					--decide based on what was pressed
					--TODO clear the keypad
					if key_pressed = '1' then
						case( keypad_output ) is
                            when x"C" => --C as clear
                                calculator_state <= calculator_reset;
                            when x"E" => --* = +
                                calculator_state <= plus_pressed;
                            when x"F" => --# = /
                                calculator_state <= minus_pressed;
									 when x"A" => --??? undefined
									 when x"B" => --??? undefined
									 when x"D" => --??? undefined
									 --TODO transition to digit_pressed and do reg_arg logic there
                            when others => --digit pressed (or A,B,D)
											--do not accept new number if the current value >= 100
											if (reg_arg < 100) then
													reg_arg <= (reg_arg * 10) + unsigned(keypad_output);
											end if;
											calculator_state <= digit_pressed;
                        end case ;
					end if;					
					
				when digit_pressed =>
					calculator_state <= read_digit;
				when plus_pressed =>
					next_operation <= plus;
					calculator_state <= calculate;
				when minus_pressed => 
					next_operation <= minus;
					calculator_state <= calculate;
				when calculate =>
					if current_operation = plus then
						reg_result <= reg_result + reg_arg;
					else
						reg_result <= reg_result - reg_arg;
					end if;
					reg_arg <= to_unsigned(0, reg_arg'length);
					current_operation <= next_operation;
					calculator_state <= display_result;
					
				when display_result =>
					display_number <= reg_result;
					--todo await keypad input for state transition
					--???
            when others =>
                calculator_state <= calculator_reset;
        
        end case ;

			--LED <= IO_P4;
			--SevenSegment <= IO_P4;
			--LED(3 downto 0) <= keypad_output;
			
			LED(0) <= keypad_output(3);
			LED(1) <= keypad_output(2);
			LED(2) <= keypad_output(1);
			LED(3) <= keypad_output(0);
			
			calculator_state_pos <= calculator_state_type'POS(calculator_state);
			LED(7 downto 4) <= std_logic_vector(to_unsigned(calculator_state_pos, 4));
			
			-- if tick_counter = tick_counter_limit then
			-- 	tick_counter <= (others => '0'); --reset the counter
			-- 	counter <= counter + 1; --add one number
			-- else
			-- 	tick_counter <= tick_counter + 1; --increment the counter
			-- end if;

			
    end if;
end process;

end Behavioral;

