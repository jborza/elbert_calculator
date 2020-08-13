----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity calc_top_module is
	Port ( Clk : in STD_LOGIC;
				--DPSwitch : in  STD_LOGIC_VECTOR (7 downto 0);
           SevenSegment : out  STD_LOGIC_VECTOR (7 downto 0);
			  Enable : out STD_LOGIC_VECTOR(2 downto 0);
			  IO_P4_ROW : in STD_LOGIC_VECTOR(3 downto 0);
			  IO_P4_COL : out STD_LOGIC_VECTOR(3 downto 0);
			  LED : out STD_LOGIC_VECTOR(3 downto 0)
			  ); --7-segment enable bits
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
	
	signal counter : unsigned(11 downto 0);
	
	constant tick_counter_limit : integer := 2000000; --counter limit before blink
	signal tick_counter : unsigned (23 downto 0); -- 25 bit counter (going to 33M)
begin

--Enable <= "110";

-- module instances

	Inst_keypad: keypad PORT MAP(
		clk => Clk,
		row_pins => IO_P4_ROW,
		column_pins => IO_P4_COL,
		output => keypad_output,
		output_ready => output_ready,
		key_pressed => key_pressed,
		reset => '0'
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
	
	Inst_bin2bcd_12bit: bin2bcd_12bit PORT MAP(
		binIN => std_logic_vector(counter),
		ones => ones,
		tens => tens,
		hundreds => hundreds,
		thousands => open
	);

process(Clk)
begin
		if rising_edge(Clk) then
			--LED <= IO_P4;
			--SevenSegment <= IO_P4;
			LED(3 downto 0) <= keypad_output;
			
			if tick_counter = tick_counter_limit then
				tick_counter <= (others => '0'); --reset the counter
				counter <= counter + 1; --add one number
			else
				tick_counter <= tick_counter + 1; --increment the counter
			end if;

			
		end if;
end process;

end Behavioral;

