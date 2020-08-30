----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


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
		output_stable : OUT std_logic
		);
		END COMPONENT;

	COMPONENT keypad_row_synchronizer
	PORT(
		clk : IN std_logic;
		row_pins_async : IN std_logic_vector(3 downto 0);          
		row_out_sync : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal rows_sync : std_logic_vector(3 downto 0);
begin

	Inst_keypad_debounce: keypad_debounce PORT MAP(
		clk => Clk,
		key_pressed_in => rows_sync,
		key_pressed_debounced => LED(3 downto 0),
		output_stable => LED(7)
	);
	
	Inst_keypad_row_synchronizer: keypad_row_synchronizer PORT MAP(
		clk => Clk,
		row_pins_async => IO_P4_ROW,
		row_out_sync => rows_sync
	);
	
	Enable <= "111";
	SevenSegment <= "00000000";
	LED(4) <= '0';
	LED(5) <= '0';
	LED(6) <= reset;
	IO_P4_COL <= "0001";

end Behavioral;

