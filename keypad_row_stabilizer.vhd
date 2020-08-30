----------------------------------------------------------------------------------
-- 2-stage synchronizer for a keypad row
-- see https://stackoverflow.com/questions/45164644/how-to-count-pressed-keys-on-fpga-spartan-board/45165202
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity keypad_row_synchronizer is
    Port ( clk : in  STD_LOGIC;
           row_pins_async : in  STD_LOGIC_VECTOR (3 downto 0);
           row_out_sync : out  STD_LOGIC_VECTOR (3 downto 0));
end keypad_row_synchronizer;

architecture Behavioral of keypad_row_synchronizer is
	signal reg0 : STD_LOGIC_VECTOR(3 downto 0);
	signal reg1 : STD_LOGIC_VECTOR(3 downto 0);
begin
	process(clk) 
	begin
		reg1 <= reg0;
		reg0 <= row_pins_async;
	end process;
	-- connect the output to the last register
	row_out_sync <= reg1;
end Behavioral;

