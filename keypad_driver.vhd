----------------------------------------------------------------------------------
-- keypad driver with polling
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity keypad_driver is
	Port ( clk : in STD_LOGIC;
		row_pins : in  STD_LOGIC_VECTOR (3 downto 0);
		column_pins : out STD_LOGIC_VECTOR (3 downto 0); --with PULLUP
		output : out STD_LOGIC_VECTOR (3 downto 0);
		output_ready : out STD_LOGIC;
		key_pressed : out STD_LOGIC;
		--key_type_digit : out STD_LOGIC; --1 for digit, 0 for special keys
		clear : in STD_LOGIC;
		reset : in STD_LOGIC
		); 
end keypad_driver;

architecture Behavioral of keypad_driver is
	COMPONENT keypad_clock_divider
	PORT(
		clk : IN std_logic;          
		clk_slow : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT keypad_decoder
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
	
	COMPONENT keypad_poller
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		key_pressed_in : IN std_logic_vector(3 downto 0);
		keypad_key_pressed : IN std_logic;
		keypad_output_ready : IN std_logic;
		clear : IN std_logic;          
		poller_output : OUT std_logic_vector(3 downto 0);
		output_ready : OUT std_logic
		);
	END COMPONENT;
	
	signal refresh_signal : STD_LOGIC;
	
	signal keypad_output : STD_LOGIC_VECTOR(3 downto 0);
	signal keypad_key_pressed : STD_LOGIC;
	signal keypad_output_ready : STD_LOGIC;
	
begin
	Inst_keypad_clock_divider: keypad_clock_divider PORT MAP(
		clk => clk,
		clk_slow => refresh_signal
	);
	
	Inst_keypad_decoder: keypad_decoder PORT MAP(
		clk => refresh_signal,
		row_pins => row_pins,
		column_pins => column_pins,
		output => keypad_output,
		output_ready => keypad_output_ready,
		key_pressed => keypad_key_pressed,
		reset => reset
	);
	
	Inst_keypad_poller: keypad_poller PORT MAP(
		clk => refresh_signal,
		reset => reset,
		key_pressed_in => keypad_output,
		keypad_key_pressed => keypad_key_pressed,
		keypad_output_ready => keypad_output_ready,
		clear => clear,
		poller_output => output,
		output_ready => output_ready
	);

end Behavioral;

