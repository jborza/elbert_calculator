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
	
	signal output_ready : STD_LOGIC;
	signal keypad_output : STD_LOGIC_VECTOR(3 downto 0);
	signal key_pressed : STD_LOGIC;
begin

Enable <= "011";

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
	
	Inst_seven_seg_4bit: seven_seg_4bit PORT MAP(
		Number => keypad_output,
		SevenSegment => SevenSegment
	);

process(Clk)
begin
		if rising_edge(Clk) then
			--LED <= IO_P4;
			--SevenSegment <= IO_P4;
			LED(3 downto 0) <= keypad_output;
			
		end if;
end process;

end Behavioral;

