----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity keypad_clock_divider is
    Port ( clk : in  STD_LOGIC; -- 12 MHz clock
           clk_slow : out  STD_LOGIC); --12,000,000 Hz / 16,384 = 732 Hz
end keypad_clock_divider;

architecture Behavioral of keypad_clock_divider is
signal clk_refresh_counter : unsigned (13 downto 0); --14-bit counter (16384)
begin
process(clk)
begin
	if rising_edge(clk) then
		clk_refresh_counter <= clk_refresh_counter + 1;
		if(clk_refresh_counter = 0) then
			clk_slow <= '1';
		else
			clk_slow <= '0';
		end if;
	end if;
end process;

end Behavioral;

